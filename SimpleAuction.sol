//SPDX-License-Identifier: MIT
pragma solidity 0.8.7;

contract SimpleAuction {
    address payable public beneficiary;
    uint public auctionEndTime;

    //current state
    address public highestBidder;
    uint public highestBid;

    // If the current bid is higher than the previous bid, the previous bid refunded back.
    mapping(address => uint) public refundBid;

    bool ended;

    event HighestBidIncreased(address bidder, uint bid);
    event AuctionEnded(address winner, uint bid);

    error AuctionHasAlreadyEnded();
    error BidNotEnough(uint bid);
    error AuctionNotYetEnded();
    error AuctionEndAlreadyCalled();

    constructor(address payable _beneficiary, uint _endTime) public {
        beneficiary = _beneficiary;
        auctionEndTime = block.timestamp + _endTime;
    }

    function bid() public payable {
        if (block.timestamp > auctionEndTime) {
            revert AuctionHasAlreadyEnded();
        }

        if (msg.value <= highestBid) {
            revert BidNotEnough(msg.value);
        }

        if (highestBid != 0) {
            refundBid[highestBidder] += highestBid;
        }

        highestBid = msg.value;
        highestBidder = msg.sender;
        emit HighestBidIncreased(msg.sender, msg.value);

    }

    function withdraw() external returns(bool) {
        uint amount = refundBid[msg.sender];

        if (amount > 0) {
            refundBid[msg.sender] = 0;

        // explicitly converted msg.sender to payable, and it transaction fails the amount is added back to refundBid
            if (!payable(msg.sender).send(amount)) { 
                refundBid[msg.sender] = amount;
                return false;
            }
        }
        return true;
    }

    function auctionEnd() public {
        if (block.timestamp < auctionEndTime) {
            revert AuctionNotYetEnded();
        }

        if (ended) {
            revert AuctionEndAlreadyCalled();
        }

        ended = true;
        emit AuctionEnded(highestBidder, highestBid);
        
        beneficiary.transfer(highestBid);
    }
    

}