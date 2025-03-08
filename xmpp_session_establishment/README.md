# @ohos/xmpp_session_establishment

## Introduction

>Based on the open source software [@xmpp/session-establishment](https://github.com/xmppjs/xmpp.js/tree/main/packages/session-establishment), this project uses TypeScript to implement similar capabilities. It provides OpenHarmony with features for processing servers and determines how to establish sessions based on these features.

## Supported Features
Session establishment


## How to Install
1. [Install an OpenHarmony HAR](https://gitcode.com/openharmony-tpc/docs/blob/master/OpenHarmony_har_usage.en.md).

2. Run the installation command:

   ```
    ohpm install @ohos/xmpp_session_establishment
   ```

## Available APIs

APIs

| Name                                        | Parameter                                               | Description    |
| ------------------------------------------------ | --------------------------------------------------- | -------- |
| sessionEstablishment({iqCaller, streamFeatures}) | iqCaller:IQCaller<br>streamFeatures:StreamFeatures | Establishes a session.|

## Example

```
import _sessionEstablishment from "@ohos/xmpp_session_establishment";

 const entity = new ClientCore(params);
 const sessionEstablishment = _sessionEstablishment({
     iqCaller,
     streamFeatures,
 });
 
 Object.assign(entity, {
        sessionEstablishment,
    });
```

## How to Use

#### Establishing a Session

```
 const sessionEstablishment = _sessionEstablishment({
     iqCaller,
     streamFeatures,
 });
```

## About obfuscation
- Code obfuscation, please see[Code Obfuscation](https://docs.openharmony.cn/pages/v5.0/zh-cn/application-dev/arkts-utils/source-obfuscation.md)
- If you want xmpp_session_establishment library not to be obfuscated during code obfuscation, you need to add corresponding exclusion rules in the obfuscation rule configuration file obfuscation-rules.txt：
```
-keep
./oh_modules/@ohos/xmpp_session_establishment
```

## Constraints

This project has been verified in the following version:

DevEco Studio: 5.0.3.200, OpenHarmony SDK: API 12 (5.0.0.21-Canary2)

## Directory Structure
````
|---- @ohos/xmpp_session_establishment
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
