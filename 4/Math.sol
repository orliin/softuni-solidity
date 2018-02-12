pragma solidity 0.4.19;

contract Math {
    
    function add(uint256 _a, uint256 _b) pure public returns(uint256) {
        return _a + _b;
    }
    function subtract(uint256 _a, uint256 _b) pure public returns(uint256) {
        return _a - _b;
    }
    function multiply(uint256 _a, uint256 _b) pure public returns(uint256) {
        return _a * _b;
    }
    function divide(uint256 _a, uint256 _b) pure public returns(uint256) {
        return _a / _b;
    }
    function power(uint256 _a, uint256 _b) pure public returns(uint256) {
        return _a ** _b;
    }
    function power_costly(uint256 _base, uint256 _power) pure public returns(uint256) {
        uint256 result = 1;
        while(_power > 0) {
            if(_power % 2 == 0) {
                _power = _power / 2;
                _base = _base * _base;
            } else {
                _power = _power - 1;
                result = result * _base;
    
                _power = _power / 2;
                _base = _base * _base;
            }
        }
        return result;
    }
    
    function module(uint256 _a, uint256 _b) pure public returns(uint256) {
        return _a % _b;
    }
    
}