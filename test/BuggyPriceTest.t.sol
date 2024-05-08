//SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import {SymTest} from "halmos-cheatcodes/SymTest.sol";
import {Test} from "forge-std/Test.sol";
import {BuggyPrice} from "../src/BuggyPrice.sol";

contract BuggyPriceTest is SymTest, Test {
    BuggyPrice public buggyPrice;

    address public owner = address(0x123);

    function setUp() public {
        vm.deal(address(this), 10 ether);
        buggyPrice = new BuggyPrice();
    }

    /**
     * This is the fuzz function that will test several value to break the contract
     * @param price price of the product
     * @param quantity quantity of the product
     */
    function test_total_fuzz(uint96 price, uint32 quantity) public view {
        uint128 total = buggyPrice.totalPriceBuggy(price, quantity);
        assert(quantity == 0 || total >= price);
    }

    /**
     * This is the test function that we already know the value to break the contract
     */
    function test_TotalPriceBuggy() public view {
        uint96 price = 43643669322988860674796334970;
        uint32 quantity = 1675100672;

        uint128 total = buggyPrice.totalPriceBuggy(price, quantity);

        assert(quantity == 0 || total >= price);
    }

    /**
     * This is another test function that we already know the value to break the contract
     */
    function test_TotalPriceBuggyOther() public view {
        uint96 price = 39614081294025656978550816767;
        uint32 quantity = 1073741824;

        uint128 total = buggyPrice.totalPriceBuggy(price, quantity);

        assert(quantity == 0 || total >= price);
    }

    /**
     * This is the function use by Halmos to break the code
     * @param price price of the product
     * @param quantity quantity of the product
     */
    function check_totalPrice_test(uint96 price, uint32 quantity) public view {
        uint128 total = buggyPrice.totalPriceBuggy(price, quantity);
        assert(quantity == 0 || total >= price);
    }
}
