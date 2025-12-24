/**
 * Copyright (C) 2023 Huawei Device Co., Ltd.
 *
 * This software is distributed under a license. The full license
 * agreement can be found in the file LICENSE in this distribution.
 * This software may not be copied, modified, sold or distributed
 * other than expressed in the named license agreement.
 *
 * This software is distributed without any warranty.
 */
import { newSocketIOClient } from 'libclient_socket_c.so';

import { buffer_util } from './buffer_util';

// 1. 定义支持的数据类型
type SocketDataType =
  | string
  | number
  | boolean
  | null
  | undefined
  | object
  | ArrayBuffer
  | Function
  | Array<SocketDataType>;

// 2. 定义回调函数类型
type EmitCallbackType = (response: ESObject) => void;

export class client_socket {
  private mSocketIOClient: newSocketIOClient;
  private classId = 0;

  constructor() {
    this.mSocketIOClient = new newSocketIOClient();
    this.classId = this.mSocketIOClient.classId;
    console.log("LibSocketIOClient constructor classId:" + this.classId);
  }

  //client相关接口

  public set_open_listener(on_open: () => void) {
    this.mSocketIOClient.set_open_listener(on_open, this.classId);
  }

  public set_fail_listener(on_fail: () => void) {
    this.mSocketIOClient.set_fail_listener(on_fail, this.classId);
  }

  public set_reconnecting_listener(on_reconnecting: () => void) {
    this.mSocketIOClient.set_reconnecting_listener(on_reconnecting, this.classId);
  }

  public set_reconnect_listener(on_reconnect: () => void) {
    this.mSocketIOClient.set_reconnect_listener(on_reconnect, this.classId);
  }

  public set_close_listener(on_close: (reason: string) => void) {
    this.mSocketIOClient.set_close_listener(on_close, this.classId);
  }

  public set_socket_open_listener(on_socket_open: (nsp: string) => void) {
    this.mSocketIOClient.set_socket_open_listener(on_socket_open, this.classId);
  }

  public set_socket_close_listener(on_socket_close: (nsp: string) => void) {
    this.mSocketIOClient.set_socket_close_listener(on_socket_close, this.classId);
  }

  public set_headers(headers: string) {
    this.mSocketIOClient.set_headers(headers, this.classId);
  }

  public set_option(opt: string) {
    this.mSocketIOClient.set_option(opt, this.classId);
  }

  public connect(uri: string) {
    this.mSocketIOClient.connect(uri, this.classId);
  }

  public clear_con_listeners() {
    this.mSocketIOClient.clear_con_listeners(this.classId);
  }

  public clear_socket_listeners() {
    this.mSocketIOClient.clear_socket_listeners(this.classId);
  }

  public set_reconnect_attempts(attempts: number) {
    this.mSocketIOClient.set_reconnect_attempts(attempts, this.classId);
  }

  public set_reconnect_delay(millis: number) {
    this.mSocketIOClient.set_reconnect_delay(millis, this.classId);
  }

  public set_reconnect_delay_max(millis: number) {
    this.mSocketIOClient.set_reconnect_delay_max(millis, this.classId);
  }

  public set_logs_default() {
    this.mSocketIOClient.set_logs_default(this.classId);
  }

  public set_logs_quiet() {
    this.mSocketIOClient.set_logs_quiet(this.classId);
  }

  public set_logs_verbose() {
    this.mSocketIOClient.set_logs_verbose(this.classId);
  }

  public close() {
    this.mSocketIOClient.close(this.classId);
  }

  public sync_close() {
    this.mSocketIOClient.sync_close(this.classId);
  }
  public set_proxy_basic_auth(uri: string, username: string, password: string) {
    this.mSocketIOClient.set_proxy_basic_auth(uri, username, password, this.classId);
  }

  public opened(): boolean {
    return this.mSocketIOClient.opened(this.classId);
  }

  public get_sessionid(): string {
    return this.mSocketIOClient.get_sessionid(this.classId);
  }

  //socket相关接口
  public set_nsp(nsp: string) {
    this.mSocketIOClient.set_nsp(nsp, this.classId);
  }

