# Formal Verification

## Installation
 - OpenZeppelin : https://github.com/OpenZeppelin/openzeppelin-contracts
 ```shell
 forge install OpenZeppelin/openzeppelin-contracts@v4.9.4 --no-commit
 ```
 - Halmos Cheat Codes : https://github.com/a16z/halmos-cheatcodes

 ```shell
 forge install a16z/halmos-cheatcodes --no-commit
 ```

## Compile the program
We need to build the code source with some parameter if we want to use halmos, because the new version of foundry/forge dont generate ast anymore

```shell
forge build --build-info
```


# BuggyPriceTest
The contract BuggyPrice contain a bug because the casting is not good, we cast uint120 to uint128

## Fuzzing wizh foundry 
We will run fuzzing to see if the contract discover the bug 
it is possible to change the parameter in the file foundry.toml with runs = 10000

Run the fuzzing test
```shell
forge test --mt test_total_fuzz
```

Avec le parametre runs = 10000, il n y pas d'erreur , cependant avec le parametre runs = 100000 , nous avons une erreur
 avec comme argument 39614081294025656978550816767 et 1073741824

```shell
Compiler run successful!
proptest: Saving this and future failures in cache/fuzz/failures
proptest: If this test was run on a CI system, you may wish to add the following line to your copy of the file. (You may need to create it.)
cc 5b1b8e2f0443c0a679d8a43b28038902297936c1b8c4c0dc55c6a11ca986ec57

Ran 1 test for test/BuggyPriceTest.t.sol:BuggyPriceTest
[FAIL. Reason: panic: assertion failed (0x01); counterexample: calldata=0xb7c7b86800000000000000000000000000000000000000008000000200000007ffffffff0000000000000000000000000000000000000000000000000000000040000000 args=[39614081294025656978550816767 [3.961e28], 1073741824 [1.073e9]]] test_total_fuzz(uint96,uint32) (runs: 35386, μ: 5894, ~: 5897)
Suite result: FAILED. 0 passed; 1 failed; 0 skipped; finished in 1.75s (1.75s CPU time)

Ran 1 test suite in 1.75s (1.75s CPU time): 0 tests passed, 1 failed, 0 skipped (1 total tests)

Failing tests:
Encountered 1 failing test in test/BuggyPriceTest.t.sol:BuggyPriceTest
[FAIL. Reason: panic: assertion failed (0x01); counterexample: calldata=0xb7c7b86800000000000000000000000000000000000000008000000200000007ffffffff0000000000000000000000000000000000000000000000000000000040000000 args=[39614081294025656978550816767 [3.961e28], 1073741824 [1.073e9]]] test_total_fuzz(uint96,uint32) (runs: 35386, μ: 5894, ~: 5897)
```

Maintenant que nous avons les valeurs, nous allons créer un autre fonction de test avec les valeurs problématiques
```shell
forge test --mt test_TotalPriceBuggyOther
```
 Le test échoue bien évidemment

 ```shell
 forge test --mt test_TotalPriceBuggyOther
[⠒] Compiling...
[⠆] Compiling 1 files with 0.8.24
[⠰] Solc 0.8.24 finished in 1.18s
Compiler run successful!

Ran 1 test for test/BuggyPriceTest.t.sol:BuggyPriceTest
[FAIL. Reason: panic: assertion failed (0x01)] test_TotalPriceBuggyOther() (gas: 5800)
Suite result: FAILED. 0 passed; 1 failed; 0 skipped; finished in 379.58µs (37.46µs CPU time)

Ran 1 test suite in 145.02ms (379.58µs CPU time): 0 tests passed, 1 failed, 0 skipped (1 total tests)

Failing tests:
Encountered 1 failing test in test/BuggyPriceTest.t.sol:BuggyPriceTest
[FAIL. Reason: panic: assertion failed (0x01)] test_TotalPriceBuggyOther() (gas: 5800)

Encountered a total of 1 failing tests, 0 tests succeeded
 ```

 
## Halmos
Run Halmos to find counterExemple.
The test program is the same as fuzzing program

```shell
halmos --function check_TotalPriceBuggy 
```

