# base64-js

## Introduction
> **base64-js** provides Base64 encoding/decoding in pure JavaScript.

## How to Install
```shell
ohpm install base64-js@1.5.1
```
For details about the OpenHarmony ohpm environment configuration, see [OpenHarmony HAR](https://gitcode.com/openharmony-tpc/docs/blob/master/OpenHarmony_har_usage.en.md).

## How to Use
1. Import files and code dependencies.
 ```
 import base64 from 'base64-js'
 
 base64.fromByteArray(new Uint8Array([1, 2, 3, 4, 5, 6, 7, 8]))
 ```

## Available APIs

 * **byteLength(b64: string): number**: receives a Base64 string and returns the length of a byte array.
 * **toByteArray(b64: string): Uint8Array**: receives a Base64 string and returns a byte array.
 * **fromByteArray(uint8: Uint8Array): string**: receives a byte array and returns a Base64 string.

## Constraints

This project has been verified in the following version:

- DevEco Studio: 4.1 Canary (4.1.3.317)

- OpenHarmony SDK: API 11 (4.1.0.36)

## Directory Structure
````
base64-js
├── bench/               # Documents
├── test/                # Test files and test cases
├── index.js             # Entry file of the library
├── index.d.ts           # External APIs of the library
├── package.json         # Package metadata and dependency information
├── README.md            # Project documents and description
├── README_zh.md         # Project documents and description
├── LICENSE              # License
└── ...                  # Other configuration files or resources              
````

## How to Contribute
If you find any problem when using the project, submit an [issue](https://gitcode.com/openharmony-tpc/openharmony_tpc_samples/issues) or a [PR](https://gitcode.com/openharmony-tpc/openharmony_tpc_samples/pulls).

## License
This project is licensed under [MIT License](https://gitcode.com/openharmony-tpc/openharmony_tpc_samples/blob/master/base64-js/LICENSE).
