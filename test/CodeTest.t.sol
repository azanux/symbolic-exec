//SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "forge-std/Test.sol";
import "../src/Code.sol";

contract CodeTest is Test {
    Code public code;

    address public owner = address(0x123);

    function setUp() public {
        vm.deal(address(this), 10 ether);
        code = new Code{value: 5 ether}();
    }

    /**
     * This the fuzz function that will test several value to break the contract
     * @param x value to withdraw
     */
    function test_check_withdraw(uint256 x) public {
        vm.prank(owner);
        code.withdraw(x);
        assert(code.balance() != 0 ether);
    }

    /**
     * This the test function will use halmos to break the contract
     * @param x value to withdraw
     */
    function check_withdraw(uint256 x) public {
        vm.prank(owner);
        code.withdraw(x);
        assert(code.balance() != 0 ether);
    }

    function test_withdraw() public {
        uint256 amount = 115792089237316195423570985008687907853269984665640564039457584007913129639910;
        vm.prank(owner);
        code.withdraw(amount);
        console.log("balance", code.balance());
        assert(code.balance() != 0 ether);
    }

    function test_fail_withdraw() public {
        uint256 amount = 25;
        vm.prank(owner);
        code.withdraw(amount);
        console.log("balance", code.balance());
        assert(code.balance() != 0 ether);
    }
}
