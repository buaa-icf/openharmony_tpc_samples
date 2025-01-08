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

import prompt from '@ohos.promptAction';
import { client_socket } from '@ohos/socketio';
import { ConnState } from './Constants';
import { chatDetailData } from './ChatDetailData';

class SocketManager {
  private client: client_socket | null = null;
  private _connect_finish: boolean = false;
  public currentState: number = 0;
  public login_finish: boolean = false;
  public username: string = "";
  public uri:string = "";

  public set connect_finish(value: boolean) {
    this._connect_finish = value;
  }

  public get connect_finish(): boolean {
    return this._connect_finish;
  }

  setUri(uri:string) {
    this.uri = uri;
  }

  commonInit() {
    this.initClient()
    this.initSocket()
  }

  checkConnectionState(func:string) {
    this.currentState = this.client?.get_current_state() ?? 0;
    console.log(func + " 当前连接状态: " + ConnState[this.currentState]);
  }

  on_open(): void {
    console.log("SOCKET_IO_INDEX on_open");
    this.connect_finish = true;
    prompt.showToast({ message: $r("app.string.Successfully") });
    this.checkConnectionState("on_open")
  }

  on_fail(): void {
    console.log("SOCKET_IO_INDEX on_fail");
    prompt.showToast({ message: $r("app.string.Failed") });
    this.checkConnectionState("on_fail")
  }

  on_reconnecting(): void {
    console.log("SOCKET_IO_INDEX on_reconnecting");
    this.checkConnectionState("on_reconnecting")
  }

  on_reconnect(): void {
    console.log("SOCKET_IO_INDEX on_reconnect");
    this.checkConnectionState("on_reconnect")
  }

  on_close(reason: string): void {
    this.connect_finish = false;
    console.log("SOCKET_IO_INDEX on_close: " + reason);
  }

  on_socket_open(nsp: string): void {
    console.log("SOCKET_IO_INDEX on_socket_open: " + nsp);
  }

  on_socket_close(nsp: string): void {
    console.log("SOCKET_IO_INDEX on_socket_close: " + nsp);
    this.checkConnectionState("on_socket_close")
  }

  on_login_listener(event_json: string): void {
    let loginCall: ESObject = JSON.parse(event_json);
    let notice =
      "Welcome to Socket.IO Chat,there " + (loginCall.numUsers != 1 ? " are " : "\'s ") + loginCall.numUsers +
        (loginCall.numUsers != 1 ? " participants" : " participant");
    let serviceMessage: ESObject = { message: notice, id: 0 };
    chatDetailData.pushData(serviceMessage);
  }

  on_new_message_listener(event_json: string): void {
    console.log("SOCKET_IO_INDEX on_new_message_listener: " + event_json);
    let messageCall: ESObject = JSON.parse(event_json);
    let serviceMessage: ESObject = { username: messageCall.username, message: messageCall.message, id: 1 };
    chatDetailData.pushData(serviceMessage);
  }

  on_user_joined_listener(event_json: string): void {
    console.log("SOCKET_IO_INDEX on_user_joined_listener: " + event_json);
    let userJoinCall: ESObject = JSON.parse(event_json);
    let notice = userJoinCall.username + " joined" + ",there" + (userJoinCall.numUsers != 1 ? " are " : "\'s ") +
    userJoinCall.numUsers + (userJoinCall.numUsers != 1 ? " participants" : " participant");
    let serviceMessage: ESObject = { message: notice, id: 0 };
    chatDetailData.pushData(serviceMessage);
  }

  on_user_left_listener(event_json: string): void {
    console.log("SOCKET_IO_INDEX on_user_left_listener: " + event_json);
    let userLeftCall: ESObject = JSON.parse(event_json);
    let notice = userLeftCall.username + " left" + ",there" + (userLeftCall.numUsers != 1 ? "are " : "\'s ") +
    userLeftCall.numUsers + (userLeftCall.numUsers != 1 ? " participants" : " participant");
    let serviceMessage: ESObject = { message: notice, id: 0 };
    chatDetailData.pushData(serviceMessage);
  }

  on_emit_callback(emit_callback_json: string): void {
    console.log("SOCKET_IO_INDEX on_emit_callback： " + emit_callback_json);
  }

  private initClient() {
    console.log("SOCKET_IO_INDEX initClient");

    // 创建新的客户端实例
    this.client = new client_socket();

    this.client.set_open_listener(() => {
      this.on_open();
    });
    this.client.set_fail_listener(() => {
      this.on_fail();
    });
    this.client.set_reconnecting_listener(() => {
      this.on_reconnecting();
    });
    this.client.set_reconnect_listener(() => {
      this.on_reconnect();
    });
    this.client.set_close_listener((reason: string) => {
      this.on_close(reason);
    });
    this.client.set_socket_open_listener((nsp: string) => {
      this.on_socket_open(nsp);
    });
    this.client.set_socket_close_listener((nsp: string) => {
      this.on_socket_close(nsp);
    });
    this.client.connect(this.uri);
  }

  //配置socket
  private initSocket() {
    console.log("SOCKET_IO_INDEX initSocket");
    this.client?.on("new message", (event_json: string)=>{
      this.on_new_message_listener(event_json);
    });
    this.client?.on("user joined", (event_json: string)=>{
      this.on_user_joined_listener(event_json);
    });
    this.client?.on("user left", (event_json: string)=>{
      this.on_user_left_listener(event_json);
    });
    this.client?.on("login", (event_json: string)=>{
      this.on_login_listener(event_json);
    });
    this.client?.on("disconnect", (data) => {
      console.log("断连:",data);
      this.checkConnectionState("disconnect")
    });
    this.client?.on("ping_pong", (data) => {
      console.log("心跳:",data);
    });
  }

  //登录
  login(username: string) {
    console.log("SOCKET_IO_INDEX login");
    if (!this.connect_finish) {
      prompt.showToast({ message: "暂未连接服务器" });
      return;
    }
    this.username = username;
    this.client?.emit("add user", username);
    this.login_finish = true;
  }

  close() {
    if (!this._connect_finish) {
      console.log("SOCKET_IO_INDEX 暂未连接服务器");
      return;
    }

    // 安全地关闭客户端
    if (this.client) {
      this.client.close(); // 异步关闭
      this.checkConnectionState("close")
      this.client = null; // 关闭引用
    }
    this._connect_finish = false;
    this.login_finish = false;
  }

  getResourceString(resourceName:Resource) {
    return getContext().resourceManager.getStringSync(resourceName.id)
  }

  //发送消息
  sendMessage(message: string) {
    console.log("SOCKET_IO_INDEX sendMessage");
    if (!this.connect_finish) {
      console.log(`SOCKET_IO_INDEX ${this.getResourceString($r("app.string.Connected_server"))}`);
      return;
    }
    this.client?.emit("new message", message, this.on_emit_callback);
  }
}

export const socketManager = new SocketManager()