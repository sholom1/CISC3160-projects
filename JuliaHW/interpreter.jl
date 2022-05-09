variableMemory = Dict{String, Int}()
function syntaxError(message)
    return ErrorException("Syntax Error: $message")
end
#Match 0|1|...|9
function isDigit(A, i)
    return contains("0123456789", A[i])
end
#Match 1|...|9
function isNonZeroDigit(A, i)
    return contains("123456789", A[i])
end
#Match 0 | NonZeroDigit Digit*
function Litteral(A, start)
    if (A[start] == '0')
        #First case should error out if there are following digits
        if (isDigit(A, start+1)) throw(syntaxError("Literals cannot start with 0. Found $(A[start:end])")) end
        return 0 
    end
    #Checks if not zero and if is a valid number
    if (isNonZeroDigit(A, start))
        lastDigit = start
        index = start + 1
        #Iterate until reaching the last digit, incrementing the counter each iteration
        while index <= length(A) && isDigit(A, index) 
            lastDigit = index
            index += 1
        end
        return parse(Int64, A[start:lastDigit])
    end
    throw(syntaxError("Expected literal found: $(A[start:end])"))
end
#Matches a|...|z|A|...|Z|_ uses char codes
function isLetter(A, i)
    code, a, z, A, Z = Int(A[i]), 97, 122, 65, 90
    return A <= code <= Z || code == 95 || a <= code <= z
end
#Matches Letter [Letter|Digit]*
function IdentifierName(A, start)
    #If it does not start with a letter throw syntax error
    if (!isLetter(A, start)) throw(syntaxError("Identifier names must start with a letter. Found $(A[start:end])")) end
    #Iterate until last valid character is found
    index = start
    while index < length(A) && (isLetter(A, index) || isDigit(A, index))
        index += 1
    end
    #strip excess whitespace
    return strip(A[start:index])
end
function skipWhiteSpace(A, start)
    index = start
    while index < length(A) && A[index] == ' '
        index += 1
    end
    return index
end
#Matches and recureses for ( Exp ) | - Fact | + Fact | Literal | Identifier
function Factor(A, start)
    if (A[start] == '(')
        #If surrounded by parenthesis find bounds and recurse to Expression
        start = skipWhiteSpace(A, start + 1)
        closing = findfirst(isequal(')'), A[start:end]) + start - 2
        return Exp(A[start:closing], 1)
    end
    if A[start] == '+'
        #Case with unary plus operator return the operator and it's recursed value
        start = skipWhiteSpace(A, start + 1)
        return +Factor(A, start)
    end
    if A[start] == '-'
        #Case with unary minus operator return the operator and it's recursed value
        start = skipWhiteSpace(A, start + 1)
        return -Factor(A, start)
    end
    #Matches a digit and returns a litteral
    if (isDigit(A, start))
        return Litteral(A, start)
    end
    #Finally it must be a identifier so get the name and return it's value
    if (isLetter(A, start))
        indetifier = IdentifierName(A, start)
        return get(variableMemory, indetifier) do 
            throw("Unassigned Variable exception") #If the value doesn't exist throw Unassigned error
        end
    end
    #If all cases fail throw an expected factor error
    throw(syntaxError("Expected factor found: $(A[start:end])"))
end
#Matches Term * Fact | Fact
function Term(A, start)
    pivot = findlast(isequal('*'), A)
    if pivot !== nothing
        return Term(A[start:pivot-1], 1) * Factor(A, skipWhiteSpace(A, pivot + 1))
    end
    return Factor(A, start)
end
#Matches 
function Exp(A, start)
    if contains(A, "*")
        return Term(A, start) #If it contains a multiplicative operator match for a term
    end
    #If it contains a plus operator with 2 operands apply and recurse
    pivot = findlast(isequal('+'), A)
    if pivot !== nothing
        return Exp(A[start:pivot-1], 1) + Term(A, skipWhiteSpace(A, pivot + 1))
    end
    #If it contains a minus operator with 2 operands apply and recurse
    pivot = findlast(isequal('-'), A)
    if pivot !== nothing
        return Exp(A[start:pivot-1], 1) - Term(A, skipWhiteSpace(A, pivot + 1))
    end
    #Else recurse for term factor
    Term(A, start)
end
#Matches Identifier = Exp;
function Assignment(A)
    pivot = findfirst(isequal('='), A)
    endl = findlast(isequal(';'), A)
    if pivot !== nothing !== endl
        #If contains supporting characters get the identifier name and evaluate expression value
        identifier = IdentifierName(A[1:pivot-1], 1)
        variableMemory[identifier] = Exp(A[skipWhiteSpace(A,pivot+1):endl-1], 1)
    elseif pivot === nothing
        #If equals sign is missing throw error
        throw(syntaxError("Invalid assignment: expected assignment operator found $A"))
    else
        #If semicolon is missing throw error
        throw(syntaxError("Invalid statement expected end of line character ';' not found $A"))
    end
end
#Takes a single line string and Interperet the program
function Interperet(A)
    A = strip(A)
    endoflastassignment = 1
    for (index, c) in enumerate(A)
        if c === ';'
            Assignment(A[endoflastassignment:index])
            endoflastassignment = index + 1
        end
    end
    #Checks if there are any trailing statements that were not evaluated
    if endoflastassignment < length(A)
        throw(syntaxError("Invalid statement expected end of line character ';' not found $(A[endoflastassignment:end])"))
    end
    #Print final key/values
    for (key, val) in variableMemory
        println("$key = $val")
    end
end
#driver code to load and start interpreter
open(file->Interperet(join(readlines(file))),"input.txt")