# timers

## Introduction

**timers** is a utility library for time parsing.


## How to Install

```shell
ohpm install timers@0.1.1
```
For details about the OpenHarmony ohpm environment configuration, see [OpenHarmony HAR](https://gitee.com/openharmony-tpc/docs/blob/master/OpenHarmony_har_usage.en.md).

## How to Use

1. Import the dependency library.

```typescript
import timers from 'timers'
```

2. Use APIs as required.

```typescript
Button ('Test every interface')
  .fontSize(30)
  .onClick(() => {
    this.message = JSON.stringify(timers.every('10h').time)
  })
```

## Available APIs

| API                     | Description                          |
| ----------------------- | ------------------------------------ |
| every(str:string):Every | Parses the time value from a string. |




## Constraints

This project has been verified in the following version:

- DevEco Studio 4.1 Canary (4.1.3.317), OpenHarmony SDK: API 11 (4.1.0.36)

## Directory Structure
````
|---- timers  
|     |---- entry      # Sample code
|     |---- README.md  # Readme                   
````

## How to Contribute
If you find any problem when using the project, submit an [issue](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/issues) or a [PR](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/pulls).
## License
This project is licensed under [MIT LICENSE](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/blob/master/timers/LICENSE).

