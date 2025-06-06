# JsSha1Demo

## Introduction

This project is an OpenHarmony development example based on the [js-sha1](https://github.com/emn178/js-sha1) library, which is a simple SHA-1 hash function for JavaScript that supports UTF-8 encoding.

## How to Install

```
  ohpm install js-sha1
  ohpm install @types/js-sha1 --save-dev // Install @types/js-sha1 to prevent import syntax errors due to missing type declarations in the js-sha1 package.
```
For details about the OpenHarmony ohpm environment configuration, see [OpenHarmony HAR](https://gitcode.com/openharmony-tpc/docs/blob/master/OpenHarmony_har_usage.en.md).

## How to Use

[API reference](https://github.com/emn178/js-sha1)

Example of using js-sha1 to process strings, binary arrays, arrays, and other data:
```
// @ts-ignore
import sha1 from 'js-sha1';

sha1(''); // da39a3ee5e6b4b0d3255bfef95601890afd80709
sha1('The quick brown fox jumps over the lazy dog'); // 2fd4e1c67a2d28fced849ee1bb76e7391b93eb12
sha1('The quick brown fox jumps over the lazy dog.'); // 408d94384216f890ff7a0c3528e8bed1e0b01621

// It also supports UTF-8 encoding
sha1('中文'); // 7be2d2d20c106eee0836c9bc2b939890a78e8fb3

// It also supports byte `Array`, `Uint8Array`, `ArrayBuffer`
sha1([]); // da39a3ee5e6b4b0d3255bfef95601890afd80709
sha1(new Uint8Array([])); // da39a3ee5e6b4b0d3255bfef95601890afd80709

// Different output
sha1(''); // da39a3ee5e6b4b0d3255bfef95601890afd80709
sha1.hex(''); // da39a3ee5e6b4b0d3255bfef95601890afd80709
sha1.array(''); // [218, 57, 163, 238, 94, 107, 75, 13, 50, 85, 191, 239, 149, 96, 24, 144, 175, 216, 7, 9]
sha1.digest(''); // [218, 57, 163, 238, 94, 107, 75, 13, 50, 85, 191, 239, 149, 96, 24, 144, 175, 216, 7, 9]
sha1.arrayBuffer(''); // ArrayBuffer
```

## Available APIs

| API                    | Parameter                                            | Description                                     |
| :--------------------- | :--------------------------------------------------- | :---------------------------------------------- |
| sha1(data)             | **data**: string, binary array, array, or Unit8Array | Generates a SHA-1 hash as a string.             |
| sha1.hex(data)         | **data**: string                                     | Generates a SHA-1 hash as a hexadecimal string. |
| sha1.array(data)       | **data**: string                                     | Generates a SHA-1 hash as an array.             |
| sha1.digest(data)      | **data**: string                                     | Generates a SHA-1 hash as a digest.             |
| sha1.arrayBuffer(data) | **data**: string                                     | Generates a SHA-1 hash as a binary array.       |

## Directory Structure

```
/JsSha1Demo  # Project code
|—— entry   # Project demo
│   └── main
│       └── ets
│           └── entryability 
│               └── EntryAbility.ts    # Project ability
│           └── pages 
│               └── Index.ets       # Demo example page

```

## Constraints
This project has been verified in the following versions:
- DevEco Studio: NEXT Beta1-5.0.3.806, SDK: API12 Release(5.0.0.66) 
- DevEco Studio: 4.0 (4.0.3.512), SDK: API 10 (4.0.10.9)
- DevEco Studio: 4.0 Canary2 (4.0.3.312), SDK: API 10 (4.0.9.2)

## License

This project is licensed under [Apache License 2.0](https://gitcode.com/openharmony-tpc/openharmony_tpc_samples/blob/master/JsSha1Demo/LICENSE).

## How to Contribute

If you find any problem during the use, submit an [Issue](https://gitcode.com/openharmony-tpc/openharmony_tpc_samples/issues) or a [PR](https://gitcode.com/openharmony-tpc/openharmony_tpc_samples/pulls).
