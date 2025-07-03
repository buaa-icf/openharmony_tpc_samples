# @ohos/xmpp_connection

## Introduction

>Based on the open source software [@xmpp/connection](https://github.com/xmppjs/xmpp.js/tree/main/packages/connection), this project uses TypeScript to implement similar capabilities. It provides OpenHarmony with a library for establishing and managing XMPP connections.

## Supported Features

- Connecting to an XMPP service
- Disconnecting a socket
- Opening a stream<br> This method sends a stream header and starts to receive data.
- Closing a stream and disconnecting a socket<br> This method sends the stream tail and ends the connection.
- Restarting a stream<br> This method resets the connection and attempts to re-establish the stream.
- Sending multiple XML elements to the server<br> You can use this method to send data in any XML format.
- Customizing socket connection parameters
- Writing a string to a socket<br> This method is used to send data to a server.

## How to Install

1. Configure the OpenHarmony ohpm environment. For details, see [OpenHarmony HAR](https://gitcode.com/openharmony-tpc/docs/blob/master/OpenHarmony_har_usage.en.md).

2. Run the following installation command:

   ```
    ohpm install @ohos/xmpp_connection
   ```

## Available APIs

Supported APIs

| API          | Parameter           | Description                          |
| ------------------ | --------------- | ------------------------------ |
| **start()**        | N/A             | Starts a connection, opens a stream, and waits until the connection is successful.|
| connect()          | N/A             | Connects to an XMPP service.          |
| disconnect()       | N/A             | Disconnects a socket.                |
| open()             | N/A             | Opens a stream, sends the stream header, and starts to receive data.|
| stop()             | N/A             | Stops a stream and disconnects a socket.            |
| restart()          | N/A             | Restarts a stream.                        |
| send()             | xml: XML instance        | Sends a message in XML format.       |
| write()         | string          | Writes a string to a socket.            |
| socketParameters() | service (address)| Customizes socket connection parameters.          |

## Example
```
import Connection from '@ohos/xmpp_connection';

// Create a connection instance. You can pass in parameters.
const connection = new Connection({XML element. This API is called when the parser parses an XML element.
  jid: 'user@example.com',
  password: 'password',
  service: 'xmpp://example.com',
});

connection.on('status', (status, ...args) => {
    console.log(`Status: ${status}`, args);
});

connection.on('error', (error) => {
    console.error('Error:', error);
});

connection.on('element', (element) => {
    console.log('Element:', element.toString());
});

connection.start()
    .then(() => {
        console.log('Connected and authenticated');

        // Example of sending a message
        const message = new XmppClient.Element('message', {
            type: 'chat',
            to: 'recipient@example.com'
        });
        message.c('body').t('Hello, recipient!');

        return connection.send(message);
    })
    .then(() => {
        console.log('Message sent');
        return connection.stop();
    })
    .then(() => {
        console.log('Connection closed');
    })
    .catch((error) => {
        console.error('Error:', error);
    });
```

## How to Use

#### Connecting to a Server

```
start(): connects to a server and sends a message stanza after the connection is successful. The connect() API is invoked in this API.
connect(): connects to an XMPP service. This API resolves a service URI and attempts to establish a connection with the service.
```

#### Disconnecting from the Server

```
disconnect(): disconnects a socket.
```

#### Opening a Stream

```
open(): opens a stream. This API sends the stream header and starts to receive data.
```

#### Closing a stream and Disconnecting a Socket

```
stop(): closes a stream and disconnects a socket. This API sends the stream tail and ends the connection.
```

#### Restarting a Stream

```
restart(): restarts a stream. This API resets the connection and attempts to re-establish the stream.
```

#### Sending XML Data

```
send(): sends XML elements to the server. This API can be used to send data in any XML format.
```

#### Writing a String to a Socket

```
write(): Writes a string to a socket. This API is used to send data to the server.
```

#### Customizing Socket Connection Parameters

```
socketParameters(): customizes socket connection parameters.
```
## About obfuscation
- Code obfuscation, please see[Code Obfuscation](https://docs.openharmony.cn/pages/v5.0/zh-cn/application-dev/arkts-utils/source-obfuscation.md)
- If you want the library not to be obfuscated during code obfuscation, you need to add corresponding exclusion rules in the obfuscation rule configuration file obfuscation-rules.txt：
```
-keep
./oh_modules/@ohos/xmpp_connection
```
## Constraints

This project has been verified in the following version:

- DevEco Studio: 5.0.3.200, OpenHarmony SDK: API 12 (5.0.0.22-Canary2)


## How to Contribute

If you find any problem when using @ohos/xmpp_connection, submit an [issue](https://gitcode.com/openharmony-tpc/openharmony_tpc_samples/issues) or a [PR](https://gitcode.com/openharmony-tpc/openharmony_tpc_samples/pulls).

## License

This project is licensed under [ISC License](https://gitcode.com/openharmony-tpc/openharmony_tpc_samples/blob/master/xmpp_connection/LICENSE).
