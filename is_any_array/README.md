# is_any_array

## Introduction

> This library checks whether the value is an array of any type.

## How to Install

```shell
ohpm  install is-any-array@2.0.1
```

For details, see [Installing an OpenHarmony HAR](https://gitee.com/openharmony-tpc/docs/blob/master/OpenHarmony_har_usage.en.md).

## How to Use


```js
import { isAnyArray } from "is-any-array"

isAnyArray([1,2])
```
For details about unit test cases, see [TEST.md](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/blob/master/is_any_array/TEST.md).

## Constraints

This project has been verified in the following version:

- DevEco Studio: 4.1 Canary (4.1.3.317), OpenHarmony SDK: API11 (4.1.0.36)

## Available APIs

| API                                     | Parameter           | Description       |
|---------------------------------------------|---------------|-----------|
| isAnyArray(value: any)   | value: data to be checked|   Whether the array is of any type   |

## Directory Structure

````
|---- is_any_array
|     |---- entry  # Sample code
              ├── src  
                 ├── main   
                   ├── ets
                       ├── pages
                             ├── Index.ets  # Sample code
|     |---- README_zh.md  # Readme         
|     |---- README.md  # Readme             
````

## How to Contribute

If you find any problem during the use, submit an [Issue](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/issues) or a [PR](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/pulls) to us.

## License

This project is licensed under [MIT License](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/blob/master/is_any_array/LICENSE).
    
