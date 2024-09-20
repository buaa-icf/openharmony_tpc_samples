# @ohos/xmpp_sasl_anonymous

## Introduction

>Based on the open source software [@xmpp/sasl-anonymous](https://github.com/xmppjs/xmpp.js/tree/main/packages/sasl-anonymous), this project uses TypeScript to implement similar capabilities. It provides OpenHarmony with a library for anonymous connection between the Extensible Messaging and Presence Protocol (XMPP) client and server.

## Supported Features

- SASL ANONYMOUS mechanism: implements the SASL ANONYMOUS mechanism defined in RFC 7525, which is an extension of the XMPP.
- XMPP client integration: integrated into XMPP client libraries or applications to add the support for anonymous authentication.
- Client and server authentication: uses the SASL ANONYMOUS mechanism for authentication during the connection to the server. This mechanism does not require the client to provide the username or password.

## How to Install

1. [Install an OpenHarmony HAR](https://gitee.com/openharmony-tpc/docs/blob/master/OpenHarmony_har_usage.en.md).

2. Run the installation command:

   ```
    ohpm install @ohos/xmpp_sasl_anonymous
   ```

## Available APIs

APIs

| Name            | Parameter            | Description                          |
| -------------------- | ---------------- | ------------------------------ |
| saslAnonymous(sasl); | `sasl`: an SASL instance.| Uses anonymous authentication to connect to the XMPP server.|

## Example
```
import _tcp from "@ohos/xmpp_tcp";
import { xml, jid, Client as ClientCore } from "@ohos/xmpp_client_core";
import anonymous from "ohos/xmpp_sasl-anonymous";
import _sasl from "ohos/xmpp_sasl";
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
    const sasl = _sasl({ streamFeatures }, credentials || { username, password });
    const mechanisms = Object.entries({
        plain, // Authentication in plain encryption mode.
        anonymous, // Authentication in anonymous mode.
    }).map(([k, v]) => ({ [k]: v(sasl) }));
}
```

## How to Use

####  Anonymously Connecting the Client to the XMPP Server

```
The main function of this module is to allow anonymous authentication when the client connects to the XMPP server. That is, the client does not need to provide any username or password.
```

## Constraints

This project has been verified in the following version:

DevEco Studio: 5.0.3.200, OpenHarmony SDK: API 12 (5.0.0.21-Canary2)

## Directory Structure
````
|---- @ohos/xmpp_sasl_anonymous 
|     |---- entry  # Sample code
|           |---- src  
|                   |---- main  # Sample code
|                   |---- ohosTest  # xts code
|     |---- library  # @ohos/xmpp_sasl_anonymous library folder
|           |---- ets
|                 |---- lib  # Main dependencies
|                 |---- types  # External APIs
|           |---- index.js  # Main entry file
|           |---- index.d.ts  # Main declaration file of the external APIs
|     |---- README.md  # Readme                   
````

## How to Contribute

If you find any problem during the use, submit an [issue](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/issues) or [PR](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/pulls).

## License

This project is licensed under the terms of the ISC license.
