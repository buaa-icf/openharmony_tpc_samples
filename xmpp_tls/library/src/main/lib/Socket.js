/**
 * ISC License
 * Copyright (C) 2024 Huawei Device Co., Ltd.
 * Permission to use, copy, modify, and/or distribute this software for any
 * purpose with or without fee is hereby granted, provided that the above
 * copyright notice and this permission notice appear in all copies.
 * THE SOFTWARE IS PROVIDED 'AS IS' AND THE AUTHOR DISCLAIMS ALL WARRANTIES WITH
 * REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY
 * AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY SPECIAL, DIRECT,
 * INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM
 * LOSS OF USE, DATA OR PROFITS, WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE
 * OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR
 * PERFORMANCE OF THIS SOFTWARE.
 */

'use strict';
import { parseURI } from '@ohos/xmpp_connection/src/main/lib/util';
import socket from '@ohos.net.socket';
import { EventEmitter } from '@ohos/node-polyfill';
import { fileIo as fs } from '@kit.CoreFileKit';
import buffer from '@ohos.buffer';

class Socket extends EventEmitter {
  tlsSocket; // TLS Socket实例
  timeout; // 定时器ID
  connecting; // 连接状态

  constructor() {
    super();
    this.tlsSocket = socket.constructTLSSocketInstance(); // 实例级别的TLS对象
    this.timeout = null;
    this.connecting = false; // 添加连接状态管理
  }

  async connect(service, caPath) {
    // 防止重复连接
    if (this.connecting) {
      console.warn('TLS Socket已在连接中，忽略重复调用');
      return;
    }

    this.connecting = true;

    try {
      const { port, hostname } = parseURI(service);
      const certContent = fs.readTextSync(caPath);
      let options = {
        address: {
          address: hostname,
          port: port != '5223' ? 5223 : parseInt(port)
        },
        secureOptions: {
          ca: certContent
        }
      };
      console.info('TLS正在绑定地址...');
      await this.tlsSocket.bind(options.address);
      console.info('TLS正在连接...');
      await this.tlsSocket.connect(options);
      this.connecting = false;
      this._attachSocket();
      this.emit('connect');
    } catch (e) {
      this.connecting = false;
      console.error('TLS连接异常:', JSON.stringify(e));
      this.emit('error', e);
      this.emit('close', true);
    }
  }

  _attachSocket() {
    this._detachSocket();
    this.tlsSocket.on('close', () => {
      this._detachSocket();
      this.emit('close');
    })
    this.tlsSocket.on('message', (data) => {
      // 使用buffer.from().toString()高效转换，与TCP保持一致
      this.emit('data', buffer.from(data.message).toString());
    })
    this.tlsSocket.on('error', (err) => {
      console.error('TLS Socket错误:', JSON.stringify(err));
      this.emit('error', err);
      this.emit('close', true);
    })
    this.tlsSocket.on('connect', () => {
      if (this.tlsSocket.getProtocol() !== 'TLSv1.3') {
        return this.emit('connect');
      }
      // Waiting before sending the stream header improves compatibility
      // with Openfire TLSv1.3 implementation. For more info, see:
      // https://github.com/xmppjs/xmpp.js/issues/889#issuecomment-902686879
      // https://github.com/xmppjs/xmpp.js/pull/912
      this.timeout = setTimeout(() => {
        this.emit('connect');
      }, 1);
    })
  }

  _detachSocket() {
    if (this.timeout) {
      clearTimeout(this.timeout);
      this.timeout = null;
    }
    if (this.tlsSocket) {
      // 移除所有监听器
      this.tlsSocket.off('message');
      this.tlsSocket.off('connect');
      this.tlsSocket.off('close');
      this.tlsSocket.off('error');
      console.info('TLS Socket监听器已移除');
    }
  }

  async end() {
    try {
      if (this.tlsSocket) {
        // 先清理监听器
        this._detachSocket();
        // 再关闭socket
        await this.tlsSocket.close();
      }
      // 先emit事件，再移除监听器
      this.emit('close', false);
      this.removeAllListeners();
    } catch (error) {
      console.error('TLS关闭异常:', error);
      this.emit('error', error);
      this.emit('close', true);
    }
  }

  async write(data, fn) {
    // 等待连接建立
    if (this.connecting) {
      console.log('TLS等待连接建立...');
      await new Promise(resolve => this.once('connect', resolve));
    }

    // 检查socket是否存在
    if (!this.tlsSocket) {
      const err = new Error('TLS Socket未连接，请先调用connect()');
      console.error(err.message);
      if (fn) {
        fn(err);
      }
      return;
    }

    try {
      await this.tlsSocket.send(data);
      if (fn) {
        fn();
      }
    } catch (err) {
      console.error('TLS发送失败:', err);
      if (fn) {
        fn(err);
      }
    }
  }

  destroy() {
    try {
      console.log('强制销毁TLS连接');
      if (this.tlsSocket) {
        this.tlsSocket.close();
      }
      this.connecting = false;
      // 移除socket的监听器
      this._detachSocket();
      // 先emit事件，再移除监听器
      this.emit('close', true);
      this.removeAllListeners();
    } catch (err) {
      console.error('TLS destroy失败:', err);
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

export default Socket;
