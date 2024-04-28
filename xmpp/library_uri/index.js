"use strict";

// const jid = require("@xmpp/jid");
import {jid} from "@xmpp/jid"
// const { IRI } = require("iri");
import {querystring} from '@ohos/node-polyfill'
import {IRI} from './src/main/uri/iri'
function findQueryType(params) {
  return Object.getOwnPropertyNames(params).find((k) => {
    return k[0] === "?" && params[k] === "";
  });
}

function parse(str) {
  const iri = new IRI(str);

  const uri = {};

  const path = iri.path();
  uri.path = jid(path.startsWith("/") ? path.slice(1) : path);

  const authority = iri.authority();
  if (authority) {
    uri.authority = jid(authority);
  }

  const query = iri.query();
  const params = querystring.parse(query, ";");
  const type = findQueryType(params);
  if (type) {
    delete params[type];
  }

  if (query) {
    uri.query = {
      type: type.slice(1),
      params,
    };
  }

  return uri;
}

// module.exports.parse = parse;

export {parse}