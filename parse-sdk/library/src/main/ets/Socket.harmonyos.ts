import webSocket from '@ohos.net.webSocket';

class SocketHarmony {
  onopen: () => void;
  onmessage: () => void;
  onclose: () => void;
  onerror: () => void;
  ws: webSocket.WebSocket;

  constructor(serverURL) {
    this.onopen = () => {};
    this.onmessage = () => {};
    this.onclose = () => {};
    this.onerror = () => {};

    this.ws = webSocket.createWebSocket();

    this.ws.on('open', (err, value) => {
      this.onopen();
    })

    this.ws.on('message', (err, msg) => {
      // @ts-ignore
      this.onmessage(msg);
    })

    this.ws.on('close', (err, event) => {
      // @ts-ignore
      this.onclose(event);
    });

    this.ws.on('error', (error) => {
      // @ts-ignore
      this.onerror(error);
    });

    this.ws.connect(serverURL);
  }

  send(data) {
    this.ws.send(data)
  }

  close() {
    // @ts-ignore
    this.ws.closeSocket();
  }
}

export default SocketHarmony;
