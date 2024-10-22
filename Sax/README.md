# sax

## Introduction

> sax is a JavaScript library for parsing XML or HTML documents.

## How to Install

````
ohpm install sax@0.6.0
````

For details about the OpenHarmony ohpm environment configuration, see [OpenHarmony HAR](https://gitee.com/openharmony-tpc/docs/blob/master/OpenHarmony_har_usage.en.md).

## How to Use

### Parsing XML information

```
  saxParseXml() {
    let _this = this;
    let parser: ESObject = sax.parser(true); // Create a parser instance.
    parser.onopentag = (node: ESObject) => {
      hilog.info(0x0000, 'testTag', '%{public}s', node);
    };
    parser.onclosetag = (nodeName: ESObject) => {
      hilog.info(0x0000, 'testTag', '%{public}s', nodeName);
    };
    parser.ontext = (text: ESObject) => {
      hilog.info(0x0000, 'testTag', '%{public}s', text);
      _this.message = text
    };
    parser.onend = (ondeEnd: ESObject) => {
      hilog.info(0x0000, 'testTag', '%{public}s', ondeEnd);
    };
    parser.onerror = (error: ESObject) => {
      hilog.info(0x0000, 'testTag', '%{public}s', error);
    };
    parser.write('<?xml version="1.0" encoding="UTF-8"?> <message> <warning> I\'m an xml! </message>');
    parser.end();
  }
```

### Parsing HTML information

```
  saxParseHtml() {
    let _this = this;
    let parser: ESObject = sax.parser(true); // Create a parser instance.
    parser.onopentag = (node: ESObject) => {
      hilog.info(0x0000, 'testTag', '%{public}s', node);
    };
    parser.onclosetag = (nodeName: ESObject) => {
      hilog.info(0x0000, 'testTag', '%{public}s', nodeName);
    };
    parser.ontext = (text: ESObject) => {
      hilog.info(0x0000, 'testTag', '%{public}s', text);
      _this.message = text
    };
    parser.onend = (ondeEnd: ESObject) => {
      hilog.info(0x0000, 'testTag', '%{public}s', ondeEnd);
    };
    parser.onerror = (error: ESObject) => {
      hilog.info(0x0000, 'testTag', '%{public}s', error);
    };
    parser.write('<head><b>I\'m an html!</b></head>');
    parser.end();
  }
```

## Available APIs

| API                        | Description            |
|--------------------------------|----------------|
| parser(a:boolean): Parser      | Creates a parser instance.   |
| onopentag(node: ESObject)      | Callback API when tag parsing starts.|
| onclosetag(nodeName: ESObject) | Callback API when tag parsing ends.|
| ontext(text: ESObject)         | Callback API for parsing tag content   |
| onend(ondeEnd: ESObject)       | Callback API for parsing ending      |
| onerror(error: ESObject)       | Callback API for parsing errors      |
| write(str: String)             | Writes the parsed content.        |
| onattribute(a: ESObject)       | Callback API for parsing the attribute value.    |
| end()                          | Ends parser write.     |
| close()                        | Closes the parser.       |

## Constraints

lodash.isequal has been verified in the following version:
- DevEco Studio: NEXT Beta1-5.0.3.806, SDK:API12 Release(5.0.0.66)
- DevEco Studio 4.1 Canary (4.1.3.317), OpenHarmony SDK: API11 (4.1.0.36)
## Directory Structure

````
|---- Sax  
|     |---- entry  # Sample code
|           |---- src  
|                   |---- main  # Sample code
|                   |---- ohosTest  # xts code
|     |---- README.md  # Readme  
|     |---- README_zh.md  # Readme                  
````

## How to Contribute

If you find any problem during the use, submit an [Issue](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/issues) or a [PR](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/pulls) to us.

## License

This project is licensed under [BSD LICENSE](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/blob/master/Sax/LICENSE).

