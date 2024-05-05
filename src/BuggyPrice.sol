// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.17;
/**
 * @title BuggyPrice
 * @author azanux
 * @notice this contract contains a bug in totalPriceBuggy function
 * the bug is caused by type casting uint120 to uint128
 */

contract BuggyPrice {
    function totalPriceBuggy(uint96 price, uint32 quantity) public pure returns (uint128) {
        unchecked {
            return uint120(price) * quantity; // buggy type casting: uint120 vs uint128
        }
    }
}
