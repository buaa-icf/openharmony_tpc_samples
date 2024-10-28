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

import http from '@ohos.net.http'

class Http {
  url: string
  extraData: Object
  options: http.HttpRequestOptions

  constructor() {
    this.url = ''
    this.options = {
      method: http.RequestMethod.GET,
      extraData: this.extraData,
      header: { 'Content-Type': 'application/json' },
      readTimeout: 50000,
      connectTimeout: 50000
    }
  }

  setUrl(url: string) {
    this.url = url
  }

  setMethod(method: string) {
    switch (method) {
      case 'GET':
        this.options.method = http.RequestMethod.GET;
        break
      case 'HEAD':
        this.options.method = http.RequestMethod.HEAD;
        break
      case 'OPTIONS':
        this.options.method = http.RequestMethod.OPTIONS;
        break
      case 'TRACE':
        this.options.method = http.RequestMethod.TRACE;
        break
      case 'DELETE':
        this.options.method = http.RequestMethod.DELETE;
        break
      case 'POST':
        this.options.method = http.RequestMethod.POST;
        break
      case 'PUT':
        this.options.method = http.RequestMethod.PUT;
        break
      case 'CONNECT':
        this.options.method = http.RequestMethod.CONNECT;
        break
      default:
        this.options.method = http.RequestMethod.GET;
        break
    }
  }

  setExtraData(extraData: Object) {
    this.options.extraData = extraData;
  }

  setOptions(option: Object) {
    this.options = option;
  }

  setList(list: number[], flag: number) {
    list = []
    for (let i = 0; i < flag; i++) {
      list[i] = i
    }
    return list
  }

  setParameter(keys: string[], values: string[]) {
    let result = {}
    for (let i = 0; i <= keys.length - 1; i++) {
      let key = keys[i]
      let value = values[i]
      result[key] = value
    }
    return result
  }

  public setHeader(headerKey: string, headerValue: string): object {
    const header = new Object();
    header[headerKey] = headerValue
    return header;
  }

  async request() {
    let httpRequest = http.createHttp()
    httpRequest.on('dataReceive', function (data) {
      AppStorage.SetOrCreate('dataLength', data.byteLength);
      console.info('[ Demo dataReceive ]  ReceivedDataLength: ' + data.byteLength);
    });
    httpRequest.on('dataReceiveProgress', function (data) {
      AppStorage.SetOrCreate('receiveSize', data.receiveSize);
      AppStorage.SetOrCreate('totalSize', data.totalSize);
      console.info('[ Demo dataProgress ]  ReceivedSize: ' + data.receiveSize + ' TotalSize: ' + data.totalSize);
    });
    httpRequest.requestInStream(this.url, this.options);
  }
}

export default new Http()

export type Params = {
  [key: string]: string;
};

