pragma solidity ^0.4.19;

contract simpleToken{
    mapping (address => uint) public balanceOf; //automatic generates getter for 
    //this variable and we can see it.
    
    mapping (address => bool) public HolderCheck;  // mapping to check if the holder has tokens
    
    enum State{Crowdsale, Open}
    State public currentState;
    State constant defaultState = State.Crowdsale;
    
    
    address private owner;
    uint timeInitialSale;
    bool private firstCallOfFunction = true;
    
    modifier onlyOwner{
        require(msg.sender == owner);
        _;
    }
    
    modifier timeToWithdraw(){
        require(now - timeInitialSale >  1 years );  
        _;
    }
    
    modifier timeToOpenState(){
        require(currentState == defaultState);  
        
      _;
    }
    

    function() public payable timeToOpenState{ //fallback function for recieving ethers from other accounts
        address buyer = msg.sender;
        //require(currentState == defaultState);
        
        if(now - timeInitialSale <  1 minutes){
            
        require(HolderCheck[buyer] != true); // check if the buyer has tokens. If 
        //so, it is not allowed to buy again
        
        require(address(this).balance != 0); // checks if there is money input
       
        balanceOf[this] -= msg.value / 5;
        balanceOf[buyer] += msg.value / 5;
            
        HolderCheck[buyer] = true; // sets the checker to true after his first supply
      
            
        }
        else{
            currentState = State.Open;
        }
        
        
    } 
    
    function openTransfer(address from, address to, uint amount) public {
        require(currentState == State.Open);
        
        to.transfer(amount);
        balanceOf[from] += amount * 5;
        balanceOf[to] -= amount * 5;
        
    }
    
    function simpleToken() public payable{ //constructor
        owner = msg.sender;
        timeInitialSale = now;
        
    }
    
    function initialSupply(uint _initialSupply) onlyOwner public payable  { //initial 
    //token supply can be called only by the owner and emitted tokens go to his 
    //account
        
        require(firstCallOfFunction == true); //checks if this is the first call 
        //of the function for initial supply

        balanceOf[this] += _initialSupply; //contract gets the initial supply

        timeInitialSale = now; // sets the time ot the initial sale

        firstCallOfFunction = false; // change the state of variable to false after first 
        //call of the function. In this way the function cannot be called any more
    }

    function getContractBallance() public view returns(uint){
        return address(this).balance;
    }
    
    function withdraw() public onlyOwner timeToWithdraw{ // withdraw function for 
    //the ethers in the contract
        uint amount = this.balance;
        owner.transfer(amount);
    }

    
}