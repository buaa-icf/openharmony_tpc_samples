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

import {Component,xml,jid} from "@ohos/xmpp_component_core"
import  _reconnect from "@ohos/xmpp_reconnect"
import _middleware from "@ohos/xmpp_middleware"
import _iqCaller from '@ohos/xmpp_iq/src/main/lib/caller'
import _iqCallee from '@ohos/xmpp_iq/src/main/lib/callee'


function component(options) {
    const { password, service, domain } = options;

    const entity = new Component({ service, domain });

    const reconnect = _reconnect({ entity });
    const middleware = _middleware({ entity });
    const iqCaller = _iqCaller({ entity, middleware });
    const iqCallee = _iqCallee({ entity, middleware });

    entity.on("open", async (el) => {
        try {
            const { id } = el.attrs;
            await (typeof password === "function"
                ? password((creds) => entity.authenticate(id, creds))
                : entity.authenticate(id, password));
        } catch (err) {
            entity.emit("error", err);
        }
    });

    return Object.assign(entity, {
        entity,
        reconnect,
        middleware,
        iqCaller,
        iqCallee,
    });
}

export { xml, jid, component }
