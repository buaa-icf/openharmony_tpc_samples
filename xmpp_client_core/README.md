# @ohos/xmpp_client_core

## Introduction

>Based on the open source software [@xmpp/client-core](https://github.com/xmppjs/xmpp.js/tree/main/packages/client-core), this project uses TypeScript to implement similar capabilities. It provides OpenHarmony a library for integrating entity attributes for @xmpp/client.

## Supported Features

- Connection management
- Message processing
- State management
- Security certification
- Scalability

## How to Install
1. Configure the OpenHarmony ohpm environment. For details, see [OpenHarmony HAR](https://gitcode.com/openharmony-tpc/docs/blob/master/OpenHarmony_har_usage.en.md).

2. Run the following installation command:

   ```
    ohpm install @ohos/xmpp_client_core
   ```

## Available APIs

Supported APIs

| API                 | Parameter               | Description            |
| ------------------------- | ------------------- | ---------------- |
| send(element, ...args)    | **element**: XML tag.    | Sends a message element.|
| connect(service)          | **service**: server address.| Connects to a service.  |
| socketParameters(...args) | args                | Obtains connection parameters.    |


## Example

```
import { Client } from "@ohos/xmpp_client_core";

const client = new Client(options);

client.connect("xmpp://example.com")
  .then(() => {
    // Operations after the connection is successful.
  })
  .catch((error) => {
    // Handle connection errors.
  });

client.send("<message>Hello</message>");
```

## How to Use

#### Importing the Client Class and Creating an Instance

```
import { Client } from "@ohos/xmpp_client_core";
const client = new Client(options);
```

#### Connecting to an XMPP Server

```
client.connect("xmpp://example.com")
  .then(() => {
    // Operations after the connection is successful.
  })
  .catch((error) => {
    // Handle connection errors.
  });
```

#### Sending Messages

```
client.send("<message>Hello</message>");

```
#### Obtaining Connection Parameters
```
 client.socketParameters(...args)   
```
## About obfuscation
- Code obfuscation, please see[Code Obfuscation](https://docs.openharmony.cn/pages/v5.0/zh-cn/application-dev/arkts-utils/source-obfuscation.md)
- If you want the library not to be obfuscated during code obfuscation, you need to add corresponding exclusion rules in the obfuscation rule configuration file obfuscation-rules.txt：
```
-keep
./oh_modules/@ohos/xmpp_client_core
```
## Constraints

This project has been verified in the following version:

- DevEco Studio: 5.0.3.200, OpenHarmony SDK: API 12 (5.0.0.21-Canary2)

## Directory Structure
````
|---- @ohos/xmpp_client_core
|     |---- entry  # Sample code
|           |---- src  
|                   |---- main  # Sample code
|                   |---- ohosTest  # xts code
|     |---- library  # @ohos/xmpp_client_core library
|           |---- ets
|                 |---- lib  # Main dependencies
|                 |---- types  # External APIs
|           |---- index.js  # Main entry file
|           |---- index.d.ts  # Main declaration file of the external APIs
|     |---- README.md  # Readme                   
|     |---- README_zh.md  # Readme                   
````
## How to Contribute

If you find any problem when using @ohos/xmpp_client_core, submit an [issue](https://gitcode.com/openharmony-tpc/openharmony_tpc_samples/issues) or a [PR](https://gitcode.com/openharmony-tpc/openharmony_tpc_samples/pulls).

## License

This project is licensed under ISC License.

