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


import compose from "koa-compose"
import { IncomingContext } from './src/main/lib/IncomingContext';
import { OutgoingContext } from './src/main/lib/OutgoingContext';

function listener(entity, middleware, Context) {
    return (stanza) => {
        const ctx = new Context(entity, stanza);
        return compose(middleware)(ctx);
    };
}

function errorHandler(entity) {
    return (ctx, next) => {
        next()
            .then((reply) => reply && entity.send(reply))
            .catch((err) => entity.emit("error", err));
    };
}

function middleware({ entity }) {
    const incoming = [errorHandler(entity)];
    const outgoing = [];

    const incomingListener = listener(entity, incoming, IncomingContext);
    const outgoingListener = listener(entity, outgoing, OutgoingContext);

    entity.on("element", incomingListener);
    entity.hookOutgoing = outgoingListener;

    return {
        use(fn) {
            incoming.push(fn);
            return fn;
        },
        filter(fn) {
            outgoing.push(fn);
            return fn;
        },
    };
};

export default middleware
