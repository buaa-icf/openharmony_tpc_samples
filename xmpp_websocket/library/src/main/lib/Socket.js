/**
 * ISC License
 * Copyright (C) 2026 Huawei Device Co., Ltd.
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

'use strict';
import webSocket from '@ohos.net.webSocket';
import {EventEmitter} from '@ohos/node-polyfill';

export class Socket extends EventEmitter {
    mWebSocket; // WebSocket实例
    url; // 连接URL
    connecting; // 连接状态

    constructor() {
        super();
        this.mWebSocket = webSocket.createWebSocket();
        this.url = null;
        this.connecting = false;
    }

    async connect(url, caPath) {
        // 防止重复连接
        if (this.connecting) {
            console.warn('WebSocket已在连接中，忽略重复调用');
            return;
        }
        this.connecting = true;
        this.url = url;

        try {
            const options = {
                caPath: caPath,
                protocol: 'xmpp',
                clientCert: {
                    certPath: '',
                    keyPath: '',
                    keyPassword: ''
                },
                header: {
                    Upgrade: 'WebSocket',
                    Connection: 'Upgrade',
                }
            };
            this._attachSocket();
            if (!await this.mWebSocket.connect(url, options)) {
                this.emit('error', new Error('webSocket连接请求创建失败'));
            }
        } catch (e) {
            console.error('WebSocket连接异常:', JSON.stringify(e));
            this._detachSocket();
            this.emit('error', e);
            this.emit('close', true);
        } finally {
            this.connecting = false;
        }
    }

    _attachSocket() {
        this._detachSocket();
        this.mWebSocket.on('open', (err, value) => {
            if (err) {
                console.error('WebSocket open错误:', JSON.stringify(err));
                this.emit('error', err);
            } else {
                console.log('WebSocket open:', JSON.stringify(value));
                this.emit('connect');
            }
        });

        this.mWebSocket.on('message', (err, value) => {
            if (err) {
                console.error('WebSocket message错误:', JSON.stringify(err));
                this.emit('error', err);
            } else {
                this.emit('data', value);
            }
        });

        this.mWebSocket.on('headerReceive', (data) => {
            console.log('WebSocket headerReceive:', JSON.stringify(data));
        });

        this.mWebSocket.on('error', (err) => {
            if (err) {
                console.error('WebSocket error:', JSON.stringify(err));
                this.emit('error', err);
                this.emit('close', true);
            }
        });

        this.mWebSocket.on('close', (err, value) => {
            console.info('WebSocket close:', JSON.stringify(value));
            this._detachSocket();
            if (err) {
                console.error('WebSocket close错误:', JSON.stringify(err));
                this.emit('error', err);
                this.emit('close', true);
            } else {
                this.emit('close', false);
            }

        });
    }

    _detachSocket() {
        if (this.mWebSocket) {
            this.mWebSocket.off('open');
            this.mWebSocket.off('message');
            this.mWebSocket.off('headerReceive');
            this.mWebSocket.off('error');
            this.mWebSocket.off('close');
            console.info('WebSocket监听器已移除');
        }
        this.url = null;
    }

    async end() {
        try {
            if (this.mWebSocket) {
                this._detachSocket();
                await this.mWebSocket.close();
            }
            this.emit('close', false);
            this.removeAllListeners();
        } catch (error) {
            console.error('WebSocket关闭异常:', error);
            this.emit('error', error);
            this.emit('close', true);
        }
    }

    async write(data, fn) {
        // 等待连接建立
        if (this.connecting) {
            console.log('WebSocket等待连接建立...');
            await new Promise(resolve => this.once('connect', resolve));
        }

        // 检查socket是否存在
        if (!this.mWebSocket) {
            const err = new Error('WebSocket未连接，请先调用connect()');
            console.error(err.message);
            if (fn) {
                fn(err);
            }
            return;
        }

        try {
            if (!await this.mWebSocket.send(data)) {
                if (fn) {
                    fn(new Error('WebSocket发送失败'));
                }
            } else {
                if (fn) {
                    fn();
                }
            }
        } catch (err) {
            console.error('WebSocket发送异常:', err);
            if (fn) {
                fn(err);
            }
        }
    }

    destroy() {
        try {
            console.log('强制销毁WebSocket连接');
            if (this.mWebSocket) {
                this.connecting = false;
                this._detachSocket();
                this.mWebSocket.close();
            }
            this.emit('close', true);
            this.removeAllListeners();
        } catch (err) {
            console.error('WebSocket destroy失败:', err);
        }
    }

    removeAllListeners(event) {
        if (event) {
            super.removeAllListeners(event);
        } else {
            super.removeAllListeners();
        }
    }
}
