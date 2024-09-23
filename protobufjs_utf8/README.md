# @protobufjs/utf8

## Introduction
> @protobufjs/pool is a minimal UTF8 implementation for number arrays.

## How to Install
```shell
ohpm install @protobufjs/utf8
```
For details about the OpenHarmony ohpm environment configuration, see [OpenHarmony HAR](https://gitee.com/openharmony-tpc/docs/blob/master/OpenHarmony_har_usage.en.md).

## How to Use

### Importing and Using the Library
```
import utf8 from "@protobufjs/utf8"

// Calculate the UTF8 byte length of a string.
let uint8:Uint8Array
utf8.length(uint8.toString())

// Read UTF8 bytes as a string.
let uint8:Uint8Array
utf8.read(data, 0, data.byteLength);

// Write a string as UTF8 bytes.
let data:Uint8Array
let len = utf8.length(Utf8ArrayToStr(data));
let buf = buffer.alloc(len);
utf8.write(Utf8ArrayToStr(data),new Uint8Array(buf.buffer), 0)
```

## Available APIs
1. Calculates the UTF8 byte length of a string.
   `length(string: string): number`
2. Reads UTF8 bytes as a string.
   `read(buffer: Uint8Array, start: number, end: number): string`
3. Writes a string as UTF8 bytes.
   `write(string: string, buffer: Uint8Array, offset: number): number`

## Constraints
This project has been verified in the following versions:

- DevEco Studio: 4.1 Canary (4.1.3.317), OpenHarmony SDK: API 11 (4.1.0.36)

## Directory Structure
````
|---- protobufjs_utf8
|     |---- entry  # Sample code
|           |---- src
|                 |---- main
|                        |---- ets
|                              |---- pages
|                                    |---- Index # sample
|                 |---- ohosTest
|                       |---- ets
|                             |---- test
|                                   |---- Ability.test.ets  # Unit test

|     |---- README.md  # Readme
|     |---- README.OpenSource  # Open source description
|     |---- CHANGELOG.md  # Changelog               
````

## How to Contribute
If you find any problem when using the project, submit an [issue](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/issues) or a [PR](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/pulls).

## License
This project is licensed under [BSD License](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/blob/master/protobufjs_utf8/LICENSE).
