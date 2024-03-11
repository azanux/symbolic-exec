//SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "forge-std/Test.sol";
import "../src/PostExample.sol";

contract PostExampleTest is Test {
    PostExample public example;

    function setUp() public {
        example = new PostExample();
    }

    function test_check_Backdoor(uint256 x) public {
        example.backdoor(x);

        assert(example.number() != 0);
    }
}