halmos find directly the values that could make the program bugg
```shell
halmos --function check_totalPrice_test
[⠊] Compiling...
No files changed, compilation skipped

Running 1 tests for test/BuggyPriceTest.t.sol:BuggyPriceTest
Counterexample: 
    p_price_uint96 = 0x00000000000000000000000000000000000000008d053276c2dc52b1147eaf7a (43643669322988860674796334970)
    p_quantity_uint32 = 0x0000000000000000000000000000000000000000000000000000000063d80200 (1675100672)
[FAIL] check_totalPrice_test(uint96,uint32) (paths: 5, time: 0.26s, bounds: [])
Symbolic test result: 0 passed; 1 failed; time: 0.30s
```

# CodeTest
The contract Code hold Ether and you have to guess the password to withdraw it
When call the function withdraw , you need to supply a number , if the number is good it withdraw the ether to the user

### Fuzzing
We will run a fuzzing on test function to find the value

```shell
forge test --mt test_check_withdraw
```
the fuzz test find the value 25
```shell
Ran 1 test for test/CodeTest.t.sol:CodeTest
[FAIL. Reason: panic: assertion failed (0x01); counterexample: calldata=0xcc5b16360000000000000000000000000000000000000000000000000000000000000019 args=[25]] test_check_withdraw(uint256) (runs: 31, μ: 13239, ~: 13239)
Suite result: FAILED. 0 passed; 1 failed; 0 skipped; finished in 7.95ms (2.63ms CPU time)
```

## halmos
we will use halmos to find where the program can be break
```shell
halmos --function check_withdraw
```
Halmos break the programm and find the value that break the function

```shell
No files changed, compilation skipped

Running 1 tests for test/CodeTest.t.sol:CodeTest
Counterexample: 
    p_x_uint256 = 0x0000000000000000000000000000000000000000000000000000000000000019 (25)
[FAIL] check_withdraw(uint256) (paths: 3, time: 0.07s, 
```

## test
The last test use the value 25 and see if the programm really failed
```shell
forge test --mt test_fail_withdraw
```

Il y a bien une erreur, la valeur de la balance du contract 0 devrait être différent de 0 mais elle ne l'est pas
```shell
Ran 1 test for test/CodeTest.t.sol:CodeTest
[FAIL. Reason: panic: assertion failed (0x01)] test_fail_withdraw() (gas: 48997)
Suite result: FAILED. 0 passed; 1 failed; 0 skipped; finished in 1.42ms (1.10ms CPU time)

Ran 1 test suite in 152.89ms (1.42ms CPU time): 0 tests passed, 1 failed, 0 skipped (1 total tests)

Failing tests:
Encountered 1 failing test in test/CodeTest.t.sol:CodeTest
[FAIL. Reason: panic: assertion failed (0x01)] test_fail_withdraw() (gas: 48997)
```

# Counter
The contract is counter that increment the value set , except when the value set is 3456827547395746354 ,the program reset to 0
We need to find the value that break the invariant

## Fuzz
We run the fuzzer with run = 10000, the fuzzer break the invariant, and find the good value : 3456827547395746354
```shell
forge test --mt test_Fuzz_SetNumber 

---------------------------------------------------------------------------------
Ran 1 test for test/Counter.t.sol:CounterTest
[FAIL. Reason: assertion failed; counterexample: calldata=0xed58433b0000000000000000000000000000000000000000000000002ff91e56dc4eea32 args=[3456827547395746354 [3.456e18]]] test_Fuzz_SetNumber(uint256) (runs: 1259, μ: 28247, ~: 28421)
Suite result: FAILED. 0 passed; 1 failed; 0 skipped; finished in 34.99ms (34.71ms CPU time)

Ran 1 test suite in 196.13ms (34.99ms CPU time): 0 tests passed, 1 failed, 0 skipped (1 total tests)

Failing tests:
Encountered 1 failing test in test/Counter.t.sol:CounterTest
[FAIL. Reason: assertion failed; counterexample: calldata=0xed58433b0000000000000000000000000000000000000000000000002ff91e56dc4eea32 args=[3456827547395746354 [3.456e18]]] test_Fuzz_SetNumber(uint256) (runs: 1259, μ: 28247, ~: 28421)

Encountered a total of 1 failing tests, 0 tests succeeded
```

