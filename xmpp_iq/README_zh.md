

# @ohos/xmpp_iq

## 简介

>本软件是参照开源软件 [@xmpp/iq](https://github.com/xmppjs/xmpp.js/tree/main/packages/iq)源码并用 TypeScript 语言实现了相关功能，在OpenHarmony上提供了处理XMPP协议中IQ（Info/Query）的模块library

## 已支持功能

- 处IQ请求处理:解析和处理XMPP（eXtensible Messaging and Presence Protocol）协议中的IQ（Information Query）请求，执行相应的操作。
- 请求验证:对发送的IQ请求进行身份验证和内容有效性检查，确保数据安全。
- 响应构建:根据IQ请求的类型和处理结果，构造符合XMPP规范的响应消息。
- 错误处理：捕获和处理在处理IQ请求过程中出现的错误，提供友好的错误反馈。
- 路由功能：根据IQ请求的目标地址，决定消息通过哪个服务器或组件进行转发。
- 中间件集成：与系统的其他模块或服务集成，以便在处理IQ请求时调用或传递数据到相关服务。

## 下载安装

1. 参考安装教程 [如何安装OpenHarmony ohpm包](https://gitee.com/openharmony-tpc/docs/blob/master/OpenHarmony_har_usage.md)

2. 安装命令如下：

```
 ohpm install @ohos/xmpp_iq
```

## 接口和属性列表

接口列表

| **接口**               | 参数                                                         | 功能                                                         |
| ---------------------- | ------------------------------------------------------------ | ------------------------------------------------------------ |
| iqCallee(options)      | `options`: 一个对象，包含中间件和XMPP实体                    | 一个工厂函数，用于创建一个IQ处理模块                         |
| get(ns, name, handler) | `ns` (命名空间): 表示XMPP节（stanza）的命名空间。`name` (名称): 表示IQ节中的查询或设置的名称。`handler` (处理器): 用于处理特定命名空间和名称的IQ请求。 | 这个方法用于注册一个处理特定命名空间（`ns`）和名称（`name`）的GET类型的IQ请求的处理器。当你调用这个方法并传入处理器函数 `handler` 时，它会将这个处理器添加到中间件链中，使得当接收到GET IQ请求且命名空间和名称匹配时，调用指定的处理器。 |
| set(ns, name, handler) | `ns` (命名空间): 表示XMPP节（stanza）的命名空间。`name` (名称): 表示IQ节中的查询或设置的名称。`handler` (处理器): 用于处理特定命名空间和名称的IQ请求。 | 用于注册处理SET类型的IQ请求的处理器。通过这种方式，`iqCallee` 提供了一种模块化的方式来处理不同类型的IQ请求，可以根据需要注册不同的处理器 |



## 使用示例
````
import Connection = require("@xmpp/connection");
import iqCallee = require("@xmpp/iq/callee");
import iqCaller = require("@xmpp/iq/caller");
import middleware = require("@xmpp/middleware");
import { Element } from "@xmpp/xml";

// test type exports
type IQCallee<TEntity extends middleware.Entity> = iqCallee.IQCallee<TEntity>;
type IQCaller<TEntity extends middleware.Entity> = iqCaller.IQCaller<TEntity>;

class Foo extends Connection implements middleware.Entity {
domain?: string;
hookOutgoing?: (stanza: Element) => Promise<void>;

    headerElement() {
        return new Element("foo");
    }

    socketParameters(service: string) {
        return null;
    }
}

const ent = new Foo({ service: "foo", domain: "foo.bar" });
const mw = middleware({ entity: ent });

const callee = iqCallee({ middleware: mw, entity: ent }); // $ExpectType IQCallee<Foo>
callee.get("foo", "bar", (ctx, next) => {
ctx; // $ExpectType IncomingContext<Foo>
next; // $ExpectType Next
return next();
});
callee.set("foo", "bar", (ctx, next) => {
ctx; // $ExpectType IncomingContext<Foo>
next; // $ExpectType Next
return next();
});

const caller = iqCaller({ middleware: mw, entity: ent }); 
caller.entity; // $ExpectType Foo
caller.handlers; // $ExpectType Map<string, Deferred<Element>>
caller.middleware; // $ExpectType Middleware<Foo>
caller.get(new Element("foo")); 
caller.get(new Element("foo"), "bar"); 
caller.get(new Element("foo"), "bar", 10); 
caller.set(new Element("foo")); 
caller.set(new Element("foo"), "bar"); 
caller.set(new Element("foo"), "bar", 10); 
caller.request(new Element("foo")); 
caller.request(new Element("foo"), 10); 
caller.start(); 
````
## 使用说明

@ohos/xmpp_iq是@ohos/xmpp_client的一个组件，IQ 节是 XMPP 协议中用于请求和响应数据的基本通信单位。

## 约束与限制

在下述版本验证通过：

- DevEco Studio 版本： 5.0.3.200,OpenHarmony SDK:API12 (5.0.0.21-Canary2)。

## 目录结构
````
|---- @ohos/xmpp_iq
|     |---- entry  # 示例代码文件夹
|           |---- src  
|                   |---- main  #sample示例代码
|                   |---- ohosTest  #xts示例代码
|     |---- library  # @ohos/xmpp_iq 库文件夹
|           |---- ets
|                 |---- lib  # 主要依赖
|                 |---- types  # 对外接口文件夹
|           |---- index.js  # 主入口文件
|           |---- index.d.ts  # 主对外接口声明文件
|     |---- README.md  # 安装使用方法                    
|     |---- README_zh.md  # 安装使用方法                    
````

## 贡献代码

使用过程中发现任何问题都可以提[Issue](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/issues) 给我们，当然，我们也非常欢迎你给我们提[PR](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/pulls) 。

## 开源协议

本项目基于ISC，请自由地享受和参与开源。