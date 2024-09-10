# @ohos/xmpp_resource_binding

## Introduction

>Based on the open source software [xmpp_resource_binding](https://github.com/xmppjs/xmpp.js/tree/main/packages/resource-binding), this project uses TypeScript to implement similar capabilities. It provides OpenHarmony with a library for binding client resources.

## Supported Features

- Multi-device login: routes a message from the sender to the recipient to ensure correct message delivery.
- Status synchronization: synchronizes user status (such as online/offline status) on different devices.
- Message routing: routes a message from the sender to the recipient to ensure correct message delivery.
- Session management: manages sessions between users, including creating and terminating a session, and tracing session status.

## How to Install

1. [Install an OpenHarmony HAR](https://gitee.com/openharmony-tpc/docs/blob/master/OpenHarmony_har_usage.en.md).

2. Run the installation command:

   ```
    ohpm install @ohos/xmpp_resource_binding
   ```

## Available APIs

APIs

| Name                                               | Parameter                                                        | Description                                                        |
| ------------------------------------------------------- | ------------------------------------------------------------ | ------------------------------------------------------------ |
| resourceBinding({ streamFeatures, iqCaller }, resource) | `streamFeatures`: stream features of the XMPP server.<br>`iqCaller`: tool for sending IQ messages.| Binds a resource with stream features. Resource binding is automatically processed during the connection of a client.|

## Example
```
import _tcp from "@ohos/xmpp_tcp";
import _middleware from "@ohos/xmpp_middleware";
import _streamFeatures from "@ohos/xmpp_stream_features";
import _iqCaller from "@ohos/xmpp_iq/src/main/iq/caller";
import _iqCallee from "@ohos/xmpp_iq/src/main/iq/callee";
import _sasl from "@@ohos/xmpp_sasl";
import _resourceBinding from "@ohos/xmpp_resource-binding";
import { xml, jid, Client as ClientCore } from "@ohos/xmpp_client_core";
function client(options = {}) {
	// Use object destructuring to extract resource, credentials, username, and password from the options object, and assign the remaining properties to the params object.
    const { resource, credentials, username, password, ...params } = options;
    // Use object destructuring to extract domain, service, and caPath from the params object.
    const { domain, service, caPath } = params;
    if (!domain && service) {
        params.domain = getDomain(service);
    }
    // Create a ClientCore instance, with the params object passed in. This instance will act as the body of the XMPP client.
    const entity = new ClientCore(params);
    // Call the _tcp function, with the entity instance passed in. The _tcp function returns a new object (named tcp), which contains the configuration and functionalities of the TCP connection. The entity instance is now capable of engaging in XMPP communications through a TCP connection.
    const tcp = _tcp({ entity });
    const middleware = _middleware({ entity });
    const streamFeatures = _streamFeatures({ middleware });
    const iqCaller = _iqCaller({ middleware, entity });
    const iqCallee = _iqCallee({ middleware, entity });
    const resolve = _resolve({ entity });
    const resourceBinding = _resourceBinding(
        { iqCaller, streamFeatures },
        resource,
    );
    // Call resourceBinding to bind the current client to the server.
}
```

## How to Use

####  Processing Resource Binding

```
resourceBinding({ streamFeatures, iqCaller }, resource): main function of the module. It receives two parameters: streamFeatures and iqCaller. streamFeatures is an object that may contain the stream features of the XMPP server. iqCaller is a tool used to send IQ messages. This function binds a resource with stream features. Resource binding is automatically processed during the connection of a client.
```

## Constraints

This project has been verified in the following version:

DevEco Studio: 5.0.3.200, OpenHarmony SDK: API 12 (5.0.0.21-Canary2)

## Directory Structure
````
|---- @ohos/xmpp_resource_binding 
|     |---- entry  # Sample code
|           |---- src  
|                   |---- main  # Sample code
|                   |---- ohosTest  # xts code
|     |---- library  # @ohos/xmpp_resource_binding library folder
|           |---- ets
|                 |---- lib  # Main dependencies
|                 |---- types  # External APIs
|           |---- index.js  # Main entry file
|           |---- index.d.ts  # Main declaration file of the external APIs
|     |---- README_EN.md  # Readme                   
````

## How to Contribute

If you find any problem during the use, submit an [issue](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/issues) or [PR](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/pulls).

## License

This project is licensed under the terms of the ISC license.
