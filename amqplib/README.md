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

* **Connection**: interface related to AMQP connections, including the connection methods and events.
* **Channel**: interface related to AMQP channels, including the channel methods and events.
* **createChannel**: creates a channel.
* **Channel.close**: closes a channel.
* **Connection.close**: closes a connection.
* **assertQueue**: asserts a queue.
* **checkQueue**: checks a queue.
* **deleteQueue**: deletes a queue.
* **purgeQueue**: purges a queue.
* **bindQueue**: binds a queue.
* **unbindQueue**: unbinds a queue.
* **assertExchange**: asserts an exchange.
* **checkExchange**: checks an exchange.
* **deleteExchange**: deletes an exchange.
* **bindExchange**: binds an exchange.
* **unbindExchange**: unbinds an exchange.
* **publish**: sends a message.
* **sendToQueue**: sends a message to a queue.
* **consume**: consumes a message.
* **cancel**: cancels the consumption.
* **get**: obtains the message body.
* **ack**: acknowledges that the message has been consumed.
* **ackAll**: acknowledges that all unacknowledged messages have been consumed.
* **nack**: acknowledges that the message is not successfully consumed.
* **nackAll**: acknowledges that all unacknowledged messages are not successfully consumed.
* **reject**: rejects a message, indicating that the message is not successfully consumed.
* **prefetch**: prefetches a certain number of messages from the queue at a time.
* **recover**: resends unacknowledged messages so that they enter the queue again for consumption.

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
