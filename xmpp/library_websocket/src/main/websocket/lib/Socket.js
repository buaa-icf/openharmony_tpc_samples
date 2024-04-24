"use strict";
import webSocket from '@ohos.net.webSocket';
// import WS from "ws";
// const  WebSocket = global.WebSocket || WS;

import {EventEmitter} from "@ohos/node-polyfill";

const CODE = "ECONNERROR";

export class Socket extends EventEmitter {
  constructor() {
    super();
    this.listeners = Object.create(null);
  }

  connect(url) {
    this.url = url;
    const  socket = webSocket.createWebSocket();
    socket.connect(url)
    this._attachSocket(socket);
  }

  _attachSocket(socket) {
    this.socket = socket;
    const { listeners } = this;
    listeners.open = () => {
      this.emit("connect");
    };

    listeners.message = ({ data }) => this.emit("data", data);
    listeners.error = (event) => {
      const { url } = this;
      // WS
      let { error } = event;
      // DOM
      if (!error) {
        error = new Error(`WebSocket ${CODE} ${url}`);
        error.errno = CODE;
        error.code = CODE;
      }

      error.event = event;
      error.url = url;
      this.emit("error", error);
    };

    listeners.close = (event) => {
      this._detachSocket();
      this.emit("close", !event.wasClean, event);
    };
   this.socket.on('open',(err,value)=>{
       console.log("xmpp----open err "+JSON.stringify(err))
       console.log("xmpp----open "+JSON.stringify(value))
     this.emit("connect");
   })
    this.socket.on('message',(err,value)=>{
      this.emit("data", value)
    })

    this.socket.on('error',(err)=>{
     console.log("xmpp----测试error"+JSON.stringify(err))
      const { url } = this;
      // WS
      let { error } = err;
      // DOM
      if (!error) {
        error = new Error(`WebSocket ${CODE} ${url}`);
        error.errno = CODE;
        error.code = CODE;
      }

      error.event = err;
      error.url = url;
      this.emit("error", error);
    })

    this.socket.on('close',(err,value)=>{
      this._detachSocket();
      this.emit("close", !value.wasClean, value);
    })

    // this.socket.addEventListener("open", );
    // this.socket.addEventListener("message", listeners.message);
    // this.socket.addEventListener("error", listeners.error);
    // this.socket.addEventListener("close", listeners.close);
  }

  _detachSocket() {
    delete this.url;
    const { socket, listeners } = this;
    for (const k of Object.getOwnPropertyNames(listeners)) {
      socket.removeEventListener(k, listeners[k]);
      delete listeners[k];
    }
    delete this.socket;
  }

  end() {
    this.socket.close();
  }

  write(data, fn) {
    // if (WebSocket === WS) {
    //   this.socket.send(data, fn);
    // } else {
    //   this.socket.send(data);
    //   fn();
    // }
      console.info("xmpp---write ---"+JSON.stringify(data))
    this.socket.send(data);

    fn();
  }
};
