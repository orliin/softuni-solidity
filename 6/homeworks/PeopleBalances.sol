pragma solidity ^0.4.20;

contract PeopleBalances{
    address private owner;
    uint private startTime=now;
    address[] private tokoenHolders;
    mapping(address=>TokenHolderInfo) private tokenHolderBalances;
    uint private tokenPriceInWei=1 ether / 5;
    States private state=States.Crowdsale;
    
    enum States{
        Crowdsale,
        Open
    }
    
     struct TokenHolderInfo {
        uint balance;
        bool exiting;
    }
    
    event ExhangeDone(address indexed by, uint transferredWei);
    event NotEnoughtValueInContractForExchange(address indexed by);
    event TokenBought(address indexed by, uint numberOfTokens);
      event NewUser(address indexed by);
    
    modifier validateState
    {
        if(now>startTime + 5 minutes){
            state=States.Open;            
        }
        _;
    }
    
    modifier withdrawLock{
        require(now > startTime + 1 years);
        _;
    }
    
     modifier onlyOwner{
        require(msg.sender == owner);
        _;
    }
    
    function PeopleBalances() public{
        owner=msg.sender;
    }
    
    function buyTokens(uint numberOfTokens) public payable validateState{ 
        require(state==States.Crowdsale);
        require(numberOfTokens*tokenPriceInWei<=msg.value); 
        
        if(tokenHolderBalances[msg.sender].exiting==false){
            tokoenHolders.push(msg.sender);
        }
        
        tokenHolderBalances[msg.sender]=TokenHolderInfo({balance:tokenHolderBalances[msg.sender].balance+numberOfTokens, exiting:true});
        
        uint amountToReturn = msg.value - (numberOfTokens*tokenPriceInWei);
        if(amountToReturn > 0){
            msg.sender.transfer(amountToReturn); 
        }
        
        TokenBought(msg.sender,numberOfTokens); 
    }
    
    function withdraw(uint value) public withdrawLock onlyOwner {
        require(this.balance >= value);
        owner.transfer(value);
    }
    
    function exchangeTokens(uint tokensToExchange) public validateState  {
        require(state==States.Open);
        require(tokenHolderBalances[msg.sender].balance>=tokensToExchange);
        
        uint amountWeiForExchange=tokensToExchange*tokenPriceInWei;
        if(this.balance>=amountWeiForExchange)
        {
            msg.sender.transfer(amountWeiForExchange);
            tokenHolderBalances[msg.sender].balance-=tokensToExchange;
            ExhangeDone(msg.sender, amountWeiForExchange);
        }
        else
        {
            NotEnoughtValueInContractForExchange(msg.sender);
        }
     
    }
    
    function getTokenHolders() public view returns(address[]){ 
       return tokoenHolders;
    }
    
    function getPeopleWithBalancesCount() public view returns(uint)
    {
        return tokoenHolders.length;
    }
    
    
}