## Halmos
We will try to break the invariant using Halmos , and halmos manage to find the value that break the invariant
```shell
halmos --function check_counter

---------------------------------------------------------------------------------
Running 1 tests for test/Counter.t.sol:CounterTest
Counterexample: 
    p_x_uint256 = 0x0000000000000000000000000000000000000000000000002ff91e56dc4eea32 (3456827547395746354)
[FAIL] chek_Fuzz_SetNumber(uint256) (paths: 2, time: 0.07s, bounds: [])
Symbolic test result: 0 passed; 1 failed; time: 0.12s
```

# PostExample
This Smart Contract have a backdoor with x as parameter in his function backdoor that will reset the value of number.
numnber should not never be equal to 0
We will try to find the value x that will break the invariant

## Fuzzer
we will use a fuzzer to test all value to break the invariant , the fuzzer manage to break the invariant by finding the value : 6912213124124532
```shell
forge test --mt test_check_Backdoor

---------------------------------------------------------------------------------
[FAIL. Reason: panic: assertion failed (0x01); counterexample: calldata=0x30baa0d600000000000000000000000000000000000000000000000000188e9f07e00f74 args=[6912213124124532 [6.912e15]]] test_check_Backdoor(uint256) (runs: 86, μ: 28478, ~: 28478)
Suite result: FAILED. 0 passed; 1 failed; 0 skipped; finished in 8.63ms (4.01ms CPU time)

Ran 1 test suite in 173.19ms (8.63ms CPU time): 0 tests passed, 1 failed, 0 skipped (1 total tests)

Failing tests:
Encountered 1 failing test in test/PostExampleTest.t.sol:PostExampleTest
[FAIL. Reason: panic: assertion failed (0x01); counterexample: calldata=0x30baa0d600000000000000000000000000000000000000000000000000188e9f07e00f74 args=[6912213124124532 [6.912e15]]] test_check_Backdoor(uint256) (runs: 86, μ: 28478, ~: 28478)

Encountered a total of 1 failing tests, 0 tests succeeded
```

## Halmos

we will use Halmos to break the invariant
```shell
halmos --function check_Backdoor
Running 1 tests for test/PostExampleTest.t.sol:PostExampleTest
Counterexample: 
    p_x_uint256 = 0x00000000000000000000000000000000000000000000000000188e9f07e00f74 (6912213124124532)
[FAIL] check_Backdoor(uint256) (paths: 2, time: 0.04s, bounds: [])
Symbolic test result: 0 passed; 1 failed; time: 0.07s
```

# Token
This Smart Contract is a token, it will allow you to transfer token to another address
 * We will try to find some value that break the invariant of the contract
 * A caller can't transfer anothe token
 * But the _transfer function is public so the call will be able to transfer other user token

 # Halmos
 We will use Halmos to break the invariant stating that when the caller doesn't call transfer function
 his balnce should not increase ans dthe balance of another user should not decrease
 ```shell
halmos --function checkBalanceUpdate --solver-timeout-assertion 0  

Running 1 tests for test/TokenTest.t.sol:TokenTest
Counterexample: 
    halmos_amount_uint256_02 = 0x0000000000000000000000000000000000000000013a7e3c9fd0803ce8000000 (380198843856324804992827392)
    halmos_amount_uint256_04 = 0x00000000000000000000000000000000000000000000c0000000000000000000 (906694364710971881029632)
    halmos_amount_uint256_06 = 0x00000000000000000000000000000000000000000000004000000000000ebf86 (1180591620717412269958)
    halmos_caller_address_07 = 0x0000000000000000000000400000000000000000
    halmos_data_bytes_09 = 0x30e0789e00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000000000000000000000000000000000000000000000000000000037fc900000307d7f7e (100 bytes)
    halmos_others_address_08 = 0x0000000000000000000000000000000000000000
    halmos_receiver_address_01 = 0x0000000000000000000000000080000000000000
    halmos_receiver_address_03 = 0x0000000000000000000000400000000000000000
    halmos_receiver_address_05 = 0x0000000000000000000000000000000000000000
```

