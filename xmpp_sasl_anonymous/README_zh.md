

# @ohos/xmpp_sasl_anonymous

## 简介

>本软件是参照开源软件 [@xmpp/sasl-anonymous](https://github.com/xmppjs/xmpp.js/tree/main/packages/sasl-anonymous)源码并用 TypeScript 语言实现了相关功能，在OpenHarmony上提供了一个用于客户端匿名连接到XMPP服务器的library

## 已支持功能

- SASL ANONYMOUS 机制：它提供了 RFC 7525 中定义的 ANONYMOUS SASL机制的实现，这是XMPP协议的一个扩展。
- XMPP 客户端集成：它可以集成到 XMPP 客户端库或应用程序中，以添加对匿名认证的支持。
- 客户端与服务器认证：XMPP 客户端能够使用 ANONYMOUS 机制与 XMPP 服务器进行认证，该机制不需要客户端提供用户名或密码。

## 下载安装

1. 参考安装教程 [如何安装OpenHarmony ohpm包](https://gitcode.com/openharmony-tpc/docs/blob/master/OpenHarmony_har_usage.md)

2. 安装命令如下：

```
 ohpm install @ohos/xmpp_sasl_anonymous
```

## 接口和属性列表

接口列表

| **接口**             | 参数             | 功能                           |
| -------------------- | ---------------- | ------------------------------ |
| saslAnonymous(sasl); | `sasl`：SASL实例 | 使用匿名认证来连接到XMPP服务器 |

## 使用示例
```
import _tcp from "@ohos/xmpp_tcp";
import { xml, jid, Client as ClientCore } from "@ohos/xmpp_client_core";
import anonymous from "ohos/xmpp_sasl-anonymous";
import _sasl from "ohos/xmpp_sasl";
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
    const sasl = _sasl({ streamFeatures }, credentials || { username, password });
    const mechanisms = Object.entries({
        plain,//以plain加密的方式验证
        anonymous,//以匿名的方式验证
    }).map(([k, v]) => ({ [k]: v(sasl) }));
}
```

## 使用说明

####  提供客户端匿名连接到xmpp服务器的功能

```
这个模块的主要功能是允许客户端在连接到XMPP服务器时进行匿名认证，即不需要提供任何用户名或密码
```

## 关于混淆
- 代码混淆，请查看[代码混淆简介](https://docs.openharmony.cn/pages/v5.0/zh-cn/application-dev/arkts-utils/source-obfuscation.md)
- 如果希望xmpp_sasl_anonymous库在代码混淆过程中不会被混淆，需要在混淆规则配置文件obfuscation-rules.txt中添加相应的排除规则：
```
-keep
./oh_modules/@ohos/xmpp_sasl_anonymous
```

## 约束与限制

在下述版本验证通过：

- DevEco Studio 版本： 5.0.3.200,OpenHarmony SDK:API12 (5.0.0.21-Canary2)。

## 目录结构
````
|---- @ohos/xmpp_sasl_anonymous 
|     |---- entry  # 示例代码文件夹
|           |---- src  
|                   |---- main  #sample示例代码
|                   |---- ohosTest  #xts示例代码
|     |---- library  # @ohos/xmpp_sasl_anonymous 库文件夹
|           |---- ets
|                 |---- lib  # 主要依赖
|                 |---- types  # 对外接口文件夹
|           |---- index.js  # 主入口文件
|           |---- index.d.ts  # 主对外接口声明文件
|     |---- README_zh.md  # 安装使用方法                    
````

## 贡献代码

使用过程中发现任何问题都可以提[Issue](https://gitcode.com/openharmony-tpc/openharmony_tpc_samples/issues) 给我们，当然，我们也非常欢迎你给我们提[PR](https://gitcode.com/openharmony-tpc/openharmony_tpc_samples/pulls) 。

## 开源协议

本项目基于ISC，请自由地享受和参与开源。