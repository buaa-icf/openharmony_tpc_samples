# ieee754

## 简介

> IEEE浮点运算标准(IEEE 754)是一个浮点计算的技术标准.

## 下载安装

```shell
ohpm  install ieee754@1.2.1
```

OpenHarmony ohpm 环境配置等更多内容，请参考 [如何安装OpenHarmony ohpm包](https://gitcode.com/openharmony-tpc/docs/blob/master/OpenHarmony_har_usage.md) 。

## 使用说明
```
import * as ieee754 from 'ieee754'
ieee754.read = function (buffer, offset, isLE, mLen, nBytes)
ieee754.write = function (buffer, value, offset, isLE, mLen, nBytes)

## 约束与限制

在下述版本验证通过：

- DevEco Studio 版本： 4.1 Canary(4.1.3.317),OpenHarmony SDK:API11 (4.1.0.36)。

````
## 接口说明

1.写入数据：wirte
2.读取数据：read

## 目录结构

````
|---- ieee754
|     |---- entry  # 示例代码文件夹
              ├── src  
                 ├── main   
                   ├── ets
                       ├── pages
                             ├── Index.ets  sample代码
|     |---- README.md  # 安装使用方法                    
````

## 贡献代码

使用过程中发现任何问题都可以提 [Issue](https://gitcode.com/openharmony-tpc/openharmony_tpc_samples/issues)
给我们，当然，我们也非常欢迎你给我们发 [PR](https://gitcode.com/openharmony-tpc/openharmony_tpc_samples/pulls) 。

## 开源协议

本项目基于 [BSD-3-Clause License](https://gitcode.com/openharmony-tpc/openharmony_tpc_samples/blob/master/ieee754/LICENSE)
，请自由地享受和参与开源。
    