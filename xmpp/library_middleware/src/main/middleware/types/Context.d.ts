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
import { JID } from "@xmpp/jid";
import { Element } from "@xmpp/xml";
import { Entity } from "../../../../index";

export = Context;

declare class Context<TEntity extends Entity> {
  stanza: Element;
  entity: TEntity;
  name: string;
  id: string;
  type: string;
  from: JID | null;
  to: JID | null;
  local: string;
  domain: string;
  resource: string;

  constructor(entity: TEntity, stanza: Element);
}