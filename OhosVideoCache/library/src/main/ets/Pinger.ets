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
import taskpool from '@ohos.taskpool';
import connection from '@ohos.net.connection';
import Preconditions from './Preconditions';
import { ProxyCacheException } from './ProxyCacheException';
import emitter from '@ohos.events.emitter';
import buffer from '@ohos.buffer';
import { VideoCacheConstant } from './constant/VideoCacheConstant';
import { LogUtil } from './LogUtil';

@Concurrent
async function pingCallable(host: string, port: number) {
  try {
    LogUtil.info("pingCallable 开始TCP连接, host = " + host + ", port = " + port);
    
    // 创建TCP Socket连接
    let tcpSocket = socket.constructTCPSocketInstance();
    
    // 设置连接参数
    let connectOption: socket.TCPConnectOptions = {
      address: {
        address: host,
        port: port,
      },
      timeout: 5000
    };
    
    // 建立连接
    await tcpSocket.connect(connectOption);
    
    // 构造HTTP GET请求
    let httpRequest = `GET /${VideoCacheConstant.PING_REQUEST} HTTP/1.1\r\nHost: ${host}:${port}\r\nConnection: close\r\n\r\n`;
    let requestBuffer = buffer.from(httpRequest, 'utf-8');
    
    // 发送请求
    let sendOption: socket.TCPSendOptions = {
      data: requestBuffer.buffer
    };
    await tcpSocket.send(sendOption);
    LogUtil.info("HTTP请求发送成功: " + httpRequest.trim());
    
    // 使用事件监听器接收响应
    let responseData = '';
    let responseReceived = false;
    
    // 设置消息监听器
    tcpSocket.on('message', (value: socket.SocketMessageInfo) => {
      LogUtil.info("收到TCP消息，长度: " + value.message.byteLength);
      
      // 解析接收到的数据
      for (let i: number = 0; i < value.message.byteLength; i++) {
        let uint8Array = new Uint8Array(value.message);
        let messages = uint8Array[i];
        let message = String.fromCharCode(messages);
        responseData += message;
      }

      LogUtil.info("累积响应数据: " + responseData);
      if (responseData.endsWith(VideoCacheConstant.PING_RESPONSE)) {
        responseReceived = true;
        // 发送事件
        let eventData: emitter.EventData = {
          data: {
            "content": true,
            "id": VideoCacheConstant.PING_EVENT_ID
          }
        };
        emitter.emit(VideoCacheConstant.PING_EVENT_ID.toString(), eventData);
        // 关闭连接
        tcpSocket.close();
      }
    });
    
    // 等待响应或超时
    let timeoutPromise = new Promise<void>((resolve) => {
      setTimeout(() => {
        if (!responseReceived) {
          LogUtil.warn("ping响应超时");
          
          // 发送超时事件
          let eventData: emitter.EventData = {
            data: {
              "content": false,
              "id": VideoCacheConstant.PING_EVENT_ID
            }
          };
          emitter.emit(VideoCacheConstant.PING_EVENT_ID.toString(), eventData);
          
          // 关闭连接
          tcpSocket.close();
        }
        resolve();
      }, 5000); // 5秒超时
    });
    
    // 等待响应完成或超时
    await timeoutPromise;
    
  } catch (err) {
    LogUtil.error("Error in pingCallable: " + err.message);
    
    // 即使失败也要发送事件，避免阻塞
    let eventData: emitter.EventData = {
      data: {
        "content": false,
        "id": VideoCacheConstant.PING_EVENT_ID
      }
    };
    emitter.emit(VideoCacheConstant.PING_EVENT_ID.toString(), eventData);
  }
}

export default class Pinger {
  private host: string;
  private port: number;

  constructor(host: string, port: number) {
    this.host = Preconditions.checkNotNull(host);
    this.port = port;
    LogUtil.info(`[PINGER] Pinger实例创建成功: host=${this.host}, port=${this.port}`);
  }

