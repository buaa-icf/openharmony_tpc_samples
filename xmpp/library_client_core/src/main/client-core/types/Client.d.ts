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
import Connection from "@xmpp/connection/index";
import { Element } from "@xmpp/xml/index";

export = Client;

declare class Client extends Connection {
  transports: Array<typeof Connection>;

  Transport?: typeof Connection;
  send(element: Element, ...args: unknown[]): Promise<void>;
  sendMany(elements: Iterable<Element>, ...args: unknown[]): Promise<void>;
  header(el: Element, ...args: unknown[]): string;
  headerElement(...args: unknown[]): Element;
  footer(el: Element, ...args: unknown[]): string;
  footerElement(...args: unknown[]): Element;
  socketParameters(service: string, ...args: unknown[]): unknown | undefined;
}
