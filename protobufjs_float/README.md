# @protobufjs/float

## 简介

> @protobufjs/float 是一个从缓冲区读取和写入浮点数以及双精度浮点数的工具库。

## 下载安装

```shell
ohpm install @protobufjs/float
```

OpenHarmony
ohpm环境配置等更多内容，请参考 [如何安装OpenHarmony ohpm包](https://gitee.com/openharmony-tpc/docs/blob/master/OpenHarmony_har_usage.md) 。

## 使用说明

### 引用及使用

1、使用小端字节序将32位浮点数写入缓冲区

```
import EventEmitter from "@protobufjs/float"
const value = 3.14159;
const buffer = new Uint8Array(4)
writeFloatLE(value, buffer, 0);
```

2、使用大端字节序将32位浮点数写入缓冲区

```
const value = 1.1754943508222875e-38;
const buffer = new Uint8Array(4)
writeDoubleLE(value, buffer, 0);
```

3、使用小端字节序从缓冲区读取32位浮点数

```
const value = 1.1754943508222875e-38;
const buffer = new Uint8Array(4)
writeDoubleBE(value, buffer, 0);
```

4、使用大端字节序从缓冲区读取32位浮点数

```
const value = 2.2250738585072014e-309;
const buffer = new Uint8Array(4)
writeFloatLE(value, buffer, 0);
readFloatLE(buffer, 0);
```

5、使用小端字节序将64位双精度浮点数写入缓冲区

```
const value = 2.2250738585072014e-309;
const buffer = new Uint8Array(4)
writeFloatLE(value, buffer, 0);
readFloatLE(buffer, 0);
```

6、使用大端字节序将64位双精度浮点数写入缓冲区

```
const value = 2.2250738585072014e-309;
const buffer = new Uint8Array(4)
writeFloatBE(value, buffer, 0);
readFloatBE(buffer, 0);
```

7、使用小端字节序从缓冲区读取64位双精度浮点数

```
const value = 3.4028234663852886e+38;
const buffer = new Uint8Array(4)
writeDoubleBE(value, buffer, 0);
readDoubleBE(buffer, 0);
```

8、使用大端字节序从缓冲区读取64位双精度浮点数

```
const value = 3.4028234663852886e+38;
const buffer = new Uint8Array(4)
writeDoubleLE(value, buffer, 0);
readDoubleLE(buffer, 0);
```

## 接口说明

1. 使用小端字节序将32位浮点数写入缓冲区
   `writeFloatLE(val: number, buf: Uint8Array, pos: number): void`
2. 使用大端字节序将32位浮点数写入缓冲区
   `writeFloatBE(val: number, buf: Uint8Array, pos: number): void`
3. 使用小端字节序从缓冲区读取32位浮点数
   `readFloatLE(buf: Uint8Array, pos: number): number`
4. 使用大端字节序从缓冲区读取32位浮点数
   `readFloatBE(buf: Uint8Array, pos: number): number`
5. 使用小端字节序将64位双精度浮点数写入缓冲区
   `writeDoubleLE(val: number, buf: Uint8Array, pos: number): void`
6. 使用大端字节序将64位双精度浮点数写入缓冲区
   `writeDoubleBE(val: number, buf: Uint8Array, pos: number): void`
7. 使用小端字节序从缓冲区读取64位双精度浮点数
   `readDoubleLE(buf: Uint8Array, pos: number): number`
8. 使用大端字节序从缓冲区读取64位双精度浮点数
   `readDoubleBE(buf: Uint8Array, pos: number): number`

## 约束与限制

在下述版本验证通过：

- DevEco Studio 版本：4.1 Canary(4.1.3.317)，OpenHarmony SDK:API11 (4.1.0.36)

## 目录结构

````
|---- protobufjs_float
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

使用过程中发现任何问题都可以提 [Issue](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/issues)给我们，当然，我们也非常欢迎你给我们发 [PR](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/pulls) 。

## 开源协议

本项目基于 [BSD License](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/blob/master/protobufjs_float/LICENSE)
，请自由地享受和参与开源。

