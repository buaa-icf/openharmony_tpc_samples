# buffer

## Introduction

>This project provides the same APIs as Node.js buffer.

## How to Install

```shell
ohpm  install buffer@6.0.3
```

For details about the OpenHarmony ohpm environment configuration, see [OpenHarmony HAR](https://gitee.com/openharmony-tpc/docs/blob/master/OpenHarmony_har_usage.en.md).

## How to Use


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

## Available APIs

| API       | Parameter                                                        | Description                                                    |
| --------------- | ------------------------------------------------------------ | ------------------------------------------------------------ |
| write()         | string, offset?, length?, encoding?                          | Writes a string to the buffer.                                |
| toString()      | encoding?, start?, end?                                      | Returns a decoded string based on the encoding parameter (**'utf8'** by default).|
| toJSON()        | N/A                                                          | Converts a buffer instance into a JSON object.                                  |
| equals()        | otherBuffer                                                  | Checks whether two buffers are equal.                                      |
| compare()       | otherBuffer, targetStart?, targetEnd?, sourceStart?, sourceEnd? | Compares two buffer objects (**buf** and **otherBuffer**) and returns a number, indicating that **buf** is before, after, or the same as **otherBuffer**.|
| copy()          | targetBuffer, targetStart?, sourceStart?, sourceEnd?         | Copies a buffer.                                                  |
| slice()         | start?, end?                                                 | Slices a buffer.                                             |
| readUIntLE()    | offset, byteLength, noAssert?                                | Reads a 48-bit (or less) unsigned number in little-endian format.                    |
| readUIntBE()    | offset, byteLength, noAssert?                                | Reads a 48-bit (or less) unsigned number in big-endian format.                    |
| readIntLE()     | offset, byteLength, noAssert?                                | Reads a 48-bit (or less) signed number in little-endian format.                    |
| readIntBE()     | offset, byteLength, noAssert?                                | Reads a 48-bit (or less) signed number in big-endian format.                    |
| readUInt8()     | offset, noAssert?                                            | Reads an 8-bit unsigned integer based on the specified offset.                   |
| writeInt8()     | value, offset, noAssert?                                     | Writes an 8-bit signed integer to the buffer based on the specified offset.|
| readInt8()      | offset, noAssert?                                            | Reads an 8-bit signed integer based on the specified offset.                   |
| swap16()        | N/A                                                          | Interprets the buffer as an array of 16-bit unsigned integers and swaps the byte order in place.      |
| swap32()        | N/A                                                          | Interprets the buffer as an array of 32-bit unsigned integers and swaps the byte order in place.      |
| swap64()        | N/A                                                          | Interprets the buffer as an array of 64-bit unsigned integers and swaps the byte order in place.      |
| writeUInt8()    | value, offset, noAssert?                                     | Writes an 8-bit unsigned integer to the buffer based on the specified offset.|
| writeUInt16LE() | value, offset, noAssert?                                     | Writes a 16-bit unsigned integer to the buffer based on the specified offset and endian format.|
| writeUInt32LE() | value, offset, noAssert?                                     | Writes a 32-bit unsigned integer to the buffer based on the specified offset and endian format.|
| writeUInt32BE() | value, offset, noAssert?                                     | Writes a 32-bit unsigned integer to the buffer based on the specified offset and endian format.|
| writeDoubleLE() | value, offset, noAssert?                                     | Writes a value in a given byte order format to the buffer based on the specified offset.              |
| fill()          | value, offset?, end?                                         | Fills the buffer with a value.                                        |
| indexOf()       | value, byteOffset?, encoding?                                | Checks whether a value exists in the buffer and returns the position.                        |
| lastIndexOf()   | value, byteOffset?, encoding?                                | Checks whether a value exists in the buffer and returns the position.                        |
| includes()      | value, byteOffset?, encoding?                                | Checks whether the buffer contains a value.                                |


## Constraints

This project has been verified in the following version:

- DevEco Studio: 4.1 Canary (4.1.3.317), OpenHarmony SDK: API 11 (4.1.0.36)

## Directory Structure

````
|---- buffer
|     |---- entry  # Sample code
              ├── src  
                 ├── main   
                   ├── ets
                       ├── pages
                             ├── Index.ets  # Sample code
|     |---- README.md  # Readme                   
````

## How to Contribute

If you find any problem when using the project, submit an [issue](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/issues) or a [PR](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/pulls).

## License

This project is licensed under [MIT License](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/blob/master/buffer/LICENSE).
