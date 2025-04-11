

# @ohos/xmpp_connection

## 简介

>本软件是参照开源软件 [@xmpp/connection](https://github.com/xmppjs/xmpp.js/tree/main/packages/connection)源码并用 TypeScript 语言实现了相关功能，在OpenHarmony上提供了一个用于建立和管理XMPP连接的library

## 已支持功能

- 连接到指定的XMPP服务
- 断开socket连接
- 打开流。这个方法会发送流头并开始接收数据
- 关闭流并断开socket。这个方法会发送流尾并结束连接
- 重启流。这个方法会重置连接并尝试重新建立流
- 发送XML元素到服务器。您可以使用这个方法发送任何XML格式的数据
- 自定义socket连接参数
- 将字符串写入socket。这个方法用于将数据发送到服务器

## 下载安装

1. 参考安装教程 [如何安装OpenHarmony ohpm包](https://gitcode.com/openharmony-tpc/docs/blob/master/OpenHarmony_har_usage.md)

2. 安装命令如下：

```
 ohpm install @ohos/xmpp_connection
```

## 接口和属性列表

接口列表

| **接口**           | 参数            | 功能                           |
| ------------------ | --------------- | ------------------------------ |
| **start()**        | 无              | 开始连接和打开流，等待连接成功 |
| connect()          | 无              | 连接到指定的XMPP服务           |
| disconnect()       | 无              | 关闭socket连接                 |
| open()             | 无              | 打开流，发送流头并开始接收数据 |
| stop()             | 无              | 关闭流并断开socket             |
| restart()          | 无              | 重启流                         |
| send()             | xml实例         | 以xml格式的方式发送消息        |
| write（）          | string          | 将字符串写入socket             |
| socketParameters() | service（地址） | 自定义socket连接参数           |

## 使用示例
```
import Connection from '@ohos/xmpp_connection';

// 创建一个新的连接实例，可以传递选项参数
const connection = new Connection({XML元素。当解析器解析到一个XML元素时，该方法会被调用。
  jid: 'user@example.com',
  password: 'password',
  service: 'xmpp://example.com',
});

connection.on('status', (status, ...args) => {
    console.log(`Status: ${status}`, args);
});

connection.on('error', (error) => {
    console.error('Error:', error);
});

connection.on('element', (element) => {
    console.log('Element:', element.toString());
});

connection.start()
    .then(() => {
        console.log('Connected and authenticated');

        // 发送消息示例
        const message = new XmppClient.Element('message', {
            type: 'chat',
            to: 'recipient@example.com'
        });
        message.c('body').t('Hello, recipient!');

        return connection.send(message);
    })
    .then(() => {
        console.log('Message sent');
        return connection.stop();
    })
    .then(() => {
        console.log('Connection closed');
    })
    .catch((error) => {
        console.error('Error:', error);
    });
```

## 使用说明

#### 开启连接到服务器

```
start()方法连接到服务器，并在连接成功后发送一个消息stanza。最后，我们关闭连接start方法中会调用connect（）方法。
connect(): 连接到指定的XMPP服务。这个方法会解析服务URI并尝试建立连接。
```

#### 断开连接

```
disconnect(): 断开socket连接。这个方法会结束当前的连接。
```

#### 打开流

```
open(): 打开流。这个方法会发送流头并开始接收数据
```

#### 关闭流并断开socket

```
stop(): 关闭流并断开socket。这个方法会发送流尾并结束连接。
```

#### 重启流

```
restart(): 重启流。这个方法会重置连接并尝试重新建立流。
```

#### 发送XML

```
send(): 发送XML元素到服务器。您可以使用这个方法发送任何XML格式的数据。
```

#### 将字符串写入socket

```
write(): 将字符串写入socket。这个方法用于将数据发送到服务器。
```

#### 自定义socket连接参数。

```
socketParameters(): 用于自定义socket连接参数。
```
## 关于混淆
- 代码混淆，请查看[代码混淆简介](https://docs.openharmony.cn/pages/v5.0/zh-cn/application-dev/arkts-utils/source-obfuscation.md)
- 如果希望三方库在代码混淆过程中不会被混淆，需要在混淆规则配置文件obfuscation-rules.txt中添加相应的排除规则：
```
-keep
./oh_modules/@ohos/xmpp_connection
```
## 约束与限制

在下述版本验证通过：

- DevEco Studio 版本： 5.0.3.200,OpenHarmony SDK:API12 (5.0.0.22-Canary2)。


## 贡献代码

使用过程中发现任何问题都可以提[Issue](https://gitcode.com/openharmony-tpc/openharmony_tpc_samples/issues) 给我们，当然，我们也非常欢迎你给我们提[PR](https://gitcode.com/openharmony-tpc/openharmony_tpc_samples/pulls) 。

## 开源协议

本项目基于ISC，请自由地享受和参与开源。