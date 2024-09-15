# @ohos/xmpp_iq

## Introduction

>Based on the open source software [@xmpp/iq](https://github.com/xmppjs/xmpp.js/tree/main/packages/iq), this project uses TypeScript to implement similar capabilities. It provides OpenHarmony with a library for processing Info/Query (IQ) requests and responses in the XMPP.

## Supported Features

- Processing IQ requests: parses and processes IQ requests in the XMPP and performs corresponding operations.
- Request verification: performs identity verification and content validity check on IQ requests to ensure data security.
- Response construction: constructs an XMPP-compliant response based on the IQ request type and processing result.
- Error handling: captures and processes errors that occur during IQ request processing, and provides friendly error feedback.
- Routing: determines the server or component through which the IQ request is forwarded based on the destination address in the request.
- Middleware integration: integrates with other modules or services of the system so that data can be called or transferred to related services during IQ request processing.

## How to Install

1. Configure the OpenHarmony ohpm environment. For details, see [OpenHarmony HAR](https://gitee.com/openharmony-tpc/docs/blob/master/OpenHarmony_har_usage.en.md).

2. Run the following installation command:

   ```
    ohpm install @ohos/xmpp_iq
   ```

## Available APIs

Supported APIs

| API              | Parameter                                                        | Description                                                        |
| ---------------------- | ------------------------------------------------------------ | ------------------------------------------------------------ |
| iqCallee(options)      | `options`: an object that contains the middleware and XMPP entity.                   | A factory function used to create an IQ processing module.                        |
| get(ns, name, handler) | `ns`: namespace of the XMPP stanza. `name`: name of the getter or setter in the IQ stanza. `handler`: handler to process the IQ request with a specific namespace and name.| Registers a handle to process an IQ GET request with a specific namespace and name. When you call this API and pass in `handler`, it adds the handler to the middleware chain so that the handler is called to process the GET IQ request with the matching namespace and name.|
| set(ns, name, handler) | `ns`: namespace of the XMPP stanza. `name`: name of the getter or setter in the IQ stanza. `handler`: handler to process the IQ request with a specific namespace and name.| Registers a handle to process an IQ SET request. In this way, `iqCallee` provides a modular way to process different types of IQ requests, and different handler can be registered as required.|

## Example
````
import Connection = require("@xmpp/connection");
import iqCallee = require("@xmpp/iq/callee");
import iqCaller = require("@xmpp/iq/caller");
import middleware = require("@xmpp/middleware");
import { Element } from "@xmpp/xml";

// test type exports
type IQCallee<TEntity extends middleware.Entity> = iqCallee.IQCallee<TEntity>;
type IQCaller<TEntity extends middleware.Entity> = iqCaller.IQCaller<TEntity>;

class Foo extends Connection implements middleware.Entity {
domain?: string;
hookOutgoing?: (stanza: Element) => Promise<void>;

    headerElement() {
        return new Element("foo");
    }

    socketParameters(service: string) {
        return null;
    }
}

const ent = new Foo({ service: "foo", domain: "foo.bar" });
const mw = middleware({ entity: ent });

const callee = iqCallee({ middleware: mw, entity: ent }); // $ExpectType IQCallee<Foo>
callee.get("foo", "bar", (ctx, next) => {
ctx; // $ExpectType IncomingContext<Foo>
next; // $ExpectType Next
return next();
});
callee.set("foo", "bar", (ctx, next) => {
ctx; // $ExpectType IncomingContext<Foo>
next; // $ExpectType Next
return next();
});

const caller = iqCaller({ middleware: mw, entity: ent }); 
caller.entity; // $ExpectType Foo
caller.handlers; // $ExpectType Map<string, Deferred<Element>>
caller.middleware; // $ExpectType Middleware<Foo>
caller.get(new Element("foo")); 
caller.get(new Element("foo"), "bar"); 
caller.get(new Element("foo"), "bar", 10); 
caller.set(new Element("foo")); 
caller.set(new Element("foo"), "bar"); 
caller.set(new Element("foo"), "bar", 10); 
caller.request(new Element("foo")); 
caller.request(new Element("foo"), 10); 
caller.start(); 
````
## How to Use

@ohos/xmpp_iq is a component of @ohos/xmpp_client. The IQ stanza is the basic communication unit used for requesting and responding to XMPP data.

## Constraints

This project has been verified in the following version:

- DevEco Studio: 5.0.3.200, OpenHarmony SDK: API 12 (5.0.0.21-Canary2)

## Directory Structure
````
|---- @ohos/xmpp_iq
|     |---- entry  # Sample code
|           |---- src  
|                   |---- main  # Sample code
|                   |---- ohosTest  # xts code
|     |---- library  # @ohos/xmpp_iq library
|           |---- ets
|                 |---- lib  # Main dependencies
|                 |---- types  # External APIs
|           |---- index.js  # Main entry file
|           |---- index.d.ts  # Main declaration file of the external APIs
|     |---- README_EN.md  # Readme                   
````

## How to Contribute

If you find any problem when using @ohos/xmpp_iq, submit an [issue](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/issues) or a [PR](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/pulls).

## License

This project is licensed under ISC License.
