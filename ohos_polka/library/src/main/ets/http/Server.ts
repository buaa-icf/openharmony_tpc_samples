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

import { NanoHTTPD } from './core/NanoHTTPD';
import {IncomingMessage} from './core/request/IncomingMessage';
import {ServerResponse} from './core/response/ServerResponse';

export default class Server extends NanoHTTPD {
  constructor(options = {}) {
    super(options);
  }

  public serve(req: IncomingMessage, res: ServerResponse){
    if (('PUT' === req.method) || ('POST' === req.method)) {
      req.files = new Map();
      req.parseBody(req.files, () => {
        this.emit('request', req, res);
      })
    } else {
      this.emit('request', req, res);
    }
  }

  public listen(port?: number, ...rest): void {
    if(port !== undefined) {
      this.myPort = port;
    }
    if(rest.length === 1) {
      if(typeof rest[0] === 'string') {
        this.hostname = rest[1];
      }
      if(typeof rest[0] === 'function') {
        this.listeningListener = rest[0];
      }
    } else if(rest.length === 2) {
      this.hostname = rest[0];
      this.listeningListener = rest[1];
    }
    this.start();
  }
}