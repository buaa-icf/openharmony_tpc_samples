# @ohos/xmpp_tcp

## Introduction

>Based on the open source software [@xmpp/tcp](https://github.com/xmppjs/xmpp.js/tree/main/packages/tcp), this project uses TypeScript to implement similar capabilities. It provides OpenHarmony with a library for establishing and managing TCP connections.

## Supported Features

- Connection management: includes basic TCP connection operations such as connection, disconnection, and reconnection.
- Communicating with other devices or systems through TCP connections

## How to Install

1. Configure the OpenHarmony ohpm environment. For details, see [OpenHarmony HAR](https://gitee.com/openharmony-tpc/docs/blob/master/OpenHarmony_har_usage.en.md).

2. Run the following installation command:

   ```
    ohpm install @ohos/xmpp_tcp
   ```

## Available APIs

Supported APIs

| API   | Parameter                  | Description                   |
| ----------- | ---------------------- | ----------------------- |
| tcp(entity) | **entity**: clientCore instance| Configures the system to support TCP connections.|

## Example
```
import _tcp from "@ohos/xmpp_tcp";
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
}
```

## How to Use

####  Adding the TCP Connection Capability for an Entity

```
function tcp({ entity }) {
  entity.transports.push(ConnectionTCP);
};
// This function adds an array named transports to the entity object and adds an object named ConnectionTCP to the array. The purpose is to configure a new connection mode on the entity object, that is, to use the TCP connection.
```

## Constraints

This project has been verified in the following version:

- DevEco Studio: 5.0.3.200, OpenHarmony SDK: API 12 (5.0.0.21-Canary2)

## Directory Structure
````
|---- @ohos/xmpp_tcp 
|     |---- entry  # Sample code
|           |---- src  
|                   |---- main  # Sample code
|                   |---- ohosTest  # xts code
|     |---- library  # @ohos/xmpp_tcp library
|           |---- ets
|                 |---- lib  # Main dependencies
|                 |---- types  # External APIs
|           |---- index.js  # Main entry file
|           |---- index.d.ts  # Main declaration file of the external APIs
|     |---- README_EN.md  # Readme                   
````

## How to Contribute

If you find any problem when using @ohos/xmpp_tcp, submit an [issue](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/issues) or a [PR](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/pulls).

## License

This project is licensed under ISC License.
