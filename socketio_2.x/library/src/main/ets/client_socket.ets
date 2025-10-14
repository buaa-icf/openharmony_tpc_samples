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
import { buffer_util } from './buffer_util'

export type SocketMessage = number | string | boolean | Array<number>
    | Array<string> | Array<boolean> | Uint8Array | object | bigint;


export class client_socket {
  private mSocketIOClient: newSocketIOClient;
  private classId = 0;

  constructor(uri: string) {
    this.mSocketIOClient = new newSocketIOClient();
    this.classId = this.mSocketIOClient.classId;
    console.log("LibSocketIOClient constructor classId:" + this.classId);
    this.mSocketIOClient.set_connection_mode(uri, this.classId);
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
    this.mSocketIOClient.set_socket_close_listener(on_socket_close,this.classId);
  }

  public set_headers(headers: string) {
    this.mSocketIOClient.set_headers(headers, this.classId);
  }

  public set_option(opt: string) {
    this.mSocketIOClient.set_option(opt, this.classId);
  }

  public set_path(path: string) {
    this.mSocketIOClient.set_path(path, this.classId);
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
    this.mSocketIOClient.set_reconnect_delay_max(millis,this.classId);
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
    this.mSocketIOClient.set_proxy_basic_auth(uri, username, password,this.classId);
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
    this.mSocketIOClient.on(event_name, on_event_listener, this.classId);
  }

  public once(event_name: string, on_event_listener: (event_json: string) => void) {
    this.mSocketIOClient.once(event_name, on_event_listener, this.classId);
  }

  public on_binary(event_name: string, on_event_listener: (event_data: Uint8Array) => void) {
    this.mSocketIOClient.on_binary(event_name, on_event_listener, this.classId);
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

  public emit(name: string, message: SocketMessage, on_emit_callback?: (emit_callback_json: string) => void) {
    this.mSocketIOClient.emit(name, message, on_emit_callback, this.classId);
  }

  public get_current_state(): number {
    return this.mSocketIOClient.get_current_state(this.classId);
  }
}
