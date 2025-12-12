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
import { JSON } from "@kit.ArkTS";
import { deleteFile, writeFile } from "../utils/FileUtils";
import { WebDialog } from "../component/WebDialog";
import { Options } from "../utils/Type";
import { Logger } from "../utils/Logger";
import { BusinessError } from "@ohos.base";
import { Input } from "@ohos/mammoth";

@Entry
@Component
struct Index {
  @State md: string = '';
  private docxName = 'hello.docx';
  private docxName2 = 'longText.docx';
  private tempDocxName: string = "includeEmbeddedStyleMap.docx";
  private webSrc: string = "convert.html";
  private context: Context | undefined = this.getUIContext().getHostContext();
  private filesDir: string =  this.context!.filesDir;
  private inputDocx = this.filesDir + "/" + this.docxName;
  dialogController: CustomDialogController | null = new CustomDialogController({
    builder: WebDialog({
      src: this.filesDir + '/' + this.webSrc,
      md: this.md
    }),
    autoCancel: true,
    alignment: DialogAlignment.Center,
    customStyle: false,
    cornerRadius: 20,
    backgroundColor: Color.White,
    cancel: () => {
      deleteFile(this.filesDir + '/' + this.webSrc);
    },
    shadow: ({
      radius: 20,
      color: Color.Grey,
      offsetX: 50,
      offsetY: 0
    }),
  });

  aboutToAppear(): void {
    if (this.context) {
      try {
        let content = this.context.resourceManager.getRawFileContentSync(this.docxName);
        if (content) {
          writeFile(this.context.filesDir, this.docxName, content.buffer);
        } else {
          Logger.error("get rawFile content error , message" + JSON.stringify(content))
        }
      } catch (error) {
        Logger.error('err:' + JSON.stringify(error));
        if (error instanceof Error) {
          throw error;
        } else {
          const errorMessage = typeof error === 'object' ? JSON.stringify(error) : String(error);
          throw new Error(errorMessage);
        }
      }

    }
  }

  aboutToDisappear(): void {
    deleteFile(this.filesDir + '/' + this.webSrc);
    deleteFile(this.filesDir + '/' + this.tempDocxName);
    deleteFile(this.filesDir + '/' + this.docxName);
  }

  convert(input?: Input, option?: Options, isTextShow?: boolean) {
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
      .catch((error: BusinessError) => {
        Logger.error(`convert html, error.message: ${error.message}`);
        Logger.error(`convert html, error.stack: ${JSON.stringify(error.message)}`);
      });
  }

  // 通过路径解析
  convert_path() {
    this.convert({ path: this.inputDocx });
  }

  // 通过arraybuffer解析
  convert_arraybuffer() {
    if (!this.context) {
      Logger.error("Context is undefined.")
      return
    }
    try {
      let content = this.context.resourceManager.getRawFileContentSync(this.docxName);
      if (!content) {
        Logger.error("RawFile content  is undefined.")
        return
      }
      this.convert({ arrayBuffer: content.buffer })
    } catch (error) {
      Logger.error('err:' + JSON.stringify(error));
      if (error instanceof Error) {
        throw error;
      } else {
        const errorMessage = typeof error === 'object' ? JSON.stringify(error) : String(error);
        throw new Error(errorMessage);
      }
    }

  }

  //  自定义styleMap
  convert_styleMap() {
    let styleMap = [
      "b => em", // 加粗
      "i => u", // 斜体
      "u => del", // 下划线
      "strike => b", // 删除线
      `p[style-name='Heading 1'] => b`, // 标题一
    ]
    this.convert({ path: this.inputDocx }, { styleMap: styleMap });
  }

  // 禁用includeEmbeddedStyleMap(控制文档中嵌入的样式映射的处理方式)
  convert_includeEmbeddedStyleMap_false() {
    const defaultStyleMap = `
      p[style-name='Heading 1'] => em
      p[style-name='Heading 2'] => em
      p[style-name='Heading 3'] => em
      p[style-name='Heading 4'] => em
      p[style-name='Heading 5'] => em
      p[style-name='Heading 6'] => em
    `;

    mammoth.embedStyleMap({ path: this.inputDocx }, defaultStyleMap)
      .then((docx) => {
        writeFile(this.filesDir, this.tempDocxName, docx.toArrayBuffer());
        this.convert({ path: this.filesDir + '/' + this.tempDocxName },
          { includeEmbeddedStyleMap: false });
      })
      .catch((error: BusinessError) => {
        Logger.error(`convert html, error.message: ${error.message}`);
        Logger.error(`convert html, error.stack: ${JSON.stringify(error.message)}`);
      });
  }

