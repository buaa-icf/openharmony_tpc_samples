# @ohos/xmpp_debug

## Introduction

>Based on the open source software [@xmpp/debug](https://github.com/xmppjs/xmpp.js/tree/main/packages/session-establishment), this project uses TypeScript to implement similar capabilities. It provides OpenHarmony with a debugging tool library for Extensible Messaging and Presence Protocol (XMPP) related development.

## Supported Features
- Hiding sensitive elements.
- Enabling debugging


## How to Install
1. [Install an OpenHarmony HAR](https://gitee.com/openharmony-tpc/docs/blob/master/OpenHarmony_har_usage.en.md).

2. Run the installation command:

   ```
    ohpm install @ohos/xmpp_debug
   ```

## Available APIs

APIs

| Name              | Parameter                        | Description        |
| ---------------------- | ---------------------------- | ------------ |
| hideSensitive(element) | element:Element              | Hides a sensitive element.|
| debug(xmpp,foce)       | xmpp:Connection,foce:boolean | Enables debugging.    |

## Example

```
import hideSensitive from "@ohos/xmpp_debug";

  let auth: Element =  xml("auth",{ xmlns: "urn:ietf:params:xml:ns:xmpp-sasl" },xml("body", {}, "foo"))
  let hideauth = hideSensitive(auth);//<auth xmlns="urn:ietf:params:xml:ns:xmpp-sasl"><hidden xmlns="xmpp.js"/></auth>
  
  debug(xmpp) // requires process.env.XMPP_DEBUG
  // or
  debug(xmpp, true) // always enabled
 
```

## How to Use

#### Hiding a Sensitive Element

```
let hideauth = hideSensitive(auth);//<auth xmlns="urn:ietf:params:xml:ns:xmpp-sasl"><hidden xmlns="xmpp.js"/></auth>
```

#### Enabling Debugging

```
  debug(xmpp) // requires process.env.XMPP_DEBUG
  // or
  debug(xmpp, true) // always enabled
```

## Constraints

This project has been verified in the following version:

DevEco Studio: 5.0.3.200, OpenHarmony SDK: API 12 (5.0.0.21-Canary2)

## Directory Structure
````
|---- @ohos/xmpp_debug
|     |---- entry  # Sample code
|           |---- src  
|                   |---- main  # Sample code
|                   |---- ohosTest  # xts code
|     |---- library  # Function library folder
|           |---- index.js  # Main entry file
|           |---- index.d.ts  # Main declaration file of the external APIs
|     |---- README_EN.md  # Readme                   
````

## How to Contribute

If you find any problem during the use, submit an [issue](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/issues) or [PR](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/pulls).

## License

This project is licensed under the terms of the ISC license.
