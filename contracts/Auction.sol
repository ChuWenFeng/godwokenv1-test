pragma solidity ^0.8;

contract SimpleAuction{
    address payable public beneficiary;

    uint public auctionEnd;
    address public highestBidder;
    uint public highestBid;

    mapping(address => uint) pendingReturns;

    bool ended;

    event HighestBidIncreased(address bidder,uint amount);
    event AuctionEnded(address winner,uint amount);

    constructor(uint _biddingTime,address payable _beneficiary){
        beneficiary = _beneficiary;
        auctionEnd = block.timestamp + _biddingTime;
    }    

    function  bid() public payable{
        require(block.timestamp <= auctionEnd,"Auction already ended.");
        require(msg.value > highestBid,"There already is a higher bid.");

        if (highestBid != 0){
            pendingReturns[highestBidder] += highestBid;
        }

        highestBidder = msg.sender;
        highestBid = msg.value;
        emit HighestBidIncreased(msg.sender, msg.value);
    }

    function withdraw() public returns(bool){
        uint amount = pendingReturns[msg.sender];
        if(amount>0){
            pendingReturns[msg.sender] = 0;
            if(!payable(msg.sender).send(amount)){
                pendingReturns[msg.sender] = amount;
                return false;
            }
        }
        return true;
    }

    function auctionEndBid() public {
        require(block.timestamp >= auctionEnd,"Auction not yet ended.");
        require(!ended,"auctionEnd has already been called.");

        ended = true;
        emit AuctionEnded(highestBidder, highestBid);
        beneficiary.transfer(highestBid);
    }
}

contract BlindAuction{
    struct Bid{
        bytes32 blindedBid;
        uint deposit;
    }

    address payable public beneficiary;
    uint public biddingEnd;
    uint public revealEnd;
    bool public ended;

    mapping(address => Bid[])public bids;

    address public highestBidder;
    uint public highestBid;

    mapping(address => uint) pendingReturns;

    event AuctionEnded(address winner,uint highestBid);

    modifier onlyBefore(uint _time){
        require(block.timestamp < _time);
        _;
    }

    modifier onlyAfter(uint _time){
        require(block.timestamp > _time);
        _;
    }

    constructor(
        uint _biddingTime,
        uint _revealTime,
        address payable _beneficiary
    ) public {
        beneficiary = _beneficiary;
        biddingEnd = block.timestamp + _biddingTime;
        revealEnd = biddingEnd + _revealTime;
    }

    function bid(bytes32 _blindedBid) public payable onlyBefore(biddingEnd){
        bids[msg.sender].push(
            Bid({
                blindedBid:_blindedBid,
                deposit:msg.value
            })
        );
    }

    function reveal(
        uint[] calldata _values ,
        bool[] calldata _fake,
        bytes32[] calldata _secret
    )public onlyAfter(biddingEnd) onlyBefore(revealEnd){
        uint length = bids[msg.sender].length;
        require(_values.length == length);
        require(_fake.length == length);
        require(_secret.length == length);

        uint refund;
        for(uint i = 0;i<length;i++){
            Bid storage bid = bids[msg.sender][i];
            (uint value,bool fake,bytes32 secret) = (_values[i],_fake[i],_secret[i]);
            if(bid.blindedBid != keccak256(abi.encodePacked(value,fake,secret))){
                continue;
            }
            refund += bid.deposit;
            if(!fake && bid.deposit >= value){
                if(placeBid(msg.sender,value)){
                    refund -= value;
                }
            }
            bid.blindedBid = bytes32(0);
        }
        payable(msg.sender).transfer(refund);

    }

    function placeBid(address bidder,uint value) internal returns(bool success){
        if(value <= highestBid){
            return false;
        }
        if(highestBidder != address(0)){
            pendingReturns[highestBidder]+=highestBid;
        }
        highestBid = value;
        highestBidder = bidder;

        return true;
    }

    function withdraw()public{
        uint amount = pendingReturns[msg.sender];
        if (amount > 0){
            pendingReturns[msg.sender] = 0;
            payable(msg.sender).transfer(amount);
        }
    }

    function auctionEndBid() public onlyAfter(revealEnd){
        require(!ended);
        emit AuctionEnded(highestBidder, highestBid);
        ended = true;
        payable(beneficiary).transfer(highestBid);
    }

}