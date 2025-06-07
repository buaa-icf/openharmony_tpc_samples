# lodash


## Introduction
This project demonstrates how to use lodash in OpenHarmony. Lodash is a JavaScript library that provides a wide range of helper functions.


## How to Install

```shell
ohpm install lodash
ohpm install @types/validator --save-dev // Install @types/lodash to prevent import syntax errors due to missing type declarations in the lodash package.

```
For details about the OpenHarmony ohpm environment configuration, see [OpenHarmony HAR](https://gitcode.com/openharmony-tpc/docs/blob/master/OpenHarmony_har_usage.en.md).

## How to Use
```javascript
    // Import the lodash APIs.
    import { camelCase, capitalize } from 'lodash'
    let camelCaseString = camelCase('__FOO_BAR__');
    // => 'fooBar'
    console.log('Convert a string to camelCase: '+ camelCaseString);
    let capitalizeString = capitalize('FRED');
    // => 'Fred'
    console.log('Convert the first character of a string to uppercase and the other characters to lowercase.' + capitalizeString);
```
For details about how to use more APIs, see **ArrayTest.ets**, **FunctionTest.ets**, **NumberTest.ets**, **CollectionTest.ets**, **DateTest.ets**, **LangTest.ets**, **MathTest.ets**, **ObjectTest.ets**, **StringTest.ets**, and **UtilTest.ets**.

## Available APIs
The table below describes the common modules.

| Module    | Description                                                   |
| ---------- | ------------------------------------------------------- |
| array      | Extended APIs related to arrays, such as truncation, comparison, and combination.          |
| collection | Extended APIs related to collections, such as filtering, searching, and sorting.          |
| math       | Extended APIs related to mathematical operations, such as rounding, summing, and comparison.|
| string     | Extended APIs related to strings, such as replacement, truncation, and case conversion.    |
| util       | Common utils, for example, converting names to camel case and generating unique IDs.           |


| Method Name | Parameters | Interface Description |
| --- | --- | --- |
| `chunk` | `array`, `[size=1]` | Splits an array into chunks of a specified length and combines these chunks into a new array. |
| `compact` | `array` | Creates a new array with all falsey values removed. |
| `uniq` | `array` | Creates a duplicate-free version of an array. |
| `union` | `[arrays]` | Creates an array of unique values, in order, from all given arrays. |
| `forEach` | `collection`, `[iteratee=identity]` | Iterates over elements of a collection and executes `iteratee` for each element. |
| `sample` | `collection` | Gets a random element from `collection`. |
| `flatMap` | `collection`, `[iteratee=identity]` | Creates a flattened array of values by running each element in `collection` through `iteratee` and flattening the mapped results. |
| `now` |  | Returns the current timestamp. |
| `map` | `collection`, `[iteratee=identity]` | Creates an array of values by running each element in `collection` through `iteratee`. |
| `ary` | `func`, `[n=func.length]` | Creates a function that invokes `func` with at most `n` arguments, ignoring any additional arguments. |
| `curry` | `func`, `[arity=func.length]` | Creates a function that accepts arguments of `func` and either invokes `func` returning its result, if enough arguments have been provided, or returns a function that accepts the remaining arguments, and so on. |
| `debounce` | `func`, `[wait=0]`, `[options={}]` | Creates a debounced function that delays invoking `func` until after `wait` milliseconds have elapsed since the last time the debounced function was invoked. |
| `delay` | `func`, `[wait=0]`, `[args]` | Invokes `func` after `wait` milliseconds. Any additional arguments are provided to `func` when it is invoked. |
| `castArray` | `value` | Casts `value` as an array if it's not one. |
| `clone` | `value` | Creates a shallow clone of `value`. |
| `eq` | `value`, `other` | Performs a shallow comparison between two values to determine if they are equivalent. |
| `isArrayBuffer` | `value` | Checks if `value` is an `ArrayBuffer`. |
| `isNumber` | `value` | Checks if `value` is classified as a `Number` primitive or object. |
| `add` | `augend`, `addend` | Adds two numbers. |
| `ceil` | `number`, `[precision=0]` | Computes `number` rounded up to `precision`. |
| `meanBy` | `collection`, `[iteratee=identity]` | Computes the mean of the values in `collection` after each value has been run through `iteratee`. |
| `clamp` | `number`, `[lower]`, `upper` | Clamps `number` within the inclusive `lower` and `upper` bounds. |
| `inRange` | `number`, `[start=0]`, `end` | Checks if `number` is between `start` and up to, but not including, `end`. |
| `random` | `[lower=0]`, `[upper=1]`, `[floating]` | Generates a random number between `lower` and `upper` (inclusive). |
| `assignIn` | `object`, `[sources]` | Assigns own and inherited enumerable string keyed properties of source objects to the destination object. |
| `findKey` | `object`, `[predicate=identity]` | Iterates over own and inherited enumerable string keyed properties of an object and returns the first key for which the `predicate` returns truthy. Otherwise, it returns `undefined`. |
| `forIn` | `object`, `[iteratee=identity]` | Iterates over own and inherited enumerable string keyed properties of an object. |
| `keys` | `object` | Retrieves all the enumerable property names of the object. |
| `get` | `object`, `path`, `[defaultValue]` | Gets the value at `path` of `object`. If the resolved value is `undefined`, the `defaultValue` is returned in its place. |
| `invert` | `object` | Creates an object composed of the inverted keys and values of `object`. |
| `camelCase` | `[string='']` | Converts `string` to camel case. |
| `capitalize` | `[string='']` | Converts the first character of `string` to upper case and the remaining to lower case. |
| `escape` | `[string='']` | Converts the characters "&", "<", ">", '"', "'", and "`" in `string` to their corresponding HTML entities. |
| `kebabCase` | `[string='']` | Converts `string` to kebab case. |
| `pad` | `[string='']`, `[length=0]`, `[chars=' ']` | Pads `string` on the left and right sides if it's shorter than `length`. Padding characters are truncated if they can't be evenly divided by `length`. |
| `parseInt` | `string`, `[radix=10]` | Converts `string` to an integer. |
| `conforms` | `source` | Creates a function that checks if all of the `predicate` properties of `source` are truthy when invoked with the corresponding property values of a given object. |
| `filter` | `collection`, `[predicate=identity]` | Iterates over elements of `collection`, returning an array of all elements `predicate` returns truthy for. |
| `defaultTo` | `value`, `defaultValue` | Checks `value` to determine whether a default value should be returned in its place. The `defaultValue` is returned if `value` is `NaN`, `null`, or `undefined`. |
| `identity` | `value` | This method returns the first argument given to it. |
| `nthArg` | `n` | Creates a function that gets the `n`th argument. |
| `stubObject` |  | Returns an empty object. |
| `times` | `n`, `[iteratee=identity]` | Calls `iteratee` `n` times, returning an array of the results of each invocation. |

For details about how to use more modules, see the [Official Document](https://lodash.com/docs/4.17.15).
## Constraints

This project has been verified in the following version:

- DevEco Studio: 4.1 Canary (4.1.3.317)

- OpenHarmony SDK: API 11 (4.1.0.36)

## How to Contribute

If you find any problem when using lodash, submit an [issue](https://gitcode.com/openharmony-tpc/openharmony_tpc_samples/issues) or a [PR](https://gitcode.com/openharmony-tpc/openharmony_tpc_samples/pulls).

## License

This project is licensed under [MIT License](https://gitcode.com/openharmony-tpc/openharmony_tpc_samples/blob/master/lodashDemo/LICENSE).
