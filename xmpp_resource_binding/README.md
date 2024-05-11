

# @ohos/xmpp_resource_binding

## 简介

>本软件是参照开源软件 [xmpp_resource_binding](https://github.com/xmppjs/xmpp.js/tree/main/packages/resource-binding)源码并用 TypeScript 语言实现了相关功能，在OpenHarmony上提供了一个用于客户端资源绑定的library

## 已支持功能

- 多设备登录:将消息从发送方路由到接收方，确保消息能够准确传递。
- 状态同步:确保用户在不同设备上的状态信息（如在线/离线状态）保持同步。
- 消息路由:将消息从发送方路由到接收方，确保消息能够准确传递。
- 会话管理:管理用户与其他用户之间的会话，包括创建、终止和跟踪会话状态。

## 下载安装

1. 参考安装教程 [如何安装OpenHarmony ohpm包](https://gitee.com/openharmony-tpc/docs/blob/master/OpenHarmony_har_usage.md)

2. 安装命令如下：

```
 ohpm install @ohos/xmpp_resource_binding
```

## 接口和属性列表

接口列表

| **接口**                                                | 参数                                                         | 功能                                                         |
| ------------------------------------------------------- | ------------------------------------------------------------ | ------------------------------------------------------------ |
| resourceBinding({ streamFeatures, iqCaller }, resource) | streamFeatures:XMPP 服务器的流特征信息,iqCaller:发送 IQ 消息的工具 | 将资源绑定功能注册到 `streamFeatures` 中的 "bind" 特征上，当客户端连接时，它会自动处理资源绑定过程。 |

## 使用示例
```
import _tcp from "@ohos/xmpp_tcp";
import _middleware from "@ohos/xmpp_middleware";
import _streamFeatures from "@ohos/xmpp_stream_features";
import _iqCaller from "@ohos/xmpp_iq/src/main/iq/caller";
import _iqCallee from "@ohos/xmpp_iq/src/main/iq/callee";
import _sasl from "@@ohos/xmpp_sasl";
import _resourceBinding from "@ohos/xmpp_resource-binding";
import { xml, jid, Client as ClientCore } from "@ohos/xmpp_client_core";
function client(options = {}) {
	//使用对象解构赋值从 options 对象中提取出 resource（资源标识符）、credentials（认证信息）、        username（用户名）、password（密码），并将剩余的属性放入 params 对象中。
    const { resource, credentials, username, password, ...params } = options;
    //再次使用对象解构赋值从 params 对象中提取出 domain（域名）、service（服务名）和 caPath
    const { domain, service, caPath } = params;
    if (!domain && service) {
        params.domain = getDomain(service);
    }
    //创建了一个 ClientCore 实例，传入 params 对象作为配置参数。这个实例将作为 XMPP 客户端的主体。
    const entity = new ClientCore(params);
    //调用 _tcp 函数，传入 entity 实例。_tcp 函数将返回一个新的对象 tcp，这个对象包含了 TCP 连接的配置和功能。通过这一步，entity 实例现在具备了通过 TCP 连接进行 XMPP 通信的能力。
    const tcp = _tcp({ entity });
    const middleware = _middleware({ entity });
    const streamFeatures = _streamFeatures({ middleware });
    const iqCaller = _iqCaller({ middleware, entity });
    const iqCallee = _iqCallee({ middleware, entity });
    const resolve = _resolve({ entity });
    const resourceBinding = _resourceBinding(
        { iqCaller, streamFeatures },
        resource,
    );
    //调用resourceBinding 将当前客户端绑定到服务器上
}
```

## 使用说明

####  处理资源绑定

```
resourceBinding({ streamFeatures, iqCaller }, resource)：这是模块的主导出函数。它接收两个参数，streamFeatures 是一个对象，可能包含了 XMPP 服务器的流特征信息，iqCaller 是用于发送 IQ 消息的工具。这个函数将资源绑定功能注册到 streamFeatures 中的 "bind" 特征上，当客户端连接时，它会自动处理资源绑定过程。
```

## 约束与限制

在下述版本验证通过：

- DevEco Studio 版本： 5.0.3.200,OpenHarmony SDK:API12 (5.0.0.21-Canary2)。

## 目录结构
````
|---- @ohos/xmpp_resource_binding 
|     |---- entry  # 示例代码文件夹
|           |---- src  
|                   |---- main  #sample示例代码
|                   |---- ohosTest  #xts示例代码
|     |---- library  # @ohos/xmpp_resource_binding 库文件夹
|           |---- ets
|                 |---- lib  # 主要依赖
|                 |---- types  # 对外接口文件夹
|           |---- index.js  # 主入口文件
|           |---- index.d.ts  # 主对外接口声明文件
|     |---- README.md  # 安装使用方法                    
````

## 贡献代码

使用过程中发现任何问题都可以提[Issue](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/issues) 给我们，当然，我们也非常欢迎你给我们提[PR](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/pulls) 。

## 开源协议

本项目基于ISC，请自由地享受和参与开源。