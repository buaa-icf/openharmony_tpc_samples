/*
 * MIT License
 *
 * Copyright (C) 2024 Huawei Device Co., Ltd.
 *
 * Permission is hereby granted, free of charge, to any person
 * obtaining a copy of this software and associated documentation
 * files (the "Software"), to deal in the Software without
 * restriction, including without limitation the rights to use,
 * copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the
 * Software is furnished to do so, subject to the following
 * conditions:
 *
 * The above copyright notice and this permission notice shall be
 * included in all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
 * OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
 * HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
 * WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
 * OTHER DEALINGS IN THE SOFTWARE.
 */

import xmlbuilder from 'xmlbuilder';
@Entry
@Component
struct Index {
  @State message: string = 'Hello World'

  build() {
    Row() {
      Column() {
        Text(this.message)
          .fontSize(25)
          .fontWeight(FontWeight.Bold)
        Text('组织一条xml')
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
            this.buildXml()
          })
        Text('组织一条html')
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
            this.buildHtml()
          })
      }
      .width('100%')
    }
    .height('100%')
  }
  buildXml() {
    const xml:string = xmlbuilder.create('root', { version: '1.0', encoding: 'UTF-8' })
      .ele('child', 'Child Element')
      .end({ pretty: true});
    this.message = xml
  }
  buildHtml() {
    const html:string = xmlbuilder.create('html', { version: '1.0', encoding: 'UTF-8' })
      .ele('head')
      .ele('title', 'My Page')
      .ele('body')
      .ele('h1', 'Welcome to My Page')
      .ele('p', 'This is a simple HTML document generated using XMLBuilder.')
      .end({ pretty: true });
    this.message = html
  }
}