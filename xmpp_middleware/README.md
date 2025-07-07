# @ohos/xmpp_middleware

## 简介

>本软件是参照开源软件 [@xmpp/middleware](https://github.com/xmppjs/xmpp.js/tree/main/packages/middleware)源码并用 TypeScript 语言实现了相关功能，在OpenHarmony上提供了用于@xmpp/client和@xmpp/component的中间件的library

## 已支持功能

- 实现中间件的注册、应用和处理。
- 实现消息处理,发送和接收过程中应用中间件。
- 实现事件处理,XMPP事件发生时应用中间件。

## 下载安装
1. 参考安装教程 [如何安装OpenHarmony ohpm包](https://gitcode.com/openharmony-tpc/docs/blob/master/OpenHarmony_har_usage.md)

2. 安装命令如下：
```
 ohpm install @ohos/xmpp_middleware
```

## 接口和属性列表

接口列表

| **接口**               | 参数                 | 功能                                                        |
|----------------------|--------------------| ----------------------------------------------------------- |
| middleware({entity}) | entity :Connection |创建了一个middleware实例|
| use(fn)              | fn:Function        | use方法为传入节注册中间件 |
| filter(fn)          | fn:Function        | filter方法为输出节注册中间件。 |


## 使用示例

```
import _middleware from "@ohos/xmpp_middleware";

const middleware = _middleware({ entity });

middleware.use((ctx, next) => {});

middleware.filter((ctx, next) => {});
```

## 使用说明

#### 创建一个middleware实例

```
const middleware = _middleware({ entity });
```

#### 传入节注册中间件

```
middleware.use((ctx, next) => {});
```

#### 输出节注册中间件

```
middleware.filter((ctx, next) => {});
```

## 约束与限制

在下述版本验证通过：

- DevEco Studio 版本： 5.0.3.200 OpenHarmony SDK:API12 (5.0.0.21-Canary2)

## 目录结构
````
|---- @ohos/xmpp_middleware 
|     |---- entry  # 示例代码文件夹
|           |---- src  
|                   |---- main  #sample示例代码
|                   |---- ohosTest  #xts示例代码
|     |---- library  # @ohos/xmpp_middleware 库文件夹
|           |---- ets
|                 |---- lib  # 主要依赖
|                 |---- types  # 对外接口文件夹
|           |---- index.js  # 主入口文件
|           |---- index.d.ts  # 主对外接口声明文件
|     |---- README.md  # 安装使用方法                    
````

## 贡献代码

使用过程中发现任何问题都可以提[Issue](https://gitcode.com/openharmony-tpc/openharmony_tpc_samples/issues) 给我们，当然，我们也非常欢迎你给我们提[PR](https://gitcode.com/openharmony-tpc/openharmony_tpc_samples/pulls) 。

## 开源协议

本项目基于[ISC License](https://gitcode.com/openharmony-tpc/openharmony_tpc_samples/blob/master/xmpp_middleware/LICENSE)，请自由地享受和参与开源。