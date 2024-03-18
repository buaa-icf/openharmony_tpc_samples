/*
 * Copyright (C) 2024 Huawei Device Co., Ltd.
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all
 * copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 */

import fs from '@ohos.file.fs';
import { GlobalContext } from './GlobalContext';
import parseAPNG from "./parser";
import { APNG } from "./structs";
import http from '@ohos.net.http';

type File = fs.File;

function getContext(): Context {
  return GlobalContext.getContext().getObject('MainContext') as Context;
}

class RequestData {
  receiveSize: number = 2000
  totalSize: number = 2000
}

class APngManager {
  constructor() {
  }

  getAPNGInstance(buffer: Uint8Array): APNG {
    let apng = {} as APNG;
    try {
      apng = parseAPNG(buffer);
    } catch (err) {
      console.log('get parse apng err: ' + err);
    }
    return apng;
  }

  async getResource(resource: Resource): Promise<Uint8Array> {
    let buffer = new Uint8Array();
    const resourceManager = getContext().resourceManager;
    buffer = await resourceManager.getMediaContent(resource.id);
    return buffer;
  }

  async open(url: string): Promise<File> {
    let file = {} as File;
    file = await fs.open(url);
    return file;
  }

  static loadData(src: string, onComplete: (img: ArrayBuffer) => void, onError: (err: string) => void) {
    try {
      let httpRequest = http.createHttp();
      let arrayBuffers = new Array<ArrayBuffer>();
      httpRequest.on('headersReceive', (header: Object) => {
        // 跟服务器连接成功准备下载
      })

      httpRequest.on('dataReceive', (data: ArrayBuffer) => {
        // 下载数据流多次返回
        arrayBuffers.push(data);
      })

      httpRequest.on('dataReceiveProgress', (data: RequestData) => {
        // 下载进度
        if (data != undefined && (typeof data.receiveSize == 'number') && (typeof data.totalSize == 'number')) {
          let percent = Math.round(((data.receiveSize * 1.0) / (data.totalSize * 1.0)) * 100)
        }
      })
      httpRequest.on('dataEnd', () => {
        // 下载完毕
        let combineArray = APngManager.combineArrayBuffers(arrayBuffers);
        onComplete(combineArray);
      })

      httpRequest.requestInStream(
        src as string,
        {
          method: http.RequestMethod.GET,
          expectDataType: http.HttpDataType.ARRAY_BUFFER,
          connectTimeout: http.HttpProtocol.HTTP1_1,
          usingCache: false
        }).then((data) => {
        if (data === 200) {

        } else {
          onError(`HttpDownloadClient has error,http code = ${data}`)
        }
      }).catch((err: Error) => {
        onError(`HttpDownloadClient has error,http code = ${JSON.stringify(err)}`)
      })
    } catch (err) {
      onError(`catch  error request uuid = ${err}`)
    }
  }

  static combineArrayBuffers(arrayBuffers: ArrayBuffer[]): ArrayBuffer {
    // 计算多个ArrayBuffer的总字节大小
    let totalByteLength = 0;
    for (const arrayBuffer of arrayBuffers) {
      totalByteLength += arrayBuffer.byteLength;
    }
    // 创建一个新的ArrayBuffer
    const combinedArrayBuffer = new ArrayBuffer(totalByteLength);
    // 创建一个新的Uint8Array来操作新的ArrayBuffer
    const combinedUint8Buffer = new Uint8Array(combinedArrayBuffer);

    let offset = 0;
    for (const attayBuffer of arrayBuffers) {
      const sourceUint8Buffer = new Uint8Array(attayBuffer);
      combinedUint8Buffer.set(sourceUint8Buffer, offset);
      offset += sourceUint8Buffer.length;
    }
    return combinedArrayBuffer;
  }
}

export default APngManager;