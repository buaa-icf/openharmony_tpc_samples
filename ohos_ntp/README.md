# ohos_ntp


## Introduction

> ohos_ntp is a TypeScript library for Network Time Protocol (NTP) server synchronization events. It allows your application to obtain accurate event information by communicating with the NTP server to ensure that your device has an accurate system clock or can obtain accurate time information for debugging.
>
> ![GIF](./img/ntpGIF_EN.gif)

## How to Install

```shell
ohpm install @ohos/ntp
```

For details about the OpenHarmony ohpm environment configuration, see [OpenHarmony HAR](https://gitee.com/openharmony-tpc/docs/blob/master/OpenHarmony_har_usage.en.md).

## How to Use

1. Import the dependency.

 ``` 
 import { getNetworkTime, NTPConfig } from '@ohos/ntp';
 ```

2. Add permissions in the **module.json5** file.

 ```
 "requestPermissions": [
     {
         "name": "ohos.permission.INTERNET"
     }
 ]
 ```

3. Create an NTPClient instance object in the event or hook function, call **getNetworkTime**, and use the default value if no parameter is transferred.

 ```
const ntpConfig: NTPConfig = {
    server: ntp.aliyun.com (NTP server)
	port: 123 (remote port number)
	delayTime: 3000 (response waiting duration (ms))
}
 
getNetworkTime(ntpConfig)
.then(date => {
	this.ntpResult = JSON.stringify(date); //"2024-02-06T01:50:37.645Z"
})
.catch((err: string) => {
	this.timeoutResult = JSON.stringify(err);
})
 ```

## Available APIs

| API        | Parameter                              | Return Value         | Description       |
| -------------- | ---------------------------------- | --------------- | ----------- |
| getNetworkTime | {server,port,delayTime}:NTPConfig | Promise< Date > | Time to obtain NTP info|

## Constraints

This project has been verified in the following version:

- DevEco Studio: 4.1.3.500; SDK: API11 Release (4.1.0)

## Directory Structure

````
|---- ntpclient
|     |---- entry  # Sample code
|     |---- library  # NTP library
|         |---- src
|             |---- main
|                  |---- ets
|                       |---- index.ts  #ntp
|         |---- index.ts  # External APIs
|     |---- README.md  # Readme
|     |---- README_zh.md  # Readme                   
````

## How to Contribute

If you find any problem when using the project, submit an [issue](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/issues) or a [PR](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/pulls) to us.

## License

This project is licensed under [Apache License 2.0](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/tree/master/ohos_ntp/LICENSE).
