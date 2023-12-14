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

import ArrayList from '@ohos.util.ArrayList';
import socket from '@ohos.net.socket';
import { CacheListener } from './CacheListener';
import Config from './Config';
import HttpProxyCache from './HttpProxyCache';
import Preconditions from './Preconditions';
import GetRequest from './GetRequest';
import HttpUrlSource from './HttpUrlSource';
import FileCache from './file/FileCache';

class UiListenerHandler implements CacheListener {
  private url: string;
  private listeners = new ArrayList<CacheListener>();

  constructor(url: string, listeners: ArrayList<CacheListener>) {
    this.url = url;
    this.listeners = listeners;
  }

  onCacheAvailable(cacheFilePath: string, url: string, percentsAvailable: number) {
    this.listeners.forEach((cacheListener: CacheListener, index?: number, arrlist?: ArrayList<CacheListener>) => {
      cacheListener.onCacheAvailable(cacheFilePath, url, percentsAvailable);
    })
  }
}

export default class HttpProxyCacheServerClients {
  private clientsCount: number = 0;
  private url: string;
  private proxyCache: HttpProxyCache | null = null;
  private uiCacheListener: CacheListener | null = null;
  private config: Config | null = null;
  private listeners = new ArrayList<CacheListener>();

  constructor(url: string, config: Config) {
    this.url = Preconditions.checkNotNull(url);
    this.config = Preconditions.checkNotNull(config);
    this.uiCacheListener = new UiListenerHandler(url, this.listeners);
  }

  async processRequest(request: GetRequest, severConnect: socket.TCPSocketConnection): Promise<void> {
    try {
      this.startProcessRequest();
      if (!this.proxyCache) {
        throw new Error('proxyCache is null')
      }
      this.clientsCount++;
      await this.proxyCache.processRequest(request, severConnect);
    } finally {
      this.finishProcessRequest();
    }
  }

  private startProcessRequest(): void {
    this.proxyCache = this.proxyCache == null ? this.newHttpProxyCache() : this.proxyCache;
  }

  private newHttpProxyCache(): HttpProxyCache {
    if (!this.config) {
      throw new Error('proxyCache is null')
    }
    let source = new HttpUrlSource([this.url, this.config.sourceInfoStorage, this.config.headerInjector]);
    let cache = new FileCache(this.config.generateCacheFile(this.url), this.config.diskUsage);
    let httpProxyCache = new HttpProxyCache(source, cache);
    httpProxyCache.registerCacheListener(this.uiCacheListener);
    return httpProxyCache;
  }

  private finishProcessRequest(): void {
    this.clientsCount--;
    if (this.clientsCount <= 0) {
      if (this.proxyCache) {
        this.proxyCache.shutdown();
      }
      this.proxyCache = null;
    }
  }

  public registerCacheListener(cacheListener: CacheListener): void {
    this.listeners.add(cacheListener);
  }

  public unregisterCacheListener(cacheListener: CacheListener): void {
    this.listeners.remove(cacheListener);
  }

  public shutdown(): void {
    this.listeners.clear();
    if (this.proxyCache != null) {
      this.proxyCache?.registerCacheListener(null);
      this.proxyCache?.shutdown();
    }
    this.proxyCache = null;
    this.clientsCount = 0;
  }

  getClientsCount(): number {
    return this.clientsCount;
  }
}

