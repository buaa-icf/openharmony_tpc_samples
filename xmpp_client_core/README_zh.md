# @ohos/xmpp_client_core

## 简介

>本软件是参照开源软件 [@xmpp/client-core](https://github.com/xmppjs/xmpp.js/tree/main/packages/client-core)源码并用 TypeScript 语言实现了相关功能，在OpenHarmony上提供了用于为@xmpp/client整合entity属性的library

## 已支持功能

- 连接管理
- 消息处理
- 状态管理
- 安全认证
- 可扩展性

## 下载安装
1. 参考安装教程 [如何安装OpenHarmony ohpm包](https://gitcode.com/openharmony-tpc/docs/blob/master/OpenHarmony_har_usage.md)

2. 安装命令如下：
```
 ohpm install @ohos/xmpp_client_core
```

## 接口和属性列表

接口列表

| **接口**               | 参数            | 功能                                                      |
|----------------------|---------------| --------------------------------------------------------- |
| send(element, ...args) | elemnet:xml标签 |发送单个消息元素|
| connect(service)             | service：服务器地址 | 连接到指定服务 |
| socketParameters(...args)      | args          |获取连接参数 |


## 使用示例

```
import { Client } from "@ohos/xmpp_client_core";

const client = new Client(options);

client.connect("xmpp://example.com")
  .then(() => {
    // 连接成功后的操作
  })
  .catch((error) => {
    // 处理连接错误
  });

client.send("<message>Hello</message>");
```

## 使用说明

#### 引入 Client 类并创建实例

```
import { Client } from "@ohos/xmpp_client_core";
const client = new Client(options);
```

#### 连接到 XMPP 服务器

```
client.connect("xmpp://example.com")
  .then(() => {
    // 连接成功后的操作
  })
  .catch((error) => {
    // 处理连接错误
  });
```

#### 发送消息

```
client.send("<message>Hello</message>");

```
#### 获取连接参数
```
 client.socketParameters(...args)   
```
## 关于混淆
- 代码混淆，请查看[代码混淆简介](https://docs.openharmony.cn/pages/v5.0/zh-cn/application-dev/arkts-utils/source-obfuscation.md)
- 如果希望三方库在代码混淆过程中不会被混淆，需要在混淆规则配置文件obfuscation-rules.txt中添加相应的排除规则：
```
-keep
./oh_modules/@ohos/xmpp_client_core
```
## 约束与限制

在下述版本验证通过：

- DevEco Studio 版本： 5.0.3.200 OpenHarmony SDK:API12 (5.0.0.21-Canary2)

## 目录结构
````
|---- @ohos/xmpp_client_core
|     |---- entry  # 示例代码文件夹
|           |---- src  
|                   |---- main  #sample示例代码
|                   |---- ohosTest  #xts示例代码
|     |---- library  # @ohos/xmpp_client_core 库文件夹
|           |---- ets
|                 |---- lib  # 主要依赖
|                 |---- types  # 对外接口文件夹
|           |---- index.js  # 主入口文件
|           |---- index.d.ts  # 主对外接口声明文件
|     |---- README.md  # 安装使用方法                    
|     |---- README_zh.md  # 安装使用方法                    
````
## 贡献代码

使用过程中发现任何问题都可以提[Issue](https://gitcode.com/openharmony-tpc/openharmony_tpc_samples/issues) 给我们，当然，我们也非常欢迎你给我们提[PR](https://gitcode.com/openharmony-tpc/openharmony_tpc_samples/pulls) 。

## 开源协议

本项目基于[ISC License](https://gitcode.com/openharmony-tpc/openharmony_tpc_samples/blob/master/xmpp_client_core/LICENSE)，请自由地享受和参与开源。