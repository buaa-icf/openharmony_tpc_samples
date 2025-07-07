# @ohos/xmpp_sasl

## Introduction

>Based on the open source software [@xmpp/sasl](https://github.com/xmppjs/xmpp.js/tree/main/packages/sasl), this project uses TypeScript to implement similar capabilities. It provides OpenHarmony with a library for identity authentication and encrypted communication between the client and server.

## Supported Features
Identity authentication in XMPP connections


## How to Install
1. [Install an OpenHarmony HAR](https://gitcode.com/openharmony-tpc/docs/blob/master/OpenHarmony_har_usage.en.md).

2. Run the installation command:

   ```
    ohpm install @ohos/xmpp_sasl
   ```

## Available APIs

APIs

| Name                             | Parameter                                                        | Description        |
| ------------------------------------- | ------------------------------------------------------------ | ------------ |
| sasl({ streamFeatures }, credentials) | streamFeatures:StreamFeatures<br>credentials:sasl.Credentials | Registers an SASL.|
| use(...args)                          | args:SASLFactory.MechanismStatic                             | Uses a specific mechanism.|

## Example

```
import _sasl from "@ohos/xmpp_sasl";

 const entity = new ClientCore(params);
 
 const sasl = _sasl({ streamFeatures }, credentials || { username, password });
 
 Object.assign(entity, {
        sasl,
    });
```

## How to Use

#### Registering an SASL

```
 const sasl = _sasl({ streamFeatures }, credentials || { username, password });
```

## About obfuscation
- Code obfuscation, please see[Code Obfuscation](https://docs.openharmony.cn/pages/v5.0/zh-cn/application-dev/arkts-utils/source-obfuscation.md)
- If you want the xmpp_sasl library not to be obfuscated during code obfuscation, you need to add corresponding exclusion rules in the obfuscation rule configuration file obfuscation-rules.txt：
```
-keep
./oh_modules/@ohos/xmpp_sasl
```

## Constraints

This project has been verified in the following version:

DevEco Studio: 5.0.3.200, OpenHarmony SDK: API 12 (5.0.0.21-Canary2)

## Directory Structure
````
|---- @ohos/xmpp_sasl
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

This project is licensed under the terms of the [ISC license](https://gitcode.com/openharmony-tpc/openharmony_tpc_samples/blob/master/xmpp_sasl/LICENSE).
