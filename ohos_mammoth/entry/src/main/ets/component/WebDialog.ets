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

import { webview } from "@kit.ArkWeb";

@CustomDialog
export struct WebDialog {
  @State src: string = '';
  @State md: string = '';
  controllerTwo?: CustomDialogController;
  private controller: WebviewController = new webview.WebviewController();

  build() {
    Column() {
      if (!this.md) {
        Web({ src: this.src, controller: this.controller })
          .javaScriptAccess(true)  // 允许JavaScript执行
          .fileAccess(true) // 允许访问本地文件
          .textZoomRatio(300)
      } else {
        TextArea({ text: this.md})
      }
    }
    .padding(20)
    .width("100%")
    .height(600)
  }
}