## Test
We will test using the method Halmos use to find the problem (TokenFuzzTest.t.sol)

```shell
forge test --mt test_checkBalanceUpdate 

Ran 1 test for test/TokenFuzzTest.t.sol:TokenTest
[FAIL. Reason: panic: assertion failed (0x01)] test_checkBalanceUpdate() (gas: 42417)
Suite result: FAILED. 0 passed; 1 failed; 0 skipped; finished in 849.71µs (48.08µs CPU time)

Ran 1 test suite in 146.72ms (849.71µs CPU time): 0 tests passed, 1 failed, 0 skipped (1 total tests)

Failing tests:
Encountered 1 failing test in test/TokenFuzzTest.t.sol:TokenTest
```


# MyToken
This contrat is an ERC20 Token , we will try to find some value that break the invariant of the contract
Invariant is when a sender transfer token to a receiver the balance of the sender will decrease and the balance of the receiver will increase by amount

## Fuzz
We will use fuzing to find somne value that break invariant , we find that when sender and receiver = 0x0000000000000000000000000000000000000001 , we break the invariant
```shell
forge test --mt test_transfer
[⠊] Compiling...
[⠘] Compiling 1 files with 0.8.17
[⠃] Solc 0.8.17 finished in 1.74s
Compiler run successful!
proptest: Saving this and future failures in cache/fuzz/failures
proptest: If this test was run on a CI system, you may wish to add the following line to your copy of the file.
cc 1c292f8a4439daadc1e7d3ff15330a97df1c1b7e5e3a6970e39a064d7e17e6af

Ran 1 test for test/MyToken.t.sol:MyTokenFuzzTest
[FAIL. Reason: panic: assertion failed (0x01); counterexample: calldata=0x4406296b000000000000000000000000000000000000000000000000000000000000000100000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000000000000000000000000000000000000001 args=[0x0000000000000000000000000000000000000001, 0x0000000000000000000000000000000000000001, 1]] test_transfer(address,address,uint256) (runs: 68, μ: 207335, ~: 208276)
Suite result: FAILED. 0 passed; 1 failed; 0 skipped; finished in 101.98ms (100.77ms CPU time)

Ran 1 test suite in 248.82ms (101.98ms CPU time): 0 tests passed, 1 failed, 0 skipped (1 total tests)

Failing tests:
Encountered 1 failing test in test/MyToken.t.sol:MyTokenFuzzTest
[FAIL. Reason: panic: assertion failed (0x01); counterexample: calldata=0x4406296b000000000000000000000000000000000000000000000000000000000000000100000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000000000000000000000000000000000000001 args=[0x0000000000000000000000000000000000000001, 0x0000000000000000000000000000000000000001, 1]] test_transfer(address,address,uint256) (runs: 68, μ: 207335, ~: 208276)

```

# Halmos
We use Halmos to break the invariant now, we notice that halmos find values that breack invariant too
when address of sender = receiver  (0x00000000000000000000000000000000aaaa0001)


```shell
 halmos --function halmos --function check_MyToken_transfer

 Running 1 tests for test/MyToken.t.sol:MyTokenTest
Counterexample: 
    halmos_initialSupply_uint256_01 = 0xc0000000a040010c8080900400800a3244808090295802400000000000002000 (86844066944863442992978657723153227526379234827954262748013478382107197710336)
    p_amount_uint256 = 0x2cfbfebe5ffdfff95d5f6ff9fc7f73ad09213f6f9aafe90bf500202000000000 (20347002126994204323227851760517155306486346144054837729429966200417900560384)
    p_receiver_address = 0x00000000000000000000000000000000aaaa0001
    p_sender_address = 0x00000000000000000000000000000000aaaa0001
[FAIL] check_MyToken_transfer(address,address,uint256) (paths: 8, time: 1.13s, bounds: [])
Symbolic test result: 0 passed; 1 failed; time: 1.69s
```

