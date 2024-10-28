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
import type socket from '@ohos.net.socket';
import type { BusinessError } from '@ohos.base';
import type Cookie from '../content/Cookie';
import type { BufferPool } from '../request/BufferPool';
import ContentType from '../content/ContentType';
import { http } from '../../index';
import type { Logger } from '../../../common/util/log';
import { getLogger } from '../../../common/util/log';
const logger: Logger = getLogger('ServerResponse');

const NUM_ONE: number = 1;
const NUM_TWO: number = 2;

/**
 * 实现一个基础的ServerResponse类
 *
 * */
export class ServerResponse {
  public keepAlive: boolean;
  public client: socket.TCPSocketConnection;
  public bufferPool: BufferPool;
  public finished: boolean;
  public statusCode: number;
  public statusMessage: string | string[] | object;
  public writableEnded: boolean;
  public writableFinished: boolean;
  public headersSent: boolean;
  public sendDate: boolean;
  private mimeType: string;
  private data: string | ArrayBuffer;
  private contentLength: number;
  private headers: Map<string, string> = new Map();
  private headersOptions: string[];
  private cookieHeaders: string[];

  /**
   * Constructor Function
   * statusMessage: 状态信息
   * statusCode: 状态值
   * mimeType: Content-type
   * keepAlive: 是否开启keep-alive
   * cookieHeaders: 存储set-cookie信息
   * finished: 是否调用了end()方法
   * writableEnded: 是否调用了end()方法
   * writableFinished: 是否调用了client.send方法
   * headersSent: 已在响应中发送标头信息
   * sendDate: 响应体加时间
   * headersOptions: 默认标题信息
   */
  constructor() {
    this.statusMessage = 'OK';
    this.statusCode = 200;
    this.mimeType = '';
    this.keepAlive = true;
    this.cookieHeaders = [];
    this.finished = false;
    this.writableEnded = false;
    this.writableFinished = false;
    this.headersSent = false;
    this.sendDate = true;
    this.headersOptions = ['content-type', 'content-length', 'set-cookie', 'connection', 'date'];
  }

  /**
   * 输出响应头
   *
   * @param code 状态值
   * @param rest 可变参数数组
   **/
  public writeHead(code: number, ...rest): void {
    this.statusCode = code;
    const length: number = rest.length;
    if (length === NUM_TWO) {
      this.statusMessage = rest[0] || '';
      if (rest[1] instanceof Object) {
        for (let i in rest[1]) {
          if (Object.prototype.hasOwnProperty.call(rest[1], i)) {
            this.headers.set(i.toLowerCase(), rest[1][i] as string);
          }
        }
      }
      if (rest[1] instanceof Array) {
        for (let e of rest[1]) {
          this.headers.set(e.split('=')[0].toLowerCase(), e.split('=')[1]);
        }
      }
    } else if (length === NUM_ONE) {
      if (rest[0] && typeof rest[0] === 'string') {
        this.statusMessage = rest[0] || '';
      } else {
        this.statusMessage = http.STATUS_CODES[this.statusCode] as string;
        if (rest[0] instanceof Object) {
          for (let i in rest[0]) {
            if (Object.prototype.hasOwnProperty.call(rest[0], i)) {
              this.headers.set(i.toLowerCase(), rest[0][i] as string);
            }
          }
        }
        if (rest[0] instanceof Array) {
          for (let e of rest[0]) {
            this.headers.set(e.split('=')[0].toLowerCase(), e.split('=')[1]);
          }
        }
      }
    } else {}
  }

  /**
   * 添加Set-Cookie信息
   *
   * @param cookie 在header中添加set-cookie
   **/
  public addCookieHeader(cookie: string): void {
    this.cookieHeaders.push(cookie);
    this.setHeader('set-cookie', this.cookieHeaders.join(''));
  }

  /**
   * 设置响应头
   *
   * @param name header中的name名称
   * @param name header中的name对应的value
   **/
  public setHeader(name: string, value: string | number | boolean | string[] | Cookie): void {
    this.headers.set(name.toLowerCase(), value as string);
  }

  /**
   * 设置响应头
   *
   * @param headers header整个对象
   **/
  public setHeaders(headers: Map<string, string>): void {
    for (const key of headers.keys()) {
      this.setHeader(key.toLowerCase(), headers.get(key));
    }
  }

  /**
   * 获取响应头
   *
   * @param name header中的name名称
   * @return name对应的value值
   **/
  public getHeader(name: string): string {
    return this.headers.get(name.toLowerCase()) || '';
  }

  /**
   * 检查header中是否包含name字段
   *
   * @param name header中的name名称
   * @return boolean
   **/
  public hasHeader(name: string): boolean {
    return this.headers.has(name.toLowerCase());
  }

