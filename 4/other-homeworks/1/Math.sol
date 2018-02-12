pragma solidity ^0.4.19;

contract Math {
    int256 n1;
 
    function Math () public {
        n1 = 0;
    }
    
    function add(int256 _n2) public returns (int256) {
        n1 += _n2;
        return n1;
    }
    function substract(int256 _n2) public returns (int256) {
        n1 -= _n2;
        return n1;
    }
    function divide(int256 _n2) public returns (int256) {
        n1 /= _n2;
        return n1;
    }
    function multiply(int256 _n2) public returns (int256) {
        n1 *= _n2;
        return n1;
    }
    
    function pow(uint256 _n2) public returns (int256) {
        
        int fixNeg = 1;
        
        if (n1 < 0 && (_n2 % 2 == 0)) {
            fixNeg = -1;
        }
        
        n1 = int256(uint(n1)** uint(_n2))*fixNeg;

        return n1;
    }
    
    function remainder(int256 _n2) public returns (int256) {
        n1 %= _n2;
        return n1;
    }
    
    function getState() public returns (int256) {
        return n1;
    }
    
    function resetState() public returns (int256) {
        n1 = 0;
        return n1;
    }
}