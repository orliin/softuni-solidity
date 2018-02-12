pragma solidity 0.4.19;

contract Transfer {
    
    
    address private owner;
    uint256 private sendAmount;
    bool private isActive;

    modifier OnlyOwner {
        require(msg.sender == owner);
        _;
    }
    
    modifier AmountAvailable(uint256 amount) {
        require(this.balance >= amount);
        _;
    }
    
    modifier Active {
        require(isActive);
        _;
    }
    
    // Creates an event for every withdrawal
    event Withdrawal(uint256 timestamp, uint256 withdrawalAmount, address receiver);
    
    // Is owned
    // Has a state variable sendAmount with initial value 1 ETH
    function Transfer() public {
        owner = msg.sender;
        sendAmount = 1 ether;
        isActive = true;
    }
    
    // Can receive plain ETH payments from anyone
    function() Active payable public;
    
    // Has method to get its balance
    function getBalance() Active view public returns(uint256){
        return this.balance;
    }
    
    // The value of sendAmount can be changed by the owner
    function setSendAmount(uint256 newSendAmount) Active OnlyOwner public {
        sendAmount = newSendAmount;
    }
    
    // Has method to withdraw sendAmount of money for free, publicly (if available)
    function withdraw() Active AmountAvailable(sendAmount) public {
        msg.sender.transfer(sendAmount);
        Withdrawal(now, sendAmount, msg.sender);
    }
    
    // Has method to send sendAmount of money to someone else for free
    function send(address receiver) Active AmountAvailable(sendAmount) public {
        receiver.transfer(sendAmount);
        Withdrawal(now, sendAmount, receiver);
    }
    
    // The owner can withdraw as much as he wants
    function withdrawAmount(uint256 amount) Active OnlyOwner AmountAvailable(amount) public {
        assert(msg.sender == owner);
        owner.transfer(amount);
        Withdrawal(now, amount, owner);
    }
    
    // Can be destroyed by the owner
    function destroy() Active OnlyOwner public {
        isActive = false;
    }
}