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
import { WebDialog } from "../component/WebDialog"
import { Logger } from "../utils/Logger";
import { BusinessError } from "@ohos.base";

const defaultStyleMap = `
    p[style-name='Heading 1'] => em
    p[style-name='Heading 2'] => em
    p[style-name='Heading 3'] => em
    p[style-name='Heading 4'] => em
    p[style-name='Heading 5'] => em
    p[style-name='Heading 6'] => em
  `;
@Entry
@Component
struct Index {
  @State html: string = '';
  @State md: string = '';
  private docxName = 'hello.docx';
  private webSrc: string = "index.html";
  private tempDocxName: string = "embedStyleMap.docx";
  private context: Context | undefined = this.getUIContext().getHostContext();
  private filesDir: string =  this.context!.filesDir;
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
      let content = this.context.resourceManager.getRawFileContentSync(this.docxName);
      if (content) {
        writeFile(this.context.filesDir, this.docxName,content.buffer);
      }else{
        Logger.error("get rawFile content error , message" + JSON.stringify(content))
      }
    }
  }

  aboutToDisappear(): void {
    deleteFile(this.filesDir + '/' + this.webSrc);
    deleteFile(this.filesDir + '/' + this.docxName);
    deleteFile(this.filesDir + '/' + this.tempDocxName);
  }

  convert(name: string) {
    mammoth.convertToHtml({ path: this.filesDir + '/' + name })
      .then((result) => {
        Logger.info(`convertToHtml html: ${result.value}`);
        Logger.info(`convertToHtml messages: ${JSON.stringify(result.messages)}`);
        writeFile(this.filesDir, this.webSrc, result.value);
        this.md = "";
        this.dialogController?.open();
      })
      .catch((error: BusinessError) => {
        Logger.error(`convertToHtml html, error.message: ${error.message}`);
        Logger.error(`convertToHtml html, error.stack: ${JSON.stringify(error.message)}`);
      });
  }

  convertToHtml(name: string) {
    mammoth.convertToHtml({ path: this.filesDir + '/' + name })
      .then((result) => {
        Logger.info(`convertToHtml html: ${result.value}`);
        Logger.info(`convertToHtml messages: ${JSON.stringify(result.messages)}`);
        writeFile(this.filesDir, this.webSrc, result.value);
        this.md = "";
        this.dialogController?.open();
      })
      .catch((error: BusinessError) => {
        Logger.error(`convertToHtml html, error.message: ${error.message}`);
        Logger.error(`convertToHtml html, error.stack: ${JSON.stringify(error.message)}`);
      });
  }

  convertToMarkdown(name: string) {
    mammoth.convertToMarkdown({ path: this.filesDir + '/' + name })
      .then((result) => {
        Logger.info(`convertToMarkdown html: ${result.value}`);
        Logger.info(`convertToMarkdown messages: ${JSON.stringify(result.messages)}`);
        this.md = result.value;
        this.dialogController?.open();
      })
      .catch((error: BusinessError) => {
        Logger.error(`convertToMarkdown html, error.message: ${error.message}`);
        Logger.error(`convertToMarkdown html, error.stack: ${JSON.stringify(error.message)}`);
      });
  }

  embedStyleMap(type: string) {

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
      .catch((error: BusinessError) => {
        Logger.error(`convertToHtml html, error.message: ${error.message}`);
        Logger.error(`convertToHtml html, error.stack: ${JSON.stringify(error.message)}`);
      });
  }

  readEmbeddedStyleMap(){
    mammoth.embedStyleMap({ path: this.filesDir + '/' + this.docxName }, defaultStyleMap)
      .then((docx) => {
        writeFile(this.filesDir, this.tempDocxName, docx.toArrayBuffer());
        mammoth.readEmbeddedStyleMap({path: this.filesDir + "/" + this.tempDocxName  }).then(
          (result) => {
            Logger.info(`readEmbeddedStyleMap  result: `+ result);
            this.md = `预期结果：${defaultStyleMap} \n\n\n 实际结果：${result.toString()}`;
            this.dialogController?.open();
          },
        ).catch((error: BusinessError) => {
          Logger.info(`readEmbeddedStyleMap, error.message: ${error.message}`);
          Logger.info(`readEmbeddedStyleMap, error.stack: ${JSON.stringify(error.message)}`);
        });
      })
      .catch((error: BusinessError) => {
        Logger.error(`readEmbeddedStyleMap, error.message: ${error.message}`);
        Logger.error(`readEmbeddedStyleMap, error.stack: ${JSON.stringify(error.message)}`);
      });
  }


  build() {
    Column() {
      Text("EmbedStyleMap Test")
        .width("100%")
        .fontSize(30)
        .margin({ bottom: 10})
        .textAlign(TextAlign.Center)

      Text($r("app.string.embedStyleMap_doc_text"))

      Button($r("app.string.embedStyleMap_parse_text"))
        .margin({ top: 30 })
        .width("90%")
        .onClick(() => {
          this.convertToHtml(this.docxName);
        })

      Text("convert")
        .fontSize(30)
        .width("90%")
        .margin({ bottom: 10, top: 30 })

      Button("convert")
        .margin({ top: 10 })
        .width("90%")
        .onClick(() => {
          this.embedStyleMap("convert");
        })

      Text("convertToHtml")
        .fontSize(30)
        .width("90%")
        .margin({ bottom: 10, top: 30 })

      Button("convertToHtml")
        .margin({ top: 10 })
        .width("90%")
        .onClick(() => {
          this.embedStyleMap("html");
        })

      Text("convertToMarkdown")
        .fontSize(30)
        .width("90%")
        .margin({ bottom: 10, top: 30 })

      Button("convertToMarkdown")
        .margin({ top: 10 })
        .width("90%")
        .onClick(() => {
          this.embedStyleMap("md");
        })

      Text($r("app.string.embedStyleMap_get_text"))
        .fontSize(20)
        .width("90%")
        .margin({ bottom: 10, top: 30 })

      Button("ReadEmbeddedStyleMap")
        .margin({ top: 10 })
        .width("90%")
        .onClick(() => {
          this.readEmbeddedStyleMap()
        })

    }
    .justifyContent(FlexAlign.Start)
    .alignItems(HorizontalAlign.Start)
    .padding(20)
    .height('100%')
    .width('100%')
  }
}