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
import { Logger } from "../utils/Logger";
import { BusinessError } from "@ohos.base";
import { Input } from "@ohos/mammoth";

@Entry
@Component
struct ExtractRawText {
  @State md: string = '';
  private docxName = 'hello.docx';
  private docxName2 = 'longText.docx';
  private tempDocxName: string = "includeEmbeddedStyleMap.docx";
  private webSrc: string = "convert.html";
  private context: Context | undefined = this.getUIContext().getHostContext();
  private filesDir: string = this.context!.filesDir;
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
      }catch (error) {
        Logger.error("err:" + JSON.stringify(error));
        if (error instanceof Error) {
          throw error;
        } else {
          // 将其他类型转换为 Error
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

  convert(input?: Input) {
    mammoth.extractRawText(input)
      .then((result) => {
        this.md = result.value;
        this.dialogController?.open();
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
      console.error("Context is undefined.")
      return
    }
    try {
      let content = this.context.resourceManager.getRawFileContentSync(this.docxName);
      if (!content) {
        console.error("RawFile content  is undefined.")
        return
      }
      this.convert({ arrayBuffer: content.buffer })
    } catch (error) {
      Logger.error("err:" + JSON.stringify(error));
      if (error instanceof Error) {
        throw error;
      } else {
        // 将其他类型转换为 Error
        const errorMessage = typeof error === 'object' ? JSON.stringify(error) : String(error);
        throw new Error(errorMessage);
      }
    }

  }

  convert_longText() {
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
    } catch (error) {
      Logger.error("err:" + JSON.stringify(error));
      if (error instanceof Error) {
        throw error;
      } else {
        // 将其他类型转换为 Error
        const errorMessage = typeof error === 'object' ? JSON.stringify(error) : String(error);
        throw new Error(errorMessage);
      }
    }

  }

  build() {

    Column() {
      Text("ExtractRaw Test")
        .width("100%")
        .fontSize(30)
        .textAlign(TextAlign.Center)

      Text($r("app.string.extractRaw_path_text"))
        .width("100%")
        .margin({ top: 10 })
      Button("convert input with path")
        .margin({ top: 10 })
        .width("90%")
        .onClick(() => {
          this.convert_path();
        })

      Text($r("app.string.extractRaw_arraybuffer_text"))
        .width("100%")
        .margin({ top: 10 })
      Button("convert input with arraybuffer")
        .margin({ top: 10 })
        .width("90%")
        .onClick(() => {
          this.convert_arraybuffer();
        })
      Text($r("app.string.extractRaw_long_text"))
        .width("100%")
        .margin({ top: 10 })
      Button("long text")
        .margin({ top: 10 })
        .width("90%")
        .onClick(() => {
          this.convert_longText();
        })
    }
    .justifyContent(FlexAlign.Start)
    .alignItems(HorizontalAlign.Start)
    .padding(20)
    .width('100%')
  }
}