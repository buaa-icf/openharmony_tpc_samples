"use strict";

import ConnectionTLS from "./src/main/lib/Connection";

export default function tls({ entity }) {
  entity.transports.push(ConnectionTLS);
};
