# amqplib

## 简介

> 本软件是参照开源软件 [amqplib](https://github.com/amqp-node/amqplib) 源码并用 TypeScript 语言实现了相关功能，在OpenHarmony上支持AMQP（Advanced Message Queuing Protocol）网络通信协议的library，可以在一个进程间传递异步消息。

## 下载安装

1. 参考安装教程 [如何安装OpenHarmony ohpm包](https://gitcode.com/openharmony-tpc/docs/blob/master/OpenHarmony_har_usage.md)

2. 安装命令如下：

   ```
   ohpm install @ohos/amqplib
   ```
   
## 使用说明
### 使用前言
1. 需要搭建RabbitMQ环境，请根据该参考链接安装环境：https://zhuanlan.zhihu.com/p/381644577

2. RabbitMQ与Erlang是存在版本对应关系，两者版本如果不对应会出现许多问题，详见：https://www.rabbitmq.com/which-erlang.html

3. 可参考版本对应关系：

   1. RabbitMQ版本为"rabbitmq-server-3.10.7.exe"，下载链接：https://github.com/rabbitmq/rabbitmq-server/releases/tag/v3.10.7
   2. Erlang版本为"otp_win64_25.0.exe"，下载链接：https://www.erlang.org/patches/otp-25.0

4. 由于RabbitMQ默认的guest只能从localhost连接不能使用远程连接，官方给出的解决方案是通过配置文件修改RabbitMQ的配置，以下是修改步骤：

   1. 找到RabbitMQ的安装目录，以rabbitmq-server-3.10.7为例；

   2. 在\rabbitmq_server-3.10.7\etc下有个README.txt文件，通过文件指引找到"真正"的RabbitMQ；

   3. 在C:\Users\%USERNAME%\AppData\Roaming\RabbitMQ目录下新建一个配置文件：rabbitmq.config，并写入：

      ```
      [{rabbit, [{loopback_users, []}]}].
      ```

   4. 保存并退出；

   5. 重启RabbitMQ服务：

      1. win键+R输入cmd，打开命令行窗口；

      2. 输入以下命令打开电脑服务；

         ```
         SERVICES.MSC
         ```

      3. 找到RabbitMQ单击并点击重启动此服务；

5. 测试机需联网并且与服务器的ip地址需要相同；

6. 编译并安装hap包到测试机即可进行用例测试；

7. 具体使用demo请参考开源库sample页面的实现；

## 接口说明

---

| 方法名          | 入参                                                                 | 接口描述                                                                 |
|-----------------|----------------------------------------------------------------------|--------------------------------------------------------------------------|
| `assertQueue`   | `(queue: string, options?: { durable?: boolean, exclusive?: boolean, autoDelete?: boolean, arguments?: Object })` | 声明队列，若不存在则创建。返回 `{ queue: string, messageCount: number, consumerCount: number }`。 |
| `checkQueue`    | `(queue: string)`                                                    | 检查队列是否存在，返回队列信息（`messageCount` 和 `consumerCount`）。     |
| `deleteQueue`   | `(queue: string, options?: { ifUnused?: boolean, ifEmpty?: boolean })` | 删除队列。`ifUnused`（仅当无消费者时删除）、`ifEmpty`（仅当队列为空时删除）。 |
| `purgeQueue`    | `(queue: string)`                                                    | 清空队列中的消息，返回删除的消息数量（`{ messageCount: number }`）。      |
| `bindQueue`     | `(queue: string, exchange: string, pattern: string, args?: Object)`  | 将队列绑定到交换器，`pattern` 为路由键（或匹配规则）。                   |
| `unbindQueue`   | `(queue: string, exchange: string, pattern: string, args?: Object)`  | 解绑队列与交换器的绑定关系。                                             |
| `assertExchange`  | `(exchange: string, type: 'direct' \| 'topic' \| 'headers' \| 'fanout' \| string, options?: { durable?: boolean, autoDelete?: boolean, internal?: boolean, arguments?: Object })` | 声明交换器，若不存在则创建。`type` 支持标准类型或自定义。                 |
| `checkExchange`   | `(exchange: string)`                                                 | 检查交换器是否存在。                                                     |
| `deleteExchange`  | `(exchange: string, options?: { ifUnused?: boolean })`               | 删除交换器。`ifUnused` 表示仅当无绑定时删除。                            |
| `bindExchange`    | `(destination: string, source: string, pattern: string, args?: Object)` | 绑定两个交换器（目标交换器绑定到源交换器）。                             |
| `unbindExchange`  | `(destination: string, source: string, pattern: string, args?: Object)` | 解绑两个交换器。                                                         |
| `publish`       | `(exchange: string, routingKey: string, content: Buffer, options?: { persistent?: boolean, expiration?: string, headers?: Object, ... })` | 向交换器发布消息。`options` 支持消息属性（如持久化、TTL、优先级等）。    |
| `sendToQueue`   | `(queue: string, content: Buffer, options?: { persistent?: boolean, ... })` | 直接发送消息到队列（绕过交换器）。                                       |
| `consume`       | `(queue: string, onMessage: (msg: ConsumeMessage \| null) => void, options?: { noAck?: boolean, exclusive?: boolean, ... })` | 注册消费者，处理队列中的消息。返回消费者标签（`consumerTag`）。          |
| `cancel`        | `(consumerTag: string)`                                              | 取消指定标签的消费者。                                                   |
| `get`           | `(queue: string, options?: { noAck?: boolean })`                     | 同步获取单条消息（非推送模式）。返回 `ConsumeMessage` 或 `null`（空队列）。 |
| `ack`      | `(message: Message, allUpTo?: boolean)`                              | 确认单条消息。`allUpTo` 为 `true` 时确认当前消费者之前所有未确认的消息。  |
| `ackAll`   | `()`                                                                 | 确认当前 Channel 中所有未确认的消息。                                    |
| `nack`     | `(message: Message, allUpTo?: boolean, requeue?: boolean)`           | 否定确认单条消息，可选择重新入队（`requeue`）。                           |
| `nackAll`  | `(requeue?: boolean)`                                                | 否定确认所有未确认的消息，可选择重新入队。                               |
| `reject`   | `(message: Message, requeue?: boolean)`                              | 拒绝单条消息（类似 `nack` 但仅针对一条）。                               |
| `prefetch` | `(count: number, global?: boolean)`                                  | 设置 QoS 预取限制（未确认消息数上限）。`global` 为 `true` 时作用于整个连接。 |
| `recover`  | `()`                                                                 | 重新投递未确认的消息（需服务器支持，非所有场景可用）。                   |

---




## 关于混淆
- 代码混淆，请查看[代码混淆简介](https://docs.openharmony.cn/pages/v5.0/zh-cn/application-dev/arkts-utils/source-obfuscation.md)
- 如果希望amqplib库在代码混淆过程中不会被混淆，需要在混淆规则配置文件obfuscation-rules.txt中添加相应的排除规则：
```
-keep
./oh_modules/@ohos/amqplib
```

## 约束与限制

在下述版本验证通过：

- DevEco Studio: NEXT Beta1-5.0.3.806, SDK: API12 Release(5.0.0.66)

- DevEco Studio 版本： 4.1 Canary(4.1.3.317) OpenHarmony SDK:API11 (4.1.0.36)


## 目录结构

```
|---- amqplib 
|     |---- entry  # 示例代码文件夹
|     |---- library  # amqplib库文件夹
|           |---- ets
|                 |---- lib  # 主要依赖
|                 |---- types  # 对外接口文件夹
|                       |---- callback_api.d.ts  # 交换机连接交互相关接口文件
|                       |---- index.d.ts  # 主对外接口文件
|                       |---- properties.d.ts  # 参数类型等对外声明文件
|                 |---- callback_api.js  # callback回调脚本
|                 |---- channel_api.js  # promise回调脚本
|     |---- README.md  # 安装使用方法
|     |---- README_zh.md  # 安装使用方法
```

## 贡献代码

使用过程中发现任何问题都可以提 [Issue](https://gitcode.com/openharmony-tpc/openharmony_tpc_samples/issues) ，当然，也非常欢迎提 [PR](https://gitcode.com/openharmony-tpc/openharmony_tpc_samples/pulls) 。

## 开源协议

本项目基于 [MIT LICENSE](https://gitcode.com/openharmony-tpc/openharmony_tpc_samples/blob/master/amqplib/LICENSE) ，请自由地享受和参与开源。
