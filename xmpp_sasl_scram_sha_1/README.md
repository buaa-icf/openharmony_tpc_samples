# @ohos/xmpp_sasl_scram_sha_1

## Introduction

>Based on the open source software [@xmpp/sasl-scram-sha-1](https://github.com/xmppjs/xmpp.js/tree/main/packages/sasl-scram-sha-1), this project uses TypeScript to implement similar capabilities. It provides OpenHarmony with the Simple Authentication and Security Layer (SASL) framework in the Extensible Messaging and Presence Protocol (XMPP). It uses the SCRAM-SHA-1 hash function for user authentication.

## Supported Features
- **Security authentication**: provides a security authentication mechanism based on the Salted Challenge Response Authentication Mechanism (SCRAM) to secure identity authentication during XMPP-based communication.
- **Hash encryption**: uses the SHA-1 hash algorithm to encrypt user passwords, enhancing password transmission security and preventing passwords from being intercepted or cracked during transmission.
## How to Install
1. [Install an OpenHarmony HAR](https://gitee.com/openharmony-tpc/docs/blob/master/OpenHarmony_har_usage.en.md).
2. Run the installation command:

   ```
    ohpm install @ohos/xmpp_sasl_scram_sha_1
   ```

## Available APIs
APIs

| Name             | Parameter                                            | Description                                                        |
| --------------------- | ------------------------------------------------ | ------------------------------------------------------------ |
| saslScramSha1 (sasl)| `sasl`: XMPP SASL context object, which is used to process the authentication process.| Adds the SCRAM-SHA-1 authentication mechanism to an XMPP SASL context object, so that the object can use this authentication method for user authentication.|

## Example
```
"use strict";
import { xml, jid, Client as ClientCore } from "@ohos/xmpp_client_core";
import { getDomain } from "./src/main/client/lib/getDomain";
import _reconnect from "@ohos/xmpp_reconnect";
import _websocket from "@ohos/xmpp_websocket";
import _tcp from "@ohos/xmpp_tcp";
import _tls from "@ohos/xmpp_tls";
import _middleware from "@ohos/xmpp_middleware";
import _streamFeatures from "@ohos/xmpp_stream-features";
import _iqCaller from "@ohos/xmpp_iq/src/main/iq/caller";
import _iqCallee from "@ohos/xmpp_iq/src/main/iq/callee";
import _resolve from "@ohos/xmpp_resolve";
// Stream features - order matters and define priority
import _starttls from "@ohos/xmpp_starttls";
import _sasl from "@ohos/xmpp_sasl";
import _resourceBinding from "@ohos/xmpp_resource_binding";
import _sessionEstablishment from "@ohos/xmpp_session_establishment";
import _streamManagement from "@ohos/xmpp_stream_management";
// SASL mechanisms - order matters and define priority
import plain from "@ohos/xmpp_sasl_plain";
import saslScramSha1 from "@ohos/xmpp_sasl_scram_sha_1";
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
        saslScramSha1,
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
```
## How to Use
#### Using scramSha1 for User Login Authentication
```
   const mechanisms = Object.entries({
        saslScramSha1,
        plain,
        anonymous,
    }).map(([k, v]) => ({ [k]: v(sasl) }));
    Three encryption modes are available: saslScramSha1, plain, and anonymous.
```
## Constraints
This project has been verified in the following version:

DevEco Studio: 5.0.3.200, OpenHarmony SDK: API 12 (5.0.0.21-Canary2)

## Directory Structure
````
|---- @ohos/xmpp_sasl_scram_sha_1
|     |---- entry  # Sample code
|           |---- src  
|                   |---- main  # Sample code
|                   |---- ohosTest  # xts code
|     |---- library  # @ohos/xmpp_sasl_scram_sha_1 library folder
|           |---- ets
|                 |---- lib  # Main dependencies
|                 |---- types  # External APIs
|           |---- index.js  # Main entry file
|           |---- index.d.ts  # Main declaration file of the external APIs
|     |---- README.md  # Readme     
|     |---- README_zh.md  # Readme               
````
## How to Contribute
If you find any problem during the use, submit an [issue](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/issues) or [PR](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/pulls).
## License
This project is licensed under the terms of the ISC license.
