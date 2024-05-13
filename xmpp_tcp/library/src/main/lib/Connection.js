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

// const Connection = require("@xmpp/connection-tcp");
import Connection from "@ohos/xmpp_connection_tcp"

class ConnectionTCP extends Connection {
  socketParameters(service) {
    console.info("xmpp--- service --"+JSON.stringify(service))
    const params = super.socketParameters(service);
    console.info("xmpp--- params --"+JSON.stringify(params))
    if (!params) return params;
    params.port = params.port || 5222
    return params;
  }
}

ConnectionTCP.prototype.NS = "jabber:client";
export { ConnectionTCP };
