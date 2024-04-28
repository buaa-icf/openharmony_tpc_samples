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
import { Entity, IncomingContext, Middleware } from "@xmpp/middleware";
import * as koaCompose from "koa-compose";

export = iqCallee;

declare function iqCallee<TEntity extends Entity>({
                                                    middleware,
                                                    entity,
                                                  }: {
  middleware: Middleware<TEntity>;
  entity: TEntity;
}): iqCallee.IQCallee<TEntity>;

declare namespace iqCallee {
  /**
   * Implements the callee side of iq semantics.
   *
   * You can think of this as http routing except there are only 2 methods; `get` and `set`
   * and you would pass a namespace and a tag name instead of an url. The return value of
   * the handler will be the child element of the response sent to the caller.
   */
  // eslint-disable-next-line @typescript-eslint/naming-convention
  interface IQCallee<TEntity extends Entity> {
    /**
     * Add a `get` handler.
     *
     * @example
     * iqCallee.get('foo:bar', 'foo', (ctx) => {
     *   return xml('foo', { xmlns: 'foo:bar' });
     * });
     */
    get(ns: string, name: string, handler: koaCompose.Middleware<IncomingContext<TEntity>>): void;
    /**
     * Add a `set` handler.
     *
     * @example
     * iqCallee.set('foo:bar', 'foo', (ctx) => {
     *   return xml('foo', { xmlns: 'foo:bar' });
     * });
     */
    set(ns: string, name: string, handler: koaCompose.Middleware<IncomingContext<TEntity>>): void;
  }
}