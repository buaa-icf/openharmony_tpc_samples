# APNG

## 简介

本项目是以开源库[apng-js](https://github.com/davidmz/apng-js)为参考，基于arkts专门为OpenHarmony打造的一款针对APNG格式图片进行编解码的三方库.

#### 效果图如下：

![演示示例](./APNG.gif)

## 下载安装

```
ohpm install @ohos/apng
```
OpenHarmony ohpm 环境配置等更多内容，请参考 [如何安装 OpenHarmony ohpm 包](https://gitee.com/openharmony-tpc/docs/blob/master/OpenHarmony_har_usage.md)

## 使用说明

```
调用
1.引入 import apng from '@ohos/apng';
 apng({
      src: $r('app.media.stack'), //图片资源
      speedRate: 1 //动画倍速，该属性仅对APNG图片类型为fcTL的生效
 })
2、在应用的entryAility中引入 import { GlobalContext } from '@ohos/apng'
   在onCreate函数中调用，传入上下文对象，用作后续读取本地图片资源文件
   GlobalContext.getContext().setObject('MainContext',this.context);

```

## 接口说明

| 接口名  | 参数                  | 返回值 | 说明                                                     |
|------|---------------------|-----|--------------------------------------------------------|
| apng | src <br/> speedRate |     | src:图片资源<br/> speedRate : 动画倍速                         |
| GlobalContext | key <br/> objectClass  |     | key：上下文对象对应的key,固定值 "MainContext" <br/>   objectClass:上下文对象 |

## 约束与限制

在下述版本验证通过：

DevEco Studio: 4.1 Canary2(4.1.3.521), SDK: API10 (4.0.10.16)

## 目录结构

```
|---- apng
|     |---- entry # 示例代码文件夹
|     |---- library # apng库文件夹
|           |---- src
|                 |---- main
|                       |---- ets
|                             |---- components
|                                   |---- apng.ets # 处理apng拆解后的每一帧，每一帧通过canvas绘制成apng
|                                   |---- crc32.ets # 用作数据传输和存储中的错误检测
|                                   |---- GlobalContext.ets # 创建了一个全局类，用来获取数据对象或者设置对象的值
|                                   |---- manager.ets # 读取本地apng文件，获取到文件buffer对象
|                                   |---- parser.ets # 对buffer对象进行拆解
|                                   |---- structs.ets # 创建了两个类，APNG类指的是整个APNG动画，包括宽度、高度、播放次数、播放时间和帧列表等属性，Frame类指的是APNG动画中的每一帧
|     |---- README.MD # 安装使用方法

```
## 贡献代码

使用过程中发现任何问题都可以给我们提[Issue](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/issues)，当然，我们也非常欢迎你给我们提[PR](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/pulls)。

## 开源协议

本项目基于 [MIT](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/blob/master/apng/LICENSE) ，请自由地享受和参与开源。