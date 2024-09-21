# @ohos/xmpp_uri

## 简介

>本软件是参照开源软件 [@xmpp/session-establishment](https://github.com/xmppjs/xmpp.js/tree/main/packages/session-establishment)源码并用 TypeScript 语言实现了相关功能，在OpenHarmony上提供了对XMPP协议中URI的解析和构建功能，使开发者能够方便地处理XMPP协议中的资源标识符。

## 已支持功能
- URI的解析


## 下载安装
1. 参考安装教程 [如何安装OpenHarmony ohpm包](https://gitee.com/openharmony-tpc/docs/blob/master/OpenHarmony_har_usage.md)

2. 安装命令如下：
```
 ohpm install @ohos/xmpp_uri
```

## 接口和属性列表

接口列表

| **接口**                                                          | 参数         | 功能       |
|-----------------------------------------------------------------|------------|----------|
| parse(str) | str:String | uri解析 |



## 使用示例

```
import { parse } from "@ohos/xmpp_uri";

let xmppurl = parse("xmpp:support@example.com/truc")

xmppurl.path = jid("support@example.com/truc")

```

## 使用说明

#### URI的解析

```
let xmppurl = parse("xmpp:support@example.com/truc")
```

## 约束与限制

在下述版本验证通过：

- DevEco Studio 版本： 5.0.3.200 OpenHarmony SDK:API12 (5.0.0.21-Canary2)

## 目录结构
````
|---- @ohos/xmpp_uri
|     |---- entry  # 示例代码文件夹
|           |---- src  
|                   |---- main  #sample示例代码
|                   |---- ohosTest  #xts示例代码
|     |---- library  # 功能库文件夹
|           |---- index.js  # 主入口文件
|           |---- index.d.ts  # 主对外接口声明文件
|     |---- README_zh.md  # 安装使用方法                    
````

## 贡献代码

使用过程中发现任何问题都可以提[Issue](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/issues) 给我们，当然，我们也非常欢迎你给我们提[PR](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/pulls) 。

## 开源协议

本项目基于ISC，请自由地享受和参与开源。