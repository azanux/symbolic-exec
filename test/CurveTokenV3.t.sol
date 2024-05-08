// SPDX-License-Identifier: AGPL-3.0
pragma solidity >=0.8.0 <0.9.0;

import {SymTest} from "halmos-cheatcodes/SymTest.sol";
import {ERC20Test} from "./ERC20Test.sol";

// https://github.com/curvefi/curve-contract/blob/master/contracts/tokens/CurveTokenV3.vy

// Auto-generated by https://bia.is/tools/abi2solidity/
interface CurveTokenV3 {
    function decimals() external view returns (uint256);
    function transfer(address _to, uint256 _value) external returns (bool);
    function transferFrom(address _from, address _to, uint256 _value) external returns (bool);
    function approve(address _spender, uint256 _value) external returns (bool);
    function increaseAllowance(address _spender, uint256 _added_value) external returns (bool);
    function decreaseAllowance(address _spender, uint256 _subtracted_value) external returns (bool);
    function mint(address _to, uint256 _value) external returns (bool);
    function burnFrom(address _to, uint256 _value) external returns (bool);
    function set_minter(address _minter) external;
    function set_name(string memory _name, string memory _symbol) external;
    function name() external view returns (string memory);
    function symbol() external view returns (string memory);
    function balanceOf(address arg0) external view returns (uint256);
    function allowance(address arg0, address arg1) external view returns (uint256);
    function totalSupply() external view returns (uint256);
    function minter() external view returns (address);
}

contract EmptyContract {}

