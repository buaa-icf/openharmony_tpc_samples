

# @ohos/xmpp_reconnect

## 简介

>本软件是参照开源软件 [xmpp_reconnect]((https://github.com/xmppjs/xmpp.js/tree/main/packages/reconnect))源码并用 TypeScript 语言实现了相关功能，在OpenHarmony上提供了一个用于 XMPP（Extensible Messaging and Presence Protocol，可扩展消息和状态协议）客户端的库，它提供了自动重连功能的library

## 已支持功能

- 重新连接

## 下载安装
1. 参考安装教程 [如何安装OpenHarmony ohpm包](https://gitee.com/openharmony-tpc/docs/blob/master/OpenHarmony_har_usage.md)

2. 安装命令如下：

```
 ohpm install @ohos/xmpp_reconnect
```

## 接口和属性列表

接口列表

| **接口**            | 参数 | 功能                                                         |
| ------------------- | ---- | ------------------------------------------------------------ |
| scheduleReconnect() | 无   | 义了一个重新连接的调度方法，它会清除之前的超时计时器，然后设置一个新的超时计时器，当超时后会尝试重新连接 |
| reconnect()         | 无   | 定义了重新连接的方法，它会触发 "reconnecting" 事件，然后调用 `entity` 的 `connect` 和 `open` 方法来重新连接 |
| start()             | 无   | 初始化重新连接模块，设置了一个监听器来监听 `entity` 的断开连接事件，并调用 `scheduleReconnect` 方法开始重新连接的调度 |
| stop()              | 无   | 停止重新连接模块，移除了断开连接的监听器并清除超时计时器     |

## 使用示例
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

## 使用说明

#### 重新连接的调度方法

```
scheduleReconnect()//此方法为重新连接内部监听调用
```

#### 重新连接

```
reconnect() //此方法是在监听到断连，后调用
```

#### 初始化重新连接模块

```
start():  初始化重新连接模块，设置了一个监听器来监听 entity 的断开连接事件，并调用 scheduleReconnect 方法开始重新连接的调度。
```

#### 停止重新连接模块

```
stop(): 停止重新连接模块，移除了断开连接的监听器并清除超时计时器
```

## 约束与限制

在下述版本验证通过：

- DevEco Studio 版本： 5.0.3.200,OpenHarmony SDK:API12 (5.0.0.21-Canary2)。

## 目录结构
```
|---- xmpp_reconnect
|     |---- entry  # 示例代码文件夹
|     |---- library  # xmpp_reconnect库文件夹
|               |----src/main #
|                    |----lib # reconnect代码文件夹
|               |----index.d.ts # 对外接口描述文件
|               |---- index.js  # 主入口文件
|     |---- README.MD  # 安装使用方法
```

## 贡献代码

使用过程中发现任何问题都可以提[Issue](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/issues) 给我们，当然，我们也非常欢迎你给我们提[PR](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/pulls) 。

## 开源协议

本项目基于ISC，请自由地享受和参与开源。