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

import { parseURI } from "@ohos/xmpp_connection/src/main/lib/util";
import ConnectionTCP from "@ohos/xmpp_connection_tcp";
import Socket from "./Socket.js";

class ConnectionTLS extends ConnectionTCP {
  socketParameters(service) {
    const { port, hostname, protocol } = parseURI(service);
    return protocol === "xmpps:"
      ? {
          port: Number(port) || 5223,
          host: hostname,
        }
      : undefined;
  }
}

ConnectionTLS.prototype.Socket = Socket;
ConnectionTLS.prototype.NS = "jabber:client";

export default ConnectionTLS;
