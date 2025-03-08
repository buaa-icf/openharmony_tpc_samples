# @ohos/xmpp_component_core

## Introduction

>Based on the open source software [@xmpp/component-core](https://github.com/xmppjs/xmpp.js/tree/main/packages/component-core), this project uses TypeScript to implement similar capabilities. It provides OpenHarmony with a library for creating Extensible Messaging and Presence Protocol (XMPP) components and connecting to the XMPP server.

## Supported Features

- The constructed component or server is compatible with other XMPP entities.
- Some basic XMPP functions, such as authentication, connection management, and element sending/receiving, are provided.

## How to Install

1. [Install an OpenHarmony HAR](https://gitcode.com/openharmony-tpc/docs/blob/master/OpenHarmony_har_usage.en.md).

2. Run the installation command:

   ```
    ohpm install @ohos/xmpp_component_core
   ```

## Available APIs

APIs

| Name                 | Parameter                                                     | Description                                                        |
| ------------------------- | --------------------------------------------------------- | ------------------------------------------------------------ |
| authenticate(id,password) | `id`: JID of the component or server; `password`: password of the component or server.| Performs authentication and verifies the passed-in ID and password by calculating the SHA-1 hash value.|

## Example
```
import Component  from "@ohos/xmpp_component_core";
const component = new Component({
  jid: 'mycomponent@domain.tld',
  password: 'mypassword'
});

// Listen for connection success events.
component.on('connect', () => {
  console.log('Connected to the XMPP server.');
});

// Listen for events indicating that a message is received.
component.on('message', (msg) => {
  console.log('Message received:', msg);
});

// Connect to the XMPP server.
component.connect().catch((err) => {
  console.error('Connection failed:', err);
});
```

## How to Use

```
@@ohos/xmpp_component_core is used to build an XMPP component or server. It is part of the @xmpp project.
import Component  from "@ohos/xmpp_component_core";
const component = new Component({
  jid: 'mycomponent@domain.tld',
  password: 'mypassword'
});

// Listen for connection success events.
component.on('connect', () => {
  console.log('Connected to the XMPP server.');
});

// Listen for events indicating that a message is received.
component.on('message', (msg) => {
  console.log('Message received:', msg);
});

// Connect to the XMPP server.
component.connect().catch((err) => {
  console.error('Connection failed:', err);
});
Import the @xmpp/component-core module, create a Component instance, and pass in the JID and password. Then, listen for the connection success events and message receiving events, and print related information on the console. Call the connect() function to connect to the XMPP server.
```

## About obfuscation
- Code obfuscation, please see[Code Obfuscation](https://docs.openharmony.cn/pages/v5.0/zh-cn/application-dev/arkts-utils/source-obfuscation.md)
- If you want the xmpp_component_core library not to be obfuscated during code obfuscation, you need to add corresponding exclusion rules in the obfuscation rule configuration file obfuscation-rules.txt：
```
-keep
./oh_modules/@ohos/xmpp_component_core
```

## Constraints

This project has been verified in the following version:

DevEco Studio: 5.0.3.200, OpenHarmony SDK: API 12 (5.0.0.21-Canary2)

## Directory Structure
````
|---- @ohos/xmpp_component_core 
|     |---- entry  # Sample code
|           |---- src  
|                   |---- main  # Sample code
|                   |---- ohosTest  # xts code
|     |---- library  # @ohos/xmpp_component_core library folder
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

This project is licensed under the terms of the ISC license.
