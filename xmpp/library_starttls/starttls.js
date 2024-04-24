"use strict";

// import tls from "tls";
import TLSSocket from '@ohos.net.socket'
import net from "net";
import { promise } from "@xmpp/events";
// import Socket from "@xmpp/tls/src/main/lib/Socket";

function canUpgrade(socket) {
    return socket instanceof net.Socket && !(socket instanceof TLSSocket);
    // return true
}


async function upgrade(socket, options = {}) {
  const tlsSocket = {  };
  // tlsSocket.connect({ socket, ...options });
  // await promise(tlsSocket, "connect");

  return tlsSocket ;
}

export { canUpgrade, upgrade };
