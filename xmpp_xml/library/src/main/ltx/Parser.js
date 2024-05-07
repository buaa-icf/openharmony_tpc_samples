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

import { EventEmitter } from "@ohos/node-polyfill";
import { Element } from "./Element";
import { SaxLtx as LtxParser } from "./ltx";

class Parser extends EventEmitter {
  constructor(options) {
    super();

    const ParserInterface = (this.Parser =
      (options && options.Parser) || this.DefaultParser);
    const ElementInterface = (this.Element =
      (options && options.Element) || this.DefaultElement);

    this.parser = new ParserInterface();

    let el;
    this.parser.on("startElement", (name, attrs) => {
      const child = new ElementInterface(name, attrs);
      el = !el ? child : el.cnode(child);
    });
    this.parser.on("endElement", (name) => {
      if (!el) {
        /* Err */
      } else if (name === el.name) {
        if (el.parent) {
          el = el.parent;
        } else if (!this.tree) {
          this.tree = el;
          el = undefined;
        }
      }
    });
    this.parser.on("text", (str) => {
      if (el) {
        el.t(str);
      }
    });
    this.parser.on("error", (e) => {
      this.error = e;
      this.emit("error", e);
    });
  }

  write(data) {
    this.parser.write(data);
  }

  end(data) {
    this.parser.end(data);

    if (!this.error) {
      if (this.tree) {
        this.emit("tree", this.tree);
      } else {
        this.emit("error", new Error("Incomplete document"));
      }
    }
  }
}

Parser.prototype.DefaultParser = LtxParser;
Parser.prototype.DefaultElement = Element;

export { Parser }
