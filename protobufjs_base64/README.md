# @protobufjs/base64

## Introduction
> @protobufjs/base64 is a minimal Base64 implementation for number arrays.

## How to Install
```shell
ohpm install @protobufjs/base64
```
For details about the OpenHarmony ohpm environment configuration, see [OpenHarmony HAR](https://gitcode.com/openharmony-tpc/docs/blob/master/OpenHarmony_har_usage.en.md).

## How to Use

### Importing and Using the Library
1. Import the dependency.
```
import { length, encode, decode, test } from '@protobufjs/base64'
```

2. Encrypt a Uint8Array typed array.

 ```
    let test="openharmony"
    const textEncoder = new util.TextEncoder()
    let uint8Array = textEncoder.encodeInto(test)
    let result= encode(uint8Array, 0, uint8Array.length)
 ```

2. Decode a Base64-encoded string.

 ```
    let test="openharmony"
    const textEncoder = new util.TextEncoder()
    let uint8Array = textEncoder.encodeInto(test)
    let encodeStr= encode(uint8Array, 0, uint8Array.length)

    let decodeUint8Array = new Uint8Array(length(encodeStr))
    decode(encodeStr, decodeUint8Array, 0)
 ```

3. Calculate the byte length of a Base64-encoded string.

 ```
    let test="openharmony"
    const textEncoder = new util.TextEncoder()
    let uint8Array = textEncoder.encodeInto(test)
    let encodeStr = encode(uint8Array, 0, uint8Array.length)
    let byteLength= length(encodeStr)
 ```

3. Test whether a specified string is encoded using Base64.

 ```
  test("123435")
  test("5L2g5aW9")
 ```

## Available APIs
1. Calculates the byte length of a Base64-encoded string.
   `length(string: string): number`

2. Encodes a buffer into a Base64-encoded string.
   `encode(buffer: Uint8Array, start: number, end: number): string`

3. Decodes a Base64-encoded string into a buffer.
   `decode(string: string, buffer: Uint8Array, offset: number): number`

4. Tests whether a specified string is encoded using Base64.
   `test(string: string): boolean`

## Constraints
This project has been verified in the following versions:

- DevEco Studio: 4.1 Canary (4.1.3.317), OpenHarmony SDK: API 11 (4.1.0.36)

## Directory Structure
````
|---- ohos_entities
|     |---- entry  # Sample code
|           |---- src
|                 |---- ohosTest
|                       |---- ets
|                             |---- test
|                                   |---- Ability.test.ets  # Unit test

|     |---- README.md  # Readme  
|     |---- README_zh.md  # Readme                   
````

## How to Contribute
If you find any problem when using the project, submit an [issue](https://gitcode.com/openharmony-tpc/openharmony_tpc_samples/issues) or a [PR](https://gitcode.com/openharmony-tpc/openharmony_tpc_samples/pulls).

## License
This project is licensed under [BSD License](https://gitcode.com/openharmony-tpc/openharmony_tpc_samples/blob/master/protobufjs_base64/LICENSE).
