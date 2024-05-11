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

/**
 * References
 * https://xmpp.org/rfcs/rfc6120.html#stanzas-semantics-iq
 * https://xmpp.org/rfcs/rfc6120.html#stanzas-error
 */

import xml from "@ohos/xmpp_xml";
import {Element} from "@ohos/xmpp_xml"
const NS_STANZA = "urn:ietf:params:xml:ns:xmpp-stanzas";

function isQuery({ name, type }) {
  if (name !== "iq") return false;
  if (type === "error" || type === "result") return false;
  return true;
}

function isValidQuery({ type }, children, child) {
  if (type !== "get" && type !== "set") return false;
  if (children.length !== 1) return false;
  if (!child) return false;
  return true;
}

function buildReply({ stanza }) {
  return xml("iq", {
    to: stanza.attrs.from,
    from: stanza.attrs.to,
    id: stanza.attrs.id,
  });
}

function buildReplyResult(ctx, child) {
  const reply = buildReply(ctx);
  reply.attrs.type = "result";
  if (child) {
    reply.append(child);
  }

  return reply;
}

function buildReplyError(ctx, error, child) {
  const reply = buildReply(ctx);
  reply.attrs.type = "error";
  if (child) {
    reply.append(child);
  }

  reply.append(error);
  return reply;
}

function buildError(type, condition) {
  return xml("error", { type }, xml(condition, NS_STANZA));
}

function iqHandler(entity) {
  return async function iqHandler(ctx, next) {
    if (!isQuery(ctx)) return next();

    const { stanza } = ctx;
    const children = stanza.getChildElements();
    const [child] = children;

    if (!isValidQuery(ctx, children, child)) {
      return buildReplyError(ctx, buildError("modify", "bad-request"), child);
    }

    ctx.element = child;

    let reply;
    try {
      reply = await next();
    } catch (err) {
      entity.emit("error", err);
      reply = buildError("cancel", "internal-server-error");
    }

    if (!reply) {
      reply = buildError("cancel", "service-unavailable");
    }

    if (reply instanceof Element && reply.is("error")) {
      return buildReplyError(ctx, reply, child);
    }

    return buildReplyResult(
      ctx,
      reply instanceof Element ? reply : undefined,
    );
  };
}

function route(type, ns, name, handler) {
  return (ctx, next) => {
    if ((ctx.type !== type) | !ctx.element || !ctx.element.is(name, ns))
      return next();
    return handler(ctx, next);
  };
}

export default function iqCallee({ middleware, entity }) {
  middleware.use(iqHandler(entity));

  return {
    get(ns, name, handler) {
      middleware.use(route("get", ns, name, handler));
    },
    set(ns, name, handler) {
      middleware.use(route("set", ns, name, handler));
    },
  };
};
