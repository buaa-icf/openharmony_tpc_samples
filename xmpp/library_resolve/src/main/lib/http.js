"use strict";
import axios from "@ohos/axios";
// const fetch = global.fetch || node_fetch;
import { parse } from "@xmpp/xml/src/main/xml/lib/parse";
import * as altConnections from "./alt-connections";
const  compareAltConnections = altConnections.compare;

function resolve(domain) {
  return axios.get(`https://${domain}/.well-known/host-meta`)
    .then((res) => res.text())
    .then((res) => {
      return parse(res)
        .getChildren("Link")
        .filter((link) =>
          [
            "urn:xmpp:alt-connections:websocket",
            "urn:xmpp:alt-connections:httppoll",
            "urn:xmpp:alt-connections:xbosh",
          ].includes(link.attrs.rel),
        )
        .map(({ attrs }) => ({
          rel: attrs.rel,
          href: attrs.href,
          method: attrs.rel.split(":").pop(),
          uri: attrs.href,
        }))
        .sort(compareAltConnections);
    })
    .catch(() => {
      return [];
    });
};

export default resolve;
