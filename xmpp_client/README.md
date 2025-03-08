# @ohos/xmpp_client

## Introduction

>Based on the open-source software [@xmpp/client](https://github.com/xmppjs/xmpp.js), this project provides OpenHarmony with a library for creating Extensible Messaging and Presence Protocol (XMPP) clients. XMPP is an open, standardized protocol used for instant messaging and online real-time communication.

## Supported Features

- Connecting the XMPP client to the XMPP server
- Reconnecting the XMPP client to the XMPP server
- Disconnecting the XMPP client from the XMPP server
- Communication with the XMPP server.
- Listening for the XMPP client login status
- Listening for XMPP client errors
- Listening for the XMPP client status

## How to Install
1. [Install an OpenHarmony HAR](https://gitcode.com/openharmony-tpc/docs/blob/master/OpenHarmony_har_usage.en.md).

2. Run the installation command:

   ```
    ohpm install @ohos/xmpp_client
   ```

## Required Permissions

```
ohos.permission.INTERNET
ohos.permission.GET_NETWORK_INFO
```

## Available APIs

APIs

| Name                               | Parameter               | Description                      |
| --------------------------------------- | ------------------- | -------------------------- |
| let xmpp=client(options:Options)        | `Options`: connection parameters.| Configures connection parameters.              |
| xmpp.on('error',(err)=>{})              | 'error':string      | Listens for errors.          |
| xmpp.on('online',async(address)=>{})    | 'online':string     | Listens for online information.          |
| xmpp.on('status', (status, value) =>{})| 'status':string     | Listens for the client status.|
| xmpp.on('stanza',(stanza)=>{})          | 'stanza':string     | Listens for messages and other operations.      |
| xmpp.start()                            | N/A                 | Starts a connection.                  |
| xmpp.send(xml({}))                      | `xml`: an XML instance.        | Sends a message in XML format.   |
| xmpp.stop()                             | N/A                 | Stops a connection.                  |

## Example

xmpp is an XMPP-based communication library and requires a connection to the XMPP server. In the local test, Openfire is used as the XMPP server, and Spark is used as the client. Spark is an open-source and cross-platform instant messaging client that provides rich XMPP-compliant instant messaging features and easy-to-use UIs.

### Configuring Openfire

(1) Download Openfire that suits your operating system from the [official website] https://www.igniterealtime.org/projects/openfire/.

(2) Select `Server Settings` (Use the default value. If no external database is configured for the database, select `Embedded Database`).

(3) Log in to the [Openfire management page] (http://localhost:9090/login.jsp).

(4) Log in as user `admin`, and click `Server Settings` to view the name and host name of the server.

(5) On the `Users/Groups` tab page, click `Create User` and enter user information.

### Using Spark

(1) Download Spark that suits your operating system from [Ignite Realtime: Spark IM Client](https://www.igniterealtime.org/projects/spark/).

(2) Log in as the new user created in Openfire.

```
import { client,Client, xml, Options } from '@ohos/xmpp_client';
import { Element } from '@ohos/xmpp_xml';

@Entry
@Component
struct WebSocketPage {
  @State status: string = "offline";
  @State message: string = 'Hello World';
  @State sendMessage: string = ""
  @State contact: string = ""
  private options: Options = {
    service: 'ws://xx.xx.xx.xx:xxxx/ws', // xx.xx.xx.xx (server address) xxxx port
    domain: 'xx.xx.xx.xx',               // Server name (xx.xx.xx.xx)
    resource: 'xx.xx.xx.xx',             // Host name (server address by default)
    username: "xxx",					 // Username of the user created in Openfire
    password: "xxx"				         // Password of the user created in Openfire
  }
  
  private xmpp = client (this.options); // Create an xmpp instance.

  private onError = (err: Error) => {
    console.info('xmpp-❌', JSON.stringify(err.message));
  }
  
  private onOffline = () => {
    console.info('xmpp--', 'offline');
  }
  
  private onStanza = (stanza: ESObject) => {
    this.contact = stanza.attrs.from
    if (stanza.is('presence') && stanza.attrs.type === 'subscribe') {
      this.contact = stanza.attrs.from
      this.xmpp.send(xml('presence', { to: stanza.attrs.from, type: 'subscribed' }));
    }
    if (stanza.is('message') && stanza.attrs.from !== this.xmpp.jid) {
      stanza.children.forEach((child: ESObject) => {
        if (child.name === 'body') {
          console.log("xmpp---message" + child.text())
          this.message = child.text()
        }
      });
    }
  }
  
  private onStatus = (status: string, value: string) => {
    this.status = status
    console.info("xmpp-response --" + "status--" + status + "---value---" + value)
  }
  
  private onLine = async (address: ESObject) => {
    console.log('🗸', 'online as', address);
    const presence:Element  = xml(
      'presence',
      {},
      xml('show', {}, 'chat'),
      xml('status', {}, 'presence!')
    );
    this.xmpp.send(presence);
  }

  aboutToAppear() {
    this.xmpp.on('error', this.onError);
    this.xmpp.on('offline',this.onOffline);
    this.xmpp.on('status', this.onStatus);
    this.xmpp.on('online', this.onLine);
    this.xmpp.on('stanza',this.onStanza);
  }
  
  async aboutToDisappear(){
    await this.xmpp.stop();
    this.xmpp.off('error',this.onError)
    this.xmpp.off('offline',this.onOffline)
    this.xmpp.off('status',this.onStatus)
    this.xmpp.off('online',this.onLine)
    this.xmpp.off('stanza',this.onStanza)
  }

  build() {
    Row() {
      Column() {
        Text("Status: "+ this.status)
          .fontSize(30)
          .fontWeight(FontWeight.Bold)
        Text("Message received: "+ this.message)
          .fontSize(30)
          .fontWeight(FontWeight.Bold)
          .margin({ top: 30 })
        Button("Connect").fontSize (30)
          .width("60%")
          .onClick(() => {
            this.xmpp.start();
          }).margin({ top: 30 })
        TextInput({ placeholder: "Enter a message" })
          .margin({ top: 30 })
          .fontSize(30)
          .width("60%")
          .height(100)
          .onChange((value: string) => {
            this.sendMessage = value;
          })

        Button("Send").fontSize(30)
          .width("60%")
          .onClick(() => {
            const message = xml("message", { type: "chat", to: this.contact }, xml("body", {}, this.sendMessage));
            this.xmpp.send(message)
          }).margin({ top: 30 })
      
        Button("Disconnect").fontSize(30)
          .width("60%")
          .onClick(() => {
            try {
              this.xmpp.stop();
            } catch (e) {
              console.info("stop ---- error -" + e.toString())
            }
          }).margin({ top: 30 })
      }
      .width('100%')
    }
    .height('100%')
  }
}

```

## How to Use

### xmpp APIs

#### Creating an xmpp Instance by Setting the client Parameters

##### xmpp=client(options)
##### In the following `Options`, `xmpp` in the value of `service` can be replaced with `xmpps`, `xmpp`, `ws`, or `wss`.
- `xmpp` corresponds to a TCP Socket connection, for example, xmpp://xxxx:xxxx.
- `xmpps` corresponds to a TLS Socket connection, for example, xmpps://xxxx:xxxx. (This is an encrypted connection, and the server needs to verify the CA certificate.)
- `ws` corresponds to a WebSocket connection, for example, ws://xxxx:xxxx/ws/.
- `wss` corresponds to an encrypted WebSocket connection, for example, wss://xxxx:xxxx/ws/. (This is an encrypted connection, and the server needs to verify the CA certificate.)
```
 private options: Options = {
    service: 'xmpp://xx.xx.xx.xx:xxxx/', // xx.xx.xx.xx (server address) xxxx port
    domain: 'xx.xx.xx.xx',               // Server name (xx.xx.xx.xx)
    resource: 'xx.xx.xx.xx',             // Host name (server address by default)
    username: "xxx",					 // Username of the user created in Openfire
    password: "xxx"				         // Password of the user created in Openfire
  }
  private xmpp = client (this.options); // Create an xmpp instance.
```

#### Listening for Errors

For convenience, aliases are provided for all supported request methods.

Listen for errors.

```
  private onError = (err: Error) => {
    console.info('xmpp-❌', JSON.stringify(err.message));
  }
  
  this.xmpp.on('error', this.onError);
```
Status Listening
#### Listening for the Status

```
 private onStatus = (status: string, value: string) => {
    this.status = status
    console.info("xmpp-response --" + "status--" + status + "---value---" + value)
  }
  this.xmpp.on('status', this.onStatus);
```

- message

- presence

  ```
   
   private onStanza = (stanza: ESObject) => {
    this.contact = stanza.attrs.from
    if (stanza.is('presence') && stanza.attrs.type === 'subscribe') {
      this.contact = stanza.attrs.from
      this.xmpp.send(xml('presence', { to: stanza.attrs.from, type: 'subscribed' }));
    }
    if (stanza.is('message') && stanza.attrs.from !== this.xmpp.jid) {
      stanza.children.forEach((child: ESObject) => {
        if (child.name === 'body') {
          console.log("xmpp---message" + child.text())
          this.message = child.text()
        }
      });
    }
  }
  this.xmpp.on('stanza',this.onStanza)
  ```

#### Sending Messages

xmpp.send(xml)

```
const message = xml("message", { type: "chat", to: "JID" }, xml("body", {}, this.sendMessage));
// message is used as an example. This XML message sends a message of the chat type. The to parameter is set to JID, and the information following body is the message to send.
```

#### Error Codes

Error constants

| Name                  | Type| Readable| Writable| Description          |
| ---------------------- | -------- | ---- | ---- | -------------- |
| Address already in use | number   | Yes  | No  | The address is in use.|
| Connection timed out   | number   | Yes  | No  | The connection times out.      |
| Parameter error        | number   | Yes  | No  | Invalid parameter.      |
| Permission denied      | number   | Yes  | No  | Permission denied.      |


## Directory Structure
````
|---- @ohos/xmpp_client
|     |---- entry  # Sample code
|           |---- src  
|                   |---- main  # Sample code
|                   |---- ohosTest  # xts code
|     |---- library  # Function library folder
|           |---- index.js  # Main entry file
|           |---- index.d.ts  # Main declaration file of the external APIs
|     |---- README.md  # Readme                   
````

## About obfuscation
- Code obfuscation, please see[Code Obfuscation](https://docs.openharmony.cn/pages/v5.0/zh-cn/application-dev/arkts-utils/source-obfuscation.md)
- If you want the xmpp_client library not to be obfuscated during code obfuscation, you need to add corresponding exclusion rules in the obfuscation rule configuration file obfuscation-rules.txt：
```
-keep
./oh_modules/@ohos/xmpp_client
```

## Constraints

This project has been verified in the following version:

DevEco Studio: 5.0.3.200, OpenHarmony SDK: API 12 (5.0.0.21-Canary2)


## How to Contribute

If you find any problem during the use, submit an [issue](https://gitcode.com/openharmony-tpc/openharmony_tpc_samples/issues) or [PR](https://gitcode.com/openharmony-tpc/openharmony_tpc_samples/pulls).

## License

This project is licensed under the terms of the ISC license.
