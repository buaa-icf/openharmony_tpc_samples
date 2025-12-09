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

@Entry
@Component
struct Index {

  build() {
    Column() {
      Text("Mammoth")
        .width("100%")
        .fontSize(30)
        .textAlign(TextAlign.Center)

      Button("Convert")
        .margin({ top: 10 })
        .width("90%")
        .onClick(() => {
          this.getUIContext().getRouter().pushUrl({
            url: "pages/Convert"
          })
        })

      Button("ConvertToHtml")
        .margin({ top: 10 })
        .width("90%")
        .onClick(() => {
          this.getUIContext().getRouter().pushUrl({
            url: "pages/ConvertToHtml"
          })
        })

      Button("ConvertToMarkdown")
        .margin({ top: 10 })
        .width("90%")
        .onClick(() => {
          this.getUIContext().getRouter().pushUrl({
            url: "pages/ConvertToMarkdown"
          })
        })

      Button("ExtractRawText")
        .margin({ top: 10 })
        .width("90%")
        .onClick(() => {
          this.getUIContext().getRouter().pushUrl({
            url: "pages/ExtractRawText"
          })
        })

      Button("ConvertImage")
        .margin({ top: 10 })
        .width("90%")
        .onClick(() => {
          this.getUIContext().getRouter().pushUrl({
            url: "pages/ConvertImage"
          })
        })

      Button("EmbedStyleMap")
        .margin({ top: 10 })
        .width("90%")
        .onClick(() => {
          this.getUIContext().getRouter().pushUrl({
            url: "pages/EmbedStyleMap"
          })
        })

      Button("TransformsAndUnderline")
        .margin({ top: 10 })
        .width("90%")
        .onClick(() => {
          this.getUIContext().getRouter().pushUrl({
            url: "pages/TransformsPage"
          })
        })

      Button("StyleMapping")
        .margin({ top: 10 })
        .width("90%")
        .onClick(() => {
          this.getUIContext().getRouter().pushUrl({
            url: "pages/styleMapping"
          })
        })
    }
    .padding(10)
    .height('100%')
    .width('100%')
  }
}