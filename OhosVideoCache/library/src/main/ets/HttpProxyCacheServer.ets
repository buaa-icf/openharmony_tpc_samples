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

import HashMap from '@ohos.util.HashMap';
import HttpProxyCacheServerClients from './HttpProxyCacheServerClients';
import socket from '@ohos.net.socket';
import Config from './Config';
import Pinger from './Pinger';
import Preconditions from './Preconditions';

import IgnoreHostProxySelector from './IgnoreHostProxySelector';
import ProxyCacheUtils from './ProxyCacheUtils';
import fs from '@ohos.file.fs';
import { CacheListener } from './CacheListener';
import { ProxyCacheException } from './ProxyCacheException';
import GetRequest from './GetRequest';
import HttpProxyCacheServerBuilder from './HttpProxyCacheServerBuilder';
import MessageCallBackBean from './bean/MessageCallBackBean';

import buffer from '@ohos.buffer';
import { Context } from '@ohos.abilityAccessCtrl';
import emitter from '@ohos.events.emitter';
import { VideoCacheConstant } from './constant/VideoCacheConstant';
import { LogUtil } from './LogUtil';
import HttpUrlSource from './HttpUrlSource';
import StorageUtils from './StorageUtils';

const BASE_COUNT = 1

interface clientAccessTime {
  url: string,
  accessTime: number
}

export default class HttpProxyCacheServer {
  private static libraryVersion: string = '1.0.0'
  private PROXY_HOST: string = "127.0.0.1";
  private clientsMap: HashMap<String, HttpProxyCacheServerClients> = new HashMap<string, HttpProxyCacheServerClients>();
  // LRU 清理相关字段
  private clientsAccessTime: HashMap<String, number> = new HashMap<string, number>();
  private maxClientsCount: number = 50; // 最大客户端数量
  private cleanupRatio: number = 0.2;   // 清理比例：每次清理20%的客户端
  private port: number = 0;
  private config: Config | null = null;
  private pinger: Pinger | null = null;
  private serverSocket: socket.TCPSocketServer | null = socket.constructTCPSocketServerInstance();
  private isServerReady: boolean = false;

  public static setLibraryVersion(version: string) {
    if (version && version.length >= 1) {
      HttpProxyCacheServer.libraryVersion = version;
    } else {
      HttpProxyCacheServer.libraryVersion = '1.0.0';
    }
  }

  public static getLibraryVersion() {
    if (!HttpProxyCacheServer.libraryVersion || HttpProxyCacheServer.libraryVersion.length < 1) {
      HttpProxyCacheServer.libraryVersion = '1.0.0';
    }
    return HttpProxyCacheServer.libraryVersion
  }

  constructor(param: Context | Config) {
    if (!param) {
      throw new Error('params can not be null')
    }
    if (param instanceof Config) {
      this.config = Preconditions.checkNotNull((param as Config));
    } else {
      this.config = new HttpProxyCacheServerBuilder((param as Context)).buildConfig()
    }
    try {
      this.port = Math.round((Math.random() * (65535 - 1024)) + 1024);
      IgnoreHostProxySelector.install(this.PROXY_HOST, this.port);
      this.waitForRequest();
    } catch (err) {
      throw new Error("Error starting local proxy server " + err.message);
    }

  }

  async waitForRequest(): Promise<void> {
    try {
      let requestArg: socket.NetAddress = {
        address: this.PROXY_HOST,
        port: this.port,
        family: 1
      }
      await this.serverSocket?.listen(requestArg);
      //服务端使用listen方法完成bind，listen，accept操作，bind方法失败会由系统随机分配端口号,所以此处需要获取端口号
      const netAddress = await this.serverSocket?.getLocalAddress();
      if (netAddress?.port !== null && netAddress?.port !== undefined) {
        this.port = netAddress?.port;
      }
      this.serverSocket?.on("connect", async (clientSocket: socket.TCPSocketConnection) => {
        clientSocket?.on("message", (data: MessageCallBackBean) => {
          if (data && data.message) {
            this.processSocket(data.message, clientSocket)
          }
        })
        clientSocket?.on("error", (err: Error) => {
          this.closeSocket(clientSocket, false)
        })
        clientSocket?.on("close", () => {
          this.closeSocket(clientSocket, true)
        })
      })
      this.pinger = new Pinger(this.PROXY_HOST, this.port)
      this.isServerReady = true;
      emitter.emit(VideoCacheConstant.SERVER_READY_ID.toString())
      return Promise.resolve()
    } catch (err) {
      return Promise.reject(err)
    }
  }

