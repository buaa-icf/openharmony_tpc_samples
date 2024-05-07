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

export = xml;

import ltx from "./src/main/ltx/types/ltx";
import * as escape from "./src/main/ltx/types/escape";
import LtxParser from "./src/main/ltx/types/parsers/ltx";

declare function xml(...args: Parameters<typeof ltx.createElement>): ReturnType<typeof ltx.createElement>;

declare namespace xml {
  type Element = ltx.Element;
  type Node = ltx.Node;

  const Element: typeof ltx.Element;
  const createElement: typeof ltx.createElement;

  const escapeXML: typeof escape.escapeXML;
  const unescapeXML: typeof escape.unescapeXML;
  const escapeXMLText: typeof escape.escapeXMLText;
  const unescapeXMLText: typeof escape.unescapeXMLText;

  class Parser extends ltx.Parser {
    static readonly XMLError: typeof XMLError;
    readonly parser: LtxParser;
    root: Element | null;
    cursor: Element | null;

    onStartElement(name: string, attrs?: string | { [attrName: string]: any }): void;
    onEndElement(name: string): void;
    onText(str: string): void;
  }

  class XMLError extends Error {
    readonly name: "XMLError";
  }
}

declare global {
  namespace JSX {
    interface IntrinsicElements {
      [elemName: string]: any;
    }

    type Element = xml.Element;
  }
}
