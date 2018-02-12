pragma solidity 0.4.19;

contract OwnedContract {
    
    uint256 state;
    address owner;
    uint256 last_increment;
    
    event Incremented(uint256 timestamp, uint256 state);
    
    function OwnedContract(uint256 _state) public {
        owner = msg.sender;
        state = _state;
        last_increment = 0;
    }
    
    function increment(uint256 _increment) public returns(uint256){
        if(msg.sender == owner && now > last_increment + 15 seconds) {
            state += _increment;
            last_increment = now;
            Incremented(last_increment, state);
        }
        return state;
    }
}