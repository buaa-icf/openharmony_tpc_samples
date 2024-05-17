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
import Connection from "@ohos/xmpp_connection_tcp"
import { crypto }  from "@ohos/node-polyfill"
import xml from "@ohos/xmpp_xml"

/*
 * References
 * https://xmpp.org/extensions/xep-0114.html done
 * https://xmpp.org/extensions/xep-0225.html) todo
 */

const NS = "jabber:component:accept";

class Component extends Connection {
  socketParameters(service) {
    const params = super.socketParameters(service);
    params.port = params.port || 5347;
    return params;
  }

  // https://xmpp.org/extensions/xep-0114.html#example-4
  send(el) {
    // All stanzas sent to the server MUST possess a 'from' attribute and a 'to' attribute, as in the 'jabber:server' namespace
    if (this.isStanza(el) && !el.attrs.from) {
      el.attrs.from = this.jid.toString();
    }

    return super.send(el);
  }

  // https://xmpp.org/extensions/xep-0114.html#example-3
  async authenticate(id, password) {
    const hash = crypto.createHash("sha1");
    hash.update(id + password, "binary");
    const el = await this.sendReceive(xml("handshake", {}, hash.digest("hex")));
    if (el.name !== "handshake") {
      throw new Error("Unexpected server response");
    }

    this._jid(this.options.domain);
    this._status("online", this.jid);
  }
}

Component.NS = NS;
Component.prototype.NS = NS;

export  default  Component;
