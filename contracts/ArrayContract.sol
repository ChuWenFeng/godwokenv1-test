pragma solidity ^0.8.0;

contract ArrayContract{
    uint[2**20] m_aLotOfIntegers;

    bool[2][] m_pairsOfFlags;

    function setAllFlagPairs(bool[2][] memory newPairs)public{
        m_pairsOfFlags = newPairs;
    }

    struct StructType{
        uint[] contents;
        uint moreInfo;
    }
    StructType s;

    function f(uint[] memory c)public{
        StructType storage g = s;
        g.moreInfo = 2;
        g.contents = c;
    }

    function setFlagPair(uint index,bool flagA,bool flagB)public{
        m_pairsOfFlags[index][0] = flagA;
        m_pairsOfFlags[index][1] = flagB;
    }

    function changeFlagArraySize(uint newSize) public{
        if(newSize < m_pairsOfFlags.length){
            while (m_pairsOfFlags.length > newSize){
                m_pairsOfFlags.pop();
            }
        }else if (newSize > m_pairsOfFlags.length){
            m_pairsOfFlags.push();
        }
    }

    function clear() public{
        delete m_pairsOfFlags;
        delete m_aLotOfIntegers;
    }

    bytes m_byteData;

    function byteArrays(bytes memory data)public{
        m_byteData = data;
        for(uint i=0;i<7;i++){
            m_byteData.push();
        }
        m_byteData[3] = 0x08;
        delete m_byteData[2];
    }

}