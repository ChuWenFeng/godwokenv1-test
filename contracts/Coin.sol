pragma solidity ^0.8;

contract Coin{
    address public minter;
    mapping(address => uint)public balances;

    event Sent(address from,address to,uint amount);

    constructor(){
        minter = msg.sender;
    }

    function mint(address receiver,uint amount)public{
        require(msg.sender == minter);
        require(amount < 1e60);
        balances[receiver]+=amount;
    }

    function getMint()public view returns(address){
        return minter;
    }

    function getBalances(address ads)public view returns(uint){
        return balances[ads];
    }

    function send(address receiver,uint amount)public{
        require(amount <= balances[msg.sender],"Insufficient balances");
        balances[msg.sender] -= amount;
        balances[receiver] += amount;
        emit Sent(msg.sender,receiver,amount);
    }

}