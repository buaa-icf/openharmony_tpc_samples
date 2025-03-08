

# @ohos/xmpp_websocket

## 简介

>本软件是参照开源软件 [xmpp_websocket](https://github.com/xmppjs/xmpp.js/tree/main/packages/websocket)源码并用 TypeScript 语言实现了相关功能，在OpenHarmony上提供了一个用于处理WebSocket在XMPP协议中的通信的library

## 已支持功能

- 连接到WebSocket服务器。
- 发送和接收消息。
- 处理连接错误。
- 处理连接关闭。

## 下载安装
1. 参考安装教程 [如何安装OpenHarmony ohpm包](https://gitcode.com/openharmony-tpc/docs/blob/master/OpenHarmony_har_usage.md)

2. 安装命令如下：

```
 ohpm install @ohos/xmpp_websocket
```

## 接口和属性列表

接口列表

| **接口**           | 参数            | 功能                           |
| ------------------ | --------------- | ------------------------------ |
| connect(url, caPath) | url：地址，capath：证书地址 | 连接到WebSocket服务器，参数包括服务器URL和CA证书路径 |
| end() | 无 | 关闭连接 |
| write(data, fn) | data:要发送的消息，fn（）：回调函数 | 发送消息到服务器，参数包括消息数据和回调函数 |

## 使用示例
```
import { Socket } from "@ohos/xmpp_webSocket";

const socket = new Socket();
const url = "wss://xxxx:xxxx";
const caPath = "/xxx/xxx/xxx/xxx";

socket.connect(url, caPath);

socket.on("connect", () => {
  console.log("Connected to WebSocket server");
  socket.write("Hello, server!", () => {
    console.log("Message sent");
  });
});

socket.on("data", (data) => {
  console.log("Received data:", data);
});

socket.on("error", (error) => {
  console.error("WebSocket error:", error);
});

socket.on("close", (isError, event) => {
  if (isError) {
    console.error("WebSocket connection closed due to error:", event);
  } else {
    console.log("WebSocket connection closed cleanly");
  }
});

```

## 使用说明

#### 连接到WebSocket服务器

```
connect(url, caPath) //连接到WebSocket服务器，参数包括服务器URL和CA证书路径
```

#### 关闭连接

```
end() //关闭连接
```

#### 发送消息到服务器

```
write(data, fn) // 发送消息到服务器，参数包括消息数据和回调函数
```

## 关于混淆
- 代码混淆，请查看[代码混淆简介](https://docs.openharmony.cn/pages/v5.0/zh-cn/application-dev/arkts-utils/source-obfuscation.md)
- 如果希望xmpp_websocket库在代码混淆过程中不会被混淆，需要在混淆规则配置文件obfuscation-rules.txt中添加相应的排除规则：
```
-keep
./oh_modules/@ohos/xmpp_websocket
```

## 约束与限制

在下述版本验证通过：
- DevEco Studio 版本： 5.0.3.200,OpenHarmony SDK:API12 (5.0.0.21-Canary2)。

## 目录结构
```
|---- xmpp_websocket
|     |---- entry  # 示例代码文件夹
|     |---- library  # xmpp_websocket库文件夹
|               |----src/main # 
|                    |----lib # websocket代码文件夹
|               |----index.d.ts # 对外接口描述文件
|               |---- index.js  # 主入口文件
|     |---- README.MD  # 安装使用方法
```
## 贡献代码

使用过程中发现任何问题都可以提[Issue](https://gitcode.com/openharmony-tpc/openharmony_tpc_samples/issues) 给我们，当然，我们也非常欢迎你给我们提[PR](https://gitcode.com/openharmony-tpc/openharmony_tpc_samples/pulls) 。

## 开源协议

本项目基于ISC，请自由地享受和参与开源。