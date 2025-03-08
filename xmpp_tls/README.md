# @ohos/xmpp_tls

## Introduction

>Based on the open source software [@xmpp/tls](https://github.com/xmppjs/xmpp.js/tree/main/packages/tls), this project uses TypeScript to implement similar capabilities. It provides OpenHarmony with a library for establishing encrypted TLS connections with the Extensible Messaging and Presence Protocol (XMPP) server.

## Supported Features
- Data encryption: encrypts data transmitted using XMPP to ensure data security and privacy during message transmission.
- Identity authentication: authenticates the identities of the server and client to ensure that the correct server and client are connected.
- Automatic certificate generation and management: uses the STARTTLS command to explicitly start a TLS session; supports automatic generation and management of SSL/TLS certificates.
- Secure communication: ensures the security of message transmission and communication in XMPP, preventing messages from being intercepted or tampered with.
## How to Install

1. [Install an OpenHarmony HAR](https://gitcode.com/openharmony-tpc/docs/blob/master/OpenHarmony_har_usage.en.md).

2. Run the installation command:

   ```
    ohpm install @ohos/xmpp_tls
   ```

## Available APIs
APIs

| Name        | Parameter                                                        | Description                  |
| ---------------- | ------------------------------------------------------------ | ---------------------- |
| connect(service) | `service`: a string in the format of `xmpp://<username>@<host>:<port>`.| Connects to a specified server and port.|
| write(data, fn)  | `data`: a buffer or string.<br>`fn`: a callback function invoked after the connection is written.| Writes data to a socket.      |
| end()            | N/A                                                          | Closes a socket connection.        |

## Example
```
import { client, xml, Options } from '@ohos/xmpp_client';
@Entry
@Component
struct TcpSocketPage {
  @State status: string = "offline";
  @State message: string = 'Hello World';
  @State sendMessage: string = ""
  @State contact: string = ""
  @State TAG: string = 'NETSTACK'
  private options: Options = {
    service: 'xxxx://xxxxx:xxxx', // Test website address
    domain: 'xxxxxx',
    resource: 'xxxxxxxx',
    username: "xxxxxxxx",
    password: "xxxxxxxx",
  }
  private xmpp = client(this.options); // Service connection
  private onError = (err: Error) => {
    console.info('xmpp-❌', JSON.stringify(err.message));
    console.info('xmpp-❌', JSON.stringify(err.stack));
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
    console.log('��', 'online as', address);
    const presence = xml(
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
  aboutToDisappear(){
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
              console.info("cq ---- error -" + e.toString())
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
#### Registering a Middleware Processing Function on the Stream of the XMPP Connection
```
 // Create an XMPP service.
 private options: Options = {
    service: 'xxxx://xxxx:xxxx', // Test website address
    domain: 'xxxxx',
    resource: 'xxxxxxxx',
    username: "xxxxxxxx",
    password: "xxxxxxxx",
  }
  private xmpp = client(this.options); // Service connection
  // If the server address starts with xmpps, a TLS connection needs to be created. The encrypted port number of the external server is 5223.
    this.xmpp.start(); // Establish a connection.
    this.xmpp.send(message) // Send a message.
    this.xmpp.stop(); // Close the connection.
```

## About obfuscation
- Code obfuscation, please see[Code Obfuscation](https://docs.openharmony.cn/pages/v5.0/zh-cn/application-dev/arkts-utils/source-obfuscation.md)
- If you want the xmpp_tls library not to be obfuscated during code obfuscation, you need to add corresponding exclusion rules in the obfuscation rule configuration file obfuscation-rules.txt：
```
-keep
./oh_modules/@ohos/xmpp_tls
```

## Constraints
This project has been verified in the following version:

DevEco Studio: 5.0.3.200, OpenHarmony SDK: API 12 (5.0.0.21-Canary2)

## Directory Structure
````
|---- @ohos/xmpp_tls
|     |---- entry  # Sample code
|           |---- src  
|                   |---- main  # Sample code
|                   |---- ohosTest  # xts code
|     |---- library  # @ohos/xmpp_tls library folder
|           |---- ets
|                 |---- lib  # Main dependencies
|                 |---- types  # External APIs
|           |---- index.js  # Main entry file
|           |---- index.d.ts  # Main declaration file of the external APIs
|     |---- README.md  # Readme
|     |---- README_zh.md  # Readme                    
````
## How to Contribute
If you find any problem during the use, submit an [issue](https://gitcode.com/openharmony-tpc/openharmony_tpc_samples/issues) or [PR](https://gitcode.com/openharmony-tpc/openharmony_tpc_samples/pulls).
## License
This project is licensed under the terms of the ISC license.
