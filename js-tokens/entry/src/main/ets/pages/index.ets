/*
 * Copyright (C) 2021 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import jsTokens, { Token } from 'js-tokens'

interface Option {
  jsx: boolean
}

@Entry
@Component
struct Index {
  @State message: string = 'Hello World'
  scroller: Scroller = new Scroller();
  controller: TextAreaController = new TextAreaController();
  @State setValue: string = '';
  @State resultStr: string = '';

  exclResult(content: string) {
    let option: Option = { jsx: true }
    let result: Token[] = Array.from(jsTokens(content));
    this.resultStr = JSON.stringify(result);
  }

  build() {
    Stack({ alignContent: Alignment.TopStart }) {
      Scroll(this.scroller) {
        Column() {
          Text($r('app.string.Text_String1'))
            .width('90%')
            .height(100)
            .borderRadius(15)
            .fontSize(15)
            .textAlign(TextAlign.Center)
            .margin({ top: 10 })

          Text("Result:" + this.resultStr)
            .width('90%')
            .borderRadius(15)
            .fontSize(13)
            .textAlign(TextAlign.Start)
            .margin({ top: 10, bottom: 10 })

          TextArea({ placeholder: $r('app.string.Input_string'), controller: this.controller })
            .height(50)
            .width('100%')
            .visibility(Visibility.None)
            .margin({ top: 5, bottom: 5, left: 5, right: 5 })
            .onChange((value: string) => {
              this.setValue = value;
              this.controller.caretPosition(-1);
            })

          Text("type string")
            .width('90%')
            .height(50)
            .backgroundColor(0xEEEEEE)
            .borderRadius(15)
            .fontSize(13)
            .textAlign(TextAlign.Center)
            .margin({ top: 10 })
            .onClick(event => {
              this.exclResult('"string content"')
            })

          Text("type comment")
            .width('90%')
            .height(50)
            .backgroundColor(0xEEEEEE)
            .borderRadius(15)
            .fontSize(13)
            .textAlign(TextAlign.Center)
            .margin({ top: 10 })
            .onClick(event => {
              this.exclResult("//comment\u2028")
            })

          Text("type regex")
            .width('90%')
            .height(50)
            .backgroundColor(0xEEEEEE)
            .borderRadius(15)
            .fontSize(13)
            .textAlign(TextAlign.Center)
            .margin({ top: 10 })
            .onClick(event => {
              this.exclResult("/[\\\\]/]/")
            })

          Text("type number")
            .width('90%')
            .height(50)
            .backgroundColor(0xEEEEEE)
            .borderRadius(15)
            .fontSize(13)
            .textAlign(TextAlign.Center)
            .margin({ top: 10 })
            .onClick(event => {
              this.exclResult("1e+1")
            })

          Text("type name")
            .width('90%')
            .height(50)
            .backgroundColor(0xEEEEEE)
            .borderRadius(15)
            .fontSize(13)
            .textAlign(TextAlign.Center)
            .margin({ top: 10 })
            .onClick(event => {
              this.exclResult("a_56åπABCDEDFIGKLPUILLLZMKK")
            })

          Text("type punctuator")
            .width('90%')
            .height(50)
            .backgroundColor(0xEEEEEE)
            .borderRadius(15)
            .fontSize(13)
            .textAlign(TextAlign.Center)
            .margin({ top: 10 })
            .onClick(event => {
              this.exclResult("!===||>>?)(*&^%$#@!")
            })

          Text("type whitespace")
            .width('90%')
            .height(50)
            .backgroundColor(0xEEEEEE)
            .borderRadius(15)
            .fontSize(13)
            .textAlign(TextAlign.Center)
            .margin({ top: 10 })
            .onClick(event => {
              this.exclResult("    ")
            })

          Text("type invalid")
            .width('90%')
            .height(50)
            .backgroundColor(0xEEEEEE)
            .borderRadius(15)
            .fontSize(13)
            .textAlign(TextAlign.Center)
            .margin({ top: 10 })
            .onClick(event => {
              this.exclResult("@")
            })

          Text($r('app.string.Text_String2'))
            .width('90%')
            .height(50)
            .backgroundColor(0xEEEEEE)
            .borderRadius(15)
            .fontSize(13)
            .textAlign(TextAlign.Center)
            .margin({ top: 10 })
            .onClick(event => {
              this.exclResult("Iñtërnâtiônàlizætiøn☃💩")
            })
        }.width('100%')
      }
      .scrollable(ScrollDirection.Vertical).scrollBar(BarState.On)
      .scrollBarColor(Color.Gray).scrollBarWidth(30)
    }.width('100%').height('100%')
  }
}