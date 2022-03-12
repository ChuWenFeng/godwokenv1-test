pragma solidity ^0.8;

contract Fibonacci{
    function indexNum(uint n)external view returns(uint){
        if (n <= 0){
            return 0;
        }
        if (n == 1 || n == 2){
            return 1;
        }
        return this.indexNum(n-1)+this.indexNum(n-2);
    }

    function pureIndexNum(uint n)external pure returns(uint){
        uint256 fir = 1;
        uint256 sec = 1;
        if (n <= 0){
            return 0;
        }
        if (n == 1 || n == 2){
            return 1;
        }
        for (uint256 i=3;i<=n;i++){
            sec = fir + sec;
            fir = sec - fir;
        }
        return sec;
    }
}