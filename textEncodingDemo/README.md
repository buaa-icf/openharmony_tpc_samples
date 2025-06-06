# textEncodingDemo

## Introduction
This demo describes how to use the third-party JavaScript library [text-encoding](https://github.com/inexorabletash/text-encoding) in OpenHarmony for encoding and decoding text data.

## How to Install
```
ohpm install text-encoding
ohpm install @types/text-encoding --save-dev // Install @types/text-encoding to prevent import syntax errors due to missing type declarations in the text-encoding package.

```
For details about the OpenHarmony ohpm environment configuration, see [OpenHarmony HAR](https://gitcode.com/openharmony-tpc/docs/blob/master/OpenHarmony_har_usage.en.md).
## How to Use

```javascript
import { TextEncoder, TextDecoder } from 'text-encoding';

let content:string = 'ABCDEFGHIJKabcdefj123456+/AA==!@';
let encode =new TextEncoder().encode(content) ;
let deco = new TextDecoder().decode(encode);
```

## Available APIs

| API               | Parameter                | Description   |
| :---------------- | :----------------------- | :------------ |
| TextEncoder(data) | **data**: data to encode | Encodes text. |
| TextDecoder(data) | **data**: data to decode | Decodes text. |
| encode(data)      | **data**: data to encode | Encodes data. |
| decode(data)      | **data**: data to decode | Decodes data. |

## Constraints
This project has been verified in the following versions:

- DevEco Studio: NEXT Beta1-5.0.3.806, SDK:API12 Release(5.0.0.66)
- DevEco Studio: 4.0 (4.0.3.512), SDK: API 10 (4.0.10.9)
- DevEco Studio: 3.1 Beta2 (3.1.0.400), SDK: API 9 Release (3.2.11.9)

## License

This project is licensed under [Apache License 2.0](https://gitcode.com/openharmony-tpc/openharmony_tpc_samples/blob/master/textEncodingDemo/LICENSE).

## How to Contribute

If you find any problem when using the project, submit an [issue](https://gitcode.com/openharmony-tpc/openharmony_tpc_samples/issues) or a [PR](https://gitcode.com/openharmony-tpc/openharmony_tpc_samples/pulls).
