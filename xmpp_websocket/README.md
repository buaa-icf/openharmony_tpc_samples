# @ohos/xmpp_websocket

## Introduction

>Based on the open source software [xmpp_websocket](https://github.com/xmppjs/xmpp.js/tree/main/packages/websocket), this project uses TypeScript to implement similar capabilities. It provides OpenHarmony with a library for processing WebSocket communication over XMPP.

## Supported Features

- Connecting to a WebSocket server
- Sending and receiving messages
- Handling connection errors
- Handling connection closure

## How to Install
1. Configure the OpenHarmony ohpm environment. For details, see [OpenHarmony HAR](https://gitee.com/openharmony-tpc/docs/blob/master/OpenHarmony_har_usage.en.md).

2. Run the following installation command:

   ```
    ohpm install @ohos/xmpp_websocket
   ```

## Available APIs

Supported APIs

| API            | Parameter                               | Description                                                |
| -------------------- | ----------------------------------- | ---------------------------------------------------- |
| connect(url, caPath) | **url**: address; **capath**: certificate address.        | Connects to a WebSocket server. The parameters include the server URL and CA certificate path.|
| end()                | N/A                                 | Closes a connection.                                            |
| write(data, fn)      | **data**: message to send; **fn**: callback function.| Sends a message to the server. The parameters include the message data and callback function.        |

## Example
```
import { Socket } from "@ohos/xmpp_webSocket";

const socket = new Socket();
const url = "wss://xxxx:xxxx";
const caPath = "/xxx/xxx/xxx/xxx";

socket.connect(url, caPath);

socket.on("connect", () => {
  console.log("Connected to WebSocket server");
  socket.write("Hello, server!", () => {
    console.log("Message sent");
  });
});

socket.on("data", (data) => {
  console.log("Received data:", data);
});

socket.on("error", (error) => {
  console.error("WebSocket error:", error);
});

socket.on("close", (isError, event) => {
  if (isError) {
    console.error("WebSocket connection closed due to error:", event);
  } else {
    console.log("WebSocket connection closed cleanly");
  }
});

```

## How to Use

#### Connecting to a WebSocket Server

```
connect(url, caPath) // Connect to a WebSocket server. The parameters include the server URL and CA certificate path.
```

#### Closing a Connection

```
end() // Close the connection.
```

#### Sending Messages to the Server

```
write(data, fn) // Send a message to the server. The parameters include the message data and callback function.
```

## Constraints

This project has been verified in the following version:
- DevEco Studio: 5.0.3.200, OpenHarmony SDK: API 12 (5.0.0.21-Canary2)

## Directory Structure
```
|---- xmpp_websocket
|     |---- entry  # Sample code
|     |---- library  # xmpp_websocket library
|               |----src/main # 
|                    |----lib # xmpp_websocket code folder
|               |----index.d.ts # External APIs
|               |---- index.js  # Main entry file
|     |---- README_EN.md  # Readme
```
## How to Contribute

If you find any problem when using @ohos/xmpp_websocket, submit an [issue](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/issues) or a [PR](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/pulls).

## License

This project is licensed under ISC License.
