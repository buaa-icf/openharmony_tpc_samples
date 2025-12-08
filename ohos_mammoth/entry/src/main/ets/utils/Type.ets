/**
 * MIT License
 *
 * Copyright (C) 2025 Huawei Device Co., Ltd.
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all
 * copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 */

export interface Options {
  styleMap?: string | Array<string>;
  includeEmbeddedStyleMap?: boolean;
  includeDefaultStyleMap?: boolean;
  convertImage?: ESObject;
  ignoreEmptyParagraphs?: boolean;
  idPrefix?: string;
  externalFileAccess?: boolean;
  transformDocument?: (element: ESObject) => ESObject;
}

export interface SrcData {
  src: string;
  alt?: string;
}


export interface BaseElement {
  type: string;
  name?: string;
}

export interface TextElement extends BaseElement {
  value: string;
}

export interface HyperlinkElement extends BaseElement {
  children: (TextElement | BaseElement)[];
  href: string;
}

interface CommentReferenceElement extends BaseElement {
  commentId: string;
}

interface IndentInfo {
  start: string | null;
  end: string | null;
  firstLine: string | null;
  hanging: string | null;
}

interface NumberingInfo {
  isOrdered: boolean;
  level: string;
}

export interface RunElement extends BaseElement {
  children: (TextElement | HyperlinkElement | CommentReferenceElement | BaseElement)[];
  styleId: string | null;
  styleName: string | null;
  isBold: boolean;
  isUnderline: boolean;
  isItalic: boolean;
  isStrikethrough: boolean;
  isAllCaps: boolean;
  isSmallCaps: boolean;
  verticalAlignment: string;
  font: object | null;
  fontSize: object | null;
  highlight: object | null;
}

export interface ParagraphElement extends BaseElement {
  children: RunElement[];
  styleId: string | null;
  styleName: string | null;
  numbering: NumberingInfo | null;
  alignment: string | null;
  indent: IndentInfo;
}
