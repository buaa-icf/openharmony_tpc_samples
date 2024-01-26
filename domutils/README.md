# domutils

# 简介

domutils提供一个HTML/XML解析器，用于处理htmlparser2的dom的实用程序

## 下载安装

```
 ohpm install domhandler
 ohpm install domutils
 ohpm install @ohos/htmlparser2
```

OpenHarmony ohpm环境配置等更多内容，请参考[如何安装OpenHarmony ohpm](https://gitee.com/openharmony-tpc/docs/blob/master/OpenHarmony_har_usage.md)



# 使用说明
```
import { parseDocument, DomUtils, Document } from '@ohos/htmlparser2'
import { Element, ChildNode } from 'domhandler';
```

功能一：解析html，生成dom对象，并获取text内容。

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
let element:Element[] = DomUtils.getElementsByTagName('style', dom);
let text:string = DomUtils.textContent(element);
```

### 接口说明
单元测试用例详情见[TEST.md](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/blob/master/domutils/TEST.md)


## 约束与限制
在下述版本验证通过：

DevEco Studio 版本： 4.1 Canary(4.1.3.317),OpenHarmony SDK:API11 (4.1.0.36)。

## 目录结构

```
|---- Domhandler  
|     |---- entry  # 示例代码文件夹
|     |---- README.MD  # 安装使用方法                   
```

## 贡献代码

使用过程中发现任何问题都可以提[Issue](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/issues) 给我们，当然，我们也非常欢迎你给我们提[PR](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/pulls)。

## 开源协议

本项目基于 [BSD License](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/blob/master/domUtils/LICENSE)，请自由地享受和参与开源。

