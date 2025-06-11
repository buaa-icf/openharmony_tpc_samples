# hex-encode-decode Demo

## Introduction
This demo describes how to use the third-party JS library [hex-encode-decode](https://github.com/tiaanduplessis/hex-encode-decode) in OpenHarmony. This library provides APIs for encoding and decoding text data.

## How to Install
```
ohpm install hex-encode-decode
```
For details about the OpenHarmony ohpm environment configuration, see [OpenHarmony HAR](https://gitcode.com/openharmony-tpc/docs/blob/master/OpenHarmony_har_usage.en.md).
## How to Use

```javascript
import {encode,decode} from 'hex-encode-decode';

let content:string = 'ABCDEFGHIJKabcdefj123456+/AA==!@';
let encodes =encode(content) ;
let decodes = decode(this.encodes)
```

## Available APIs

|    API   |      Parameter     | Description|
| :----------: | :------------: | :------: |
| encode(data) | **data**: content to encode. |   Encodes data.  |
| decode(data) | **data**: data to decode.|   Decodes data.  |

## Constraints
This project has been verified in the following versions:
- DevEco Studio: NEXT Beta1-5.0.3.806, SDK:API12 Release(5.0.0.66)
- DevEco Studio: 4.0 (4.0.3.512), SDK: API 10 (4.0.10.9)
- DevEco Studio: 3.1 Beta2 (3.1.0.400), SDK: API 9 Release (3.2.11.9)

## License

This project is licensed under [Apache License 2.0](https://gitcode.com/openharmony-tpc/openharmony_tpc_samples/blob/master/hex-encode-decodeDemo/LICENSE).

## How to Contribute

If you find any problem when using the hex-encode-decode demo, submit an [issue](https://gitcode.com/openharmony-tpc/openharmony_tpc_samples/issues) or a [PR](https://gitcode.com/openharmony-tpc/openharmony_tpc_samples/pulls).
