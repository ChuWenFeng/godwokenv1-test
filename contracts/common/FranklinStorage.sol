// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract FranklinStorage{

    address payable public testCreator;

    constructor() {
        testCreator = payable(msg.sender);
    }

    function killThisTestContract() public {
        require(msg.sender == testCreator, "only creator can clean up test contracts");
        selfdestruct(testCreator);
    }

    bytes32 constant EMPTY_TREE_ROOT = 0x003f7e15e4de3453fe13e11fb4b007f1fce6a5b0f0353b3b8208910143aaa2f7;

    event BlockCommitted(uint32 indexed blockNumber);
    event BlockVerified(uint32 indexed blockNumber);

    enum Circuit {
        DEPOSIT,
        TRANSFER,
        EXIT
    }

    enum AccountState {
        NOT_REGISTERED,
        REGISTERED,
        PENDING_EXIT,
        UNCONFIRMED_EXIT
    }

    struct Block {
        uint8 circuit;
        uint64  deadline;
        uint128 totalFees;
        bytes32 newRoot;
        bytes32 publicDataCommitment;
        address prover;
    }

    // Key is block number
    mapping (uint32 => Block) public blocks;
    // Only some addresses can send proofs
    mapping (address => bool) public operators;
    // Fee collection accounting
    mapping (address => uint256) public balances;

    struct Account {
        uint8 state;
        uint32 exitBatchNumber;
        address owner;
        uint256 publicKey;
        uint32 exitListHead;
        uint32 exitListTail;
    }




}