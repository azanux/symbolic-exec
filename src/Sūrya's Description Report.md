 Sūrya's Description Report

 Files Description Table


|  File Name  |  SHA-1 Hash  |
|-------------|--------------|
| /Users/azanux/Desktop/hacking/code/testing/symbolic-exec/src/OpenZeppelinERC20.sol | d79149b8764da0731678c79e2976f8a0361a0050 |
| /Users/azanux/Desktop/hacking/code/testing/symbolic-exec/test/CodeTest.t.sol | 58979a5ca2f98cf8afe7c352d5bfe2841f2e69ea |
| /Users/azanux/Desktop/hacking/code/testing/symbolic-exec/src/Code.sol | d9d2b03fe3b5cab99b1255b315a27c78f09340f5 |
| /Users/azanux/Desktop/hacking/code/testing/symbolic-exec/src/PostExample.sol | 52ecea7e4d810aea0c29f140696a48ca2204796f |
| /Users/azanux/Desktop/hacking/code/testing/symbolic-exec/src/BuggyPrice.sol | f221ceb39d58cd169e3f6324c6093190273dc718 |
| /Users/azanux/Desktop/hacking/code/testing/symbolic-exec/test/BuggyPriceTest.t.sol | 06bf07af1d38f0bb4950cf635b6a2faef9378efb |
| /Users/azanux/Desktop/hacking/code/testing/symbolic-exec/src/Token.sol | 4d6f5323cec5ce2f12c9f642e80b9fca7fca1cea |
| /Users/azanux/Desktop/hacking/code/testing/symbolic-exec/test/ERC20Test.sol | 9c6a9f1b11c80f5a363885fc64d62aa4003d275a |
| /Users/azanux/Desktop/hacking/code/testing/symbolic-exec/test/OpenZeppelinERC20Test.t.sol | b854e971976792e944b7702e09a6df40a60bb1ea |
| /Users/azanux/Desktop/hacking/code/testing/symbolic-exec/test/halmos/TokenTest.t.sol | ea7810cce6e1eab20d0d0da37acccc55595a9468 |


 Contracts Description Table


|  Contract  |         Type        |       Bases      |                  |                 |
|:----------:|:-------------------:|:----------------:|:----------------:|:---------------:|
|     └      |  **Function Name**  |  **Visibility**  |  **Mutability**  |  **Modifiers**  |
||||||
| **OpenZeppelinERC20** | Implementation | ERC20 |||
| └ | <Constructor> | Public ❗️ | 🛑  | ERC20 |
||||||
| **CodeTest** | Implementation | Test |||
| └ | setUp | Public ❗️ | 🛑  |NO❗️ |
| └ | test_check_withdraw | Public ❗️ | 🛑  |NO❗️ |
| └ | test_withdraw | Public ❗️ | 🛑  |NO❗️ |
| └ | test_withdraw_ko | Public ❗️ | 🛑  |NO❗️ |
||||||
| **Code** | Implementation |  |||
| └ | <Constructor> | Public ❗️ |  💵 |NO❗️ |
| └ | withdraw | Public ❗️ | 🛑  |NO❗️ |
| └ | balance | Public ❗️ |   |NO❗️ |
||||||
| **PostExample** | Implementation |  |||
| └ | backdoor | External ❗️ | 🛑  |NO❗️ |
||||||
| **BuggyPrice** | Implementation |  |||
| └ | totalPriceBuggy | Public ❗️ |   |NO❗️ |
||||||
| **BuggyPriceTest** | Implementation | Test |||
| └ | setUp | Public ❗️ | 🛑  |NO❗️ |
| └ | test_check_TotalPriceBuggy | Public ❗️ |   |NO❗️ |
| └ | test_TotalPriceBuggy | Public ❗️ |   |NO❗️ |
| └ | test_TotalPriceBuggyOther | Public ❗️ |   |NO❗️ |
||||||
| **Token** | Implementation |  |||
| └ | <Constructor> | Public ❗️ | 🛑  |NO❗️ |
| └ | transfer | Public ❗️ | 🛑  |NO❗️ |
| └ | _transfer | Public ❗️ | 🛑  |NO❗️ |
||||||
| **ERC20Test** | Implementation | SymTest, Test |||
| └ | setUp | Public ❗️ | 🛑  |NO❗️ |
| └ | _checkNoBackdoor | Public ❗️ | 🛑  |NO❗️ |
| └ | check_transfer | Public ❗️ | 🛑  |NO❗️ |
| └ | check_transferFrom | Public ❗️ | 🛑  |NO❗️ |
||||||
| **OpenZeppelinERC20Test** | Implementation | ERC20Test |||
| └ | setUp | Public ❗️ | 🛑  |NO❗️ |
| └ | check_NoBackdoor | Public ❗️ | 🛑  |NO❗️ |
||||||
| **TokenTest** | Implementation | SymTest, Test |||
| └ | setUp | Public ❗️ | 🛑  |NO❗️ |
| └ | test_check_BalanceUpdate | Public ❗️ | 🛑  |NO❗️ |


 Legend

|  Symbol  |  Meaning  |
|:--------:|-----------|
|    🛑    | Function can modify state |
|    💵    | Function is payable |
