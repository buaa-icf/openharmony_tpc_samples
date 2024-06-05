

# @ohos/xmpp_starttls

## 简介

>本软件是参照开源软件 [@xmpp/starttls](https://github.com/xmppjs/xmpp.js/tree/main/packages/starttls)源码并用 TypeScript 语言实现了相关功能，在OpenHarmony上提供了一个用于与xmpp（Extensible Messaging and Presence Protocol）服务器建立加密TLS连接的library

## 已支持功能

- TLS (Transport Layer Security) 握手：在 XMPP 连接中启用 TLS 加密，以确保安全的通信。
- 自动 STARTTLS：自动检测服务器是否支持 StartTLS，以进行有条件地安全连接。
- 错误处理：捕捉和处理 StartTLS 过程中可能发生的错误和异常。

## 下载安装

1. 参考安装教程 [如何安装OpenHarmony ohpm包](https://gitee.com/openharmony-tpc/docs/blob/master/OpenHarmony_har_usage.md)

2. 安装命令如下：

```
 ohpm install @ohos/xmpp_starttls
```
## 接口和属性列表
接口列表

| **接口**                     | 参数                                                         | 功能                                               |
| ---------------------------- | ------------------------------------------------------------ | -------------------------------------------------- |
| negotiate(entity)            | `entity` 是一个对象，包含了与 XMPP 服务器通信所需的各种信息和方法，如发送和接收 XML 节点的能力。 | 用于与 XMPP 服务器协商是否可以进行 StartTLS 握手   |
| starttls({ streamFeatures }) | `{ streamFeatures }` 是一个对象，包含了当前 XMPP 连接的流特征，如认证方法、加密选项等。 | 用于处理 XMPP 流特征中的 StartTLS 特征             |
| canUpgrade(socket)           | `socket` 是当前的网络套接字对象。                            | 检查当前的网络套接字 (`socket`) 是否支持升级到 TLS |
| upgrade(service)             | `service` 是一个服务对象，可能包含了用于升级到 TLS 所需的信息和方法 | 将网络套接字升级到 TLS 连接                        |
## 使用示例
```
import { xml, jid, Client as ClientCore } from "@ohos/xmpp_client_core";
import { getDomain } from "./src/main/client/lib/getDomain";
import _reconnect from "@ohos/xmpp_reconnect";
import _websocket from "@ohos/xmpp_websocket";
import _tcp from "@ohos/xmpp_tcp";
import _tls from "@ohos/xmpp_tls";
import _middleware from "@ohos/xmpp_middleware";
import _streamFeatures from "@ohos/xmpp_stream_features";
import _iqCaller from "@ohos/xmpp_iq/src/main/lib/caller";
import _iqCallee from "@ohos/xmpp_iq/src/main/lib/callee";
import _resolve from "@ohos/xmpp_resolve";
// Stream features - order matters and define priority
import _starttls from "@ohos/xmpp_starttls";
import _sasl from "@ohos/xmpp_sasl";
import _resourceBinding from "@ohos/xmpp_resource_binding";
import _sessionEstablishment from "@ohos/xmpp_session_establishment";
import _streamManagement from "@ohos/xmpp_stream_management";
// SASL mechanisms - order matters and define priority
import plain from "@ohos/xmpp_sasl_plain";
import scramsha1 from "@ohos/xmpp_sasl_scram_sha_1";
import anonymous from "@ohos/xmpp_sasl_anonymous";
function client(options = {}) {
    const { resource, credentials, username, password, ...params } = options;
    const { domain, service, caPath } = params;
    if (!domain && service) {
        params.domain = getDomain(service);
    }
    const entity = new ClientCore(params);
    const reconnect = _reconnect({ entity });
    const websocket = _websocket({ entity });
    const tcp = _tcp({ entity });
    const tls = _tls({ entity });
    const middleware = _middleware({ entity });
    const streamFeatures = _streamFeatures({ middleware });
    const iqCaller = _iqCaller({ middleware, entity });
    const iqCallee = _iqCallee({ middleware, entity });
    const resolve = _resolve({ entity });
    // Stream features - order matters and define priority
    const starttls = _starttls({ streamFeatures });
    const sasl = _sasl({ streamFeatures }, credentials || { username, password });
    const streamManagement = _streamManagement({
        streamFeatures,
        entity,
        middleware,
    });
    const resourceBinding = _resourceBinding(
        { iqCaller, streamFeatures },
        resource,
    );
    const sessionEstablishment = _sessionEstablishment({
        iqCaller,
        streamFeatures,
    });
    // SASL mechanisms - order matters and define priority
    const mechanisms = Object.entries({
        scramsha1,
        plain,
        anonymous,
    }).map(([k, v]) => ({ [k]: v(sasl) }));
    return Object.assign(entity, {
        entity,
        reconnect,
        tcp,
        websocket,
        tls,
        middleware,
        streamFeatures,
        iqCaller,
        iqCallee,
        resolve,
        starttls,
        sasl,
        resourceBinding,
        sessionEstablishment,
        streamManagement,
        mechanisms,
    });
}
export { xml, jid, client };
//starttls主要用于将tcp连接升级成为TLS加密连接
```
## 使用说明
#### 在XMPP连接的流（stream）上注册一个中间件（middleware）处理函数
```
//判断现有Socket连接如果是TCP并且不是TLS就可以进行升级
function canUpgrade(socket) {
    return socket instanceof TcpSocket && !(socket instanceof TlsSocket)
}
//创建一个新的TLS，用于TCP升级
async function upgrade(service) {
  const tlsSocket = new TlsSocket();
        tlsSocket.connect(service);
  await promise(tlsSocket, "connect");
  return tlsSocket ;
}
async function negotiate(entity) {
  const element = await entity.sendReceive(xml("starttls", { xmlns: NS }));
  if (element.is("proceed", NS)) {
    return element;
  }
  throw new Error("STARTTLS_FAILURE");
}
export default function starttls({ streamFeatures }) {
  return streamFeatures.use("starttls", NS, async ({ entity }, next) => {
    const { socket, options } = entity;
    if (!canUpgrade(socket)) {
      return next();
    }
    await negotiate(entity);
    const tlsSocket = await upgrade(entity.service);
    entity._attachSocket(tlsSocket);
	//升级完成重启服务
    await entity.restart();
  });
};
```
## 约束与限制
在下述版本验证通过：
- DevEco Studio 版本： 5.0.3.200,OpenHarmony SDK:API12 (5.0.0.21-Canary2)。
## 目录结构
````
|---- @ohos/xmpp_starttls
|     |---- entry  # 示例代码文件夹
|           |---- src  
|                   |---- main  #sample示例代码
|                   |---- ohosTest  #xts示例代码
|     |---- library  # @ohos/xmpp_starttls 库文件夹
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