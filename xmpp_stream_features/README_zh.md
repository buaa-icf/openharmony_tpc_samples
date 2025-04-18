

# @ohos/xmpp_stream_features

## 简介

>本软件是参照开源软件 [xmpp_connection](https://github.com/xmppjs/xmpp.js/tree/main/packages/stream-feraturs)源码并用 TypeScript 语言实现了相关功能，在OpenHarmony上提供了一个用于建立和管理XMPP流连接的library

## 已支持功能

- 处理流特性
- 使用中间件
- 调用特性处理器
- 错误处理

## 下载安装

1. 参考安装教程 [如何安装OpenHarmony ohpm包](https://gitcode.com/openharmony-tpc/docs/blob/master/OpenHarmony_har_usage.md)

2. 安装命令如下：

```
 ohpm install @ohos/xmpp_stream_features
```

## 接口和属性列表

接口列表

| **接口**                              | 参数                                                         | 功能             |
| ------------------------------------- | ------------------------------------------------------------ | ---------------- |
| use(featureName, namespace, callback) | `featureName`（特性名称），`namespace`（特性命名空间），和 `callback`（处理特定特性事件的函数） | 处理特定特性事件 |

## 使用示例
```
//使用streamFeatures.use()注册的中间件，用于处理XMPP流管理（Stream Management）
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

## 使用说明

#### 在XMPP连接的流（stream）上注册一个中间件（middleware）处理函数

```
streamFeatures.use(featureName, namespace, callback);
//featureName：通常是字符串，表示要使用的功能或协议的名称，例如"sm"（Stream Management）。
//namespace：通常是一个字符串，表示该功能使用的XML命名空间，例如"http://jabber.org/protocol/stream-management"。
//callback：一个异步函数，它接收两个参数：context（上下文对象，包含有关连接和会话的信息）和next（一个函数，用于继续执行下一个中间件，或者在完成特定操作后继续执行流的建立过程）。
在callback函数中，你可以编写处理特定功能的逻辑，比如处理连接的建立、数据传输、错误处理等。如果中间件需要异步操作，可以在回调函数中使用await关键字等待操作完成

const streamFeatures = connection.features.streamFeatures; // 获取连接的streamFeatures对象

streamFeatures.use("sm", NS, async (context, next) => {
  // 在这里添加你的SM中间件逻辑
  // ...
  await next(); // 调用next()以继续流的建立过程
});

```
## 关于混淆
- 代码混淆，请查看[代码混淆简介](https://docs.openharmony.cn/pages/v5.0/zh-cn/application-dev/arkts-utils/source-obfuscation.md)
- 如果希望三方库在代码混淆过程中不会被混淆，需要在混淆规则配置文件obfuscation-rules.txt中添加相应的排除规则：
```
-keep
./oh_modules/@ohos/xmpp_stream_features
```
## 约束与限制

在下述版本验证通过：

- DevEco Studio 版本： 5.0.3.200,OpenHarmony SDK:API12 (5.0.0.21-Canary2)。

## 目录结构
````
|---- @ohos/xmpp_stream_features 
|     |---- entry  # 示例代码文件夹
|           |---- src  
|                   |---- main  #sample示例代码
|                   |---- ohosTest  #xts示例代码
|     |---- library  # @ohos/xmpp_stream_features 库文件夹
|           |---- ets
|                 |---- lib  # 主要依赖
|                 |---- types  # 对外接口文件夹
|           |---- index.js  # 主入口文件
|           |---- index.d.ts  # 主对外接口声明文件
|     |---- README.md  # 安装使用方法                    
|     |---- README_zh.md  # 安装使用方法                    
````

## 贡献代码

使用过程中发现任何问题都可以提[Issue](https://gitcode.com/openharmony-tpc/openharmony_tpc_samples/issues) 给我们，当然，我们也非常欢迎你给我们提[PR](https://gitcode.com/openharmony-tpc/openharmony_tpc_samples/pulls) 。

## 开源协议

本项目基于ISC，请自由地享受和参与开源。