
# @ohos/xmpp_component_core

## 简介

>本软件是参照开源软件 [@xmpp/component-core](https://github.com/xmppjs/xmpp.js/tree/main/packages/component-core)源码并用 TypeScript 语言实现了相关功能，在OpenHarmony上提供了一个用于创建XMPP(Extensible Messaging and Presence Protocol)组件并连接到 XMPP 服务器的library

## 已支持功能

- 构建的组件或服务器与其他 XMPP 实体兼容
- 提供了一些基本的 XMPP 功能，例如身份验证、连接管理和元素发送/接收

## 下载安装

1. 参考安装教程 [如何安装OpenHarmony ohpm包](https://gitcode.com/openharmony-tpc/docs/blob/master/OpenHarmony_har_usage.md)

2. 安装命令如下：

```
 ohpm install @ohos/xmpp_component_core
```

## 接口和属性列表

接口列表

| **接口**                  | 参数                                                      | 功能                                                         |
| ------------------------- | --------------------------------------------------------- | ------------------------------------------------------------ |
| authenticate(id,password) | `id`是组件或服务器的 JID，`password` 是组件或服务器的密码 | 执行身份验证，通过计算 SHA1 哈希值来验证输入的 id 和 password。 |

## 使用示例
```
import Component  from "@ohos/xmpp_component_core";
const component = new Component({
  jid: 'mycomponent@domain.tld',
  password: 'mypassword'
});

// 监听连接成功事件
component.on('connect', () => {
  console.log('已连接到 XMPP 服务器');
});

// 监听接收到消息事件
component.on('message', (msg) => {
  console.log('收到消息:', msg);
});

// 连接到 XMPP 服务器
component.connect().catch((err) => {
  console.error('连接失败:', err);
});
```

## 使用说明

```
@@ohos/xmpp_component_core用于构建 XMPP 组件或服务器。它是 @xmpp 项目的一部分,
import Component  from "@ohos/xmpp_component_core";
const component = new Component({
  jid: 'mycomponent@domain.tld',
  password: 'mypassword'
});

// 监听连接成功事件
component.on('connect', () => {
  console.log('已连接到 XMPP 服务器');
});

// 监听接收到消息事件
component.on('message', (msg) => {
  console.log('收到消息:', msg);
});

// 连接到 XMPP 服务器
component.connect().catch((err) => {
  console.error('连接失败:', err);
});
引入 @xmpp/component-core 模块，然后创建一个新的 Component 实例，并传入 JID 和密码作为参数。接着我们监听了连接成功事件和接收到消息事件，并在控制台打印相关信息。最后调用 connect() 方法连接到 XMPP 服务器
```

## 关于混淆
- 代码混淆，请查看[代码混淆简介](https://docs.openharmony.cn/pages/v5.0/zh-cn/application-dev/arkts-utils/source-obfuscation.md)
- 如果希望xmpp_component_core库在代码混淆过程中不会被混淆，需要在混淆规则配置文件obfuscation-rules.txt中添加相应的排除规则：
```
-keep
./oh_modules/@ohos/xmpp_component_core
```

## 约束与限制

在下述版本验证通过：

- DevEco Studio 版本： 5.0.3.200,OpenHarmony SDK:API12 (5.0.0.21-Canary2)。

## 目录结构
````
|---- @ohos/xmpp_component_core 
|     |---- entry  # 示例代码文件夹
|           |---- src  
|                   |---- main  #sample示例代码
|                   |---- ohosTest  #xts示例代码
|     |---- library  # @ohos/xmpp_component_core 库文件夹
|           |---- ets
|                 |---- lib  # 主要依赖
|                 |---- types  # 对外接口文件夹
|           |---- index.js  # 主入口文件
|           |---- index.d.ts  # 主对外接口声明文件
|     |---- README_zh.md  # 安装使用方法                    
````

## 贡献代码

使用过程中发现任何问题都可以提[Issue](https://gitcode.com/openharmony-tpc/openharmony_tpc_samples/issues)，当然，也非常欢迎提[PR](https://gitcode.com/openharmony-tpc/openharmony_tpc_samples/pulls) 。

## 开源协议

本项目基于ISC，请自由地享受和参与开源。