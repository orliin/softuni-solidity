pragma solidity 0.4.19;

contract MathNumber {
    
    int256 number = 0;
    
    function reset_number() public {
        number = 0;
    }
    function set_number(int256 _number) public {
        number = _number;
    }
    function get_number() view public returns(int256) {
        return number;
    }
    
    function add(int256 _a) public {
        number += _a;
    }
    function subtract(int256 _a) public {
        number -= _a;
    }
    function multiply(int256 _a) public {
        number *= _a;
    }
    function divide(int256 _a) public {
        number /= _a;
    }
    function power(uint256 _a) public {
        int8 sign = 1;
        if(number < 0) {
            number = -number;
            if(_a %2 == 1) sign = -1;
        }
        number = int256(uint256(number)**_a) * sign;
    }
    function module(uint256 _a) public {
        if (number > 0) {
            number = int256(uint256(number)%_a);
        } else {
            number = int256(_a - uint256(-number)%_a);
        }
    }
    
}