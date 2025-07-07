# @ohos/xmpp_stream_features

## Introduction

>Based on the open source software [xmpp_connection](https://github.com/xmppjs/xmpp.js/tree/main/packages/stream-feraturs), this project uses TypeScript to implement similar capabilities. It provides OpenHarmony with a library for establishing and managing XMPP stream connections.

## Supported Features

- Processing stream features
- Using middleware
- Invoking feature processors
- Error handling

## How to Install

1. Configure the OpenHarmony ohpm environment. For details, see [OpenHarmony HAR](https://gitcode.com/openharmony-tpc/docs/blob/master/OpenHarmony_har_usage.en.md).

2. Run the following installation command:

   ```
    ohpm install @ohos/xmpp_stream_features
   ```

## Available APIs

Supported APIs

| API                             | Parameter                                                        | Description            |
| ------------------------------------- | ------------------------------------------------------------ | ---------------- |
| use(featureName, namespace, callback) | **featureName**, **namespace**, and **callback** (function for processing specific feature events)| Handles a feature event.|

## Example
```
// Use the middleware registered by streamFeatures.use() for XMPP stream management.
import streamFeatures from "@ohos/xmpp_stream_features";
const NS = "urn:xmpp:sm:3";
streamFeatures.use("sm", NS, async (context, next) => {
    // Resuming
    if (sm.id) {
      try {
        await resume(entity, sm.inbound, sm.id);
        sm.enabled = true;
        entity.jid = address;
        entity.status = "online";
        return true;
        // If resumption fails, continue with session establishment
        // eslint-disable-next-line no-unused-vars
      } catch {
        sm.id = "";
        sm.enabled = false;
        sm.outbound = 0;
      }
    }

    // Enabling

    // Resource binding first
    await next();

    const promiseEnable = enable(entity, sm.allowResume, sm.preferredMaximum);

    // > The counter for an entity's own sent stanzas is set to zero and started after sending either <enable/> or <enabled/>.
    sm.outbound = 0;

    try {
      const response = await promiseEnable;
      sm.enabled = true;
      sm.id = response.attrs.id;
      sm.max = response.attrs.max;
      // eslint-disable-next-line no-unused-vars
    } catch {
      sm.enabled = false;
    }

    sm.inbound = 0;
  });
```

## How to Use

#### Registering a Middleware Processing Function on the Stream of the XMPP Connection

```
streamFeatures.use(featureName, namespace, callback);
// featureName: usually a string, indicating the name of the feature or protocol to be used, for example, sm (Stream Management).
// namespace: usually a string, indicating the XML namespace used by the feature, for example, "http://jabber.org/protocol/stream-management".
// callback: an asynchronous function that receives two parameters: context (context object, including connection and session information) and next (a function used to continue to execute the next middleware or continue to execute the stream establishment process after a specific operation is complete).
In the callback function, you can write the logic for processing specific capabilities, such as connection establishment, data transmission, and error handling. If the middleware requires asynchronous operations, you can use **await** in the callback function to wait until the operation is complete.

const streamFeatures = connection.features.streamFeatures; // Obtain the streamFeatures object of the connection.

streamFeatures.use("sm", NS, async (context, next) => {
  // Add the SM middleware logic here.
  // ...
  await next(); // Call next() to continue the stream establishment process.
});

```
## About obfuscation
- Code obfuscation, please see[Code Obfuscation](https://docs.openharmony.cn/pages/v5.0/zh-cn/application-dev/arkts-utils/source-obfuscation.md)
- If you want the library not to be obfuscated during code obfuscation, you need to add corresponding exclusion rules in the obfuscation rule configuration file obfuscation-rules.txt：
```
-keep
./oh_modules/@ohos/xmpp_stream_features
```
## Constraints

This project has been verified in the following version:

- DevEco Studio: 5.0.3.200, OpenHarmony SDK: API 12 (5.0.0.21-Canary2)

## Directory Structure
````
|---- @ohos/xmpp_stream_features 
|     |---- entry  # Sample code
|           |---- src  
|                   |---- main  # Sample code
|                   |---- ohosTest  # xts code
|     |---- library  # @ohos/xmpp_stream_features library
|           |---- ets
|                 |---- lib  # Main dependencies
|                 |---- types  # External APIs
|           |---- index.js  # Main entry file
|           |---- index.d.ts  # Main declaration file of the external APIs
|     |---- README.md  # Readme                   
|     |---- README_zh.md  # Readme                   
````

## How to Contribute

If you find any problem when using @ohos/xmpp_stream_features, submit an [issue](https://gitcode.com/openharmony-tpc/openharmony_tpc_samples/issues) or a [PR](https://gitcode.com/openharmony-tpc/openharmony_tpc_samples/pulls).

## License

This project is licensed under [ISC License](https://gitcode.com/openharmony-tpc/openharmony_tpc_samples/blob/master/xmpp_stream_features/LICENSE).
