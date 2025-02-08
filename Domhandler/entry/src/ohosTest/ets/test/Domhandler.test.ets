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

import DomHandler, {
  ProcessingInstruction,
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
} from "domhandler"
import * as helper from './helper'

import { Parser, parseDocument, DomUtils, createDocumentStream, ElementType, } from '@ohos/htmlparser2'

import { describe, expect, it } from '@ohos/hypium'


export default function dommhandler() {
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
  let dom: Document = parseDocument(html);
  let element: Element[] = DomUtils.getElementsByTagName('style', dom);

  describe('dommhandler', () => {
    it('isTag', 0, () => {
      let isTagResult: boolean = isTag(element[0]);
      expect(isTagResult).assertTrue();
    })

    it('isCDATA', 0, () => {
      let isCDATAResult: boolean = isCDATA(element[0]);
      expect(isCDATAResult).assertFalse();
    })

    it('isText', 0, () => {
      let isTextResult: boolean = isText(element[0]);
      expect(isTextResult).assertFalse();
    })

    it('isComment', 0, () => {
      let isCommentResult: boolean = isComment(element[0]);
      expect(isCommentResult).assertFalse();
    })


    it('isDirective', 0, () => {
      let isDirectiveResult: boolean = isDirective(element[0]);
      expect(isDirectiveResult).assertFalse();
    })

    it('isDocument', 0, () => {
      let isDocumentResult: boolean = isDocument(element[0]);
      expect(isDocumentResult).assertFalse();
    })

    it('hasChildren', 0, () => {
      let hasChildrenResult: boolean = hasChildren(element[0]);
      expect(hasChildrenResult).assertTrue();
    })

    it('cloneNode', 0, () => {
      let cloneNodeResult = cloneNode(element[0]);
      expect(cloneNodeResult != null).assertTrue();
    })

    it('node_name', 0, () => {
      let elementTwo: Element = new Element("style", {})
      expect(elementTwo.name).assertEqual("style");
    })
    it('tagNmae', 0, () => {
      let elementTwo: Element = new Element("style", {})
      expect(elementTwo.tagName).assertEqual("style");
    })


    it('firstChild', 0, () => {
      let firstChild: ChildNode | null = element[0].firstChild
      expect(firstChild != null).assertTrue()
    })

    it('lastChild', 0, () => {
      let lastChild: ChildNode | null = element[0].lastChild
      expect(lastChild != null).assertTrue()
    })

    it('childNodes', 0, () => {
      let childNodes: ChildNode[] = element[0].childNodes
      expect(childNodes.length > 0).assertTrue()
    })

    it('ProcessingInstruction_name', 0, () => {
      let processingInstruction: ProcessingInstruction = new ProcessingInstruction("china", "Chinese")
      expect(processingInstruction.name).assertEqual("china")
    })

    it('ProcessingInstruction_data', 0, () => {
      let processingInstruction: ProcessingInstruction = new ProcessingInstruction("china", "Chinese")
      expect(processingInstruction.data).assertEqual("Chinese")
    })

    it('parent', 0, () => {
      let childNode: ChildNode | null = element[0].firstChild
      if (childNode != null) {
        let parentNode: ParentNode | null = childNode.parent
        expect(parentNode != null).assertTrue()
      }
    })

    it('prev', 0, () => {
      let childNode: ChildNode | null = element[0].firstChild
      if (childNode != null) {
        let parentNode: ParentNode | null = childNode.parent
        if (parentNode != null) {
          let prevNode: ChildNode | null = parentNode.prev
          expect(prevNode != null).assertTrue()
        }
      }
    })

    it('next', 0, () => {
      let childNode: ChildNode | null = element[0].firstChild
      if (childNode != null) {
        let parentNode: ParentNode | null = childNode.parent
        if (parentNode != null) {
          let nextNode: ChildNode | null = parentNode.next
          expect(nextNode != null).assertTrue()
        }
      }
    })

    it('previousSibling', 0, () => {
      let previousSibling: ChildNode | null = element[0].previousSibling
      expect(previousSibling != null).assertTrue()
    })

    it('parentNode', 0, () => {
      let childNode: ChildNode | null = element[0].firstChild
      if (childNode != null) {
        let parentNode: ChildNode | null = childNode.parentNode
        expect(parentNode != null).assertTrue()
      }
    })

    it('nextSibling', 0, () => {
      let nextSibling: ChildNode | null = element[0].nextSibling
      expect(nextSibling != null).assertTrue()
    })

    it('attribs', 0, () => {
      let parser: Parser = createDocumentStream((error: Error | null, dom: Document) => {
        if (!!error) {
          expect().assertFail()
          return
        }
        let element: Element[] = DomUtils.getElementsByTagName('style', dom);
        expect(element[0].nodeType).assertEqual(1);
        expect(element[0].tagName).assertEqual('style');
        element[0].tagName = "style1"
        expect(element[0].tagName).assertEqual('style1');
        element[0].tagName = "style1"

        expect(JSON.stringify(element[0].attributes)).assertEqual('[]');
      });
      parser.write(html);
      parser.end();
    })

    it('startIndex', 0, () => {
      let childNode: ChildNode | null = element[0].firstChild
      if (childNode != null) {
        let parentNode: ParentNode | null = childNode.parent
        if (parentNode != null) {
          let startIndex: number | null = parentNode.startIndex
          if (startIndex != null) {
            expect(startIndex >= 0).assertTrue()
          }
        }
      }
    })

    it('endIndex', 0, () => {
      let childNode: ChildNode | null = element[0].firstChild
      if (childNode != null) {
        let parentNode: ParentNode | null = childNode.parent
        if (parentNode != null) {
          let endIndex: number | null = parentNode.endIndex
          if (endIndex != null) {
            expect(endIndex >= 0).assertTrue()
          }
        }
      }
    })

    it('callback', 0, () => {
      let arr: Array<string> = new Array()
      const handler = helper.getEventCollector((error, actual: ESObject) => {
        if (error) {
          expect().assertFail()
          return
        }

        if (actual.$event == "text") {
          arr.push(actual.data)
        }

        if (actual.$event == "end") {
          expect(true).assertTrue()
        }
      });
      const parser: Parser = new Parser(handler);
      parser.write("china <script type='text/javascript'>const foo = '<<bar>>';</script>",);
      parser.end();
    })


    it('DomHandler', 0, () => {
      const rawHtml =
        "Xyz <script language= javascript>var foo = '<<bar>>';</script><!--<!-- Waah! -- -->";
      const handler = new DomHandler((error, dom) => {
        if (error) {
          expect().assertFail()
        } else {
          expect(true).assertTrue()
        }
      });
      const parser = new Parser(handler);
      parser.write(rawHtml);
      parser.end();
    })

  })
}
 
