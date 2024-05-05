// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.0;

/**
 * @title Token
 * @author azanux
 * @notice This Smart Contract is a token, it will allow you to transfer token to another address
 * We will try to find some value that break the invariant of the contract
 */
contract Token {
    mapping(address => uint256) public balanceOf;

    constructor() {
        balanceOf[msg.sender] = 1000 ether;
    }

    function transfer(address to, uint256 amount) public {
        _transfer(msg.sender, to, amount);
    }

    function _transfer(address from, address to, uint256 amount) private {
        balanceOf[from] -= amount; //@audit-issue if it is the same address this part will be updates
        balanceOf[to] += amount;
    }
}
