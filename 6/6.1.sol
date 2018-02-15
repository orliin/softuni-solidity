pragma solidity 0.4.19;

contract LockableTimestamp {
    
    enum States { Locked, Unlocked, Restricted}
    struct Timestamp {
        uint256 counter;
        uint256 time;
        address caller;
    }
    
    modifier Restrict(States currentState) {
        if(currentState == States.Locked) {
            require(false);
        } else if(currentState == States.Restricted) {
            require(msg.sender == owner);
        }
        _;
    }
    
    address private owner;
    Timestamp public timestamp;
    States public state = States.Locked;
    
    function LockableTimestamp() public {
        owner = msg.sender;
        timestamp = Timestamp(0, now, owner);
    }
    
    function setState(States newState) Restrict(States.Restricted) public {
        state = newState;
    }
    
    function newTimestamp() Restrict(state) public {
        timestamp.counter++;
        timestamp.time = now;
        timestamp.caller = msg.sender;
    }
    
}