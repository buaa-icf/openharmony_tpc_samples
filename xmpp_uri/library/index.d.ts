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

// <reference types="node" />
import { JID } from "@xmpp/jid";
// import { ParsedUrlQuery } from "@ohos/node-polyfill";

/**
 * Parse XMPP URIs.
 *
 * @example
 * import * as URI from '@xmpp/uri';
 *
 * URI.parse('xmpp://guest@example.com/support@example.com/truc?message;subject=Hello%20World')
 *
 * // =>
 * // {
 * //   authority: jid('guest@example.com'), // see https://github.com/xmppjs/xmpp.js/tree/main/packages/jid
 * //   path: jid('support@example.com/truc'), // see https://github.com/xmppjs/xmpp.js/tree/main/packages/jid
 * //   query: {
 * //     type: 'message',
 * //     params: {
 * //       subject: 'Hello World',
 * //     },
 * //   },
 * // }
 */
export function parse(str: string): XMPPURI;

export interface XMPPURI {
  path: JID;
  authority?: JID;
  query?: XMPPURIQuery;
}

export interface XMPPURIQuery {
  type: string;
  params: any;
}