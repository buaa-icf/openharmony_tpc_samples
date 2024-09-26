# js-md2Demo

## Introduction
This demo uses the third-party JavaScript library [js-md2](https://github.com/emn178/js-md2) in OpenHarmony. The simple MD2 hash function of JavaScript supports UTF-8 encoding.

## How to Install
```
ohpm install js-md2
```
For details about the OpenHarmony ohpm environment configuration, see [OpenHarmony HAR](https://gitee.com/openharmony-tpc/docs/blob/master/OpenHarmony_har_usage.en.md).
## How to Use

```javascript
import md2 from 'js-md2';

let content:string = 'ABCDEFGHI';
let mess = md2 (content);
```

## Available APIs

|    API   |    Parameter    | Description|
|:---------:|:---------:|:----:|
| md2(data) | **data**: content|  Algorithm |

## Constraints
This project has been verified in the following version:

DevEco Studio: 4.0 Beta2(4.0.3.512), SDK: API10 (4.0.10.9)

DevEco Studio: 3.1 Beta2 (3.1.0.400), SDK: API 9 Release (3.2.11.9)

## License

This project is licensed under [MIT License](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/tree/master/js-md2Demo/LICENSE).

## How to Contribute

If you find any problem during the use, submit an [issue](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/issues) or a [PR](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/pulls) to us.
