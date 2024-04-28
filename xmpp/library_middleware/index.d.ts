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
import * as koaCompose from "koa-compose";
import Connection from "@xmpp/connection";
import { Element } from "@xmpp/xml";
import IncomingCtx from  "./src/main/middleware/types/IncomingContext";
import OutgoingCtx from "./src/main/middleware/types/OutgoingContext";

export = middleware;

declare function middleware<TEntity extends middleware.Entity>({
                                                                 entity,
                                                               }: {
  entity: TEntity;
}): middleware.Middleware<TEntity>;

declare namespace middleware {
  type IncomingContext<TEntity extends Entity> = IncomingCtx<TEntity>;
  type OutgoingContext<TEntity extends Entity> = OutgoingCtx<TEntity>;

  interface Entity extends Connection {
    domain?: string;
    hookOutgoing?: (stanza: Element) => Promise<void>;
  }

  interface Middleware<TEntity extends Entity> {
    use<TMiddleware extends koaCompose.Middleware<IncomingContext<TEntity>>>(middleware: TMiddleware): TMiddleware;
    filter<TMiddleware extends koaCompose.Middleware<OutgoingContext<TEntity>>>(
      middleware: TMiddleware,
    ): TMiddleware;
  }
}
