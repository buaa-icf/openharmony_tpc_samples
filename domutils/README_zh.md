# domutils

# 简介

domutils提供一个HTML/XML解析器，用于处理htmlparser2的dom的实用程序

## 下载安装

```
 ohpm install domhandler
 ohpm install domutils
 ohpm install @ohos/htmlparser2
```

OpenHarmony ohpm环境配置等更多内容，请参考[如何安装OpenHarmony ohpm](https://gitcode.com/openharmony-tpc/docs/blob/master/OpenHarmony_har_usage.md)



# 使用说明
```
import {
  append,
  appendChild,
  compareDocumentPosition,
  existsOne,
  filter,
  find,
  findAll,
  findOne,
  getAttributeValue,
  getChildren,
  getElementById,
  getElements,
  getElementsByTagName,
  getElementsByTagType,
  getInnerHTML,
  getName,
  getOuterHTML,
  getParent,
  getSiblings,
  hasAttrib,
  innerText,
  nextElementSibling,
  prependChild,
  prevElementSibling,
  removeElement,
  removeSubsets,
  replaceElement,
  textContent,
  uniqueSort,
} from 'domutils';
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
const markup = Array(21).join(
	"<?xml><tag1 id='asdf' class='class1'> <script>text</script> <!-- comment --> <tag2> text </tag1>");
let fixture = parseDocument(markup).children
let content: Array<string> = [];
let dom: Document = parseDocument(html);

const dom1 = parseDocument("<div><p><span></span></p><p></p></div>")
	.children[0] as Element;
let removeSubsetsResult: ChildNode[] = removeSubsets([dom1, dom1])

const markup1 = "<div><p><span></span></p><a></a></div>";
const dom2 = parseDocument(markup1).children[0] as Element;
const p = dom2.children[0] as Element;
const span = p.children[0];
const a = dom2.children[1];
let position = compareDocumentPosition(span, a)

let oldNodes: ChildNode[] = dom.children
let newNodes: ChildNode[] = uniqueSort(oldNodes)

let node = getElements({ id: "asdfs" }, fixture, true)

let node1: ChildNode | null = getElementById("asdf", fixture, true)

let elements = getElementsByTagName("tag2", fixture, true)

let elements2 = getElementsByTagType(ElementType.Script, fixture, true)

const dom3 = parseDOM(
	"<div><p><img/><object/></p><p></p></div>",
)[0] as Element;
const parents = dom3.children as Element[];
const image = parents[0].children[0];
removeElement(image);
this.addLog(content, `removeElement next = ${image.next}`);
this.addLog(content, `removeElement prev = ${image.prev}`);

let oldNodes2: ChildNode[] = dom.children
let firstNodeLength = dom.children.length
replaceElement(oldNodes2[0], oldNodes2[1]);

const dom4 = parseDOM(
	"<div><p><img/></p><p><object/></p></div>",
)[0] as Element;
const child = parseDOM("<span></span>")[0] as Element;
const parents2 = dom4.children as Element[];
appendChild(parents2[0], child);
appendChild(parents2[1], child);


const dom5 = parseDOM(
	"<div><p><img/></p><p><object/></p></div>",
)[0] as Element;
const child1 = parseDOM("<span></span>")[0] as Element;
const parents5 = dom5.children as Element[];
append(parents5[0].children[0], child1);
append(parents5[1].children[0], child1);

const dom6 = parseDOM(
	"<div><p><img/></p><p><object/></p></div>",
)[0] as Element;
const child2 = parseDOM("<span></span>")[0] as Element;
const parents3 = dom6.children as Element[];
prependChild(parents3[0], child2);
prependChild(parents3[1], child2);

const manyNodesWide = parseDocument(
	`<body>${"<div></div>".repeat(200)}Text</body>`,);
let nodes1 = filter((elem) => elem.type === ElementType.Tag, manyNodesWide)

const manyNodesWide1 = parseDocument(
	`<body>${"<div></div>".repeat(200)}Text</body>`).children;
let nodes2 = find(
	(elem) => elem.type === ElementType.Tag,
	manyNodesWide1,
	true,
	Infinity,
)

const manyNodesWide2 = parseDocument(
	`<body>${"<div></div>".repeat(200)}Text</body>`,);
let node3: ChildNode | null = findOne(
	(elem) => elem.name === "body",
	manyNodesWide2.children,
	true,
)
if (node3) {
	this.addLog(content, `findOne = ${node3.attributes.length}`);
}

const manyNodesWide3 = parseDocument(
	`<body>${"<div></div>".repeat(200)}Text</body>`).children;
this.addLog(content, `existsOne = ${existsOne((elem) => elem.name === "body", manyNodesWide3)}`);

const manyNodesWide4 = parseDocument(
	`<body>${"<div></div>".repeat(200)}Text</body>`).children;
this.addLog(content, `findAll = ${findAll((elem) => elem.name === "div", manyNodesWide4).length}`);

textContent(fixture[1])

getInnerHTML(fixture[1])

getOuterHTML(fixture[1])

innerText(fixture[1])

let element3: Element[] = getElementsByTagName('style', dom);
let getChildrenResult: ChildNode[] = getChildren(element3[0]);

let element4: Element[] = getElementsByTagName('style', dom);
let textResult: ParentNode | null = getParent(element4[0].children[0]);

const dom7 = parseDOM("<div><h1></h1><p><p><p></div>")[0] as Element;
this.addLog(content, `getSiblings = ${getSiblings(dom7.children[1]).length}`);

this.addLog(content, `getAttributeValue = ${getAttributeValue(
	parseDOM("<div class='test'>")[0] as Element,
"class",
)}`);

this.addLog(content, `hasAttrib = ${hasAttrib(parseDOM("textnode")[0] as never, "some-attrib")}`);

this.addLog(content, `getName = ${getName(parseDOM("<div>")[0] as Element)}`);

let element6: Element[] = getElementsByTagName('style', dom);
let textResult6: Element | null = nextElementSibling(element6[0]);

let element7: Element[] = getElementsByTagName('style', dom);
let textResult7: Element | null = prevElementSibling(element7[0]);

```

### 接口说明
单元测试用例详情见[TEST.md](https://gitcode.com/openharmony-tpc/openharmony_tpc_samples/blob/master/domutils/TEST.md)


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

使用过程中发现任何问题都可以提[Issue](https://gitcode.com/openharmony-tpc/openharmony_tpc_samples/issues) 给组件，当然，也非常欢迎给组件提[PR](https://gitcode.com/openharmony-tpc/openharmony_tpc_samples/pulls)。

## 开源协议

本项目基于 [BSD License](https://gitcode.com/openharmony-tpc/openharmony_tpc_samples/blob/master/domutils/LICENSE)，请自由地享受和参与开源。

