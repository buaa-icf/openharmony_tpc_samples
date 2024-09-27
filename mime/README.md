# mime

## Introduction

The mime library is used to obtain the MIME type of a specified file path or file name extension, providing more convenient development experience and higher code readability.

## How to Install

```
ohpm install mime
ohpm install @types/mime@3.0.3 --save-dev // Install @types/mime to prevent import syntax errors due to missing type declarations in the mime package.
```

For details about the OpenHarmony ohpm environment configuration, see [OpenHarmony HAR](https://gitee.com/openharmony-tpc/docs/blob/master/OpenHarmony_har_usage.en.md).

## How to Use

```
import mime from "mime";

mime.getType('js'); // application/javascript
mime.getExtension('text/plain')  // txt;
```

## Constraints

This project has been verified in the following version:
DevEco Studio: 4.1 Canary (4.1.3.213), SDK: API 11 4.1.2.3

## Directory Structure

```
|---- mime
|     |---- entry  # Sample code
|     |---- README.md  # Readme
|     |---- README_zh.md  # Readme
```

## How to Contribute

If you find any problem when using the project, submit an [issue](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/issues) or a [PR](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/pulls).

## License

This project is licensed under [MIT License](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/blob/master/mime/LICENSE).
