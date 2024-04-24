"use strict";

// const Connection = require("@xmpp/connection-tcp");
import Connection from "@xmpp/connection-tcp"

class ConnectionTCP extends Connection {
  socketParameters(service) {
    console.info("xmpp--- service --"+JSON.stringify(service))
    const params = super.socketParameters(service);
    console.info("xmpp--- params --"+JSON.stringify(params))
    if (!params) return params;
    params.port = params.port || 5222
    return params;
  }
}

ConnectionTCP.prototype.NS = "jabber:client";
export { ConnectionTCP };
