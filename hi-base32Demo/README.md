# hi-base32 Demo

## Introduction
This demo describes how to use the third-party JavaScript library [hi-base32](https://github.com/emn178/hi-base32) in OpenHarmony. This library is a simple Base32 (RFC4648) encode/decode function that supports UTF-8 encoding.

## How to Install
```
ohpm install hi-base32
```
For details about the OpenHarmony ohpm environment configuration, see [OpenHarmony HAR](https://gitee.com/openharmony-tpc/docs/blob/master/OpenHarmony_har_usage.en.md).
## How to Use

```javascript
import base32 from 'hi-base32';

let content:string = 'ABCDEFGHIJKabcdefj123456+/AA==!@';
let encode =base32.encode(content) ;
let deco = base32.decode(encode);
```

## Available APIs

|    API   |      Parameter     | Description|
| :----------: | :------------: | :------: |
| encode(data) | **data**: content to encode. |   Encodes data.  |
| decode(data) | **data**: data to decode.|   Decodes data.  |

## Constraints
This project has been verified in the following version:

- DevEco Studio: NEXT Beta1-5.0.3.806, SDK:API12 Release(5.0.0.66)
- DevEco Studio: 4.0 (4.0.3.512), SDK: API 10 (4.0.10.9)

## License

This project is licensed under [Apache License 2.0](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/tree/master/hi-base32Demo/LICENSE).

## How to Contribute

If you find any problem when using the hi-base32 demo, submit an [issue](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/issues) or a [PR](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/pulls).
