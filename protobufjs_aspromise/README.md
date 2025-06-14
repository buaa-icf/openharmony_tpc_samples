# @protobufjs/aspromise

## Introduction
> @protobufjs/aspromise is a tool library that returns a promise from a node-style callback function.

## How to Install
```shell
ohpm install @protobufjs/aspromise
```
For details about the OpenHarmony ohpm environment configuration, see [OpenHarmony HAR](https://gitcode.com/openharmony-tpc/docs/blob/master/OpenHarmony_har_usage.en.md).

## How to Use

### Importing and Using the Library
```
import { asPromise } from '@protobufjs/aspromise'

      let ctx: ESObject = {};
      let promise: Promise<ESObject> = asPromise(fn, ctx, 1, 2);
      promise.then((arg2: ESObject) => {
          result += "function should be resolved with arg2 = " + arg2
          that.message = result
      }).catch((err: ESObject) => {
          result += "function should not be rejected (" + err + ")"
          that.message = result
      });
        
        
      fn(error: Error | null, param1: ESObject, callback: Function) {
          result += "function should be called with this = ctx\r\n"
          result += "function should be called with arg1 = " + error + "\r\n"
          result += "function should be called with arg2 = " + param1 + "\r\n"
          callback(null, param1)
          callback(error)
          class test {}
          return new test()
      }

```

## Available APIs
1. Returns a promise.
   `asPromise(fn: asPromiseCallback, ctx: any, ...params: any[]): Promise<any>`

## Constraints
This project has been verified in the following versions:

- DevEco Studio: 4.1 Canary (4.1.3.317), OpenHarmony SDK: API 11 (4.1.0.36)

## Directory Structure
````
|---- protobufjs_aspromise
|     |---- entry  # Sample code
|           |---- src
|                 |---- main
|                        |---- ets
|                              |---- pages
|                                    |---- Index # Sample
|                 |---- ohosTest
|                       |---- ets
|                             |---- test
|                                   |---- Ability.test.ets  # Unit test

|     |---- README.md  # Readme         
|     |---- README_zh.md  # Readme             
````

## How to Contribute
If you find any problem when using the project, submit an [issue](https://gitcode.com/openharmony-tpc/openharmony_tpc_samples/issues) or a [PR](https://gitcode.com/openharmony-tpc/openharmony_tpc_samples/pulls).

## License
This project is licensed under [BSD License](https://gitcode.com/openharmony-tpc/openharmony_tpc_samples/blob/master/protobufjs_aspromise/LICENSE).
