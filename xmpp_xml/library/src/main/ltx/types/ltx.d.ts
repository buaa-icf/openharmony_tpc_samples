/**
 * Copyright (C) 2024 Huawei Device Co., Ltd.
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 * */


// import clone from "./clone";
import createElement from "./createElement";
import Element, { Node } from "./Element";
// import equal, { attrsEqual, childrenEqual, nameEqual } from "./equal";
import { escapeXML, escapeXMLText, unescapeXML, unescapeXMLText } from "./escape";
// import { isElement, isNode, isText } from "./is";
// import JSONify, { ElementJson } from "./JSONify";
// import parse from "./parse";
import Parser, { ParserOptions } from "./Parser";
// import stringify from "./stringify";
// import tag from "./tag";
// import tagString from "./tagString";

export {
  // attrsEqual,
  // childrenEqual,
  // clone,
  createElement,
  Element,
  // ElementJson,
  // equal,
  escapeXML,
  escapeXMLText,
  // isElement,
  // isNode,
  // isText,
  // JSONify,
  // nameEqual,
  Node,
  // parse,
  Parser,
  ParserOptions,
  // stringify,
  // tag,
  // tagString,
  unescapeXML,
  unescapeXMLText,
};