//SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

/**
 * @title PostExample
 * @author azanux
 * @notice The contract is counter that increment the value set , except when the value set is 3456827547395746354 ,the program reset to 0
 * We need to find the value that break the invariant
 */
contract PostExample {
    uint256 public number;

    // https://github.com/foundry-rs/foundry/issues/2851
    function backdoor(uint256 x) external {
        number = 99;
        unchecked {
            uint256 z = x - 1;
            if (z == 6912213124124531) {
                number = 0;
            } else {
                number = 1;
            }
        }
    }
}
