# signalr

## 简介

> signalr是一个在客户端和服务器之间实现低延迟、双向和基于事件的通信的库。建立在 WebSocket 协议之上，并提供额外的保证，例如回退到 HTTP 长轮询或自动重新连接。

### 注意事项：
- signalr 支持基于 HTTP 和 HTTPS（TLS）协议的连接；
- 支持多种传输方式：WebSockets、Server-Sent Events、Long Polling；

## 效果展示

![avatar](ScreenShots/演示.gif)

## 下载安装

```shell
ohpm install @ohos/signalr
```
OpenHarmony ohpm 环境配置等更多内容，请参考[如何安装 OpenHarmony ohpm 包](https://gitcode.com/openharmony-tpc/docs/blob/master/OpenHarmony_har_usage.md)。

## X86模拟器配置

[使用模拟器运行应用/服务](https://developer.huawei.com/consumer/cn/deveco-developer-suite/enabling/kit?currentPage=1&pageSize=100)。

## 使用说明

### 前置条件：配置网络权限

在使用本库之前，需要在 `entry/src/main/module.json5` 文件中配置网络权限：

```json
"requestPermissions": [
  {
    "name": "ohos.permission.INTERNET",
    "reason": "$string:internet_permission_reason",
    "usedScene": {
      "abilities": ["EntryAbility"],
      "when": "inuse"
    }
  }
]
```

### 使用步骤

1. 导入依赖库

```typescript
import { HubConnectionBuilder, HubConnection, HubConnectionState, LogLevel, HttpTransportType, IHttpConnectionOptions, ISubscription } from '@ohos/signalr';
```

2. 初始化SignalR客户端

```typescript
hubConnection: HubConnection | null = null;
```

3. 设置连接配置和监听事件

```typescript
// 创建连接配置
const connectionOptions: IHttpConnectionOptions = {
  headers: {
    'User-Agent': 'HarmonyOS-SignalR-Client/1.0'
  },
  skipNegotiation: false,
  transport: HttpTransportType.WebSockets // 或其他传输方式
};

// 创建连接
this.hubConnection = new HubConnectionBuilder()
  .withUrl('http://yourserver.com/yourhub', connectionOptions)
  .configureLogging(LogLevel.Debug)
  .withKeepAliveInterval(15000) // 保持15秒心跳间隔
  .withAutomaticReconnect([0, 2000, 10000, 30000]) // 重连间隔
  .build();
```

4. 连接服务器

```typescript
await this.hubConnection.start();
```

5. 设置用户消息监听以及用户加入离开监听

```typescript
// 监听接收消息
this.hubConnection.on('ReceiveMessage', (user: string, message: string) => {
  console.log(`${user}: ${message}`);
});

// 监听用户加入
this.hubConnection.on('UserJoined', (userName: string) => {
  console.log(`${userName} 加入了聊天室`);
});

// 监听用户离开
this.hubConnection.on('UserLeft', (userName: string) => {
  console.log(`${userName} 离开了聊天室`);
});
```

6. 发送消息到服务器

```typescript
await this.hubConnection.invoke('SendMessage', userName, message);
```

7. 设置连接状态监听

```typescript
// 连接关闭事件
this.hubConnection.onclose((error?: Error) => {
  if (error) {
    console.error('连接意外关闭:', error);
  } else {
    console.log('连接正常关闭');
  }
});

// 重连事件
this.hubConnection.onreconnecting((error?: Error) => {
  console.log('正在重连...');
});

this.hubConnection.onreconnected((connectionId?: string) => {
  console.log('重连成功:', connectionId);
});
```

8. 关闭服务器连接

```typescript
await this.hubConnection.stop();
```

9. 流式数据传输

```typescript
// 接收流数据
const streamResult = this.hubConnection.stream<number>('StreamData', 10);

const subscription = streamResult.subscribe({
  next: (item: number) => {
    console.log('收到流数据:', item);
  },
  error: (err: Error) => {
    console.error('流传输错误:', err);
  },
  complete: () => {
    console.log('流传输完成');
  }
});

// 停止流传输
subscription.dispose();
```

10. 补充说明

- 本示例代码中提供了一个完整的聊天应用Demo，具体使用时可以根据自己的需求进行修改。

## 接口说明

- 初始化客户端

```typescript
hubConnection: HubConnection = new HubConnectionBuilder()
  .withUrl(url, options)
  .build();
```

- 配置连接URL和选项

```typescript
withUrl(url: string, options?: IHttpConnectionOptions): HubConnectionBuilder
```

- 配置日志级别

```typescript
configureLogging(logLevel: LogLevel): HubConnectionBuilder
```

- 设置服务器超时时间

```typescript
withServerTimeout(milliseconds: number): HubConnectionBuilder
```

- 设置心跳间隔

```typescript
withKeepAliveInterval(milliseconds: number): HubConnectionBuilder
```

- 配置自动重连

```typescript
withAutomaticReconnect(retryDelays?: number[]): HubConnectionBuilder
```

- 启动连接

```typescript
start(): Promise<void>
```

- 停止连接

```typescript
stop(): Promise<void>
```

- 获取连接状态

```typescript
state: HubConnectionState
```

- 注册事件监听器

```typescript
on(methodName: string, newMethod: (...args: (string | number | boolean | object)[]) => void): void
```

- 调用服务器方法

```typescript
invoke<T = object>(methodName: string, ...args: (string | number | boolean | object)[]): Promise<T>
```

- 发送消息（不等待响应）

```typescript
send(methodName: string, ...args: (string | number | boolean | object)[]): Promise<void>
```

- 流式数据订阅

```typescript
stream<T>(methodName: string, ...args: (string | number | boolean)[]): IStreamResult<T>
// 示例：stream<number>('StreamData', 10)
```

- 流订阅管理

```typescript
interface ISubscription<T> {
  dispose(): void; // 取消流订阅
}
```

- 连接关闭监听

```typescript
onclose(callback: (error?: Error) => void): void
```

- 重连监听

```typescript
onreconnecting(callback: (error?: Error) => void): void
onreconnected(callback: (connectionId?: string) => void): void
```

- 传输类型枚举

```typescript
enum HttpTransportType {
  None = 0,
  WebSockets = 1,
  ServerSentEvents = 2,
  LongPolling = 4
}
```

- 连接状态枚举

```typescript
enum HubConnectionState {
  Disconnected = "Disconnected",
  Connecting = "Connecting", 
  Connected = "Connected",
  Disconnecting = "Disconnecting",
  Reconnecting = "Reconnecting"
}
```

- 日志级别枚举

```typescript
enum LogLevel {
  Trace = 0,
  Debug = 1,
  Information = 2,
  Warning = 3,
  Error = 4,
  Critical = 5,
  None = 6
}
```

## 关于混淆
- 代码混淆，请查看[代码混淆简介](https://docs.openharmony.cn/pages/v5.0/zh-cn/application-dev/arkts-utils/source-obfuscation.md)
- 如果希望@ohos/signalr库在代码混淆过程中不会被混淆，需要在混淆规则配置文件obfuscation-rules.txt中添加相应的排除规则：
```
-keep
./oh_modules/@ohos/signalr
```

## 约束与限制

在下述版本验证通过：

- IDE：DevEco Studio 5.1.0.849; SDK:API18 (5.1.0.125)。
- IDE：DevEco Studio 5.1.1.823; SDK:API19 (5.1.1.823)。

## 目录结构
```
|---- signalr
|     |---- entry  # 示例代码文件夹
|           |---- src # Demo源码目录
|                 |---- main # 主要代码
|                       |---- ets # ArkTS代码
|                             |---- pages # 页面目录
|                                   |---- Index.ets # 主页面（聊天Demo）
|     |---- library  # SignalR库
|           |---- src # 库源码目录
|                 |---- main # 主要代码
|                       |---- ets # ArkTS代码
|                             |---- src # 核心类目录
|                                   |---- HubConnection.ts # Hub连接核心类
|                                   |---- HubConnectionBuilder.ts # 连接构建器
|                                   |---- index.ts # 导出接口
|                                   |---- HarmonyHttpClient.ts # 鸿蒙HTTP客户端
|                                   |---- HarmonyWebSocketTransport.ts # WebSocket传输
|     |---- README.md  # 安装使用方法
```

## 贡献代码

使用过程中发现任何问题都可以提 [Issue](https://gitcode.com/openharmony-tpc/openharmony_tpc_samples/issues) 给组件，当然也非常欢迎给
发 [PR](https://gitcode.com/openharmony-tpc/openharmony_tpc_samples/pulls) 共建。

## 开源协议

本项目基于 [MIT LICENSE](https://gitcode.com/openharmony-tpc/openharmony_tpc_samples/tree/master/SignalR/LICENSE) ，请自由地享受和参与开源。