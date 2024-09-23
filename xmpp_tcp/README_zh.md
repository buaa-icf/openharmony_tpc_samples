

# @ohos/xmpp_tcp

## 简介

>本软件是参照开源软件 [@xmpp/tcp](https://github.com/xmppjs/xmpp.js/tree/main/packages/tcp)源码并用 TypeScript 语言实现了相关功能，在OpenHarmony上提供了一个用于建立和管理TCP连接的library

## 已支持功能

- 连接管理：包括连接建立、断开、重连等基本的TCP连接操作。
- 通过 TCP 连接与其他设备或系统进行通讯

## 下载安装

1. 参考安装教程 [如何安装OpenHarmony ohpm包](https://gitee.com/openharmony-tpc/docs/blob/master/OpenHarmony_har_usage.md)

2. 安装命令如下：

```
 ohpm install @ohos/xmpp_tcp
```

## 接口和属性列表

接口列表

| **接口**    | 参数                   | 功能                    |
| ----------- | ---------------------- | ----------------------- |
| tcp(entity) | entity：clientCore实例 | 配置系统以支持 TCP 连接 |

## 使用示例
```
import _tcp from "@ohos/xmpp_tcp";
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
}
```

## 使用说明

####  为entity添加 TCP 连接能力

```
function tcp({ entity }) {
  entity.transports.push(ConnectionTCP);
};
//这个函数的目的是在 entity 对象上添加一个名为 transports 的数组，并将 ConnectionTCP 对象添加到该数组中。这样做的目的是在 entity 对象上配置一个新的连接方式，即使用 TCP 连接
```

## 约束与限制

在下述版本验证通过：

- DevEco Studio 版本： 5.0.3.200,OpenHarmony SDK:API12 (5.0.0.21-Canary2)。

## 目录结构
````
|---- @ohos/xmpp_tcp 
|     |---- entry  # 示例代码文件夹
|           |---- src  
|                   |---- main  #sample示例代码
|                   |---- ohosTest  #xts示例代码
|     |---- library  # @ohos/xmpp_tcp 库文件夹
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