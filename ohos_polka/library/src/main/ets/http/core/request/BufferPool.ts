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

import type emitter from '@ohos.events.emitter';
import buffer from '@ohos.buffer';
import { EventEmitter } from '../../../common/util/event-emitter';

let bodyTimer = null;
let size = 1024;
let number2 = 2;
let number3 = 3;
let number4 = 4;

/**
 * BufferPool类，继承自EventEmitter，用于处理数据缓冲
 */
export class BufferPool extends EventEmitter {
  // 缓冲区
  buffer: buffer.Buffer;

  // 数据长度
  dataLength: number;

  // 读取位置
  dataReadPos: number;

  // 写入位置
  dataWritePos: number;

  // 头部位置
  headPos: number;

  // 内容长度
  contentLength: number;

  // 默认缓冲区大小
  defaultBufferSize: number;

  // 是否触发body
  bodyTriggered: boolean;

  // 缓冲区大小
  private bufferSize: number;

  constructor(bufferSize: number) {
    super();
    this.bufferSize = this.defaultBufferSize = bufferSize || (size * size);
    this.buffer  = buffer.from(new ArrayBuffer(bufferSize));
    this.dataLength = 0;
    this.dataReadPos = 0;
    this.dataWritePos = 0;
    this.headPos = 0;
    this.contentLength = 0;
    this.bodyTriggered = false;
  }

  /**
   * 重置BufferPool类
   */
  public reset(): void {
    this.buffer = null;
    this.buffer = buffer.from(new ArrayBuffer(this.defaultBufferSize));
    this.dataLength = 0;
    this.dataReadPos = 0;
    this.dataWritePos = 0;
    this.headPos = 0;
    this.contentLength = 0;
    this.bodyTriggered = false;
    this.removeAllListeners('bodyEvent');
  }

  /**
   * 获取当前正文长度
   * 如果headPos存在，返回数据写入位置与headPos之间的距离
   * 如果headPos不存在，返回headPos
   * @return {number} 返回当前正文长度
   */
  public getCurrentBodyLength(): number {
    if (this.headPos) { // 判断headPos是否存在
      return this.dataWritePos - this.headPos; // 返回数据写入位置与headPos之间的距离
    } else {
      return this.headPos; // 如果headPos不存在，返回headPos
    }
  }

  /**
   * 推送消息到BufferPool
   * @param msg 消息内容
   */
  pushMsg(msg: buffer.Buffer): void {
    if (msg.length === 0) {
      return;
    }
    if (bodyTimer === null) {
      clearTimeout(bodyTimer);
    }
    let msgStart = 0;
    let msgLength = msg.length;
    let availLength = this.buffer.length - this.dataLength;
    let msgBuffer: buffer.Buffer = buffer.from(msg);
    // 扩容
    if (msgLength > availLength) {
      // 以1M为基数扩展Buffer空间
      let exLength = Math.ceil((this.dataLength + msgLength) / (size * size)) * (size * size);
      let tempBuffer  = buffer.from(new ArrayBuffer(exLength));
      this.bufferSize = exLength;

      this.buffer.copy(tempBuffer, 0, this.dataReadPos, this.dataWritePos);
      this.buffer = null;
      this.buffer = tempBuffer;

      this.dataReadPos = 0;
      this.dataWritePos = this.dataLength;
      msgBuffer.copy(this.buffer, this.dataWritePos, msgStart, msgStart + msgLength);
      this.dataLength += msgLength;
      this.dataWritePos += msgLength;
    } else {
      msgBuffer.copy(this.buffer, this.dataWritePos, msgStart, msgStart + msgLength);
      this.dataLength += msgLength;
      this.dataWritePos += msgLength;
    }
    if (!this.headPos) {
      this.headPos = this.findHeaderEnd(msg.toString(), msgLength);
      if (this.headPos) {
        this.on('sessionEvent', (eventData) => {
          this.contentLength = eventData.data.contentLength;
          if (this.contentLength && (this.dataWritePos - this.headPos >= this.contentLength)) {
            this.triggerBody();
          }
        });
        let eventData: emitter.EventData = {
          data: {
            header: this.buffer.toString('utf-8', this.dataReadPos, this.dataReadPos + this.headPos),
          },
        };
        this.emit('headerEvent', eventData);
      }
    }

    if (this.contentLength && (this.dataWritePos - this.headPos >= this.contentLength)) {
        this.triggerBody();
    }
  }

  /**
   * 触发body事件
   */
  private triggerBody(): void {
    this.bodyTriggered = true;
    let eventData: emitter.EventData = {
      data: {},
    };
    this.emit('bodyEvent', eventData);
  }

  /**
   * 查找消息头部结束位置
   * @param inputStream 输入流
   * @param rlen 读取长度
   * @return 返回头部结束位置
   */
  private findHeaderEnd(inputStream: string, rlen: number): number {
    let splitByte: number = 0;
    while (splitByte + 1 < rlen) {
      /*
       * 这是根据RFC2616（HTTP 1.1协议的官方文档）中的规定，头部的结束是由两个'\r\n'组成的
       * 首先检查splitByte位置的字符串和splitByte + 1位置的字符串是否为“\r”和“\n”，同时splitByte + 2和splitByte + 3位置的字符串
       * 是否也是为“\r”和“\n”，如果都是那么返回splitByte + 4，表示找到了头部的结束位置。
       */
      const firstCase = inputStream[splitByte] === '\r' && inputStream[splitByte + 1] === '\n';
      const lessThan = splitByte + number3 < rlen;
      const secondCase = inputStream[splitByte + number2] === '\r' && inputStream[splitByte + number3] === '\n';
      if (firstCase && lessThan && secondCase) {
        return splitByte + number4;
      }

      /*
       * 为了兼容某些不完全符合RFC2616的情况， tolerance
       * 检查splitByte位置的字符串和splitByte + 1位置的字符串是否为两个“\n”，如果是，那么返回splitByte + 2，表示找到了头部结束的位置
       */
      if (inputStream[splitByte] === '\n' && inputStream[splitByte + 1] === '\n') {
        return splitByte + number2;
      }

      splitByte++;
    }

    return 0;
  }
}