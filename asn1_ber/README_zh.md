# asn1_ber

## 简介

asn1_ber 提供生成和解析ASN1.BER对象的能力。

## 下载安装

```shell
ohpm install @ohos/asn1-ber
```

OpenHarmony ohpm环境配置等更多内容，请参考 [如何安装OpenHarmony har包](https://gitcode.com/openharmony-tpc/docs/blob/master/OpenHarmony_har_usage.md) 。

## 使用说明

1.简单使用
```
import { BerWriter,BerReader } from '@ohos/asn1_ber'
	let writer = new BerWriter()

	writer.startSequence()
	writer.writeBoolean(true)
	writer.writeBoolean(false)
	writer.endSequence()
	var buffer = writer.buffer

	var reader = new BerReader(buffer)
	reader.readSequence()
	reader.readBoolean()
	reader.readBoolean()

```

## 接口说明
1. BerWriter

| 接口名       | 参数               | 返回值  | 说明                                            |
| --------- |------------------|------|-----------------------------------------------|
| writeByte   | data:number      | void | 写入单个字节                                        |
| writeInt   | data: number     | void | 写入一个有符号或无符号整数                                 |
| writeBoolean | bool:boolean     | void | 写入一个boolean值                                  |
| writeString | str:string       | void | 写入一个字符串                                       |                
| writeBuffer | buffer: Buffer   | void | 写入一个Buffer                                    |  
| writeStringArray | strArray:string[] | void | 写入一个字符串数组                                     |     
| startSequence | 无                | void | 开始一个新的序列     
| endSequence | 无                | void | 结束开始的新的序列 ，和startSequence 搭配使用    
| writeOID | oid: string      | void | 写入一个对象标识符 

1. BerReader

| 接口名       | 参数           | 返回值         | 说明                                                    |
| --------- |--------------|-------------|-------------------------------------------------------|
| readByte   | peek:boolean | number      | 从输入缓冲区读取并返回下一个字节，  peek参数被传递为true，则读取偏移量将不会增加。        |
| readInt   | 无            | number      | 读取一个有符号或无符号整数                |
| readBoolean | 无            | boolean     | 从输入缓冲区读取一个布尔值 |
| readEnumeration | 无            | number      | 读取枚举类型的整数值                           |                
| readString | 无            | sting       | 从输入缓冲区读取一个字符串            
| readSequence | 无            | number      | 从输入缓冲区读取一个序列              
| readBitString | 无            | string/null |从输入缓冲区读取一个长字符串          
| readOID | 无            | string/null     | 读取一个对象标识符并以点分十进制格式             


## 关于混淆
- 代码混淆，请查看[代码混淆简介](https://docs.openharmony.cn/pages/v5.0/zh-cn/application-dev/arkts-utils/source-obfuscation.md)
- 如果希望asn1-ber库在代码混淆过程中不会被混淆，需要在混淆规则配置文件obfuscation-rules.txt中添加相应的排除规则：
```
-keep
./oh_modules/@ohos/asn1-ber
```

## 约束与限制

- DevEco Studio 版本： 5.0.3.300SP2

- OpenHarmony SDK:API12 (5.0.0.22)

## 目录结构

````
|---- asn1_ber
|     |---- entry  # 示例代码文件夹
|     |---- asn1ber  # fastble库文件夹
|	    |----src
          |----main
              |----ets
                  |----ber
                      |----error.js # 定义Error
                      |----index.js # 导出文件
                      |----reader.js # 提供了一系列方法来读取特定类型的数据
                      |----writer.js # 提供了一系列方法来写入不同类型的 BER
                      |----types.js # 定义ASN1.ber  类型
|           |---- index.ets  # 对外接口
|     |---- README.md  # 安装使用方法                    
````

## 贡献代码

使用过程中发现任何问题都可以提 [Issue](https://gitcode.com/openharmony-tpc/openharmony_tpc_samples/issues) 给组件，当然，也非常欢迎给发[PR](https://gitcode.com/openharmony-tpc/openharmony_tpc_samples/pulls)共建 。


## 开源协议

本项目基于 [MIT LICENSE](https://gitcode.com/openharmony-tpc/openharmony_tpc_samples/blob/master/LICENSE) ，请自由地享受和参与开源。
