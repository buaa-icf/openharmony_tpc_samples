# @ohos/xmldom

## Introduction

> This project provides OpenHarmony with a JavaScript module that supports W3C-compliant DOMParser and XMLSerializer. It allows you to parse and manipulate XML data in browsers and Node.js environments, and to convert DOM documents into XML strings. This makes it easier and more standardized to process and manipulate XML data.

## How to Install

```shell
ohpm install @ohos/xmldom
```

OpenHarmony

For details about the ohpm environment configuration, see [Installing the OpenHarmony HAR](https://gitee.com/openharmony-tpc/docs/blob/master/OpenHarmony_har_usage.en.md).

## How to Use

Import files and code dependencies.

```
 import { DOMParser, XMLSerializer, DOMImplementation } from '@ohos/xmldom'
 
 const source = `<xml xmlns="a">
	<child>test</child>
	<child/>
 </xml>`

 const doc :ESObject = new DOMParser().parseFromString(source, 'text/xml')

 const serialized :ESObject = new XMLSerializer().serializeToString(doc)
```

## Available APIs

* Parses an XML string into a DOM document.
 - `parseFromString()`
* Serializes a DOM document into an XML string.
 - `serializeToString()`

## Directory Structure
````
|---- xmldom
|     |---- entry  # Sample code
              ├── src  
                 ├── main   
                   ├── ets
                       ├── pages
                             ├── Index.ets  # Sample code
|     |---- README.md  # Readme                   
````

## Constraints

This project has been verified in the following version:

- DevEco Studio: NEXT Beta1-5.0.3.806, SDK:API12 Release(5.0.0.66)
- DevEco Studio： 4.1 Canary(4.1.3.317), OpenHarmony SDK:API11 (4.1.0.36)

## How to Contribute

If you find any problem during the use, submit an [issue](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/issues) or a [PR](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/pulls).

## License

This project is licensed under [MIT License](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/blob/master/xmldom/LICENSE).
