# @ohos/xmpp_debug

## 简介

>本软件是参照开源软件 [@xmpp/debug](https://github.com/xmppjs/xmpp.js/tree/main/packages/session-establishment)源码并用 TypeScript 语言实现了相关功能，在OpenHarmony上提供了一个针对XMPP（Extensible Messaging and Presence Protocol，扩展消息和在线状态协议）开发的调试工具库

## 已支持功能
- 隐藏敏感标签
- 启用调试开关


## 下载安装
1. 参考安装教程 [如何安装OpenHarmony ohpm包](https://gitee.com/openharmony-tpc/docs/blob/master/OpenHarmony_har_usage.md)

2. 安装命令如下：
```
 ohpm install @ohos/xmpp_debug
```

## 接口和属性列表

接口列表

| **接口**                | 参数                           | 功能     |
|-----------------------|------------------------------|--------|
| hideSensitive(element) | element:Element              | 隐藏敏感标签 |
| debug(xmpp,foce)         | xmpp:Connection,foce:boolean | 启用调试   |



## 使用示例

```
import hideSensitive from "@ohos/xmpp_debug";

  let auth: Element =  xml("auth",{ xmlns: "urn:ietf:params:xml:ns:xmpp-sasl" },xml("body", {}, "foo"))
  let hideauth = hideSensitive(auth);//<auth xmlns="urn:ietf:params:xml:ns:xmpp-sasl"><hidden xmlns="xmpp.js"/></auth>
  
  debug(xmpp) // requires process.env.XMPP_DEBUG
  // or
  debug(xmpp, true) // always enabled
 
```

## 使用说明

#### 隐藏敏感标签

```
let hideauth = hideSensitive(auth);//<auth xmlns="urn:ietf:params:xml:ns:xmpp-sasl"><hidden xmlns="xmpp.js"/></auth>
```

#### 隐藏敏感标签

```
  debug(xmpp) // requires process.env.XMPP_DEBUG
  // or
  debug(xmpp, true) // always enabled
```

## 约束与限制

在下述版本验证通过：

- DevEco Studio 版本： 5.0.3.200 OpenHarmony SDK:API12 (5.0.0.21-Canary2)

## 目录结构
````
|---- @ohos/xmpp_debug
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