//SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import {SymTest} from "halmos-cheatcodes/SymTest.sol";
import {Test} from "forge-std/Test.sol";
import {MyToken} from "../src/MyToken.sol";

contract MyTokenTest is SymTest, Test {
    MyToken token;

    function setUp() public {
        uint256 initialSupply = svm.createUint256("initialSupply");
        token = new MyToken(initialSupply);
    }

    function check_MyToken_transfer(address sender, address receiver, uint256 amount) public {
        // specify input conditions
        vm.assume(receiver != address(0));
        vm.assume(token.balanceOf(sender) >= amount);

        // record the current balance of sender and receiver
        uint256 balanceOfSender = token.balanceOf(sender);
        uint256 balanceOfReceiver = token.balanceOf(receiver);

        // call target contract
        vm.prank(sender);
        token.transfer(receiver, amount);

        // check output state
        assert(token.balanceOf(sender) == balanceOfSender - amount);
        assert(token.balanceOf(receiver) == balanceOfReceiver + amount);
    }
}

contract MyTokenFuzzTest is Test {
    MyToken token;

    function setUp() public {
        uint256 initialSupply = 1 ether;
        token = new MyToken(initialSupply);
    }

    function test_transfer(address sender, address receiver, uint256 amount) public {
        // specify input conditions
        vm.assume(receiver != address(0));
        vm.assume(sender != address(0));

        deal(address(token), sender, amount * 2);
        //vm.assume(token.balanceOf(sender) >= amount);

        // record the current balance of sender and receiver
        uint256 balanceOfSender = token.balanceOf(sender);
        uint256 balanceOfReceiver = token.balanceOf(receiver);

        // call target contract
        vm.prank(sender);
        token.transfer(receiver, amount);

        // check output state
        assert(token.balanceOf(sender) == balanceOfSender - amount);
        assert(token.balanceOf(receiver) == balanceOfReceiver + amount);
    }
}
