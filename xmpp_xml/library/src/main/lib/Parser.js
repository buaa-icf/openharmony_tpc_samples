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

"use strict";
import { SaxLtx as LtxParser}  from '../ltx/parsers/ltx'
// const LtxParser = require("ltx/lib/parsers/ltx");
// const Element = require("ltx/lib/Element");
import {Element} from '../ltx/Element'
// const EventEmitter = require("events");
import {EventEmitter} from '@ohos/node-polyfill'
// const XMLError = require("./XMLError");
import {XMLError} from './XMLError'


class Parser extends EventEmitter {
  constructor() {
    super();
    const parser = new LtxParser();
    this.root = null;
    this.cursor = null;

    parser.on("startElement", this.onStartElement.bind(this));
    parser.on("endElement", this.onEndElement.bind(this));
    parser.on("text", this.onText.bind(this));

    this.parser = parser;
  }

  onStartElement(name, attrs) {
    const element = new Element(name, attrs);

    const { root, cursor } = this;

    if (!root) {
      this.root = element;
      this.emit("start", element);
    } else if (cursor !== root) {
      cursor.append(element);
    }

    this.cursor = element;
  }

  onEndElement(name) {
    const { root, cursor } = this;
    if (name !== cursor.name) {
      // <foo></bar>
      this.emit("error", new XMLError(`${cursor.name} must be closed.`));
      return;
    }

    if (cursor === root) {
      this.emit("end", root);
      return;
    }

    if (!cursor.parent) {
      cursor.parent = root;
      this.emit("element", cursor);
      this.cursor = root;
      return;
    }

    this.cursor = cursor.parent;
  }

  onText(str) {
    const { cursor } = this;
    if (!cursor) {
      this.emit("error", new XMLError(`${str} must be a child.`));
      return;
    }

    cursor.t(str);
  }

  write(data) {
    this.parser.write(data);
  }

  end(data) {
    if (data) {
      this.parser.write(data);
    }
  }
}

Parser.XMLError = XMLError;

// module.exports = Parser;
export { Parser }