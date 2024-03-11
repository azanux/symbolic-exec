//SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "forge-std/Test.sol";
import "../src/BuggyPrice.sol";

contract BuggyPriceTest is Test {
    BuggyPrice public buggyPrice;

    address public owner = address(0x123);

    function setUp() public {
        vm.deal(address(this), 10 ether);
        buggyPrice = new BuggyPrice();
    }

    function (uint96 price, uint32 quantity) public view {
        uint128 total = buggyPrice.totalPriceBuggy(price, quantity);
        assert(quantity == 0 || total >= price);
    }

    function test_TotalPriceBuggy() public view {
        uint96 price = 43643669322988860674796334970;
        uint32 quantity = 1675100672;

        uint128 total = buggyPrice.totalPriceBuggy(price, quantity);

        assert(quantity == 0 || total >= price);
    }

    function test_TotalPriceBuggyOther() public view {
        uint96 price = 39614081294025656978550816768;
        uint32 quantity = 1073741824;

        uint128 total = buggyPrice.totalPriceBuggy(price, quantity);

        assert(quantity == 0 || total >= price);
    }
}
