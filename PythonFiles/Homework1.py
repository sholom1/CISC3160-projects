from math import sqrt
def TrabbPardoKnuth(S):
    for e in reversed(S):
        result = sqrt(abs(e)) + 5 * e
        if result > 500:
            print ("Error: incorrect sequence")
            break
        else:
            print (result)

def main():
    inputList = []
    print("Input 11 numbers:")
    for i in range(0, 11):
        val = ""
        while not val.isnumeric():
            val = input()
        inputList.append(int(val))
    TrabbPardoKnuth(inputList)

if __name__ == "__main__":
    main()