  /**
   * 获取header中的所有name字段
   *
   * @return header中的所有name字段
   **/
  public getHeaderNames(): string[] {
    return [...this.headers.keys()];
  }

  /**
   * 从header中删除名称字段
   * @param header中的name名称
   **/
  public removeHeader(name: string): void {
    this.headers.delete(name.toLowerCase());
  }

  /**
   * 获取header集合
   *
   * @return 获取整个header信息
   **/
  public getHeaders(): object {
    return Object.fromEntries(this.headers);
  }

  /**
   * 检查当前连接是否关闭
   *
   * @return boolean.
   **/
  public isCloseConnection(): boolean {
    return this.getHeader('connection') === 'close';
  }

  /**
   * 发送所有响应标头和正文
   *
   * @param data 发送内容
   * @param totalBytes 发送内容的大小
   **/
  public end(data?: string | ArrayBuffer, totalBytes?: number): void {
    this.finished = true;
    this.writableEnded = true;
    let contentType: ContentType = new ContentType(this.getHeader('content-type'));
    if (data) {
      if (typeof data === 'string') {
        contentType = contentType.tryUTF8();
        if (data == null) {
          this.data = data;
          this.contentLength = 0;
        } else {
          this.data = data;
          let tempEncoding: buffer.BufferEncoding = contentType.getEncoding() as buffer.BufferEncoding;
          this.contentLength = totalBytes ? totalBytes : buffer.byteLength(data, tempEncoding);
        }
      } else {
        if (data == null) {
          this.data = data;
          this.contentLength = 0;
        } else {
          this.data = data;
          this.contentLength = totalBytes ? totalBytes : data.byteLength;
        }
      }
    } else {
      this.data = '';
      this.contentLength = 0;
    }
    this.sendBody(this.client, this.bufferPool);
  }

  /**
   * end()方法调用：使用ArkTs的client.send发送数据
   *
   * @param client socket.TCPSocketConnection
   * @param bufferPool 内容
   **/
  private sendBody(client: socket.TCPSocketConnection, bufferPool: BufferPool): void {
    let header: buffer.Buffer = buffer.from(this.outHeader());
    let body: buffer.Buffer = (typeof this.data === 'string') ?
    buffer.from(this.data as string) : buffer.from(this.data as ArrayBuffer);
    let tcpSendOption: socket.TCPSendOptions = {
      data: buffer.concat([header, body]).buffer,
    };
    client.send(tcpSendOption).then(() => {
      this.headersSent = true;
      this.writableFinished = true;
      bufferPool.reset();
    }).catch((err: BusinessError) => {
      this.headersSent = true;
      this.writableFinished = true;
      bufferPool.reset();
      logger.error(`send fail ${err}`);
    });
  }

  /**
   * 返回数据时组装标题数据
   *
   * @return 响应标头字符串输出
   **/
  private outHeader(): string {
    if (this.statusCode == null) {
      throw new Error("response Status can't be null.");
    }
    let resData: string = `HTTP/1.1 ${this.statusCode} ${this.statusMessage}\r\n`;
    if (this.headers.has('content-type')) {
      this.mimeType = this.headers.get('content-type');
      resData = this.printHeader(resData, 'Content-Type', this.mimeType);
    }
    if (this.contentLength) {
      resData = this.printHeader(resData, 'Content-Length', this.contentLength);
    }
    if (!this.headers.has('connection')) {
      resData = this.printHeader(resData, 'Connection', this.keepAlive ? 'keep-alive' : 'close');
    }
    if (this.sendDate) {
      resData = this.printHeader(resData, 'Date', new Date().toUTCString());
    }
    for (let cookieHeader of this.cookieHeaders) {
      resData = this.printHeader(resData, 'Set-Cookie', cookieHeader);
    }
    this.headers?.forEach((value, key) => {
      if (!this.headersOptions.includes(key)) {
        resData = this.printHeader(resData, key, value);
      }
    });
    resData += '\r\n';
    return resData;
  }

  /**
   * 向outHeader中追加header信息
   *
   * @param originHeader起源标头
   * @param header中key值
   * @param header中value值
   * @return 响应头字符串输出
   **/
  private printHeader(originHeader: string, headerKey: string, headerValue: string | number | boolean): string {
    let tempOriginHeader: string = originHeader;
    let arr: string[] = headerKey.split('-');
    arr.forEach((i) => {
      i.toLowerCase().replace(/( |^)[a-z]/g, (l) => l.toUpperCase());
    });
    tempOriginHeader += `${arr.join('-')}: ${headerValue}\r\n`;
    if (!['set-cookie'].includes(headerKey)) {
      this.setHeader(headerKey, headerValue);
    }
    return tempOriginHeader;
  }
}