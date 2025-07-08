# @ohos/xmpp_component

## Introduction

>Based on the open source software [@xmpp/component](https://github.com/xmppjs/xmpp.js/tree/main/packages/component), this project uses TypeScript to implement similar capabilities. It provides OpenHarmony with a library for creating Extensible Messaging and Presence Protocol (XMPP) components.

## Supported Features

- Component connection: establishes and manages connections with XMPP servers and other components, including authentication, streaming features, and error handling.
- Message routing: processes received and sent messages, including processing message stanzas (XML messages), metadata, and errors.
- Component discovery: includes component discovery protocol support, which is used to display component capabilities and functionalities.

## How to Install

1. [Install an OpenHarmony HAR](https://gitcode.com/openharmony-tpc/docs/blob/master/OpenHarmony_har_usage.en.md).

2. Run the installation command:

   ```
    ohpm install @ohos/xmpp_component
   ```

## Available APIs

APIs

| Name          | Parameter                                                        | Description                                                        |
| ------------------ | ------------------------------------------------------------ | ------------------------------------------------------------ |
| component(options) | `options`: an object that contains properties such as password, service, and domain. These properties are used to configure XMPP components.| Provides core functionalities required for XMPP communication, reconnection mechanism, middleware processing, and IQ (information/query) caller and callee.|

## Example
```
import { Component, component, jid, Options, xml } from "@ohos/xmpp_component";
import { Component as ComponentCore } from "@ohos/xmpp_component_core";

// test type exports
type Opts = Options;
type Cl = Component;

const c = component({}); // $ExpectType Component
component({ password: "foo" }); // $ExpectType Component
// $ExpectType Component
component({
    password: async auth => {
        auth; // $ExpectType (password: string) => Promise<void>
        await auth("foo");
    },
});
component({ domain: "foo" }); // $ExpectType Component
component({ service: "foo.bar" }); // $ExpectType Component

const cc: ComponentCore = c;
c.entity; // $ExpectType Component
c.reconnect; // $ExpectType Reconnect<Component>
c.middleware; // $ExpectType Middleware<Component>
c.iqCaller; // $ExpectType IQCaller<Component>
c.iqCallee; // $ExpectType IQCallee<Component>

jid("foo");
jid(null, "foo", "bar");

xml("foo");
xml("foo", { foo: "bar" }, "bar");
```

## How to Use

```
import { Component, component, jid, Options, xml } from "@ohos/xmpp_component";
import { Component as ComponentCore } from "@ohos/xmpp_component_core";
// Import Component, component, jid, Options, and xml in the @ohos/xmpp_component library and Component (renamed ComponentCore) in the @ohos/xmpp_component_core library.

// Two type aliases (Opts and Cl) are defined, representing the Options and Component types, respectively.
type Opts = Options;
type Cl = Component;

// Use the component() function to create a Component instance. The first example does not pass in any options, and the second example passes in an options object that contains the password property.
const c = component({}); 
component({ password: "foo" }); 
// $ExpectType Component
component({
// Use asynchronous password authentication. The options object passed to the component() function contains the password property, which is an asynchronous function that accepts an auth function as a parameter and calls the function to verify the password.
    password: async auth => {
        auth; // $ExpectType (password: string) => Promise<void>
        await auth("foo");
    },
});
component({ domain: "foo" }); 
component({ service: "foo.bar" }); 

const cc: ComponentCore = c;
c.entity; 
c.reconnect; 
c.middleware; 
c.iqCaller; 
c.iqCallee;

jid("foo");
jid(null, "foo", "bar");

xml("foo");
xml("foo", { foo: "bar" }, "bar");
```

## About obfuscation
- Code obfuscation, please see[Code Obfuscation](https://docs.openharmony.cn/pages/v5.0/zh-cn/application-dev/arkts-utils/source-obfuscation.md)
- If you want the xmpp_component library not to be obfuscated during code obfuscation, you need to add corresponding exclusion rules in the obfuscation rule configuration file obfuscation-rules.txt：
```
-keep
./oh_modules/@ohos/xmpp_component
```

## Constraints

This project has been verified in the following version:

DevEco Studio: 5.0.3.200, OpenHarmony SDK: API 12 (5.0.0.21-Canary2)

## Directory Structure
````
|---- @ohos/xmpp_component
|     |---- entry  # Sample code
|           |---- src  
|                   |---- main  # Sample code
|                   |---- ohosTest  # xts code
|     |---- library  # @ohos/xmpp_component library folder
|           |---- ets
|                 |---- lib  # Main dependencies
|                 |---- types  # External APIs
|           |---- index.js  # Main entry file
|           |---- index.d.ts  # Main declaration file of the external APIs
|     |---- README.md  # Readme                   
````

## How to Contribute

If you find any problem during the use, submit an [issue](https://gitcode.com/openharmony-tpc/openharmony_tpc_samples/issues) or [PR](https://gitcode.com/openharmony-tpc/openharmony_tpc_samples/pulls).

## License

This project is licensed under the terms of the [ISC license](https://gitcode.com/openharmony-tpc/openharmony_tpc_samples/blob/master/xmpp_component/LICENSE).
