/**
 * Copyright (C) 2025 Huawei Device Co., Ltd.
 *
 * This software is distributed under a license. The full license
 * agreement can be found in the file LICENSE in this distribution.
 * This software may not be copied, modified, sold or distributed
 * other than expressed in the named license agreement.
 *
 * This software is distributed without any warranty.
 */

// RobustEventSource.ts

import http from '@ohos.net.http';
import util from '@ohos.util';
import { url } from '@kit.ArkTS';

/**
 * 简单的EventEmitter实现
 */
class SimpleEventEmitter {
  private listeners: Map<string, Function[]> = new Map();
  private maxListeners: number = 10; // 默认最大监听器数量

  on(event: string, listener: Function): void {
    if (!this.listeners.has(event)) {
      this.listeners.set(event, []);
    }
    
    const eventListeners = this.listeners.get(event)!;
    
    // 检查监听器数量限制
    if (eventListeners.length >= this.maxListeners) {
      console.warn(`警告: 事件'${event}'的监听器数量(${eventListeners.length})超过建议最大值(${this.maxListeners})`);
    }
    
    eventListeners.push(listener);
  }

  emit(event: string, ...args: any[]): boolean {
    const eventListeners = this.listeners.get(event);
    if (!eventListeners || eventListeners.length === 0) {
      // 如果是error事件且没有监听器，应该抛出异常
      if (event === 'error' && args[0] instanceof Error) {
        throw args[0];
      }
      return false;
    }
    
    eventListeners.forEach(listener => {
      try {
        listener(...args);
      } catch (error) {
        // 向error事件传播错误
        if (event !== 'error') {
          this.emit('error', error);
        } else {
          // 防止无限递归
          console.error('EventEmitter error event listener threw:', error);
        }
      }
    });
    
    return true;
  }

  removeAllListeners(event?: string): void {
    if (event) {
      this.listeners.delete(event);
    } else {
      this.listeners.clear();
    }
  }

  off(event: string, listener: Function): void {
    const eventListeners = this.listeners.get(event);
    if (eventListeners) {
      const index = eventListeners.indexOf(listener);
      if (index !== -1) {
        eventListeners.splice(index, 1);
      }
    }
  }

  // 添加once支持
  once(event: string, listener: Function): void {
    const onceWrapper = (...args: any[]) => {
      this.off(event, onceWrapper);
      listener(...args);
    };
    this.on(event, onceWrapper);
  }

  // 添加监听器计数
  listenerCount(event: string): number {
    return this.listeners.get(event)?.length || 0;
  }

  // 设置最大监听器数量
  setMaxListeners(n: number): void {
    this.maxListeners = n;
  }
}

/**
 * 模拟W3C标准的MessageEvent
 */
class MessageEvent {
  public readonly type: string = 'message';
  public readonly data: string;
  public readonly lastEventId: string;
  public readonly origin: string;

  constructor(type: string, eventInitDict: { data: string; lastEventId: string; origin: string; }) {
    this.type = type;
    this.data = eventInitDict.data;
    this.lastEventId = eventInitDict.lastEventId;
    this.origin = eventInitDict.origin;
  }
}

interface EventSourceOptions {
  headers?: Record<string, string>;
  reconnectInterval?: number;
}

/**
 * 基于鸿蒙原生API的EventSource实现
 */
export class RobustEventSource extends SimpleEventEmitter {
  public static readonly CONNECTING = 0;
  public static readonly OPEN = 1;
  public static readonly CLOSED = 2;

  // 消息大小和性能限制
  private static readonly MAX_MESSAGE_SIZE = 1024 * 1024; // 1MB限制
  private static readonly MAX_BUFFER_SIZE = 2 * 1024 * 1024; // 2MB缓冲区限制
  private static readonly RECONNECT_MAX_ATTEMPTS = 5; // 最大重连次数

  public readonly url: string;
  public readyState: number = RobustEventSource.CONNECTING;

  private httpRequest: http.HttpRequest;
  private options: EventSourceOptions;
  private buffer: string = '';
  private lastEventId: string = '';
  private reconnectInterval: number = 5000;
  private reconnectTimer: number | null = null;
  private reconnectAttempts: number = 0;
  private origin: string;
  private isActive: boolean = false;
  private decoder: util.TextDecoder = new util.TextDecoder();

  // 性能监控字段
  private messageCount: number = 0;
  private lastMessageTime: number = Date.now();
  private connectionStartTime: number = Date.now();

  // onmessage, onopen, onerror 的快捷方式
  set onmessage(listener: (event: MessageEvent) => void) {
    this.removeAllListeners('message');
    this.on('message', listener);
  }

  set onopen(listener: () => void) {
    this.removeAllListeners('open');
    this.on('open', listener);
  }

