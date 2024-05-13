# @ohos/xmpp_stream_management

## 简介

>本软件是参照开源软件 [@xmpp/stream-management](https://github.com/xmppjs/xmpp.js/tree/main/packages/stream-features)源码并用 TypeScript 语言实现了相关功能，在OpenHarmony上提供了在XMPP连接中协商和实现流管理的功能，包括会话恢复和错误恢复的library

## 已支持功能
- xmpp流管理功能


## 下载安装
1. 参考安装教程 [如何安装OpenHarmony ohpm包](https://gitee.com/openharmony-tpc/docs/blob/master/OpenHarmony_har_usage.md)

2. 安装命令如下：
```
 ohpm install @ohos/xmpp_stream_management
```

## 接口和属性列表

接口列表

| **接口**                                                          | 参数                                                                        | 功能                                                        |
|-----------------------------------------------------------------|---------------------------------------------------------------------------| ----------------------------------------------------------- |
| streamManagement({streamFeatures,entity,middleware}) | streamFeatures:StreamFeatures<br/>entity:Entity<br/>middleware:Middleware |创建了一个streamManagement实例|



## 使用示例

```
import _streamManagement from "@ohos/xmpp_stream_management";

const streamManagement = _streamManagement({
        streamFeatures,
        entity,
        middleware,
});
```

## 使用说明

#### 创建一个streamManagement实例

```
const middleware = streamManagement({
        streamFeatures,
        entity,
        middleware,
});
```

## 约束与限制

在下述版本验证通过：

- DevEco Studio 版本： 5.0.3.200 OpenHarmony SDK:API12 (5.0.0.21-Canary2)

## 目录结构
````
|---- @ohos/xmpp_stream_management
|     |---- entry  # 示例代码文件夹
|           |---- src  
|                   |---- main  #sample示例代码
|                   |---- ohosTest  #xts示例代码
|     |---- library  # 功能库文件夹
|           |---- index.js  # 主入口文件
|           |---- index.d.ts  # 主对外接口声明文件
|     |---- README.md  # 安装使用方法                    
````

## 贡献代码

使用过程中发现任何问题都可以提[Issue](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/issues) 给我们，当然，我们也非常欢迎你给我们提[PR](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/pulls) 。

## 开源协议

本项目基于ISC，请自由地享受和参与开源。