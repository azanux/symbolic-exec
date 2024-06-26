// SPDX-License-Identifier: AGPL-3.0
pragma solidity >=0.8.0 <0.9.0;

import {ERC20Test} from "./ERC20Test.sol";

import {OpenZeppelinERC20} from "../src/OpenZeppelinERC20.sol";

/// @custom:halmos --solver-timeout-assertion 0
contract OpenZeppelinERC20Test is ERC20Test {
    /// @custom:halmos --solver-timeout-branching 1000
    function setUp() public override {
        address deployer = address(0x1000);

        OpenZeppelinERC20 token_ =
            new OpenZeppelinERC20("OpenZeppelinERC20", "OpenZeppelinERC20", 1_000_000_000e18, deployer);
        token = address(token_);

        holders = new address[](3);
        holders[0] = address(0x1001);
        holders[1] = address(0x1002);
        holders[2] = address(0x1003);

        for (uint256 i = 0; i < holders.length; i++) {
            address account = holders[i];
            uint256 balance = svm.createUint256("balance");
            vm.prank(deployer);
            token_.transfer(account, balance);
            for (uint256 j = 0; j < i; j++) {
                address other = holders[j];
                uint256 amount = svm.createUint256("amount");
                vm.prank(account);
                token_.approve(other, amount);
            }
        }
    }

    function check_NoBackdoor(bytes4 selector, address caller, address other) public {
        bytes memory args = svm.createBytes(1024, "data");
        _checkNoBackdoor(selector, args, caller, other);
    }
}

contract OpenZeppelinFuzzERC20Test is ERC20Test {
    /// @custom:halmos --solver-timeout-branching 1000
    function setUp() public override {
        address deployer = address(0x1000);

        OpenZeppelinERC20 token_ =
            new OpenZeppelinERC20("OpenZeppelinERC20", "OpenZeppelinERC20", 1_000_000_000e18, deployer);
        token = address(token_);

        holders = new address[](3);
        holders[0] = address(0x1001);
        holders[1] = address(0x1002);
        holders[2] = address(0x1003);

        for (uint256 i = 0; i < holders.length; i++) {
            address account = holders[i];
            uint256 balance = 0 ether;
            vm.prank(deployer);
            token_.transfer(account, balance);
            for (uint256 j = 0; j < i; j++) {
                address other = holders[j];
                uint256 amount = 4361478144;
                vm.prank(account);
                token_.approve(other, amount);
            }
        }
    }

    function test_OZ_transfer(address sender, address receiver, uint256 amount) public {
        vm.assume(receiver != address(0));
        vm.assume(sender != address(0));
        check_transfer(sender, receiver, address(0x1004), amount);
    }

    function test_TOZ_transfer() public {
        check_transfer(
            address(0x0000000000000000000000000000000000000002),
            address(0x0000000000000000000000000000000000000002),
            address(0x0000000000000000000000000000000000000000),
            1585180672
        );
    }
}
