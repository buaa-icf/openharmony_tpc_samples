/**
 * ISC License
 * Copyright (C) 2024 Huawei Device Co., Ltd.
 * Permission to use, copy, modify, and/or distribute this software for any
 * purpose with or without fee is hereby granted, provided that the above
 * copyright notice and this permission notice appear in all copies.
 * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES WITH
 * REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY
 * AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY SPECIAL, DIRECT,
 * INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM
 * LOSS OF USE, DATA OR PROFITS, WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE
 * OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR
 * PERFORMANCE OF THIS SOFTWARE.
 */

"use strict";
import { parseURI } from "@ohos/xmpp_connection/src/main/lib/util";
import socket from "@ohos.net.socket";
import { EventEmitter } from "@ohos/node-polyfill";
var tls = socket.constructTLSSocketInstance()

class Socket extends EventEmitter {
  constructor() {
    super();
    this.listeners = Object.create(null);
    this.timeout = null;
  }

  async connect(service) {
    const { port, hostname } = parseURI(service);
    let options = {
      address: {
        address: hostname,
        port: port != "5223" ? 5223 : parseInt(port)
      }
    };
    try{
      await tls.bind(options.address)
      tls.connect(options, (err) => {
        if (!err) {
          console.info('tlsSocket-----------------connect')
        } else {
          console.error('tlsSocket-----------------connect-err' , JSON.stringify(err))
        }
      })
    } catch (e) {
      this.emit('close');
      console.error('tls-connect-error',JSON.stringify(e))
    }
    this._attachSocket(tls);
  }
  _attachSocket(socket) {
    this.socket = socket;
    const { listeners } = this;
    this.socket.on('close',()=>{
      this._detachSocket();
      this.emit("close");
    })
    this.socket.on('message',(data)=>{
      const uintArray = new Uint8Array(data.message)
      let str = ''
      for (let i = 0; i < uintArray.length; ++i) {
        str += String.fromCharCode(uintArray[i])
      }
      this.emit("data", str);
    })
    this.socket.on('error',(err)=>{
      // this.emit("error",  new Error(err.errorString));
      // this.emit("error",  err);
      this.emit('close');
      console.info("the--xmpp--error-is---"+JSON.stringify(err));
    })
    this.socket.on('connect',()=>{
      if (this.socket.getProtocol() !== "TLSv1.3") {
        return this.emit("connect");
      }
      // Waiting before sending the stream header improves compatibility
      // with Openfire TLSv1.3 implementation. For more info, see:
      // https://github.com/xmppjs/xmpp.js/issues/889#issuecomment-902686879
      // https://github.com/xmppjs/xmpp.js/pull/912
      this.timeout = setTimeout(() => {
        this.emit("connect");
      }, 1);
    })
  }

  _detachSocket() {
    clearTimeout(this.timeout);
    const { socket } = this;
    // socket.off("message",(value)=>{
    //   console.info("tlsSocket--message--off")
    // });
    // socket.off("connect",()=>{
    //   console.info("tlsSocket--connect--off")
    // });
    delete this.socket;
  }

  async end() {
    await this.socket.close();
  }

  write(data, fn) {
    this.socket.send(data);
    fn()
  }
}

export default Socket;