# OpenZeppelinERC20
The contract is an ERC20 based on Openzeppelin , we will use Halmos to break the invariant
we have 2 invariants 
 - // ensure that the caller cannot spend other' tokens without approvals
 - // ensure that the call after nay call can't have more token after the call 
 We add a bugg in the contract that automatically mint token for the caller, we will se if Halmos can find this bug

 ## Halmos Allowance
 In this part we will ensure that the caller cannot spend other' tokens without approvals,
 Halmos didn't break the invariant 
 ```shell
  halmos --function check_NoBackdoor

  Running 1 tests for test/OpenZeppelinERC20Test.t.sol:OpenZeppelinERC20Test
Warning: multiple paths were found in setUp(); an arbitrary path has been selected for the following tests.
[PASS] check_NoBackdoor(bytes4,address,address) (paths: 33, time: 6.81s, bounds: [])
Symbolic test result: 1 passed; 0 failed; time: 16.58s
 ```
  ## Halmos transfer
 - // ensure that the call after nay call can't have more token after the call 
 We add a bugg in the contract that automatically mint 1 ether token for the caller, we will see if Halmos can find this bug.
 Halmos break the invariant by finding values that can break the invariant

 ```shell
 halmos --function check_transfer

Running 2 tests for test/OpenZeppelinERC20Test.t.sol:OpenZeppelinERC20Test
Warning: multiple paths were found in setUp(); an arbitrary path has been selected for the following tests.
Counterexample: 
    halmos_amount_uint256_03 = 0x0000000000000000000000000000000000000000000000000000000000000000 (0)
    halmos_amount_uint256_05 = 0x0000000000000000000000000000000000000000000000000000000000000000 (0)
    halmos_amount_uint256_06 = 0x0000000000000000000000000000000000000000000000000000000000000000 (0)
    halmos_balance_uint256_01 = 0x000000000000000000000000000000000000000000000000000000010e700000 (4537188352)
    halmos_balance_uint256_02 = 0x0000000000000000000000000000000000000000000000000000000050000000 (1342177280)
    halmos_balance_uint256_04 = 0x0000000000000000000000000000000000000000000000000000000116000000 (4664066048)
    p_amount_uint256 = 0x000000000000000000000000000000000000000000000000000000001ff7ffff (536346623)
    p_other_address = 0x0000000000000000000000000000000000000000
    p_receiver_address = 0x0000000000000000000000000000000000000001
    p_sender_address = 0x0000000000000000000000000000000000001003
Counterexample: 
    halmos_amount_uint256_03 = 0x0000000000000000000000000000000000000000000000000000000000000000 (0)
    halmos_amount_uint256_05 = 0x0000000000000000000000000000000000000000000000000000000000000000 (0)
    halmos_amount_uint256_06 = 0x0000000000000000000000000000000000000000000000000000000000000000 (0)
    halmos_balance_uint256_01 = 0x0000000000000000000000000000000000000000000000000000000076500000 (1984954368)
    halmos_balance_uint256_02 = 0x0000000000000000000000000000000000000000000000000000000080000000 (2147483648)
    halmos_balance_uint256_04 = 0x0000000000000000000000000000000000000000000000000000000080000000 (2147483648)
    p_amount_uint256 = 0x0000000000000000000000000000000000000000000000000000000040000000 (1073741824)
    p_other_address = 0x0000000000000000000000000000000000000000
    p_receiver_address = 0x0000000000000000000000080000000000000000
    p_sender_address = 0x0000000000000000000000080000000000000000
[FAIL] check_transfer(address,address,address,uint256) (paths: 34, time: 3.51s, bounds: [])
 ```

# DEIStableCoin
This contract is realated to DEUSDAO Hack , where Token holders lost a total of ~$6.5M on Arbitrum, BSC and Etherum, and the DEI stablecoin depegged over 80%.

