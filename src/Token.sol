// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.0;

/**
 * @title Token
 * @author azanux
 * @notice This Smart Contract is a token, it will allow you to transfer token to another address
 * We will try to find some value that break the invariant of the contract
 * A caller can't transfer anothe token
 * But the _transfer function is public so the call will be able to transfer other user token
 */
contract Token {
    mapping(address => uint256) public balanceOf;

    constructor() {
        balanceOf[msg.sender] = 1e27;
    }

    function transfer(address to, uint256 amount) public {
        _transfer(msg.sender, to, amount);
    }

    function _transfer(address from, address to, uint256 amount) public {
        balanceOf[from] -= amount; //@audit-issue this part is public and can be called by anyone
        balanceOf[to] += amount;
    }
}
