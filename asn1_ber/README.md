# asn1_ber

## Introduction

asn1_ber is provide the ability to generate and parse ASN.1 BER objects.

## How to Install

```shell
ohpm install @ohos/asn1-ber
```

For details, see [Installing an OpenHarmony HAR](https://gitee.com/openharmony-tpc/docs/blob/master/OpenHarmony_har_usage.en.md).

## How to Use

1.simple use
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

## Available APIs
1. BerWriter

| interface name   | parameter             | return | explanation                                            |
|------------------|-------------------|--------|-----------------------------------------------|
| writeByte        | data:number       | void   | Write a single byte                                        |
| writeInt         | data: number      | void   | Write a signed or unsigned integer                                 |
| writeBoolean     | bool:boolean      | void   | Write a boolean value                                  |
| writeString      | str:string        | void   | Write a string                                     |                
| writeBuffer      | buffer: Buffer    | void   | Write a buffer                                    |  
| writeStringArray | strArray:string[] | void   | Write an array of strings                                 |     
| startSequence    | 无                 | void   | Start a new sequence    
| endSequence      | 无                 | void   | End the started new sequence (to be used in conjunction with startSequence)    
| writeOID         | oid: string       | void   | Insert an object identifier 

1. BerReader

| interface name       | parameter           | return         | explanation                                                    |
| --------- |--------------|-------------|-------------------------------------------------------|
| readByte   | peek:boolean | number      | Read and return the next byte from the input buffer. If the peek parameter is passed as true, the read offset will not be incremented        |
| readInt   | 无            | number      | Read a signed or unsigned integer                |
| readBoolean | 无            | boolean     | Read a boolean value from the input buffer|
| readEnumeration | 无            | number      | Read an integer value of an enumerated type                          |                
| readString | 无            | sting       | Read a string from the input buffer            
| readSequence | 无            | number      | Read a sequence from the input buffer              
| readBitString | 无            | string/null |Read a long string from the input buffer         
| readOID | 无            | string/null     | Read an object identifier in dotted decimal notation.            


## Constraints

- DevEco Studio ： 5.0.3.300SP2

- OpenHarmony SDK:API12 (5.0.0.22)

## Directory Structure

````
|---- asn1_ber
|     |---- entry  # sample code
|     |---- asn1ber  # library
|	    |----src
          |----main
              |----ets
                  |----ber
                      |----error.js # Error
                      |----index.js # interface export 
                      |----reader.js # It provides a series of methods to read data of specific types.
                      |----wirter.js # It provides a series of methods for writing different types of BER (Basic Encoding Rules) data.
                      |----types.js # ASN1.ber  type
|           |---- index.ets  # external Interface
|     |---- README.md  # readme                  
````

## How to Contribute

If you find any problem during the use, submit an [issue](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/issues) or a [PR](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/pulls) to us.


## License

This project is licensed under [MIT LICENSE](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/blob/master/LICENSE).
Welcome to enjoy and participate in the open source.