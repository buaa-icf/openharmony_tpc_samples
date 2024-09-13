# js-md5Demo

## Introduction
This demo allows you to use the third-party JavaScript library [js-md2](https://github.com/emn178/js-md5) with OpenHarmony. The simple MD5 hash function of JavaScript supports UTF-8 encoding.

## How to Install
```
ohpm install js-md5
ohpm install @types/js-md5 --save-dev // If a syntax error is reported when 'import js-md5' is executed, the js-md5 package does not contain the type declaration. To solve this problem, run '@types/js-md5' to download the type declaration file.
```
For details about the OpenHarmony ohpm environment configuration, see [OpenHarmony HAR](https://gitee.com/openharmony-tpc/docs/blob/master/OpenHarmony_har_usage.en.md).
## How to Use

```javascript
import md5 from 'js-md5';

let content:string = 'ABCDEFGHI';
let mess = md5(content);
let mess2 = md5.hex(content);
let mess3 = md5.base64(content);
```

## Available APIs

|    API   |    Parameter    | Description|
|:---------|:---------|:----|
| md5(data) | data|  Algorithm. |
| md5.hex(data) | data|  Algorithm. |
| md5.base64(data) | data|  Algorithm. |
| md5.digest(data) | data|  Algorithm. |
| md5.array(data) | data|  Algorithm. |


## Constraints
This project has been verified in the following versions:

- DevEco Studio: 4.0 Beta2(4.0.3.512), SDK: API10 (4.0.10.9)

- DevEco Studio: 3.1 Beta2 (3.1.0.400), SDK: API9 Release (3.2.11.9)


## License

This project is licensed under [Apache License 2.0](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/tree/master/js-md5Demo/LICENSE).

## How to Contribute

If you find any problem during the use, submit an [Issue](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/issues) or a [PR](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/pulls).
