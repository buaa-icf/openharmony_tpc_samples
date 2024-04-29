"use strict";

// const Context = require("./Context");
import {Context} from './Context'
// const JID = require("@xmpp/jid");
import {JID} from "@xmpp/jid";

 class OutgoingContext extends Context {
  constructor(entity, stanza) {
    super(entity, stanza);

    const { jid, domain } = entity;

    const from = stanza.attrs.from || (jid && jid.toString());
    const to = stanza.attrs.to || domain;

    if (from) this.from = parse(from);

    if (to) {
      this.to = parse(to);
      this.local = this.to.local;
      this.domain = this.to.domain;
      this.resource = this.to.resource;
    }
  }
};

export {OutgoingContext}
