# entities

## Introduction
The **entities** library provides APIs for quickly encoding and decoding HTML and XML entities.

## How to Install
```shell
ohpm install entities
```
For details about the OpenHarmony ohpm environment configuration, see [OpenHarmony HAR](https://gitee.com/openharmony-tpc/docs/blob/master/OpenHarmony_har_usage.en.md).

## How to Use
1. Import dependencies.
 ```
  import {
    decode,
    decodeHTML,
    decodeHTMLStrict,
    decodeXML,
    encode,
    encodeHTML,
    encodeNonAsciiHTML,
    encodeXML,
    EntityLevel,
    escapeUTF8,
    decodeHTMLAttribute
} from 'entities';
 ```

## Available APIs

| API                                                          | Description                                         |
| ------------------------------------------------------------ | --------------------------------------------------- |
| `decodeHTML(str: string, mode = DecodingMode.Legacy): string` | Decodes HTML entities in a string.                                           |
| `decodeXML(str: string): string`                             | Decodes XML entities in a string.                                            |
| `decodeHTMLStrict(str: string): string`                      | Strictly decodes HTML entities in a string. Each entity must end with a semicolon (;).   |
| `encodeHTML(data: string): string`                           | Encodes a string by converting characters to HTML entities.                                           |
| `encodeNonAsciiHTML(data: string): string`                   | Encodes non-ASCII characters in a string to HTML entities.|
| `encodeXML(str: string): string`                             | Encodes a string by converting characters to XML entities.                                            |
| `decode(data: string, options: DecodingOptions | EntityLevel = EntityLevel.XML): string` | Decodes entities in a string.                               |
| `encode(data: string, options: EncodingOptions | EntityLevel = EntityLevel.XML): string` | Encodes a string containing entities.                               |
| `decodeHTMLAttribute(str: string): string`                   | Decodes HTML entities in an attribute.                                       |
| `escapeUTF8: (data: string) => string`                       | Escape the UTF-8 characters in a string.                       |
| `escapeAttribute: (data: string) => string`                  | Escapes the characters in an attribute so that it can be used in HTML.                       |
| `escapeText: (data: string) => string`                       | Escapes the characters in text content so that it can be used in HTML.                       |


## Constraints

This project has been verified in the following version:

- DevEco Studio: 4.1 Canary (4.1.3.317), OpenHarmony SDK: API 11 (4.1.0.36)

## Directory Structure
````
|---- entities
|     |---- entry  # Sample code
|           |---- src
|                 |---- ohosTest
|                       |---- ets
|                             |---- test
|                                   |---- Ability.test.ets  # Unit test

|     |---- README.md  # Readme
|     |---- README.OpenSource  # Open source description
|     |---- CHANGELOG.md  # Changelog                  
````

## How to Contribute
If you find any problem when using the project, submit an [issue](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/issues) or a [PR](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/pulls).

## License
This project is licensed under [BSD License](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/blob/master/entities/LICENSE).
