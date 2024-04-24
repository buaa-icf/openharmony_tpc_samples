/**
 * Copyright (C) 2024 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
import { Deferred } from "@xmpp/events";
import { Entity, Middleware } from "@xmpp/middleware";
import { Element } from "@xmpp/xml";

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
