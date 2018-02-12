pragma solidity ^0.4.18;


contract MathFunc{
    
    int first;
    
    function MathFunc() public{
        first=0;
    }
    
    function pow(uint _second)public {

        bool isFirstNegative= first<0 ;
        uint tempFirst=isFirstNegative?uint(first*-1):uint(first);
       
        tempFirst=tempFirst**_second;
        
        if(isFirstNegative && _second%2==1)
        {
            first=int(tempFirst)*-1;
        }
        else
        {
            first=int(tempFirst);
        }
    }
    
    function sum(int _second)public {

         first+=_second;
    }
    
    function substract(int _second)public {

         first-=_second;
    }
    
    function divide(int _second)public {

         first/=_second;
    }
    
    function reminder(int _second)public {

         first%=_second;
    }
    
    
    function multiply(int _second)public {

         first*=_second;
    }
   
    function getState()public returns(int) {

        return first;
    }
    function resetState()public {

         first=0;
    }
}
