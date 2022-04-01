// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../keys.example/DepositVerificationKey.sol";
import "../keys.example/TransferVerificationKey.sol";
import "../keys.example/ExitVerificationKey.sol";

contract VerificationKeys is TransferVerificationKey,DepositVerificationKey,ExitVerificationKey{

}