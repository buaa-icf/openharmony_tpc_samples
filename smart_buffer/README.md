# smart-buffer

## Introduction

smart-buffer s a Buffer wrapper that adds functionalities such as automatic read/write offset tracking, string manipulation, data insertion, and more.

## How to Install

```shell
ohpm install @ohos/smart-buffer 
```

For details, see [Installing an OpenHarmony HAR](https://gitcode.com/openharmony-tpc/docs/blob/master/OpenHarmony_har_usage.en.md).

## How to Use

1.simple use
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

2.creat SmartBuffer object
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

3.Writing and inserting data in SmartBuffer.
```
let buff = SmartBuffer.fromBuffer(new Buffer([1,2,3,4,5,6]));
buff.writeInt8(7, 2);

let buff = SmartBuffer.fromBuffer(new Buffer([1,2,3,4,5,6]));
buff.insertInt8(7, 2);
```

## Available APIs
| interface name   | parameter                                                                                      | return              | explanation                                             |
|------------------|-----------------------------------------------------------------------------------------|---------------------|---------------------------------------------------------|
| fromBuffer       | buff: Buffer.Buffer, encoding?: Buffer.BufferEncoding                                   | SmartBuffer         | Using the provided buffer (Buffer) and optional encoding, create a new SmartBuffer instance     |
| fromSize         | size: number, encoding?: Buffer.BufferEncoding                                          | SmartBuffer         | Create a new SmartBuffer instance using the provided internal buffer size and optional encoding                  |
| fromOptions      | options: SmartBufferOptions                                                             | SmartBuffer         | Create a new SmartBuffer instance using the provided SmartBufferOptions or a failure callback   |
| readInt8         | offset?: number                                                                         | number              | Read an Int8 value from the current read position or an optionally provided offset.                             |                
| readInt16BE      | offset?: number                                                                         | number              | Read an Int16BE (16-bit integer in big-endian order) value from the current read position or an optionally provided offset.               
| readInt16LE      | offset?: number                                                                         | number              | Read an Int16LE (16-bit integer in little-endian order) value from the current read position or an optionally provided offset.               
| readInt32BE      | offset?: number                                                                         | number              | Read an Int32BE (32-bit integer in big-endian order) value from the current read position or an optionally provided offset.               
| readInt32LE      | offset?: number                                                                         | number              | Read an Int32LE (32-bit integer in little-endian order) value from the current read position or an optionally provided offset.               
| readBigInt64BE   | offset?: number                                                                         | bigint              | Read a BigInt64BE (64-bit big integer in big-endian order) value from the current read position or an optionally provided offset.           
| readBigInt64LE   | offset?: number                                                                         | bigint              | Read a BigInt64LE (64-bit big integer in little-endian order) value from the current read position or an optionally provided offset.          
| writeInt8        | value: number, offset?: number                                                          | SmartBuffer         | Write an Int8 (8-bit integer) value to the current write position (or at an optional offset).                     
| insertInt8       | value: number, offset: number                                                           | SmartBuffer         | Insert an Int8 (8-bit integer) value at a given offset position.                               
| writeInt16BE     | value: number, offset?: number                                                          | SmartBuffer         | Write an Int16BE (16-bit integer in big-endian order) value to the current write position (or at an optional offset).          
| insertInt16BE    | value: number, offset: number                                                           | SmartBuffer         | nsert an Int16BE (16-bit integer in big-endian order) value at a given offset position.                      
| writeInt16LE     | value: number, offset?: number                                                          | SmartBuffer         | Write an Int16LE (16-bit integer in little-endian order) value to the current write position (or at an optional offset).            
| insertInt16LE    | value: number, offset: number                                                           | SmartBuffer         | Insert an Int16LE (16-bit integer in little-endian order) value at a given offset position.                   
| writeInt32BE     | value: number, offset?: number                                                          | SmartBuffer         | When dealing with files or data streams, Int32BE refers to a 32-bit integer represented in "big-endian byte order" 
| insertInt32BE    | value: number, offset: number                                                           | SmartBuffer         | Insert an Int32BE value at a given offset position.                                   
| writeInt32LE     | value: number, offset?: number                                                          | SmartBuffer         | Write an Int32LE value to the current write position.                                     
| insertInt32LE    | value: number, offset: number                                                           | SmartBuffer         | Insert an Int32LE value at a given offset position.                                    
| writeBigInt64BE  | value: bigint, offset?: number                                                          | SmartBuffer         | Write a BigInt64BE value to the current write position.                                
| insertBigInt64BE | value: bigint, offset: number                                                           | SmartBuffer         | Insert a BigInt64BE value at a given offset position.                               
| writeBigInt64LE  | value: bigint, offset?: number                                                          | number              | Write a BigInt64LE value to the current write position.                                  
| insertBigInt64LE | value: bigint, offset: number                                                           | SmartBuffer         | insert a BigInt64LE valueat a given offset position.                                   
| readUInt8        | offset: number                                                                          | number              | Read a UInt8 value from the current read position or an optionally provided offset.                             
| readUInt16BE     | offset?: number                                                                         | number              | Read a UInt16BE value from the current read position or an optionally provided offset.                        
| readUInt16LE     | offset?: number                                                                         | number              | Read a UInt16LE value from the current read position or an optionally provided offset.                     
| readUInt32BE     | offset?: number                                                                         | number              | Read a UInt32BE value from the current read position or an optionally provided offset.                         
| readUInt32LE     | offset?: number                                                                         | number              | Read a UInt32LE value from the current read position or an optionally provided offset.                          
| readBigUInt64BE  | offset?: number                                                                         | bigint              | Read a BigUInt64BE value from the current read position or an optionally provided offset.                      
| readBigUInt64LE  | offset?: number                                                                         | bigint              | Read a BigUInt64LE value from the current read position or an optionally provided offset.                       
| writeUInt8       | value: number, offset?: number                                                          | SmartBuffer         | Write a UInt8 value to the current write position.                                      
| insertUInt8      | value: number, offset: number                                                           | SmartBuffer         | Insert a UInt8 value at a given offset position.                                     
| writeUInt16BE    | value: number, offset?: number                                                          | SmartBuffer         | Write a UInt16BE value to the current write position.                                    
| insertUInt16BE   | value: number, offset: number                                                           | SmartBuffer         | Insert a UInt16BE value at a given offset position.                                  
| writeUInt16LE    | value: number, offset?: number                                                          | SmartBuffer         | Write a UInt16LE value to the current write position.                                   
| insertUInt16LE   | value: number, offset: number                                                           | SmartBuffer         | Insert a UInt16LE value at a given offset position.                                 
| writeUInt32BE    | value: number, offset?: number                                                          | SmartBuffer         | Write a UInt32BE value to the current write position.                                   
| insertUInt32BE   | value: number, offset: number                                                           | SmartBuffer         | Insert a UInt32BE value at a given offset position.                                   
| writeUInt32LE    | value: number, offset?: number                                                          | SmartBuffer         | Write a UInt32LE value to the current write position.                                    
| insertUInt32LE   | value: number, offset: number                                                           | SmartBuffer         | Insert a UInt32LE value at a given offset position.                                  
| writeBigUInt64BE | value: bigint, offset?: number                                                          | SmartBuffer         | Write a BigUInt64BE value to the current write position.                               
| insertBigUInt64BE | value: bigint, offset: number                                                           | SmartBuffer        | Insert a BigUInt64BE value at a specified offset                                
| writeBigUInt64LE | value: bigint, offset?: number                                                          | SmartBuffer         | Write a BigUInt64LE value at the current write position                                 
| insertBigUInt64LE | value: bigint, offset: number                                                           | SmartBuffer        | Insert a BigUInt64LE value at a specified offset                                
| readFloatBE      | offset?: number                                                                         | number              | Read a FloatBE value from the current read position or an optional offset                           
| readFloatLE      | offset: number                                                                          | number              | Read a FloatLE value from the current read position or an optional offset                           
| writeFloatBE     | value: number, offset?: number                                                          | SmartBuffer         | Write a FloatBE value at the current write position                                     
| insertFloatBE    | value: number, offset: number                                                           | SmartBuffer         | Insert a FloatBE value at a specified offset                                 
| writeFloatLE     | value: number, offset?: number                                                          | SmartBuffer         | Write a FloatLE value at the current write position                                  
| insertFloatLE    | value: number, offset: number                                                           | SmartBuffer         | Insert a FloatLE value at a specified offset                                   
| readDoubleBE     | offset?: number                                                                         | number              | Read a DoubleBE value from the current read position or an optional offset                        
| readDoubleLE     | offset: number                                                                          | number              | Read a DoubleLE value from the current read position or an optional offset                         
| writeDoubleBE    | value: number, offset?: number                                                          | SmartBuffer         | Write a DoubleBE value at the current write position                                    
| insertDoubleBE   | value: number, offset: number                                                           | SmartBuffer         | Insert a DoubleBE value at a specified offset                                  
| writeDoubleLE    | value: number, offset?: number                                                          | SmartBuffer         | Write a DoubleLE value at the current write position                                   
| insertDoubleLE   | value: number, offset: number                                                           | SmartBuffer         | Insert a DoubleLE value at a specified offset                                  
| readString       | arg1?: number   / Buffer.BufferEncoding, encoding?: Buffer.BufferEncoding               | string              | Read a string from the current read position                                      
| insertString     | value: string, offset: number, encoding?: Buffer.BufferEncoding                         | SmartBuffer         | Insert a string                                                 
| writeString      | value: string, arg2?: number / Buffer.BufferEncoding, encoding?: Buffer.BufferEncoding  | SmartBuffer         | Write a string                                                
| readStringNT     | encoding?: Buffer.BufferEncoding                                                        | string              | Read a null-terminated string from the current read position                                   
| insertStringNT   | value: string, offset: number, encoding?: Buffer.BufferEncoding                         | SmartBuffer         | Insert a null-terminated string                                         
| writeStringNT    | value: string, arg2?: number  / Buffer.BufferEncoding, encoding?: Buffer.BufferEncoding | SmartBuffer         | Write a null-terminated string                                        
| readBuffer       | length?: number                                                                         | Buffer.Buffer       | Read a buffer from the current read position within the internal buffer                                       
| insertBuffer     | value: Buffer.Buffer, offset: number                                                    | SmartBuffer         | Insert a buffer at the current write position                                        
| writeBuffer      | value: Buffer.Buffer, offset?: number                                                   | SmartBuffer         | Write a buffer at the current write position                                        
| readBufferNT     | None                                                                                       | Buffer.Buffer    | Read a null-terminated buffer from the current read position                                   
| insertBufferNT   | value: Buffer.Buffer, offset: number                                                    | SmartBuffer         | Insert a null-terminated buffer                                          
| writeBufferNT    | value: Buffer.Buffer, offset?: number                                                   | SmartBuffer         | Write a null-terminated buffer                                          
| clear            | None                                                                                       | SmartBuffer      | Clear the SmartBuffer instance to its original empty state                                
| remaining        | None                                                                                       | number           | Retrieve the remaining data to be read from the SmartBuffer instance                               
| readOffset       | None                                                                                       | number           | Get the current read offset value of the SmartBuffer instance                               
| readOffset       | offset: number                                                                          | void                | Set the read offset value of the SmartBuffer instance                                  
| writeOffset      | None                                                                                       | number              | Get the current write offset value of the SmartBuffer instance                                
| writeOffset      | offset: number                                                                          | void                | Set the write offset value of the SmartBuffer instance                                  
| encoding         | None                                                                                       | Buffer.BufferEncoding | Get the currently set string encoding for the SmartBuffer instance                             
| encoding         | encoding: Buffer.BufferEncoding                                                         | void                | Set the string encoding for the SmartBuffer instance                                   
| internalBuffer   | None                                                                                       | Buffer.Buffer       | Retrieve the underlying internal buffer                                            
| toBuffer         | None                                                                                       | Buffer.Buffer       | Get the value of the internally managed buffer                                            
| toString         | encoding?: Buffer.BufferEncoding                                                        | string              | Get the string value of the internally managed buffer                                        
| destroy          | None                                                                                       | SmartBuffer         | Destroy the SmartBuffer instance                                        


## Constraints

- DevEco Studio ： 5.0.3.300SP2

- OpenHarmony SDK:API12 (5.0.0.22)

## Directory Structure

````
|---- smart_buffer
|     |---- entry  # Sample code
|     |---- buffer  # lib
|	    |----src
          |----main
              |----ets
                  |----smartbuffer.ts #core logic
                  |----utils.ts #utils
|           |---- index.ets  # external Interface
|     |---- README.md  # Readme                 
````


## About obfuscation
- Code obfuscation, please see[Code Obfuscation](https://docs.openharmony.cn/pages/v5.0/zh-cn/application-dev/arkts-utils/source-obfuscation.md)
- If you want the smart_buffer library not to be obfuscated during code obfuscation, you need to add corresponding exclusion rules in the obfuscation rule configuration file obfuscation-rules.txt：

```
-keep
./oh_modules/@ohos/smart_buffer
```

## How to Contribute

If you find any problem during the use, submit an [issue](https://gitcode.com/openharmony-tpc/openharmony_tpc_samples/issues) or a [PR](https://gitcode.com/openharmony-tpc/openharmony_tpc_samples/pulls) to us.


## License

This project is licensed under [MIT LICENSE](https://gitcode.com/openharmony-tpc/openharmony_tpc_samples/blob/master/smart_buffer/LICENSE).
Welcome to enjoy and participate in the open source.