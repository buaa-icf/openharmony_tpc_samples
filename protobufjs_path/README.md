# @protobufjs/path

## 简介

> @protobufjs/path 是一个最小路径模块，用于解析Unix、Windows和URL路径。

## 下载安装

```shell
ohpm install @protobufjs/path
```

OpenHarmony
ohpm环境配置等更多内容，请参考 [如何安装OpenHarmony ohpm包](https://gitee.com/openharmony-tpc/docs/blob/master/OpenHarmony_har_usage.md) 。

## 使用说明

### 引用及使用

```
import path from "@protobufjs/path"
  //测试指定的路径是否为绝对路径
  path.isAbsolute("X:\\some\\path\\file.js")
  //规范化指定的路径
  path.normalize("X:\\some\\..\\.\\path\\\\file.js")
  //根据指定的原始路径解析指定的包含路径
  path.resolve("/path/origin.js", "/some/.././path//file.js")
```

## 接口说明

1. 测试指定的路径是否为绝对路径
   `isAbsolute(path: string): boolean`
2. 规范化指定的路径
   `normalize(path: string): string`
3. 根据指定的原始路径解析指定的包含路径
   `resolve(originPath: string, includePath: string, alreadyNormalized?: boolean): string`

## 约束与限制

在下述版本验证通过：

- DevEco Studio 版本：4.1 Canary(4.1.3.317)，OpenHarmony SDK:API11 (4.1.0.36)

## 目录结构

````
|---- protobuf_path
|     |---- entry  # 示例代码文件夹
|           |---- src
|                 |---- main
|                        |---- ets
|                              |---- pages
|                                    |---- Index # sample
|                 |---- ohosTest
|                       |---- ets
|                             |---- test
|                                   |---- Ability.test.ets  # 单元测试

|     |---- README.md  # 安装使用方法
|     |---- README.OpenSource  # 开源说明
|     |---- CHANGELOG.md  # 更新日志                
````

## 贡献代码

使用过程中发现任何问题都可以提 [Issue](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/issues)
给我们，当然，我们也非常欢迎你给我们发 [PR](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/pulls) 。

## 开源协议

本项目基于 [BSD License](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/blob/master/protobuf_path/LICENSE)
，请自由地享受和参与开源。

