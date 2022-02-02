using System;
using System.collections;

class Homework1
{
    public static void main(String args[]){
        
    }
    public static void TrabbPardoKnuth(List<int> sequence){
        for (int i = sequence.Count(); i > 0; i--){
            float result = Math.sqrt(abs(sequence[i])) + 5 * sequence[i];
            if (result > 500){
                throw new InvalidArgumentException("Sequence is incorrect");
            }else{
                Console.WriteLine(result);
            }
        }
    }
}