/// @custom:halmos --storage-layout=generic --solver-timeout-assertion 0
contract CurveTokenV3Test is ERC20Test {
    CurveTokenV3 token_;
    address minter;

    /// @custom:halmos --solver-timeout-branching 1000
    function setUp() public override {
        token = address(new EmptyContract());
        // Source of Deployed Bytecode: https://etherscan.io/address/0x06325440D014e39736583c165C2963BA99fAf14E#code
        vm.etch(
            token,
            hex"341561000a57600080fd5b60043610156100185761092e565b600035601c5263313ce567600051141561003957601260005260206000f350005b63a9059cbb60005114156100ee5760043560a01c1561005757600080fd5b60023360e05260c052604060c02080546024358082101561007757600080fd5b80820390509050815550600260043560e05260c052604060c02080546024358181830110156100a557600080fd5b8082019050905081555060243561014052600435337fddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef6020610140a3600160005260206000f350005b6323b872dd600051141561023c5760043560a01c1561010c57600080fd5b60243560a01c1561011c57600080fd5b600260043560e05260c052604060c02080546044358082101561013e57600080fd5b80820390509050815550600260243560e05260c052604060c020805460443581818301101561016c57600080fd5b80820190509050815550600360043560e05260c052604060c0203360e05260c052604060c02054610140527fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff6101405118156101fb5761014051604435808210156101d657600080fd5b80820390509050600360043560e05260c052604060c0203360e05260c052604060c020555b604435610160526024356004357fddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef6020610160a3600160005260206000f350005b63095ea7b360005114156102b95760043560a01c1561025a57600080fd5b60243560033360e05260c052604060c02060043560e05260c052604060c0205560243561014052600435337f8c5be1e5ebec7d5bd14f71427d1e84f3dd0314c0f7b2291e5b200ac8c7c3b9256020610140a3600160005260206000f350005b633950935160005114156103725760043560a01c156102d757600080fd5b60033360e05260c052604060c02060043560e05260c052604060c0205460243581818301101561030657600080fd5b80820190509050610140526101405160033360e05260c052604060c02060043560e05260c052604060c020556101405161016052600435337f8c5be1e5ebec7d5bd14f71427d1e84f3dd0314c0f7b2291e5b200ac8c7c3b9256020610160a3600160005260206000f350005b63a457c2d760005114156104295760043560a01c1561039057600080fd5b60033360e05260c052604060c02060043560e05260c052604060c02054602435808210156103bd57600080fd5b80820390509050610140526101405160033360e05260c052604060c02060043560e05260c052604060c020556101405161016052600435337f8c5be1e5ebec7d5bd14f71427d1e84f3dd0314c0f7b2291e5b200ac8c7c3b9256020610160a3600160005260206000f350005b6340c10f1960005114156104e35760043560a01c1561044757600080fd5b600554331461045557600080fd5b6004805460243581818301101561046b57600080fd5b80820190509050815550600260043560e05260c052604060c020805460243581818301101561049957600080fd5b808201905090508155506024356101405260043560007fddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef6020610140a3600160005260206000f350005b6379cc679060005114156105995760043560a01c1561050157600080fd5b600554331461050f57600080fd5b600480546024358082101561052357600080fd5b80820390509050815550600260043560e05260c052604060c02080546024358082101561054f57600080fd5b808203905090508155506024356101405260006004357fddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef6020610140a3600160005260206000f350005b631652e9fc60005114156105cd5760043560a01c156105b757600080fd5b60055433146105c557600080fd5b600435600555005b63e1430e0660005114156107115760606004356004016101403760406004356004013511156105fb57600080fd5b60406024356004016101c037602060243560040135111561061b57600080fd5b3360206102806004638da5cb5b6102205261023c6005545afa61063d57600080fd5b601f3d1161064a57600080fd5b600050610280511461065b57600080fd5b61014080600060c052602060c020602082510161012060006003818352015b8261012051602002111561068d576106af565b61012051602002850151610120518501555b815160010180835281141561067a575b5050505050506101c080600160c052602060c020602082510161012060006002818352015b826101205160200211156106e757610709565b61012051602002850151610120518501555b81516001018083528114156106d4575b505050505050005b6306fdde0360005114156107ba5760008060c052602060c020610180602082540161012060006003818352015b8261012051602002111561075157610773565b61012051850154610120516020028501525b815160010180835281141561073e575b50505050505061018051806101a001818260206001820306601f82010390500336823750506020610160526040610180510160206001820306601f8201039050610160f350005b6395d89b4160005114156108635760018060c052602060c020610180602082540161012060006002818352015b826101205160200211156107fa5761081c565b61012051850154610120516020028501525b81516001018083528114156107e7575b50505050505061018051806101a001818260206001820306601f82010390500336823750506020610160526040610180510160206001820306601f8201039050610160f350005b6370a08231600051141561089d5760043560a01c1561088157600080fd5b600260043560e05260c052604060c0205460005260206000f350005b63dd62ed3e60005114156108f55760043560a01c156108bb57600080fd5b60243560a01c156108cb57600080fd5b600360043560e05260c052604060c02060243560e05260c052604060c0205460005260206000f350005b6318160ddd60005114156109115760045460005260206000f350005b6307546172600051141561092d5760055460005260206000f350005b5b60006000fd"
        );
        token_ = CurveTokenV3(token);

        minter = token_.minter();
        vm.prank(minter);
        token_.mint(address(this), 1_000_000_000e18);
        assert(token_.balanceOf(address(this)) == 1_000_000_000e18);

        holders = new address[](3);
        holders[0] = address(0x1001);
        holders[1] = address(0x1002);
        holders[2] = address(0x1003);

        for (uint256 i = 0; i < holders.length; i++) {
            address account = holders[i];
            uint256 balance = svm.createUint256("balance");
            token_.transfer(account, balance);
            for (uint256 j = 0; j < i; j++) {
                address other = holders[j];
                uint256 amount = svm.createUint256("amount");
                vm.prank(account);
                token_.approve(other, amount);
            }
        }
    }

    function check_CurveV3NoBackdoor(bytes4 selector, address caller, address other) public {
        vm.assume(caller != minter);
        vm.assume(selector != CurveTokenV3.set_name.selector);
        bytes memory args = svm.createBytes(1024, "data");
        _checkNoBackdoor(selector, args, caller, other);
    }
}
