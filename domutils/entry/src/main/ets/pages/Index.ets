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

import { parseDocument, Document, ElementType, parseDOM } from '@ohos/htmlparser2'
import { Element, ChildNode, ParentNode } from 'domhandler';
import {
  append,
  appendChild,
  compareDocumentPosition,
  existsOne,
  filter,
  find,
  findAll,
  findOne,
  getAttributeValue,
  getChildren,
  getElementById,
  getElements,
  getElementsByTagName,
  getElementsByTagType,
  getInnerHTML,
  getName,
  getOuterHTML,
  getParent,
  getSiblings,
  hasAttrib,
  innerText,
  nextElementSibling,
  prependChild,
  prevElementSibling,
  removeElement,
  removeSubsets,
  replaceElement,
  textContent,
  uniqueSort,
} from 'domutils';


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
        Button($r('app.string.getNode'))
          .fontSize(25)
          .margin(15)
          .height(46)
          .fontWeight(FontWeight.Bold)
          .onClick(() => {
            const markup = Array(21).join(
              "<?xml><tag1 id='asdf' class='class1'> <script>text</script> <!-- comment --> <tag2> text </tag1>");
            let fixture = parseDocument(markup).children
            let content: Array<string> = [];
            let dom: Document = parseDocument(html);

            const dom1 = parseDocument("<div><p><span></span></p><p></p></div>")
              .children[0] as Element;
            let removeSubsetsResult: ChildNode[] = removeSubsets([dom1, dom1])
            this.addLog(content, `removeSubsets = ${removeSubsetsResult.length}`);

            const markup1 = "<div><p><span></span></p><a></a></div>";
            const dom2 = parseDocument(markup1).children[0] as Element;
            const p = dom2.children[0] as Element;
            const span = p.children[0];
            const a = dom2.children[1];
            let position = compareDocumentPosition(span, a)
            this.addLog(content, `compareDocumentPosition = ${position}`);

            let oldNodes: ChildNode[] = dom.children
            let newNodes: ChildNode[] = uniqueSort(oldNodes)
            this.addLog(content, `uniqueSort = ${newNodes.length}`);

            let node = getElements({ id: "asdfs" }, fixture, true)
            this.addLog(content, `getElements = ${node.length}`);

            let node1: ChildNode | null = getElementById("asdf", fixture, true)
            if (node1) {
              this.addLog(content, `getElementById = ${JSON.stringify(node1.attribs)}`);
            }

            let elements = getElementsByTagName("tag2", fixture, true)
            this.addLog(content, `getElementsByTagName = ${elements.length}`);

            let elements2 = getElementsByTagType(ElementType.Script, fixture, true)
            this.addLog(content, `getElementsByTagType = ${elements2.length}`);

            const dom3 = parseDOM(
              "<div><p><img/><object/></p><p></p></div>",
            )[0] as Element;
            const parents = dom3.children as Element[];
            const image = parents[0].children[0];
            removeElement(image);
            this.addLog(content, `removeElement next = ${image.next}`);
            this.addLog(content, `removeElement prev = ${image.prev}`);

            let oldNodes2: ChildNode[] = dom.children
            let firstNodeLength = dom.children.length
            replaceElement(oldNodes2[0], oldNodes2[1]);
            this.addLog(content, `replaceElement = ${firstNodeLength == dom.children.length}`);

            const dom4 = parseDOM(
              "<div><p><img/></p><p><object/></p></div>",
            )[0] as Element;
            const child = parseDOM("<span></span>")[0] as Element;
            const parents2 = dom4.children as Element[];
            appendChild(parents2[0], child);
            appendChild(parents2[1], child);
            this.addLog(content, `appendChild = ${parents[0].children.length}`);


            const dom5 = parseDOM(
              "<div><p><img/></p><p><object/></p></div>",
            )[0] as Element;
            const child1 = parseDOM("<span></span>")[0] as Element;
            const parents5 = dom5.children as Element[];
            append(parents5[0].children[0], child1);
            append(parents5[1].children[0], child1);
            this.addLog(content, `append = ${parents5[0].children.length}`);

            const dom6 = parseDOM(
              "<div><p><img/></p><p><object/></p></div>",
            )[0] as Element;
            const child2 = parseDOM("<span></span>")[0] as Element;
            const parents3 = dom6.children as Element[];
            prependChild(parents3[0], child2);
            prependChild(parents3[1], child2);
            this.addLog(content, `prependChild = ${parents3[0].children.length}`);

            const manyNodesWide = parseDocument(
              `<body>${"<div></div>".repeat(200)}Text</body>`,);
            let nodes1 = filter((elem) => elem.type === ElementType.Tag, manyNodesWide)
            this.addLog(content, `filter = ${nodes1.length}`);

            const manyNodesWide1 = parseDocument(
              `<body>${"<div></div>".repeat(200)}Text</body>`).children;
            let nodes2 = find(
              (elem) => elem.type === ElementType.Tag,
              manyNodesWide1,
              true,
              Infinity,
            )
            this.addLog(content, `find = ${nodes2.length}`);

            const manyNodesWide2 = parseDocument(
              `<body>${"<div></div>".repeat(200)}Text</body>`,);
            let node3: ChildNode | null = findOne(
              (elem) => elem.name === "body",
              manyNodesWide2.children,
              true,
            )
            if (node3) {
              this.addLog(content, `findOne = ${node3.attributes.length}`);
            }

            const manyNodesWide3 = parseDocument(
              `<body>${"<div></div>".repeat(200)}Text</body>`).children;
            this.addLog(content, `existsOne = ${existsOne((elem) => elem.name === "body", manyNodesWide3)}`);


            const manyNodesWide4 = parseDocument(
              `<body>${"<div></div>".repeat(200)}Text</body>`).children;
            this.addLog(content, `findAll = ${findAll((elem) => elem.name === "div", manyNodesWide4).length}`);

            this.addLog(content, `textContent = ${textContent(fixture[1])}`);

            this.addLog(content, `getInnerHTML = ${getInnerHTML(fixture[1])}`);

            this.addLog(content, `getOuterHTML = ${getOuterHTML(fixture[1])}`);

            this.addLog(content, `innerText = ${innerText(fixture[1])}`);

            let element3: Element[] = getElementsByTagName('style', dom);
            let getChildrenResult: ChildNode[] = getChildren(element3[0]);
            this.addLog(content, `getChildren = ${getChildrenResult.length > 0}`);

            let element4: Element[] = getElementsByTagName('style', dom);
            let textResult: ParentNode | null = getParent(element4[0].children[0]);
            this.addLog(content, `getParent = ${textResult != null}`);

            const dom7 = parseDOM("<div><h1></h1><p><p><p></div>")[0] as Element;
            this.addLog(content, `getSiblings = ${getSiblings(dom7.children[1]).length}`);

            this.addLog(content, `getAttributeValue = ${getAttributeValue(
              parseDOM("<div class='test'>")[0] as Element,
              "class",
            )}`);

            this.addLog(content, `hasAttrib = ${hasAttrib(parseDOM("textnode")[0] as never, "some-attrib")}`);

            this.addLog(content, `getName = ${getName(parseDOM("<div>")[0] as Element)}`);

            let element6: Element[] = getElementsByTagName('style', dom);
            let textResult6: Element | null = nextElementSibling(element6[0]);
            this.addLog(content, `nextElementSibling = ${textResult6 != null}`);

            let element7: Element[] = getElementsByTagName('style', dom);
            let textResult7: Element | null = prevElementSibling(element7[0]);
            this.addLog(content, `prevElementSibling = ${textResult7 != null}`);

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