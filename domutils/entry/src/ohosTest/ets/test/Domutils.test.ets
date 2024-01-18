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

import { parseDocument, Document, ElementType,DomUtils } from '@ohos/htmlparser2'

import {
  ParentNode,
  Element,
  ChildNode,
} from "domhandler"

import {
  removeSubsets,
  DocumentPosition,
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

} from 'domutils'


import { describe, expect, it } from '@ohos/hypium'


export default function dommhandler() {
  let dom: Document = parseDocument(html);

  describe('dommhandler', () => {
    it('removeSubsets', 0, () => {
      let childNodes : ChildNode[] = dom.children
      let newNodes:ChildNode[] = dom.children
      let removeSubsetsResult = removeSubsets(childNodes)
      expect(newNodes.length >= removeSubsetsResult.length).assertTrue();
    })

    it('compareDocumentPosition', 0, () => {
      let newNodes:ChildNode[] = dom.children
      let removeSubsetsResult:number = compareDocumentPosition(newNodes[0],newNodes[1])
      expect(removeSubsetsResult > 0).assertTrue();
    })

    it('uniqueSort', 0, () => {
      let oldNodes:ChildNode[] = dom.children
      let newNodes:ChildNode[] = uniqueSort(oldNodes)
      expect(oldNodes.length == newNodes.length).assertTrue();
    })

    it('getElements', 0, () => {
      let oldNodes:ChildNode[] = dom.children
      let getElementRequest : ChildNode[] = getElements({"tag_name":"style"}, oldNodes, true)
      expect(getElementRequest.length > 0).assertTrue();
    })

    it('getElementById', 0, () => {
      let oldNodes:ChildNode[] = dom.children
      let getElementByIdRequst : Element | null = getElementById('bodyId', oldNodes);
      expect(getElementByIdRequst != null ).assertTrue();
    })

    it('getElementsByTagName', 0, () => {
      let body:Element[] = getElementsByTagName('body', dom);
      expect(body.length > 0 ).assertTrue();
    })

    it('getElementsByTagType', 0, () => {
      let oldNodes:ChildNode[] = dom.children
      let body:ChildNode[] = getElementsByTagType(ElementType.Text, oldNodes);
      expect(body.length > 0 ).assertTrue();
    })

    it('removeElement', 0, () => {
      let oldNodes:ChildNode[] = dom.children
      let firstNodeLength = dom.children.length
      removeElement(oldNodes[0]);
      expect(firstNodeLength > dom.children.length ).assertTrue();
    })

    it('replaceElement', 0, () => {
      let oldNodes:ChildNode[] = dom.children
      let firstNodeLength = dom.children.length
      replaceElement(oldNodes[0],oldNodes[1]);
      expect(firstNodeLength == dom.children.length ).assertTrue();
    })

    it('appendChild', 0, () => {
      let oldNodes:ChildNode[] = dom.children
      let firstNodeLength = dom.children.length
      appendChild(oldNodes[0].parent,oldNodes[1]);
      expect(firstNodeLength == dom.children.length ).assertTrue();
    })


    it('append', 0, () => {
      let oldNodes:ChildNode[] = dom.children
      let firstNodeLength = dom.children.length
      append(oldNodes[0],oldNodes[1]);
      expect(firstNodeLength == dom.children.length ).assertTrue();
    })

    it('prependChild', 0, () => {
      let oldNodes:ChildNode[] = dom.children
      let firstNodeLength = dom.children.length
      prependChild(oldNodes[0].parent, oldNodes[1]);
      expect(firstNodeLength == dom.children.length ).assertTrue();
    })


    it('filter', 0, () => {
      let oldNodes:ChildNode[] = dom.children
      let firstNodeLength = dom.children.length
      let filterResult : ChildNode[] = filter((elem: ChildNode) =>{
        if (getElements({"tag_name":"style"}, elem, true).length > 0) {
          return true
        } else {
          return false
        }
      }, oldNodes);
      expect(filterResult.length > 0 ).assertTrue();
    })

    it('find', 0, () => {
      let oldNodes:ChildNode[] = dom.children
      let filterResult : ChildNode[] = find((elem: ChildNode) =>{
        if (getElements({"tag_name":"style"}, elem, true).length > 0) {
          return true
        } else {
          return false
        }
      }, oldNodes,true,3);
      expect(filterResult.length > 0 ).assertTrue();
    })

    it('findOne', 0, () => {
      let oldNodes:ChildNode[] = dom.children
      let filterOneResult : Element | null = findOne((elem: ChildNode) =>{
        if (getElements({"tag_name":"style"}, elem, true).length > 0) {
          return true
        } else {
          return false
        }
      }, oldNodes);
      expect(filterOneResult != null ).assertTrue();
    })

    it('existsOne', 0, () => {
      let oldNodes:ChildNode[] = dom.children
      let existResult : boolean = existsOne((elem: ChildNode) =>{
        if (getElements({"tag_name":"style"}, elem, true).length > 0) {
          return true
        } else {
          return false
        }
      }, oldNodes);
      expect(existResult).assertTrue();
    })

    it('findAll', 0, () => {
      let oldNodes:ChildNode[] = dom.children
      let findAllResult : Element[] = findAll((elem: ChildNode) =>{
        if (getElements({"tag_name":"style"}, elem, true).length > 0) {
          return true
        } else {
          return false
        }
      }, oldNodes);
      expect(findAllResult.length > 0).assertTrue();
    })

    it('textContent', 0, () => {
      let oldNodes:ChildNode[] = dom.children
      let textResult : string = textContent(oldNodes[0]);
      expect(textResult.length > 0).assertTrue();
    })

    it('innerText', 0, () => {
      let oldNodes:ChildNode[] = dom.children
      let textResult : string = innerText(oldNodes[0]);
      expect(textResult.length > 0).assertTrue();
    })

    it('getChildren', 0, () => {
      let element: Element[] = DomUtils.getElementsByTagName('style', dom);
      let getChildrenResult: ChildNode[] = getChildren(element[0]);
      expect(getChildrenResult.length > 0).assertTrue();
    })

    it('getParent', 0, () => {
      let element: Element[] = DomUtils.getElementsByTagName('style', dom);
      let oldNodes:ChildNode[] = dom.children
      let textResult : ParentNode | null = getParent(element[0].children[0]);
      expect(textResult != null).assertTrue();
    })

    it('getSiblings', 0, () => {
      let element: Element[] = DomUtils.getElementsByTagName('style', dom);
      let oldNodes:ChildNode[] = dom.children
      let textResult : ChildNode[] = getSiblings(element[0].children[0]);
      expect(textResult.length > 0).assertTrue();
    })

    it('getAttributeValue', 0, () => {
      let element: Element[] = DomUtils.getElementsByTagName('style', dom);
      let oldNodes:ChildNode[] = dom.children
      let textResult : string | undefined = getAttributeValue(element[0],"body");
      if (textResult) {
        expect(textResult.length > 0).assertTrue();
      }
    })

    it('hasAttrib', 0, () => {
      let element: Element[] = DomUtils.getElementsByTagName('style', dom);
      let textResult : boolean = hasAttrib(element[0],"body");
      expect(!textResult).assertTrue();
    })

    it('getName', 0, () => {
      let element: Element[] = DomUtils.getElementsByTagName('style', dom);
      let textResult : string = getName(element[0]);
      expect(textResult.length > 0).assertTrue();
    })

    it('nextElementSibling', 0, () => {
      let element: Element[] = DomUtils.getElementsByTagName('style', dom);
      let textResult : Element | null = nextElementSibling(element[0]);
      expect(textResult != null).assertTrue();
    })

    it('prevElementSibling', 0, () => {
      let element: Element[] = DomUtils.getElementsByTagName('style', dom);
      let textResult : Element | null = prevElementSibling(element[0]);
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
