

# @ohos/xmpp_connection_tcp

## 简介

>本软件是参照开源软件 [@xmpp/connection-tcp](https://github.com/xmppjs/xmpp.js/tree/main/packages/connection-tcp)源码并用 TypeScript 语言实现了相关功能，在OpenHarmony上提供了一个用于建立和管理XMPP连接的library

## 已支持功能

- 自动重连：处理连接失败并尝试重新连接到 XMPP 服务器。
- 发送多个元素：可以一次性发送多个 XML 元素到服务器。
- 解析 URI：解析服务的 URI，提取出端口、主机名和协议信息。

## 下载安装
1. 参考安装教程 [如何安装OpenHarmony ohpm包](https://gitcode.com/openharmony-tpc/docs/blob/master/OpenHarmony_har_usage.md)

2. 安装命令如下：
```
 ohpm install @ohos/xmpp_connection_tcp
```

## 接口和属性列表

接口列表

| **接口**           | 参数            | 功能                           |
| ------------------ | --------------- | ------------------------------ |
| sendMany() | elements:xml实例 | 发送多个 XML 元素到服务器 |
| socketParameters() | service：服务器地址 | 根据服务的 URI 返回连接参数 |
| headerElement() | 无              | 生成头部元素，用于建立 XMPP 流 |

## 使用示例
```
import { Socket } from "@ohos/xmpp_connection_tcp/src/main/lib/net"
import ConnectionTCP from "@ohos/xmpp_connection_tcp"
import { Parser } from "@ohos/xmpp_xml"
import { parseURI } from "@ohos/xmpp_connection/src/main/lib/util"

const connection = new ConnectionTCP();

const service = "xmpp://example.com:5222";
const socketParams = connection.socketParameters(service);
const socket = new Socket(socketParams);

// Connect to the XMPP server
socket.connect(() => {
    // Send XMPP stanzas
    const elements = [/* Array of XML elements */];
    connection.sendMany(elements);
});

```

## 使用说明

#### 发送多个XML元素

```
sendMany(elements)// 发送多个 XML 元素到服务器
```

#### 根据服务器地址返回连接参数

```
socketParameters(service)//根据服务的 URI 返回连接参数
```
## 关于混淆
- 代码混淆，请查看[代码混淆简介](https://docs.openharmony.cn/pages/v5.0/zh-cn/application-dev/arkts-utils/source-obfuscation.md)
- 如果希望三方库在代码混淆过程中不会被混淆，需要在混淆规则配置文件obfuscation-rules.txt中添加相应的排除规则：
```
-keep
./oh_modules/@ohos/xmpp_connection_tcp
```
## 约束与限制
在下述版本验证通过：
- DevEco Studio 版本： 5.0.3.200,OpenHarmony SDK:API12 (5.0.0.21-Canary2)。

## 目录结构
```
|---- @ohos/xmpp_connection_tcp
|     |---- entry  # 示例代码文件夹
|     |---- library  # xmpp_connection_tcp库文件夹
|               |----src/main #
|                    |----lib # xmpp_connection_tcp代码文件夹
|               |----index.d.ts # 对外接口描述文件
|               |---- index.js  # 主入口文件
|     |---- README.MD  # 安装使用方法
|     |---- README_zh.MD  # 安装使用方法
```

## 贡献代码

使用过程中发现任何问题都可以提[Issue](https://gitcode.com/openharmony-tpc/openharmony_tpc_samples/issues) 给我们，当然，我们也非常欢迎你给我们提[PR](https://gitcode.com/openharmony-tpc/openharmony_tpc_samples/pulls) 。

## 开源协议

本项目基于ISC，请自由地享受和参与开源。