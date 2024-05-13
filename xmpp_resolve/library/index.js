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

import { resolveArgs }  from "./resolve";
import { promise } from "@xmpp/events";

async function fetchURIs(domain) {
  const result = await resolveArgs(domain, {
    srv: [
      {
        service: "xmpps-client",
        protocol: "tcp",
      },
      {
        service: "xmpp-client",
        protocol: "tcp",
      },
    ],
  });

  return [
    // Remove duplicates
    ...new Set(result.map((record) => record.uri)),
  ];
}

function filterSupportedURIs(entity, uris) {
  return uris.filter((uri) => entity._findTransport(uri));
}

async function fallbackConnect(entity, uris) {
  if (uris.length === 0) {
    throw new Error("Couldn't connect");
  }

  const uri = uris.shift();
  const Transport = entity._findTransport(uri);

  if (!Transport) {
    return fallbackConnect(entity, uris);
  }

  entity._status("connecting", uri);
  const params = Transport.prototype.socketParameters(uri);
  const socket = new Transport.prototype.Socket();

  try {
    socket.connect(params);
    await promise(socket, "connect");
  } catch {
    return fallbackConnect(entity, uris);
  }

  entity._attachSocket(socket);
  socket.emit("connect");
  entity.Transport = Transport;
  entity.Socket = Transport.prototype.Socket;
  entity.Parser = Transport.prototype.Parser;
}

export default function resolve({ entity }) {
  const _connect = entity.connect;
  entity.connect = async function connect(service) {
    if (!service || /:\/\//.test(service)) {
      return _connect.call(this, service);
    }

    const uris = filterSupportedURIs(entity, await fetchURIs(service));

    if (uris.length === 0) {
      throw new Error("No compatible transport found.");
    }

    try {
      await fallbackConnect(entity, uris);
    } catch (err) {
      entity._reset();
      entity._status("disconnect");
      throw err;
    }
  };
};
