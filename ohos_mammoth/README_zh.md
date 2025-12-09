# mammoth
## 简介

Mammoth旨在将.docx文档（例如由Microsoft Word创建的文档）转换为HTML。Mammoth旨在通过利用文档中的语义信息生成简单且干净的HTML，同时忽略其它细节。例如，Mammoth会将任何使用“Heading 1”样式的段落转换为h1元素，而不是尝试精确复制标题的样式（字体、文字大小、颜色等）。


## 下载安裝

```
 ohpm install @ohos/mammoth
```
OpenHarmony ohpm 环境配置等更多内容，请参考[如何安装 OpenHarmony ohpm 包](https://gitcode.com/openharmony-tpc/docs/blob/master/OpenHarmony_har_usage.md)。

## 使用示例
注意： path为沙箱路径<br/>
1. 获取docx内容转换为html格式字符串。
```typescript
import * as mammoth from "@ohos/mammoth";

mammoth.convertToHtml({ path: fileDir + "path/to/document.docx" })
      .then((result) => {
        let html: string =  result.value;
        let message: string =  result.message;
      })
      .catch((error: ESObject) => {
        // ... convert error
      });
```

2. 获取纯文本。
```typescript
import * as mammoth from "@ohos/mammoth";

mammoth.extractRawText({ path: sanBoxFileDir + "path/to/document.docx" })
  .then((result) => {
    let html: string =  result.value;
    let message: string =  result.message;
  })
  .catch((error: ESObject) => {
    // ... convert error
  });
```

3.自定义styleMap。
```typescript
import * as mammoth from "@ohos/mammoth";

const styleMap: string[] = [
  "strike => em",
]
mammoth.convertToHtml({ path: sanBoxFileDir + "path/to/document.docx" }, {styleMap: this.styleMap})
  .then((result) => {
    let html: string =  result.value;
    let message: string =  result.message;
  })
  .catch((error: ESObject) => {
    // ... convert error
  });
```
## 使用说明

### 基本转换
#### convertToHtml
要将现有的 .docx 文件转换为 HTML，请使用mammoth.convertToHtml。  
```typescript
import * as mammoth from "@ohos/mammoth";
mammoth.convertToHtml({path: sanBoxFileDir + "path/to/document.docx"})
    .then(function(result){
      let html: string =  result.value;
      let message: string =  result.message;
    })
    .catch(function(error) {
        console.error(error);
    });
```

#### extractRawText
可以使用以下方法提取文档的原始文本mammoth.extractRawText。这将忽略文档中的所有格式。每个段落后都以两个换行符结尾。
```typescript
import * as mammoth from "@ohos/mammoth";
mammoth.extractRawText({path: sanBoxFileDir + "path/to/document.docx"})
    .then((result) =>{
      let html: string =  result.value;
      let message: string =  result.message;
    })
    .catch((error: BusinessError) => {
        console.error(error);
    });
```

#### convertToMarkdown
获取docx内容转换为markdown格式字符串。Markdown 支持已弃用。建议生成 HTML，然后使用其它库将 HTML 转换为 Markdown，这样可能会产生更好的结果。
```typescript
import * as mammoth from "@ohos/mammoth";
mammoth.convertToMarkdown(input, option)
      .then((result) => {
        let html: string =  result.value;
        let message: string =  result.message;
      })
      .catch((error: BusinessError) => {
        console.error(error);
      });
```

### 样式映射
默认情况下，Mammoth 会将一些常见的 .docx 样式映射到 HTML 元素。例如，具有特定样式名称的段落Heading 1会被转换为 `<style>`元素。可以通过传递一个包含 `stylemap`属性的选项对象作为第二个参数，h1来传入自定义样式映射。样式映射的语法说明请参见“编写样式映射”部分。

#### 自定义样式映射
```typescript
import * as mammoth from "@ohos/mammoth";

const options = {
    styleMap: [
        "p[style-name='Section Title'] => h1:fresh",
        "p[style-name='Subsection Title'] => h2:fresh"
    ]
};
mammoth.convertToHtml({path: sanBoxFileDir + "path/to/document.docx"}, options);
```

用户自定义样式映射优先于默认样式映射。要完全停止使用默认样式映射，请options.includeDefaultStyleMap设置false。

```typescript
const options = {
    styleMap: [
        "p[style-name='Section Title'] => h1:fresh",
        "p[style-name='Subsection Title'] => h2:fresh"
    ],
    includeDefaultStyleMap: false
};
```

#### 生成一个嵌入了传入样式映射的新docx文件
给定一个现有的 docx 文件， embedStyleMap该函数会生成一个嵌入了传入样式映射的新 docx 文件。当 Mammoth 读取这个新 docx 文件时，它将使用嵌入的样式映射。

```typescript

const styleMap: string[] = [
  "p[style-name='Heading 1'] => u:fresh",
  "p[style-name='Heading 2'] => s:fresh",
  "p[style-name='Heading 3'] => u:fresh"
]
mammoth.embedStyleMap({ path: sanBoxFileDir + "path/to/document.docx" }, styleMap)
  .then((docx) => {
    // 将新 docx 文件文件写入沙箱路径
    let file = fs.openSync(destinationPath, fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE);
    fs.writeSync(file.fd, content);
    fs.closeSync(file.fd);
  })
  .catch((error: BusinessError) => {
    console.error(error);
  });
```

#### 读取docx文件的样式映射
如果一个docx文件包含样式映射，可通过readEmbeddedStyleMap获取。
```typescript
 mammoth.readEmbeddedStyleMap({path: sanBoxFileDir + "path/to/document.docx"  })
  .then((result) => {
    let styleMap: string = result.toString();
  })
  .catch((error: ESObject) => {
    console.error(error);
  });
```

### 自定义图像处理器
可以通过调用 `image.converter` 函数来创建图像转换器mammoth.images.imgElement(func)。这将为<img>原始 docx 文件中的每个图像创建一个 `image` 元素。`image.converter` func应该是一个接受一个参数的函数image。该参数是要转换的图像元素，并具有以下属性：
- contentType：图像的内容类型，例如image/png。<br/>
- readAsArrayBuffer()：读取图像文件作为对象ArrayBuffer。返回一个 Promise 对象ArrayBuffer。<br/>
- readAsBase64String()：将图像文件读取为 base64 编码的字符串。返回一个 Promise 对象string。<br/>
- read([encoding])（已弃用）：使用指定的编码读取图像文件。如果指定了编码，string则返回一个 Promise 对象。如果未指定编码，Buffer则返回一个 Promise 对象。<br/>

```typescript
let option: Options = {
    convertImage: mammoth.images.imgElement((image) => {
      return image.readAsBase64String().then((base64) => {
        // 对图像内容进行处理
        let srcData: SrcData = {
          src: "data:" + image.contentType + ";base64," + base64
        }
        return srcData
      })
    })
}

mammoth.convert({ path: this.inputDocx}, options)
  .then((result) => {
    let html: string =  result.value;
  })
  .catch((error: BusinessError) => {
    // ... error handler
  });
```

### 文档转换
Mammoth 允许在转换文档之前对其进行转换。例如，假设文档尚未进行语义标记，但知道任何居中对齐的段落都应该是标题。可以使用参数transformDocument对文档进行相应的修改。<br/>
返回值transformDocument用于 HTML 生成。

#### mammoth.transforms.paragraph(transformParagraph)
返回一个可作为transformDocument选项使用的函数。该函数会应用于transformParagraph每个段落元素， transformParagraph并返回新的段落。
```typescript
// 获取标签元素并进行修改。
let paragraphFunc = (paragraphElement: ParagraphElement): ParagraphElement => {
  // 修改标题内容
  if (paragraphElement.styleName && paragraphElement.styleName.includes("heading")) {
    if (paragraphElement.children && paragraphElement.children.length > 0) {
      const firstRun = paragraphElement.children[0];
      if (firstRun.children && firstRun.children.length > 0) {
        const firstText = firstRun.children[0] as TextElement;
        if (firstText.type === "text" && firstText.value) {
          firstText.value = "[Modified] " + firstText.value;
        }
      }
    }
  }

  // 将无序列表转为有序列表
  if (paragraphElement.numbering && !paragraphElement.numbering.isOrdered) {
    paragraphElement.numbering.isOrdered = true;
  }

  return paragraphElement;
};

// 创建转换规则
const transformDocument = mammoth.transforms.paragraph(paragraphFunc);
```

#### mammoth.transforms.run(transformRun)
返回一个可作为transformDocument选项使用的函数。该函数将应用于transformRun每个运行元素， transformRun并返回新的运行结果。
```
let runFunc = (runElement: RunElement): RunElement => {
  // 修改加粗文本
  if (runElement.isBold) {
    runElement.isItalic = true;
    if (runElement.children && runElement.children.length > 0) {
      const firstChild = runElement.children[0] as TextElement;
      if (firstChild.type === "text" && firstChild.value) {
        firstChild.value = firstChild.value + " [BOLD]";
      }
    }
  }
  return runElement;
};
// 创建转换规则
const transformDocument = mammoth.transforms.run(runFunc);
    
```

####  mammoth.transforms._elementsOfType
```
let Func = (Element: BaseElement): BaseElement => {
      // 修改文本
      if (Element.type === "text") {
        let textElement = Element as TextElement;
        textElement.value =  "[文本]";
        return textElement;
      }
      return Element;
    };
    // 创建转换规则
    //_elementsOfType是获取指定元素
    const transformDocument = mammoth.transforms._elementsOfType("text",Func);
```

####  mammoth.transforms.getDescendants(element) && mammoth.transforms.getDescendantsOfType(element, type)
```
let Func = (Element: BaseElement): BaseElement => {
  // 获取所有后代元素
  const descendants: BaseElement[] = mammoth.transforms.getDescendants(Element);
  Logger.log(`Found ${descendants.length} descendants`);

  // 获取特定类型的后代元素
  const hyperlinkElements: BaseElement[] = mammoth.transforms.getDescendantsOfType(Element, "hyperlink");
  hyperlinkElements.forEach((element: BaseElement) => {
    let hyperlinkElement = element as HyperlinkElement;
    Logger.log(`Found hyperlink: ${JSON.stringify(hyperlinkElement)}`);
  });

  // 对hyperlink元素进行处理
  if (Element.type === "hyperlink") {
    const hyperlinkElement = Element as HyperlinkElement;
    if (hyperlinkElement.href) {
      hyperlinkElement.href = "https://gitcode.com/gh_mirrors/ma/mammoth.js";
    }
  }

  return Element;
};

// 创建转换规则，_elements是获取所有元素
const transformDocument = mammoth.transforms._elements(Func);
```

### 获取特定标签元素的函数

```typescript
 //获取下划线标签元素
 mammoth.underline.element("u");
```


## 接口说明
接口

| 功能名称                 | 入参内容                                                 | 功能描述                      |
|----------------------|------------------------------------------------------|---------------------------|
| convertToHtml        | (input: Input, options?: Options) => Promise<Result> | 获取docx内容转换为html格式字符串。     |
| extractRawText       | (input: Input) => Promise<Result>                    | 获取纯文本。                    |
| embedStyleMap        | (input: Input, styleMap: string) => Promise<any>;    | 用嵌入映射规则修改原docx内容标签。       |
| convertToMarkdown    | (input: Input, options?: Options) => Promise<Result> | 获取docx内容转换为markdown格式字符串。 |
| convert              | (input: Input, options?: Options) => Promise<Result> | 获取docx内容转换为html格式字符串。     |
| readEmbeddedStyleMap | (input: Input) => Promise<Result>                    | 获取嵌入映射规则。                 |
| underline            | (name: string) => (html: any)                        | 获取特定标签元素的函数。              |
| transforms           | Transforms                                           | 获取标签元素并进行修改。              |


Input

| 功能名称        | 入参内容        | 功能描述                  |
|-------------|-------------|-----------------------|
| path        | string      | 是 .docx 文件所在的沙箱路径。    |
| arrayBuffer | ArrayBuffer | 是一个包含 .docx 文件的数组缓冲区。 |

Options

| 类型名称                  | 入参内容                    | 功能描述                                                                                      |
|-------------------------|-------------------------|-------------------------------------------------------------------------------------------|
| styleMap                | string or Array<string> | 控制 Word 样式到 HTML 的映射。                                                                     |
| includeEmbeddedStyleMap | boolean                 | 默认情况下，如果文档包含嵌入式样式映射，则会将其与默认样式映射合并。要忽略任何嵌入式样式映射，请将其设置options.includeEmbeddedStyleMap为false。 |
| includeDefaultStyleMap  | boolean                 | 默认情况下，传入的样式映射styleMap会与默认样式映射合并。要完全停止使用默认样式映射，请将其设置options.includeDefaultStyleMap为false。  |
| convertImage            | ImageConverter          | 默认情况下，图像会被转换为`<img>`元素，并将源信息内联包含在src属性中。启用此选项可使图像转换器覆盖默认行为。                                 |
| ignoreEmptyParagraphs   | boolean                 | 默认情况下，空段落会被忽略。启用此选项可false在输出中保留空段落。                                                       |
| idPrefix                | string                  | 要添加到任何生成的 ID 前面的字符串，例如书签、脚注和尾注使用的 ID。默认为空字符串。                                             |
| externalFileAccess      | boolean                 | 源文档可能引用源文档外部的文件。                                                                          |
| transformDocument       | (element: any) => any   | 此函数将应用于从 docx 文件读取的文档，然后再转换为 HTML。文档转换 API 尚不稳定。                                          |


## 约束与限制

在下述版本验证通过：
- DevEco Studio: DevEco Studio 6.0.1 Release(6.0.1.251), SDK: API12(5.0.0.71)

## 目录结构

````
/mammoth              # 项目根目录
├── entry             # 示例代码文件夹
├── library           # mammoth库文件夹
│    └─ src/main/ets
│       └─ docx       # docx核心处理代码
│       └─ html       # html核心处理代码
│       └─ styles     # styles核心处理代码
│       └─ writers 
│       └─ xml
│       └─index.d.ts    # 接口声明文档    
│       └─ lop  # lop库代码                  
├── README.md  # 安装使用方法                       
````

## 贡献代码

使用过程中发现任何问题都可以提交 [Issue](https://gitcode.com/openharmony-tpc/openharmony_tpc_samples/issues)，当然，也非常欢迎提交 [PR](https://gitcode.com/openharmony-tpc/openharmony_tpc_samples/pulls) 。

## 开源协议

本项目遵循 [BSD-2-Clause](https://gitcode.com/openharmony-tpc/openharmony_tpc_samples/blob/master/ohos_mammoth/LICENSE)， 请自由的享受和参与开源。
