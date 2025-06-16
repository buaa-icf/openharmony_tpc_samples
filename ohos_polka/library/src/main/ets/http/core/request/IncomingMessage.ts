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
import type emitter from '@ohos.events.emitter';
import type { BusinessError, Callback } from '@ohos.base';
import { NanoHTTPD } from '../NanoHTTPD';
import type { BufferPool } from './BufferPool';
import ContentType from '../content/ContentType';
import CookieHandler from '../content/CookieHandler';
import { ServerResponse } from '../response/ServerResponse';
import { getLogger, type Logger } from '../../../common/util/log';

const logger: Logger = getLogger('IncomingMessage');
const CARRIAGE_RETURN: string = '\r';
const NEW_LINE: string = '\n';
const LF: number = 10;

const number2 = 2;
const number3 = 3;
const number4 = 4;

/**
 * 解析和处理HTTP请求。它可以获取请求的各种信息，如请求头、请求参数、请求方法等
 */
export class IncomingMessage {
  // HTTP版本
  public static HTTP_VERSION: string = 'HTTP/1.1';

  // 缓冲区大小
  public static BUFSIZE: number = (1024 * 1024);

  // 储存网络服务器的socket信息
  public socket: string;

  // 请求URI
  public uri: string;

  // 请求方法
  public method: string | undefined;

  // 请求头信息
  public headers: Record<string, string>;

  // cookies
  public cookies: CookieHandler;

  // 存储URL
  public url: string;

  // 存储路径
  public path: string;

  // 请求参数
  public parameters: Map<string, string[]>;

  // 查询参数字符串
  public queryParameterString: string;

  // 文件
  public files: Map<string, buffer.Buffer>;

  // 缓冲池
  private bufferPool: BufferPool;

  // 网络服务器
  private httpd: NanoHTTPD;

  // 分割数据
  private splitByte: number;

  // 数据的长度
  private rlen: number;

  // 远程IP地址
  private remoteIp: string;

  // 协议版本
  private protocolVersion: string;


  /**
   * 构造一个具有获取客户端IP地址能力的Socket连接对象
   *
   * @param { NanoHTTPD } httpd-NanoHTTPD实例
   * @param { BufferPool } bufferPool-bufferPool 缓冲池
   * @param { string } socket-字符串
   * @param { socket.TCPSocketConnection } client-socket.TCPSocketConnection实例
   */
  constructor(httpd: NanoHTTPD, bufferPool: BufferPool, socket: string, client: socket.TCPSocketConnection) {
    this.httpd = httpd;
    this.bufferPool = bufferPool;
    this.socket = socket;

    // 检查客户端是否为null，不为空则调用getRemoteAddress方法获取远程IP地址
    if (client != null) {
      // client.getRemoteAddress接收两个参数：一个错误对象和一个包含网络地址的对象
      client.getRemoteAddress((err: BusinessError, data: socket.NetAddress) => {
        if (err !== undefined) {
          logger.log('getRemoteAddress fail');
          return;
        }
        logger.log(`getRemoteAddress success: ${JSON.stringify(data)}`);
        this.remoteIp = data.address;
      });
    } else {
      throw new Error('Failed to create the socket client.');
    }
  }

  /**
   * 获取parameters中参数列表
   *
   * @returns { Map<string, string[]> } 返回pparameters中参数列表字符串
   */
  getParameters(): Map<string, string[]> {
    return this.parameters;
  }

  /**
   * 获取查询参数字符串
   *
   * @returns { string } 返回获取查询参数字符串
   */
  getQueryParameterString(): string {
    return this.queryParameterString;
  }

  /**
   * 提供socket客户端返回Ip地址
   *
   * @returns { string } socket客户端返回Ip地址
   */
  getRemoteIpAddress(): string {
    return this.remoteIp;
  }

