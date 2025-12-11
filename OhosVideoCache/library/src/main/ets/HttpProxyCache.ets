/*
 * Copyright (C) 2023 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */


import socket from '@ohos.net.socket';
import { CacheListener } from './CacheListener';
import FileCache from './file/FileCache';
import GetRequest from './GetRequest';
import HttpUrlSource from './HttpUrlSource';
import ProxyCache from './ProxyCache';
import ProxyCacheUtils from './ProxyCacheUtils';
import { DataBackListener } from './interfaces/DataBackListener';
import { LogUtil } from './LogUtil';

export default class HttpProxyCache extends ProxyCache {
  private NO_CACHE_BARRIER: number = 0.2;
  protected source: HttpUrlSource | null = null;
  protected cache: FileCache | null = null;
  private listener: CacheListener | null = null;
  private receiveSize: number = 0;
  private offset: number = 0;
  private serverConnect: socket.TCPSocketConnection | null = null;

  constructor(source: HttpUrlSource, cache: FileCache, url: string) {
    super(source, cache, url)
    this.source = source;
    this.cache = cache;
    this.receiveSize = 0;
  }

  async shutdown(): Promise<void> {
    try {
      this.stopped = true;
      await super.shutdown();
      // 完全清理 TCP 连接，避免内存泄漏
      if (this.serverConnect) {
        this.serverConnect.off('message');
        this.serverConnect.off('error');
        this.serverConnect.off('close');
        await this.serverConnect.close();
        this.serverConnect = null;
      }
    } catch (err) {
      LogUtil.error('shutdown error: ' + JSON.stringify(err));
    }
    return Promise.resolve()
  }

  public registerCacheListener(cacheListener: CacheListener | null): void {
    this.listener = cacheListener;
  }

  /**
   * 获取当前活跃的 HttpUrlSource 实例
   * @returns HttpUrlSource 实例或 null
   */
  public getCurrentSource(): HttpUrlSource | null {
    return this.source;
  }

  public async processRequest(request: GetRequest, serverConnect: socket.TCPSocketConnection): Promise<void> {
    if (!request) {
      return Promise.reject(new Error('request can not be null'))
    }
    if (this.serverConnect && this.serverConnect.clientId != serverConnect.clientId) {
      try {
        this.serverConnect.off('message')
        this.serverConnect.off('error')
        this.serverConnect.off('close')
        this.serverConnect.close()
      } catch (err) {
        LogUtil.error('processRequest error: ' + JSON.stringify(err));
      }
      this.serverConnect = serverConnect;
    }
    let responseHeaders = await this.newResponseHeaders(request);
    let msg: socket.TCPSendOptions = {
      data: responseHeaders
    }
    try {
      await serverConnect?.send(msg);
    } catch (err) {
      LogUtil.error('[HttpProxyCache] [发送响应头] 发送失败: ' + JSON.stringify(err));
      throw new Error(err);
    }
    this.offset = request.rangeOffset;
    this.stopped = false;
    
    // HEAD 请求只返回响应头，不返回响应体
    if (request.method === 'HEAD') {
      LogUtil.info('[HttpProxyCache] [处理请求] HEAD请求，跳过响应体发送');
      return Promise.resolve();
    }
    
    if (this.cache && this.source) {
      let available = this.cache.available();
      let length = await this.source.length()
      if (length > 0) {
        let percent = available * 100 / length;
        this.onCachePercentsAvailableChanged(percent);
      }
    }
    if (await this.isUseCache(request)) {
      await this.responseWithCache(this.offset, serverConnect);
    } else {
      await this.responseWithoutCache(this.offset, serverConnect);
    }
    return Promise.resolve();
  }

  private async responseWithCache(offset: number, serverConnect: socket.TCPSocketConnection): Promise<void> {
    let buff = new ArrayBuffer(ProxyCacheUtils.DEFAULT_BUFFER_SIZE);
    let readBytes: number = 0;
    while ((readBytes = await this.read(buff, offset, buff.byteLength)) != -1) {
      try {
        let trueBuff = buff.slice(0, readBytes);
        let msg: socket.TCPSendOptions = {
          data: trueBuff
        }
        if (this.stopped) {
          break;
        }
        if (!serverConnect) {
          break;
        }
        await serverConnect?.send(msg);

      } catch (err) {
        LogUtil.error('responseWithCache error: ' + JSON.stringify(err));
        break;
      }
      offset += readBytes;
    }
    return Promise.resolve();
  }

