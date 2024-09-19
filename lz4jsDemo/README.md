# lz4jsDemo

## Introduction

This demo allows you to use the third-party JavaScript library [lz4js](https://github.com/Benzinga/lz4js) in OpenHarmony. lz4js provides data compression and decompression using the LZ4 algorithm.

## How to Install

```
  ohpm install lz4js
```
For details, see [Installing an OpenHarmony HAR](https://gitee.com/openharmony-tpc/docs/blob/master/OpenHarmony_har_usage.en.md).

## How to Use

### Compressing and Decompressing Data Using lz4js
```
  import lz4 from 'lz4js'

// Compress 128 bytes of zero.
var compressed = lz4.compress(new Array(128));

// Decompress.
var decompressed = lz4.decompress(compressed);

```

## Available APIs

|                  API                 |          Parameter         |    Description    |
|:-------------------------------------|:--------------------|:-----------|
|            compress(data)             |      **data**: data to compress.      | Compresses data using LZ4.|
|           decompress(data)            |      **data**: data to decompress.      |  Decompresses data using LZ4. |

## Directory Structure

```
/lz4jsDemo # Project code.
|—— entry   # Project demo.
│   └── main
│       └── ets
│       └── pages
│           └── Index.ets             # lz4js example.
```

## Constraints
This project has been verified in the following versions:
- DevEco Studio: 4.0 (4.0.3.512), SDK: API10 (4.0.10.9)
- DevEco Studio: 3.1 Beta2 (3.1.0.400), SDK: API9 Release (3.2.11.9)

## License

This project is licensed under [Apache License 2.0](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/blob/master/lz4jsDemo/LICENSE).

## How to Contribute

If you find any problem during the use, submit an [Issue](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/issues) or a [PR](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/pulls).