  // 禁用includeEmbeddedStyleMap(控制文档中嵌入的样式映射的处理方式)
  convert_includeEmbeddedStyleMap_true() {
    const defaultStyleMap = `
      p[style-name='Heading 1'] => em
      p[style-name='Heading 2'] => em
      p[style-name='Heading 3'] => em
      p[style-name='Heading 4'] => em
      p[style-name='Heading 5'] => em
      p[style-name='Heading 6'] => em
    `;

    mammoth.embedStyleMap({ path: this.inputDocx }, defaultStyleMap)
      .then((docx) => {
        writeFile(this.filesDir, this.tempDocxName, docx.toArrayBuffer());
        this.convert({ path: this.filesDir + '/' + this.tempDocxName },
          { includeEmbeddedStyleMap: true });
      })
      .catch((error: BusinessError) => {
        Logger.error(`convert html, error.message: ${error.message}`);
        Logger.error(`convert html, error.stack: ${JSON.stringify(error.message)}`);
      });
  }

  // 禁用includeDefaultStyleMap(控制默认的样式映射的处理方式)
  convert_includeDefaultStyleMap_false() {
    this.convert({ path: this.inputDocx }, { includeDefaultStyleMap: false });
  }

  // 启用includeDefaultStyleMap(控制默认的样式映射的处理方式)
  convert_includeDefaultStyleMap_true() {
    this.convert({ path: this.inputDocx }, { includeDefaultStyleMap: true });
  }

  // 禁用忽略空白段落
  convert_ignoreEmptyParagraphs_false() {
    if (!this.context) {
      Logger.error("Context is undefined.")
      return
    }
    try {
      let content = this.context.resourceManager.getRawFileContentSync("ignoreEmptyParagraphs.docx");
      if (!content) {
        Logger.error("RawFile content  is undefined.")
        return
      }
      this.convert({ arrayBuffer: content.buffer }, { ignoreEmptyParagraphs: false }, true);
    } catch (error) {
      Logger.error('err:' + JSON.stringify(error));
      if (error instanceof Error) {
        throw error;
      } else {
        const errorMessage = typeof error === 'object' ? JSON.stringify(error) : String(error);
        throw new Error(errorMessage);
      }
    }

  }

  // 开启忽略空白段落
  convert_ignoreEmptyParagraphs_true() {
    if (!this.context) {
      Logger.error("Context is undefined.")
      return
    }
    try {
      let content = this.context.resourceManager.getRawFileContentSync("ignoreEmptyParagraphs.docx");
      if (!content) {
        Logger.error("RawFile content  is undefined.")
        return
      }
      this.convert({ arrayBuffer: content.buffer }, { ignoreEmptyParagraphs: true }, true);
    } catch (error) {
      Logger.error('err:' + JSON.stringify(error));
      if (error instanceof Error) {
        throw error;
      } else {
        const errorMessage = typeof error === 'object' ? JSON.stringify(error) : String(error);
        throw new Error(errorMessage);
      }
    }

  }

  // 为 自动生成的 HTML ID 添加前缀
  convert_idPrefix_unset() {
    this.convert({ path: this.inputDocx }, {}, true);
  }

  // 为 自动生成的 HTML ID 添加前缀
  convert_idPrefix() {
    this.convert({ path: this.inputDocx }, { idPrefix: "hhhh-" }, true);
  }

  // 不允许访问文件系统来读取外部文件
  convert_externalFileAccess_false() {
    if (!this.context) {
      Logger.error("Context is undefined.")
      return
    }
    try {
      let content = this.context.resourceManager.getRawFileContentSync("externalFile.docx");
      if (!content) {
        Logger.error("RawFile content  is undefined.")
        return
      }
      this.convert({ arrayBuffer: content.buffer }, { externalFileAccess: false });
    }catch (error) {
      Logger.error('err:' + JSON.stringify(error));
      if (error instanceof Error) {
        throw error;
      } else {
        const errorMessage = typeof error === 'object' ? JSON.stringify(error) : String(error);
        throw new Error(errorMessage);
      }
    }

  }

  // 允许访问文件系统来读取外部文件
  convert_externalFileAccess_true() {
    if (!this.context) {
      Logger.error("Context is undefined.")
      return
    }
    try {
      let content = this.context.resourceManager.getRawFileContentSync("externalFile.docx");
      if (!content) {
        Logger.error("RawFile content  is undefined.")
        return
      }
      this.convert({ arrayBuffer: content.buffer }, { externalFileAccess: true });
    }catch (error) {
      Logger.error('err:' + JSON.stringify(error));
      if (error instanceof Error) {
        throw error;
      } else {
        const errorMessage = typeof error === 'object' ? JSON.stringify(error) : String(error);
        throw new Error(errorMessage);
      }
    }

  }

