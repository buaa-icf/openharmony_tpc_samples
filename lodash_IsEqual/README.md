# lodash.isequal

## Overview

lodash.isequal is a library used to check whether two objects are the same.

## How to Install

```bash
ohpm install lodash.isequal@4.5.0
```
For details about the OpenHarmony ohpm environment configuration, see [OpenHarmony HAR](https://gitcode.com/openharmony-tpc/docs/blob/master/OpenHarmony_har_usage.en.md).

## How to Use

```bash
import isEqual from 'lodash.isequal';
let a = 1
    let b = 1
    let res: boolean = isEqual(a, b)
```

## Available APIs


| Name                                                     | Description            |
| ------------------------------------------------------------ | ---------------- |
| isEqual(a: ESObject,b:ESObject): boolean | Checks whether two objects are the same. |

## Constraints

lodash.isequal has been verified in the following version: DevEco Studio 4.1 Canary (4.1.3.317), OpenHarmony SDK: API11 (4.1.0.36)

## Directory Structure

````
|---- lodash_isEqual  
|     |---- entry  # Sample code
|           |---- src  
|                   |---- main  # Sample code
|                   |---- ohosTest  # xts code
|     |---- README.md  # Readme
|     |---- README_zh.md  # Readme                   
````

## How to Contribute

If you find any problem when using lodash.isequal, submit an [Issue](https://gitcode.com/openharmony-tpc/openharmony_tpc_samples/issues) or
a [PR](https://gitcode.com/openharmony-tpc/openharmony_tpc_samples/pulls) to us.

## License

This project is licensed under [MIT LICENSE](https://gitcode.com/openharmony-tpc/openharmony_tpc_samples/blob/master/lodash_IsEqual/LICENSE).
 
