## POP3

### 介绍

支持pop3协议

### 下载

1丶安装

```
ohpm install @ohos/node-pop3
```
OpenHarmony ohpm 环境配置等更多内容，请参考[如何安装 OpenHarmony ohpm 包](https://gitee.com/openharmony-tpc/docs/blob/master/OpenHarmony_har_usage.md) 。
2丶导入

```
import Pop3Command from '@ohos/node-pop3'
```

### Demo样例

参照该Demo工程中[Index](./entry/src/main/ets/pages/Index.ets)页面

单元测试用例详情见[TEST.md](./TEST.md)

### 接口说明

API

| 参数                 | 可选  | 描述                                                                      |
|--------------------|-----|-------------------------------------------------------------------------|
| listify | str | String                                                                  |
| options.host       | no  | String                                                                  |
| options.port       | yes | Number. Defaults to 110                                                 |
| QUIT    | no  | 发送QUIT命令，自动断开连接                                                   |
| options.servername | yes | String. Defaults to host value. Same as servername for Node TLS option. |
| options.tls        | yes | Boolean. Defaults to false                                              |
| options.timeout    | yes | Number. Defaults to undefined                                           |
| connect()          |  | connect                                                            |
| command(...args)   |  | send command messages                                                             |
| listify(str)       |  | converts each line to a an array based on splitting by spaces                                                           |
| UIDL(msgNumber = '') |  |                                                             |
| RETR(msgNumber)       |  |                                                             |
| TOP(msgNumber, numLines = 0) |  |                                                           |
| QUIT()             |  |                                                          |

更多模块的使用可参考[官方文档](https://github.com/node-pop3/node-pop3/blob/master/README.md)，[单元测试用例](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/blob/master/node-pop3/TEST.md)详情可参考

### 约束与限制

在下述版本验证通过：

DevEco Studio: 4.0 Release(4.0.3.413), SDK: API10 (4.0.10.3)

支持的邮箱类型：QQ邮箱、163邮箱、126邮箱。

### 软件架构

```
|-entry 
    |-ets
    |   |-entryability
    |           |-EntryAbility.ts
    |   |-pages
    |           |-LoginPage.ets             #主页demo
    |           |-SendMailPage.ets
|-POP3   # pop3协议lib         
```

### 贡献代码

使用过程中发现任何问题都可以提 [Issue](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/issues)
给我们，当然，我们也非常欢迎你给我们发 [PR](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/pulls) 。

### 开源协议

本项目基于 [MIT license](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/blob/master/node-pop3/LICENSE) ，请自由地享受和参与开源。

