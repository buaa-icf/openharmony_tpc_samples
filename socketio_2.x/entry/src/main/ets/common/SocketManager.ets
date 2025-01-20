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
import { client_socket } from '@ohos/socketio_2.x';
import { ConnState } from './Constants';
import { chatDetailData } from './ChatDetailData';
import hilog from '@ohos.hilog';

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

  destroyCurrentClient(): void {
    if (this.client) {
      this.client.close();
      this.client = null;
      this._connect_finish = false;
      this.login_finish = false;
    }
  }
  commonInit() {
    // 销毁当前连接
    this.destroyCurrentClient();
    // 创建新连接
    this.client = new client_socket(this.uri);
    if(this.client) {
      hilog.info(0x0000, 'testTag', '%{public}s', 'client instance created successfully');
      this.initClient();
      this.initSocket();
    } else {
      hilog.error(0x0000, 'testTag', '%{public}s', 'client instance creation failed');
      return;
    }
  }

  checkConnectionState(func:string) {
    if (!this.client) {
      hilog.info(0x0000, 'testTag', '%{public}s', func + " no active connection");
      return;
    }
    this.currentState = this.client?.get_current_state() ?? 0;
    hilog.info(0x0000, 'testTag', '%{public}s', func + " current connection state: " + ConnState[this.currentState]);
  }

  checkUrl(uri: string): boolean {
    let isValid: boolean = false;
    if (uri.length === 0) {
      hilog.error(0x0000, 'testTag', '%{public}s', "uri is empty");
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
    hilog.info(0x0000, 'testTag', '%{public}s', "SOCKET_IO_INDEX on_open：user connected");
    this.connect_finish = true;
    prompt.showToast({ message: "连接服务器成功" });
    this.checkConnectionState("on_open");
  }

  on_fail(): void {
    hilog.info(0x0000, 'testTag', '%{public}s', "SOCKET_IO_INDEX on_fail：connection failed");
    prompt.showToast({ message: "连接服务器失败" });
    this.checkConnectionState("on_fail");
  }

  on_reconnecting(): void {
    hilog.info(0x0000, 'testTag', '%{public}s', "SOCKET_IO_INDEX on_reconnecting");
    this.checkConnectionState("on_reconnecting");
  }

  on_reconnect(): void {
    hilog.info(0x0000, 'testTag', '%{public}s', "SOCKET_IO_INDEX on_reconnect");
    this.checkConnectionState("on_reconnect");
  }

  on_close(reason: string): void {
    this.connect_finish = false;
    hilog.info(0x0000, 'testTag', '%{public}s', "%{public}s", "SOCKET_IO_INDEX on_close, reason: " + reason);
  }

  on_socket_open(nsp: string): void {
    hilog.info(0x0000, 'testTag', '%{public}s', "SOCKET_IO_INDEX on_socket_open: " + nsp);
  }

  on_socket_close(nsp: string): void {
    hilog.info(0x0000, 'testTag', '%{public}s', "SOCKET_IO_INDEX on_socket_close: " + nsp);
    this.checkConnectionState("on_socket_close");
  }

  on_login_listener(event_json: string): void {
    hilog.info(0x0000, 'testTag', '%{public}s', "SOCKET_IO_INDEX on_login_listener: " + event_json);
    let loginCall: ESObject = JSON.parse(event_json);

    let notice =
      "Welcome to Socket.IO Chat,there " + (loginCall.numUsers != 1 ? " are " : "\'s ") + loginCall.numUsers +
        (loginCall.numUsers != 1 ? " participants" : " participant");
    let serviceMessage: ESObject = { message: notice, id: 0 };
    chatDetailData.pushData(serviceMessage);
  }

  on_new_message_listener(event_json: string): void {
    hilog.info(0x0000, 'testTag', '%{public}s', "SOCKET_IO_INDEX on_new_message_listener: " + event_json);
    let messageCall: ESObject = JSON.parse(event_json);
    let serviceMessage: ESObject = { username: messageCall.username, message: messageCall.message, id: 1 };
    chatDetailData.pushData(serviceMessage);
  }

  on_user_joined_listener(event_json: string): void {
    hilog.info(0x0000, 'testTag', '%{public}s', "SOCKET_IO_INDEX on_user_joined_listener: " + event_json);
    let userJoinCall: ESObject = JSON.parse(event_json);
    let notice = userJoinCall.username + " joined" + ",there" + (userJoinCall.numUsers != 1 ? " are " : "\'s ") +
    userJoinCall.numUsers + (userJoinCall.numUsers != 1 ? " participants" : " participant");
    let serviceMessage: ESObject = { message: notice, id: 0 };
    chatDetailData.pushData(serviceMessage);
  }

  on_user_left_listener(event_json: string): void {
    hilog.info(0x0000, 'testTag', '%{public}s', "SOCKET_IO_INDEX on_user_left_listener: " + event_json);
    let userLeftCall: ESObject = JSON.parse(event_json);
    let notice = userLeftCall.username + " left" + ",there" + (userLeftCall.numUsers != 1 ? "are " : "\'s ") +
    userLeftCall.numUsers + (userLeftCall.numUsers != 1 ? " participants" : " participant");
    let serviceMessage: ESObject = { message: notice, id: 0 };
    chatDetailData.pushData(serviceMessage);
  }

  on_emit_callback(emit_callback_json: string): void {
    hilog.info(0x0000, 'testTag', '%{public}s', "SOCKET_IO_INDEX on_emit_callback: " + emit_callback_json);
  }

  //配置client
  initClient() {
    hilog.info(0x0000, 'testTag', '%{public}s', "SOCKET_IO_INDEX initClient");

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

    // set_path接口的参数支持：xxx, /xxx, xxx/, /xxx/四种写法。(该接口暂时注释，若要使用需要服务端适配)
    // this.client?.set_path("/chat");

    // (该接口暂时注释，若要使用需要服务端适配)
    // this.client?.set_nsp("/nsp");

    this.client?.connect(this.uri);
  }

  //配置socket
  initSocket() {
    hilog.info(0x0000, 'testTag', '%{public}s', "SOCKET_IO_INDEX initSocket");

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
      hilog.info(0x0000, 'testTag', '%{public}s', "disconnect: " + data);
      this.checkConnectionState("disconnect")
    });
    this.client?.on("ping_pong", (data: string) => {
      hilog.info(0x0000, 'testTag', '%{public}s', "ping_pong: " + data);
    });
  }

  //登录
  login(username: string) {
    hilog.info(0x0000, 'testTag', '%{public}s', "SOCKET_IO_INDEX login");
    if (!this.connect_finish) {
      prompt.showToast({ message: "暂未连接服务器" });
      return;
    }
    this.username = username;
    this.client?.emit("add user", username);
    this.login_finish = true;
  }

  //发送消息
  sendMessage(message: string) {
    hilog.info(0x0000, 'testTag', '%{public}s', "SOCKET_IO_INDEX sendMessage");
    if (!this.connect_finish) {
      hilog.info(0x0000, 'testTag', '%{public}s', "SOCKET_IO_INDEX 暂未连接服务器");
      return;
    }
    this.client?.emit("new message", message, this.on_emit_callback);
  }

  //退出连接
  close() {
    hilog.info(0x0000, 'testTag', '%{public}s', "SOCKET_IO_INDEX close");
    if (!this.connect_finish) {
      hilog.info(0x0000, 'testTag', '%{public}s', "SOCKET_IO_INDEX 暂未连接服务器");
      return;
    }
    this.destroyCurrentClient();
    this.checkConnectionState("close");
  }
}
export const socketManager = new SocketManager()