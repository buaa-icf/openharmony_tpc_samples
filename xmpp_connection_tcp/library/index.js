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
import { Socket } from "./src/main/lib/net"
import Connection from "@ohos/xmpp_connection"

import { Parser } from "@ohos/xmpp_xml"

import { parseURI } from "@ohos/xmpp_connection/src/main/lib/util"

const NS_STREAM = "http://etherx.jabber.org/streams";

/* References
 * Extensible Messaging and Presence Protocol (XMPP): Core http://xmpp.org/rfcs/rfc6120.html
 */
class ConnectionTCP extends Connection {
    async sendMany(elements) {
        let fragment = "";

        for (const element of elements) {
            element.parent = this.root;
            fragment += element.toString();
        }

        await this.write(fragment);

        for (const element of elements) {
            this.emit("send", element);
        }
    }

    socketParameters(service) {
        const { port, hostname, protocol } = parseURI(service);
        return protocol === "xmpp:"
            ? { host: hostname, port: Number(port) }
            : undefined;
    }

    // https://xmpp.org/rfcs/rfc6120.html#streams-open
    headerElement() {
        const el = super.headerElement();
        el.name = "stream:stream";
        el.attrs["xmlns:stream"] = NS_STREAM;
        return el;
    }

    // https://xmpp.org/rfcs/rfc6120.html#streams-open
    header(el) {
        return `<?xml version='1.0'?>${el.toString().slice(0, -2)}>`;
    }

    // https://xmpp.org/rfcs/rfc6120.html#streams-close
    footer() {
        return "</stream:stream>";
    }
}

ConnectionTCP.prototype.NS = NS_STREAM;
ConnectionTCP.prototype.Socket = Socket;
ConnectionTCP.prototype.Parser = Parser;

// module.exports = ConnectionTCP;
export default ConnectionTCP