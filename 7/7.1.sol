pragma solidity 0.4.20;

contract Agent {
    
    uint256 workStartTime;
    address owner;
    
    modifier OnlyOwner {
        require(msg.sender == owner);
        _;
    }
    
    function Agent() public {
        owner = msg.sender;
    }
    
    function startWork() OnlyOwner public {
        workStartTime = now;
    }
    
    function workFinished() OnlyOwner view public returns(bool) {
        require(workStartTime!=0);
        
        return workStartTime + 15 seconds <= now;
    }
}

contract Master {
    
    address owner;
    
    mapping(address => bool) public approved;
    
    modifier OnlyOwner {
        require(msg.sender == owner);
        _;
    }
    
    function Master() public {
        owner = msg.sender;
    }
    
    function createAgent() public returns(Agent){
        Agent newAgent = new Agent();
        approved[newAgent] = true;
        return newAgent;
    }
    
    function addAgent(Agent agent) OnlyOwner public {
        approved[agent] = true;
    }
    
    function callAgent(Agent agent) OnlyOwner public {
        require(approved[agent]);
        agent.startWork();
    }
    
    function checkAgent(Agent agent) OnlyOwner view public returns(bool){
        require(approved[agent]);
        return agent.workFinished();
    }
}