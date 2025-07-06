# timers

## 简介

> timers是一个用于时间解析的工具库。


## 下载安装

```shell
ohpm install timers@0.1.1
```
OpenHarmony ohpm 环境配置等更多内容，请参考[如何安装 OpenHarmony ohpm 包](https://gitcode.com/openharmony-tpc/docs/blob/master/OpenHarmony_har_usage.md)

## 使用说明

1. 导入依赖库

```typescript
import timers from 'timers'
```

2. 按需使用相关接口

```typescript
Button('测试every接口')
  .fontSize(30)
  .onClick(() => {
    this.message = JSON.stringify(timers.every('10h').time)
  })
```

## 接口说明

- 解析指定字符串的时间值

```typescript
every(str:string):Every
```


## 约束与限制

在下述版本验证通过：适配DevEco Studio:4.1 Canary(4.1.3.317)，OpenHarmony SDK:API version 11 (4.1.0.36).

## 目录结构
````
|---- timers  
|     |---- entry  # 示例代码文件夹
|     |---- README.md  # 安装使用方法                    
|     |---- README_zh.md  # 安装使用方法                    
````

## 贡献代码
使用过程中发现任何问题都可以提 [Issue](https://gitcode.com/openharmony-tpc/openharmony_tpc_samples/issues) 给我们，当然，我们也非常欢迎你给我们发 [PR](https://gitcode.com/openharmony-tpc/openharmony_tpc_samples/pulls) 。
## 开源协议
本项目基于 [MIT LICENSE](https://gitcode.com/openharmony-tpc/openharmony_tpc_samples/blob/master/timers/LICENSE) ，请自由地享受和参与开源。
  

