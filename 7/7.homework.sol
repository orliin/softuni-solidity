pragma solidity 0.4.20;

// TODO: add log message when new members are added and members removed 
//       add log message when poll is started
// TODO: check public/private functions
// TODO: change polls so that members are removed correctly:
//       There needs to be a map for every poll, showing who already voted.

library MemberLibrary {
    struct Member {
        uint256 weiDonated;
        uint256 lastDonationTime;
        uint256 lastDonationValue;
        bool isMember;
    }
    
    struct Data {
        mapping (address => MemberLibrary.Member) members; // member address maps to member's data
        uint256 memberCount; // total number of members
    }
    
    function addMember(Data storage self, address member) public {
        require(!self.members[member].isMember); // cannot add a member twice
        
        self.members[member].isMember = true;
        self.memberCount++;
    }
    
    function removeMember(Data storage self, address member) public {
        require(self.members[member].isMember); // cannot remove if not a member
        assert(self.memberCount>0); // if there are members to remove, count should be >0
        
        self.members[member].isMember = false;
        self.memberCount--;
    }
    
    function isMember(Data storage self, address member) view public returns(bool) {
        return self.members[member].isMember;
    }
    
    function makeDonation(Data storage self, address member, uint256 value) public {
        self.members[member].lastDonationValue = value;
        self.members[member].lastDonationTime = now;
    }
    
}

library PollLibrary {
    struct Poll {
        mapping (address => bool) voted; // who voted already
        uint256 voteCount;
        uint256 numberOfVotesRequired;
        bool isRunning;
        bool pollResult;
        uint256 pollEndTime;
    }
    
    struct Data {
        mapping (address => PollLibrary.Poll) polls; // member address maps to poll about the member
        uint256 pollCount; // total number running polls
        uint256 pollLengthLimit; // a limit for the length of new polls
    }
    
    // I add modifier because I need to change the isRunning cariable and then rollback the rest
    // If I change and then rollback, the change in the variable will be also rolled back
    // I hope this will do the trick, but I doubt :)
    modifier checkVoteExpired(Data storage self, address candidate) {
        if(self.polls[candidate].pollEndTime < now) {
            stopPoll(self, candidate);
        }
        _;
    }
    
    function startPoll(Data storage self, 
                        address candidate, 
                        uint256 pollLength,
                        uint256 _numberOfVotesRequired) public {
        require(!self.polls[candidate].isRunning); // cannot start a poll if there is already a poll
        
        // We need to set all fields to default in case this candidate had other polls in the past
        self.polls[candidate] = Poll({
            voteCount: 0,
            numberOfVotesRequired: _numberOfVotesRequired,
            isRunning: true,
            pollResult: false,
            pollEndTime: now + pollLength
        });
        // self.polls[candidate].numberOfVotesRequired = _numberOfVotesRequired;
        // self.polls[candidate].isRunning = true;
        // self.polls[candidate].pollEndTime = now + pollLength;
    }
    
    function stopPoll(Data storage self, address candidate) private {
        require(self.polls[candidate].isRunning);
        assert(self.pollCount>0);
        
        self.polls[candidate].isRunning = false;
        self.pollCount--;
    }
    
    function vote(Data storage self, address candidate) checkVoteExpired(self, candidate) public {
        require(self.polls[candidate].isRunning); // the poll should be started
        require(!self.polls[candidate].voted[msg.sender]); // the voter should not have voted already
        
        self.polls[candidate].voted[msg.sender] = true;
        self.polls[candidate].voteCount++;
        
        // if the required number of voters is reached, the poll finishes with success
        if(self.polls[candidate].voteCount >= self.polls[candidate].numberOfVotesRequired) {
            self.polls[candidate].pollResult = true;
            stopPoll(self, candidate);
        }
    }
    
    function pollSuccessful(Data storage self, address candidate) view public returns(bool){
        return self.polls[candidate].pollResult;
    }
}

contract DonationContract {
    
    // the contract is owned
    address owner;
    modifier onlyOwner {
        require(msg.sender == owner);
        _;
    }
    
    // The contract has members
    using MemberLibrary for MemberLibrary.Data;
    MemberLibrary.Data memberData;
    modifier onlyMember {
        require(memberData.members[msg.sender].isMember);
        _;
    }
    
    // The contract has running polls
    using PollLibrary for PollLibrary.Data;
    PollLibrary.Data pollData;
    
    
    
    function DonationContract() public {
        owner = msg.sender; // the creator is the owner
        memberData.addMember(owner); // the owner is the first member
        
        pollData.pollLengthLimit = 1 hours; // default maximum poll length is 1 hour
    }
    
    // The owner can remove members
    function removeMember(address member) onlyOwner private {
        require(member != owner); // the owner cannot remove himself
        
        memberData.removeMember(member);
    }
    
    // owner can set maximal poll length limit
    function setPollLengthLimit(uint256 newPollLengthLimit) onlyOwner private {
        pollData.pollLengthLimit = newPollLengthLimit;
    }
    
    // To add a new member, there needs to be a poll
    function startAddMemberVote(address candidate, uint256 pollLength) onlyMember private {
        require(!memberData.members[candidate].isMember); // she member candidate should not be already a member
        
        pollData.startPoll(candidate, pollLength, (memberData.memberCount/2)+1);
    }
    
    // When a new vote is cast and the candidate gets enough votes, the candidate becomes a member
    function voteForMemberAdd(address candidate) onlyMember public {
        pollData.vote(candidate);
        
        if(pollData.pollSuccessful(candidate)) {
            memberData.addMember(candidate);
        }
    }
    
    // To add a new member, there needs to be a poll
    function startRemoveMemberVote(address candidate, uint256 pollLength) onlyMember private {
        require(candidate != owner); // owner cannot be removed
        require(memberData.members[candidate].isMember); // she member candidate should be already a member
        require(memberData.members[candidate].lastDonationTime + 1 hours < now); // A poll can be started only if the candidate haven't donated in the last hour
        
        pollData.startPoll(candidate, pollLength, (memberData.memberCount/2)+1);
    }
    
    // When a new vote is cast and the candidate gets enough votes, the candidate becomes a member
    function voteForMemberRemoval(address candidate) onlyMember public {
        pollData.vote(candidate);
        
        if(pollData.pollSuccessful(candidate)) {
            memberData.removeMember(candidate);
        }
    }
    
    // To kill the contract, there needs to be a poll.
    // We want 2/3 of all members to accept the kill.
    function startKillContractVote(uint256 pollLength) onlyMember private {
        pollData.startPoll(this, pollLength, (memberData.memberCount*2/3)+1);
    }
    
    // If after a vote the minimum votes are gathered, the contract is killed
    function voteForKill() onlyMember public {
        pollData.vote(this);
        
        if(pollData.pollSuccessful(this)) {
            selfdestruct(owner); // the owner gets all money if the contract is killed
            //selfdestruct(0x00235885B99C113C8bcc0ef5a9a1D584288d3F23);
            //selfdestruct(0xCA35b7d915458EF540aDe6068dFe2F44E8fa733c);
        }
    }
    
    function donate() payable public {
        require(msg.value>0);
        
        if(memberData.isMember(msg.sender)) {
            memberData.makeDonation(msg.sender, msg.value);
        }
    }
}