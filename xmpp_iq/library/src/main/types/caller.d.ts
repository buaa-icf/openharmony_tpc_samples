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


import { Deferred } from "@xmpp/events";
import { Entity, Middleware } from "@ohos/xmpp_middleware";
import { Element } from "@ohos/xmpp_xml";

export = iqCaller;

declare function iqCaller<TEntity extends Entity>({
                                                    middleware,
                                                    entity,
                                                  }: {
  middleware: Middleware<TEntity>;
  entity: TEntity;
}): iqCaller.IQCaller<TEntity>;

declare namespace iqCaller {
  /**
   * Implements the caller side of iq semantics.
   */
  // eslint-disable-next-line @typescript-eslint/naming-convention
  interface IQCaller<TEntity extends Entity> {
    handlers: Map<string, Deferred<Element>>;
    entity: TEntity;
    middleware: Middleware<TEntity>;

    start(): void;
    /**
     * Sends an iq and returns a promise.
     *
     * - Resolves with the response when it is received.
     * - Rejects with `StanzaError` when an error is received.
     * - Rejects with `TimeoutError` if a reply wasn't received within the specified or default timeout.
     * - Rejects with `Error` for anything else.
     *
     * * The request `id` attribute is optional and will be added if omitted.
     * * The request `to` attribute is optional and will default to the server.
     *
     * @example
     * const response = await iqCaller.request(
     *   xml('iq', { type: 'get' }, xml('foo', 'foo:bar')),
     *   30 * 1000, // 30 seconds timeout - default
     * );
     * const foo = response.getChild('foo', 'foo:bar');
     * console.log(foo);
     */
    request(stanza: Element, timeout?: number): Promise<Element>;
    /**
     * A convenient method to send a `get` request. Behaves like `request` but accepts/returns a child
     * element instead of an `iq`.
     *
     * @example
     * const foo = await iqCaller.get(
     *   xml('foo', 'foo:bar'),
     *   to, // 'to' attribute, optional
     *   timeout, // 30 seconds timeout - default
     * );
     * console.log(foo);
     */
    get(element: Element, to?: string, timeout?: number): Promise<Element | undefined>;
    /**
     * A convenient method to send a `set` request. Behaves like `request` but accepts/returns a child
     * element instead of an `iq`.
     *
     * @example
     * const foo = await iqCaller.set(
     *   xml('foo', 'foo:bar'),
     *   to, // 'to' attribute, optional
     *   timeout, // 30 seconds timeout - default
     * );
     * console.log(foo);
     */
    set(element: Element, to?: string, timeout?: number): Promise<Element | undefined>;
  }
}
