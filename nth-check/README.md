# nth-check 

Parses and compiles CSS nth-checks to highly optimized functions.

### About

This module can be used to parse & compile nth-checks, as they are found in CSS 3's `nth-child()` and `nth-last-of-type()`. It can be used to check if a given index matches a given nth-rule, or to generate a sequence of indices matching a given nth-rule.

`nth-check` focusses on speed, providing optimized functions for different kinds of nth-child formulas, while still following the [spec](http://www.w3.org/TR/css3-selectors/#nth-child-pseudo).
## Install
```shell
ohpm install nth-check
```
For details, see [Installing an OpenHarmony HAR](https://gitee.com/openharmony-tpc/docs/blob/master/OpenHarmony_har_usage.en.md).

### API

```js
import nthCheck, { parse, compile } from "nth-check";
```

##### `nthCheck(formula)`

Parses and compiles a formula to a highly optimized function. Combination of `parse` and `compile`.

If the formula doesn't match any elements, it returns [`boolbase`](https://github.com/fb55/boolbase)'s `falseFunc`. Otherwise, a function accepting an _index_ is returned, which returns whether or not the passed _index_ matches the formula.

**Note**: The nth-rule starts counting at `1`, the returned function at `0`.

**Example:**

```js
const check = nthCheck("2n+3");

check(0); // `false`
check(1); // `false`
check(2); // `true`
check(3); // `false`
check(4); // `true`
check(5); // `false`
check(6); // `true`
```

##### `parse(formula)`

Parses the expression, throws an `Error` if it fails. Otherwise, returns an array containing the integer step size and the integer offset of the nth rule.

**Example:**

```js
parse("2n+3"); // [2, 3]
```

##### `compile([a, b])`

Takes an array with two elements (as returned by `.parse`) and returns a highly optimized function.

**Example:**

```js
const check = compile([2, 3]);

check(0); // `false`
check(1); // `false`
check(2); // `true`
check(3); // `false`
check(4); // `true`
check(5); // `false`
check(6); // `true`
```

##### `generate([a, b])`

Returns a function that produces a monotonously increasing sequence of indices.

If the sequence has an end, the returned function will return `null` after the last index in the sequence.

**Example:** An always increasing sequence

```js
const gen = generate([2, 3]);

gen(); // `2`
gen(); // `4`
gen(); // `6`
gen(); // `8`
gen(); // `10`
```

**Example:** With an end value

```js
const gen = generate([-2, 5]);

gen(); // 0
gen(); // 2
gen(); // 4
gen(); // null
```

##### `sequence(formula)`

Parses and compiles a formula to a generator that produces a sequence of indices. Combination of `parse` and `generate`.

**Example:** An always increasing sequence

```js
const gen = sequence("2n+3");

gen(); // `2`
gen(); // `4`
gen(); // `6`
gen(); // `8`
gen(); // `10`
```

**Example:** With an end value

```js
const gen = sequence("-2n+5");

gen(); // 0
gen(); // 2
gen(); // 4
gen(); // null
```

## Constraints

nth-check has been verified in the following version:

- DevEco Studio Version: 5.0.1 Release (5.0.5.310), OpenHarmony SDK: 13 (5.0.0(13))

## Directory Structure
```
|----nth-check 
|     |---- entry  # Sample code
|          |----src
|              |----main
|                  |----ets
|                      |----pages
|                          |---- Index.ets
|     |---- README.md  # Readme 
|     |---- README_zh.md  # Readme 
```

## How to Contribute
If you find any problem when using nth-check, submit an [Issue](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/nth-check/issues) or a [PR](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/nth-check/pulls).

## License
This project is licensed under [BSD 2-Clause](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/nth-check/blob/master/LICENSE).
