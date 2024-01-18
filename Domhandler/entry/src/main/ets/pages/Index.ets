/**
 *
 * Copyright (c) 2023 Huawei Device Co., Ltd.
 *
 * All rights reserved.
 * Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
 * Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
 * Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
 * THIS IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS 'AS IS' AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS,
 * EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */


import { Element } from 'domhandler';
import {
  Parser,
  parseDocument,
  DomUtils,
  Document,
  createDocumentStream,
} from '@ohos/htmlparser2'

const html = `
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document</title>
</head>
<style>
    .tagh1{
        background-color: aquamarine;
        color:'blue';
    }
    .one-div{
        line-height: 30px;
    }
</style>
<body>
    <h1 class="tagh1">
        kkkk
        <p>hhhhh</p>
    </h1>
    <div style="color:red; height:100px;" class="one-div">cshi</div>
    <img src="https:baidu.com" alt="wwww"/>
    <p>wjdwekfe</p>
    <em>dsjfw
    <div>dksfmjk</div>
    owqkdo</em>
</body>
</html>
`
@Entry
@Component
struct Index {
  @State result: string = "";
  build() {
    Row() {
      Column() {
        Text("解析结果 :\r\n  " + this.result)
          .fontSize(15)
          .margin({ top: 55, left: 10, right: 10 })
        Text("parseDocument")
          .width('90%')
          .height(60)
          .backgroundColor(0xFFFFFF)
          .borderRadius(15)
          .border({ width: 2, color: '#666666', radius: 6 })
          .fontSize(16)
          .textAlign(TextAlign.Center)
          .margin({ top: 20 })
          .onClick(event => {
            this.result = ""
            let dom: Document = parseDocument(html);
            let element: Element[] = DomUtils.getElementsByTagName('style', dom);
            let text:string = DomUtils.textContent(element);
            this.result += "text:" + text + "\r\n"
            let isTag :boolean= DomUtils.isTag(element[0]);
            this.result += "isTag:" + isTag + "\r\n"
            let isCDATA:boolean = DomUtils.isCDATA(element[0]);
            this.result += "isCDATA:" + isCDATA + "\r\n"
            let isText:boolean = DomUtils.isText(element[0]);
            this.result += "isText:" + isText + "\r\n"
            let isComment :boolean= DomUtils.isComment(element[0]);
            this.result += "isComment:" + isComment + "\r\n"
            this.result += "isComment:" + element[0].name + "\r\n"
          });
        Column() {
          Text("createDocumentStream")
            .width('90%')
            .height(60)
            .backgroundColor(0xFFFFFF)
            .borderRadius(15)
            .fontSize(16)
            .border({ width: 2, color: '#666666', radius: 6 })
            .textAlign(TextAlign.Center)
            .margin({ top: 20 })
            .onClick(event => {
              this.result = ""
              let parser: Parser = createDocumentStream((error: Error | null, dom: Document) => {
                if (!!error) {
                  this.result = JSON.stringify(error)
                  return
                }
                let element : Element[]= DomUtils.getElementsByTagName('style', dom);
                let text:string = DomUtils.textContent(element);
                this.result += "text:" + text + "\r\n"
                let isTag :boolean= DomUtils.isTag(element[0]);
                this.result += "isTag:" + isTag + "\r\n"
                let isCDATA :boolean= DomUtils.isCDATA(element[0]);
                this.result += "isCDATA:" + isCDATA + "\r\n"
                let isText:boolean = DomUtils.isText(element[0]);
                this.result += "isText:" + isText + "\r\n"
                let isComment :boolean= DomUtils.isComment(element[0]);
                this.result += "isComment:" + isComment + "\r\n"
              });
              parser.write(html);
              parser.end();
            });
        }
      }
      .width('100%')
    }
    .height('100%')
  }
}