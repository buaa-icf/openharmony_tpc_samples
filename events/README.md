# events

## Introduction
**events** provides APIs for event listening.

## How to Install
```bash
ohpm install events@3.3.0
ohpm install @types/events --save-dev // Install @types/events to prevent import syntax errors due to missing type declarations in the events package.
```

## How to Use
```bash
import * as events from 'events'
this.event = new events.EventEmitter();
this.event.on('message', this.messageCb);
```
## Available APIs


| **API**                                                     | Description            |
| ------------------------------------------------------------ | ---------------- |
| on(topic: string,cb:Function) | Adds a listener for a topic.|
| emit(topic:string,msg:string) | Emits a notification of the specified topic.|
| off(topic:string) | Removes a listener for a topic.|

## Constraints

This project has been verified in the following version:

- DevEco Studio: NEXT Beta1-5.0.3.806, SDK:API12 Release(5.0.0.66)
- DevEco Studio 4.1 Canary (4.1.3.317), OpenHarmony SDK: API 11 (4.1.0.36)

## Directory Structure
````
|---- events 
|     |---- entry  # Sample code
|           |---- src  
|                   |---- main      # Sample code
|                   |---- ohosTest  # xts code
|     |---- README.md  # Readme                   
|     |---- README_zh.md  # Readme                   
````

## How to Contribute
If you find any problem when using the project, submit an [issue](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/issues) or a [PR](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/pulls).
## License
This project is licensed under [MIT LICENSE](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/blob/master/events/LICENSE).
