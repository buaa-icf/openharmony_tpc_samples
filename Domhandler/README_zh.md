# Domhandler

# 简介

用于将页面转换为dom的htmlparser2的处理程序，创建一个包含页面所有节点的dom

## 下载安装

```
 ohpm install domhandler
 ohpm install @ohos/htmlparser2
```

OpenHarmony ohpm环境配置等更多内容，请参考[如何安装OpenHarmony ohpm](https://gitcode.com/openharmony-tpc/docs/blob/master/OpenHarmony_har_usage.md)



# 使用说明
```
import {
  Node,
  DataNode,
  Comment,
  ProcessingInstruction,
  NodeWithChildren,
  CDATA,
  ParentNode,
  Document,
  Element,
  isTag,
  isCDATA,
  isText,
  isComment,
  isDirective,
  isDocument,
  hasChildren,
  ChildNode,
  cloneNode,
  DomHandler
} from "domhandler"
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
let parser: Parser = createDocumentStream((error: Error | null, dom: Document) => {
	if (!!error) {
		this.result = JSON.stringify(error)
		return
	}
	let element: Element[] = DomUtils.getElementsByTagName('style', dom);
	let text: string = DomUtils.textContent(element);

	let isTag1: boolean = isTag(element[0]);

	let isCDATA1: boolean = isCDATA(element[0]);

	let isText1: boolean = isText(element[0]);

	let isComment1: boolean = isComment(element[0]);

	let isDirectiveResult: boolean = isDirective(element[0]);

	let isDocumentResult: boolean = isDocument(element[0]);

	let hasChildrenResult: boolean = hasChildren(element[0]);

	let cloneNodeResult = cloneNode(element[0]);

	let firstChild: ChildNode | null = element[0].firstChild

	let lastChild: ChildNode | null = element[0].lastChild

	let childNodes: ChildNode[] = element[0].childNodes

	let processingInstruction: ProcessingInstruction = new ProcessingInstruction("china", "Chinese")
	this.result += "ProcessingInstruction.nodeType:" + (processingInstruction.nodeType) + "\r\n"
	this.result += "ProcessingInstruction.data:" + (processingInstruction.data) + "\r\n"

	this.result += "Element.nodeType:" + (element[0].nodeType) + "\r\n"

	this.result += "Element.tagName:" + (element[0].tagName) + "\r\n"

	element[0].tagName="style1"
	this.result += "Element.tagName:" + (element[0].tagName) + "\r\n"

	this.result += "Element.attribs:" + (JSON.stringify(element[0].attributes)) + "\r\n"

	this.result += "Node.parentNode:" + (element[0].parentNode) + "\r\n"
	this.result += "Node.nextSibling:" + (element[0].nextSibling) + "\r\n"
	this.result += "Node.previousSibling:" + (element[0].previousSibling) + "\r\n"
	this.result += "Node.cloneNode:" + (JSON.stringify(element[0].cloneNode())) + "\r\n"

	const rawHtml =
		"Xyz <script language= javascript>var foo = '<<bar>>';</script><!--<!-- Waah! -- -->";
	const handler = new DomHandler((error, dom) => {
		if (error) {
		} else {
			this.result += "DomHandler:" + (dom[0].nodeType) + "\r\n"
		}
	});
	const parser = new Parser(handler);
	parser.write(rawHtml);
	parser.end();


	let arr: Array<string> = new Array()
	const handler1 = helper.getEventCollector((error, actual: ESObject) => {
		if (error) {
			this.result = this.result + getContext().resourceManager.getStringByNameSync('Parse_fail') + "：" + JSON.stringify(error)
			return
		}

		if (actual.$event == "text") {
			arr.push(actual.data)
		}

		if (actual.$event == "end") {
			this.result += "callback:" + (JSON.stringify(arr)) + "\r\n"
		}
	});
	const parser1: Parser = new Parser(handler1);
	parser1.write("china <script type='text/javascript'>const foo = '<<bar>>';</script>",);
	parser1.end();

});
parser.write(html);
parser.end();
```

### 接口说明
单元测试用例详情见[TEST.md](https://gitcode.com/openharmony-tpc/openharmony_tpc_samples/blob/master/Domhandler/TEST.md)


## 约束与限制
在下述版本验证通过：

DevEco Studio 版本： 4.1 Canary(4.1.3.317),OpenHarmony SDK:API11 (4.1.0.36)。

DevEco Studio 版本：DevEco Studio 5.1.0 Canary1(5.1.0.229)，OpenHarmony SDK:5.1.0.229 API16（5.1.0.46）。

## 目录结构

```
|---- Domhandler  
|     |---- entry  # 示例代码文件夹
|     |---- README.MD  # 安装使用方法                   
|     |---- README_zh.MD  # 安装使用方法                   
```

## 贡献代码

使用过程中发现任何问题都可以提[Issue](https://gitcode.com/openharmony-tpc/openharmony_tpc_samples/issues) 给我们，当然，我们也非常欢迎你给我们提[PR](https://gitcode.com/openharmony-tpc/openharmony_tpc_samples/pulls)。

## 开源协议

本项目基于 [BSD License](https://gitcode.com/openharmony-tpc/openharmony_tpc_samples/blob/master/Domhandler/LICENSE)，请自由地享受和参与开源。

