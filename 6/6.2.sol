pragma solidity 0.4.19;

contract GroupProposal {
    
    address[] public owners;
    Proposal public currentProposal;
    uint256 public currentTime;
    uint256 public currentOwner;
    
    struct Proposal {
        address receiver;
        uint256 amount;
    }
    
    modifier OnlyOwners() {
        for(uint256 i = 0; i<owners.length; i++) {
            if(msg.sender == owners[i]) {
                _;
            }
        }
        revert();
    }
    
    modifier FiveMinutes() {
        if(currentTime + 5 minutes >= now) {
            _;
        } else {
            currentOwner = 0;
        }
    }
    
    function GroupProposal(address[] _owners) public {
        owners = _owners;
        currentProposal = Proposal(0,0);
        currentTime = 0;
        currentOwner = 0;
    }
    
    function() public payable {}
    
    function makeProposal(address receiver, uint256 amount) OnlyOwners public {
        require(currentOwner == 0);
        currentProposal = Proposal(receiver, amount);
        currentTime = now;
        currentOwner = 1;
    }
    
    function accept() FiveMinutes public {
        require(currentOwner>=1 && currentOwner < owners.length);
        require(msg.sender == owners[currentOwner-1]);
        currentOwner++;
        if(currentOwner == owners.length+1 && this.balance >= currentProposal.amount) {
            currentProposal.receiver.transfer(currentProposal.amount);
            currentOwner = 0;
        }
    }
}