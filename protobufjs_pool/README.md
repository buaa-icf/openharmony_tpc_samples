# @protobufjs/pool

## Introduction
> @protobufjs/pool is a general buffer pool.

## How to Install
```shell
ohpm install @protobufjs/pool
```
For details about the OpenHarmony ohpm environment configuration, see [OpenHarmony HAR](https://gitcode.com/openharmony-tpc/docs/blob/master/OpenHarmony_har_usage.en.md).

## How to Use

### Importing and Using the Library
```
import pool from "@protobufjs/pool"

   let alloc = pool((size) => {
        return new Uint8Array(size);
    }, Uint8Array.prototype.subarray);
    
   alloc(8)
```

## Available APIs
1. Creates a general buffer pool.
   `pool(alloc: PoolAllocator, slice: PoolSlicer, size?: number): PoolAllocator`

## Constraints
This project has been verified in the following versions:

- DevEco Studio: 4.1 Canary (4.1.3.317), OpenHarmony SDK: API 11 (4.1.0.36)

## Directory Structure
````
|---- protobufjs_pool
|     |---- entry  # Sample code
|           |---- src
|                 |---- main
|                        |---- ets
|                              |---- pages
|                                    |---- Index # sample
|                 |---- ohosTest
|                       |---- ets
|                             |---- test
|                                   |---- Ability.test.ets  # Unit test

|     |---- README.md  # Readme
|     |---- README.OpenSource  # Open source description
|     |---- CHANGELOG.md  # Changelog               
````

## How to Contribute
If you find any problem when using the project, submit an [issue](https://gitcode.com/openharmony-tpc/openharmony_tpc_samples/issues) or a [PR](https://gitcode.com/openharmony-tpc/openharmony_tpc_samples/pulls).

## License
This project is licensed under [BSD License](https://gitcode.com/openharmony-tpc/openharmony_tpc_samples/blob/master/protobufjs_pool/LICENSE).
