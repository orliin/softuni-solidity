pragma solidity 0.4.20;

library SafeMath {
    
    int256 constant public MIN_VALUE = int256((uint256(1) << 255));
    int256 constant public MAX_VALUE = int256(~((uint256(1) << 255)));
    
    function add(int256 a, int256 b) pure public returns(int256) {
        int256 result = a+b;
        if(b<0) {
            require(result < a);
        } else {
            require(result >= a);
        }
        return result;
    }
    
    function subtract(int256 a, int256 b) pure public returns(int256) {
        return add(a, -b);
    }
    
    function multiply(int256 a, int256 b) pure public returns(int256) {
        if(a==0 || b==0 || a==1 || b==1) {
            return a*b;
        }
        if(a==MIN_VALUE || b==MIN_VALUE) {
            revert();
        }
        if(b<0) {
            a=-a;
            b=-b;
        }
        int256 result = 0;
        while(b>0) {
            if(b%2==1) {
                result = add(result, a);
            }
            b/=2;
            if(b>0){
                a = add(a,a);
            }
        }
        return result;
    }
}

contract Owned {
    
    address private owner;
    
    modifier onlyOwner {
        require(owner == msg.sender);
        _;
    }
    
    function Owned() public {
        owner = msg.sender;
    }
    
    function newOwner(address newAddress) onlyOwner public {
        owner = newAddress;
    }
}

contract OwnedSafeMath is Owned {
    using SafeMath for int256;
    int256 public state;
    uint256 public lastChange = 1;
    
    function change() onlyOwner public {
        state = state.add(int256(now) % 256);
        state = state.multiply(int256(now).subtract(int256(lastChange)));
        state = state.subtract(int256(block.gaslimit));
        
        lastChange = now;
    }
    
}