pragma solidity 0.4.19;

contract OwnedContract {
    
    address owner;
    
    event OwnerChange(address indexed previousOwner, address indexed newOwner);
    
    function OwnedContract() public {
        owner = msg.sender;
    }
    
    function update_owner(address newOwner) public returns(address){
        if(msg.sender == owner) {
            OwnerChange(owner, newOwner);
            owner = newOwner;
        }
        return owner;
    }
}