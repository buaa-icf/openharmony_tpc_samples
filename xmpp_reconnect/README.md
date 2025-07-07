# @ohos/xmpp_reconnect

## Introduction

>Based on the open source software [xmpp_reconnect](https://github.com/xmppjs/xmpp.js/tree/main/packages/reconnect), this project uses TypeScript to implement similar capabilities. It provides OpenHarmony with a library for automatic reconnection of the XMPP client.

## Supported Features

- Reconnection

## How to Install
1. Configure the OpenHarmony ohpm environment. For details, see [OpenHarmony HAR](https://gitcode.com/openharmony-tpc/docs/blob/master/OpenHarmony_har_usage.en.md).

2. Run the following installation command:

   ```
    ohpm install @ohos/xmpp_reconnect
   ```

## Available APIs

Supported APIs

| API           | Parameter| Description                                                        |
| ------------------- | ---- | ------------------------------------------------------------ |
| scheduleReconnect() | N/A  | Clears the previous timer, sets a new timer, and initiates a reconnection when the new timer expires.|
| reconnect()         | N/A  | Triggers the `reconnecting` event and calls the `connect` and `open` APIs of `entity` for reconnection.|
| start()             | N/A  | Initializes the reconnection module, sets a listener to listen for the disconnection event of `entity`, and calls `scheduleReconnect` to start reconnection scheduling.|
| stop()              | N/A  | Stops the reconnection module, removes the listener that listens for the disconnection event, and clears the timer.    |

## Example
```
import { client } from '@ohos/xmpp_client';
import reconnect from '@ohos/xmpp_reconnect';

const entity = client({
  service: 'xmpp://example.com',
  domain: 'example.com',
  lang: 'en'
});

const reconnector = reconnect({ entity });
reconnector.on('reconnecting', () => {
  console.log('Reconnecting...');
});
reconnector.on('reconnected', () => {
  console.log('Reconnected');
});

entity.start().catch(console.error);

```

## How to Use

#### Reconnection Scheduling

```
scheduleReconnect() // Set a new timer for reconnection.
```

#### Initiating Reconnection

```
reconnect() // Called after a disconnection is detected.
```

#### Initializing the Reconnection Module

```
start(): initializes the reconnection module, sets a listener to listen for the disconnection event of entity, and calls scheduleReconnect to start reconnection scheduling.
```

#### Stopping Reconnection

```
stop(): stops the reconnection module, removes the listener, and clears the timer.
```
## About obfuscation
- Code obfuscation, please see[Code Obfuscation](https://docs.openharmony.cn/pages/v5.0/zh-cn/application-dev/arkts-utils/source-obfuscation.md)
- If you want the library not to be obfuscated during code obfuscation, you need to add corresponding exclusion rules in the obfuscation rule configuration file obfuscation-rules.txt：
```
-keep
./oh_modules/@ohos/xmpp_reconnect
```
## Constraints

This project has been verified in the following version:

- DevEco Studio: 5.0.3.200, OpenHarmony SDK: API 12 (5.0.0.21-Canary2)

## Directory Structure
```
|---- xmpp_reconnect
|     |---- entry  # Sample code
|     |---- library  # xmpp_reconnect library
|               |----src/main #
|                    |----lib # xmpp_reconnect code folder
|               |----index.d.ts # External APIs
|               |---- index.js  # Main entry file
|     |---- README.md  # Readme
|     |---- README_zh.md  # Readme
```

## How to Contribute

If you find any problem when using @ohos/xmpp_reconnect, submit an [issue](https://gitcode.com/openharmony-tpc/openharmony_tpc_samples/issues) or a [PR](https://gitcode.com/openharmony-tpc/openharmony_tpc_samples/pulls).

## License

This project is licensed under [ISC License](https://gitcode.com/openharmony-tpc/openharmony_tpc_samples/blob/master/xmpp_reconnect/LICENSE).
