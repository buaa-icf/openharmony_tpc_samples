# @protobufjs/float

## Introduction

> @protobufjs/float is a tool library for reading floats and doubles from buffers and writing floats and doubles to buffers.

## How to Install

```shell
ohpm install @protobufjs/float
```

OpenHarmony
For details about the OpenHarmony ohpm environment configuration, see [OpenHarmony HAR](https://gitcode.com/openharmony-tpc/docs/blob/master/OpenHarmony_har_usage.en.md).

## How to Use

### Importing and Using the Library

1. Write a 32-bit float to a buffer using little endian byte order.

```
import EventEmitter from "@protobufjs/float"
const value = 3.14159;
const buffer = new Uint8Array(4)
writeFloatLE(value, buffer, 0);
```

2. Write a 32-bit float to a buffer using big endian byte order.

```
const value = 1.1754943508222875e-38;
const buffer = new Uint8Array(4)
writeDoubleLE(value, buffer, 0);
```

3. Read a 32-bit float from a buffer using little endian byte order.

```
const value = 1.1754943508222875e-38;
const buffer = new Uint8Array(4)
writeDoubleBE(value, buffer, 0);
```

4. Read a 32-bit float from a buffer using big endian byte order.

```
const value = 2.2250738585072014e-309;
const buffer = new Uint8Array(4)
writeFloatLE(value, buffer, 0);
readFloatLE(buffer, 0);
```

5. Write a 64-bit double to a buffer using little endian byte order.

```
const value = 2.2250738585072014e-309;
const buffer = new Uint8Array(4)
writeFloatLE(value, buffer, 0);
readFloatLE(buffer, 0);
```

6. Write a 64-bit double to a buffer using big endian byte order.

```
const value = 2.2250738585072014e-309;
const buffer = new Uint8Array(4)
writeFloatBE(value, buffer, 0);
readFloatBE(buffer, 0);
```

7. Read a 64-bit double from a buffer using little endian byte order.

```
const value = 3.4028234663852886e+38;
const buffer = new Uint8Array(4)
writeDoubleBE(value, buffer, 0);
readDoubleBE(buffer, 0);
```

8. Read a 64-bit double from a buffer using big endian byte order.

```
const value = 3.4028234663852886e+38;
const buffer = new Uint8Array(4)
writeDoubleLE(value, buffer, 0);
readDoubleLE(buffer, 0);
```

## Available APIs

1. Writes a 32-bit float to a buffer using little endian byte order.
   `writeFloatLE(val: number, buf: Uint8Array, pos: number): void`
2. Writes a 32-bit float to a buffer using big endian byte order.
   `writeFloatBE(val: number, buf: Uint8Array, pos: number): void`
3. Reads a 32-bit float from a buffer using little endian byte order.
   `readFloatLE(buf: Uint8Array, pos: number): number`
4. Reads a 32-bit float from a buffer using big endian byte order.
   `readFloatBE(buf: Uint8Array, pos: number): number`
5. Writes a 64-bit double to a buffer using little endian byte order.
   `writeDoubleLE(val: number, buf: Uint8Array, pos: number): void`
6. Writes a 64-bit double to a buffer using big endian byte order.
   `writeDoubleBE(val: number, buf: Uint8Array, pos: number): void`
7. Reads a 64-bit double from a buffer using little endian byte order.
   `readDoubleLE(buf: Uint8Array, pos: number): number`
8. Reads a 64-bit double from a buffer using big endian byte order.
   `readDoubleBE(buf: Uint8Array, pos: number): number`

## Constraints

This project has been verified in the following versions:

- DevEco Studio: 4.1 Canary (4.1.3.317), OpenHarmony SDK: API 11 (4.1.0.36)

## Directory Structure

````
|---- protobufjs_float
|     |---- entry  # Sample code
|           |---- src
|                 |---- main
|                        |---- ets
|                              |---- pages
|                                    |---- Index # Sample
|                 |---- ohosTest
|                       |---- ets
|                             |---- test
|                                   |---- Ability.test.ets  # Unit test

|     |---- README.md  # Readme
|     |---- README.OpenSource  # Open source description
|     |---- CHANGELOG.md  # Changelog               
````

## How to Contribute

If you find any problem when using the project, submit an [issue](https://gitcode.com/openharmony-tpc/openharmony_tpc_samples/issues) or a [PR](https://gitcode.com/openharmony-tpc/openharmony_tpc_samples/pulls).

## License

This project is licensed under [BSD License](https://gitcode.com/openharmony-tpc/openharmony_tpc_samples/blob/master/protobufjs_float/LICENSE).
