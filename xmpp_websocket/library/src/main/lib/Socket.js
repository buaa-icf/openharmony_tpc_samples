/**
 * ISC License
 * Copyright (C) 2024 Huawei Device Co., Ltd.
 *
 * Permission to use, copy, modify, and/or distribute this software for any
 * purpose with or without fee is hereby granted, provided that the above
 * copyright notice and this permission notice appear in all copies.
 *
 * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES WITH
 * REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY
 * AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY SPECIAL, DIRECT,
 * INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM
 * LOSS OF USE, DATA OR PROFITS, WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE
 * OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR
 * PERFORMANCE OF THIS SOFTWARE.
 * */

"use strict";
import webSocket from '@ohos.net.webSocket';

import {EventEmitter} from "@ohos/node-polyfill";

const CODE = "ECONNERROR";

export class Socket extends EventEmitter {
    constructor() {
        super();
        this.listeners = Object.create(null);
    }

    async connect(url,caPath) {
        this.url = url;
        const socket = webSocket.createWebSocket();
        const header = {
            caPath: caPath,
            protocol: "xmpp",
            clientCert: {
                certPath: "",
                keyPath: "",
                keyPassword: ""
            },
            header: {
                Upgrade: 'WebSocket',
                Connection: 'Upgrade',
            }
        }
        socket.connect(url, header, (err, value) => {
            if (!err) {
                console.info('connect------value' + JSON.stringify(value))
            } else {
                console.error('connect------err' + JSON.stringify(err))
            }
        })

        this._attachSocket(socket);
    }

    _attachSocket(socket) {
        this.socket = socket;
        const { listeners } = this;
        listeners.open = () => {
            this.emit("connect");
        };

        listeners.message = ({ data }) => this.emit("data", data);
        listeners.error = (err) => {
            if (err) {
                console.error('websocket error:' + JSON.stringify(err))
            }
        };

        listeners.close = (event) => {
            this._detachSocket();
            this.emit("close", !event.wasClean, event);
        };
        this.socket.on('open',(err,value)=>{
            console.log("NB----open err "+JSON.stringify(err))
            console.log("NB----open "+JSON.stringify(value))
            this.emit("connect");
        })
        this.socket.on('message',(err,value)=>{
            this.emit("data", value)
        })

        this.socket.on('headerReceive', (data) => {
            console.log("on headerReceive " + JSON.stringify(data));
        });

        this.socket.on('error',(err)=>{
            if (err) {
                if (err.code == 200) {
                    this.emit('close');
                }
                console.error('websocket error:' + JSON.stringify(err))
            }
        })

        this.socket.on('close', (err, value) => {
            console.info("CQ-----socket on-"+JSON.stringify(value))
            this._detachSocket();
            this.emit("close", !value.wasClean, value);
        })
        // this.socket.addEventListener("open",listeners.open );
        // this.socket.addEventListener("message", listeners.message);
        // this.socket.addEventListener("error", listeners.error);
        // this.socket.addEventListener("close", listeners.close);

    }

    _detachSocket() {
        delete this.url;
        const { socket, listeners } = this;
        for (const k of Object.getOwnPropertyNames(listeners)) {
            socket.off(k, listeners[k]);
            delete listeners[k];
        }
        delete this.socket;
    }

    end() {
        this.socket.close();
    }

    write(data, fn) {
        console.log("xmpp---write"+JSON.stringify(data))
        this.socket.send(data, (err, value) => {
            if (err) {
                console.error('send-----------------------err-' + JSON.stringify(err))
            } else {
                console.info('send-----------------------value-' + JSON.stringify(value))
            }
        });
        fn();
    }
};
