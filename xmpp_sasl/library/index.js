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

import { encode, decode } from "@xmpp/base64";
import SASLError from "./src/main/lib/SASLError";
import xml from "@ohos/xmpp_xml";
import SASLFactory from "saslmechanisms";

// https://xmpp.org/rfcs/rfc6120.html#sasl

const NS = "urn:ietf:params:xml:ns:xmpp-sasl";

function getMechanismNames(features) {
  return features
    .getChild("mechanisms", NS)
    .getChildElements()
    .map((el) => el.text());
}

async function authenticate(SASL, entity, mechname, credentials) {
  const mech = SASL.create([mechname]);
  if (!mech) {
    throw new Error("No compatible mechanism");
  }

  const { domain } = entity.options;
  const creds = {
    username: null,
    password: null,
    server: domain,
    host: domain,
    realm: domain,
    serviceType: "xmpp",
    serviceName: domain,
    ...credentials,
  };

  return new Promise((resolve, reject) => {
    const handler = (element) => {
      if (element.attrs.xmlns !== NS) {
        return;
      }

      if (element.name === "challenge") {
        mech.challenge(decode(element.text()));
        const resp = mech.response(creds);
        console.log("mechanisms---"+JSON.stringify(resp))

        entity.send(
          xml(
            "response",
            { xmlns: NS, mechanism: mech.name },
            typeof resp === "string" ? encode(resp) : "",
          ),
        );
        return;
      }

      if (element.name === "failure") {
        reject(SASLError.fromElement(element));
      } else if (element.name === "success") {
        resolve();
      }

      entity.removeListener("nonza", handler);
    };

    entity.on("nonza", handler);

    if (mech.clientFirst) {
      entity.send(
        xml(
          "auth",
          { xmlns: NS, mechanism: mech.name },
          encode(mech.response(creds)),
        ),
      );
    }
  });
}

export default function sasl({ streamFeatures }, credentials) {
  const SASL = new SASLFactory();
  streamFeatures.use("mechanisms", NS, async ({ stanza, entity }) => {
    const offered = getMechanismNames(stanza);
    const supported = SASL._mechs.map(({ name }) => name);
    // eslint-disable-next-line unicorn/prefer-array-find
    const intersection = supported.filter((mech) => {
      return offered.includes(mech);
    });
    // eslint-disable-next-line prefer-destructuring
    let mech = intersection[0];

    if (typeof credentials === "function") {
      await credentials(
        (creds) => authenticate(SASL, entity, mech, creds, stanza),
        mech,
      );
    } else {
      if (!credentials.username && !credentials.password) {
        mech = "ANONYMOUS";
      }

      await authenticate(SASL, entity, mech, credentials, stanza);
    }

    await entity.restart();
  });

  return {
    use(...args) {
      return SASL.use(...args);
    },
  };
};
