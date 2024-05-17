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

// const jid = require("@xmpp/jid");
// const { IRI } = require("iri");
import { jid } from "@xmpp/jid"
import { querystring } from '@ohos/node-polyfill'
import { IRI } from './src/main/lib/iri'
function findQueryType(params) {
  return Object.getOwnPropertyNames(params).find((k) => {
    return k[0] === "?" && params[k] === "";
  });
}

function parse(str) {
  const iri = new IRI(str);

  const uri = {};

  const path = iri.path();
  uri.path = jid(path.startsWith("/") ? path.slice(1) : path);

  const authority = iri.authority();
  if (authority) {
    uri.authority = jid(authority);
  }

  const query = iri.query();
  const params = querystring.parse(query, ";");
  const type = findQueryType(params);
  if (type) {
    delete params[type];
  }

  if (query) {
    uri.query = {
      type: type.slice(1),
      params,
    };
  }

  return uri;
}

// module.exports.parse = parse;

export { parse }