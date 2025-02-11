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

import { parseDocument, Document, ElementType, DomUtils, parseDOM } from '@ohos/htmlparser2'

import { ParentNode, Element, ChildNode, AnyNode, } from "domhandler"

import {
  removeSubsets,
  compareDocumentPosition,
  uniqueSort,
  getElements,
  getElementById,
  getElementsByTagName,
  getElementsByTagType,
  removeElement,
  replaceElement,
  appendChild,
  append,
  prependChild,
  filter,
  find,
  findOne,
  existsOne,
  findAll,
  textContent,
  innerText,
  getChildren,
  getParent,
  getSiblings,
  getAttributeValue,
  hasAttrib,
  getName,
  nextElementSibling,
  prevElementSibling,
  getText,
  getInnerHTML,
  getOuterHTML,
} from 'domutils'

import { beforeAll, describe, expect, it } from '@ohos/hypium'


export default function dommhandler() {
  let dom: Document = parseDocument(html);
  const markup = Array(21).join(
    "<?xml><tag1 id='asdf' class='class1'> <script>text</script> <!-- comment --> <tag2> text </tag1>");
  let fixture = parseDocument(markup).children

  const expected: ESObject = {
    idAsdf: fixture[1] as Element,
    tag2: [] as AnyNode[],
    typeScript: [] as AnyNode[],
  };


  beforeAll(() => {
    for (let idx = 0; idx < 20; ++idx) {
      const node = fixture[idx * 2 + 1] as Element;
      expected.tag2.push(node.children[5]);
      expected.typeScript.push(node.children[1]);
    }
  })

  describe('dommhandler', () => {
    it('removeSubsets', 0, () => {
      const dom = parseDocument("<div><p><span></span></p><p></p></div>")
        .children[0] as Element;
      let removeSubsetsResult = removeSubsets([dom, dom])
      expect(removeSubsetsResult.length == 1).assertTrue();

      const firstChild = dom.children[0] as Element;
      const matches = removeSubsets([dom, firstChild.children[0]]);
      expect(matches.length == 1).assertTrue();

      expect(removeSubsets([dom.children[0], dom]).length).assertEqual(1);

      expect(removeSubsets([dom.children[0], dom.children[1]]).length).assertEqual(2);
    })

    it('compareDocumentPosition', 0, () => {
      const markup = "<div><p><span></span></p><a></a></div>";
      const dom = parseDocument(markup).children[0] as Element;
      const p = dom.children[0] as Element;
      const span = p.children[0];
      const a = dom.children[1];

      expect(compareDocumentPosition(span, a)).assertEqual(2);
      expect(compareDocumentPosition(p, span)).assertEqual(10);
      expect(compareDocumentPosition(a, span)).assertEqual(4);
      expect(compareDocumentPosition(span, p)).assertEqual(20);

      const otherDom = parseDocument(markup).children[0] as Element;
      const other = (otherDom.children[0] as Element).children[0];
      expect(compareDocumentPosition(span, other)).assertEqual(1);

      expect(compareDocumentPosition(span, span)).assertEqual(0);
      const dom1 = parseDocument("<div><span>1</span><span>2</span></div>")
        .children[0] as Element;
      expect(compareDocumentPosition(dom1.children[0], (dom1.children[0] as Element).children[0])).assertEqual(10);
    })

    it('uniqueSort', 0, () => {
      let oldNodes: ChildNode[] = dom.children
      let newNodes: ChildNode[] = uniqueSort(oldNodes)
      expect(oldNodes.length).assertEqual(newNodes.length);
    })

    it('getElements', 0, () => {
      expect(getElements({
        id: "asdfs"
      }, fixture, true).length).assertEqual(0);

      expect(
        getElements({
          tag_name: "asdfs"
        }, fixture, true).length
      ).assertEqual(0)

      expect(
        getElements({
          tag_type: "video"
        }, fixture, true).length
      ).assertEqual(0);

      expect(
        getElements({
          tag_contains: "text"
        }, fixture, true).length
      ).assertEqual(20);

      expect(
        getElements(
          {
            tag_contains: (text) => text === "text"
          },
          fixture,
          true,
        ).length
      ).assertEqual(20);

      expect(getElements({
        tag_name: "*"
      }, fixture, true).length).assertEqual(60);
    })

    it('getElementById', 0, () => {
      let node: ChildNode | null = getElementById("asdf", fixture, true)
      if (node) {
        expect(JSON.stringify(node.attribs)).assertEqual('{"id":"asdf","class":"class1"}');
      }
      expect(getElementById("asdfs", fixture, true)).assertNull();
    })

    it('getElementsByTagName', 0, () => {
      expect(getElementsByTagName("tag2", fixture, true).length).assertEqual(20);
      expect(getElementsByTagName("tag23", fixture, true).length).assertEqual(0);
    })

    it('getElementsByTagType', 0, () => {
      expect(getElementsByTagType(ElementType.Script, fixture, true).length).assertEqual(20);
      expect(getElementsByTagType("video" as never, fixture, true).length).assertEqual(0);
    })

    it('removeElement', 0, () => {
      const dom = parseDOM(
        "<div><p><img/><object/></p><p></p></div>",
      )[0] as Element;
      const parents = dom.children as Element[];

      const image = parents[0].children[0];

      removeElement(image);
      expect(image.next).assertNull();
      expect(image.prev).assertNull();
      expect(image.parent).assertNull();
      appendChild(parents[1], image);

      expect(parents[0].children.length).assertEqual(1);
      expect(parents[1].children.length).assertEqual(1);
    })

    it('replaceElement', 0, () => {
      let oldNodes: ChildNode[] = dom.children
      let firstNodeLength = dom.children.length
      replaceElement(oldNodes[0], oldNodes[1]);
      expect(firstNodeLength).assertEqual(dom.children.length);
    })

    it('appendChild', 0, () => {
      const dom = parseDOM(
        "<div><p><img/></p><p><object/></p></div>",
      )[0] as Element;
      const child = parseDOM("<span></span>")[0] as Element;
      const parents = dom.children as Element[];
      appendChild(parents[0], child);
      appendChild(parents[1], child);
      expect(parents[0].children.length).assertEqual(1);
      expect(parents[1].children.length).assertEqual(2);
    })


    it('append', 0, () => {
      const dom = parseDOM(
        "<div><p><img/></p><p><object/></p></div>",
      )[0] as Element;
      const child = parseDOM("<span></span>")[0] as Element;
      const parents = dom.children as Element[];
      append(parents[0].children[0], child);
      append(parents[1].children[0], child);

      expect(parents[0].children.length).assertEqual(1);
      expect(parents[1].children.length).assertEqual(2);
    })

    it('prependChild', 0, () => {
      const dom = parseDOM(
        "<div><p><img/></p><p><object/></p></div>",
      )[0] as Element;
      const child = parseDOM("<span></span>")[0] as Element;
      const parents = dom.children as Element[];
      prependChild(parents[0], child);
      prependChild(parents[1], child);
      expect(parents[0].children.length).assertEqual(1);
      expect(parents[1].children.length).assertEqual(2);
    })


    it('filter', 0, () => {
      const manyNodesWide = parseDocument(
        `<body>${"<div></div>".repeat(200_000)}Text</body>`,);
      expect(
        filter((elem) => elem.type === ElementType.Tag, manyNodesWide).length
      ).assertEqual(200_001);
      expect(
        filter(
          (elem) => elem.type === ElementType.Tag,
          manyNodesWide.children[0],
        ).length
      ).assertEqual(200_001);
    })

    it('find', 0, () => {
      const manyNodesWide = parseDocument(
        `<body>${"<div></div>".repeat(200_000)}Text</body>`).children;
      expect(
        find(
          (elem) => elem.type === ElementType.Tag,
          manyNodesWide,
          true,
          Infinity
        ).length
      ).assertEqual(200_001);
      expect(
        find(
          (elem) => elem.type === ElementType.Tag,
          manyNodesWide,
          true,
          20,
        ).length
      ).assertEqual(20);
    })

    it('findOne', 0, () => {
      const manyNodesWide = parseDocument(
        `<body>${"<div></div>".repeat(200_000)}Text</body>`).children;
      let node: ChildNode | null = findOne(
        (elem) => elem.name === "body",
        manyNodesWide,
        true,
      )
      if (node) {
        expect(node.attributes.length).assertEqual(0);
      }

      expect(
        findOne((elem) => elem.name === "div", manyNodesWide, false),
      ).assertNull();

      expect(findOne(() => false, manyNodesWide)).assertNull()
    })

    it('existsOne', 0, () => {
      const manyNodesWide = parseDocument(
        `<body>${"<div></div>".repeat(200_000)}Text</body>`).children;
      expect(
        existsOne((elem) => elem.name === "body", manyNodesWide),
      ).assertTrue();
      expect(existsOne(() => false, manyNodesWide)).assertFalse();
    })

    it('findAll', 0, () => {
      const manyNodesWide = parseDocument(
        `<body>${"<div></div>".repeat(200_000)}Text</body>`).children;
      expect(
        findAll((elem) => elem.name === "div", manyNodesWide).length
      ).assertEqual(200_000);
    })

    it('textContent', 0, () => {
      expect(textContent(fixture[1])).assertEqual(" text   text ");
    })

    it('getText', 0, () => {
      expect(getText(fixture[1])).assertEqual(" text   text ");
    })

    it('getInnerHTML', 0, () => {
      expect(getInnerHTML(fixture[1])).assertEqual(
        " <script>text</script> <!-- comment --> <tag2> text </tag2>",
      );
    })

    it('getOuterHTML', 0, () => {
      expect(getOuterHTML(fixture[1])).assertEqual(
        '<tag1 id="asdf" class="class1"> <script>text</script> <!-- comment --> <tag2> text </tag2></tag1>',
      );
    })

    it('innerText', 0, () => {
      expect(innerText(fixture[1])).assertEqual("    text ");
    })

    it('getChildren', 0, () => {
      let element: Element[] = DomUtils.getElementsByTagName('style', dom);
      let getChildrenResult: ChildNode[] = getChildren(element[0]);
      expect(getChildrenResult.length > 0).assertTrue();
    })

    it('getParent', 0, () => {
      let element: Element[] = DomUtils.getElementsByTagName('style', dom);
      let textResult: ParentNode | null = getParent(element[0].children[0]);
      expect(textResult != null).assertTrue();
    })

    it('getSiblings', 0, () => {
      const dom = parseDOM("<div><h1></h1><p><p><p></div>")[0] as Element;
      expect(getSiblings(dom.children[1]).length).assertEqual(4);

      const dom1 = parseDOM("<h1></h1><p><p><p>") as Element[];
      for (const node of dom1) {
        node.parent = null;
      }
      expect(getSiblings(dom1[2]).length).assertEqual(4);
    })

    it('getAttributeValue', 0, () => {
      expect(
        getAttributeValue(
          parseDOM("<div class='test'>")[0] as Element,
          "class",
        ),
      ).assertEqual("test");
      expect(
        getAttributeValue(parseDOM("<div>")[0] as Element, "id"),
      ).assertUndefined();
      expect(
        getAttributeValue(parseDOM("TEXT")[0] as never, "id"),
      ).assertUndefined()
    })

    it('hasAttrib', 0, () => {
      expect(() =>
      hasAttrib(parseDOM("textnode")[0] as never, "some-attrib"),
      ).not().assertThrowError();

      expect(
        hasAttrib(
          parseDOM("<div><h1></h1>test<p></p></div>")[0] as Element,
          "constructor",
        ),
      ).assertFalse();

      const div = parseDOM("<div class=test>")[0] as Element;

      expect(hasAttrib(div, "class")).assertTrue();

      div.attribs["class"] = null as never;

      expect(hasAttrib(div, "class")).assertFalse();
    })

    it('getName', 0, () => {
      expect(getName(parseDOM("<div>")[0] as Element)).assertEqual("div");
      expect(getName(parseDOM("TEXT")[0] as never)).assertUndefined();
    })

    it('nextElementSibling', 0, () => {
      let element: Element[] = DomUtils.getElementsByTagName('style', dom);
      let textResult: Element | null = nextElementSibling(element[0]);
      expect(textResult != null).assertTrue();
    })

    it('prevElementSibling', 0, () => {
      let element: Element[] = DomUtils.getElementsByTagName('style', dom);
      let textResult: Element | null = prevElementSibling(element[0]);
      expect(textResult != null).assertTrue();
    })
  })
}


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
