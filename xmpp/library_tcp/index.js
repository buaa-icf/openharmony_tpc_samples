"use strict";

// const ConnectionTCP = require("./src/main/tcp/lib/Connection");
import { ConnectionTCP } from './src/main/tcp/lib/Connection'
export default function tcp({ entity }) {
  entity.transports.push(ConnectionTCP);
};
