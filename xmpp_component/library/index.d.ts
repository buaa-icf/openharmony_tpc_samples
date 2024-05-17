/**
 * Copyright (C) 2024 Huawei Device Co., Ltd.
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all
 * copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE
 */

import { Component as ComponentCore, jid as xmppJid, xml as xmppXml } from "@ohos/xmpp_component_core";
import { IQCallee } from "@ohos/xmpp_iq/src/main/types/callee";
import { IQCaller } from "@ohos/xmpp_iq/src/main/types/caller";
import { Middleware } from "@ohos/xmpp_middleware";
import { Reconnect } from "@ohos/xmpp_reconnect";

export function component(options: Options): Component;

export interface Options {
    password?: string | ((authenticate: (password: string) => Promise<void>) => Promise<void>);
    service?: string;
    domain?: string;
}

export interface Component extends ComponentCore {
    entity: Component;
    reconnect: Reconnect<Component>;
    middleware: Middleware<Component>;
    iqCaller: IQCaller<Component>;
    iqCallee: IQCallee<Component>;
}

export const jid: typeof xmppJid;
export const xml: typeof xmppXml;