  async processSocket(requestInfo: ArrayBuffer, severConnect: socket.TCPSocketConnection) {
    let self = this;
    try {
      let request = GetRequest.read(requestInfo);
      let url = ProxyCacheUtils.decode(request.uri);
      if (self.pinger && self.pinger.isPingRequest(url)) {
        await self.pinger?.responseToPing(severConnect);
      } else {
        let clients = self.getClients(url);
        await clients.processRequest(request, severConnect);
      }
    } catch (err) {
      self.onError(new ProxyCacheException("Error processing request,reason is : " + err.message));
    } finally {
      if (severConnect) {
        self.releaseSocket(severConnect, false);
      }
    }
  }


  /**
   * Returns url that wrap original url and should be used for client (MediaPlayer, ExoPlayer, etc).
   * <p>
   * If parameter {@code allowCachedFileUri} is {@code true} and file for this url is fully cached
   * (it means method {@link #isCached(String)} returns {@code true}) then file:// uri to cached file will be returned.
   *
   * @param url                a url to file that should be cached.
   * @param allowCachedFileUri {@code true} if allow to return file:// uri if url is fully cached
   * @return a wrapped by proxy url if file is not fully cached or url pointed to cache file otherwise (if {@code allowCachedFileUri} is {@code true}).
   */
  public async getProxyUrl(url: string, allowCachedFileUri: boolean = true): Promise<string> {
    try {
      if (allowCachedFileUri && this.isCached(url)) {
        let cacheFile = this.getCacheFile(url);
        this.touchFileSafely(cacheFile);
        return cacheFile;
      }
      
      // 创建超时Promise，3秒后超时
      let timeoutId: number | null = null;
      const timeoutPromise = new Promise<string>((resolve) => {
        timeoutId = setTimeout(() => {
          LogUtil.warn("getProxyUrl timeout after 3 seconds, returning original URL");
          resolve(url);
        }, 3000);
      });
      
      // 创建实际执行逻辑的Promise
      const executePromise = new Promise<string>(async (resolve) => {
        try {
          // 以下代码是为了确保服务器准备好了 不加这里的逻辑 很可能服务器没初始化，导致下面的isAlive直接返回false，逻辑就不走代理了
          await new Promise<void>((resolveServer) => {
            if (this.isServerReady) {
              resolveServer()
            } else {
              emitter.on(VideoCacheConstant.SERVER_READY_ID.toString(), (data: emitter.EventData) => {
                resolveServer()
              })
            }
          })

          let result = await this.isAlive();
          // 清理超时定时器
          if (timeoutId !== null) {
            clearTimeout(timeoutId);
            timeoutId = null;
          }
          resolve(result ? this.appendToProxyUrl(url) : url);
        } catch (error) {
          LogUtil.error("Error in getProxyUrl execution: " + error.message);
          // 清理超时定时器
          if (timeoutId !== null) {
            clearTimeout(timeoutId);
            timeoutId = null;
          }
          resolve(url);
        }
      });
      
      // 使用Promise.race实现超时机制，先完成的Promise会返回结果
      return Promise.race([executePromise, timeoutPromise]);
      
    } catch (error) {
      LogUtil.error("Error in getProxyUrl: " + error.message);
      return url; // 返回原始URL
    }
  }

  /**
   * 返回端口号 用于编写单元测试
   * @returns 端口号
   */
  public getProxyPort(): number {
    return this.port;
  }

  /**
   * 返回代理服务器配置信息 用于编写单元测试
   * @returns 代理服务器配置信息
   */
  public getConfig(): Config | null {
    return this.config;
  }

  /**
   * Checks is cache contains fully cached file for particular url.
   *
   * @param url an url cache file will be checked for.
   * @return {@code true} if cache contains fully cached file for passed in parameters url.
   */
  public isCached(url: string): boolean {
    Preconditions.checkNotNull(url, "Url can't be null!");
    return fs.accessSync(this.getCacheFile(url))
  }

  private appendToProxyUrl(url: string): string {
    return `http://${this.PROXY_HOST}:${this.port}/${ProxyCacheUtils.encode(url)}`;
  }

  private getCacheFile(url: string): string {
    if (this.config && this.config.fileNameGenerator) {
      let cacheDir = this.config.cacheRoot;
      let fileName = this.config.fileNameGenerator.generate(url);
      return `${cacheDir}/${fileName}`;
    }
    return ``;
  }

