pragma solidity ^0.8.0;

contract OwnedToken{
    TokenCreator creator;
    address owner;
    string name;
    constructor(string memory _name){
        owner = msg.sender;
        creator = TokenCreator(msg.sender);
        name = _name;
    }

    function changeName(string calldata newName) public {
        if (msg.sender == address(creator)){
            name = newName;
        }
    }

    function transfer(address newOwner)public{
        if (msg.sender != owner) return;

        if(creator.isTokenTransferOk(owner, newOwner))
            owner = newOwner;
    }
}


contract TokenCreator{
    function createToken(string memory name) public returns(OwnedToken tokenAddress){
        return new OwnedToken(name);
    }

    function changeName(OwnedToken tokenAddress,string calldata name) public {
        tokenAddress.changeName(name);
    }

    function isTokenTransferOk(address _currentOwner,address newOwner) public view returns(bool ok){
        address tokenAddress = msg.sender;
        return ( keccak256(abi.encodePacked(newOwner)) ) == (bytes20(tokenAddress) );
    }
}