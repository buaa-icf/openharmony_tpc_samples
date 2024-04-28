"use strict";


import compose from "koa-compose"
import { IncomingContext } from './src/main/middleware/lib/IncomingContext';
import { OutgoingContext } from './src/main/middleware/lib/OutgoingContext';

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

    try {
        const incomingListener = listener(entity, incoming, IncomingContext);
        const outgoingListener = listener(entity, outgoing, OutgoingContext);
        entity.on("element", incomingListener);
        entity.hookOutgoing = outgoingListener;
    } catch (e) {
        console.error("xmpp---incomingListener" + e)
    }


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
