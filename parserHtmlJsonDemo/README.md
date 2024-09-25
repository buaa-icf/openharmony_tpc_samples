# parser-html-json

## Introduction

This project provides APIs to parse HTML data of a string into JSON data and obtain related content.

![Demo](./demo_EN.gif)

## Installation

```
ohpm install parser-html-json
```

For details about the OpenHarmony ohpm environment configuration, see [OpenHarmony HAR](https://gitee.com/openharmony-tpc/docs/blob/master/OpenHarmony_har_usage.en.md).

## How to Use

### Extracting a CSS String

```
import * as ParserHTMLJson from 'parser-html-json';

let parserJson = new ParserHTMLJson.default(html);
let result = JSON.stringify(parserJson.getClassStyleJson());
```

### Obtaining HTML Data in JSON Format

```
import * as ParserHTMLJson from 'parser-html-json';

let parserJson = new ParserHTMLJson.default(html);
let result = JSON.stringify(parserJson.getHtmlJson());
```

### Available APIs
|      API      |           Description          |
| :---------------: | :--------------------------: |
| getClassStyleJson |   Obtains the JSON object converted from a CSS string.   |
|    getHtmlJson    | Obtains HTML data in JSON format.|

## Directory Structure

```
|---- parserHtmlJsonDemo
|     |---- entry/src/main/ets  # Sample code
|           |---- entryability
|                            |---- EntryAbility.ets
|           |---- pages
|                     |---- Index.ets
|     |---- README_EN.md  # Readme
|     |---- demo_EN.gif  # Demo
```

## How to Contribute

If you find any problem when using parser-html-json, submit an [issue](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/issues) or a [PR](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/pulls).

## License

This project is licensed under [MIT License](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/blob/master/parserHtmlJsonDemo/LICENSE).
