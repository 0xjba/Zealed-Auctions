pragma solidity ^0.8.4;

contract BiddingAuction {
    // Private variables to track the highest bidder and their bid amount
    address private highestBidder;
    uint private highestBid;

    // Boolean to track if the auction has ended
    bool public ended;

    // Address of the seller
    address payable public seller;

    // Address of the auctioneer
    address public auctioneer;

    // Event to emit when the auction ends
    event AuctionEnded(address winner, uint amount);

    // Private mapping to keep track of each bidder's bid
    mapping(address => uint) private _bids;

    constructor(address payable _seller) {
        // Set the seller to the provided address
        seller = _seller;

        // Set the auctioneer to the contract deployer
        auctioneer = msg.sender;
    }

    // Function to place a bid
    function bid() public payable {
        // Make sure the auction has not ended
        require(!ended, "The auction has ended.");

        // Make sure the bid is higher than the current highest bid
        require(msg.value > highestBid, "There is already a higher bid.");

        // Update the highest bidder and bid amount
        highestBidder = msg.sender;
        highestBid = msg.value;

        // Add the bid amount to the mapping for the bidder
        _bids[msg.sender] += msg.value;
    }

    // Function to end the auction and send the highest bid to the seller
    function endAuction() public {
        // Make sure the auction has not already ended
        require(!ended, "The auction has already ended.");
        
        // Make sure the caller is the auctioneer
        require(msg.sender == auctioneer, "Only the auctioneer can end the auction.");

        // Set ended to true
        ended = true;

        // Send the highest bid to the seller
        seller.transfer(highestBid);

        // Emit the AuctionEnded event
        emit AuctionEnded(highestBidder, highestBid);
    }

    // Function to access the bids mapping
    function getBid(address bidder) public view returns (uint) {
        // Make sure the caller is the auctioneer
        require(msg.sender == auctioneer, "Only the auctioneer can access the bids.");

        // Return the bid amount for the bidder
        return _bids[bidder];
    }

    // Function to get the highest bid and bidder
    function getHighestBid() public view returns (address, uint) {
        // Make sure the caller is the auctioneer or the seller
        require(msg.sender == auctioneer || msg.sender == seller, "Only the auctioneer or the seller can access the highest bid.");
        
        // Return the highest bidder and bid amount
        return (highestBidder, highestBid);
    }

    // Function to show the highest bidder and bid, only accessible when the auction has ended
    function results() public view returns (address, uint) {
        // Make sure the auction has ended
        require(ended, "The auction has not ended yet.");
        
        // Return the highest bidder and bid amount
        return (highestBidder, highestBid);
    }

        function withdraw() public {
        // Make sure the auction has ended
        require(ended, "The auction has not ended yet.");

        // Make sure the caller is not the highest bidder
        require(msg.sender != highestBidder, "The highest bidder cannot withdraw their bid.");

        // Get the bid amount for the caller
        uint bidAmount = _bids[msg.sender];

        // Make sure the caller has a bid amount to withdraw
        require(bidAmount > 0, "You have no bid amount to withdraw.");

        // Set the bid amount to zero
        _bids[msg.sender] = 0;

        // Send the bid amount back to the bidder
        payable(msg.sender).transfer(bidAmount);
    }
}
