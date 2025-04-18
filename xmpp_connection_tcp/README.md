# @ohos/xmpp_connection_tcp

## Introduction

>Based on the open source software [@xmpp/connection-tcp](https://github.com/xmppjs/xmpp.js/tree/main/packages/connection-tcp), this project uses TypeScript to implement similar capabilities. It provides OpenHarmony with a library for establishing and managing XMPP connections.

## Supported Features

- Automatic reconnection: An attempt to reconnect to the XMPP server is initiated upon a connection failure.
- Sending multiple elements: Multiple XML elements can be sent to the server at a time.
- Parsing URIs: parses the URI of a service to extract the port number, host name, and scheme.

## How to Install
1. Configure the OpenHarmony ohpm environment. For details, see [OpenHarmony HAR](https://gitcode.com/openharmony-tpc/docs/blob/master/OpenHarmony_har_usage.en.md).

2. Run the following installation command:

   ```
    ohpm install @ohos/xmpp_connection_tcp
   ```

## Available APIs

Supported APIs

| API          | Parameter               | Description                          |
| ------------------ | ------------------- | ------------------------------ |
| sendMany()         | **elements**: an XML instance.   | Sends multiple XML elements to the server.     |
| socketParameters() | **service**: server address.| Returns connection parameters based on a URI.   |
| headerElement()    | N/A                 | Generates a header element for establishing an XMPP stream.|

## Example
```
import { Socket } from "@ohos/xmpp_connection_tcp/src/main/lib/net"
import ConnectionTCP from "@ohos/xmpp_connection_tcp"
import { Parser } from "@ohos/xmpp_xml"
import { parseURI } from "@ohos/xmpp_connection/src/main/lib/util"

const connection = new ConnectionTCP();

const service = "xmpp://example.com:5222";
const socketParams = connection.socketParameters(service);
const socket = new Socket(socketParams);

// Connect to the XMPP server
socket.connect(() => {
    // Send XMPP stanzas
    const elements = [/* Array of XML elements */];
    connection.sendMany(elements);
});

```

## How to Use

#### Sending Multiple XML Elements

```
sendMany(elements) // Send multiple XML elements to the server.
```

#### Returning Connection Parameters Based on a URI

```
socketParameters(service) // Return connection parameters based on a URI.
```
## About obfuscation
- Code obfuscation, please see[Code Obfuscation](https://docs.openharmony.cn/pages/v5.0/zh-cn/application-dev/arkts-utils/source-obfuscation.md)
- If you want the library not to be obfuscated during code obfuscation, you need to add corresponding exclusion rules in the obfuscation rule configuration file obfuscation-rules.txt：
```
-keep
./oh_modules/@ohos/xmpp_connection_tcp
```
## Constraints
This project has been verified in the following version:
- DevEco Studio: 5.0.3.200, OpenHarmony SDK: API 12 (5.0.0.21-Canary2)

## Directory Structure
```
|---- @ohos/xmpp_connection_tcp
|     |---- entry  # Sample code
|     |---- library  # xmpp_connection_tcp library
|               |----src/main #
|                    |----lib # xmpp_connection_tcp code folder
|               |----index.d.ts # External APIs
|               |---- index.js  # Main entry file
|     |---- README.md  # Readme
|     |---- README_zh.md  # Readme
```

## How to Contribute

If you find any problem when using @ohos/xmpp_connection_tcp, submit an [issue](https://gitcode.com/openharmony-tpc/openharmony_tpc_samples/issues) or a [PR](https://gitcode.com/openharmony-tpc/openharmony_tpc_samples/pulls).

## License

This project is licensed under ISC License.