  set onerror(listener: (error?: Error) => void) {
    this.removeAllListeners('error');
    this.on('error', listener);
  }

  constructor(url: string, options: EventSourceOptions = {}) {
    super();
    this.url = url;
    this.options = options;
    this.reconnectInterval = options.reconnectInterval ?? this.reconnectInterval;
    
    // 使用鸿蒙官方URL API解析origin
    this.origin = this.parseOriginWithOfficialAPI(url);

    this.connect();
  }

  /**
   * 使用鸿蒙官方API解析URL的origin
   * 支持复杂的URL格式，包括IPv6、端口号、认证信息等
   */
  private parseOriginWithOfficialAPI(urlString: string): string {
    try {
      const urlObject = url.URL.parseURL(urlString);
      return urlObject.origin;
    } catch (e) {
      // 如果官方API解析失败，回退到简化实现
      return this.parseOriginFallback(urlString);
    }
  }

  /**
   * 回退的URL解析实现
   * 用于处理官方API无法解析的特殊情况
   */
  private parseOriginFallback(urlString: string): string {
    try {
      if (urlString.startsWith('https://')) {
        const hostPart = urlString.substring(8);
        const slashIndex = hostPart.indexOf('/');
        const host = slashIndex > 0 ? hostPart.substring(0, slashIndex) : hostPart;
        return 'https://' + host;
      } else if (urlString.startsWith('http://')) {
        const hostPart = urlString.substring(7);
        const slashIndex = hostPart.indexOf('/');
        const host = slashIndex > 0 ? hostPart.substring(0, slashIndex) : hostPart;
        return 'http://' + host;
      } else {
        return '';
      }
    } catch (e) {
      return '';
    }
  }

  private connect(): void {
    this.isActive = true;
    this.readyState = RobustEventSource.CONNECTING;
    
    if (this.reconnectTimer) {
      clearTimeout(this.reconnectTimer);
      this.reconnectTimer = null;
    }

    this.httpRequest = http.createHttp();
    
    // 设置请求头
    const headers: Record<string, string> = {
      'Accept': 'text/event-stream',
      'Cache-Control': 'no-cache'
    };
    
    if (this.options.headers) {
      // 合并headers
      Object.assign(headers, this.options.headers);
    }

    if (this.lastEventId) {
      headers['Last-Event-ID'] = this.lastEventId;
    }

    const requestOptions = {
      method: http.RequestMethod.GET,
      header: headers,
      readTimeout: 0
    };

    // 设置数据接收监听
    this.httpRequest.on('dataReceive', (data: ArrayBuffer) => {
      if (!this.isActive) return;
      
      // 一旦收到数据，立即设置为OPEN状态（避免握手超时）
      if (this.readyState !== RobustEventSource.OPEN) {
        this.readyState = RobustEventSource.OPEN;
        this.emit('open');
      }
      
      try {
        const chunk = this.decoder.decode(new Uint8Array(data));
        this.processChunk(chunk);
      } catch (e) {
        this.handleError(new Error('Failed to decode chunk'));
      }
    });

    // 发起请求
    let promise = this.httpRequest.requestInStream(this.url, requestOptions);

    promise.then((data: number) => {
      if (this.readyState !== RobustEventSource.OPEN) {
        this.readyState = RobustEventSource.OPEN;
        this.emit('open');
      }
    }).catch((err: Error) => {
      this.handleError(err);
    });
  }

  private processChunk(chunk: string): void {
    // 检查缓冲区大小，防止内存耗尽
    if (this.buffer.length + chunk.length > RobustEventSource.MAX_BUFFER_SIZE) {
      this.handleError(new Error(`Buffer overflow: size would exceed ${RobustEventSource.MAX_BUFFER_SIZE} bytes`));
      return;
    }

    this.buffer += chunk;
    const lines = this.buffer.split('\n');
    this.buffer = lines[lines.length - 1] || '';

    for (let i = 0; i < lines.length - 1; i++) {
      const line = lines[i].replace('\r', '').trim();
      
      if (line === '') continue;
      if (line === ':') continue; // SSE注释行

      if (line.startsWith('data:')) {
        const data = line.slice(5).trim();
        
        // 检查单个消息大小
        if (data.length > RobustEventSource.MAX_MESSAGE_SIZE) {
          this.handleError(new Error(`Message size exceeds maximum allowed size: ${data.length} > ${RobustEventSource.MAX_MESSAGE_SIZE}`));
          continue;
        }
        
        this.processMessageData(data);
      } else if (line.startsWith('id:')) {
        this.lastEventId = line.slice(3).trim();
      } else if (line.startsWith('event:')) {
        // 可以在将来扩展自定义事件支持
      } else if (line.startsWith('retry:')) {
        const newInterval = parseInt(line.slice(6).trim(), 10);
        if (!isNaN(newInterval) && newInterval >= 0) {
          this.reconnectInterval = Math.min(newInterval, 60000); // 最大60秒重连间隔
        }
      }
    }

    // 防止缓冲区无限增长
    if (this.buffer.length > RobustEventSource.MAX_MESSAGE_SIZE) {
      // 保留最后的部分数据，防止消息被截断
      this.buffer = this.buffer.slice(-RobustEventSource.MAX_MESSAGE_SIZE / 2);
    }
  }

