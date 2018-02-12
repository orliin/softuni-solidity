pragma solidity ^0.4.18;

contract Math {
    
    int256 private firstNumber;
    
    function Math() public {
        firstNumber = 0;
    }
    
    function GetFirstNumber() public returns (int256) {
        return firstNumber;
    }
    
    function ResetFirstNumber() public {
        firstNumber = 0;
    }
    
    function Add(int248 _secondNumber) public {
        firstNumber += _secondNumber;
    }
    
    function Substract(int256 _secondNumber) public {
        firstNumber -= _secondNumber;
    }
    
    function Multiply(int128 _secondNumber) public {
        firstNumber *= _secondNumber;
    }
    
    function Divide(int256 _secondNumber) public {
        require(_secondNumber != 0);
        firstNumber /= _secondNumber;
    }
    
    function Raise(uint16 _secondNumber) public {
        firstNumber = uint16(firstNumber) ** _secondNumber;
    }
    
    function Modulo(int256 _secondNumber) public returns (int256) {
        firstNumber = firstNumber % _secondNumber;
    }
}