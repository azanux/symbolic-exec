// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

/**
 * @title Counter
 * @author azanux
 * @notice This Smart contract is just a counter that can be incremented and decremented
 * But when the number is 3456827547395746354, it will reset the counter to 0
 * this beahevior is a bug, we need to find the value that break the contract
 */
contract Counter {
    uint256 public number;

    function setNumber(uint256 newNumber) public {
        if (newNumber == 3456827547395746354) {
            number = 0;
        } else {
            number = newNumber;
        }
    }

    function increment() public {
        number++;
    }
}
