/**
 * ISC License
 * Copyright (C) 2024 Huawei Device Co., Ltd.
 * Permission to use, copy, modify, and/or distribute this software for any
 * purpose with or without fee is hereby granted, provided that the above
 * copyright notice and this permission notice appear in all copies.
 * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES WITH
 * REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY
 * AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY SPECIAL, DIRECT,
 * INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM
 * LOSS OF USE, DATA OR PROFITS, WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE
 * OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR
 * PERFORMANCE OF THIS SOFTWARE.
 */


"use strict";

import id  from "@xmpp/id";
import StanzaError from "@ohos/xmpp_middleware/src/main/lib/StanzaError";
import { Deferred } from "@xmpp/events";
import * as timeoutPromise from "@xmpp/events";
import xml from "@ohos/xmpp_xml";

function isReply({ name, type }) {
  if (name !== "iq") return false;
  if (type !== "error" && type !== "result") return false;
  return true;
}

class IQCaller {
  constructor({ entity, middleware }) {
    this.handlers = new Map();
    this.entity = entity;
    this.middleware = middleware;
  }

  start() {
    this.middleware.use(this._route.bind(this));
  }

  _route({ type, name, id, stanza }, next) {
    if (!isReply({ name, type })) return next();

    const deferred = this.handlers.get(id);

    if (!deferred) {
      return next();
    }

    if (type === "error") {
      deferred.reject(StanzaError.fromElement(stanza.getChild("error")));
    } else {
      deferred.resolve(stanza);
    }

    this.handlers.delete(id);
  }

  async request(stanza, timeout = 30 * 1000) {
    if (!stanza.attrs.id) {
      stanza.attrs.id = id();
    }

    const deferred = new Deferred();
    this.handlers.set(stanza.attrs.id, deferred);
    try {
      await this.entity.send(stanza);
      await timeoutPromise.timeout(deferred.promise, timeout);
    } catch (err) {
      this.handlers.delete(stanza.attrs.id);
      throw err;
    }

    return deferred.promise;
  }

  _childRequest(type, element, to, ...args) {
    const {
      name,
      attrs: { xmlns },
    } = element;
    return this.request(xml("iq", { type, to }, element), ...args).then(
      (stanza) => stanza.getChild(name, xmlns),
    );
  }

  async get(...args) {
    return this._childRequest("get", ...args);
  }

  async set(...args) {
    return this._childRequest("set", ...args);
  }
}

export default function iqCaller(...args) {
  const iqCaller = new IQCaller(...args);
  iqCaller.start();
  return iqCaller;
};
