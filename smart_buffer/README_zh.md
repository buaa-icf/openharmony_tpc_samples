# smart-buffer

## 简介

smart-buffer 是一个 Buffer 包装器，它添加了自动读写偏移量跟踪、字符串操作、数据插入等功能。

## 下载安装

```shell
ohpm install @ohos/smart-buffer 
```

OpenHarmony ohpm环境配置等更多内容，请参考 [如何安装OpenHarmony har包](https://gitee.com/openharmony-tpc/docs/blob/master/OpenHarmony_har_usage.md) 。

## 使用说明

1.简单使用
```
import { SmartBuffer, SmartBufferOptions } from '@ohos/smart_buffer
    let packet = new SmartBuffer();
    packet.writeUInt16LE(0x0060);
    packet.writeStringNT(username);
    packet.writeStringNT(password);
    packet.writeUInt8(age);
    packet.writeStringNT(country);
    packet.insertUInt16LE(packet.length - 2, 2);
```

2.创建SmartBuffer 对象
```
let buff = SmartBuffer.fromBuffer(buffer);
let buff = SmartBuffer.fromBuffer(buffer, 'ascii'); 

let buff = SmartBuffer.fromSize(1024); 
let buff = SmartBuffer.fromSize(1024, 'utf8');

let buff = SmartBuffer.fromOptions({
    size: 1024,
    encoding: 'ascii'
});
let buff = SmartBuffer.fromOptions({
    buff: buffer
});
let buff = SmartBuffer.fromBuffer(Buffer.from('some string', 'utf8'));
let buff = new SmartBuffer();
```

3.在SmartBuffer 中写入和插入数据
```
let buff = SmartBuffer.fromBuffer(new Buffer([1,2,3,4,5,6]));
buff.writeInt8(7, 2);

let buff = SmartBuffer.fromBuffer(new Buffer([1,2,3,4,5,6]));
buff.insertInt8(7, 2);
```

## 接口说明
| 接口名       | 参数                                                                                      | 返回值                                                     | 说明                                                    |
| --------- |-----------------------------------------------------------------------------------------|---------------------------------------------------------|-------------------------------------------------------|
| fromBuffer   | buff: Buffer.Buffer, encoding?: Buffer.BufferEncoding                                   | SmartBuffer                                             | 使用提供的缓冲区（Buffer）和可选的编码方式，创建一个新的智能缓冲区（SmartBuffer）实例   |
| fromSize   | size: number, encoding?: Buffer.BufferEncoding                                          | SmartBuffer                                             | 使用提供的内部缓冲区大小和可选的编码来创建一个新的SmartBuffer实例                |
| fromOptions | options: SmartBufferOptions                                                             | SmartBuffer                                             | 使用提供的 SmartBufferOptions 选项创建一个新的 SmartBuffer 实例/失败回调 |
| readInt8 | offset?: number                                                                         | number                                                  | 从当前的读取位置或可选提供的偏移量中读取一个Int8值           |                
| readInt16BE | offset?: number                                                                         | number                                                  | 从当前读取位置或可选提供的偏移量中读取一个 Int16BE（大端序的16位整数）值             
| readInt16LE | offset?: number                                                                         | number                                                  | 从当前读取位置或可选提供的偏移量中读取一个 Int16LE（小端序的16位整数）值             
| readInt32BE | offset?: number                                                                         | number                                                  | 从当前读取位置或可选提供的偏移量中读取一个 Int32BE（大端序的32位整数）值             
| readInt32LE | offset?: number                                                                         | number                                                  | 从当前读取位置或可选提供的偏移量中读取一个 Int32LE（小端序的32位整数）值             
| readBigInt64BE | offset?: number                                                                         | bigint                                                  | 从当前读取位置或可选提供的偏移量中读取一个 BigInt64BE（大端序的64位大整数）值         
| readBigInt64LE | offset?: number                                                                         | bigint                                                  | 从当前读取位置或可选提供的偏移量中读取一个 BigInt64LE（小端序的64位大整数）值。        
| writeInt8 | value: number, offset?: number                                                          | SmartBuffer                                             | 将一个 Int8（8位整数）值写入当前写入位置（或在可选的偏移量处）。                   
| insertInt8 | value: number, offset: number                                                           | SmartBuffer                                             | 在给定的偏移量位置插入一个 Int8（8位整数）值                             
| writeInt16BE | value: number, offset?: number                                                          | SmartBuffer                                             | 将一个 Int16BE（大端序的16位整数）值写入到当前写入位置（或在可选提供的偏移量处）。        
| insertInt16BE | value: number, offset: number                                                           | SmartBuffer                                             | 在给定的偏移量位置插入一个 Int16BE（大端序的16位整数）值。                    
| writeInt16LE | value: number, offset?: number                                                          | SmartBuffer                                             | 将一个 Int16LE（小端序的16位整数）值写入当前写入位置（或在可选提供的偏移量处）          
| insertInt16LE | value: number, offset: number                                                           | SmartBuffer                                             | 在给定的偏移量位置插入一个 Int16LE（小端序的16位整数）值值                    
| writeInt32BE | value: number, offset?: number                                                          | SmartBuffer                                             | 在处理文件或数据流时，Int32BE 指的是以“大端字节序”（Big-Endian）方式表示的一个32位整数。                         
| insertInt32BE | value: number, offset: number                                                           | SmartBuffer                                             | 在给定的偏移值处插入一个Int32BE值                         
| writeInt32LE | value: number, offset?: number                                                          | SmartBuffer                                             | 将一个Int32LE值写入当前写入位置                          
| insertInt32LE | value: number, offset: number                                                           | SmartBuffer                                             | 在给定的偏移值处插入一个Int32LE值                          
| writeBigInt64BE | value: bigint, offset?: number                                                          | SmartBuffer                                             | 将一个BigInt64BE值写入当前写入位置                          
| insertBigInt64BE | value: bigint, offset: number                                                           | SmartBuffer                                             | 在给定的偏移值处插入一个BigInt64BE值                          
| writeBigInt64LE | value: bigint, offset?: number                                                          | number                                                  | 将一个BigInt64LE值写入当前写入位置                           
| insertBigInt64LE | value: bigint, offset: number                                                           | SmartBuffer                                             | 在给定的偏移值处插入一个Int64LE值                           
| readUInt8 | offset: number                                                                          | number                                                  | 从当前读取位置或可选提供的偏移量中读取一个UInt8值                         
| readUInt16BE | offset?: number                                                                         | number                                                  | 从当前读取位置或可选提供的偏移量中读取一个UInt16BE值                           
| readUInt16LE | offset?: number                                                                         | number                                                  | 从当前读取位置或可选提供的偏移量中读取一个UInt16LE值                          
| readUInt32BE | offset?: number                                                                         | number                                                  | 从当前读取位置或可选提供的偏移量中读取一个UInt32BE值                           
| readUInt32LE | offset?: number                                                                         | number                                                  | 从当前读取位置或可选提供的偏移量中读取一个UInt32LE值                          
| readBigUInt64BE | offset?: number                                                                         | bigint                                                  | 从当前读取位置或可选提供的偏移量中读取一个BigUInt64BE值                           
| readBigUInt64LE | offset?: number                                                                         | bigint                                                  | 从当前读取位置或可选提供的偏移量中读取一个BigUInt64LE值                           
| writeUInt8 | value: number, offset?: number                                                          | SmartBuffer                                             | 将一个UInt8值写入当前写入位置                          
| insertUInt8 | value: number, offset: number                                                           | SmartBuffer                                             | 在给定的偏移值处插入一个UInt8值                          
| writeUInt16BE | value: number, offset?: number                                                          | SmartBuffer                                             | 将一个UInt16BE值写入当前写入位置                          
| insertUInt16BE | value: number, offset: number                                                           | SmartBuffer                                             | 在给定的偏移值处插入一个UInt16BE值                           
| writeUInt16LE | value: number, offset?: number                                                          | SmartBuffer                                             | 将一个UInt16LE值写入当前写入位置                           
| insertUInt16LE | value: number, offset: number                                                           | SmartBuffer                                             | 在给定的偏移值处插入一个UInt16LE值                          
| writeUInt32BE | value: number, offset?: number                                                          | SmartBuffer                                             | 将一个UInt32BE值写入当前写入位置                           
| insertUInt32BE | value: number, offset: number                                                           | SmartBuffer                                             | 在给定的偏移值处插入一个UInt32BE值                           
| writeUInt32LE | value: number, offset?: number                                                          | SmartBuffer                                             | 将一个UInt32LE值写入当前写入位置                          
| insertUInt32LE | value: number, offset: number                                                           | SmartBuffer                                             | 在给定的偏移值处插入一个UInt32LE值                          
| writeBigUInt64BE | value: bigint, offset?: number                                                          | SmartBuffer                                             | 将一个BigUInt64BE值写入当前写入位置                           
| insertBigUInt64BE | value: bigint, offset: number                                                           | SmartBuffer                                             | 在给定的偏移值处插入一个BigUInt64BE值                           
| writeBigUInt64LE | value: bigint, offset?: number                                                          | SmartBuffer                                             | 将一个BigUInt64LE值写入当前写入位置                           
| insertBigUInt64LE | value: bigint, offset: number                                                           | SmartBuffer                                             | 在给定的偏移值处插入一个BigUInt64LE值                          
| readFloatBE | offset?: number                                                                         | number                                                  | 从当前读取位置或可选提供的偏移量中读取一个FloatBE值                           
| readFloatLE | offset: number                                                                          | number                                                  | 从当前读取位置或可选提供的偏移量中读取一个FloatLE值                          
| writeFloatBE | value: number, offset?: number                                                          | SmartBuffer                                             | 将一个FloatBE值写入当前写入位置                          
| insertFloatBE | value: number, offset: number                                                           | SmartBuffer                                             | 在给定的偏移值处插入一个FloatBE值                           
| writeFloatLE | value: number, offset?: number                                                          | SmartBuffer                                             | 将一个FloatLE值写入当前写入位置                         
| insertFloatLE | value: number, offset: number                                                           | SmartBuffer                                             | 在给定的偏移值处插入一个FloatLE值                           
| readDoubleBE | offset?: number                                                                         | number                                                  | 从当前读取位置或可选提供的偏移量中读取一个DoubleBE值                         
| readDoubleLE | offset: number                                                                          | number                                                  | 从当前读取位置或可选提供的偏移量中读取一个DoubleLE值                          
| writeDoubleBE | value: number, offset?: number                                                          | SmartBuffer                                             | 将一个DoubleBE值写入当前写入位置                         
| insertDoubleBE | value: number, offset: number                                                           | SmartBuffer                                             | 在给定的偏移值处插入一个DoubleBE值                          
| writeDoubleLE | value: number, offset?: number                                                          | SmartBuffer                                             | 将一个DoubleLE值写入当前写入位置                          
| insertDoubleLE | value: number, offset: number                                                           | SmartBuffer                                             | 在给定的偏移值处插入一个DoubleLE值                           
| readString | arg1?: number   / Buffer.BufferEncoding, encoding?: Buffer.BufferEncoding               | string                                                |从当前读取位置读取一个字符串           
| insertString | value: string, offset: number, encoding?: Buffer.BufferEncoding                         | SmartBuffer                                             | 插入一个字符串                           
| writeString | value: string, arg2?: number / Buffer.BufferEncoding, encoding?: Buffer.BufferEncoding  | SmartBuffer                                           | 写入一个字符串                          
| readStringNT | encoding?: Buffer.BufferEncoding                                                        | string                                                  | 从当前读取位置读取一个以空字符终止的字符串                         
| insertStringNT | value: string, offset: number, encoding?: Buffer.BufferEncoding                         | SmartBuffer                                             | 插入一个以空字符终止的字符串                          
| writeStringNT | value: string, arg2?: number  / Buffer.BufferEncoding, encoding?: Buffer.BufferEncoding | SmartBuffer                                           | 写入一个以空字符终止的字符串                           
| readBuffer | length?: number                                                                         | Buffer.Buffer                                           | 从内部读取位置读取一个缓冲区                          
| insertBuffer | value: Buffer.Buffer, offset: number                                                    | SmartBuffer                                             | 将一个缓冲区插入当前写入位置                          
| writeBuffer | value: Buffer.Buffer, offset?: number                                                   | SmartBuffer                                             | 将一个缓冲区写入当前写入位置                           
| readBufferNT | 无                                                                                       | Buffer.Buffer                                           | 从当前读取位置读取一个以空字符终止的缓冲区                           
| insertBufferNT | value: Buffer.Buffer, offset: number                                                    | SmartBuffer                                             | 插入一个以空字符终止的缓冲区                          
| writeBufferNT | value: Buffer.Buffer, offset?: number                                                   | SmartBuffer                                             | 写入一个以空字符终止的缓冲区                           
| clear | 无                                                                                       | SmartBuffer                                             | 将SmartBuffer实例清除到其原始空状态                           
| remaining | 无                                                                                       | number                                                  | 从SmartBuffer实例中获取剩余待读取的数据                           
| readOffset | 无                                                                                       | number                                                  | 获取SmartBuffer实例的当前读取偏移量值                           
| readOffset | offset: number                                                                          | void                                                    | 设置SmartBuffer实例的读取偏移量值                           
| writeOffset | 无                                                                                       | number                                                  |获取SmartBuffer实例的当前写入偏移量值                           
| writeOffset | offset: number                                                                          | void                                                    | 设置SmartBuffer实例的写入偏移量值                           
| encoding | 无                                                                                       | Buffer.BufferEncoding                                   | 获取SmartBuffer实例当前设置的字符串编码                          
| encoding | encoding: Buffer.BufferEncoding                                                         | void                                                    | 设置SmartBuffer实例的字符串编码                           
| internalBuffer | 无                                                                                       | Buffer.Buffer                                           | 获取底层的内部缓冲区                           
| toBuffer | 无                                                                                       | Buffer.Buffer                                           | 获取内部托管缓冲区的值                           
| toString | encoding?: Buffer.BufferEncoding                                                        | string                                                  | 获取内部托管缓冲区的字符串值                           
| destroy | 无                                                                                       | SmartBuffer                                             | 销毁SmartBuffer实例                           


## 约束与限制

- DevEco Studio 版本： 5.0.3.300SP2

- OpenHarmony SDK:API12 (5.0.0.22)

## 目录结构

````
|---- smart_buffer
|     |---- entry  # 示例代码文件夹
|     |---- buffer  # fastble库文件夹
|	    |----src
          |----main
              |----ets
                  |----smartbuffer.ts #核心逻辑
                  |----utils.ts #工具类
|           |---- index.ets  # 对外接口
|     |---- README.md  # 安装使用方法                    
````

## 贡献代码

使用过程中发现任何问题都可以提 [Issue](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/issues) 给组件，当然，也非常欢迎给发[PR](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/pulls)共建 。

## 开源协议

本项目基于 [MIT LICENSE](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/smart_buffer/blob/master/LICENSE) ，请自由地享受和参与开源。
