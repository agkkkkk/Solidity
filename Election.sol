//SPDX-License-Identifier: MIT
pragma solidity 0.8.9;

contract Election {
    address public electionSupervisor;

    struct Candidate {
        uint candidateId;
        string candidateName;
        uint voteCount;
    }

    mapping(uint => Candidate) public candidates;
    mapping(address => bool) public voters;

    uint public candidateCount;

    bool electionEnded;

    event VoteRegistered();

    constructor() {
        electionSupervisor = msg.sender;
    }

    modifier onlySupervisor() {
        require(electionSupervisor == msg.sender, "Only Supervisor can call this function.");
        _;
    }

    function addCandidate(string memory _candidateName) public onlySupervisor {
        require(!electionEnded, "ELection has Ended.");
        candidateCount++;
        candidates[candidateCount] = Candidate(candidateCount, _candidateName, 0);
    }

    function vote(uint _candidateId) public {
        require(!electionEnded, "Election has ended.");
        require(!voters[msg.sender], "Voter has already voted.");
        require(_candidateId > 0 && _candidateId <= candidateCount, "Invalid candidate ID");

        voters[msg.sender] = true;
        candidates[_candidateId].voteCount++;
    }

    function endElection() public onlySupervisor {
        require(!electionEnded, "Election has ended.");
        electionEnded = true;
    }

    function declareResult() public view onlySupervisor returns(string memory name) {
        require(electionEnded, "Election not yet over.");

        for (uint i=1; i <= candidateCount; i++) {
            uint totalVote;
            if (candidates[i].voteCount > totalVote) {
                totalVote = candidates[i].voteCount;
                name = candidates[i].candidateName;
            }
        }
        return name;
    }
}