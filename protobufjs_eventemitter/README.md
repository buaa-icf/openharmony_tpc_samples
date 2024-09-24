# @protobufjs/eventemitter

## Introduction
> @protobufjs/eventemitter is a lightweight event emitter.

## How to Install
```shell
ohpm install @protobufjs/eventemitter
```
For details about the OpenHarmony ohpm environment configuration, see [OpenHarmony HAR](https://gitee.com/openharmony-tpc/docs/blob/master/OpenHarmony_har_usage.en.md).

## How to Use

### Importing and Using the Library
```
import EventEmitter from "@protobufjs/eventemitter"

   let ee = new EventEmitter();
   let ctx: ESObject = {};
   // Register an event listener.
   ee.on("a", ((arg1: ESObject) => {
       result = result + arg1
   }) as ESObject, ctx)
   ee.emit ("a," 1);// Emit an event.
   ee.off("a");// Disable the event listener.
```

## Available APIs
1. Registers an event listener.
   `on(evt: string, fn: () => any, ctx?: any): EventEmitter`
2. Disables an event listener.
   `off(evt?: string, fn?: () => any): EventEmitter`
3. Emits an event.
   `emit(evt: string, ...args: any[]): EventEmitter`
## Constraints
This project has been verified in the following versions:

- DevEco Studio: 4.0 Release (4.0.0.600), OpenHarmony SDK: API 10 (4.0.10.11)

## Directory Structure
````
|---- protobufjs_eventemitter
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
|     |---- README_zh.md  # Readme                  
````

## How to Contribute
If you find any problem when using the project, submit an [issue](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/issues) or a [PR](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/pulls).

## License
This project is licensed under [BSD License](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/blob/master/protobufjs_eventemitter/LICENSE).
