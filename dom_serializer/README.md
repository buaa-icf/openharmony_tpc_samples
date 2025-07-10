# dom-serializer

## Introduction

> dom-serializer is a utility library that renders a DOM node or an array of DOM nodes into a string.

## How to Install

```shell
ohpm install dom-serializer
```

OpenHarmony

For details about the OpenHarmony ohpm environment configuration, see [OpenHarmony HAR](https://gitcode.com/openharmony-tpc/docs/blob/master/OpenHarmony_har_usage.en.md).

## How to Use

### Referencing and Using the Library

```
import { render } from "dom-serializer";
import { Document, DomUtils, parseDocument } from "@ohos/htmlparser2";
  let html:string=""
  let dom: Document = parseDocument(html);
  let element = DomUtils.getElementsByTagName('style', dom);
  this.message = render(element)
```

## Available APIs

Renders a DOM node or an array of DOM nodes into a string.

`render(node: AnyNode | ArrayLike<AnyNode>, options?: DomSerializerOptions): string`


| Name | Type    | Mandatory | Description      |
|---------|-------------------------------------------------------------|-----------|-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| node    | AnyNode &#124;? ArrayLike<AnyNode>                                           | YES       | AnyNode object or array                                                                                                                                                                             |
| options | DomSerializerOptions                                           | NO        | Serialization options  <br/>{ emptyAttrs��Print an empty attribute's value��<br/>selfClosingTags��Print self-closing tags for tags without contents.��<br/>xmlMode��Treat the input as an XML document; enables the `emptyAttrs` and `selfClosingTags` options.��<br/>encodeEntities��Encode characters that are either reserved in HTML or XML��} |

## Constraints

This project has been verified in the following version:

- DevEco Studio Version: 4.1 Canary (4.1.3.317), OpenHarmony SDK: API 11 (4.1.0.36)

- DevEco Studio Version��DevEco Studio 5.1.0 Canary1(5.1.0.229)��OpenHarmony SDK:5.1.0.229 API16��5.1.0.46����

## Directory Structure

````
|---- dom_serializer
|     |---- entry  # Sample code
|           |---- src
|                 |---- main
|                        |---- ets
|                              |---- pages
|                                    |---- Index # sample
|                 |---- ohosTest
|                       |---- ets
|                             |---- test
|                                   |---- Ability.test.ets  # Unit test

|     |---- README.md  # Readme
|     |---- README_zh.md  # Readme
|     |---- README.OpenSource  # Open source description
|     |---- CHANGELOG.md  # Changelog               
````

## How to Contribute

If you find any problem when using dom-serializer, submit an [issue](https://gitcode.com/openharmony-tpc/openharmony_tpc_samples/issues) or a [PR](https://gitcode.com/openharmony-tpc/openharmony_tpc_samples/pulls).

## License

This project is licensed under [MIT License](https://gitcode.com/openharmony-tpc/openharmony_tpc_samples/blob/master/dom_serializer/LICENSE).
