/**
 * ISC License
 * Copyright (C) 2024 Huawei Device Co., Ltd.
 *
 * Permission to use, copy, modify, and/or distribute this software for any
 * purpose with or without fee is hereby granted, provided that the above
 * copyright notice and this permission notice appear in all copies.
 *
 * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES WITH
 * REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY
 * AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY SPECIAL, DIRECT,
 * INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM
 * LOSS OF USE, DATA OR PROFITS, WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE
 * OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR
 * PERFORMANCE OF THIS SOFTWARE.
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