  /**
   * 解析传入的参数字符串，将其转换为键值对，存储在一个Map对象中
   *
   * @param { string } params-解析的参数字符串
   * @param { Map<string, string[]> } parseParameters-存储解析结果的Map对象，其中键为参数名，值为参数值的数组。
   */
  public decodeParms(params: string, parseParameters: Map<string, string[]>): void {
    // 判断请求参数是否存在
    if (params === undefined) {
      this.queryParameterString = '';
      return;
    }

    // 赋值查询参数字符串
    this.queryParameterString = params;

    // 用 & 分割多个子字符串，存到 stringTokenizer数组
    let stringTokenizer: string[] = params.split('&');

    // 循环stringTokenizer
    while (stringTokenizer.length) {
      // 使用 shift方法 移除 stringTokenizer 数组第一个元素
      let e: string = stringTokenizer.shift();

      // 查找 e包含符合‘=’，赋值给sep
      let sep: number = e.indexOf('=');

      // 键名
      let key: string = null;

      // 键值
      let value: string = null;

      // sep 大于 0， 分割 e 中 符号 ”=“ 前后 分别赋值给 key 和 value
      if (sep >= 0) {
        key = NanoHTTPD.decodePercent(e.substring(0, sep)).trim();
        value = NanoHTTPD.decodePercent(e.substring(sep + 1));
      } else {
        // 否则，符号 ”=“ 前 只赋值 key， value = 空字符串
        key = NanoHTTPD.decodePercent(e).trim();
        value = '';
      }

      // 从 parseParameters 映射中获取 key 对应的值
      let values: string[] = parseParameters.get(key);

      // 如果不存在，则创建一个新的数组并且赋值 给values
      if (values === undefined) {
        values = new Array<string>();
        parseParameters.set(key, values);
      }

      // 把value 添加到values数组中
      values.push(value);
    }
  }

  /**
   * 获取请求头中cookie信息
   *
   * @returns { CookieHandler } 返回请求头中cookie信息
   */
  public getCookies(): CookieHandler {
    return this.cookies;
  }

  /**
   * 获取header中包含的uri信息
   *
   * @returns { string } 返回header中包含的uri信息
   */
  public getUri(): string {
    return this.uri;
  }

  /**
   * 获取headers对象
   *
   * @returns { object } 返回headers对象
   */
  public getHeaders(): object {
    return this.headers;
  }

  /**
   * 获取参数列表
   *
   * @returns { Map<string, string> } 参数列表的Map类型
   */
  public getParms(): Map<string, string> {
    let result: Map<string, string> = new Map();
    for (let [key, value] of this.parameters) {
      result.set(key, value[0]);
    }
    return result;
  }

  /**
   * 获取请求类型的方法
   *
   * @returns { string | undefined } 返回请求类型方法
   */
  public getMethod(): string | undefined {
    return this.method;
  }

  /**
   * 获取socket字符串
   *
   * @returns { string } 返回socket字符串
   */
  public getInputStream(): string {
    return this.socket;
  }

  /**
   * 解析HTTP请求头，将解析结果存储在类的实例变量中，然后调用httpd对象的serve方法处理请求并生成响应
   *
   * @param { socket.TCPSocketConnection } client-与客户端的TCP连接
   * @param { BufferPool } bufferPool-缓冲池
   */
  public execute(client: socket.TCPSocketConnection, bufferPool: BufferPool): void {
    // 索引
    this.splitByte = 0;

    // socket长度
    this.rlen = 0;

    // 请求参数
    this.parameters = new Map();

    // 请求头
    this.headers = {};
    let pre: Map<string, string> = new Map();

    // 计算socket长度
    this.rlen += this.socket.length;

    // 查找头部结束位置
    this.splitByte = this.findHeaderEnd(this.socket, this.rlen);
    logger.log(`httpsession splitByte: ${this.splitByte}`);

    // 获取请求头
    let requestHead: string = this.splitByte ? this.socket.substring(0, this.splitByte) : this.socket;
    this.decodeHeader(requestHead, pre, this.parameters, this.headers);

    // 获取请求方法，并转换为大写
    this.method = pre.get('method')?.toUpperCase();
    logger.log(`httpsession method: ${this.method}`);

    // 检查HTTP方法是否定义
    if (this.method === undefined) {
      throw new Error(`BAD REQUEST: Syntax error. HTTP verb ${pre.get('method')} unhandled.`);
    }

    // 获取请求URI和URL
    this.uri = pre.get('uri');
    this.url = this.path = pre.get('url');

    // 处理cookies
    this.cookies = new CookieHandler(this.headers);

    // 获取连接信息
    const { connection } = this.headers;
    logger.log(connection);

    // 判断是否保持连接
    let keepAlive: boolean =
      (IncomingMessage.HTTP_VERSION === this.protocolVersion) && ((connection === undefined) ||
        !(/close/ig.test(connection)));

    // test log
    for (let [key, value] of this.parameters) {
      logger.log(`"httpsession parameters: "${key}: ${value}`);
    }

    // 创建事件数据
    let eventData: emitter.EventData = {
      data: {
        contentLength: this.headers['content-length'] || 0,
      },
    };

    // 触发会话事件
    this.bufferPool.emit('sessionEvent', eventData);

    // 创建服务器响应
    const response: ServerResponse = new ServerResponse();
    response.client = client;
    response.bufferPool = bufferPool;
    response.keepAlive = keepAlive;
    
    // 处理请求
    this.httpd.serve(this, response);
  }

