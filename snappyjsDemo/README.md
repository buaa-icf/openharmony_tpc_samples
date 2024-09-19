# snappyjsDemo

## Introduction

This demo allows you to use the third-party JavaScript library [snappyjs](https://github.com/zhipeng-jia/snappyjs) in OpenHarmony. snappyjs provides data compression and decompression using Snappy.

## How to Install

```
  ohpm install snappyjs
  ohpm install @types/snappyjs@0.7.1 // Install @types/snappyjs@0.7.1 to prevent import syntax errors due to missing type declarations in the snappyjs package.
```
For details, see [Installing an OpenHarmony HAR](https://gitee.com/openharmony-tpc/docs/blob/master/OpenHarmony_har_usage.en.md).

## How to Use


### Compressing and Decompressing Data Using snappyjs
```
  import snappyJS from 'snappyjs'

var buffer = new ArrayBuffer(100)
var compressed = snappyJS.compress(buffer)
var uncompressed = snappyJS.uncompress(compressed)
```

## Available APIs

|                    API                   |                            Parameter                           |    Description   |
|:-----------------------------------------|:--------------------------------------------------------|:----------|
|              compress(data:Uint8Array\|ArrayBuffer)              |            **data**: data of the Uint8Array or ArrayBuffer type to compress.            | Compresses data using Snappy.|
|             uncompress(data:Uint8Array\|ArrayBuffer)             |            **data**: data of the Uint8Array or ArrayBuffer type to decompress.            |  Decompresses data using Snappy. |

## Directory Structure

```
/snappyjsDemo # Project code.
|—— entry   # Project demo.
│   └── main
│       └── ets
│           └── pages
│               └── Index.ets             # snappyjs example.
```

## Constraints
This project has been verified in the following versions:

- DevEco Studio: 3.1 Beta2(3.1.0.400), SDK: API9 Release(3.2.11.9)
- DevEco Studio: 4.0 (4.0.3.512), SDK: API 10 (4.0.10.9)

## License

This project is licensed under [Apache License 2.0](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/blob/master/snappyjsDemo/LICENSE).

## How to Contribute

If you find any problem during the use, submit an [issue](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/issues) or a [PR](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/pulls).
