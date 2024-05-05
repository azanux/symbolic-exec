// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {Counter} from "../src/Counter.sol";

contract CounterTest is Test {
    Counter public counter;

    function setUp() public {
        counter = new Counter();
        counter.setNumber(0);
    }

    function test_Increment() public {
        counter.increment();
        assertEq(counter.number(), 1);
    }

    /**
     *
     * @param x This test function use fuzzing to break the contract
     * with 1000000 iteration the fuzzer have trouble to find the value that break the contract
     */
    function test_Fuzz_SetNumber(uint256 x) public {
        counter.setNumber(x);
        assertEq(counter.number(), x);
    }

    /**
     *
     * @param x This test function use halmos to break the contract
     */
    function chek_Fuzz_SetNumber(uint256 x) public {
        counter.setNumber(x);
        assertEq(counter.number(), x);
    }

    /**
     * This test function use a value tu brake the contract
     */
    function test_SetNumber() public {
        uint256 x = 3456827547395746354;
        counter.setNumber(x);
        assertEq(counter.number(), x);
    }
}
