# tiny_emitter

## Introduction

> tiny_emitter is a tiny (less than 1k) event emitter library.

## How to Install

```shell
ohpm  install tiny-emitter@2.1.0
```

For details, see [Installing an OpenHarmony HAR](https://gitee.com/openharmony-tpc/docs/blob/master/OpenHarmony_har_usage.en.md).

## How to Use


```js
Method 1:
import { TinyEmitter } from "tiny-emitter";

let mEmitter: TinyEmitter = new TinyEmitter();
mEmitter.on('some-event', (arg1: string, arg2: string, arg3: string) => {
     
});
mEmitter.once('some-event', (arg1: string, arg2: string, arg3: string) => {
    
});
mEmitter.off('some-event');
mEmitter.emit('some-event', 'arg1 value', 'arg2 value', 'arg3 value');


Method 2:
import emitter from "tiny-emitter/instance";

emitter.on('some-event', (arg1: string, arg2: string, arg3: string) => {
    
});
emitter.once('some-event', (arg1: string, arg2: string, arg3: string) => {

});
emitter.off('some-event');
emitter.emit('some-event', 'arg1 value', 'arg2 value', 'arg3 value');

```
For details about unit test cases, see [TEST.md](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/blob/master/tiny_emitter/TEST.md).

## Constraints

This project has been verified in the following version:

- DevEco Studio: 4.1 Canary (4.1.3.317), OpenHarmony SDK: API11 (4.1.0.36)

## Available APIs

| API                                            | Parameter                                        | Description       |
|----------------------------------------------------|--------------------------------------------|-----------|
| on(event: string, callback: Function, ctx?: any)   | **event**: event name<br> **callback**: callback method<br> **ctx**: context| Listens to events.     |
| once(event: string, callback: Function, ctx?: any) | **event**: event name<br> **callback**: callback method<br> **ctx**: context| Responds to the listening event only once.|
| off(event: string, callback?: Function)            | **event**: event name<br> **callback**: callback method             | Unregisters the event listening.     |
| emit(event: string, ...args: any[])                | **event**: event name<br> **args**: emitted data               | Emits data.     |

## Directory Structure

````
|---- tiny_emitter
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

This project is licensed under [MIT License](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/blob/master/tiny_emitter/LICENSE).
    