  public on(event_name: string, on_event_listener: (event_json: string) => void) {
    const wrapper = (event_json: ESObject) => {
      try {
        console.log( '接收到on回调参数----on',  event_json);
        const params:ESObject  = JSON.parse(event_json)
        on_event_listener(JSON.stringify(params));
      } catch (e) {
        console.log( '接收到on回调参数----on',  event_json);
        const match: string = event_json.match(/"username"\s*:\s*"([^"]*)"/);
        on_event_listener(
          JSON.stringify({
            'eventName': event_name,
            'message': 'Transmission data parsing error',
            'username': match ? match[1] : null
          })
        );
      }
    };
    this.mSocketIOClient.on(event_name, wrapper, this.classId);
  }
  public on_multi(event_name: string, on_event_listener: (...args: ESObject[]) => void) {
    const wrapper = (event_json: ESObject) => {
      try {
        console.log( '接收到on回调参数----on_multi',  event_json);
        const params: ESObject[]  = JSON.parse(event_json)
        on_event_listener( ...params );
      } catch (e) {
        console.log( '接收到on回调参数----on_multi catch',  event_json);
        const match: string = event_json.match(/"username"\s*:\s*"([^"]*)"/);
        on_event_listener(
          JSON.stringify({
            'eventName': event_name,
            'message': 'Transmission data parsing error',
            'username': match ? match[1] : null
          })
        );
      }
    };
    this.mSocketIOClient.on_multi(event_name, wrapper, this.classId);
  }
  public on_binary(event_name: string, on_event_listener: (event_data: Uint8Array) => void) {
    this.mSocketIOClient.on_binary(event_name, on_event_listener, this.classId);
  }

  public once(event_name: string, on_event_listener: (event_json: string) => void) {
    this.mSocketIOClient.once(event_name, on_event_listener, this.classId);
  }

  public off(event_name: string) {
    this.mSocketIOClient.off(event_name, this.classId);
  }

  public off_all() {
    this.mSocketIOClient.off_all(this.classId);
  }

  public socket_close() {
    this.mSocketIOClient.socket_close(this.classId);
  }

  public on_error(on_error_listener: (message: string) => void) {
    this.mSocketIOClient.on_error(on_error_listener, this.classId);
  }

  public off_error() {
    this.mSocketIOClient.off_error(this.classId);
  }
  public emit(name: string, ...args:Array<SocketDataType | EmitCallbackType>) {
    try {
      const finalArgs: (ESObject | ((event_json: string) => void))[] = [];
      let callbackWrapper: EmitCallbackType | undefined;
      if (args.length > 0 && typeof args[args.length - 1] === 'function') {
        callbackWrapper = args[args.length - 1] as EmitCallbackType;
        finalArgs.push(...args.slice(0, -1));
      } else {
        finalArgs.push(...args);
      }
      const wrapper = (event_json: ESObject) => {
        try {
          console.log('接收到 ...wrapper， ... emit 回调参数:', event_json);
          const params: ESObject = JSON.parse(event_json as ESObject);
          callbackWrapper && callbackWrapper(JSON.stringify(params));
        } catch (e) {
          const match: string = event_json.match(/"username"\s*:\s*"([^"]*)"/);
          callbackWrapper && callbackWrapper(JSON.stringify({
            'eventName': name,
            'message': 'Transmission data parsing error',
            'username': match ? match[1] : null
          }));
        }
      };
      this.mSocketIOClient.emit(name, ...finalArgs, wrapper, this.classId);
    } catch (e) {
    }
  }

  public emitAckBinary(name: string, message: ESObject,
    on_emit_callback?: (code: number, emit_callback_data: Uint8Array) => void) {
    if (message instanceof Uint8Array) {
      this.mSocketIOClient.emitAckBinary(name, buffer_util.uint8ArrayToString(message), true, on_emit_callback,
        this.classId);
    } else {
      this.mSocketIOClient.emitAckBinary(name, message, false, on_emit_callback, this.classId);
    }
  }

  public get_current_state(): number {
    return this.mSocketIOClient.get_current_state(this.classId);
  }
}

