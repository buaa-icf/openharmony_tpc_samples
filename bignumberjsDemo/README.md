# bignumberjsDemo

## Introduction
This project is an OpenHarmony development example based on the [bignumber.js](https://github.com/MikeMcl/bignumber.js) library, a JavaScript library for arbitrary-precision decimal and non-decimal arithmetic.

## How to Install
```
ohpm install bignumber.js
```
For details about the OpenHarmony ohpm environment configuration, see [OpenHarmony HAR](https://gitcode.com/openharmony-tpc/docs/blob/master/OpenHarmony_har_usage.en.md).
## How to Use
If the package name **bignumber.js** with the .js extension is not supported, see [Example](./entry/src/main/ets/pages) for the solution.
```javascript
import BigNumber from "bignumber.js"
let x = new BigNumber('1111222233334444555566');
x.toString();                       // "1.111222233334444555566e+21"
x.toFixed();                        // "1111222233334444555566"
let x = new BigNumber('1111222233334444555566');
x.toString();                       // "1.111222233334444555566e+21"
x.toFixed();                        // "1111222233334444555566"
```

## Available APIs

|          API         |         Parameter         |       Description      |
| :----------------------- | :-------------------- | :------------------- |
|     absoluteValue()      | N/A |      Returns the absolute value.     |
|     comparedTo(data)     |  **data**: number to compare  |       Compares this number to another number.      |
|   decimalPlaces(data)    |  **data**: number of decimal places |    Returns the number of decimal places.   |
|     dividedBy(data)      |    **data**: divisor    |       Divides this number by another number.      |
| dividedToIntegerBy(data) |     **data**: divisor    | Divides this number by another number and returns the integer part.|
|  exponentiatedBy(data)   | **data**: number of decimal places to retain	 |       Raises this number to a power.      |
|    integerValue(data)    | **data**: rounding method (up or down)|       Rounds this number to an integer.      |
|       minus(data)        |    **data**: subtractend    |       Subtracts a number from this number.      |
|       modulo(data)       |     **data**: divisor    |        Calculates the remainder of this number divided by another.       |
|        plus(data)        |    **data**: addend    |       Adds a number to this number.      |
|     shiftedBy(data)      |  **data**: number of bits to shift  |    Shifts the bits of this number.   |
|       squareRoot()       | N/A |      Calculates the square root of this number.     |

For details, see the [Official Documentation](https://mikemcl.github.io/bignumber.js/) and [Unit Test Cases](https://gitcode.com/openharmony-tpc/openharmony_tpc_samples/blob/master/bignumberjsDemo/TEST.md).
## Constraints
This project has been verified in the following versions:
- DevEco Studio: NEXT Beta1-5.0.3.806, SDK: API12 Release (5.0.0.66)
- DevEco Studio: 4.0 (4.0.3.512), SDK: API 10 (4.0.10.9)
- DevEco Studio: 3.1 Beta2 (3.1.0.400), SDK: API 9 Release (3.2.11.9)

## License

This project is licensed under [Apache License 2.0](https://gitcode.com/openharmony-tpc/openharmony_tpc_samples/blob/master/bignumberjsDemo/LICENSE).

## How to Contribute

If you find any problem during the use, submit an [Issue](https://gitcode.com/openharmony-tpc/openharmony_tpc_samples/issues) or a [PR](https://gitcode.com/openharmony-tpc/openharmony_tpc_samples/pulls) to us.
