# ieee754

## Introduction

> IEEE 754 specifies the formats and operations for floating-point arithmetic.

## How to Install

```shell
ohpm  install ieee754@1.2.1
```

For details about the OpenHarmony ohpm environment configuration, see [OpenHarmony HAR](https://gitee.com/openharmony-tpc/docs/blob/master/OpenHarmony_har_usage.en.md).

## How to Use
```
import * as ieee754 from 'ieee754'
ieee754.read = function (buffer, offset, isLE, mLen, nBytes)
ieee754.write = function (buffer, value, offset, isLE, mLen, nBytes)
````
## Constraints

This project has been verified in the following version:

- DevEco Studio: 4.1 Canary (4.1.3.317), OpenHarmony SDK: API 11 (4.1.0.36)


## Available APIs

1. Writes data.

   `wirte`
2. Reads data.

   `read`

## Directory Structure

````
|---- ieee754
|     |---- entry  # Sample code
              ├── src  
                 ├── main   
                   ├── ets
                       ├── pages
                             ├── Index.ets  # Sample code
|     |---- README.md  # Readme                   
````

## How to Contribute

If you find any problem when using the project, submit an [issue](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/issues) or a [PR](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/pulls).

## License

This project is licensed under [BSD-3-Clause License](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/blob/master/ieee754/LICENSE).
    
