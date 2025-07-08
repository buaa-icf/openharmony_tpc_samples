/* global WebSocket */
import SocketHarmony from './Socket.harmonyos';

let WebSocketController;

try {
    WebSocketController = SocketHarmony;
} catch (_) {
  // WebSocket unavailable
}

export default WebSocketController;
