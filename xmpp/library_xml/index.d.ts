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
export = xml;

import * as ltx from "ltx";
import * as escape from "ltx/src/main/types/escape";
import LtxParser from "ltx/src/main/types/parsers/ltx";

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
