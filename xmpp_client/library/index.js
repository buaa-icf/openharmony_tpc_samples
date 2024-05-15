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

import { xml, jid, Client as ClientCore } from "@ohos/xmpp_client_core";
import { getDomain } from "./src/main/lib/getDomain";

import _reconnect from "@ohos/xmpp_reconnect";
import _websocket from "@ohos/xmpp_websocket";
import _tcp from "@ohos/xmpp_tcp";
// import _tls from "@ohos/xmpp_tls";
import _middleware from "@ohos/xmpp_middleware";
import _streamFeatures from "@ohos/xmpp_stream_features";
import _iqCaller from "@ohos/xmpp_iq/src/main/lib/caller";
import _iqCallee from "@ohos/xmpp_iq/src/main/lib/callee";
import _resolve from "@ohos/xmpp_resolve";

// Stream features - order matters and define priority
// import _starttls from "@ohos/xmpp_starttls";
import _sasl from "@ohos/xmpp_sasl";
import _resourceBinding from "@ohos/xmpp_resoure_binding";
import _sessionEstablishment from "@ohos/xmpp_session_establishment";
import _streamManagement from "@ohos/xmpp_stream_management";

// SASL mechanisms - order matters and define priority
import plain from "@ohos/xmpp_sasl_plain";

// import scramsha1 from "@ohos/xmpp_sasl-scram-sha-1";
import anonymous from "@ohos/xmpp_sasl_anonymous";

function client(options = {}) {
    const { resource, credentials, username, password, ...params } = options;
    const { domain, service, caPath } = params;
    if (!domain && service) {
        params.domain = getDomain(service);
    }

    const entity = new ClientCore(params);

    const reconnect = _reconnect({ entity });
    const websocket = _websocket({ entity });
    const tcp = _tcp({ entity });
    // const tls = _tls({ entity });
    const middleware = _middleware({ entity });
    const streamFeatures = _streamFeatures({ middleware });
    const iqCaller = _iqCaller({ middleware, entity });
    const iqCallee = _iqCallee({ middleware, entity });
    const resolve = _resolve({ entity });
    // // Stream features - order matters and define priority
    // const starttls = _starttls({ streamFeatures });
    const sasl = _sasl({ streamFeatures }, credentials || { username, password });
    const streamManagement = _streamManagement({
        streamFeatures,
        entity,
        middleware,
    });
    const resourceBinding = _resourceBinding(
        { iqCaller, streamFeatures },
        resource,
    );
    const sessionEstablishment = _sessionEstablishment({
        iqCaller,
        streamFeatures,
    });
    // SASL mechanisms - order matters and define priority
    const mechanisms = Object.entries({
        // scramsha1,
        plain,
        anonymous,
    }).map(([k, v]) => ({ [k]: v(sasl) }));
    //
    return Object.assign(entity, {
        entity,
        reconnect,
        tcp,
        websocket,
        // tls,
        middleware,
        streamFeatures,
        iqCaller,
        iqCallee,
        resolve,
        // starttls,
        sasl,
        resourceBinding,
        sessionEstablishment,
        streamManagement,
        mechanisms,
    });
}

export { xml, jid, client };
