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

import { Parser, Element, XMLError } from "@ohos/xmpp_xml";

export class FramedParser extends Parser {
  onStartElement(name, attrs) {
    const element = new Element(name, attrs);

    const { cursor } = this;

    if (cursor) {
      cursor.append(element);
    }

    this.cursor = element;
  }

  onEndElement(name) {
    const { cursor } = this;
    if (name !== cursor.name) {
      // <foo></bar>
      this.emit("error", new XMLError(`${cursor.name} must be closed.`));
      return;
    }

    if (cursor.parent) {
      this.cursor = cursor.parent;
      return;
    }

    if (cursor.is("open", "urn:ietf:params:xml:ns:xmpp-framing")) {
      this.emit("start", cursor);
    } else if (cursor.is("close", "urn:ietf:params:xml:ns:xmpp-framing")) {
      this.emit("end", cursor);
    } else {
      this.emit("element", cursor);
    }

    this.cursor = null;
  }
};
