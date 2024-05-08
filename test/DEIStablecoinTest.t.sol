// SPDX-License-Identifier: AGPL-3.0
pragma solidity >=0.8.0 <0.9.0;

import {SymTest} from "halmos-cheatcodes/SymTest.sol";
import {ERC20Test} from "./ERC20Test.sol";

import {DEIStablecoin} from "../src/DEIStablecoin.sol";

contract EmptyContract {}

contract SymAccount is SymTest {
    fallback(bytes calldata) external payable returns (bytes memory) {
        if (svm.createBool("?")) {
            return svm.createBytes(32, "retdata"); // any primitive return value: bool, address, uintN, bytesN, etc
        } else {
            revert();
        }
    }
}

/// @notice This example shows how to find the DEI token bug exploited by the Deus DAO hack: https://rekt.news/deus-dao-r3kt/
/// @custom:halmos --solver-timeout-assertion 0
contract DEIStablecoinTest is ERC20Test {
    DEIStablecoin token_;
    address lossless;

    /// @custom:halmos --solver-timeout-branching 1000
    function setUp() public override {
        token = address(new EmptyContract());
        // Source of Deployed Bytecode: https://etherscan.io/address/0x63c28e2ff796e1480eb9ac8c3c55dcb9ae7b3df6#code
        vm.etch(
            token,
            hex"608060405234801561001057600080fd5b50600436106102ad5760003560e01c806361086b001161017b578063a9059cbb116100d8578063d547741f1161008c578063dd62ed3e11610071578063dd62ed3e146105fe578063f55c980f14610644578063f851a4401461065757600080fd5b8063d547741f146105e3578063d6e242b8146105f657600080fd5b8063b5c22877116100bd578063b5c228771461059c578063ccfa214f146105af578063d5391393146105bc57600080fd5b8063a9059cbb14610581578063b38fe9571461059457600080fd5b806393310ffe1161012f57806395d89b411161011457806395d89b411461055e578063a217fddf14610566578063a457c2d71461056e57600080fd5b806393310ffe14610538578063936af9111461054b57600080fd5b806370a082311161016057806370a08231146104a957806379cc6790146104df57806391d14854146104f257600080fd5b806361086b00146104825780636e9960c31461048b57600080fd5b80632ecaf6751161022957806339509351116101dd57806342966c68116101c257806342966c68146104475780635b8a194a1461045a5780635f6529a31461046257600080fd5b8063395093511461042157806340c10f191461043457600080fd5b8063313ce5671161020e578063313ce567146103b557806334f6ebf5146103c457806336568abe1461040e57600080fd5b80632ecaf675146103995780632f2ff15d146103a257600080fd5b806323b872dd11610280578063282c51f311610265578063282c51f31461034a5780632b7c9fd6146103715780632baa3c9e1461038657600080fd5b806323b872dd14610314578063248a9ca31461032757600080fd5b806301ffc9a7146102b257806306fdde03146102da578063095ea7b3146102ef57806318160ddd14610302575b600080fd5b6102c56102c0366004612d2f565b610677565b60405190151581526020015b60405180910390f35b6102e2610710565b6040516102d19190612f0e565b6102c56102fd366004612c5c565b6107a2565b6035545b6040519081526020016102d1565b6102c5610322366004612c21565b61087c565b610306610335366004612cf5565b60009081526071602052604090206001015490565b6103067f3c11d16cbaffd01df69ce1c404f6340ee057498f5f00246190ea54220576a84881565b61038461037f366004612e37565b610a3d565b005b610384610394366004612bd5565b610b75565b610306603c5481565b6103846103b0366004612d0d565b610d19565b604051601281526020016102d1565b603e546103e990610100900473ffffffffffffffffffffffffffffffffffffffff1681565b60405173ffffffffffffffffffffffffffffffffffffffff90911681526020016102d1565b61038461041c366004612d0d565b610d43565b6102c561042f366004612c5c565b610df6565b610384610442366004612c5c565b610efd565b610384610455366004612cf5565b610f31565b610384610f3e565b6038546103e99073ffffffffffffffffffffffffffffffffffffffff1681565b610306603d5481565b603b5473ffffffffffffffffffffffffffffffffffffffff166103e9565b6103066104b7366004612bd5565b73ffffffffffffffffffffffffffffffffffffffff1660009081526033602052604090205490565b6103846104ed366004612c5c565b61109d565b6102c5610500366004612d0d565b600091825260716020908152604080842073ffffffffffffffffffffffffffffffffffffffff93909316845291905290205460ff1690565b610384610546366004612c5c565b6110e9565b610384610559366004612c85565b6111f5565b6102e26113dd565b610306600081565b6102c561057c366004612c5c565b6113ec565b6102c561058f366004612c5c565b61158c565b61038461165b565b6103846105aa366004612d6f565b61181f565b603e546102c59060ff1681565b6103067f9f2df0fed2c77648de5860a4cc508cd0818c85b8b8a1ab4ceeef8d981c8956a681565b6103846105f1366004612d0d565b6119b9565b6103846119de565b61030661060c366004612bef565b73ffffffffffffffffffffffffffffffffffffffff918216600090815260346020908152604080832093909416825291909152205490565b610384610652366004612cf5565b611b92565b603b546103e99073ffffffffffffffffffffffffffffffffffffffff1681565b60007fffffffff0000000000000000000000000000000000000000000000000000000082167f7965db0b00000000000000000000000000000000000000000000000000000000148061070a57507f01ffc9a7000000000000000000000000000000000000000000000000000000007fffffffff000000000000000000000000000000000000000000000000000000008316145b92915050565b60606036805461071f90613030565b80601f016020809104026020016040519081016040528092919081815260200182805461074b90613030565b80156107985780601f1061076d57610100808354040283529160200191610798565b820191906000526020600020905b81548152906001019060200180831161077b57829003601f168201915b5050505050905090565b603e546000908390839060ff161561086657603e54610100900473ffffffffffffffffffffffffffffffffffffffff166347abf3be336040517fffffffff0000000000000000000000000000000000000000000000000000000060e084901b16815273ffffffffffffffffffffffffffffffffffffffff9182166004820152908516602482015260448101849052606401600060405180830381600087803b15801561084d57600080fd5b505af1158015610861573d6000803e3d6000fd5b505050505b610871338686611c61565b506001949350505050565b603e5460009084908490849060ff161561094a57603e54610100900473ffffffffffffffffffffffffffffffffffffffff1663379f5c69336040517fffffffff0000000000000000000000000000000000000000000000000000000060e084901b16815273ffffffffffffffffffffffffffffffffffffffff91821660048201528187166024820152908516604482015260648101849052608401600060405180830381600087803b15801561093157600080fd5b505af1158015610945573d6000803e3d6000fd5b505050505b73ffffffffffffffffffffffffffffffffffffffff8716600090815260346020908152604080832033845290915290205485811015610a10576040517f08c379a000000000000000000000000000000000000000000000000000000000815260206004820152602960248201527f4c45524332303a207472616e7366657220616d6f756e7420657863656564732060448201527f616c6c6f77616e6365000000000000000000000000000000000000000000000060648201526084015b60405180910390fd5b610a1b888888611cd0565b610a2f8833610a2a8985612fb4565b611c61565b506001979650505050505050565b6000610a496001611eea565b90508015610a7e57600080547fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff00ff166101001790555b610af7866040518060400160405280600381526020017f44454900000000000000000000000000000000000000000000000000000000008152506040518060400160405280600381526020017f444549000000000000000000000000000000000000000000000000000000000081525088888888612075565b610aff61220d565b610b0a6000866122a6565b8015610b6d57600080547fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff00ff169055604051600181527f7f26b83ff96e1f2b6a682f133852f6798a09c465da95921460cefb38474024989060200160405180910390a15b505050505050565b60385473ffffffffffffffffffffffffffffffffffffffff163373ffffffffffffffffffffffffffffffffffffffff1614610c0c576040517f08c379a000000000000000000000000000000000000000000000000000000000815260206004820152601e60248201527f4c45524332303a204d757374206265207265636f766572792061646d696e00006044820152606401610a07565b603b5473ffffffffffffffffffffffffffffffffffffffff82811691161415610c91576040517f08c379a000000000000000000000000000000000000000000000000000000000815260206004820152601f60248201527f4c45524332303a2043616e6e6f74207365742073616d652061646472657373006044820152606401610a07565b60405173ffffffffffffffffffffffffffffffffffffffff8216907f71614071b88dee5e0b2ae578a9dd7b2ebbe9ae832ba419dc0242cd065a290b6c90600090a2603b80547fffffffffffffffffffffffff00000000000000000000000000000000000000001673ffffffffffffffffffffffffffffffffffffffff92909216919091179055565b600082815260716020526040902060010154610d348161239a565b610d3e83836122a6565b505050565b73ffffffffffffffffffffffffffffffffffffffff81163314610de8576040517f08c379a000000000000000000000000000000000000000000000000000000000815260206004820152602f60248201527f416363657373436f6e74726f6c3a2063616e206f6e6c792072656e6f756e636560448201527f20726f6c657320666f722073656c6600000000000000000000000000000000006064820152608401610a07565b610df282826123a4565b5050565b603e546000908390839060ff1615610eba57603e54610100900473ffffffffffffffffffffffffffffffffffffffff1663cf5961bb336040517fffffffff0000000000000000000000000000000000000000000000000000000060e084901b16815273ffffffffffffffffffffffffffffffffffffffff9182166004820152908516602482015260448101849052606401600060405180830381600087803b158015610ea157600080fd5b505af1158015610eb5573d6000803e3d6000fd5b505050505b33600081815260346020908152604080832073ffffffffffffffffffffffffffffffffffffffff8a16845290915290205461087191908790610a2a908890612f5f565b7f9f2df0fed2c77648de5860a4cc508cd0818c85b8b8a1ab4ceeef8d981c8956a6610f278161239a565b610d3e838361245f565b610f3b3382612554565b50565b60385473ffffffffffffffffffffffffffffffffffffffff163373ffffffffffffffffffffffffffffffffffffffff1614610fd5576040517f08c379a000000000000000000000000000000000000000000000000000000000815260206004820152601e60248201527f4c45524332303a204d757374206265207265636f766572792061646d696e00006044820152606401610a07565b603e5460ff1615611042576040517f08c379a000000000000000000000000000000000000000000000000000000000815260206004820152601b60248201527f4c45524332303a204c6f73736c65737320616c7265616479206f6e00000000006044820152606401610a07565b6000603d819055603e80547fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff001660011790556040517f1ba3b66404043da8297d0b876fa6464f2cb127edfc6626308046d4503028322b9190a1565b33600081815260346020908152604080832073ffffffffffffffffffffffffffffffffffffffff87168452909152902054906110df908490610a2a8585612fb4565b610d3e8383612554565b60385473ffffffffffffffffffffffffffffffffffffffff163373ffffffffffffffffffffffffffffffffffffffff1614611180576040517f08c379a000000000000000000000000000000000000000000000000000000000815260206004820152601e60248201527f4c45524332303a204d757374206265207265636f766572792061646d696e00006044820152606401610a07565b603980547fffffffffffffffffffffffff00000000000000000000000000000000000000001673ffffffffffffffffffffffffffffffffffffffff8416908117909155603a8290556040517f6c591da8da2f6e69746d7d9ae61c27ee29fbe303798141b4942ae2aef54274b190600090a25050565b603e54610100900473ffffffffffffffffffffffffffffffffffffffff163373ffffffffffffffffffffffffffffffffffffffff1614611291576040517f08c379a000000000000000000000000000000000000000000000000000000000815260206004820152601e60248201527f4c45524332303a204f6e6c79206c6f73736c65737320636f6e747261637400006044820152606401610a07565b806000805b828110156113955760008585838181106112d9577f4e487b7100000000000000000000000000000000000000000000000000000000600052603260045260246000fd5b90506020020160208101906112ee9190612bd5565b73ffffffffffffffffffffffffffffffffffffffff8116600090815260336020526040812080549190559091506113258185612f5f565b603e5460405183815291955073ffffffffffffffffffffffffffffffffffffffff610100909104811691908416907fddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef9060200160405180910390a35050808061138d90613084565b915050611296565b50603e54610100900473ffffffffffffffffffffffffffffffffffffffff16600090815260336020526040812080548392906113d2908490612f5f565b909155505050505050565b60606037805461071f90613030565b603e546000908390839060ff16156114b057603e54610100900473ffffffffffffffffffffffffffffffffffffffff1663568c75a9336040517fffffffff0000000000000000000000000000000000000000000000000000000060e084901b16815273ffffffffffffffffffffffffffffffffffffffff9182166004820152908516602482015260448101849052606401600060405180830381600087803b15801561149757600080fd5b505af11580156114ab573d6000803e3d6000fd5b505050505b33600090815260346020908152604080832073ffffffffffffffffffffffffffffffffffffffff8916845290915290205484811015611571576040517f08c379a000000000000000000000000000000000000000000000000000000000815260206004820152602660248201527f4c45524332303a2064656372656173656420616c6c6f77616e63652062656c6f60448201527f77207a65726f00000000000000000000000000000000000000000000000000006064820152608401610a07565b6115803387610a2a8885612fb4565b50600195945050505050565b603e546000908390839060ff161561165057603e54610100900473ffffffffffffffffffffffffffffffffffffffff16631ffb811f336040517fffffffff0000000000000000000000000000000000000000000000000000000060e084901b16815273ffffffffffffffffffffffffffffffffffffffff9182166004820152908516602482015260448101849052606401600060405180830381600087803b15801561163757600080fd5b505af115801561164b573d6000803e3d6000fd5b505050505b610871338686611cd0565b60385473ffffffffffffffffffffffffffffffffffffffff163373ffffffffffffffffffffffffffffffffffffffff16146116f2576040517f08c379a000000000000000000000000000000000000000000000000000000000815260206004820152601e60248201527f4c45524332303a204d757374206265207265636f766572792061646d696e00006044820152606401610a07565b603d5461175b576040517f08c379a000000000000000000000000000000000000000000000000000000000815260206004820152601c60248201527f4c45524332303a205475726e4f6666206e6f742070726f706f736564000000006044820152606401610a07565b42603d5411156117c7576040517f08c379a000000000000000000000000000000000000000000000000000000000815260206004820152601d60248201527f4c45524332303a2054696d65206c6f636b20696e2070726f67726573730000006044820152606401610a07565b603e80547fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff001690556000603d8190556040517f3eb72350c9c7928d31e9ab450bfff2c159434aa4b82658a7d8eae7f109cb4e7b9190a1565b60395473ffffffffffffffffffffffffffffffffffffffff163373ffffffffffffffffffffffffffffffffffffffff16146118b6576040517f08c379a000000000000000000000000000000000000000000000000000000000815260206004820152601960248201527f4c45524332303a204d7573742062652063616e646974617465000000000000006044820152606401610a07565b603a548151602083012014611927576040517f08c379a000000000000000000000000000000000000000000000000000000000815260206004820152601360248201527f4c45524332303a20496e76616c6964206b6579000000000000000000000000006044820152606401610a07565b60395460405173ffffffffffffffffffffffffffffffffffffffff909116907fb94bba6936ec7f75ee931dadf6e1a4d66b43d09b6fa0178fb13df9b77fb5841f90600090a25060398054603880547fffffffffffffffffffffffff000000000000000000000000000000000000000090811673ffffffffffffffffffffffffffffffffffffffff841617909155169055565b6000828152607160205260409020600101546119d48161239a565b610d3e83836123a4565b60385473ffffffffffffffffffffffffffffffffffffffff163373ffffffffffffffffffffffffffffffffffffffff1614611a75576040517f08c379a000000000000000000000000000000000000000000000000000000000815260206004820152601e60248201527f4c45524332303a204d757374206265207265636f766572792061646d696e00006044820152606401610a07565b603d5415611adf576040517f08c379a000000000000000000000000000000000000000000000000000000000815260206004820181905260248201527f4c45524332303a205475726e4f666620616c72656164792070726f706f7365646044820152606401610a07565b603e5460ff16611b4b576040517f08c379a000000000000000000000000000000000000000000000000000000000815260206004820152601c60248201527f4c45524332303a204c6f73736c65737320616c7265616479206f6666000000006044820152606401610a07565b603c54611b589042612f5f565b603d8190556040519081527f6ca688e6e3ddd707280140b2bf0106afe883689b6c74e68cbd517576dd9c245a9060200160405180910390a1565b60385473ffffffffffffffffffffffffffffffffffffffff163373ffffffffffffffffffffffffffffffffffffffff1614611c29576040517f08c379a000000000000000000000000000000000000000000000000000000000815260206004820152601e60248201527f4c45524332303a204d757374206265207265636f766572792061646d696e00006044820152606401610a07565b6040518181527fd3fcf9b3a3c0e56c64bbe7d178c180cd10cc7d1d0f96f76fbf30eaf78829fcd49060200160405180910390a1603c55565b73ffffffffffffffffffffffffffffffffffffffff83811660008181526034602090815260408083209487168084529482529182902085905590518481527f8c5be1e5ebec7d5bd14f71427d1e84f3dd0314c0f7b2291e5b200ac8c7c3b92591015b60405180910390a3505050565b73ffffffffffffffffffffffffffffffffffffffff8316611d73576040517f08c379a000000000000000000000000000000000000000000000000000000000815260206004820152602660248201527f4c45524332303a207472616e736665722066726f6d20746865207a65726f206160448201527f64647265737300000000000000000000000000000000000000000000000000006064820152608401610a07565b73ffffffffffffffffffffffffffffffffffffffff831660009081526033602052604090205481811015611e29576040517f08c379a000000000000000000000000000000000000000000000000000000000815260206004820152602760248201527f4c45524332303a207472616e7366657220616d6f756e7420657863656564732060448201527f62616c616e6365000000000000000000000000000000000000000000000000006064820152608401610a07565b611e338282612fb4565b73ffffffffffffffffffffffffffffffffffffffff8086166000908152603360205260408082209390935590851681529081208054849290611e76908490612f5f565b925050819055508273ffffffffffffffffffffffffffffffffffffffff168473ffffffffffffffffffffffffffffffffffffffff167fddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef84604051611edc91815260200190565b60405180910390a350505050565b60008054610100900460ff1615611fa1578160ff166001148015611f0d5750303b155b611f99576040517f08c379a000000000000000000000000000000000000000000000000000000000815260206004820152602e60248201527f496e697469616c697a61626c653a20636f6e747261637420697320616c72656160448201527f647920696e697469616c697a65640000000000000000000000000000000000006064820152608401610a07565b506000919050565b60005460ff808416911610612038576040517f08c379a000000000000000000000000000000000000000000000000000000000815260206004820152602e60248201527f496e697469616c697a61626c653a20636f6e747261637420697320616c72656160448201527f647920696e697469616c697a65640000000000000000000000000000000000006064820152608401610a07565b50600080547fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff001660ff92909216919091179055600190565b919050565b600054610100900460ff1661210c576040517f08c379a000000000000000000000000000000000000000000000000000000000815260206004820152602b60248201527f496e697469616c697a61626c653a20636f6e7472616374206973206e6f74206960448201527f6e697469616c697a696e670000000000000000000000000000000000000000006064820152608401610a07565b612116338861245f565b8551612129906036906020890190612b18565b50845161213d906037906020880190612b18565b50603b80547fffffffffffffffffffffffff000000000000000000000000000000000000000090811673ffffffffffffffffffffffffffffffffffffffff9687161790915560388054821694861694909417909355603980549093169092556000603a819055603c91909155603d55603e80547fffffffffffffffffffffff0000000000000000000000000000000000000000001661010092909316919091027fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff0016919091176001179055505050565b600054610100900460ff166122a4576040517f08c379a000000000000000000000000000000000000000000000000000000000815260206004820152602b60248201527f496e697469616c697a61626c653a20636f6e7472616374206973206e6f74206960448201527f6e697469616c697a696e670000000000000000000000000000000000000000006064820152608401610a07565b565b600082815260716020908152604080832073ffffffffffffffffffffffffffffffffffffffff8516845290915290205460ff16610df257600082815260716020908152604080832073ffffffffffffffffffffffffffffffffffffffff85168452909152902080547fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff0016600117905561233c3390565b73ffffffffffffffffffffffffffffffffffffffff168173ffffffffffffffffffffffffffffffffffffffff16837f2f8788117e7eff1d82e926ec794901d17c78024a50270940304540a733656f0d60405160405180910390a45050565b610f3b8133612739565b600082815260716020908152604080832073ffffffffffffffffffffffffffffffffffffffff8516845290915290205460ff1615610df257600082815260716020908152604080832073ffffffffffffffffffffffffffffffffffffffff8516808552925280832080547fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff0016905551339285917ff6391f5c32d9c69d2a47ea670b442974b53935d1edc7fd64eb21e047a839171b9190a45050565b73ffffffffffffffffffffffffffffffffffffffff82166124dc576040517f08c379a000000000000000000000000000000000000000000000000000000000815260206004820181905260248201527f4c45524332303a206d696e7420746f20746865207a65726f20616464726573736044820152606401610a07565b80603560008282546124ee9190612f5f565b909155505073ffffffffffffffffffffffffffffffffffffffff82166000818152603360209081526040808320805486019055518481527fddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef910160405180910390a35050565b73ffffffffffffffffffffffffffffffffffffffff82166125f7576040517f08c379a000000000000000000000000000000000000000000000000000000000815260206004820152602160248201527f45524332303a206275726e2066726f6d20746865207a65726f2061646472657360448201527f73000000000000000000000000000000000000000000000000000000000000006064820152608401610a07565b73ffffffffffffffffffffffffffffffffffffffff8216600090815260336020526040902054818110156126ad576040517f08c379a000000000000000000000000000000000000000000000000000000000815260206004820152602260248201527f45524332303a206275726e20616d6f756e7420657863656564732062616c616e60448201527f63650000000000000000000000000000000000000000000000000000000000006064820152608401610a07565b73ffffffffffffffffffffffffffffffffffffffff831660009081526033602052604081208383039055603580548492906126e9908490612fb4565b909155505060405182815260009073ffffffffffffffffffffffffffffffffffffffff8516907fddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef90602001611cc3565b600082815260716020908152604080832073ffffffffffffffffffffffffffffffffffffffff8516845290915290205460ff16610df2576127918173ffffffffffffffffffffffffffffffffffffffff16601461280b565b61279c83602061280b565b6040516020016127ad929190612e8d565b604080517fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0818403018152908290527f08c379a0000000000000000000000000000000000000000000000000000000008252610a0791600401612f0e565b6060600061281a836002612f77565b612825906002612f5f565b67ffffffffffffffff811115612864577f4e487b7100000000000000000000000000000000000000000000000000000000600052604160045260246000fd5b6040519080825280601f01601f19166020018201604052801561288e576020820181803683370190505b5090507f3000000000000000000000000000000000000000000000000000000000000000816000815181106128ec577f4e487b7100000000000000000000000000000000000000000000000000000000600052603260045260246000fd5b60200101907effffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff1916908160001a9053507f780000000000000000000000000000000000000000000000000000000000000081600181518110612976577f4e487b7100000000000000000000000000000000000000000000000000000000600052603260045260246000fd5b60200101907effffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff1916908160001a90535060006129b2846002612f77565b6129bd906001612f5f565b90505b6001811115612aa8577f303132333435363738396162636465660000000000000000000000000000000085600f1660108110612a25577f4e487b7100000000000000000000000000000000000000000000000000000000600052603260045260246000fd5b1a60f81b828281518110612a62577f4e487b7100000000000000000000000000000000000000000000000000000000600052603260045260246000fd5b60200101907effffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff1916908160001a90535060049490941c93612aa181612ffb565b90506129c0565b508315612b11576040517f08c379a000000000000000000000000000000000000000000000000000000000815260206004820181905260248201527f537472696e67733a20686578206c656e67746820696e73756666696369656e746044820152606401610a07565b9392505050565b828054612b2490613030565b90600052602060002090601f016020900481019282612b465760008555612b8c565b82601f10612b5f57805160ff1916838001178555612b8c565b82800160010185558215612b8c579182015b82811115612b8c578251825591602001919060010190612b71565b50612b98929150612b9c565b5090565b5b80821115612b985760008155600101612b9d565b803573ffffffffffffffffffffffffffffffffffffffff8116811461207057600080fd5b600060208284031215612be6578081fd5b612b1182612bb1565b60008060408385031215612c01578081fd5b612c0a83612bb1565b9150612c1860208401612bb1565b90509250929050565b600080600060608486031215612c35578081fd5b612c3e84612bb1565b9250612c4c60208501612bb1565b9150604084013590509250925092565b60008060408385031215612c6e578182fd5b612c7783612bb1565b946020939093013593505050565b60008060208385031215612c97578182fd5b823567ffffffffffffffff80821115612cae578384fd5b818501915085601f830112612cc1578384fd5b813581811115612ccf578485fd5b8660208260051b8501011115612ce3578485fd5b60209290920196919550909350505050565b600060208284031215612d06578081fd5b5035919050565b60008060408385031215612d1f578182fd5b82359150612c1860208401612bb1565b600060208284031215612d40578081fd5b81357fffffffff0000000000000000000000000000000000000000000000000000000081168114612b11578182fd5b600060208284031215612d80578081fd5b813567ffffffffffffffff80821115612d97578283fd5b818401915084601f830112612daa578283fd5b813581811115612dbc57612dbc6130ec565b604051601f82017fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0908116603f01168101908382118183101715612e0257612e026130ec565b81604052828152876020848701011115612e1a578586fd5b826020860160208301379182016020019490945295945050505050565b600080600080600060a08688031215612e4e578081fd5b85359450612e5e60208701612bb1565b9350612e6c60408701612bb1565b925060608601359150612e8160808701612bb1565b90509295509295909350565b7f416363657373436f6e74726f6c3a206163636f756e7420000000000000000000815260008351612ec5816017850160208801612fcb565b7f206973206d697373696e6720726f6c65200000000000000000000000000000006017918401918201528351612f02816028840160208801612fcb565b01602801949350505050565b6020815260008251806020840152612f2d816040850160208701612fcb565b601f017fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0169190910160400192915050565b60008219821115612f7257612f726130bd565b500190565b6000817fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff0483118215151615612faf57612faf6130bd565b500290565b600082821015612fc657612fc66130bd565b500390565b60005b83811015612fe6578181015183820152602001612fce565b83811115612ff5576000848401525b50505050565b60008161300a5761300a6130bd565b507fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff0190565b600181811c9082168061304457607f821691505b6020821081141561307e577f4e487b7100000000000000000000000000000000000000000000000000000000600052602260045260246000fd5b50919050565b60007fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff8214156130b6576130b66130bd565b5060010190565b7f4e487b7100000000000000000000000000000000000000000000000000000000600052601160045260246000fd5b7f4e487b7100000000000000000000000000000000000000000000000000000000600052604160045260246000fdfea264697066735822122086360fa7ed2700fdfaa6056f800b19c6d5f302048602c99f8f1c57c70ff5b08464736f6c63430008040033"
        );
        token_ = DEIStablecoin(token);

        lossless = address(new SymAccount());
        token_.initialize(1_000_000_000e18, address(this), address(this), 0, lossless);
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

    function check_DEI_NoBackdoor(bytes4 selector, address caller, address other) public {
        bytes memory args;
        if (selector == token_.acceptRecoveryAdminOwnership.selector) {
            args = abi.encode(svm.createBytes(32, "data"));
        } else if (selector == token_.transferOutBlacklistedFunds.selector) {
            vm.assume(caller != lossless); // lossless can transfer any
            address[] memory from = new address[](1);
            from[0] = svm.createAddress("from");
            args = abi.encode(from);
        } else {
            args = svm.createBytes(1024, "data");
        }
        _checkNoBackdoor(selector, args, caller, other);
    }
}
