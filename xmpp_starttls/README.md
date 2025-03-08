# @ohos/xmpp_starttls

## Introduction

>Based on the open source software [@xmpp/starttls](https://github.com/xmppjs/xmpp.js/tree/main/packages/starttls), this project uses TypeScript to implement similar capabilities. It provides OpenHarmony with a library for establishing encrypted TLS connections with the Extensible Messaging and Presence Protocol (XMPP) server.

## Supported Features

- Transport Layer Security (TLS) handshake: enables TLS encryption in XMPP connections to ensure secure communication.
- Automatic STARTTLS: automatically checks whether the server supports STARTTLS for conditionally secure connection.
- Error handling: captures and handles errors and exceptions that may occur during STARTTLS.

## How to Install

1. [Install an OpenHarmony HAR](https://gitcode.com/openharmony-tpc/docs/blob/master/OpenHarmony_har_usage.en.md).

2. Run the installation command:

   ```
    ohpm install @ohos/xmpp_starttls
   ```

## Available APIs
APIs

| Name                    | Parameter                                                        | Description                                              |
| ---------------------------- | ------------------------------------------------------------ | -------------------------------------------------- |
| negotiate(entity)            | `entity`: an object that contains various information and methods required for communicating with the XMPP server, such as the capabilities of sending and receiving XML nodes.| Negotiates with the XMPP server about whether a STARTTLS HANDSHAKE can be performed.  |
| starttls({ streamFeatures }) | `{ streamFeatures }`: an object that contains the stream features of the current XMPP connection, such as the authentication method and encryption options.| Processes the STARTTLS feature in XMPP streams.            |
| canUpgrade(socket)           | `socket`: the current network socket object.                           | Checks whether the current network socket supports an upgrade to TLS.|
| upgrade(service)             | `service`: a service object that may contain the information and methods required for upgrading to TLS.| Upgrades a network socket to a TLS connection.                       |
## Example
```
import { xml, jid, Client as ClientCore } from "@ohos/xmpp_client_core";
import { getDomain } from "./src/main/client/lib/getDomain";
import _reconnect from "@ohos/xmpp_reconnect";
import _websocket from "@ohos/xmpp_websocket";
import _tcp from "@ohos/xmpp_tcp";
import _tls from "@ohos/xmpp_tls";
import _middleware from "@ohos/xmpp_middleware";
import _streamFeatures from "@ohos/xmpp_stream_features";
import _iqCaller from "@ohos/xmpp_iq/src/main/lib/caller";
import _iqCallee from "@ohos/xmpp_iq/src/main/lib/callee";
import _resolve from "@ohos/xmpp_resolve";
// Stream features - order matters and define priority
import _starttls from "@ohos/xmpp_starttls";
import _sasl from "@ohos/xmpp_sasl";
import _resourceBinding from "@ohos/xmpp_resource_binding";
import _sessionEstablishment from "@ohos/xmpp_session_establishment";
import _streamManagement from "@ohos/xmpp_stream_management";
// SASL mechanisms - order matters and define priority
import plain from "@ohos/xmpp_sasl_plain";
import scramsha1 from "@ohos/xmpp_sasl_scram_sha_1";
import anonymous from "@ohos/xmpp_sasl_anonymous";
function client(options = {}) {
    const { resource, credentials, username, password, ...params } = options;
    const { domain, service, caPath } = params;
    if (!domain && service) {
        params.domain = getDomain(service);
    }
    const entity = new ClientCore(params);
    const reconnect = _reconnect({ entity });
    const websocket = _websocket({ entity });
    const tcp = _tcp({ entity });
    const tls = _tls({ entity });
    const middleware = _middleware({ entity });
    const streamFeatures = _streamFeatures({ middleware });
    const iqCaller = _iqCaller({ middleware, entity });
    const iqCallee = _iqCallee({ middleware, entity });
    const resolve = _resolve({ entity });
    // Stream features - order matters and define priority
    const starttls = _starttls({ streamFeatures });
    const sasl = _sasl({ streamFeatures }, credentials || { username, password });
    const streamManagement = _streamManagement({
        streamFeatures,
        entity,
        middleware,
    });
    const resourceBinding = _resourceBinding(
        { iqCaller, streamFeatures },
        resource,
    );
    const sessionEstablishment = _sessionEstablishment({
        iqCaller,
        streamFeatures,
    });
    // SASL mechanisms - order matters and define priority
    const mechanisms = Object.entries({
        scramsha1,
        plain,
        anonymous,
    }).map(([k, v]) => ({ [k]: v(sasl) }));
    return Object.assign(entity, {
        entity,
        reconnect,
        tcp,
        websocket,
        tls,
        middleware,
        streamFeatures,
        iqCaller,
        iqCallee,
        resolve,
        starttls,
        sasl,
        resourceBinding,
        sessionEstablishment,
        streamManagement,
        mechanisms,
    });
}
export { xml, jid, client };
// STARTTLS is used to upgrade a TCP connection to a TLS connection.
```
## How to Use
#### Registering a Middleware Processing Function on the Stream of the XMPP Connection
```
// Check whether the socket connection is TCP, and if so, trigger an upgrade to TLS.
function canUpgrade(socket) {
    return socket instanceof TcpSocket && !(socket instanceof TlsSocket)
}
// Create a TLS socket for TCP upgrade.
async function upgrade(service) {
  const tlsSocket = new TlsSocket();
        tlsSocket.connect(service);
  await promise(tlsSocket, "connect");
  return tlsSocket ;
}
async function negotiate(entity) {
  const element = await entity.sendReceive(xml("starttls", { xmlns: NS }));
  if (element.is("proceed", NS)) {
    return element;
  }
  throw new Error("STARTTLS_FAILURE");
}
export default function starttls({ streamFeatures }) {
  return streamFeatures.use("starttls", NS, async ({ entity }, next) => {
    const { socket, options } = entity;
    if (!canUpgrade(socket)) {
      return next();
    }
    await negotiate(entity);
    const tlsSocket = await upgrade(entity.service);
    entity._attachSocket(tlsSocket);
	// Restart the service after the upgrade is complete.
    await entity.restart();
  });
};
```

## About obfuscation
- Code obfuscation, please see[Code Obfuscation](https://docs.openharmony.cn/pages/v5.0/zh-cn/application-dev/arkts-utils/source-obfuscation.md)
- If you want the xmpp_starttls library not to be obfuscated during code obfuscation, you need to add corresponding exclusion rules in the obfuscation rule configuration file obfuscation-rules.txt：
```
-keep
./oh_modules/@ohos/xmpp_starttls
```

## Constraints
This project has been verified in the following version:

DevEco Studio: 5.0.3.200, OpenHarmony SDK: API 12 (5.0.0.21-Canary2)

## Directory Structure
````
|---- @ohos/xmpp_starttls
|     |---- entry  # Sample code
|           |---- src  
|                   |---- main  # Sample code
|                   |---- ohosTest  # xts code
|     |---- library  # @ohos/xmpp_starttls library folder
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
