# @ohos/xmpp_sasl_plain

## 简介

>本软件是参照开源软件 [@xmpp/sasl-plain](https://github.com/xmppjs/xmpp.js/blob/main/packages/sasl-plain)源码并用 TypeScript 语言实现了相关功能，在OpenHarmony上提供了用于 XMPP（Extensible Messaging and Presence Protocol）的 SASL PLAIN 认证机制的library

## 已支持功能
- 简单明文认证


## 下载安装
1. 参考安装教程 [如何安装OpenHarmony ohpm包](https://gitcode.com/openharmony-tpc/docs/blob/master/OpenHarmony_har_usage.md)

2. 安装命令如下：
```
 ohpm install @ohos/xmpp_sasl_plain
```

## 接口和属性列表

接口列表

| **接口**                                                        | 参数                                                                        | 功能      |
|---------------------------------------------------------------|---------------------------------------------------------------------------|---------|
| saslPlain(sasl) | sasl:SASL | 简单明文认证 |



## 使用示例

```
import plain from "@ohos/xmpp_sasl_plain";

const sasl = _sasl({ streamFeatures }, credentials || { username, password });
 
const mechanisms = Object.entries({
    scramsha1,
    plain,
    anonymous,
}).map(([k, v]) => ({ [k]: v(sasl) }));

Object.assign(entity, {
        sasl,
        mechanisms
});
```

## 使用说明

#### 简单明文认证

```
 saslPlain(sasl)
```

## 关于混淆
- 代码混淆，请查看[代码混淆简介](https://docs.openharmony.cn/pages/v5.0/zh-cn/application-dev/arkts-utils/source-obfuscation.md)
- 如果希望xmpp_sasl_plain库在代码混淆过程中不会被混淆，需要在混淆规则配置文件obfuscation-rules.txt中添加相应的排除规则：
```
-keep
./oh_modules/@ohos/xmpp_sasl_plain
```

## 约束与限制

在下述版本验证通过：

- DevEco Studio 版本： 5.0.3.200 OpenHarmony SDK:API12 (5.0.0.21-Canary2)

## 目录结构
````
|---- @ohos/xmpp_sasl_plain
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

使用过程中发现任何问题都可以提[Issue](https://gitcode.com/openharmony-tpc/openharmony_tpc_samples/issues) 给我们，当然，我们也非常欢迎你给我们提[PR](https://gitcode.com/openharmony-tpc/openharmony_tpc_samples/pulls) 。

## 开源协议

本项目基于[ISC license](https://gitcode.com/openharmony-tpc/openharmony_tpc_samples/blob/master/xmpp_sasl_plain/LICENSE)，请自由地享受和参与开源。