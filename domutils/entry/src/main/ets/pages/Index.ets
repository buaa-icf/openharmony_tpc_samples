/**
 *
 * Copyright (c) 2024 Huawei Device Co., Ltd.
 *
 * All rights reserved.
 * Redistribution and use in source and binary forms, with or without modification,
 * are permitted provided that the following conditions are met:
 *
 * Redistributions of source code must retain the above copyright notice,this
 * list of conditions and the following disclaimer.
 *
 * Redistributions in binary form must reproduce the above copyright notice,
 * this list of conditions and the following disclaimer in the documentation
 * and/or other materials provided with the distribution.
 *
 * THIS IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS 'AS IS' AND ANY EXPRESS OR IMPLIED WARRANTIES,
 * INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 * ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
 * INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
 * PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS;
 * OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
 * STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS,
 *
 * EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

import { parseDocument, DomUtils, Document } from '@ohos/htmlparser2'
import { Element, ChildNode } from 'domhandler';


const html = `
          <!DOCTYPE html>
          <html lang="en">
          <head>
              <meta charset="UTF-8">
              <meta http-equiv="X-UA-Compatible" content="IE=edge">
              <meta name="viewport" content="width=device-width, initial-scale=1.0">
              <title>Document</title>
          </head>
          <style id="bodyId">
              .tagh1{
                  background-color: aquamarine;
                  color:'blue';
              }
              .one-div{
                  line-height: 30px;
              }
              #bodyId{
                color: black;
              }
          </style>
          <body id="bodyId">
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
  @State showContent: string = '';

  build() {
    Column() {
      Row() {
        Button('解析HTML标签并获取属性')
          .fontSize(25)
          .margin(15)
          .height(46)
          .fontWeight(FontWeight.Bold)
          .onClick(() => {
            let content: ESObject = [];
            let dom: Document = parseDocument(html);
            this.addLog(content, 'domUtils length= ' + dom.children.length);
            let element:Element[] = DomUtils.getElementsByTagName('style', dom);
            this.addLog(content, `domUtils element.length = ${element.length}`);
            let text:string = DomUtils.textContent(element);
            this.addLog(content, `domUtils text = ${text}`);
            let isTag:boolean = DomUtils.isTag(element[0]);
            this.addLog(content, `domUtils isTag = ${isTag}`);
            let isCDATA:boolean = DomUtils.isCDATA(element[0]);
            this.addLog(content, `domUtils isCDATA = ${isCDATA}`);
            let isText:boolean = DomUtils.isText(element[0]);
            this.addLog(content, `domUtils isText = ${isText}`);
            let isComment:boolean = DomUtils.isComment(element[0]);
            this.addLog(content, `domUtils isComment = ${isComment}`);

            let body:Element[] = DomUtils.getElementsByTagName('body', dom);
            this.addLog(content, `domUtils getElementsByTagName = ${body.length}`);
            let bodyId:Element | null = DomUtils.getElementById('bodyId', dom);
            if (bodyId != null) {
              this.addLog(content, `domUtils getElementById = ${bodyId}`);
            }
            let childrens:ChildNode[] = DomUtils.getChildren(body[0]);
            this.addLog(content, `domUtils getChildren = ${childrens.length}`);
            let getText:string = DomUtils.getText(element)
            this.addLog(content, `domUtils getText = ${getText}`);
            this.showContent = content.join('\n');
          })
      }.height('10%')
      Row() {
        Scroll() {
          Text(this.showContent)
            .width('100%')
            .fontSize(25)
            .align(Alignment.Start)
            .padding(15)
            .textAlign(TextAlign.Start)
        }.width('100%')
        .height('100%')
      }
      .width('100%')
      .height('80%')
    }
    .height('100%')
  }

  private addLog(array: Array<string>, info: string) {
    console.info(info);
    array.push(info);
  }
}