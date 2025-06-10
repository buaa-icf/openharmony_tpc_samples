# intl_messageformat_parser

## Introduction

> This library parses ICU message strings. intl_messageformat_parser is the dependency library specified by icu4j.

## How to Install

```shell
ohpm install @f-fjs/intl-messageformat-parser@4.1.2
```

OpenHarmony ohpm
For details about the environment configuration, see [OpenHarmony HAR](https://gitcode.com/openharmony-tpc/docs/blob/master/OpenHarmony_har_usage.en.md).

## How to Use

1. Import the dependency libraries.

```typescript
import * as intl_messageformat_parser from '@ohos/intl_messageformat_parser'
```

2. Use related APIs as required.

```typescript
Button ('parse test').fontSize (24).onClick(() == > {
  let input = 'On{takenDate,date,short} {name} took {numPhotos,plural, =0 {no photos.} =1{one photo.} other {# photos}}';
  const ast = intl_messageformat_parser.parse(input);
  setData(JSON.stringify(ast), this.dialogController)
})
```

## Available APIs

- // Parse the string.

```
parse(input: string, opts ? : ParseOptions):MessageFormatElement[]
```

## Constraints

This project has been verified in the following version:

- DevEco Studio version: 4.1 Canary (4.1.3.317); OpenHarmony SDK: API version 11 (4.1.0.36)

## Directory Structure

````
|---- OHOS_APP_icu4j  
|     |---- entry  # Sample code
|     |---- intl_messageformat_parser  # intl_messageformat_parser library
|           |---- ets # Core code directory
|     |---- README_EN.md  # Readme                   
````

## How to Contribute

If you find any problem during the use, submit an [Issue](https://gitcode.com/openharmony-tpc/openharmony_tpc_samples/issues) or a [PR](https://gitcode.com/openharmony-tpc/openharmony_tpc_samples/pulls) to us.

## License

This project is based on [Apache LICENSE](https://gitcode.com/openharmony-tpc/openharmony_tpc_samples/blob/master/icu4j/LICENSE).

  
