# @protobufjs/utf8

## 简介
> @protobufjs/pool 是一个用于数字数组的最小UTF8实现

## 下载安装
```shell
ohpm install @protobufjs/utf8
```
OpenHarmony ohpm环境配置等更多内容，请参考 [如何安装OpenHarmony ohpm包](https://gitee.com/openharmony-tpc/docs/blob/master/OpenHarmony_har_usage.md) 。

## 使用说明

### 引用及使用
```
import utf8 from "@protobufjs/utf8"

//计算字符串的UTF8字节长度
let uint8:Uint8Array
utf8.length(uint8.toString())

//将UTF8字节作为字符串读取
let uint8:Uint8Array
utf8.read(data, 0, data.byteLength);

//将字符串写成UTF8字节
let data:Uint8Array
let len = utf8.length(Utf8ArrayToStr(data));
let buf = buffer.alloc(len);
utf8.write(Utf8ArrayToStr(data),new Uint8Array(buf.buffer), 0)
```

## 接口说明
1. 计算字符串的UTF8字节长度
   `length(string: string): number`
2. 将UTF8字节作为字符串读取
   `read(buffer: Uint8Array, start: number, end: number): string`
3. 将字符串写成UTF8字节。
   `write(string: string, buffer: Uint8Array, offset: number): number`

## 约束与限制
在下述版本验证通过：

- DevEco Studio 版本：4.1 Canary(4.1.3.317)，OpenHarmony SDK:API11 (4.1.0.36)

## 目录结构
````
|---- protobufjs_utf8
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
使用过程中发现任何问题都可以提 [Issue](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/issues) 给我们，当然，我们也非常欢迎你给我们发 [PR](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/pulls) 。

## 开源协议
本项目基于 [BSD License](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/blob/master/protobufjs_utf8/LICENSE) ，请自由地享受和参与开源。

