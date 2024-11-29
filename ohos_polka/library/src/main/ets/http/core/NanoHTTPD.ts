/**
 * MIT License
 *
 * Copyright (c) 2024 Huawei Device Co., Ltd.
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the 'Software'), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to all conditions.
 *
 * The above copyright notice and this permission notice shall be included in all
 * copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 */

import buffer from '@ohos.buffer';
import socket from '@ohos.net.socket';
import type { BusinessError } from '@ohos.base';
import { IncomingMessage } from './request/IncomingMessage';
import type { ServerResponse } from './response/ServerResponse';
import { BufferPool } from './request/BufferPool';
import { EventEmitter } from '../../common/util/event-emitter';
import type { Logger } from '../../common/util/log';
import { getLogger } from '../../common/util/log';

const logger: Logger = getLogger('NanoHTTPD');
const DEFAULT_SOCKET_TIMEOUT: number = 5000;

/**
 * 基于鸿蒙的@ohos.net.socket库的数据传输功能类
 **/
export class NanoHTTPD extends EventEmitter {
  public static contentTypeRegex = /([ |\t]*content-type[ |\t]*:)(.*)/;
  public static contentDispositionRegex = /([ |\t]*Content-Disposition[ |\t]*:)(.*)/;
  public static contentDispositionAttributeRegex = /[ |\t]*([a-zA-Z]*)[ |\t]*=[ |\t]*['|\"]([^\"^']*)['|\"]/;
  public static readonly mimePlaintext: string = 'text/plain';
  public static readonly mimeHtml: string = 'text/html';
  public static socketReadTimeout: number = DEFAULT_SOCKET_TIMEOUT;
  private static queryStringParameter: string = 'NanoHttpd.QUERY_STRING';
  public listeningListener: (message?: string) => void;
  public myServerSocket: socket.TCPSocketServer;
  public serverConnectArray: socket.TCPSocketConnection[] = [];
  public hostname: string;
  public myPort: number;
  private serverIsStarted: boolean = false;
  private serverSocketFactory: socket.TCPSocketServer = socket.constructTCPSocketServerInstance();
  private options;
  private bufferPoolArray: BufferPool[] = [];
  private callback;

  constructor(options = {}) {
    super();
    this.options = Object.assign({
      hostname: 'localhost',
      myPort: '8080',
      cors: '',
    }, options);
    this.hostname = this.options.hostname;
    this.myPort = this.options.myPort;
  }

  /**
   * 解码
   *
   * @param str 编码<code>String</code>
   * @return expanded form of the input, for example "foo%20bar" becomes "foo bar"
   */
  public static decodePercent(str: string): string {
    let decoded: string = '';
    try {
      decoded = decodeURI(str);
    } catch (e) {
      logger.error(`decodeURI: ${e.message}`);
    }
    return decoded;
  }

  /**
   * 从URL中解码参数，通过返回值列表来处理单个参数名称可能多次提供的情况。通常，这些列表将包含单个元素
   *
   * @param queryString 从URL提取的查询字符串
   * @return a map of <code>String</code> (parameter name) to <code>List&lt;
   *         String&gt;</code> (a list of the values supplied).
   */
  protected static decodeParameters(queryString: string | Map<string, string>): Map<string, string[]> {
    let params: Map<string, string[]> = new Map<string, string[]>();
    let curStr: string | undefined = '';
    if (typeof queryString !== 'string') {
      curStr = queryString.get(this.queryStringParameter);
    } else {
      curStr = queryString;
    }
    if (curStr != null) {
      let stringTokenizer: string[] = curStr.split('&');
      while (stringTokenizer.length) {
        let e: string = stringTokenizer.shift();
        let sep: number = e.indexOf('=');
        let propertyName: string = '';
        let propertyValue: string = '';
        if (sep >= 0) {
          propertyName = this.decodePercent(e.substring(0, sep)).trim();
          propertyValue = this.decodePercent(e.substring(sep + 1));
        } else {
          propertyName = this.decodePercent(e).trim();
          propertyValue = '';
        }
        if (!params.has(propertyName)) {
          params.set(propertyName, new Array<string>());
        }
        if (propertyValue !== '') {
          params.get(propertyName)?.push(propertyValue);
        }
      }
    }
    return params;
  }

  /**
   * 开启server.
   */
  public start(timeout?: number): void {
    this.myServerSocket = this.getServerSocketFactory();
    if ((timeout !== undefined) && timeout > 0) {
      this.createServer(timeout);
    } else {
      this.createServer();
    }
  }

  /**
   * 停止server
   */
  public stop(): void {
    try {
      this.safeClose();
    } catch {
      logger.error('Failed to stop the service.');
    }
  }

  /**
   * 获取socket服务
   *
   * @return 返回socket服务
   */
  public getMyServerSocket(): socket.TCPSocketServer {
    return this.myServerSocket;
  }

  /**
   * 覆盖此项以自定义服务器
   *
   * (By default, this returns a 404 "Not Found" plain text error response.)
   * @param session IncomingMessage
   * @param response ServerResponse
   * @return HTTP响应
   */
  public serve(session: IncomingMessage, response: ServerResponse): void {}

  /**
   * 获取TCPSocketServer
   *
   * @return 返回一个TCPSocketServer
   */
  public getServerSocketFactory(): socket.TCPSocketServer {
    return this.serverSocketFactory;
  }

  /**
   * 获取主机名
   *
   * @return 返回主机名
   */
  public getHostname(): string {
    return this.hostname;
  }

  /**
   * 获取端口号
   *
   * @return 返回端口号
   */
  public getListeningPort(): number {
    return this.serverIsStarted ? this.myPort : -1;
  }

  /**
   * 检查服务是否启动
   *
   * @return boolean
   */
  public wasStarted(): boolean {
    return this.serverIsStarted;
  }

  /**
   * 关闭服务
   */
  private safeClose(): void {
    this.myServerSocket?.off('connect');
    const tcpConnectArrayLength: number = this.serverConnectArray.length;
    for (let i = 0; i < tcpConnectArrayLength; i++) {
      this.serverConnectArray[i]?.off('message');
      this.serverConnectArray[i]?.off('close');
    }
    this.bufferPoolArray = [];
    this.serverConnectArray = [];
    this.serverIsStarted = false;
  }

  /**
   * 创建Socket
   *
   * @param timeout 超时时间
   */
  private createServer(timeout?: number): void {
    let listenAddr: socket.NetAddress = {
      address: this.hostname,
      port: this.myPort,
      family: 1,
    };

    this.myServerSocket.listen(listenAddr, (err: BusinessError) => {
      if (err !== undefined) {
        this.listeningListener(err.message);
        return;
      }
      if (this.listeningListener !== undefined) {
        this.serverIsStarted = true;
        this.listeningListener(`> Running on ${this.hostname}:${this.myPort}`);
      }
    });

    let serverExtraOptions = {
      socketTimeout: (timeout !== undefined) ? timeout : NanoHTTPD.socketReadTimeout,
    };
    this.myServerSocket.setExtraOptions(serverExtraOptions).then(() => {
      logger.info('setExtraOptions success');
    }).catch((err: BusinessError) => {
      logger.error(`setExtraOptions fail ${err}`);
    });
    this.callback = (client: socket.TCPSocketConnection): void => {
      this.serverConnectArray.push(client);
      let bufferPool: BufferPool = new BufferPool(IncomingMessage.BUFSIZE);
      this.bufferPoolArray.push(bufferPool);
      bufferPool.on('headerEvent', (eventData) => {
        let hs: IncomingMessage = new IncomingMessage(this, bufferPool, eventData?.data?.header as string, client);
        hs.execute(client, bufferPool);
      });
      client.on('message', (value: socket.SocketMessageInfo) => {
        bufferPool.pushMsg(buffer.from(value.message));
      });
      client.on('close', () => {
        this.bufferPoolArray = this.bufferPoolArray.filter(pool => pool === bufferPool)
        this.serverConnectArray.filter(tmpClient => tmpClient === client)
        bufferPool.removeAllListeners();
        client.off('message')
      });
    };
    this.myServerSocket.on('connect', this.callback);
    this.myServerSocket.on('error', err => {
      logger.error(`on error, err: ${JSON.stringify(err)}`);
    });
  }
}