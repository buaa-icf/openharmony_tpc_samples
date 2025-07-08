

# @ohos/xmpp_sasl_scram_sha_1

## 简介

>本软件是参照开源软件 [@xmpp/sasl-scram-sha-1](https://github.com/xmppjs/xmpp.js/tree/main/packages/sasl-scram-sha-1)源码并用 TypeScript 语言实现了相关功能，在OpenHarmony上提供了一个用于 XMPP 协议的 SASL（安全认证层）机制，它基于 SCRAM 协议使用 SHA-1 哈希函数进行用户认证的library

## 已支持功能
- **安全认证**：提供了基于 SCRAM（Salted Challenge Response Authentication Mechanism）的安全认证机制，确保用户在 XMPP 通信中的身份验证安全。
- **哈希加密**：该模块使用 SHA-1 哈希算法对用户密码进行加密处理，增强了密码传输过程中的安全性，防止密码在传输过程中被截获和破解。
## 下载安装
1. 参考安装教程 [如何安装OpenHarmony ohpm包](https://gitcode.com/openharmony-tpc/docs/blob/master/OpenHarmony_har_usage.md)
2. 安装命令如下：
```
 ohpm install @ohos/xmpp_sasl_scram_sha_1
```
## 接口和属性列表
接口列表

| **接口**                                | 参数                | 功能                       |
| --------------------------------------- | ------------------- | -------------------------- |
|  saslScramSha1（sasl）        | `sasl`: XMPP SASL 上下文对象，用于处理认证流程。 | 将 SCRAM-SHA-1 认证机制添加到 XMPP SASL 上下文对象中，使其能够使用这种认证方法来进行用户身份验证。           |

## 使用示例
```
"use strict";
import { xml, jid, Client as ClientCore } from "@ohos/xmpp_client_core";
import { getDomain } from "./src/main/client/lib/getDomain";
import _reconnect from "@ohos/xmpp_reconnect";
import _websocket from "@ohos/xmpp_websocket";
import _tcp from "@ohos/xmpp_tcp";
import _tls from "@ohos/xmpp_tls";
import _middleware from "@ohos/xmpp_middleware";
import _streamFeatures from "@ohos/xmpp_stream-features";
import _iqCaller from "@ohos/xmpp_iq/src/main/iq/caller";
import _iqCallee from "@ohos/xmpp_iq/src/main/iq/callee";
import _resolve from "@ohos/xmpp_resolve";
// Stream features - order matters and define priority
import _starttls from "@ohos/xmpp_starttls";
import _sasl from "@ohos/xmpp_sasl";
import _resourceBinding from "@ohos/xmpp_resource_binding";
import _sessionEstablishment from "@ohos/xmpp_session_establishment";
import _streamManagement from "@ohos/xmpp_stream_management";
// SASL mechanisms - order matters and define priority
import plain from "@ohos/xmpp_sasl_plain";
import saslScramSha1 from "@ohos/xmpp_sasl_scram_sha_1";
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
        saslScramSha1,
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
```
## 使用说明
#### 用户登录验证使用scramSha1的认证方式
```
   const mechanisms = Object.entries({
        saslScramSha1,
        plain,
        anonymous,
    }).map(([k, v]) => ({ [k]: v(sasl) }));
    传入三种加密方式 saslScramSha1、plain、anonymous
```

## 关于混淆
- 代码混淆，请查看[代码混淆简介](https://docs.openharmony.cn/pages/v5.0/zh-cn/application-dev/arkts-utils/source-obfuscation.md)
- 如果希望xmpp_sasl_scram_sha_1库在代码混淆过程中不会被混淆，需要在混淆规则配置文件obfuscation-rules.txt中添加相应的排除规则：
```
-keep
./oh_modules/@ohos/xmpp_sasl_scram_sha_1
```

## 约束与限制
在下述版本验证通过：
- DevEco Studio 版本： 5.0.3.200,OpenHarmony SDK:API12 (5.0.0.21-Canary2)。
## 目录结构
````
|---- @ohos/xmpp_sasl_scram_sha_1
|     |---- entry  # 示例代码文件夹
|           |---- src  
|                   |---- main  #sample示例代码
|                   |---- ohosTest  #xts示例代码
|     |---- library  # @ohos/xmpp_sasl_scram_sha_1 库文件夹
|           |---- ets
|                 |---- lib  # 主要依赖
|                 |---- types  # 对外接口文件夹
|           |---- index.js  # 主入口文件
|           |---- index.d.ts  # 主对外接口声明文件
|     |---- README.md  # 安装使用方法
|     |---- README_zh.md  # 安装使用方法                    
````
## 贡献代码
使用过程中发现任何问题都可以提[Issue](https://gitcode.com/openharmony-tpc/openharmony_tpc_samples/issues) ，当然，也非常欢迎提[PR](https://gitcode.com/openharmony-tpc/openharmony_tpc_samples/pulls) 。
## 开源协议
本项目基于[ISC license](https://gitcode.com/openharmony-tpc/openharmony_tpc_samples/blob/master/xmpp_sasl_scram_sha_1/LICENSE)，请自由地享受和参与开源。