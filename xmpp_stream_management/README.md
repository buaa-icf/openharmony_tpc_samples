# @ohos/xmpp_stream_management

## Introduction

>Based on the open source software [@xmpp/stream-management](https://github.com/xmppjs/xmpp.js/tree/main/packages/stream-features), this project uses TypeScript to implement similar capabilities. It provides OpenHarmony with a library for negotiating and managing streams in Extensible Messaging and Presence Protocol (XMPP) connections, including session recovery and error recovery.

## Supported Features
XMPP stream management


## How to Install
1. [Install an OpenHarmony HAR](https://gitcode.com/openharmony-tpc/docs/blob/master/OpenHarmony_har_usage.en.md).

2. Run the installation command:

   ```
    ohpm install @ohos/xmpp_stream_management
   ```

## Available APIs

APIs

| Name                                            | Parameter                                                        | Description                          |
| ---------------------------------------------------- | ------------------------------------------------------------ | ------------------------------ |
| streamManagement({streamFeatures,entity,middleware}) | streamFeatures:StreamFeatures<br>entity:Entity<br>middleware:Middleware | Creates a stream management instance.|

## Example

```
import _streamManagement from "@ohos/xmpp_stream_management";

const streamManagement = _streamManagement({
        streamFeatures,
        entity,
        middleware,
});
```

## How to Use

#### Creating a Stream Management Instance

```
const middleware = streamManagement({
        streamFeatures,
        entity,
        middleware,
});
```

## About obfuscation
- Code obfuscation, please see[Code Obfuscation](https://docs.openharmony.cn/pages/v5.0/zh-cn/application-dev/arkts-utils/source-obfuscation.md)
- If you want the xmpp_stream_management library not to be obfuscated during code obfuscation, you need to add corresponding exclusion rules in the obfuscation rule configuration file obfuscation-rules.txt：
```
-keep
./oh_modules/@ohos/xmpp_stream_management
```

## Constraints


This project has been verified in the following version:

DevEco Studio: 5.0.3.200, OpenHarmony SDK: API 12 (5.0.0.21-Canary2)

## Directory Structure
````
|---- @ohos/xmpp_stream_management
|     |---- entry  # Sample code
|           |---- src  
|                   |---- main  # Sample code
|                   |---- ohosTest  # xts code
|     |---- library  # Function library folder
|           |---- index.js  # Main entry file
|           |---- index.d.ts  # Main declaration file of the external APIs
|     |---- README.md  # Readme                   
````

## How to Contribute

If you find any problem during the use, submit an [issue](https://gitcode.com/openharmony-tpc/openharmony_tpc_samples/issues) or [PR](https://gitcode.com/openharmony-tpc/openharmony_tpc_samples/pulls).

## License

This project is licensed under the terms of the ISC license.
