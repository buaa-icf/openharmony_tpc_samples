# signalr单元测试用例
该测试用例基于OpenHarmony系统下，进行单元测试

单元测试用例覆盖情况
| 接口名  |是否通过   |备注   |
| ------------ | ------------ | ------------ |
|  withUrl |  pass |  连接构建 |
|  configureLogging | pass  |  日志配置 |
|  withAutomaticReconnect | pass  |  自动重连 |
|  withServerTimeout | pass  |  服务器超时 |
|  withKeepAliveInterval | pass  |  心跳间隔 |
|  build | pass  |  构建连接 |
|  start | pass  |  连接管理 |
|  stop | pass  |  连接管理 |
|  invoke | pass  |  方法调用 |
|  send | pass  |  消息发送 |
|  stream | pass  |  流数据 |
|  on | pass  |  事件监听 |
|  off | pass  |  事件移除 |
|  onclose | pass  |  连接关闭事件 |
|  onreconnecting | pass  |  重连事件 |
|  onreconnected | pass  |  重连成功事件 |