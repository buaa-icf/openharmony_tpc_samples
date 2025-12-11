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
import fs from '@ohos.file.fs';
import { WebDialog } from "../component/WebDialog";
import { deleteFile, writeFile } from "../utils/FileUtils";
import { Logger } from "../utils/Logger";
import { BusinessError } from "@ohos.base";

const TAG = `[mammoth]: `;

@Entry
@Component
struct StyleMapping {
  private context: Context | undefined = this.getUIContext().getHostContext();
  @State md: string = '';
  private docxName = 'hello.docx';
  private webSrc: string = "index1.html";
  private filesDir: string =  this.context!.filesDir;
  private inputDocx = this.filesDir + "/" + this.docxName;

  @State html: string = '';

  dialogController: CustomDialogController | null = new CustomDialogController({
    builder: WebDialog({ src: this.filesDir + '/' + this.webSrc, md: this.md }),
    autoCancel: true,
    alignment: DialogAlignment.Center,
    customStyle: false,
    cornerRadius: 20,
    backgroundColor: Color.White,
    cancel: () => {
      deleteFile(this.filesDir + '/'+this.webSrc);
    },
    shadow: ({
      radius: 20,
      color: Color.Grey,
      offsetX: 50,
      offsetY: 0
    }),
  });

  // 使<h1>变为自定义的<...>
  styleMap: string[] = [
    "p[style-name='Heading 1'] => u:fresh",
    "p[style-name='Heading 2'] => s:fresh",
    "p[style-name='Heading 3'] => u:fresh",
    "p[style-name='Heading 4'] => s:fresh",
    "p[style-name='Heading 5'] => u:fresh",
    "p[style-name='Heading 6'] => s:fresh",
    "p:unordered-list(1) => strong > li:fresh",
    "r[style-name='Hyperlink'] => em",
    "u => s",
    "i => u",
    "strike => em",
    "b => s",
    "p => s",
  ]

  convertToHtml() {
    mammoth.convertToHtml({ path: this.inputDocx}, {styleMap: this.styleMap})
      .then((result) => {
        this.html = result.value; // The generated HTML
        let messages = result.messages; // Any messages, such as warnings during conversion
        console.info(`${TAG} convertToHtml html: ${this.html}`);
        console.info(`${TAG} convertToHtml messages: ${JSON.stringify(messages)}`)

        writeFile(this.filesDir, this.webSrc, result.value);
        this.dialogController?.open();
      })

      .catch((error: BusinessError) => {
        console.error(`${TAG} convertToHtml html, error.message: ${error.message}`);
        console.error(`${TAG} convertToHtml html, error.stack: ${JSON.stringify(error.message)}`);
      });
  }

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
    deleteFile(this.inputDocx);
  }

  build() {
    Column() {

      Button("convertToHtml")
        .onClick(() => {
          this.convertToHtml();
        })

    }
    .height('100%')
    .width('100%')
  }
}