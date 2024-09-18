# cborDemo

## Introduction

This project is an OpenHarmony development example based on the cbor-js library, which is is an open-source JavaScript library for encoding and parsing data in the Concise Binary Object Representation (CBOR) data format (RFC 8949).

## How to Install

```
ohpm install cbor-js
ohpm install @types/cbor-js --save-dev // Install @types/cbor-js to prevent import syntax errors due to missing type declarations in the cbor-js package.

```
For details about the OpenHarmony ohpm environment configuration, see [OpenHarmony HAR](https://gitee.com/openharmony-tpc/docs/blob/master/OpenHarmony_har_usage.en.md).

For details about the OpenHarmony ohpm environment configuration, see [OpenHarmony HAR](https://gitee.com/openharmony-tpc/docs/blob/master/OpenHarmony_har_usage.en.md).

## How to Use

```javascript
import CBOR from 'cbor-js'

var initial = { Hello: "World" };
var encoded = CBOR.encode(initial)
var decoded = CBOR.decode(encoded)
```

## Available APIs
1. **encode()**: encodes data into the CBOR format.
2. **decode()**: decodes data from the CBOR format.

## Constraints

This project has been verified in the following versions:
- Deveco Studio: 4.0 (4.0.3.512), SDK: API 10 (4.0.10.9)

- DevEco Studio: 3.1 Beta2 (3.1.0.400), SDK: API 9 Release (3.2.11.9)

## Directory Structure

```
 ├── cborjsDemo
 │ └── entry
 │ │ └── src
 │ │ │ ├── main
 │ │ │ │  ├── ets
 │ │ │ │  │ ├── pages        
 │ │ │ │ │  │ ├── index.ets       # CBOR encoding and decoding example
```

## How to Contribute
If you find any problem during the use, submit an [Issue](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/issues) or a [PR](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/pulls).

## License
This project is licensed under [Apache License 2.0](https://gitee.com/openharmony-tpc/cborjsDemo/blob/master/LICENSE).
