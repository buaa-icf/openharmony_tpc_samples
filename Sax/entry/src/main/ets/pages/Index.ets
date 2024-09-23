/**
 * BSD License
 *
 * Copyright (c) 2024 Huawei Device Co., Ltd. All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without modification,
 * are permitted provided that the following conditions are met:
 *
 * * Redistributions of source code must retain the above copyright notice, this
 *  list of conditions and the following disclaimer.
 *
 * * Redistributions in binary form must reproduce the above copyright notice,
 * this list of conditions and the following disclaimer in the documentation
 * and/or other materials provided with the distribution.
 *
 * * Neither the name Facebook nor the names of its contributors may be used to
 * endorse or promote products derived from this software without specific
 * prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS 'AS IS' AND
 * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 * WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 * DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR
 * ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
 * LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
 * ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 * SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

import sax from 'sax';
import hilog from '@ohos.hilog';

@Entry
@Component
struct Index {
  @State message: string = 'Hello World'

  build() {
    Row() {
      Column() {
        Text(this.message)
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
          .width('100%')
          .padding(10)
          .backgroundColor(Color.Red)
          .fontColor(Color.White)
        Text($r("app.string.Parsing"))
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
          .width('100%')
          .height(50)
          .margin({
            top: 20
          })
          .backgroundColor(Color.Blue)
          .fontColor(Color.White)
          .onClick(() => {
            this.saxParseXml()
          })
        Text($r("app.string.Parsing"))
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
          .width('100%')
          .height(50)
          .margin({
            top: 20
          })
          .backgroundColor(Color.Blue)
          .fontColor(Color.White)
          .onClick(() => {
            this.saxParseHtml()
          })
      }
      .width('100%')
    }
    .height('100%')
  }

  saxParseXml() {
    let _this = this;
    let parser: ESObject = sax.parser(true); // 创建一个新的解析器实例
    parser.onopentag = (node: ESObject) => {
      hilog.info(0x0000, 'testTag', '%{public}s', node);
    };
    parser.onclosetag = (nodeName: ESObject) => {
      hilog.info(0x0000, 'testTag', '%{public}s', nodeName);
    };
    parser.ontext = (text: ESObject) => {
      hilog.info(0x0000, 'testTag', '%{public}s', text);
      _this.message = text
    };
    parser.onend = (ondeEnd: ESObject) => {
      hilog.info(0x0000, 'testTag', '%{public}s', ondeEnd);
    };
    parser.onerror = (error: ESObject) => {
      hilog.info(0x0000, 'testTag', '%{public}s', error);
    };
    parser.write('<?xml version="1.0" encoding="UTF-8"?> <message> <warning> I\'m an xml! </message>');
    parser.end();
  }

  saxParseHtml() {
    let _this = this;
    let parser: ESObject = sax.parser(true); // 创建一个新的解析器实例
    parser.onopentag = (node: ESObject) => {
      hilog.info(0x0000, 'testTag', '%{public}s', node);
    };
    parser.onclosetag = (nodeName: ESObject) => {
      hilog.info(0x0000, 'testTag', '%{public}s', nodeName);
    };
    parser.ontext = (text: ESObject) => {
      hilog.info(0x0000, 'testTag', '%{public}s', text);
      _this.message = text
    };
    parser.onend = (ondeEnd: ESObject) => {
      hilog.info(0x0000, 'testTag', '%{public}s', ondeEnd);
    };
    parser.onerror = (error: ESObject) => {
      hilog.info(0x0000, 'testTag', '%{public}s', error);
    };
    parser.write('<head><b>I\'m an html!</b></head>');
    parser.end();
  }
}