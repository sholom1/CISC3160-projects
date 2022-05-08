using  Dates
function spherevolume(r)
    return 4/3*pi*r^3
end
function quadraticequation(a,b,c)
    d = sqrt(b*b-4*a*c)
    r1 = (-b+d)/(2*a)
    r2 = (-b-d)/(2*a)
    return [r1,r2]
end
function numberofzeroes(list)
    count = 0
    for x in list
        if(x==0)
            count += 1
        end
    end
    return count
end
bcMemory = Dict()
function binomialcoefficient(n, k)
    if (n == k || k == 0) return 1 end
    if (haskey(bcMemory, [n,k])) return bcMemory[[n,k]] end
    val = binomialcoefficient(n-1, k-1) + binomialcoefficient(n-1, k)
    bcMemory[[n,k]] = val
    return val
end
function removeconsecutivedups(arr)
    result = []
    for (index, val) in enumerate(arr)
        if (index == 1) push!(result, val) end
        if (index > 1 && arr[index-1] != val)
            push!(result, val)
        end
    end
    return result
end
function drawpascal(n)
    for row in 0:n
        for column in 0:row
            print("$(binomialcoefficient(row, column)) ")
        end
        println()
    end
end
function days(dt1, dt2)
    return dt1-dt2
end
function euler()
    n = sqrt(19293949596979899)
    function match(val)
        s = string(val)
        return occursin(r"1\d2\d3\d4\d5\d6\d7\d8\d9\d0", s)
    end
    while !match(n*n)
        n -= 2
    end
    return n * 10
end
function removedups(list)
    set = Set(list)
    return collect(set)
end
function replicate(list, n)
    result = Array{Int64}(undef, n * length(list))
    for (index, val) in enumerate(list), i in 1:n
        setindex!(result, val, ((index - 1) * n) + i)
    end
    return result
end
function split(list, n)
    return [list[1:n], list[n+1:length(list)]]
end
function minmaxmedian(list)
    sort!(list)
    len = length(list)
    median = len % 2 == 0 ? (list[Int(floor(len/2))] + list[Int(floor(1+len/2))])/2 : list[Int(floor(len/2))]
    return [list[1], median, list[length(list)]]
end
function maxcrosssum(A, low, mid, high)
    sum = 0
    lsum = typemin(Int64)
    for i in mid:-1:low
        sum += A[i]
        if (sum > lsum)
            lsum = sum
        end
    end
    sum = 0
    rsum = typemin(Int64)
    for i in mid+1:high
        sum += A[i]
        if (sum > rsum)
            rsum = sum
        end
    end
    return lsum + rsum
end
function maxsubarray(A, Low, High)
    if (Low == High) return A[Low] end
    mid = Int(floor((Low + High) / 2))
    leftsum = maxsubarray(A, Low, mid)
    rightsum = maxsubarray(A, mid + 1, High)
    crosssum = maxcrosssum(A, Low, mid, High)
    return max(leftsum, rightsum, crosssum)
end
function maxsubarray(A)
    return maxsubarray(A, 1, length(A))
end
println(spherevolume(5))
println(quadraticequation(1,5,2))
println(numberofzeroes([1,0,2,0]))
println(binomialcoefficient(10, 5))
println(removeconsecutivedups([1, 1, 2, 2, 3, 3, 3, 5, 6, 7]))
drawpascal(10)
println(days(Date(2022,5,6), Date(2001,9,25)))
# println(euler())
println(removedups(['a','a','a','a','b','c','c','a','a','d','e','e','e','e']))
println(replicate([1,2,3], 3))
println(split([1,2,3,4], 2))
println(minmaxmedian([3,5,6,2]))
println(maxsubarray([1,-10,2,4,8,-10]))