# Base64


## Introduction
This project is an example of using Base64 in OpenHarmony. Base64 is an encoding and decoding tool library.


## How to Install

```shell
ohpm install Base64
```
For details about the OpenHarmony ohpm environment configuration, see [OpenHarmony HAR](https://gitcode.com/openharmony-tpc/docs/blob/master/OpenHarmony_har_usage.en.md).

## How to Use
```javascript
    // Import Base64-related APIs.
    import { btoa, atob } from 'Base64'
    this.message = btoa('hello Base64');
    // aGVsbG8gQmFzZTY0
    console.log ("Encode' hello Base64': "+ this.message)
    this.message = atob('aGVsbG8gQmFzZTY0');
    // hello Base64
    console.log ("Decode' aGVsbG8gQmFzZTY0': "+ this.message)
```

## Available APIs


| API   | Parameter    | Description             |
|---------|--------|-------------------|
| btoa()  | input  | Encoding string            |
| atob()  | input  | Decoding string            |

## About obfuscation
- Code obfuscation, please see[Code Obfuscation](https://docs.openharmony.cn/pages/v5.0/zh-cn/application-dev/arkts-utils/source-obfuscation.md)
- If you want the Base64 library not to be obfuscated during code obfuscation, you need to add corresponding exclusion rules in the obfuscation rule configuration file obfuscation-rules.txt：
```
-keep
./oh_modules/Base64
```


## Constraints

This project has been verified in the following version:

- DevEco Studio: 4.1 Canary (4.1.3.317), OpenHarmony SDK: API11 (4.1.0.36)

## How to Contribute

If you find any problem during the use, submit an [issue](https://gitcode.com/openharmony-tpc/openharmony_tpc_samples/issues) or a [PR](https://gitcode.com/openharmony-tpc/openharmony_tpc_samples/pulls) to us.

## License

This project is licensed under [MIT License](https://gitcode.com/openharmony-tpc/openharmony_tpc_samples/blob/master/Base64/LICENSE).