  /**
   * 解析请求体，处理POST和PUT方法中的数据
   * @param files 用于存储文件的Map
   * @param callback 解析完成后的回调函数
   */
  public parseBody(files: Map<string, buffer.Buffer>, callback: Callback<void>): void {
    // 如果请求方法是POST，可能在数据部分也有参数，读取它
    this.bufferPool.on('bodyEvent', (eventData: emitter.EventData) => {
      // 如果当前请求体长度大于0
      if (this.bufferPool.getCurrentBodyLength() > 0) {
        // 如果请求方法是POST
        if (this.method === 'POST') {
          // 获取请求头中的content-type
          let contentType: ContentType = new ContentType(this.headers['content-type']);
          // 如果content-type是multipart，解析multipart/form-data格式的数据
          if (contentType.isMultipart()) {
            this.decodeMultipartFormData(contentType, this.bufferPool, this.parameters, files);
          } else {
            // 创建一个buffer来存储请求体数据
            let postLine: buffer.Buffer =
              buffer.from(new ArrayBuffer(this.bufferPool.dataWritePos - this.bufferPool.headPos));
            this.bufferPool.buffer.copy(postLine, 0, this.bufferPool.headPos, this.bufferPool.dataWritePos);
            // 如果content-type是application/x-www-form-urlencoded，解析表单数据
            logger.log(`postLine length: ${postLine.length}`);
            if (contentType.getContentType() === 'application/x-www-form-urlencoded') {
              this.decodeParms(postLine.toString(), this.parameters);
              for (let [key, value] of this.parameters) {
                // 打印解析后的参数
                logger.log(`"httpsession parameters: "${key}: ${value}`);
              }
            }
            if (postLine.length !== 0) {
              // 如果请求体长度不为0，将请求体数据存储到files中
              files.set('postData', postLine);
            }
          }
        }
        if (this.method === 'PUT') {
          // 创建一个buffer来存储请求体数据
          let postLine: buffer.Buffer =
            buffer.from(new ArrayBuffer(this.bufferPool.dataWritePos - this.bufferPool.headPos));
          this.bufferPool.buffer.copy(postLine, 0, this.bufferPool.headPos, this.bufferPool.dataWritePos);
          // 如果请求方法是PUT，将请求体数据存储到files中
          files.set('content', postLine);
        }

        this.bufferPool.removeAllListeners('bodyEvent');

        // 执行回调函数
        callback();
      }
    });

    // 如果请求体已经触发，触发bodyEvent事件
    if (this.bufferPool.bodyTriggered === true) {
      this.bufferPool.emit('bodyEvent');
    }
  }

  /**
   * 获取请求体的大小
   *
   * @return {number} 返回请求体的大小，如果'content-length'头部未定义，则返回剩余的字节数，如果剩余的字节数也不存在，则返回0
   */
  public getBodySize(): number {
    // 检查'content-length'头部是否存在
    if (this.headers['content-length'] !== undefined) {
      // 如果存在，返回'content-length'头部的值
      return Number(this.headers['content-length']);
    }

    if (this.splitByte < this.rlen) { // 检查是否有剩余的字节
      // 如果有，返回剩余的字节数
      return this.rlen - this.splitByte;
    }
    // 如果'content-length'头部不存在且没有剩余的字节，返回0
    return 0;
  }

