"use strict";

import { ConnectionWebSocket } from "./src/main/websocket/lib/Connection";

export default function websocket({ entity }) {
    entity.transports.push(ConnectionWebSocket);
};

