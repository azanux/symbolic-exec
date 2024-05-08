// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {ERC20} from "openzeppelin/token/ERC20/ERC20.sol";
/**
 * @title MyToken
 * @author azanux
 * @notice This contrat is an ERC20 Token , we will try to find some value that break the invariant of the contract
 * Invariant is when a sender transfer token to a receiver the balance of the sender will decrease and the balance of the receiver will increase by amount
 */

contract MyToken is ERC20 {
    constructor(uint256 initialSupply) ERC20("MyToken", "MT") {
        _mint(msg.sender, initialSupply);
    }
}