  async ping(maxAttempts: number, startTimeout: number): Promise<boolean> {
    Preconditions.checkArgument(maxAttempts >= 1);
    Preconditions.checkArgument(startTimeout > 0);
    LogUtil.info(`[PING] 开始ping服务器: host=${this.host}, port=${this.port}, maxAttempts=${maxAttempts}, startTimeout=${startTimeout}ms`);
    const self = this;
    let timeout = startTimeout;
    let attempts = 0;
    let pingData: boolean = false;
    while (attempts < maxAttempts) {
      try {
        LogUtil.info(`[PING] 第${attempts + 1}次尝试ping，超时时间: ${timeout}ms`);
        pingData = await new Promise<boolean>((resolve, reject) => {
          // 设置事件监听器
          let eventListener = (data: emitter.EventData) => {
            if (data && data.data && data.data.content && typeof data.data.content === 'boolean') {
              LogUtil.info(`[PING] 收到ping响应: ${data.data.content}`);
              resolve(data.data.content);
            } else {
              LogUtil.warn(`[PING] 收到无效的ping响应数据`);
              resolve(false);
            }
          };
          emitter.on(VideoCacheConstant.PING_EVENT_ID.toString(), eventListener);
          // 设置超时
          let timeoutId = setTimeout(() => {
            LogUtil.warn(`[PING] ping超时，超时时间: ${timeout}ms`);
            emitter.off(VideoCacheConstant.PING_EVENT_ID.toString(), eventListener);
            resolve(false);
          }, timeout);
          // 执行ping
          let url = self.getPingUrl();
          LogUtil.info(`[PING] 发送ping请求到: ${url}`);
          
          let runningTask: taskpool.Task = new taskpool.Task(pingCallable, self.host, self.port);
          taskpool.execute(runningTask, taskpool.Priority.HIGH).then(() => {
            // ping完成后清理超时定时器
            clearTimeout(timeoutId);
          }).catch((error: Error) => {
            LogUtil.error(`[PING] ping执行失败: ${error.message}`);
            clearTimeout(timeoutId);
            emitter.off(VideoCacheConstant.PING_EVENT_ID.toString(), eventListener);
            resolve(false);
          });
        });
        
        if (pingData) {
          LogUtil.info(`[PING] ping成功，尝试次数: ${attempts + 1}`);
          break;
        }
      } catch (err) {
        LogUtil.warn(`[PING] 第${attempts + 1}次ping失败: ${err.message}`);
      }
      attempts++;
      timeout *= 2;
    }
    if (pingData) {
      LogUtil.info(`[PING] ping最终成功，总尝试次数: ${attempts + 1}`);
      return pingData;
    } else {
      LogUtil.error(`[PING] ping最终失败，总尝试次数: ${attempts + 1}`);
      // 获取默认代理信息用于诊断
      let proxy = await this.getDefaultProxies();
      let error = `Error pinging server (attempts: ${attempts}, max timeout: ${timeout / 2}).
If you see this message, please, report at https://github.com/danikula/AndroidVideoCache/issues/134.
Default proxies are:${JSON.stringify(proxy)}`;
      
      LogUtil.error('error: ' + new ProxyCacheException(error));
      return false;
    }
  }

  isPingRequest(request: string): boolean {
    return VideoCacheConstant.PING_REQUEST == request;
  }

  async responseToPing(socket: socket.TCPSocketConnection): Promise<void> {
    try {
      LogUtil.info(`[RESPONSE_TO_PING] 开始响应ping请求`);
      
      // 发送HTTP响应头
      let header: socket.TCPSendOptions = {
        data: "HTTP/1.1 200 OK\r\nContent-Type: text/plain\r\nContent-Length: 7\r\n\r\n"
      };
      await socket?.send(header);
      LogUtil.info(`[RESPONSE_TO_PING] HTTP响应头发送成功`);
      
      // 发送ping响应体
      let body: socket.TCPSendOptions = {
        data: VideoCacheConstant.PING_RESPONSE
      };
      await socket?.send(body);
    } catch (err) {
      LogUtil.error(`[RESPONSE_TO_PING] 响应ping请求失败: ${err.message}`);
    }
    
    return Promise.resolve();
  }


  private async getDefaultProxies(): Promise<connection.HttpProxy> {
    try {
      let result = await connection.getDefaultHttpProxy();
      return result;
    } catch (err) {
      throw new ProxyCacheException(err.message);
    }
  }

  private getPingUrl(): string {
    return `http://${this.host}:${this.port}/${VideoCacheConstant.PING_REQUEST}`;
  }
}