# stun

## Overview

stun is an open-source service component based on the STUN protocol. It allows clients to obtain external IP addresses and port numbers allocated by NAT and identify NAT behavior types.

## Display Effects
![stun](screenshot/stun.gif)

## How to Install

```shell
ohpm install @ohos/stun
```
For details, see [Installing an OpenHarmony HAR](https://gitee.com/openharmony-tpc/docs/blob/master/OpenHarmony_har_usage.en.md).

## How to Use

##### Code Dependency

```
import { StunServer, StunClient } from '@ohos/stun';
...
// Create and start the server.
@State serverMessage: string = "Tip: Click 'node-stun-server' to display the server log";
stunServer: StunServer = null;
private createServer() {
  var self = this;
  if (self.stunServer) {
    return;
  }
  self.serverMessage = "";
  self.stunServer = new StunServer();
  self.stunServer.setServerMessageListener({ onMessageChanged(serverMessage: string) {
    self.serverMessage += serverMessage + "\n";
  } });
  self.stunServer.createServer(this.newDefaults);
}
...
// Create and start the client.
@State clientMessage: string = "Tip: Click 'node-stun-client' to display the client log";
stunClient: StunClient = null;
private createClient() {
  var self = this;
  self.clientMessage = "";
  prompt.showToast({ message: "node-stun-client", duration: 3000 });
  if (!self.stunClient) {
    self.stunClient = new StunClient();
    self.stunClient.setClientMessageListener({ onMessageChanged(clientMessage: string) {
      self.clientMessage += clientMessage + "\n";
    } });
  }
  self.stunClient.createClient(this.clientAddress, this.serverInfo);
}
...
```

## Available APIs
1. Create a STUN server.

   `createServer() `

2. Set the message callback of a STUN server.

   `public setServerMessageListener(onServerMessageListener: OnServerMessageListener)`

3. Enable listening for STUN requests sent from a STUN client.
   `listen()`

4. Disable a STUN server.
   `close()`

5. Create a STUN client.
   `createClient()`

6. Set the message callback of the STUN client.
   `public setClientMessageListener(onClientMessageListener: OnClientMessageListener)`

7. Set the NAT address and port number.
   `setServerAddr(addr, port)`

8. Enable NAT detection.
   `start(option, cb)`

9. Check whether the mapping address is a local address.
   `isNatted()`

10. Obtain the mapping address and port number returned by the STUN server.
      `getMappedAddr()`

11. Obtain the NAT binding type.
    `getNB()`

12. Obtain the node filtering type.
    `getEF()`

13. Obtain the name of the NAT type.
    `getNatType()`

14. Obtain the round trip time (RTT) measured during NAT detection.
    `getRtt()`

15. Disable a STUN client.
    `close(callback)`

## Constraints

stun has been verified in the following versions:

- DevEco Studio Version: 4.1 Canary (4.1.3.317)

- OpenHarmony SDK: API11 (4.1.0.36)

## Directory Structure
````
|---- stun  
|     |---- entry  # Sample code
|     |---- library  # Stun library
|           |---- src/main/ets/common
|                 |---- node-stun  
|                       |---- bin  # External APIs
|                             |---- StunServer.ets  # External APIs for the server
|                             |---- StunClient.ets  # External APIs for the client
|                       |---- lib  # Key code
|                             |---- Server.ets  # Server key code
|                             |---- Client.ets  # Client key code
|                             |---- Const.ets   # Constant class
|                             |---- Logger.ets  # Logger class
|                             |---- Message.ets # Message class
|                             |---- Utils.ets   # Utility class
|                       |---- Index.ets  # Encapsulation of the server and client in the created lib
|           |---- index.ets  # External APIs
|     |---- README.md  # Readme    
|     |---- README_zh.md  # Readme                 
````

## How to Contribute
If you find any problem when using stun, submit an [Issue](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/issues) or a [PR](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/pulls).

## License
The ohos_coap library is based on [Apache License 2.0](https://gitee.com/hihopeorg/stun-server/blob/master/LICENSE).
