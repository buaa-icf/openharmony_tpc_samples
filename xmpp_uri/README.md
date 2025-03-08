# @ohos/xmpp_uri

## Introduction

>Based on the open source software [@xmpp/session-establishment](https://github.com/xmppjs/xmpp.js/tree/main/packages/session-establishment), this project uses TypeScript to implement similar capabilities. It provides OpenHarmony with functions for parsing URIs in the Extensible Messaging and Presence Protocol (XMPP).

## Supported Features
URI parsing


## How to Install
1. [Install an OpenHarmony HAR](https://gitcode.com/openharmony-tpc/docs/blob/master/OpenHarmony_har_usage.en.md).

2. Run the installation command:

   ```
    ohpm install @ohos/xmpp_uri
   ```

## Available APIs

APIs

| Name  | Parameter      | Description   |
| ---------- | ---------- | ------- |
| parse(str) | str:String | Parses a URI.|

## Example

```
import { parse } from "@ohos/xmpp_uri";

let xmppurl = parse("xmpp:support@example.com/truc")

xmppurl.path = jid("support@example.com/truc")

```

## How to Use

#### Parsing a URI

```
let xmppurl = parse("xmpp:support@example.com/truc")
```

## About obfuscation
- Code obfuscation, please see[Code Obfuscation](https://docs.openharmony.cn/pages/v5.0/zh-cn/application-dev/arkts-utils/source-obfuscation.md)
- If you want the xmpp_uri library not to be obfuscated during code obfuscation, you need to add corresponding exclusion rules in the obfuscation rule configuration file obfuscation-rules.txt：
```
-keep
./oh_modules/@ohos/xmpp_uri
```

## Constraints

This project has been verified in the following version:

DevEco Studio: 5.0.3.200, OpenHarmony SDK: API 12 (5.0.0.21-Canary2)

## Directory Structure
````
|---- @ohos/xmpp_uri
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