  /**
   * 解析HTTP请求头部信息
   *
   * @param { string } socket-HTTP请求头部信息
   * @param { Map<string, string> } preRequestInfoMap-存储解析后的请求信息
   * @param { Map<string, string[] } params-存储解析后的请求参数
   * @param { object } headers-存储解析后的请求头部信息
   */
  private decodeHeader(socket: string, preRequestInfoMap: Map<string, string>, params: Map<string, string[]>,
    headers: object): void {
    try {
      // 把socket字符串按照换行符分割成多行，并取出第一行
      let lines: string[] = socket.trim().split(/\r?\n/);
      let line: string = lines.shift();

      // 把第一行按照空格分割，得到 一个 stringTokenizer 数组
      let stringTokenizer: string | string[] = (line !== '') ? line.split(' ') : [];
      logger.log(`httpsession: stringTokenizer ${JSON.stringify(stringTokenizer)}`);

      // 检查数组是否为空，如果为空，则抛出一个错误
      if (!stringTokenizer.length) {
        throw new Error('BAD REQUEST: Syntax error. Usage: GET /example/file.html');
      }

      // 把请求方法存储到 preRequestInfoMap 中
      preRequestInfoMap.set('method', stringTokenizer.shift());

      // 检查数组是否为空，如果为空，则抛出一个错误
      if (!stringTokenizer.length) {
        throw new Error('BAD REQUEST: Missing URI. Usage: GET /example/file.html');
      }

      // 把URI存储到preRequestInfoMap中
      let uri: string = stringTokenizer.shift();
      preRequestInfoMap.set('url', uri);

      // 从 URI 解码参数
      let qmi: number = uri.indexOf('?');
      if (qmi >= 0) {
        // 解析URI中的参数
        this.decodeParms(uri.substring(qmi + 1), params);

        // 把解析后的URI存储回uri变量
        uri = NanoHTTPD.decodePercent(uri.substring(0, qmi));
      } else {
        // 如果URI中没有参数， 则直接对整个URI解码
        uri = NanoHTTPD.decodePercent(uri);
      }

      // 检查数组是否为空，如果不为空，则获取请求的协议版本，否则默认为HTTP/1.1
      if (!stringTokenizer.length) {
        this.protocolVersion = stringTokenizer.shift();
      } else {
        this.protocolVersion = IncomingMessage.HTTP_VERSION;
        logger.log('no protocol version specified, strange. Assuming HTTP/1.1.');
      }

      // 遍历剩余的请求头部，把每行按照冒号分割，然后把得到的键值对存储到headers对象中
      line = lines.shift();
      while ((line !== undefined) && line.trim() !== '') {
        let headIndex: number = line.indexOf(':');
        if (headIndex >= 0) {
          headers[line.substring(0, headIndex).trim().toLowerCase()] = line.substring(headIndex + 1).trim();
        }
        line = lines.shift();
      }

      // 把解析后的URI存储到preRequestInfoMap中
      preRequestInfoMap.set('uri', uri);
    } catch (e) {
      // 如果在解析过程中发生错误，则抛出一个错误
      throw new Error(`SERVER INTERNAL ERROR: IOException: ${e.message}`);
    }
  }

  /**
   * 判断是否符合HTTP请求头的结尾的格式
   *
   * @param { string } socket-HTTP请求头的内容
   * @param { number } rlen-socket字符串的长度
   * @returns -{ number } Return如果找到HTTP请求头的结尾，则返回结尾的位置
   -          - Return如果没有找到HTTP请求头的结尾，则返回0
   */
  private findHeaderEnd(socket: string, rlen: number): number {
    // 跟踪当前正在检查的字符串的索引
    let splitByte: number = 0;

    // 循环socket
    while (splitByte + 1 < rlen) {
      let firstCase = socket[splitByte] === CARRIAGE_RETURN && socket[splitByte + 1] === NEW_LINE;
      let secondCase = socket[splitByte + number2] === CARRIAGE_RETURN && socket[splitByte + number3] === NEW_LINE;
      let lessThan = splitByte + number3 < rlen;
      // 如果找到了符合RFC2616规定的头部结束标记，返回splitByte + 4
      if (firstCase && lessThan && secondCase) {
        return splitByte + number4;
      }

      // 如果找到了两个连续的换行符，返回splitByte + 2
      if (socket[splitByte] === NEW_LINE && socket[splitByte + 1] === NEW_LINE) {
        return splitByte + number2;
      }

      // 如果上述所有条件都不满足，将splitByte加1，继续检查下一个字符
      splitByte++;
    }

    // 如果循环结束都没有找到头部的结束位置，那么返回0
    return 0;
  }

