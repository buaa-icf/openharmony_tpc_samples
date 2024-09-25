# ml_array_rescale

## Introduction

> This project provides an API to rescale an array to a range.

## How to Install

```shell
ohpm  install ml-array-rescale@1.3.7
```

For details about the OpenHarmony ohpm environment configuration, see [OpenHarmony HAR](https://gitee.com/openharmony-tpc/docs/blob/master/OpenHarmony_har_usage.en.md).

## How to Use


```js
import rescale from 'ml-array-rescale';

const result = rescale([0, 1, 2, 3, 4]);
// [0, 0.25, 0.5, 0.75, 1]

```
For details about unit test cases, see [TEST.md](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/blob/master/ml_array_rescale/TEST.md).

## Constraints

This project has been verified in the following version:

- DevEco Studio: 4.1 Canary (4.1.3.317), OpenHarmony SDK: API 11 (4.1.0.36)

## Available APIs

| API                                                    | Parameter                                      | Description        |
| ------------------------------------------------------------ | ------------------------------------------ | ------------ |
| rescale( array: T, options?: mlArrayRescale.ArrayRescaleOptions<T>) | **array**: array to rescale.<br>**options**: options for rescaling the array. | Rescales an array.|


## Directory Structure

````
|---- ml_array_rescale
|     |---- entry  # Sample code
              ├── src  
                 ├── main   
                   ├── ets
                       ├── pages
                             ├── Index.ets  # Sample code
|     |---- README_EN.md  # Readme                   
````

## How to Contribute

If you find any problem when using ml_array_rescale, submit an [issue](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/issues) or a [PR](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/pulls).

## License

This project is licensed under [MIT LICENSE](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/blob/master/ml_array_rescale/LICENSE).

​    
