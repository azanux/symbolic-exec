// import Halmos cheatcodes

import {Test} from "forge-std/Test.sol";

import {Token} from "../src/Token.sol";

contract TokenTest is Test {
    Token token;

    function setUp() public {
        token = new Token();

        // set the balances of three arbitrary accounts to arbitrary symbolic values
        address receiver = address(0x0000000000000000000000000080000000000000); // create a new symbolic address
        uint256 amount = 380198843856324804992827392; // create a new symbolic uint256 value
        token.transfer(receiver, amount);

        address receiver1 = address(0x0000000000000000000000400000000000000000); // create a new symbolic address
        uint256 amount1 = 906694364710971881029632; // create a new symbolic uint256 value
        token.transfer(receiver1, amount1);

        address receiver2 = address(0x0000000000000000000000000000000000000000); // create a new symbolic address
        uint256 amount2 = 1180591620717412269958; // create a new symbolic uint256 value
        token.transfer(receiver2, amount2);
    }

    function test_checkBalanceUpdate() public {
        // consider two arbitrary distinct accounts
        address caller = address(0x0000000000000000000000400000000000000000); // create a symbolic address
        address others = address(0x0000000000000000000000000000000000000000); // create another symbolic address
        vm.assume(others != caller); // assume the two addresses are different

        // record their current balances
        uint256 oldBalanceCaller = token.balanceOf(caller);
        uint256 oldBalanceOthers = token.balanceOf(others);

        // execute an arbitrary function call to the token from the caller
        /**
         * vm.prank(caller);
         *     uint256 dataSize = 100; // the max calldata size for the public functions in the token
         *     bytes
         *         memory data = hex"30e0789e00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000000000000000000000000000000000000000000000000000000037fc900000307d7f7e"; // create a symbolic calldata
         *     address(token).call(data);
         */
        vm.prank(caller);
        token._transfer(
            address(0x0000000000000000000000000000000000000000),
            address(0x0000010000000000000000000000000000000000),
            1032769970149043044222
        );

        // ensure that the caller cannot spend others' tokens
        assert(token.balanceOf(caller) <= oldBalanceCaller); // cannot increase their own balance
        assert(token.balanceOf(others) >= oldBalanceOthers); // cannot decrease others' balance
    }
}
