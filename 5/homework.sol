pragma solidity 0.4.19;

contract Service {
    
    address private owner;
    uint256 private lastServicePaid;
    uint256 private lastWithdrawal;
    
    function Service() public {
        owner = msg.sender;
        lastServicePaid = 0;
        lastWithdrawal = 0;
    }
    
    modifier TwoMinutePeriod {
        require(now >= lastServicePaid + 2 minutes);
        _;
    }
    
    modifier OneHourPeriod {
        require(now >= lastWithdrawal + 1 hours);
        _;
    }
    
    modifier OnlyOwner {
        require(msg.sender == owner);
        _;
    }
    
    
    event ServicePaid(uint256 time, address buyer);
    
    function buyService() TwoMinutePeriod payable public {
        uint256 returnAmount = msg.value;
        
        // If transferred value is greater or equal to 1 ether, take 1 ether and provide service
        if(msg.value >= 1) {
            returnAmount -= 1 ether;
            lastServicePaid = now;
            ServicePaid(lastServicePaid, msg.sender);
        }
        
        // If transferred value is not equal to 1 ether, then return the difference to sender
        msg.sender.transfer(returnAmount);
    }
    
    function withdrawAmount(uint256 amount) OnlyOwner OneHourPeriod public {
        
        if(amount <= 5 ether && amount <= this.balance) {
            lastWithdrawal = now;
            owner.transfer(amount);    
        }
        
    }
    
    function withdraw() OnlyOwner OneHourPeriod public {
        if(this.balance > 5 ether) {
            lastWithdrawal = now;
            owner.transfer(5 ether);
        } else {
            lastWithdrawal = now;
            owner.transfer(this.balance);
        }
    }
    
}