  private async isAlive(): Promise<boolean> {
    if (this.pinger) {
      let result = await this.pinger.ping(3, 70); // 70+140+280=max~500ms
      return new Promise((resolve, reject) => {
        resolve(result)
      });
    } else {
      return new Promise((resolve, reject) => {
        resolve(false)
      });
    }

  }

  private touchFileSafely(cacheFile: string): void {
    try {
      if (this.config && this.config.diskUsage) {
        this.config.diskUsage.touch(cacheFile);
      }
    } catch (err) {
      console.error("Error touching file " + cacheFile + "  ,reason is " + err.message);
    }
  }

  public registerCacheListener(cacheListener: CacheListener, url: string): void {
    Preconditions.checkAllNotNull(cacheListener, url);
    if (!url || url.length < 1) {
      throw new Error('url is null')
    }
    try {
      this.getClients(url).registerCacheListener(cacheListener);
    } catch (err) {
      console.warn("Error registering cache listener,reason is : " + err.message);
    }
  }

  public unregisterCacheListener(cacheListener: CacheListener, url: string): void {
    if (url && url.length > 0) {
      Preconditions.checkAllNotNull(cacheListener, url);
      try {
        this.getClients(url).unregisterCacheListener(cacheListener);
      } catch (err) {
        console.warn("Error registering cache listener,reason is : " + err.message);
      }
    } else {
      Preconditions.checkNotNull(cacheListener);
      this.clientsMap.forEach((clients: HttpProxyCacheServerClients, key: string, map: HashMap<string, HttpProxyCacheServerClients>) => {
        clients.unregisterCacheListener(cacheListener);
      })
    }
  }

  public shutdown(): void {
    LogUtil.info("Shutdown proxy server");
    emitter.emit(VideoCacheConstant.SHUT_DOWN_TASKPOOL.toString());
    this.shutdownClients();
    if (this.config && this.config.sourceInfoStorage) {
      this.config.sourceInfoStorage.release();
    }
    emitter.off(VideoCacheConstant.PING_EVENT_ID.toString())
    emitter.off(VideoCacheConstant.SEND_TOTAL_SIZE_ID.toString())
    emitter.off(VideoCacheConstant.SEND_ACCEPT_ID.toString())
    emitter.off(VideoCacheConstant.COUNT_TOTAL_SIZE_ID.toString())
    emitter.off(VideoCacheConstant.COUNT_TOTAL_SIZE_START_ID.toString())
    emitter.off(VideoCacheConstant.COUNT_TOTAL_SIZE_END_ID.toString())
    emitter.off(VideoCacheConstant.GET_ACCEPT_ID.toString())
    emitter.off(VideoCacheConstant.HTTP_URL_SOURCE_READY_ID.toString())
    emitter.off(VideoCacheConstant.SERVER_READY_ID.toString())
    emitter.off(VideoCacheConstant.RENAME_FINISH_ID.toString())
    emitter.off(VideoCacheConstant.SHUT_DOWN_TASKPOOL.toString())
  }

  private onError(e: Error | ProxyCacheException): void {
    console.error("HttpProxyCacheServer error,reason is " + e.message);
  }

  private shutdownClients(): void {
    this.clientsMap?.forEach(async (clients: HttpProxyCacheServerClients, key: string, map: HashMap<string, HttpProxyCacheServerClients>) => {
      await clients?.shutdown();
    })
    this.clientsMap.clear();
    // 清理访问时间记录
    this.clientsAccessTime.clear();
  }

  /**
   * 获取当前活跃的 HttpUrlSource 实例
   * 用于外部调用 destroy 方法来关闭连接
   * @param url 视频URL
   * @returns HttpUrlSource 实例或 null
   */
  public getCurrentSource(url: string): HttpUrlSource | null {
    try {
      const clients = this.clientsMap.get(url);
      if (clients) {
        return clients.getCurrentSource();
      }
      return null;
    } catch (err) {
      LogUtil.error('getCurrentSource error: ' + JSON.stringify(err));
      return null;
    }
  }

  /**
   * 销毁指定URL的当前连接
   * @param url 视频URL
   */
  public destroyCurrentSource(url: string): void {
    try {
      const source = this.getCurrentSource(url);
      if (source) {
        source.destroy();
        LogUtil.info(`已销毁连接: ${url}`);
      }
    } catch (err) {
      LogUtil.error('destroyCurrentSource error: ' + JSON.stringify(err));
    }
  }

