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
halmos --function chek_Fuzz_SetNumber 

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









Run halmos to find conterExample
```shell
 halmos --function test_check_BalanceUpdate  --solver-timeout-assertion 0
 ```

## Ityfuzz

Run ityfuzz

```shell
ityfuzz evm -m test/CodeTest.sol:CodeTest -- forge test --mt test_check_withdraw

ityfuzz evm -m test/BuggyPriceTest.t.sol:BuggyPriceTest -- forge test --mt test_check_TotalPriceBuggy
````


