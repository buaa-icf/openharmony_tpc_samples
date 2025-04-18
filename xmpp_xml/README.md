# @ohos/xmpp_xml

## Introduction

Based on the open source software [@xmpp/xml](https://github.com/xmppjs/xmpp.js/tree/main/packages/xml), this project uses TypeScript to implement similar capabilities. It provides OpenHarmony with a library for writing XML over XMPP.

## Supported Features

- Creating an XML element
- Parsing XML strings
- Escaping XML strings containing special characters
- Unescaping escaped XML strings
- Escaping special characters in XML files
- Unescaping escaped XML files

## How to Install

```
 ohpm install @ohos/xmpp_xml
```

## Available APIs

Supported APIs

| API                   | Parameter                 | Description                                                        |
| --------------------------- | --------------------- | ------------------------------------------------------------ |
| onStartElement(name, attrs) | name, attrs          | Called when the parser encounters the start tag of an XML element. In this callback, you need to create an `Element` instance and add it to the correct location based on the current parsing status.|
| onEndElement(name)          | 'name':string         | Called when the parser encounters the end tag of an XML element. In this callback, you need to check the current parsing status and process the end tag.|
| onText(str)                 | 'online':string       | Called when the parser encounters text. In this callback, you need to add the text to the current `cursor` element.|
| end(data)                   | 'status':string       | Ends the parsing process. Parsing will not end immediately when there is still data left. It continues until all the data has been completely parsed.                      |
| write(data)                 | 'stanza':string       | Passes data to a `LtxParser` instance for parsing.                       |
| xml(...args)                | **args**: data used to construct an XML element.| Default export function that takes any parameter and returns an XML element created by `createElement()`. It can be used to quickly create an XML element.|
| createElement               | N/A                   | Creates an XML element. You can pass in information such as the tag name, attributes, and subelements, and a new `Element` instance is returned.|
| escapeXML                   | N/A                   | Escapes special characters in an XML string.                         |
| unescapeXML                 | N/A                   | Unescapes special characters in an XML string.             |
| escapeXMLText               | N/A                   | Escapes special characters in an XML file.                           |
| unescapeXMLText             | N/A                   | Unescapes special characters in an XML file.               |



## Example

```
import {Parser} from '@ohos/xmpp_xml'
import xml  from "@ohos/xmpp_xml"
@Entry
@Component
struct Index {
  private parser:ESObject =new Parser();
  build() {
    Column() {
      Button('Parser').onClick((v) => {
          // Called upon the start tag.
        this.parser.on('start', (element:ESObject) => {
          console.info('Parser---Start element:', element);
        });
          // Called upon the end tag.
        this. parser.on('end', (root:ESObject) => {
          console.info('Parser---End element:', root);
        });
          // Called upon text.
        this. parser.on('element', (element:ESObject) => {
          console.info('Parser---Element:', element);
        });
          // Write an XML string to trigger the parsing process.
        this.parser.write("<foo><bar>hello</bar></foo>");
      }).margin({ top: px2vp(50) })
        // Create an XML element.
         message= xml("message", { type: "chat", to: "admin@10.50.80.51" }, xml("body", {}, "Hello").toString ();
          })
    }
    .height('100%')
    .width('100%')
  }
```

## How to Use

#### Callback Invoked Upon an XML Start Tag

```
parser.onStartElement('message', { from: 'sender@example.com', to: 'receiver@example.com' });
```

#### Callback Invoked Upon an XML End Tag

```
parser.onEndElement('message');
```

#### Callback Invoked Upon Text

```
parser.onText('Hello, world!');
```

#### Passing Data to a `LtxParser` Instance for Parsing

xmpp.send(xml)

```
parser.write('<message from="sender@example.com" to="receiver@example.com">Hello, world!</message>');
```

#### Ending the Parsing Process (Parsing Will Not Stop Immediately If there Is Still Data Left)

```
parser.end();
```

#### Listening for Parser State Changes

```
parser.on('start', (element) => {
  console.log('Start element:', element);
});

parser.on('end', (root) => {
  console.log('End element:', root);
});

parser.on('element', (element) => {
  console.log('Element:', element);
});

parser.on('error', (error) => {
  console.error('Error:', error.message);
});
```
## About obfuscation
- Code obfuscation, please see[Code Obfuscation](https://docs.openharmony.cn/pages/v5.0/zh-cn/application-dev/arkts-utils/source-obfuscation.md)
- If you want the library not to be obfuscated during code obfuscation, you need to add corresponding exclusion rules in the obfuscation rule configuration file obfuscation-rules.txt：
```
-keep
./oh_modules/@ohos/xmpp_xml
```
## Constraints

This project has been verified in the following version:

DevEco Studio: 5.0.3.200, 5.0.0.22-Canary2, SDK: API 12

## How to Contribute

If you find any problem when using @xmpp/xml, submit an [issue](https://gitcode.com/openharmony-tpc/openharmony_tpc_samples/issues) or a [PR](https://gitcode.com/openharmony-tpc/openharmony_tpc_samples/pulls).

## License

This project is licensed under ISC License.
