# @ohos/xmpp_sasl_plain

## Introduction

>Based on the open source software [@xmpp/sasl-plain](https://github.com/xmppjs/xmpp.js/blob/main/packages/sasl-plain), this project uses TypeScript to implement similar capabilities. It provides OpenHarmony with a library for the SASL PLAIN mechanism defined in the Extensible Messaging and Presence Protocol (XMPP).

## Supported Features
Simple plain text authentication


## How to Install
1. [Install an OpenHarmony HAR](https://gitcode.com/openharmony-tpc/docs/blob/master/OpenHarmony_har_usage.en.md).

2. Run the installation command:

   ```
    ohpm install @ohos/xmpp_sasl_plain
   ```

## Available APIs

APIs

| Name       | Parameter     | Description        |
| --------------- | --------- | ------------ |
| saslPlain(sasl) | sasl:SASL | Uses simple plain text authentication.|

## Example

```
import plain from "@ohos/xmpp_sasl_plain";

const sasl = _sasl({ streamFeatures }, credentials || { username, password });
 
const mechanisms = Object.entries({
    scramsha1,
    plain,
    anonymous,
}).map(([k, v]) => ({ [k]: v(sasl) }));

Object.assign(entity, {
        sasl,
        mechanisms
});
```

## How to Use

#### Using Simple Plain Text Authentication

```
 saslPlain(sasl)
```

## About obfuscation
- Code obfuscation, please see[Code Obfuscation](https://docs.openharmony.cn/pages/v5.0/zh-cn/application-dev/arkts-utils/source-obfuscation.md)
- If you want the xmpp_sasl_plain library not to be obfuscated during code obfuscation, you need to add corresponding exclusion rules in the obfuscation rule configuration file obfuscation-rules.txt：
```
-keep
./oh_modules/@ohos/xmpp_sasl_plain
```

## Constraints

This project has been verified in the following version:

DevEco Studio: 5.0.3.200, OpenHarmony SDK: API 12 (5.0.0.21-Canary2)

## Directory Structure
````
|---- @ohos/xmpp_sasl_plain
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

This project is licensed under the terms of the [ISC license](https://gitcode.com/openharmony-tpc/openharmony_tpc_samples/blob/master/xmpp_sasl_plain/LICENSE).
