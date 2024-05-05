// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.0;

/**
 * @title Code
 * @author azanux
 * @notice this  program hold Ether and you have to guess the password to withdraw it
 */
contract Code {
    uint256 private password;

    constructor() payable {
        require(msg.value >= 1 ether);
        password = 25;
    }

    function withdraw(uint256 password_) public {
        if (password_ == password) {
            (bool success,) = msg.sender.call{value: address(this).balance}("");
            require(success, "failed to send");
        }
    }

    function balance() public view returns (uint256) {
        return address(this).balance;
    }
}
