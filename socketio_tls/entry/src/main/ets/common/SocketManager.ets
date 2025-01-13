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
import { client_socket } from '@ohos/socketio_tls';
import { ConnState } from './Constants';
import { chatDetailData } from './ChatDetailData';

class SocketManager {
  private client: client_socket | null = null;
  private _connect_finish: boolean = false;
  public currentState: number = 0;
  public login_finish: boolean = false;
  public username: string = "";
  public uri: string = "";

  public set connect_finish(value: boolean) {
    this._connect_finish = value;
  }

  public get connect_finish(): boolean {
    return this._connect_finish;
  }

  setUri(uri: string) {
    this.uri = uri;
  }

  commonInit() {
    this.initClient();
    this.initSocket();
  }

  checkConnectionState(func:string) {
    this.currentState = this.client?.get_current_state() ?? 0;
    console.log(func + " 当前连接状态: " + ConnState[this.currentState]);
  }

  checkUrl(uri: string): boolean {
    let isValid: boolean = false;
    if (uri.length == 0) {
      console.error("服务器地址不能为空");
      isValid = false;
    }

    if (uri.startsWith("http://") || uri.startsWith("https://") || uri.startsWith("ws://") ||
    uri.startsWith("wss://")) {
      isValid = true;
    } else {
      isValid = false;
    }
    return isValid;
  }

  on_open(): void {
    console.log("SOCKET_IO_INDEX on_open：连接服务器成功");
    this.connect_finish = true;
    prompt.showToast({ message: getContext().resourceManager.getStringSync($r('app.string.connect_success')) });
    this.checkConnectionState("on_open");
  }

  on_fail(): void {
    console.log("SOCKET_IO_INDEX on_fail：连接服务器失败");
    prompt.showToast({ message: getContext().resourceManager.getStringSync($r('app.string.connect_failed')) });
    this.checkConnectionState("on_fail");
  }

  on_reconnecting(): void {
    console.log("SOCKET_IO_INDEX on_reconnecting");
    this.checkConnectionState("on_reconnecting");
  }

  on_reconnect(): void {
    console.log("SOCKET_IO_INDEX on_reconnect");
    this.checkConnectionState("on_reconnect");
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
    this.checkConnectionState("on_socket_close");
  }

  on_login_listener(event_json: string): void {
    console.log("SOCKET_IO_INDEX on_login_listener: " + event_json);
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


  //配置client
  initClient() {
    console.log("SOCKET_IO_INDEX initClient");
    this.client = new client_socket();
    this.client?.set_open_listener(() => {
      this.on_open();
    });
    this.client?.set_fail_listener(() => {
      this.on_fail();
    });
    this.client?.set_reconnecting_listener(() => {
      this.on_reconnecting();
    });
    this.client?.set_reconnect_listener(() => {
      this.on_reconnect();
    });
    this.client?.set_close_listener((reason: string) => {
      this.on_close(reason);
    });
    this.client?.set_socket_open_listener((nsp: string) => {
      this.on_socket_open(nsp);
    });
    this.client?.set_socket_close_listener((nsp: string) => {
      this.on_socket_close(nsp);
    });
    this.client?.set_headers("{myKey1:myValue1,myKey2:myValue2}");
    this.client?.set_option("{myKey:myValue}");
    this.client?.connect(this.uri);
  }

  //配置socket
  initSocket() {
    console.log("SOCKET_IO_INDEX initSocket");
    this.client?.on("new message", (event_json: string) => {
      this.on_new_message_listener(event_json);
    });
    this.client?.on("user joined", (event_json: string) => {
      this.on_user_joined_listener(event_json);
    });
    this.client?.on("user left", (event_json: string) => {
      this.on_user_left_listener(event_json);
    });
    this.client?.on("login", (event_json: string) => {
      this.on_login_listener(event_json);
    });
    this.client?.on("disconnect", (data: string) => {
      console.log("disconnect:", data);
      this.checkConnectionState("disconnect")
    });
    this.client?.on("ping_pong", (data: string) => {
      console.log("ping_pong:", data);
    });
  }

  //登录
  login(username: string) {
    console.log("SOCKET_IO_INDEX login");
    if (!this.connect_finish) {
      prompt.showToast({ message: getContext().resourceManager.getStringSync($r('app.string.connect_unfinished')) });
      return;
    }
    this.username = username;
    this.client?.emit("add user", username);
    this.login_finish = true;
  }

  //发送消息
  sendMessage(message: string) {
    console.log("SOCKET_IO_INDEX sendMessage");
    if (!this.connect_finish) {
      console.log("SOCKET_IO_INDEX 暂未连接服务器");
      return;
    }
    this.client?.emit("new message", message, this.on_emit_callback);
  }

  //退出连接
  close() {
    console.log("SOCKET_IO_INDEX close");
    if (!this.connect_finish) {
      console.log("SOCKET_IO_INDEX 暂未连接服务器");
      return;
    }
    if(this.client)
    {
      this.client.close();
      this.checkConnectionState("close");
      this.client = null;
    }
    this._connect_finish = false;
    this.login_finish = false;
  }
}

export const socketManager = new SocketManager()