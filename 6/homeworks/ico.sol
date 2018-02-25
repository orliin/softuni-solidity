pragma solidity ^0.4.20;

contract ICO {
    address owner;
    uint saleStart;
    uint saleEnd;
    mapping(address => uint) public balances;
    mapping(address => bool) public holders;
    address[] public allTokenHoldersEver;
    
    function ICO(address _owner) public {
        owner = _owner;
        saleStart = now;
        saleEnd = now + 5 minutes;
    }
    
    modifier saleActive() {
        require(now >= saleStart && now <= saleEnd);
        _;
    }
    
    modifier saleInactive() {
        require(now > saleEnd);
        _;
    }
    
    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }
    
    function() public payable saleActive {
        require(msg.value >= 0.2 ether);
        uint tokens = msg.value * 5 / 1 ether;
        if(tokens > 0) {
            balances[msg.sender] += tokens;
            holders[msg.sender] = true;
            if(!inArray(msg.sender)) {
                allTokenHoldersEver.push(msg.sender);
            }
        }
    }
    
    function sendTokens(address _receiver, uint _tokens) public saleInactive {
        uint oldBalance = balances[msg.sender];
        require(balances[msg.sender] >= _tokens);
        balances[msg.sender] -= _tokens;
        balances[_receiver] += _tokens;
        holders[_receiver] = true;
        if(!inArray(_receiver)) {
            allTokenHoldersEver.push(_receiver);
        }
        assert(balances[msg.sender] == oldBalance - _tokens);
    }
    
    function ownerWithdraw(uint howMuch) public onlyOwner saleInactive {
        require(now > saleStart + 1 years);
        require(howMuch <= this.balance);
        owner.transfer(howMuch);
    }
    
    function inArray(address _address) public view returns(bool) {
        bool rtn = false;
        for(uint i = 0; i < allTokenHoldersEver.length; i++) {
            if(allTokenHoldersEver[i] == _address) {
                rtn = true;
                break;
            }
        }
        return rtn;
    }
}