  /**
   * 处理消息数据并进行性能监控
   */
  private processMessageData(data: string): void {
    if (!data) return;

    // 更新性能统计
    this.messageCount++;
    this.lastMessageTime = Date.now();

    // 检查连接健康状态
    this.checkConnectionHealth();

    try {
      // 检查是否包含SignalR终止符
      if (data.endsWith('\u001e')) {
        this.dispatchMessage(data);
      } else {
        // 处理没有终止符的数据（可能是其他格式）
        if (data === '{}' || (data.startsWith('{') && data.endsWith('}'))) {
          this.dispatchMessage(data);
        }
      }
    } catch (e) {
      this.handleError(new Error('Error processing message data: ' + e.message));
    }
  }

  /**
   * 派发消息事件
   */
  private dispatchMessage(data: string): void {
    const messageEvent = new MessageEvent('message', {
      data: data,
      lastEventId: this.lastEventId,
      origin: this.origin,
    });
    
    if (this.onmessage) {
      this.onmessage(messageEvent);
    }
    
    this.emit('message', messageEvent);
  }

  /**
   * 检查连接健康状态
   */
  private checkConnectionHealth(): void {
    const now = Date.now();
    const timeSinceLastMessage = now - this.lastMessageTime;
    
    // 如果超过30秒没有收到消息，发出警告但不断开连接
    if (timeSinceLastMessage > 30000 && this.messageCount > 1) {
      console.warn(`SSE连接可能不稳定，已${Math.floor(timeSinceLastMessage/1000)}秒未收到消息`);
    }
    
    // 连接质量统计
    const connectionDuration = now - this.connectionStartTime;
    if (connectionDuration > 60000) { // 连接超过1分钟
      const messagesPerMinute = (this.messageCount / (connectionDuration / 60000));
      if (messagesPerMinute < 0.1) { // 每分钟少于0.1条消息
        console.warn(`SSE连接消息频率较低: ${messagesPerMinute.toFixed(2)} 消息/分钟`);
      }
    }
  }

  private handleError(error: Error): void {
    this.reconnectAttempts++;
    
    // 如果重连次数过多，建议切换传输方式
    if (this.reconnectAttempts > RobustEventSource.RECONNECT_MAX_ATTEMPTS) {
      this.emit('transportShouldFallback', error);
      this.close();
      return;
    }
    
    this.emit('error', error);
    this.reconnect();
  }

  private reconnect(): void {
    if (this.readyState === RobustEventSource.CLOSED) return;
    
    if (this.reconnectTimer) {
      return;
    }
    
    // 使用指数退避策略
    const backoffDelay = Math.min(
      this.reconnectInterval * Math.pow(2, this.reconnectAttempts - 1),
      30000 // 最大30秒
    );
    
    this.reconnectTimer = setTimeout(() => {
      this.reconnectTimer = null;
      // 重置性能统计
      this.connectionStartTime = Date.now();
      this.messageCount = 0;
      this.lastMessageTime = Date.now();
      this.connect();
    }, backoffDelay);
  }

  public close(): void {
    if (this.readyState === RobustEventSource.CLOSED) return;

    this.readyState = RobustEventSource.CLOSED;
    this.isActive = false;
    
    if (this.httpRequest) {
      this.httpRequest.off('dataReceive');
      this.httpRequest.destroy();
    }
    if (this.reconnectTimer) {
      clearTimeout(this.reconnectTimer);
      this.reconnectTimer = null;
    }
    this.removeAllListeners();
  }

  // W3C兼容的API
  public addEventListener(type: string, listener: (...args: any[]) => void): void {
    this.on(type, listener);
  }

  public removeEventListener(type: string, listener: (...args: any[]) => void): void {
    this.off(type, listener);
  }

  /**
   * 获取连接统计信息
   */
  public getConnectionStats() {
    const now = Date.now();
    const connectionDuration = now - this.connectionStartTime;
    return {
      connectionDuration,
      messageCount: this.messageCount,
      messagesPerMinute: connectionDuration > 0 ? (this.messageCount / (connectionDuration / 60000)) : 0,
      lastMessageTime: this.lastMessageTime,
      reconnectAttempts: this.reconnectAttempts,
      bufferSize: this.buffer.length
    };
  }
}