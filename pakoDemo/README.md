# pakoDemo

## Introduction

This demo allows you to use the third-party JavaScript library [pako](https://github.com/nodeca/pako) with OpenHarmony. pako provides data compression and decompression in gzip and deflate formats.

## How to Install

```
  ohpm install pako
```
For details, see [Installing an OpenHarmony HAR](https://gitee.com/openharmony-tpc/docs/blob/master/OpenHarmony_har_usage.en.md).

## How to Use

[API reference](http://nodeca.github.io/pako/)
### Processing Uint8Array Data
```
  import pako from 'pako'

// Deflate
//
const input = new Uint8Array();
//... fill input data here
const output = pako.deflate(input);

// Inflate (simple wrapper can throw exception on broken stream)
//
const compressed = new Uint8Array();
//... fill data to uncompress here
try {
  const result = pako.inflate(compressed);
  // ... continue processing
} catch (err) {
  console.log(err);
}

const deflator = new pako.Deflate();

deflator.push(chunk1, false);
deflator.push(chunk2); // second param is false by default.
...
deflator.push(chunk_last, true); // `true` says this chunk is last

if (deflator.err) {
  console.log(deflator.msg);
}

const output = deflator.result;


const inflator = new pako.Inflate();

inflator.push(chunk1);
inflator.push(chunk2);
...
inflator.push(chunk_last); // no second param because end is auto-detected

if (inflator.err) {
  console.log(inflator.msg);
}

const output = inflator.result;**
```

## Available APIs

|                   API                   |          Parameter         |    Description    |
|:----------------------------------------|:--------------------|:-----------|
|           new Deflate(options)           |      **options**: Deflate options.     | Creates a Deflate instance.|
|          deflate(data, options)          | **data**: data to compress.<br/>**options**: options for data compression. | Compresses data in Deflate format.|
|           gzip(data, options)            | **data**: data to compress.<br/>**options**: options for data compression. |  Compresses data in gzip format.  |
|          ungzip(data, options)           | **data**: data to decompress.<br/>**options**: options for data decompression. |  Decompresses the gzip data.  |
|          inflate(data)           | **data**: data to decompress.|  Decompresses the data that was compressed by using Deflate.  |

## Directory Structure

```
/pakoDemo # Project code.
|—— entry   # Project demo.
│   └── main
│       └── ets
│       └── pages 
│           └── DeflateDemo.ets       # Deflate example.
│           └── Gzip.ets              # gzip example. 
│           └── Index.ets
│           └── PakoTest.ets          # Other examples. 
```

## Constraints
This project has been verified in the following version:

DevEco Studio: 5.0 Canary3(5.0.3.228), SDK: API12(5.0.0.18)

## License

This project is licensed under [Apache License 2.0](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/blob/master/pakoDemo/LICENSE).

## How to Contribute

If you find any problem during the use, submit an [Issue](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/issues) or a [PR](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/pulls).
