// SPDX-License-Identifier: MIT

pragma solidity ^0.5.0;

import "github.com/provable-things/ethereum-api/provableAPI_0.5.sol";

contract RunChecker is usingProvable {
    // Owner of contract
    address owner;
    // Wallet to send funds to if run not completed
    address payable punishWallet;
    // Length of a committed run in metres
    uint256 runLength;
    // Date run needs to be completed on in UNIX
    uint256 runDate;
    // Temporary runCheck variable
    bool runCheck;

    constructor() public {
        owner = msg.sender;
    }

    // Create modifier that gives owner permission to call functions
    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }

    // Set the details of a run to be completed
    function runCommit(
        uint256 _runLength,
        uint256 _runDate,
        address payable _punishWallet
    ) public payable onlyOwner {
        address nonPayableAddress = address(this);
        address payable payableAddress = address(uint160(nonPayableAddress));
        payableAddress.transfer(msg.value);
        runDate = _runDate;
        runLength = _runLength;
        punishWallet = _punishWallet;
    }

    // Check to see if run has been completed according to specifications
    function isRunComplete() public payable onlyOwner {
        // bool runCheck = call oraclise api
        if (runCheck == true) {
            msg.sender.transfer(address(this).balance);
        } else {
            punishWallet.transfer(address(this).balance);
        }
    }

    // Set value of runCheck
    function setRunCheck(bool _runCheck) public onlyOwner {
        runCheck = _runCheck;
    }
}
