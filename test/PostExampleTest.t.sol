//SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "forge-std/Test.sol";
import "../src/PostExample.sol";

/**
 * @title PostExampleTest
 * @author azanux
 * @notice This Smart Contract have a backdoor with x as parameter in his function backdoor that will reset the value of number.
 * numnber should not never be equal to 0
 * We will try to find the value x that will break the invariant
 */
contract PostExampleTest is Test {
    PostExample public example;

    function setUp() public {
        example = new PostExample();
    }
    /**
     *
     * @param x value to test with fuzzer
     */

    function test_check_Backdoor(uint256 x) public {
        example.backdoor(x);

        assert(example.number() != 0);
    }

    /**
     *
     * @param x value to test with halmos
     */
    function check_Backdoor(uint256 x) public {
        example.backdoor(x);

        assert(example.number() != 0);
    }
}
