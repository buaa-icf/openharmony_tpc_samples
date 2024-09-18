# Domhandler

# Introduction

Domhandler is a handler for htmlparser2 that turns pages into a DOM. It creates a DOM containing all nodes of a page.

## How to Install

```
 ohpm install domhandler
 ohpm install @ohos/htmlparser2
```

For details about the OpenHarmony ohpm environment configuration, see [OpenHarmony HAR](https://gitee.com/openharmony-tpc/docs/blob/master/OpenHarmony_har_usage.en.md).

# How to Use
```
import { Element } from 'domhandler';
import {
  Parser,
  parseDocument,
  DomUtils,
  Document,
  createDocumentStream,
} from '@ohos/htmlparser2'
```

Parse an HTML file, generate a DOM object, and obtain the text content.

```javascript
const html = `
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document</title>
</head>
<style>
    .tagh1{
        background-color: aquamarine;
        color:'blue';
    }
    .one-div{
        line-height: 30px;
    }
</style>
<body>
    <h1 class="tagh1">
        kkkk
        <p>hhhhh</p>
    </h1>
    <div style="color:red; height:100px;" class="one-div">cshi</div>
    <img src="https:baidu.com" alt="wwww"/>
    <p>wjdwekfe</p>
    <em>dsjfw
    <div>dksfmjk</div>
    owqkdo</em>
</body>
</html>
`;
let dom: Document = parseDocument(html);
let text:string = DomUtils.textContent(element);
```

### Available APIs
For details about unit test cases, see [TEST.md](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/blob/master/Domhandler/TEST.md).


## Constraints
This project has been verified in the following version:

DevEco Studio: 4.1 Canary (4.1.3.317), OpenHarmony SDK: API 11 (4.1.0.36)

## Directory Structure

```
|---- Domhandler  
|     |---- entry  # Sample code
|     |---- README.md  # Readme                  
|     |---- README_zh.md  # Readme                  
```

## How to Contribute

If you find any problem when using domhandler, submit an [issue](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/issues) or a [PR](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/pulls).

## License

This project is licensed under [BSD License](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/blob/master/Domhandler/LICENSE).
