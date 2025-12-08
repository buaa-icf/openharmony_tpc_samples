# mammoth
## 简介

Mammoth旨在将.docx文档（例如由Microsoft Word、Google Docs和LibreOffice创建的文档）转换为HTML。Mammoth旨在通过利用文档中的语义信息生成简单且干净的HTML，同时忽略其他细节。例如，Mammoth会将任何使用“Heading 1”样式的段落转换为h1元素，而不是尝试精确复制标题的样式（字体、文字大小、颜色等）。

![showlottie](./screenshot/showlottie.gif)


## 下载安裝

```
 ohpm install @ohos/mammoth
```
OpenHarmony ohpm 环境配置等更多内容，请参考[如何安装 OpenHarmony ohpm 包](https://gitcode.com/openharmony-tpc/docs/blob/master/OpenHarmony_har_usage.md)

## 使用说明

```
导入依赖
import * as mammoth from "@ohos/mammoth";

//获取docx内容转换为html格式字符串
mammoth.convertToHtml(input, option)
      .then((result) => {
        if (!isTextShow) {
          this.md = "";
          writeFile(this.filesDir, this.webSrc, result.value);
          this.dialogController?.open();
        } else {
          this.md = result.value;
          this.dialogController?.open();
        }
      })
      .catch((error: ESObject) => {
        Logger.error(`convert html, error.message: ${error.message}`);
        Logger.error(`convert html, error.stack: ${JSON.stringify(error.message)}`);
      });
 
// 获取纯文本
mammoth.extractRawText(input)
      .then((result) => {
        this.md = result.value;
        this.dialogController?.open();
      })
      .catch((error: ESObject) => {
        Logger.error(`convert html, error.message: ${error.message}`);
        Logger.error(`convert html, error.stack: ${JSON.stringify(error.message)}`);
      });
      
//用嵌入映射规则修改原docx内容标签
mammoth.embedStyleMap({ path: this.filesDir + '/' + this.docxName }, defaultStyleMap)
      .then((docx) => {
        writeFile(this.filesDir, this.tempDocxName, docx.toArrayBuffer());
        if (type == 'convert') {
          this.convert(this.tempDocxName);
        }else if (type == 'html') {
          this.convertToHtml(this.tempDocxName);
        } else {
          this.convertToMarkdown(this.tempDocxName);
        }
      })
      .catch((error: ESObject) => {
        Logger.error(`convertToHtml html, error.message: ${error.message}`);
        Logger.error(`convertToHtml html, error.stack: ${JSON.stringify(error.message)}`);
      });

//获取docx内容转换为markdown格式字符串
mammoth.convertToMarkdown(input, option)
      .then((result) => {
        this.md = result.value;
        this.dialogController?.open();
      })
      .catch((error: ESObject) => {
        Logger.error(`convert html, error.message: ${error.message}`);
        Logger.error(`convert html, error.stack: ${JSON.stringify(error.message)}`);
      });

//获取docx内容转换为html格式字符串
mammoth.convert(input, option)
      .then((result) => {
        if (!isTextShow) {
          this.md = "";
          writeFile(this.filesDir, this.webSrc, result.value);
          this.dialogController?.open();
        } else {
          this.md = result.value;
          this.dialogController?.open();
        }
      })
      .catch((error: ESObject) => {
        Logger.error(`convert html, error.message: ${error.message}`);
        Logger.error(`convert html, error.stack: ${JSON.stringify(error.message)}`);
      });

// 获取嵌入映射规则
mammoth.embedStyleMap({ path: this.filesDir + '/' + this.docxName }, defaultStyleMap)
      .then((docx) => {
        writeFile(this.filesDir, this.tempDocxName, docx.toArrayBuffer());
        mammoth.readEmbeddedStyleMap({path: this.filesDir + "/" + this.tempDocxName  }).then(
          (result) => {
            Logger.info(`readEmbeddedStyleMap  result: `+ result);
            this.md = `预期结果：${defaultStyleMap} \n\n\n 实际结果：${result.toString()}`;
            this.dialogController?.open();
          },
        ).catch((error: ESObject) => {
          Logger.info(`readEmbeddedStyleMap, error.message: ${error.message}`);
          Logger.info(`readEmbeddedStyleMap, error.stack: ${JSON.stringify(error.message)}`);
        });
      })
      .catch((error: ESObject) => {
        Logger.error(`readEmbeddedStyleMap, error.message: ${error.message}`);
        Logger.error(`readEmbeddedStyleMap, error.stack: ${JSON.stringify(error.message)}`);
      });

//获取特定标签元素的函数
underline(title: string, text: string) {
    try {
      let func: Function = mammoth.underline.element(title);
      Logger.log("underline result:" + JSON.stringify(func(text)));
    } catch (e) {
      Logger.log("underline error:" + e);
    }
  }
  
//获取标签元素并进行修改
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

    // 创建转换规则
    //_elements是获取所有元素
    const transformDocument = mammoth.transforms._elements(Func);
```



## 接口说明

| 功能名称             | 功能描述                             |
| -------------------- | ------------------------------------ |
| convertToHtml        | 获取docx内容转换为html格式字符串     |
| extractRawText       | 获取纯文本                           |
| embedStyleMap        | 用嵌入映射规则修改原docx内容标签     |
| convertToMarkdown    | 获取docx内容转换为markdown格式字符串 |
| convert              | 获取docx内容转换为html格式字符串     |
| readEmbeddedStyleMap | 获取嵌入映射规则                     |
| underline            | 获取特定标签元素的函数               |
| transforms           | 获取标签元素并进行修改               |

## 约束与限制

在下述版本验证通过：
- DevEco Studio: DevEco Studio 6.0.1 Release(6.0.1.251), SDK: API12(5.0.0.71)

## 目录结构

````
/mammoth        # 项目根目录
├── entry      # 示例代码文件夹
├── library     # mammoth库文件夹
│    └─ src/main/ets
│       └─ docx 
│       └─ html 
│       └─ styles 
│       └─ writers 
│       └─ xml
│       └─index.d.ts    # 接口声明文档                     
├── README.md  # 安装使用方法                       
````

## 贡献代码

使用过程中发现任何问题都可以提交 [Issue]()，当然，也非常欢迎提交 [PR]() 。

## 开源协议

本项目遵循 [BSD-2-Clause](https://gitcode.com/ywp791322/ohos_mammoth/blob/main/LICENSE)。
