/**
 * MIT License
 *
 * Copyright (C) 2025 Huawei Device Co., Ltd.
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all
 * copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 */

import * as mammoth from "@ohos/mammoth";
import { WebDialog } from "../component/WebDialog";
import { Logger } from "../utils/Logger";
import { BaseElement, HyperlinkElement, ParagraphElement, RunElement, TextElement } from "../utils/Type";
import { deleteFile, writeFile } from "../utils/FileUtils";
import { BusinessError } from "@ohos.base";

@Entry
@Component
struct TransformsPage {
  @State md: string = "";
  private docxName = 'hello.docx';
  private webSrc: string = "result.html";
  private context: Context | undefined = this.getUIContext().getHostContext();
  private filesDir: string =  this.context!.filesDir;
  private inputDocx = this.filesDir + "/" + this.docxName;

  // 添加弹窗控制器
  dialogController: CustomDialogController = new CustomDialogController({
    builder: WebDialog({ src: this.filesDir + '/' + this.webSrc, md: this.md }),
    autoCancel: true,
    alignment: DialogAlignment.Center,
    customStyle: false,
    cornerRadius: 20,
    backgroundColor: Color.White,
    cancel: () => {
      deleteFile(this.filesDir + '/' + this.webSrc);
    },
  });

  underline(title: string, text: string) {
    try {
      let func: Function = mammoth.underline.element(title);
      Logger.log("underline result:" + JSON.stringify(func(text)));
      this.md = JSON.stringify(func(text));
      this.dialogController.open();
    } catch (e) {
      Logger.log("underline error:" + e);
    }
  }

  transformsParagraph() {
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

    // 应用转换规则
    mammoth.convertToHtml(
      { path: this.inputDocx },
      { transformDocument: transformDocument }
    ).then((result) => {
      Logger.info(`convertToHtml html: ${result.value}`);
      Logger.info(`convertToHtml messages: ${JSON.stringify(result.messages)}`);

      this.md = "";
      // 写入文件并显示弹窗
      writeFile(this.filesDir, this.webSrc, result.value);
      this.dialogController.open();

    })
      .catch((error: BusinessError) => {
        Logger.info(`convertToHtml html, error.message: ${error.message}`);
        Logger.info(`convertToHtml html, error.stack: ${JSON.stringify(error.message)}`);
      });
  }

  transformsRun() {
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

    // 应用转换规则
    mammoth.convertToHtml(
      { path: this.inputDocx },
      { transformDocument: transformDocument }
    ).then((result) => {
      Logger.info(`convertToHtml html: ${result.value}`);
      Logger.info(`convertToHtml messages: ${JSON.stringify(result.messages)}`);
      this.md = "";
      // 写入文件并显示弹窗
      writeFile(this.filesDir, this.webSrc, result.value);
      this.dialogController.open();
    })
      .catch((error: BusinessError) => {
        Logger.info(`convertToHtml html, error.message: ${error.message}`);
        Logger.info(`convertToHtml html, error.stack: ${JSON.stringify(error.message)}`);
      });
  }

  transformsOfType() {
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

    // 应用转换规则
    mammoth.convertToHtml(
      { path: this.inputDocx },
      { transformDocument: transformDocument }
    ).then((result) => {
      Logger.info(`convertToHtml html: ${result.value}`);
      Logger.info(`convertToHtml messages: ${JSON.stringify(result.messages)}`);
      this.md = "";
      // 写入文件并显示弹窗
      writeFile(this.filesDir, this.webSrc, result.value);
      this.dialogController.open();
    })
      .catch((error: BusinessError) => {
        Logger.info(`convertToHtml html, error.message: ${error.message}`);
        Logger.info(`convertToHtml html, error.stack: ${JSON.stringify(error.message)}`);
      });
  }

  transforms() {
    let Func = (Element: BaseElement): BaseElement => {
      // 获取所有后代元素
      const descendants: BaseElement[] = mammoth.transforms.getDescendants(Element);
      Logger.log(`Found ${descendants.length} descendants`);
      descendants.forEach((element: BaseElement) => {
        if (element.type === 'document') {
          Logger.log(`Found element: ${JSON.stringify(element)}`);
        }
      })

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

    // 应用转换规则
    mammoth.convertToHtml(
      { path: this.inputDocx },
      { transformDocument: transformDocument }
    ).then((result) => {
      Logger.info(`convertToHtml html: ${result.value}`);
      Logger.info(`convertToHtml messages: ${JSON.stringify(result.messages)}`);
      this.md = "";
      // 写入文件并显示弹窗
      writeFile(this.filesDir, this.webSrc, result.value);
      this.dialogController.open();
    })
      .catch((error: BusinessError) => {
        Logger.info(`convertToHtml html, error.message: ${error.message}`);
        Logger.info(`convertToHtml html, error.stack: ${JSON.stringify(error.message)}`);
      });
  }

  aboutToAppear(): void {
    if (this.context) {
      let content = this.context.resourceManager.getRawFileContentSync(this.docxName);
      if (content) {
        writeFile(this.context.filesDir, this.docxName,content.buffer);
      }
    }
  }

  aboutToDisappear(): void {
    deleteFile(this.filesDir + '/' + this.webSrc);
    deleteFile(this.filesDir + '/' + this.docxName);
  }

  build() {
    Column() {
      Button("Underline")
        .margin({ top: 10 })
        .onClick(() => {
          //创建了带有下划线标签的HTML元素
          this.underline("u", "下划线")
        })

      Button("TransformsParagraph")
        .margin({ top: 10 })
        .onClick(() => {
          //标题前添加[Modified]并将无序列表转为有序列表
          this.transformsParagraph()
        })
      Button("TransformsRun")
        .margin({ top: 10 })
        .onClick(() => {
          //加粗文本后添加[BOLD]并添加斜体样式
          this.transformsRun()
        })
      Button("TransformsOfType")
        .margin({ top: 10 })
        .onClick(() => {
          //文本前修改[text]
          this.transformsOfType()
        })
      Button("Transforms")
        .margin({ top: 10 })
        .onClick(() => {
          //修改超链接
          this.transforms()
        })
    }
    .height('100%')
    .width('100%')
  }
}