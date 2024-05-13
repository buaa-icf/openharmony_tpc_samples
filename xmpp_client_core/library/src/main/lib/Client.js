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

import Connection from '@ohos/xmpp_connection/index'
class Client extends Connection {
  constructor(options) {
    super(options);
    this.transports = [];
  }

  send(element, ...args) {
    return this.Transport.prototype.send.call(this, element, ...args);
  }

  sendMany(...args) {
    return this.Transport.prototype.sendMany.call(this, ...args);
  }

  _findTransport(service) {
    return this.transports.find((Transport) => {
      try {
        return Transport.prototype.socketParameters(service) !== undefined;
      } catch {
        return false;
      }
    });
  }

  connect(service) {
    const Transport = this._findTransport(service);

    if (!Transport) {
      throw new Error("No compatible connection method found.");
    }

    this.Transport = Transport;
    this.Socket = Transport.prototype.Socket;
    this.Parser = Transport.prototype.Parser;

    return super.connect(service);
  }

  socketParameters(...args) {
    return this.Transport.prototype.socketParameters(...args);
  }

  header(...args) {
    return this.Transport.prototype.header(...args);
  }

  headerElement(...args) {
    return this.Transport.prototype.headerElement(...args);
  }

  footer(...args) {
    return this.Transport.prototype.footer(...args);
  }

  footerElement(...args) {
    return this.Transport.prototype.footerElement(...args);
  }
}

Client.prototype.NS = "jabber:client";

// module.exports = Client;
export {Client}