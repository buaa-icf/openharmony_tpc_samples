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

import jsTokens from 'js-tokens'

@Entry
@Component
struct Index {
  @State message: string = 'Hello World'
  scroller: Scroller = new Scroller();
  controller: TextAreaController = new TextAreaController();
  @State setValue: string = '';
  @State resultStr: string = '';
  tos: string = '';
  arr1: Array<string> = new Array();
  regular: string = "/[1-9][0-9]?/";
  ifInIf: string = `

if(
  \`\${
      (()=>{
            if(x) /r/i
            return Math.random()
      })()
  }\` > 0.5
) /a/g
`.trim();

  partChar(code: string) {
    var forStrResult = "";
    for (var element of jsTokens(code)) {
      forStrResult = forStrResult + "类型:" + element.type + "-值:" + element.value;
    }
    console.log(forStrResult);
    this.resultStr = forStrResult;
  }

  joinChar(char: string) {
    const jsString = '(1，23@45%6789)'
    for (var element of jsTokens(jsString)) {
      this.arr1.push(element.value);
    }
    var tok = this.arr1.join(char);
    console.log(tok);
    this.resultStr = tok;
  }

  build() {
    Stack({ alignContent: Alignment.TopStart }) {
      Scroll(this.scroller) {
        Column() {
          Text("该库核心功能：分词器，就是按字符类型将词分开，---------------------------------（重点：按类型分词，看Readme类型规则），包括各种特殊字符！分完词后给出类型和值，Key-Value形式存在")
            .width('90%')
            .height(100)
            .borderRadius(15)
            .fontSize(15)
            .textAlign(TextAlign.Center)
            .margin({ top: 10 })

          Text("测试结果:" + this.resultStr)
            .width('90%')
            .borderRadius(15)
            .fontSize(13)
            .textAlign(TextAlign.Start)
            .margin({ top: 10, bottom: 10 })

          TextArea({ placeholder: "输入任意类型字符", controller: this.controller })
            .height(50)
            .width('100%')
            .margin({ top: 5, bottom: 5, left: 5, right: 5 })
            .onChange((value: string) => {
              this.setValue = value;
              this.controller.caretPosition(-1);
            })

          Text("开始分词")
            .width('90%')
            .height(50)
            .backgroundColor(0xEEEEEE)
            .borderRadius(15)
            .fontSize(13)
            .textAlign(TextAlign.Center)
            .margin({ top: 10 })
            .onClick(event => {
              this.partChar(this.setValue);
            })

          Text("给(1，23@45%6789)加入分界线")
            .width('90%')
            .height(50)
            .backgroundColor(0xEEEEEE)
            .borderRadius(15)
            .fontSize(13)
            .textAlign(TextAlign.Center)
            .margin({ top: 10 })
            .onClick(event => {
              this.joinChar("|");
            })

          Text("正则表达式分词")
            .width('90%')
            .height(50)
            .backgroundColor(0xEEEEEE)
            .borderRadius(15)
            .fontSize(13)
            .textAlign(TextAlign.Center)
            .margin({ top: 10 })
            .onClick(event => {
              this.partChar(this.regular);
            })

          Text("特殊字符分词1")
            .width('90%')
            .height(50)
            .backgroundColor(0xEEEEEE)
            .borderRadius(15)
            .fontSize(13)
            .textAlign(TextAlign.Center)
            .margin({ top: 10 })
            .onClick(event => {
              this.partChar("`a ${ {c:d } e`.length");
            })

          Text("标识符混合2")
            .width('90%')
            .height(50)
            .backgroundColor(0xEEEEEE)
            .borderRadius(15)
            .fontSize(13)
            .textAlign(TextAlign.Center)
            .margin({ top: 10 })
            .onClick(event => {
              this.partChar(this.ifInIf);
            })

          Text("注释")
            .width('90%')
            .height(50)
            .backgroundColor(0xEEEEEE)
            .borderRadius(15)
            .fontSize(13)
            .textAlign(TextAlign.Center)
            .margin({ top: 10 })
            .onClick(event => {
              this.partChar("/* common */ &&& /** conono */");
            })

          Text("私有标识和数字")
            .width('90%')
            .height(50)
            .backgroundColor(0xEEEEEE)
            .borderRadius(15)
            .fontSize(13)
            .textAlign(TextAlign.Center)
            .margin({ top: 10 })
            .onClick(event => {
              this.partChar("#undefined #\u006C\u006F\u006C\u0077\u0061\u0074 #if 1.5 ob110");
            })

          Text("字符表情分词（💩表情在os貌似不支持显示）")
            .width('90%')
            .height(50)
            .backgroundColor(0xEEEEEE)
            .borderRadius(15)
            .fontSize(13)
            .textAlign(TextAlign.Center)
            .margin({ top: 10 })
            .onClick(event => {
              this.partChar("`${💩}`");
            })
        }.width('100%')
      }
      .scrollable(ScrollDirection.Vertical).scrollBar(BarState.On)
      .scrollBarColor(Color.Gray).scrollBarWidth(30)
    }.width('100%').height('100%')
  }
}