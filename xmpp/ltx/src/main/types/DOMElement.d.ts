/**
 * Copyright (C) 2024 Huawei Device Co., Ltd.
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
// import DOMElement from "../src/DOMElement";
//
// export = DOMElement;

import Element, { Node } from "./Element";

export default class DOMElement extends Element {
  static createElement(name: string, attrs?: string | { [attrName: string]: any }, ...children: Node[]): DOMElement;

  nodeType: 1;
  nodeName: string;

  readonly localName: ReturnType<typeof Element.prototype.getName>;
  readonly namespaceURI: ReturnType<typeof Element.prototype.getNS>;
  readonly parentNode: typeof Element.prototype.parent;
  readonly childNodes: typeof Element.prototype.children;
  textContent: string;

  getElementsByTagName: typeof Element.prototype.getChildren;
  getAttribute: typeof Element.prototype.getAttr;
  setAttribute(attr: string, val: any): void;
  getAttributeNS(ns: string, name: string): any;
  setAttributeNS(ns: string, name: string, value: any): void;
  removeAttribute(name: string): void;
  removeAttributeNS(ns: string, name: string): void;
  appendChild(child: Node): void;
  removeChild(child: Node): void;
}