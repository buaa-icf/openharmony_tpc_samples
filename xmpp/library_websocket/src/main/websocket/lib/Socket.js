"use strict";
import webSocket from '@ohos.net.webSocket';
// const  WebSocket = global.WebSocket || WS;

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
                console.error('connect------value' + JSON.stringify(value))
            } else {
                console.info('connect------err' + JSON.stringify(err))
            }
        })

        this._attachSocket(socket);
        // this._attachSocket(new WebSocket(url,['xmpp']));
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
            // delete listeners[k];
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