  // 长文本测试
  convert_longText(){
    if (!this.context) {
      console.error("Context is undefined.")
      return
    }
    try {
      let content = this.context.resourceManager.getRawFileContentSync(this.docxName2);
      if (!content) {
        console.error("RawFile content  is undefined.")
        return
      }
      this.convert({ arrayBuffer: content.buffer })
    }catch (error) {
      Logger.error('err:' + JSON.stringify(error));
      if (error instanceof Error) {
        throw error;
      } else {
        const errorMessage = typeof error === 'object' ? JSON.stringify(error) : String(error);
        throw new Error(errorMessage);
      }
    }

  }

  build() {
    Scroll() {
      Column() {
        Text("Convert Test")
          .width("100%")
          .fontSize(30)
          .textAlign(TextAlign.Center)

        Column() {
          Text("Input")
            .fontSize(20)
            .margin({ bottom: 10 })

          Button("input with path")
            .margin({ top: 10 })
            .width("90%")
            .onClick(() => {
              this.convert_path();
            })

          Button("input with arraybuffer")
            .margin({ top: 10 })
            .width("90%")
            .onClick(() => {
              this.convert_arraybuffer();
            })
        }

        Column() {
          Text("Option")
            .fontSize(20)
            .margin({ bottom: 10, top: 10 })

          Text($r("app.string.convert_styleMap_text"))
            .width("100%")
            .margin({ bottom: 10, top: 10 })
          Button("styleMap")
            .margin({ top: 10 })
            .width("90%")
            .onClick(() => {
              this.convert_styleMap();
            })

          Text($r("app.string.convert_includeEmbeddedStyleMap_text"))
            .margin({ bottom: 10, top: 10 })
          Button("includeEmbeddedStyleMap false")
            .margin({ top: 10 })
            .width("90%")
            .onClick(() => {
              this.convert_includeEmbeddedStyleMap_false();
            })

          Button("includeEmbeddedStyleMap true")
            .margin({ top: 10 })
            .width("90%")
            .onClick(() => {
              this.convert_includeEmbeddedStyleMap_true();
            })

          Text($r("app.string.convert_includeDefaultStyleMap_text"))
            .margin({ bottom: 10, top: 10 })
          Button("includeDefaultStyleMap false")
            .margin({ top: 10 })
            .width("90%")
            .onClick(() => {
              this.convert_includeDefaultStyleMap_false();
            })

          Button("includeDefaultStyleMap true")
            .margin({ top: 10 })
            .width("90%")
            .onClick(() => {
              this.convert_includeDefaultStyleMap_true();
            })

          // convertImage已提供额外的页面测试

          Text($r("app.string.convert_ignoreEmptyParagraphs_text"))
            .margin({ bottom: 10, top: 10 })
          Button("ignoreEmptyParagraphs false")
            .margin({ top: 10 })
            .width("90%")
            .onClick(() => {
              this.convert_ignoreEmptyParagraphs_false();
            })

          Button("ignoreEmptyParagraphs true")
            .margin({ top: 10 })
            .width("90%")
            .onClick(() => {
              this.convert_ignoreEmptyParagraphs_true();
            })

          Text($r("app.string.convert_idPrefix_text"))
            .margin({ bottom: 10, top: 10 })
          Button("idPrefix unset ")
            .margin({ top: 10 })
            .width("90%")
            .onClick(() => {
              this.convert_idPrefix_unset();
            })

          Button("idPrefix set")
            .margin({ top: 10 })
            .width("90%")
            .onClick(() => {
              this.convert_idPrefix();
            })

          Text($r("app.string.convert_externalFileAccess_text"))
            .margin({ bottom: 10, top: 10 })
          Button("externalFileAccess false ")
            .margin({ top: 10 })
            .width("90%")
            .onClick(() => {
              this.convert_externalFileAccess_false();
            })

          Button("externalFileAccess true")
            .margin({ top: 10 })
            .width("90%")
            .onClick(() => {
              this.convert_externalFileAccess_true();
            })

          Text($r("app.string.convert_long_text"))
            .width("100%")
            .margin({ bottom: 10, top: 10 })
          Button("long text")
            .margin({ top: 10 })
            .width("90%")
            .onClick(() => {
              this.convert_longText();
            })

          //transformDocument已提供额外的页面测试
        }
      }
      .justifyContent(FlexAlign.Start)
      .alignItems(HorizontalAlign.Start)
      .padding(20)
      .width('100%')
    }
    .scrollable(ScrollDirection.Vertical)
    .width('100%')
  }
}