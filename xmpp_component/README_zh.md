
# @ohos/xmpp_component

## 简介

>本软件是参照开源软件 [@xmpp/component](https://github.com/xmppjs/xmpp.js/tree/main/packages/component)源码并用 TypeScript 语言实现了相关功能，在OpenHarmony上提供了一个用于创建XMPP(Extensible Messaging and Presence Protocol)扩展消息和在线状态协议组件的library

## 已支持功能

- 组件连接： 该库允许与XMPP服务器和其它组件建立和管理连接，包括处理认证、流特性以及错误处理。
- 消息路由： 它提供了处理接收和发送消息的功能，包括处理消息stanza（XML消息）、元数据以及错误。
- 组件发现： 包含组件发现协议支持，用于组件之间展示自身能力和功能。

## 下载安装

1. 参考安装教程 [如何安装OpenHarmony ohpm包](https://gitcode.com/openharmony-tpc/docs/blob/master/OpenHarmony_har_usage.md)

2. 安装命令如下：

```
 ohpm install @ohos/xmpp_component
```

## 接口和属性列表

接口列表

| **接口**             | 参数       | 功能                                                         |
|--------------------|----------| ------------------------------------------------------------ |
| component(options) | options：该对象包含password、service和domain等属性。这些属性用于配置XMPP组件。 | 提供了XMPP通信所需的核心功能、重连机制、中间件处理、IQ（信息/查询）调用者和被调用者功能。 |

## 使用示例
```
import { Component, component, jid, Options, xml } from "@ohos/xmpp_component";
import { Component as ComponentCore } from "@ohos/xmpp_component_core";

// test type exports
type Opts = Options;
type Cl = Component;

const c = component({}); // $ExpectType Component
component({ password: "foo" }); // $ExpectType Component
// $ExpectType Component
component({
    password: async auth => {
        auth; // $ExpectType (password: string) => Promise<void>
        await auth("foo");
    },
});
component({ domain: "foo" }); // $ExpectType Component
component({ service: "foo.bar" }); // $ExpectType Component

const cc: ComponentCore = c;
c.entity; // $ExpectType Component
c.reconnect; // $ExpectType Reconnect<Component>
c.middleware; // $ExpectType Middleware<Component>
c.iqCaller; // $ExpectType IQCaller<Component>
c.iqCallee; // $ExpectType IQCallee<Component>

jid("foo");
jid(null, "foo", "bar");

xml("foo");
xml("foo", { foo: "bar" }, "bar");
```

## 使用说明

```
import { Component, component, jid, Options, xml } from "@ohos/xmpp_component";
import { Component as ComponentCore } from "@ohos/xmpp_component_core";
//导入@ohos/xmpp_component库中的Component、component、jid、Options和xml，以及@ohos/xmpp_component_core库中的Component（重命名为ComponentCore）

// 这里定义了两个类型别名Opts和Cl，分别代表Options和Component类型
type Opts = Options;
type Cl = Component;

//使用component()函数创建一个Component实例。第一个例子没有传递任何选项，第二个例子传递了一个包含password属性的选项对象
const c = component({}); 
component({ password: "foo" }); 
// $ExpectType Component
component({
//使用异步密码验证。传递给component()函数的选项对象包含一个password属性，该属性是一个异步函数，接受一个auth函数作为参数，并调用该函数验证密码
    password: async auth => {
        auth; // $ExpectType (password: string) => Promise<void>
        await auth("foo");
    },
});
component({ domain: "foo" }); 
component({ service: "foo.bar" }); 

const cc: ComponentCore = c;
c.entity; 
c.reconnect; 
c.middleware; 
c.iqCaller; 
c.iqCallee;

jid("foo");
jid(null, "foo", "bar");

xml("foo");
xml("foo", { foo: "bar" }, "bar");
```

## 关于混淆
- 代码混淆，请查看[代码混淆简介](https://docs.openharmony.cn/pages/v5.0/zh-cn/application-dev/arkts-utils/source-obfuscation.md)
- 如果希望xmpp_component库在代码混淆过程中不会被混淆，需要在混淆规则配置文件obfuscation-rules.txt中添加相应的排除规则：
```
-keep
./oh_modules/@ohos/xmpp_component
```

## 约束与限制

在下述版本验证通过：

- DevEco Studio 版本： 5.0.3.200,OpenHarmony SDK:API12 (5.0.0.21-Canary2)。

## 目录结构
````
|---- @ohos/xmpp_component
|     |---- entry  # 示例代码文件夹
|           |---- src  
|                   |---- main  # sample示例代码
|                   |---- ohosTest  # xts示例代码
|     |---- library  # @ohos/xmpp_component 库文件夹
|           |---- ets
|                 |---- lib  # 主要依赖
|                 |---- types  # 对外接口文件夹
|           |---- index.js  # 主入口文件
|           |---- index.d.ts  # 主对外接口声明文件
|     |---- README_zh.md  # 安装使用方法                    
````

## 贡献代码

使用过程中发现任何问题都可以提[Issue](https://gitcode.com/openharmony-tpc/openharmony_tpc_samples/issues) ，当然，也非常欢迎提[PR](https://gitcode.com/openharmony-tpc/openharmony_tpc_samples/pulls) 。

## 开源协议

本项目基于[ISC license](https://gitcode.com/openharmony-tpc/openharmony_tpc_samples/blob/master/xmpp_component/LICENSE)，请自由地享受和参与开源。