  /**
   * 解析multipart/form-data类型的HTTP请求体
   * @param contentType 请求体的ContentType
   * @param bp 请求体的BufferPool
   * @param params 用于存储解析出来的参数
   * @param files 用于存储解析出来的文件
   */
  private decodeMultipartFormData(contentType: ContentType, bp: BufferPool, params: Map<string, string[]>,
    files: Map<string, buffer.Buffer>): void {
    // 获取boundary
    let boundary: string = contentType.getBoundary();
    boundary = `--${boundary}`;

    // 找到所有boundary的位置
    const boundaryIdxs = this.getBoundaryPositions(bp, boundary);

    // 检查找到的boundary数量
    if (boundaryIdxs.length < number2) {
      throw new Error('BAD REQUEST: Content type is multipart/form-data but contains less than two boundary strings.');
    }

    // boundary块循环解析
    for (let boundaryIdx = 0; boundaryIdx < boundaryIdxs.length - 1; boundaryIdx++) {
      // 把每个boundary之间的数据块解析出来
      let mpBlock: buffer.Buffer =
        buffer.from(new ArrayBuffer(boundaryIdxs[boundaryIdx + 1] - boundaryIdxs[boundaryIdx]));
      this.bufferPool.buffer.copy(mpBlock, 0, boundaryIdxs[boundaryIdx], boundaryIdxs[boundaryIdx + 1]);
      const mpBlockString = mpBlock.toString('utf-8', 0, mpBlock.length);
      let mpLines: string[] = mpBlockString.split(/\r\n/);
      let headerLines: number = 0;
      let mpLine: string = mpLines.shift();
      headerLines++;
      if (!mpLine) {
        throw new Error('BAD REQUEST: Content type is multipart/form-data but chunk does not start with boundary.');
      }
      mpLine = mpLines.shift();
      headerLines++;
      let partName: string;
      let fileName: string;
      let partContentType: string;

      // boundary块解析
      while (mpLine && (mpLine.trim().length > 0)) {
        logger.log(`mpLine: ${mpLine}`);
        // Content-Disposition
        const regex = new RegExp(NanoHTTPD.contentDispositionRegex, 'i');
        const match: RegExpExecArray | null = regex.exec(mpLine);
        if (match) {
          const regexGi = new RegExp(NanoHTTPD.contentDispositionAttributeRegex, 'gi');
          let matchAttribute: RegExpMatchArray | null = match[number2].match(regexGi);
          matchAttribute.map((item) => {
            // Content-Disposition Attribute
            const matcher: RegExpExecArray | null = NanoHTTPD.contentDispositionAttributeRegex.exec(item);
            if (matcher) {
              let key: string = matcher[1].toLowerCase();
              if (key === 'name') {
                partName = matcher[number2];
              }
              if (key === 'filename') {
                fileName = matcher[number2];
              }
            }
          });
        }
        // contentType
        const regexContentType = new RegExp(NanoHTTPD.contentTypeRegex, 'i');
        const matchContentType: RegExpExecArray | null = regexContentType.exec(mpLine);
        if (matchContentType) {
          partContentType = matchContentType[number2].trim();
        }
        mpLine = mpLines.shift();
        headerLines++;
      }

      // Read the part data
      let partHeaderLength: number = 0;
      while (headerLines-- > 1) {
        partHeaderLength = this.scipOverNewLine(mpBlock, partHeaderLength);
      }

      let partDataStart: number = boundaryIdxs[boundaryIdx] + partHeaderLength + number2;
      let partDataEnd: number = boundaryIdxs[boundaryIdx + 1] - number4 + number2;

      let values: string[] = params.get(partName);
      if (!values) {
        values = new Array<string>();
        params.set(partName, values);
      }
      let data: buffer.Buffer =
        buffer.from(new ArrayBuffer(partDataEnd - partDataStart));
      this.bufferPool.buffer.copy(data, 0, partDataStart, partDataEnd);
      if (!partContentType) {
        // Read the part into a string
        values.push(data.toString('utf-8', 0, data.length));
      } else {
        // Read it into a file
        if (!files.has(partName)) {
          files.set(partName, data);
        } else {
          let count: number = number2;
          while (files.has(partName + count)) {
            count++;
          }
          files.set(partName + count, data);
        }
        values.push(fileName);
      }
    }
  }

  /**
   * 获取缓冲池中的边界位置
   * @param bp 缓冲池对象
   * @param boundary 边界字符串
   * @return 返回边界位置的数组，如果没有找到匹配的边界位置，则返回空数组
   */
  private getBoundaryPositions(bp: BufferPool, boundary: string): number[] {
    // 初始化结果数组
    let res: number[] = [];

    // 如果缓冲池的当前体长度小于边界字符串的长度，则直接返回空结果数组
    if (bp.getCurrentBodyLength() < boundary.length) {
      return res;
    }

    let byteOffset: number = 0;
    let buf: buffer.Buffer = bp.buffer;
    let isInclude = buf.includes(boundary, byteOffset);
    while (isInclude && (byteOffset < buf.length)) {
      byteOffset = buf.indexOf(boundary, byteOffset);
      res.push(byteOffset);
      byteOffset += 1;
      isInclude = buf.includes(boundary, byteOffset);
    }

    // 返回结果数组
    return res;
  }

  /**
   * 跳过新行符，直到遇到下一个字符
   * @param partHeaderBuff 字符串，用于查找新行符
   * @param index 开始查找的位置
   * @return 返回新行符后一个字符的位置
   */
  private scipOverNewLine(partHeaderBuff: buffer.Buffer, index: number): number {
    let newIndex: number = index;
    // 当前字符不是新行符时，继续向后查找
    while (partHeaderBuff[newIndex] !== LF) {
      newIndex++;
    }

    // 返回新行符后一个字符的位置
    return ++newIndex;
  }
}