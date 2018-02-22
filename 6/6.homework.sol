pragma solidity 0.4.20;

contract Otoken {
    
    enum State { Crowdsale, Open }
    
    struct Holder {
        bool heldTokens;
        uint256 balance;
    }
    
    address public owner;
    uint256 public contractCreated;
    State public currentState;
    mapping(address => Holder) public balances;
    address[] public holders;
    
    modifier StateCrowdsale {
        updateState();
        require(currentState == State.Crowdsale);
        _;
    }
    modifier StateOpen {
        updateState();
        require(currentState == State.Open);
        _;
    }
    
    function Otoken() public {
        owner = msg.sender;
        contractCreated = now;
        currentState = State.Crowdsale;
    }
    
    function updateState() private {
        if(currentState == State.Crowdsale && contractCreated + 5 minutes <= now) {
            currentState = State.Open;
        }
    }
    
    function topUp(uint256 amount, address receiver) private {
        require(amount > 0);
        if(balances[receiver].heldTokens == false) {
            holders.push(receiver);
            balances[receiver].heldTokens = true;
        }
        balances[receiver].balance += amount;
    }
    
    function buy() StateCrowdsale payable public {
        topUp(msg.value * 5, msg.sender);
    }
    
    function withdraw() public {
        require(msg.sender == owner);
        require(contractCreated + 1 years <= now);
        
        msg.sender.transfer(this.balance);
    }
    
    function transfer(uint256 amount, address receiver) StateOpen public {
        require(balances[msg.sender].balance >= amount);
        
        topUp(amount, receiver);
        balances[msg.sender].balance -= amount;
    }
}