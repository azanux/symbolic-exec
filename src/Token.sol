// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.0;

contract Token {
    mapping(address => uint256) public balanceOf;

    constructor() {
        balanceOf[msg.sender] = 1e27;
    }

    function transfer(address to, uint256 amount) public {
        _transfer(msg.sender, to, amount);
    }

    function _transfer(address from, address to, uint256 amount) public {
        balanceOf[from] -= amount; //@audit-issue if it is the same address this part will be updates
        balanceOf[to] += amount;
    }
}
