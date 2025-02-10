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


import {
  Node,
  DataNode,
  Comment,
  ProcessingInstruction,
  NodeWithChildren,
  CDATA,
  ParentNode,
  Document,
  Element,
  isTag,
  isCDATA,
  isText,
  isComment,
  isDirective,
  isDocument,
  hasChildren,
  ChildNode,
  cloneNode,
  DomHandler
} from "domhandler"

import { Parser, parseDocument, DomUtils, createDocumentStream, } from '@ohos/htmlparser2'
import * as helper from './helper'

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
  scroller: Scroller = new Scroller()
  getResourceString(res: Resource) {
    return getContext().resourceManager.getStringSync(res.id)
  }

  build() {
    Row() {
      Column() {
        Scroll(this.scroller) {
          Text(this.getResourceString($r('app.string.Analysis_results')) + "\r\n  " + this.result)
            .fontSize(15)
            .margin({ top: 55, left: 10, right: 10 })
        }.height("80%")

        Column() {
          Button($r('app.string.createDocumentStream'))
            .width('90%')
            .height(60)
            .fontColor(Color.Black)
            .backgroundColor(0xFFFFFF)
            .borderRadius(15)
            .fontSize(16)
            .border({ width: 2, color: '#666666', radius: 6 })
            .margin({ top: 20 })
            .onClick(() => {
              this.result = ""
              let parser: Parser = createDocumentStream((error: Error | null, dom: Document) => {
                if (!!error) {
                  this.result = JSON.stringify(error)
                  return
                }
                let element: Element[] = DomUtils.getElementsByTagName('style', dom);
                let text: string = DomUtils.textContent(element);
                this.result += "text:" + text + "\r\n"

                let isTag1: boolean = isTag(element[0]);
                this.result += "isTag:" + isTag1 + "\r\n"

                let isCDATA1: boolean = isCDATA(element[0]);
                this.result += "isCDATA:" + isCDATA1 + "\r\n"

                let isText1: boolean = isText(element[0]);
                this.result += "isText:" + isText1 + "\r\n"

                let isComment1: boolean = isComment(element[0]);
                this.result += "isComment:" + isComment1 + "\r\n"

                let isDirectiveResult: boolean = isDirective(element[0]);
                this.result += "isDirective:" + isDirectiveResult + "\r\n"

                let isDocumentResult: boolean = isDocument(element[0]);
                this.result += "isDocument:" + isDocumentResult + "\r\n"

                let hasChildrenResult: boolean = hasChildren(element[0]);
                this.result += "hasChildren:" + hasChildrenResult + "\r\n"

                let cloneNodeResult = cloneNode(element[0]);
                this.result += "cloneNode:" + JSON.stringify(cloneNodeResult) + "\r\n"

                let firstChild: ChildNode | null = element[0].firstChild
                this.result += "firstChild:" + (firstChild != null) + "\r\n"

                let lastChild: ChildNode | null = element[0].lastChild
                this.result += "lastChild:" + (lastChild != null) + "\r\n"

                let childNodes: ChildNode[] = element[0].childNodes
                this.result += "childNodes:" + (childNodes.length > 0) + "\r\n"

                let processingInstruction: ProcessingInstruction = new ProcessingInstruction("china", "Chinese")
                this.result += "ProcessingInstruction.nodeType:" + (processingInstruction.nodeType) + "\r\n"
                this.result += "ProcessingInstruction.data:" + (processingInstruction.data) + "\r\n"

                this.result += "Element.nodeType:" + (element[0].nodeType) + "\r\n"

                this.result += "Element.tagName:" + (element[0].tagName) + "\r\n"

                element[0].tagName="style1"
                this.result += "Element.tagName:" + (element[0].tagName) + "\r\n"

                this.result += "Element.attribs:" + (JSON.stringify(element[0].attributes)) + "\r\n"

                this.result += "Node.parentNode:" + (element[0].parentNode!=null) + "\r\n"
                this.result += "Node.nextSibling:" + (element[0].nextSibling!=null) + "\r\n"
                this.result += "Node.previousSibling:" + (element[0].previousSibling!=null) + "\r\n"
                this.result += "Node.cloneNode:" + (JSON.stringify(element[0].cloneNode())) + "\r\n"

                const rawHtml =
                  "Xyz <script language= javascript>var foo = '<<bar>>';</script><!--<!-- Waah! -- -->";
                const handler = new DomHandler((error, dom) => {
                  if (error) {
                  } else {
                    this.result += "DomHandler:" + (dom[0].nodeType) + "\r\n"
                  }
                });
                const parser = new Parser(handler);
                parser.write(rawHtml);
                parser.end();


                let arr: Array<string> = new Array()
                const handler1 = helper.getEventCollector((error, actual: ESObject) => {
                  if (error) {
                    this.result = this.result + getContext().resourceManager.getStringByNameSync('Parse_fail') + "：" + JSON.stringify(error)
                    return
                  }

                  if (actual.$event == "text") {
                    arr.push(actual.data)
                  }

                  if (actual.$event == "end") {
                    this.result += "callback:" + (JSON.stringify(arr)) + "\r\n"
                  }
                });
                const parser1: Parser = new Parser(handler1);
                parser1.write("china <script type='text/javascript'>const foo = '<<bar>>';</script>",);
                parser1.end();

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