  /**
   * 获取缓存目录的总大小（字节）
   * @returns 缓存总大小（字节）
   */
  public getCacheSize(): number {
    if (!this.config) {
      LogUtil.error('Config is null, cannot get cache size');
      return 0;
    }

    const cacheDir = StorageUtils.DEFAULT_DIR;
    if (!cacheDir) {
      LogUtil.error('Cache root directory is not configured');
      return 0;
    }

    try {
      if (!fs.accessSync(cacheDir)) {
        LogUtil.log(`Cache directory ${cacheDir} does not exist`);
        return 0;
      }

      let totalSize = 0;
      const files = fs.listFileSync(cacheDir);
      
      if (files && files.length > 0) {
        for (let i = 0; i < files.length; i++) {
          const filePath = cacheDir + '/' + files[i];
          try {
            const stat = fs.statSync(filePath);
            if (stat.isFile()) {
              totalSize += stat.size;
            }
          } catch (err) {
            LogUtil.error(`Error getting file size for ${filePath}: ${JSON.stringify(err)}`);
          }
        }
      }

      LogUtil.info(`Cache size calculated: ${totalSize} bytes`);
      return totalSize;
    } catch (err) {
      LogUtil.error('getCacheSize error: ' + JSON.stringify(err));
      return 0;
    }
  }

  /**
   * 清理clientsMap
   */
  public clearClientsMap() {
    this.clientsMap.clear();
  }

  private getClients(url: string | null): HttpProxyCacheServerClients {
    if (!this.config) {
      throw new Error('config is null')
    }
    if (!this.clientsMap) {
      throw new Error('clientsMap is null')
    }
    if (!url || url.length < 1) {
      throw new Error('url is null')
    }
    let clients = this.clientsMap.get(url);
    if (clients == null || clients == undefined) {
      clients = new HttpProxyCacheServerClients(url, this.config);
      this.clientsMap.set(url, clients);
    }
    // 更新访问时间
    this.clientsAccessTime.set(url, Date.now());

    // 检查是否需要执行 LRU 清理
    if (this.clientsMap.length > this.maxClientsCount) {
      LogUtil.info(`客户端数量 ${this.clientsMap.length} 超过阈值 ${this.maxClientsCount}，自动触发 LRU 清理`);
      this.performLRUCleanup();
    }

    return clients;
  }

  /**
   * 执行 LRU 清理操作
   */
  private performLRUCleanup(): void {
    LogUtil.info(`开始 LRU 清理 clientsMap，当前大小: ${this.clientsMap.length}`);

    // 按访问时间排序，找出最久未使用的客户端
    const entries: Array<clientAccessTime> = [];
    this.clientsAccessTime.forEach((accessTime: number, url: string) => {
      entries.push({url, accessTime});
    });

    // 按访问时间升序排序（最旧的在前）
    entries.sort((a, b) => a.accessTime - b.accessTime);

    // 计算需要清理的数量 - 每次清理更多，减少清理频率
    const needCleanupCount = Math.max(
      this.clientsMap.length - this.maxClientsCount,  // 基础清理数量
      Math.floor(this.clientsMap.length * this.cleanupRatio)        // 额外清理比例的客户端
    );

    // 清理最久未使用的客户端
    for (let i = 0; i < needCleanupCount && i < entries.length; i++) {
      const url = entries[i].url;
      const clients = this.clientsMap.get(url);

      if (clients) {
        LogUtil.info(`LRU 清理客户端: ${url}`);
        // 异步关闭客户端
        clients.shutdown().then(() => {
          LogUtil.info(`客户端已关闭: ${url}`);
        }).catch((err: Error) => {
          console.error(`关闭客户端失败: ${url}, 错误: ${err.message}`);
        });

        // 从 map 中移除
        this.clientsMap.remove(url);
        this.clientsAccessTime.remove(url);
      }
    }
  }

  private releaseSocket(severConnect: socket.TCPSocketConnection, isCloseByClient: boolean): void {
    // 鸿蒙不区分socket的input和output 直接关闭
    this.closeSocket(severConnect, isCloseByClient);
  }

  private closeSocket(severConnect: socket.TCPSocketConnection | null, isCloseByClient: boolean): void {
    // 客户端主动断开连接的情况下 不做处理 否则可能将正在执行的其他连接断开
    try {
      // 暂不处理 该方法关闭可能会关掉当前传输数据的severConnect而不是已经不再使用的severConnect 改为在HttpProxyCache里面关闭。
      if (!isCloseByClient && false) {
        severConnect?.off('message');
        severConnect?.off('error');
        severConnect?.off('close');
        severConnect?.close();
        severConnect = null;
      }
    } catch (err) {
      this.onError(err)
    }

  }
}