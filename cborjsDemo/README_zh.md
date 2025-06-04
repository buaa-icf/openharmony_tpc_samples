# cborDemo

## 简介

本项目是OpenHarmony系统下使用cbor-js的示例，cbor-js是以简明二进制对象表示 (CBOR) 数据格式 ( RFC 7049 )编码和解析数据的Javascript开源库。

## 下载安装

```
ohpm install cbor-js
ohpm install @types/cbor-js --save-dev //import cbor-js 的时候语法报错。其原因是cbor-js包内不含类型声明，需要 @types/cbor-js 下载这个包的声明文件，从而解决语法的报错。

```
OpenHarmony ohpm 环境配置等更多内容，请参考[如何安装 OpenHarmony ohpm 包](https://gitcode.com/openharmony-tpc/docs/blob/master/OpenHarmony_har_usage.md)

OpenHarmony ohpm环境配置等更多内容，请参考 [如何安装OpenHarmony ohpm包](https://gitcode.com/openharmony-tpc/docs/blob/master/OpenHarmony_har_usage.md) 。 

## 使用说明

```javascript
import CBOR from 'cbor-js'

var initial = { Hello: "World" };
var encoded = CBOR.encode(initial)
var decoded = CBOR.decode(encoded)
```

## 接口说明
1. encode()对数据进行简明二进制对象CBOR的编码。
2. decode()对数据进行简明二进制对象CBOR的解码。

## 约束与限制

在下述版本验证通过：
- DevEco Studio: NEXT Beta1-5.0.3.806, SDK: API12 Release (5.0.0.66)

- Deveco Studio:4.0 (4.0.3.512),SDK:API10 (4.0.10.9)

- DevEco Studio: 3.1 Beta2(3.1.0.400), SDK: API9 Release(3.2.11.9)

## 目录结构

```
 ├── cborjsDemo
 │ └── entry
 │ │ └── src
 │ │ │ ├── main
 │ │ │ │  ├── ets
 │ │ │ │  │ ├── pages        
 │ │ │ │ │  │ ├── index.ets       # cbor编解码示例
```

## 贡献代码
使用过程中发现任何问题都可以提 [Issue](https://gitcode.com/openharmony-tpc/openharmony_tpc_samples/issues) 给我们，当然，我们也非常欢迎你给我们发 [PR](https://gitcode.com/openharmony-tpc/openharmony_tpc_samples/pulls) 。

## 开源协议
本项目基于 [Apache License 2.0](https://gitcode.com/openharmony-tpc/openharmony_tpc_samples/blob/master/cborjsDemo/LICENSE)，请自由地享受和参与开源。