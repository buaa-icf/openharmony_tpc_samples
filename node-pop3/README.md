## POP3

### 介绍

支持pop3协议

### 下载

1丶安装

```
ohpm install @ohos/node_pop3
```
OpenHarmony ohpm 环境配置等更多内容，请参考[如何安装 OpenHarmony ohpm 包](https://gitee.com/openharmony-tpc/docs/blob/master/OpenHarmony_har_usage.md) 。
2丶导入

```
import Pop3Command from '@ohos/node_pop3'
```

### Demo样例

参照该Demo工程中[Index](./entry/src/main/ets/pages/Index.ets)页面

单元测试用例详情见[TEST.md](./TEST.md)

### 接口说明

API

| 参数                 | 可选  | 描述                                                                      |
|--------------------|-----|-------------------------------------------------------------------------|
| options.user       | no  | String                                                                  |
| options.password   | no  | String                                                                  |
| options.host       | no  | String                                                                  |
| options.port       | yes | Number. Defaults to 110                                                 |
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


### 约束与限制

在下述版本验证通过：

DevEco Studio: 4.0 Release(4.0.3.413), SDK: API10 (4.0.10.3)

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

