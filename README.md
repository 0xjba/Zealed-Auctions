# Zealed-Auctions
In a sealed bid auction, bidders privately submit their best offer in a sealed envelope. The bids are opened privately by the auctioneer and seller. Here users cant see other bid's or the highest bid (until the auction ends).

# Zealed-Auction Contract

This is a smart contract for a simple bidding auction. It allows bidders to place bids, the highest bidder to withdraw their bid, and the auctioneer to end the auction and send the highest bid to the seller.

Contract Address: **0xD114389e8E2C358CA78C82851d13D9aB1Ff7A4C0**

Contract Deployed on: **Obscuro Testnet**

Contract Deployment Transcation ID: **0x431381d5fe3b189d39cfcbc01906dd5afbe4325f1a00dd5b601433970b57498d**

 **NOTE** - `This contract doesnt come with a frontend so line by line comments are added in the contract to ensure that you can easily understand & build the frontend for this contract.`

## Variables

### Private Variables

-   `highestBidder` - the address of the current highest bidder
-   `highestBid` - the amount of the current highest bid

### Public Variables

-   `ended` - a boolean that indicates whether the auction has ended
-   `seller` - the address of the seller
-   `auctioneer` - the address of the auctioneer

## Constructor

### `constructor(address payable _seller)`

-   `_seller` - the address of the seller

The constructor initializes the `seller` variable to the provided address and the `auctioneer` variable to the address of the contract deployer.

## Events

### `AuctionEnded(address winner, uint amount)`

This event is emitted when the auction ends and includes the address of the highest bidder and the amount of their bid.

## Functions

### `bid()`

This function allows bidders to place bids.

Modifiers:

-   `require(!ended, "The auction has ended.")` - checks whether the auction has ended.
-   `require(msg.value > highestBid, "There is already a higher bid.")` - checks whether the bid is higher than the current highest bid.

When a bid is placed, the function updates the `highestBidder` and `highestBid` variables and adds the bid amount to the mapping for the bidder.

### `getBid(address bidder)`

This function allows the auctioneer to access the mapping of each bidder's bid.

Modifiers:

-   `require(msg.sender == auctioneer, "Only the auctioneer can access the bids.")` - checks whether the caller is the auctioneer.

The function returns the bid amount for the specified `bidder`.

### `getHighestBid()`

This function allows the auctioneer or the seller to get the highest bidder and bid amount.

Modifiers:

-   `require(msg.sender == auctioneer || msg.sender == seller, "Only the auctioneer or the seller can access the highest bid.")` - checks whether the caller is the auctioneer or the seller.

The function returns the `highestBidder` and `highestBid` variables.

### `endAuction()`

This function allows the auctioneer to end the auction and send the highest bid to the seller.

Modifiers:

-   `require(!ended, "The auction has already ended.")` - checks whether the auction has already ended.
-   `require(msg.sender == auctioneer, "Only the auctioneer can end the auction.")` - checks whether the caller is the auctioneer.

When the auction is ended, the function sets the `ended` variable to true, sends the highest bid to the `seller`, and emits the `AuctionEnded` event.

### `results()`

This function allows anyone to see the highest bidder and bid amount, but only after the auction has ended.

Modifiers:

-   `require(ended, "The auction has not ended yet.")` - checks whether the auction has ended.

The function returns the `highestBidder` and `highestBid` variables.

### `withdraw()`

This function allows bidders to withdraw their bid, but only after the auction has ended and they are not the highest bidder.

Modifiers:

-   `require(ended, "The auction has not ended yet.")` - checks whether the auction has ended.
-   `require(msg.sender != highestBidder, "The highest bidder cannot withdraw their bid.")` - checks whether the caller is not the highest bidder.

When a bidder withdraws their bid, the function sets their bid amount to zero and sends the amount
