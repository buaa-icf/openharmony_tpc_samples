# buffer

## 简介

>提供一个与node的Buffer API 100%相同的API

## 下载安装

```shell
ohpm  install buffer@6.0.3
```

OpenHarmony ohpm 环境配置等更多内容，请参考 [如何安装OpenHarmony ohpm包](https://gitcode.com/openharmony-tpc/docs/blob/master/OpenHarmony_har_usage.md) 。

## 使用说明


```
import {Buffer} from 'buffer/'
/allocUnsafe,slice/
const b = Buffer.allocUnsafe(1024);
const sliceA = b.slice(offset, offset + asciiString.length);
const sliceB = b.slice(offset, offset + asciiString.length);
/byteLength,toString,write,from/
const b = Buffer.allocUnsafe(1024);
b.write(utf8String, 0, Buffer.byteLength(utf8String), 'utf8');
let utf8Slice = b.toString('utf8', 0, Buffer.byteLength(utf8String));
const d = Buffer.from([23, 42, 255]);
```

## 接口说明

| 使用方法            | 参数                                                              | 相关描述                                                                   |
|-----------------|-----------------------------------------------------------------|------------------------------------------------------------------------|
| write()         | string, offset?, length?, encoding?                             | 将参数 string 数据写入buffer                                                  |
| toString()      | encoding?, start?, end?                                         | 根据 encoding参数（默认是 'utf8'）返回一个解码过的 string 类型                            |
| toJSON()        | 无                                                               | 将Buffer实例转换为JSON对象                                                     |
| equals()        | otherBuffer                                                     | 比较两个缓冲区是否相等                                                            |
| compare()       | otherBuffer, targetStart?, targetEnd?, sourceStart?, sourceEnd? | 比较两个Buffer对象，返回一个数字，表示 buf 在 otherBuffer 之前，之后或相同。                     |
| copy()          | targetBuffer, targetStart?, sourceStart?, sourceEnd?            | buffer拷贝                                                               |
| slice()         | start?, end?                                                    | 剪切 Buffer对象                                                            |
| readUIntLE()    | offset, byteLength, noAssert?                                   | 支持读取 48 位以下的无符号数字，小端对齐                                                 |
| readUIntBE()    | offset, byteLength, noAssert?                                   | 支持读取 48 位以下的无符号数字，大端对齐                                                 |
| readIntLE()     | offset, byteLength, noAssert?                                   | 支持读取 48 位以下的有符号数字，小端对齐                                                 |
| readIntBE()     | offset, byteLength, noAssert?                                   | 支持读取 48 位以下的有符号数字，大端对齐                                                 |
| readUInt8()     | offset, noAssert?                                               | 根据指定的偏移量，读取一个无符号 8 位整数                                                 |
| writeInt8()     | value, offset, noAssert?                                        | 根据传入的offset偏移量将value写入buffer，value 必须是一个合法的无符号 8 位整数。                  |
| readInt8()      | offset, noAssert?                                               | 根据指定的偏移量，读取一个有符号 8 位整数                                                 |
| swap16()        | 无                                                               | 将 buffer 解释为无符号 16 位整数数组并就地交换字节顺序                                      |
| swap32()        | 无                                                               | 将 buffer 解释为无符号 32 位整数数组并就地交换字节顺序                                      |
| swap64()        | 无                                                               | 将 buffer 解释为无符号 64 位整数数组并就地交换字节顺序                                      |
| writeUInt8()    | value, offset, noAssert?                                        | 根据传入的 offset 偏移量将 value 写入 buffer，value 必须是一个合法的无符号 8 位整数              |
| writeUInt16LE() | value, offset, noAssert?                                        | 根据传入的 offset 偏移量和指定的 endian 格式将 value 写入 buffer，value 必须是一个合法的无符号16位整数 |
| writeUInt32LE() | value, offset, noAssert?                                        | 根据传入的 offset 偏移量和指定的 endian 格式将 value 写入 buffer，value 必须是一个合法的无符号32位整数 |
| writeUInt32BE() | value, offset, noAssert?                                        | 根据传入的 offset 偏移量和指定的 endian 格式将 value 写入 buffer，value 必须是一个合法的无符号32位整数 |
| writeDoubleLE() | value, offset, noAssert?                                        | 将值以指定的字节序格式以指定的偏移量写入缓冲区                                                |
| fill()          | value, offset?, end?                                            | 用指定的值填充缓冲区                                                             |
| indexOf()       | value, byteOffset?, encoding?                                   | 检查缓冲区中是否存在指定值并返回位置                                                     |
| lastIndexOf()   | value, byteOffset?, encoding?                                   | 检查缓冲区中是否存在指定值并返回位置                                                     |
| includes()      | value, byteOffset?, encoding?                                   | 检查缓冲区中是否包含指定的值                                                         |
 

## 约束与限制

在下述版本验证通过：

- DevEco Studio 版本： 4.1 Canary(4.1.3.317),OpenHarmony SDK:API11 (4.1.0.36)。

## 目录结构

````
|---- buffer
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

本项目基于 [MIT License](https://gitcode.com/openharmony-tpc/openharmony_tpc_samples/blob/master/buffer/LICENSE)
，请自由地享受和参与开源。
    