# amqplib

## Introduction

> This project uses TypeScript to implement capabilities similar to [amqplib](https://github.com/amqp-node/amqplib) on OpenHarmony. It supports the Advanced Message Queuing Protocol (AMQP), which allows the transmission of asynchronous messages across processes.

## How to Install

1. Configure the OpenHarmony ohpm environment. For details, see [OpenHarmony HAR](https://gitcode.com/openharmony-tpc/docs/blob/master/OpenHarmony_har_usage.en.md).

2. Run the following installation command:

   ```
   ohpm install @ohos/amqplib
   ```
   
## How to Use
### Geting Started
1. Set up the RabbitMQ environment.

2. There is a version mapping between RabbitMQ and Erlang. Unexpected problems may arise if the two versions do not match. For details, see [Erlang Version Requirements](https://www.rabbitmq.com/which-erlang.html).

3. Version mapping:

   1. RabbitMQ version **rabbitmq-server-3.10.7.exe**: https://github.com/rabbitmq/rabbitmq-server/releases/tag/v3.10.7
   2. Erlang version **otp_win64_25.0.exe**: https://www.erlang.org/patches/otp-25.0

4. By default, the guest of RabbitMQ can only be connected from localhost. The official solution is to modify the RabbitMQ configuration in the configuration file. The procedure is as follows:

   1. Find the RabbitMQ installation directory, for example, **rabbitmq-server-3.10.7**.

   2. In the **README.txt** file in **\rabbitmq_server-3.10.7\etc**, find the real RabbitMQ.

   3. Create the configuration file **rabbitmq.config** in **C:\Users\ %USERNAME %\AppData\Roaming\RabbitMQ** and write the following information into the file:

      ```
      [{rabbit, [{loopback_users, []}]}].
      ```

   4. Save and exit.

   5. Restart the RabbitMQ service.

      1. Press Win+R and enter cmd to open the CLI.

      2. Launch the Services Manager.

         ```
         SERVICES.MSC
         ```

      3. Find RabbitMQ and click Restart to restart the service.

5. Connect the test PC to the network. Make sure that its IP address is the same as that of the server.

6. Compile and install the HAP on the test PC to perform the test cases.

7. For details about how to use the demo, see the implementation of the sample page.

## Available APIs
---

| **Method Name**       | **Parameters**                                                                 | **Description**                                                                 |
|-----------------------|--------------------------------------------------------------------------------|---------------------------------------------------------------------------------|
| `assertQueue`         | `(queue: string, options?: { durable?: boolean, exclusive?: boolean, autoDelete?: boolean, arguments?: Object })` | Declares a queue, creating it if it does not exist. Returns `{ queue: string, messageCount: number, consumerCount: number }`. |
| `checkQueue`          | `(queue: string)`                                                              | Checks if a queue exists and returns queue information (`messageCount` and `consumerCount`). |
| `deleteQueue`         | `(queue: string, options?: { ifUnused?: boolean, ifEmpty?: boolean })`          | Deletes a queue. `ifUnused` (delete only if no consumers) or `ifEmpty` (delete only if empty). |
| `purgeQueue`          | `(queue: string)`                                                              | Clears all messages from a queue and returns the count of deleted messages (`{ messageCount: number }`). |
| `bindQueue`           | `(queue: string, exchange: string, pattern: string, args?: Object)`             | Binds a queue to an exchange, where `pattern` is the routing key (or matching rule). |
| `unbindQueue`         | `(queue: string, exchange: string, pattern: string, args?: Object)`             | Unbinds a queue from an exchange.                                               |
| `assertExchange`      | `(exchange: string, type: 'direct' \| 'topic' \| 'headers' \| 'fanout' \| string, options?: { durable?: boolean, autoDelete?: boolean, internal?: boolean, arguments?: Object })` | Declares an exchange, creating it if it does not exist. `type` supports standard or custom types. |
| `checkExchange`       | `(exchange: string)`                                                           | Checks if an exchange exists.                                                    |
| `deleteExchange`      | `(exchange: string, options?: { ifUnused?: boolean })`                          | Deletes an exchange. `ifUnused` means delete only if no bindings exist.          |
| `bindExchange`        | `(destination: string, source: string, pattern: string, args?: Object)`        | Binds two exchanges (destination exchange to source exchange).                   |
| `unbindExchange`      | `(destination: string, source: string, pattern: string, args?: Object)`        | Unbinds two exchanges.                                                          |
| `publish`             | `(exchange: string, routingKey: string, content: Buffer, options?: { persistent?: boolean, expiration?: string, headers?: Object, ... })` | Publishes a message to an exchange. `options` supports message properties (e.g., persistence, TTL, priority). |
| `sendToQueue`         | `(queue: string, content: Buffer, options?: { persistent?: boolean, ... })`      | Sends a message directly to a queue (bypassing exchanges).                        |
| `consume`             | `(queue: string, onMessage: (msg: ConsumeMessage \| null) => void, options?: { noAck?: boolean, exclusive?: boolean, ... })` | Registers a consumer to process messages from a queue. Returns a consumer tag (`consumerTag`). |
| `cancel`              | `(consumerTag: string)`                                                        | Cancels a consumer with the specified tag.                                       |
| `get`                 | `(queue: string, options?: { noAck?: boolean })`                               | Synchronously retrieves a single message (non-push mode). Returns `ConsumeMessage` or `null` (empty queue). |
| `ack`                 | `(message: Message, allUpTo?: boolean)`                                        | Acknowledges a single message. If `allUpTo` is `true`, acknowledges all unacknowledged messages up to the current one. |
| `ackAll`              | `()`                                                                           | Acknowledges all unacknowledged messages in the current channel.                  |
| `nack`                | `(message: Message, allUpTo?: boolean, requeue?: boolean)`                      | Negatively acknowledges a single message, optionally requeuing it (`requeue`).   |
| `nackAll`             | `(requeue?: boolean)`                                                          | Negatively acknowledges all unacknowledged messages, optionally requeuing them.  |
| `reject`              | `(message: Message, requeue?: boolean)`                                        | Rejects a single message (similar to `nack` but for one message only).           |
| `prefetch`            | `(count: number, global?: boolean)`                                             | Sets QoS prefetch limit (max unacknowledged messages). If `global` is `true`, applies to the entire connection. |
| `recover`             | `()`                                                                           | Redelivers unacknowledged messages (requires server support; not available in all scenarios). |

---


## About obfuscation
- Code obfuscation, please see[Code Obfuscation](https://docs.openharmony.cn/pages/v5.0/zh-cn/application-dev/arkts-utils/source-obfuscation.md)
- If you want the amqplib library not to be obfuscated during code obfuscation, you need to add corresponding exclusion rules in the obfuscation rule configuration file obfuscation-rules.txt：
```
-keep
./oh_modules/@ohos/amqplib
```

## Constraints

This project has been verified in the following version:

- DevEco Studio: 4.1 Canary (4.1.3.317), OpenHarmony SDK: API 11 (4.1.0.36)


## Directory Structure

```
|---- amqplib 
|     |---- entry  # Sample code
|     |---- library  # amqplib library
|           |---- ets
|                 |---- lib  # Main dependencies
|                 |---- types  # External APIs
|                       |---- callback_api.d.ts  # Interface file related to exchange connection and interaction
|                       |---- index.d.ts  # Main external interface file
|                       |---- properties.d.ts  # External declaration file of the parameter types
|                 |---- callback_api.js  # Callback scripts
|                 |---- channel_api.js  # Promise scripts
|     |---- README.md  # Readme
|     |---- README_zh.md  # Readme
```

## How to Contribute

If you find any problem when using amqplib, submit an [issue](https://gitcode.com/openharmony-tpc/openharmony_tpc_samples/issues) or a [PR](https://gitcode.com/openharmony-tpc/openharmony_tpc_samples/pulls).

## License

This project is licensed under [MIT LICENSE](https://gitcode.com/openharmony-tpc/openharmony_tpc_samples/blob/master/amqplib/LICENSE).
