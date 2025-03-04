# ohos_ntp


## 简介

> ohos_ntp是一个用于网络时间协议(NTP)服务器同步事件的TypeScript库。它允许应用程序通过与NTP服务器通信来获取准确的事件信息，以确保设备具有准确的系统时钟，或确保能获取到准确时间信息用来调试。
>
> ![GIF](./img/ntpGIF.gif)

## 下载安装

```shell
ohpm install @ohos/ntp
```

OpenHarmony ohpm环境配置等更多内容，请参考 [如何安装OpenHarmony ohpm包](https://gitcode.com/openharmony-tpc/docs/blob/master/OpenHarmony_har_usage.md) 。

## 使用说明

1、引入依赖

 ``` 
 import { getNetworkTime, NTPConfig } from '@ohos/ntp';
 ```

2、在module.json5中添加权限

 ```
 "requestPermissions": [
     {
         "name": "ohos.permission.INTERNET"
     }
 ]
 ```

3、在事件或钩子函数中创建NTPClient实例化对象，调用getNetworkTime方法，不传参为默认值

 ```
const ntpConfig: NTPConfig = {
    server: ntp.aliyun.com(NTP服务器),
	port: 123(远端端口号),
	delayTime: 3000(等待响应时长(ms))
}
 
getNetworkTime(ntpConfig)
.then(date => {
	this.ntpResult = JSON.stringify(date); //"2024-02-06T01:50:37.645Z"
})
.catch((err: string) => {
	this.timeoutResult = JSON.stringify(err);
})
 ```

## 接口说明

| 接口名         | 参数                               | 返回值          | 说明        |
| -------------- | ---------------------------------- | --------------- | ----------- |
| getNetworkTime | {server,port,delayTime}:NTPConfig | Promise< Date > | 获取NTP时间 |

## 约束与限制

在下述版本验证通过：
- DevEco Studio: NEXT Release(5.0.3.900), SDK: API12 (5.0.0.71)
- DevEco Studio: NEXT Developer Beta3(5.0.3.524), SDK: API12 (5.0.0.25)
- DevEco Studio版本: 4.1.3.500, SDK: API11 Release(4.1.0)

## 目录结构

````
|---- ntpclient
|     |---- entry  # 示例代码文件夹
|     |---- library  # ntp库文件夹
|         |---- src
|             |---- main
|                  |---- ets
|                       |---- index.ts  #ntp
|         |---- index.ts  # 对外接口
|     |---- README.md  # 安装使用方法
|     |---- README_zh.md  # 安装使用方法                    
````

## 关于混淆
- 代码混淆，请查看[代码混淆简介](https://docs.openharmony.cn/pages/v5.0/zh-cn/application-dev/arkts-utils/source-obfuscation.md)
- 如果希望ntp库在代码混淆过程中不会被混淆，需要在混淆规则配置文件obfuscation-rules.txt中添加相应的排除规则：

```
-keep
./oh_modules/@ohos/ntp
```

## 贡献代码

使用过程中发现任何问题都可以提 [Issue](https://gitcode.com/openharmony-tpc/openharmony_tpc_samples/issues) 给组件，当然，也非常欢迎发 [PR](https://gitcode.com/openharmony-tpc/openharmony_tpc_samples/pulls)共建 。

## 开源协议

本项目基于 [Apache License 2.0](https://gitcode.com/openharmony-tpc/openharmony_tpc_samples/blob/master/ohos_ntp/LICENSE) ，请自由地享受和参与开源。
