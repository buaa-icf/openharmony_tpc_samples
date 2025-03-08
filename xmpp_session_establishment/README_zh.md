# @ohos/xmpp_session_establishment

## 简介

>本软件是参照开源软件 [@xmpp/session-establishment](https://github.com/xmppjs/xmpp.js/tree/main/packages/session-establishment)源码并用 TypeScript 语言实现了相关功能，在OpenHarmony上提供了用于处理服务器发送的特性，并根据这些特性来决定如何建立会话的library

## 已支持功能
- 建立会话


## 下载安装
1. 参考安装教程 [如何安装OpenHarmony ohpm包](https://gitcode.com/openharmony-tpc/docs/blob/master/OpenHarmony_har_usage.md)

2. 安装命令如下：
```
 ohpm install @ohos/xmpp_session_establishment
```

## 接口和属性列表

接口列表

| **接口**                                                          | 参数                                                                        | 功能                                                        |
|-----------------------------------------------------------------|---------------------------------------------------------------------------| ----------------------------------------------------------- |
| sessionEstablishment({iqCaller, streamFeatures}) | iqCaller:IQCaller<br/>streamFeatures:StreamFeatures | 建立会话 |



## 使用示例

```
import _sessionEstablishment from "@ohos/xmpp_session_establishment";

 const entity = new ClientCore(params);
 const sessionEstablishment = _sessionEstablishment({
     iqCaller,
     streamFeatures,
 });
 
 Object.assign(entity, {
        sessionEstablishment,
    });
```

## 使用说明

#### 建立会话

```
 const sessionEstablishment = _sessionEstablishment({
     iqCaller,
     streamFeatures,
 });
```

## 关于混淆
- 代码混淆，请查看[代码混淆简介](https://docs.openharmony.cn/pages/v5.0/zh-cn/application-dev/arkts-utils/source-obfuscation.md)
- 如果希望xmpp_session_establishment库在代码混淆过程中不会被混淆，需要在混淆规则配置文件obfuscation-rules.txt中添加相应的排除规则：
```
-keep
./oh_modules/@ohos/xmpp_session_establishment
```

## 约束与限制

在下述版本验证通过：

- DevEco Studio 版本： 5.0.3.200 OpenHarmony SDK:API12 (5.0.0.21-Canary2)

## 目录结构
````
|---- @ohos/xmpp_session_establishment
|     |---- entry  # 示例代码文件夹
|           |---- src  
|                   |---- main  # sample示例代码
|                   |---- ohosTest  # xts示例代码
|     |---- library  # 功能库文件夹
|           |---- index.js  # 主入口文件
|           |---- index.d.ts  # 主对外接口声明文件
|     |---- README_zh.md  # 安装使用方法                    
````

## 贡献代码

使用过程中发现任何问题都可以提[Issue](https://gitcode.com/openharmony-tpc/openharmony_tpc_samples/issues) 给我们，当然，我们也非常欢迎你给我们提[PR](https://gitcode.com/openharmony-tpc/openharmony_tpc_samples/pulls) 。

## 开源协议

本项目基于ISC，请自由地享受和参与开源。