A simple implementation error was introduced into the DEI token contract, in an upgrade last month. The burnFrom function was misconfigured, with the ‘_allowances’ parameters ‘msgSender’ and ‘account’ written into the contract in the wrong order.
The mis-ordered parameters allow the attacker to set a large token approval for any DEI holder’s address. Then, by burning 0 tokens from the address, the approval is updated to the attacker’s address, who can drain the holder’s funds.
This is the attack , when we see that the function burnFrom give allowance to the caller
1 -identify an address with a huge amount of DEI
2 - approve to this address
3 - call burnFrom with amount = 0 and this address
4 - During the burnFrom it grants approves all tokens from the address to your own
5 - call transferFrom

```shell
halmos --function check_DEI_NoBackdoor 

Running 1 tests for test/DEIStablecoinTest.t.sol:DEIStablecoinTest
Counterexample: 
    halmos_?_bool_02 = true
    halmos_?_bool_05 = true
    halmos_?_bool_08 = true
    halmos_?_bool_11 = true
    halmos_?_bool_14 = true
    halmos_?_bool_17 = true
    halmos_amount_uint256_07 = 0x0000000000000000000000000000000000000000000000000000000000000000 (0)
    halmos_amount_uint256_13 = 0x0000000000000000000000000000000000000000000800000000000000000000 (9671406556917033397649408)
    halmos_amount_uint256_16 = 0x0000000000000000000000000000000000000000000000000000000000000000 (0)
    halmos_balance_uint256_01 = 0x0000000000000000000000000000000000000000000000000000000010000000 (268435456)
    halmos_balance_uint256_04 = 0x0000000000000000000000000000000000000000005fc0000040000000000000 (115754647246115141987598336)
    halmos_balance_uint256_10 = 0x000000000000000000000000000000000000000000fbbfffffc0000000000000 (304347075069968496222797824)
    halmos_data_bytes_19 = 0x0000000000000000000000000000000000000000000000000000000000001001000000000000000000000000000000000000000000000000000000000ffffffe000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000 (1024 bytes)
    p_caller_address = 0x0000000000000000000000000000000000001003
    p_other_address = 0x0000000000000000000000000000000000001001
    p_selector_bytes4 = 0x79cc679000000000000000000000000000000000000000000000000000000000
[FAIL] check_DEI_NoBackdoor(bytes4,address,address) (paths: 51, time: 45.65s, bounds: [])
Symbolic test result: 0 passed; 1 failed; time: 50.74s
```

We see that a call to brunFrom breack the invariant
```shell
cast 4byte 0x79cc6790

burnFrom(address,uint256)
```

# OpenZeppelinERC721
Ce contract est semblable a celui de ERc20 mais concerne ERC721 
Il vise a s'assurer que tous les invariants sont respectés. a savoir :


Check if we don't have allowance
```shell
halmos --function check_ERC721NoBackdoor


Running 1 tests for test/OpenZeppelinERC721Test.t.sol:OpenZeppelinERC721Test
[PASS] check_ERC721NoBackdoor(bytes4) (paths: 50, time: 11.58s, bounds: [])
WARNING:Halmos:check_ERC721NoBackdoor(bytes4): unknown calls have been assumed to be static: 0x150b7a02
(see https://github.com/a16z/halmos/wiki/warnings#uninterpreted-unknown-calls)
Symbolic test result: 1 passed; 0 failed; time: 13.06s
```

Check if the caller don't have more 
```shell
halmos --function check_ERC721_transferFrom

Running 1 tests for test/OpenZeppelinERC721Test.t.sol:OpenZeppelinERC721Test
[PASS] check_ERC721_transferFrom(address,address,address,address,uint256,uint256) (paths: 105, time: 28.21s, bounds: [])
WARNING:Halmos:check_ERC721_transferFrom(address,address,address,address,uint256,uint256): unknown calls have been assumed to be static: 0x150b7a02
(see https://github.com/a16z/halmos/wiki/warnings#uninterpreted-unknown-calls)
Symbolic test result: 1 passed; 0 failed; time: 29.77s

```


## Ityfuzz

Run ityfuzz

```shell
ityfuzz evm -m test/CodeTest.sol:CodeTest -- forge test --mt test_check_withdraw

ityfuzz evm -m test/BuggyPriceTest.t.sol:BuggyPriceTest -- forge test --mt test_check_TotalPriceBuggy
```