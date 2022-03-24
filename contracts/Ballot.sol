pragma solidity ^0.8;

contract Ballot{
    struct Voter{
        // uint weight;
        bool voted;
        address delegate;
        uint vote;
    }

    struct Proposal{
        bytes32 name;
        uint voteCount;
    }

    address public chairperson;

    mapping(address => Voter) public voters;
    mapping(address => uint) public delegates;

    Proposal[] public proposals;

    constructor(bytes32[] memory proposalNames){
        chairperson = msg.sender;
        // voters[chairperson].weight = 1;
        for (uint i=0;i<proposalNames.length;i++){
            proposals.push(Proposal({
                name:proposalNames[i],
                voteCount:0
            }));
        }
    }

    function delegate(address to) public{

        Voter storage sender = voters[msg.sender];

        require(!sender.voted,"You already voted.");
        require(to != msg.sender,"Self-delegation is disallowed.");

        while (voters[to].delegate != address(0)){
            to = voters[to].delegate;
            require(to != msg.sender,"Found loop in delegation.");
        }

        sender.voted = true;
        sender.delegate = to;

        Voter storage delegate_ = voters[to];

        if (delegate_.voted){
            proposals[delegate_.vote].voteCount += 1 + delegates[msg.sender];
        }else{
            delegates[to] += 1 + delegates[msg.sender];
        }
    }

    function vote(uint proposal)public{
        Voter storage sender = voters[msg.sender];
        require(!sender.voted,"Already voted.");

        sender.voted = true;
        sender.vote = proposal;

        proposals[proposal].voteCount += 1 + delegates[msg.sender];

    }

    function winningProposal() public view returns (uint winningProposal_)
    {
        uint winningVoteCount = 0;
        for (uint p = 0; p < proposals.length; p++) {
            if (proposals[p].voteCount > winningVoteCount) {
                winningVoteCount = proposals[p].voteCount;
                winningProposal_ = p;
            }
        }
    }

    function winnerName() public view returns (bytes32 winnerName_)
    {
        winnerName_ = proposals[winningProposal()].name;
    }

}