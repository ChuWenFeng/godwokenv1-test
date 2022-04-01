pragma solidity ^0.8.0;

contract Test{
    fallback() external {x=1;}
    uint x;
}

contract TestPayable{
    fallback() external payable {x=1;y=msg.value;}
    receive() external payable {x=2;y=msg.value;}

    uint x;
    uint y;
}

contract Caller{
    function callTest(Test test) public returns (bool){
        (bool sucess,) = address(test).call(abi.encodeWithSignature("nonExisitingFunction()"));
        require(sucess);
        //require(test.x == 1);
        address payable testPayable = payable(address(test));
        //testPayable.send(2 ether);
    }

    function callTestPayable(TestPayable test) public returns(bool){
        (bool sucess,) = address(test).call(abi.encodeWithSignature("nonExisitingFunction()"));
        require(sucess);

        (sucess,) = address(test).call{value:1}(abi.encodeWithSignature("nonExisitingFunction()"));
        require(sucess);

        require(payable(test).send(2 ether));

        return true;
    }
}