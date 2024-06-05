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

import { promise } from "@xmpp/events";
import TlsSocket from "@ohos/xmpp_tls/src/main/lib/Socket";
import { Socket as TcpSocket } from "@ohos/xmpp_connection_tcp/src/main/lib/net"
function canUpgrade(socket) {
    return socket instanceof TcpSocket && !(socket instanceof TlsSocket)
}

async function upgrade(service) {
  const tlsSocket = new TlsSocket();
        tlsSocket.connect(service);
  await promise(tlsSocket, "connect");
  return tlsSocket ;
}

export { canUpgrade, upgrade };