  private async responseWithoutCache(offset: number, serverConnect: socket.TCPSocketConnection): Promise<void> {
    if (!this.source) {
      return Promise.reject(new Error('source is null'));
    }
    const ctx = this;
    let newSourceNoCache = new HttpUrlSource([this.source]);
    await new Promise<void>((resolve, reject) => {
      // 发送串行队列，避免高频并发 send 造成错误
      const pendingChunks: Array<ArrayBuffer> = [];
      let sending: boolean = false;
      let ended: boolean = false;

      const sendNext = () => {
        if (sending) {
          return;
        }
        const next = pendingChunks.shift();
        if (!next) {
          maybeFinish();
          return;
        }
        sending = true;
        const msg: socket.TCPSendOptions = { data: next };
        serverConnect?.send(msg).then(() => {
          sending = false;
          sendNext();
        }).catch((err: Error) => {
          sending = false;
          return reject(err);
        });
      };

      const maybeFinish = () => {
        if (ended && !sending && pendingChunks.length === 0) {
          newSourceNoCache.close();
          newSourceNoCache.setDataListener(null);
          return resolve();
        }
      };
      try {
        class TempDataBackListener implements DataBackListener {
          onDataEnd() {
            ended = true;
            maybeFinish();
          }

          onDataStart() {
            ctx.receiveSize = offset;
          }

          onDataReceive(data: ArrayBuffer) {
            ctx.receiveSize += data.byteLength;
            pendingChunks.push(data);
            sendNext();
          }

          onDataProgress() {
          }
        }

        newSourceNoCache.setDataListener(new TempDataBackListener())
        newSourceNoCache.open(offset);
      } catch (err) {
        LogUtil.error('responseWithoutCache error: ' + JSON.stringify(err));
        newSourceNoCache.close();
        reject(err)
      }
    })

  }


  private async isUseCache(request: GetRequest): Promise<boolean> {
    if (!this.source) {
      throw new Error('source is null')
    }
    if (!this.cache) {
      throw new Error('cache is null')
    }
    let sourceLength = await this.source.length();
    let sourceLengthKnown = sourceLength > 0;
    let cacheAvailable = this.cache.available();
    let result = !sourceLengthKnown || !request.partial || request.rangeOffset <= cacheAvailable + sourceLength * this.NO_CACHE_BARRIER
    return Promise.resolve(result);
  }

  private async newResponseHeaders(request: GetRequest): Promise<string> {
    if (!this.source) {
      throw new Error('source is null')
    }
    if (!this.cache) {
      throw new Error('cache is null')
    }
    let mime = await this.source.getMime();
    let mimeKnown = mime != null && mime != undefined && mime.length > 0;
    let length = this.cache.isCompleted() ? this.cache.available() : await this.source.length();
    let lengthKnown = length >= 0;
    let contentLength = request.partial ? length - request.rangeOffset : length;
    let addRange = lengthKnown && request.partial;
    let lengthStr = lengthKnown ? `Content-Length: ${contentLength}${"\n"} ` : ""
    let rangeStr = addRange ? `Content-Range: bytes ${request.rangeOffset}-${length - 1}/${length}${"\n"}` : ""
    let mimeStr = mimeKnown ? `Content-Type: ${mime}${"\n"}` : ""

    let str1 = `HTTP/1.1 206 PARTIAL CONTENT${"\n"}${"Accept-Ranges: bytes\n"}${lengthStr}${rangeStr}${mimeStr}${"\n"}`;
    let str2 = `HTTP/1.1 200 OK${"\n"}${"Accept-Ranges: bytes\n"}${lengthStr}${rangeStr}${mimeStr}${"\n"}`;

    return Promise.resolve(`${request.partial ? str1 : str2}`);

  }

  protected onCachePercentsAvailableChanged(percents: number): void {
    if (this.listener != null && this.cache && this.source) {
      this.listener.onCacheAvailable(this.cache.trueFilePath, this.source.getUrl(), percents);
    }
  }
}