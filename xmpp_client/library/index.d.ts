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



import { Client as ClientCore, jid as xmppJid, xml as xmppXml } from "@ohos/xmpp_client_core";
import { Options as ConnectionOptions } from "@ohos/xmpp_connection";
import { IQCallee } from "@ohos/xmpp_iq/src/main/types/callee";
import { IQCaller } from "@ohos/xmpp_iq/src/main/types/caller";
import { IncomingContext, Middleware } from "@ohos/xmpp_middleware";
import { Reconnect } from "@ohos/xmpp_reconnect";
import { Resource } from "@ohos/xmpp_resoure_binding";
import { Credentials, SASL } from "@ohos/xmpp_sasl";
import { StreamFeatures } from "@ohos/xmpp_stream_features";
import { StreamManagement } from "@ohos/xmpp_stream_management";
import * as koaCompose from "koa-compose";


interface ServiceOptions{
  service: string,
  domain?: string,
  username?:string,
  password?:string,
  resource?:string,
  credentials?:string
}
/**
 * An XMPP client is an entity that connects to an XMPP server.
 *
 * `@xmpp/client` package includes a minimal set of features to connect and authenticate securely and reliably.
 *
 * @example
 * import { client, xml } from "@xmpp/client";
 * import debug = require("@xmpp/debug");
 *
 * const xmpp = client({
 *   service: "ws://localhost:5280/xmpp-websocket",
 *   domain: "localhost",
 *   resource: "example",
 *   username: "username",
 *   password: "password",
 * });
 *
 * debug(xmpp, true);
 *
 * xmpp.on("error", (err) => {
 *   console.error(err);
 * });
 *
 * xmpp.on("offline", () => {
 *   console.log("offline");
 * });
 *
 * xmpp.on("stanza", async (stanza) => {
 *   if (stanza.is("message")) {
 *     await xmpp.send(xml("presence", { type: "unavailable" }));
 *     await xmpp.stop();
 *   }
 * });
 *
 * xmpp.on("online", async (address) => {
 *   // Makes itself available
 *   await xmpp.send(xml("presence"));
 *
 *   // Sends a chat message to itself
 *   const message = xml(
 *     "message",
 *     { type: "chat", to: address },
 *     xml("body", {}, "hello world"),
 *   );
 *   await xmpp.send(message);
 * });
 *
 * xmpp.start().catch(console.error);
 */
export function client(options?: Options): Client;

export interface Options extends ConnectionOptions {
  /**
   * Resource for `@xmpp/resource-binding`.
   */
  resource?: Resource | undefined;
  credentials?: Credentials | undefined;
  /**
   * Username for `@xmpp/sasl`.
   */
  username?: string | undefined;
  /**
   * Password for `@xmpp/sasl`.
   */
  password?: string | undefined;

  caPath?:string | undefined;
}

export interface Client extends ClientCore {
  entity: Client;
  reconnect: Reconnect<Client>;
  middleware: Middleware<Client>;
  streamFeatures: StreamFeatures<Client>;
  iqCaller: IQCaller<Client>;
  iqCallee: IQCallee<Client>;
  starttls: koaCompose.Middleware<IncomingContext<Client>>;
  sasl: SASL;
  streamManagement: StreamManagement;
  mechanisms: Array<{ scramsha1: undefined } | { plain: undefined } | { anonymous: undefined }>;
}

export const jid: typeof xmppJid;
export const xml: typeof xmppXml;