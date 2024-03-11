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

## Foundry

## Halmos
Run Halmos to find counterExemple.

```shell
halmos --function test_check_TotalPriceBuggy 
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


