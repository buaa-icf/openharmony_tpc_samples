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

import prompt from '@ohos.promptAction';
import { client_socket } from '@ohos/socketio_2.x';
import { ConnState } from './Constants';
import { multiChatDetailDataA, multiChatDetailDataB } from './MultiChatDetailData';
import hilog from '@ohos.hilog';

// 单个客户端配置
class ClientConfig {
  public client: client_socket | null = null;
  public connect_finish: boolean = false;
  public login_finish: boolean = false;
  public username: string = "";
  public uri: string = "";
  public currentState: number = 0;
  public clientType: string = "";
  public headers: string = "";  // e.g. "{myKey1:myValue1,myKey2:myValue2}"
  public option: string = "";   // e.g. "{myKey:myValue}"
  public nsp: string = "";      // e.g. "/chat"

  constructor(clientType: string) {
    this.clientType = clientType;
  }
}

interface serverMessageInfo {
  username?: string;
  message: string;
  id: number;
  nsp?: string;
}

class MultiSocketManager {
  private clientA: ClientConfig;
  private clientB: ClientConfig;

  constructor() {
    this.clientA = new ClientConfig("A");
    this.clientA.uri = ""
    this.clientA.username = "A"; // 固定用户名为A
    // this.clientA.headers = "";
    // this.clientA.option = "";
    this.clientA.nsp = "/nsp_test";

    this.clientB = new ClientConfig("B");
    this.clientB.username = "B"; // 固定用户名为B
    this.clientB.uri = ""
    // this.clientB.headers = "";
    // this.clientB.option = "";
    // this.clientB.nsp = "";
  }

  // 规范化命名空间：空=>"/"；无前缀=>补"/"
  private normalizeNsp(nsp: string | undefined | null): string {
    const raw = (nsp ?? '').trim();
    if (raw.length === 0) return '/';
    return raw.startsWith('/') ? raw : ('/' + raw);
  }

  // 获取指定客户端配置
  private getClientConfig(clientType: 'A' | 'B'): ClientConfig {
    return clientType === 'A' ? this.clientA : this.clientB;
  }

  // 获取指定客户端的聊天数据管理器
  private getChatData(clientType: 'A' | 'B') {
    return clientType === 'A' ? multiChatDetailDataA : multiChatDetailDataB;
  }

  // 设置URI
  setUri(clientType: 'A' | 'B', uri: string) {
    const config = this.getClientConfig(clientType);
    config.uri = uri;
  }

  // 获取URI
  getUri(clientType: 'A' | 'B'): string {
    return this.getClientConfig(clientType).uri;
  }

  // 设置用户名
  setUsername(clientType: 'A' | 'B', username: string) {
    const config = this.getClientConfig(clientType);
    config.username = username;
  }

  // 获取用户名
  getUsername(clientType: 'A' | 'B'): string {
    return this.getClientConfig(clientType).username;
  }

  // 设置/获取 Headers（字符串形式）
  setHeaders(clientType: 'A' | 'B', headers: string) {
    const config = this.getClientConfig(clientType);
    config.headers = headers;
  }
  getHeaders(clientType: 'A' | 'B'): string {
    return this.getClientConfig(clientType).headers;
  }

  // 设置/获取 Option（字符串形式）
  setOption(clientType: 'A' | 'B', option: string) {
    const config = this.getClientConfig(clientType);
    config.option = option;
  }
  getOption(clientType: 'A' | 'B'): string {
    return this.getClientConfig(clientType).option;
  }

  // 设置/获取 命名空间 nsp
  setNsp(clientType: 'A' | 'B', nsp: string) {
    const config = this.getClientConfig(clientType);
    config.nsp = nsp;
  }
  getNsp(clientType: 'A' | 'B'): string {
    return this.getClientConfig(clientType).nsp;
  }

  // 获取连接状态
  getConnectFinish(clientType: 'A' | 'B'): boolean {
    return this.getClientConfig(clientType).connect_finish;
  }

  // 获取登录状态
  getLoginFinish(clientType: 'A' | 'B'): boolean {
    return this.getClientConfig(clientType).login_finish;
  }

  // 销毁指定客户端连接
  destroyClient(clientType: 'A' | 'B'): void {
    const config = this.getClientConfig(clientType);
    if (config.client) {
      config.client.close();
      config.client = null;
      config.connect_finish = false;
      config.login_finish = false;
    }
  }

  // 销毁所有客户端连接
  destroyAllClients(): void {
    this.destroyClient('A');
    this.destroyClient('B');
  }

  // 检查连接状态
  checkConnectionState(clientType: 'A' | 'B', func: string) {
    const config = this.getClientConfig(clientType);
    if (!config.client) {
      hilog.error(0x0000, 'testTag', '%{public}s', `Client${clientType}: no active connection`);
      return;
    }
    config.currentState = config.client?.get_current_state() ?? 0;
    hilog.info(0x0000, 'testTag', '%{public}s', 
      `Client${clientType} ${func} current connection state: ${ConnState[config.currentState]}`);
  }

  // 检查URL有效性
  checkUrl(uri: string): boolean {
    let isValid: boolean = false;
    if (uri.length == 0) {
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

  // 连接回调函数
  private on_open(clientType: 'A' | 'B'): void {
    const config = this.getClientConfig(clientType);
    hilog.info(0x0000, 'testTag', '%{public}s', `Client${clientType} on_open：连接服务器成功`);
    config.connect_finish = true;
    prompt.showToast({ message: `客户端${clientType}连接成功` });
    this.checkConnectionState(clientType, "on_open");
  }

  private on_fail(clientType: 'A' | 'B'): void {
    hilog.info(0x0000, 'testTag', '%{public}s', `Client${clientType} on_fail：连接服务器失败`);
    prompt.showToast({ message: `客户端${clientType}连接失败` });
    this.checkConnectionState(clientType, "on_fail");
  }

  private on_reconnecting(clientType: 'A' | 'B'): void {
    const config = this.getClientConfig(clientType);
    hilog.info(0x0000, 'testTag', '%{public}s', `Client${clientType} on_reconnecting`);
    this.checkConnectionState(clientType, "on_reconnecting");
    config.connect_finish = false;
  }

  private on_reconnect(clientType: 'A' | 'B'): void {
    const config = this.getClientConfig(clientType);
    hilog.info(0x0000, 'testTag', '%{public}s', `Client${clientType} on_reconnect`);
    this.checkConnectionState(clientType, "on_reconnect");
    config.connect_finish = false;
  }

  private on_close(clientType: 'A' | 'B', reason: string): void {
    const config = this.getClientConfig(clientType);
    config.connect_finish = false;
    hilog.info(0x0000, 'testTag', '%{public}s', `Client${clientType} on_close: ${reason}`);
    config.connect_finish = false;
  }

  private on_socket_open(clientType: 'A' | 'B', nsp: string): void {
    hilog.info(0x0000, 'testTag', '%{public}s', `Client${clientType} on_socket_open: ${nsp}`);
  }

  private on_socket_close(clientType: 'A' | 'B', nsp: string): void {
    hilog.info(0x0000, 'testTag', '%{public}s', `Client${clientType} on_socket_close: ${nsp}`);
    this.checkConnectionState(clientType, "on_socket_close");
  }

  // 消息监听回调
  private on_login_listener(clientType: 'A' | 'B', event_json: string): void {
    hilog.info(0x0000, 'testTag', '%{public}s', `Client${clientType} on_login_listener: ${event_json}`);
    const config = this.getClientConfig(clientType);
    config.login_finish = true;
    let loginCall: ESObject = JSON.parse(event_json);

    let notice =
      "Welcome to Socket.IO Chat,there " + (loginCall.numUsers != 1 ? " are " : "\'s ") + loginCall.numUsers +
        (loginCall.numUsers != 1 ? " participants" : " participant");
    let serviceMessage: serverMessageInfo = { message: notice, id: 0 };
    this.getChatData(clientType).pushData(serviceMessage);
  }

  // 携带命名空间的登录监听
  private on_login_listener_nsp(clientType: 'A' | 'B', nsp: string, event_json: string): void {
    hilog.info(0x0000, 'testTag', '%{public}s', `Client${clientType} on_login_listener[${nsp}]: ${event_json}`);
    const config = this.getClientConfig(clientType);
    config.login_finish = true;
    let loginCall: ESObject = JSON.parse(event_json);
    let notice =
      "Welcome to Socket.IO Chat,there " + (loginCall.numUsers != 1 ? " are " : "'s ") + loginCall.numUsers +
        (loginCall.numUsers != 1 ? " participants" : " participant");
    let serviceMessage: serverMessageInfo = { message: notice, id: 0, nsp: nsp };
    this.getChatData(clientType).pushData(serviceMessage);
  }

  private on_new_message_listener(clientType: 'A' | 'B', event_json: string): void {
    hilog.info(0x0000, 'testTag', '%{public}s', `Client${clientType} on_new_message_listener: ${event_json}`);
    let messageCall: ESObject = JSON.parse(event_json);
    let serviceMessage: serverMessageInfo = { username: messageCall.username, message: messageCall.message, id: 1 };
    this.getChatData(clientType).pushData(serviceMessage);
  }

  // 携带命名空间的消息监听
  private on_new_message_listener_nsp(clientType: 'A' | 'B', nsp: string, event_json: string): void {
    hilog.info(0x0000, 'testTag', '%{public}s', `Client${clientType} on_new_message_listener[${nsp}]: ${event_json}`);
    let messageCall: ESObject = JSON.parse(event_json);
    let serviceMessage: serverMessageInfo = { username: messageCall.username, message: messageCall.message, id: 1, nsp: nsp };
    this.getChatData(clientType).pushData(serviceMessage);
  }

  private on_user_joined_listener(clientType: 'A' | 'B', event_json: string): void {
    hilog.info(0x0000, 'testTag', '%{public}s', `Client${clientType} on_user_joined_listener: ${event_json}`);
    let userJoinCall: ESObject = JSON.parse(event_json);
    let notice = userJoinCall.username + " joined" + ",there" + (userJoinCall.numUsers != 1 ? " are " : "\'s ") +
    userJoinCall.numUsers + (userJoinCall.numUsers != 1 ? " participants" : " participant");
    let serviceMessage: serverMessageInfo = { message: notice, id: 0 };
    this.getChatData(clientType).pushData(serviceMessage);
  }

  private on_user_joined_listener_nsp(clientType: 'A' | 'B', nsp: string, event_json: string): void {
    hilog.info(0x0000, 'testTag', '%{public}s', `Client${clientType} on_user_joined_listener[${nsp}]: ${event_json}`);
    let userJoinCall: ESObject = JSON.parse(event_json);
    let notice = userJoinCall.username + " joined" + ",there" + (userJoinCall.numUsers != 1 ? " are " : "'s ") +
    userJoinCall.numUsers + (userJoinCall.numUsers != 1 ? " participants" : " participant");
    let serviceMessage: serverMessageInfo = { message: notice, id: 0, nsp: nsp };
    this.getChatData(clientType).pushData(serviceMessage);
  }

  private on_user_left_listener(clientType: 'A' | 'B', event_json: string): void {
    hilog.info(0x0000, 'testTag', '%{public}s', `Client${clientType} on_user_left_listener: ${event_json}`);
    let userLeftCall: ESObject = JSON.parse(event_json);
    let notice = userLeftCall.username + " left" + ",there" + (userLeftCall.numUsers != 1 ? " are " : "\'s ") +
    userLeftCall.numUsers + (userLeftCall.numUsers != 1 ? " participants" : " participant");
    let serviceMessage: serverMessageInfo = { message: notice, id: 0 };
    this.getChatData(clientType).pushData(serviceMessage);
  }

  private on_user_left_listener_nsp(clientType: 'A' | 'B', nsp: string, event_json: string): void {
    hilog.info(0x0000, 'testTag', '%{public}s', `Client${clientType} on_user_left_listener[${nsp}]: ${event_json}`);
    let userLeftCall: ESObject = JSON.parse(event_json);
    let notice = userLeftCall.username + " left" + ",there" + (userLeftCall.numUsers != 1 ? " are " : "'s ") +
    userLeftCall.numUsers + (userLeftCall.numUsers != 1 ? " participants" : " participant");
    let serviceMessage: serverMessageInfo  = { message: notice, id: 0, nsp: nsp };
    this.getChatData(clientType).pushData(serviceMessage);
  }

  private on_emit_callback(clientType: 'A' | 'B', emit_callback_json: string): void {
    hilog.info(0x0000, 'testTag', '%{public}s', `Client${clientType} on_emit_callback： ${emit_callback_json}`);
  }

  // 初始化客户端
  initClient(clientType: 'A' | 'B') {
    const config = this.getClientConfig(clientType);
    
    // 销毁当前连接
    this.destroyClient(clientType);
    config.client = new client_socket(config.uri);
    if (config.client) {
      hilog.info(0x0000, 'testTag', '%{public}s', `Client${clientType} instance created successfully`);
      this.configureClient(clientType);
      this.configureSocket(clientType);
    } else {
      hilog.error(0x0000, 'testTag', '%{public}s', `Client${clientType} instance creation failed`);
      return;
    }
  }

  // 配置客户端
  private configureClient(clientType: 'A' | 'B') {
    const config = this.getClientConfig(clientType);
    hilog.info(0x0000, 'testTag', '%{public}s', `Client${clientType} configureClient`);
    
    config.client?.set_open_listener(() => {
      this.on_open(clientType);
    });
    config.client?.set_fail_listener(() => {
      this.on_fail(clientType);
    });
    config.client?.set_reconnecting_listener(() => {
      this.on_reconnecting(clientType);
    });
    config.client?.set_reconnect_listener(() => {
      this.on_reconnect(clientType);
    });
    config.client?.set_close_listener((reason: string) => {
      this.on_close(clientType, reason);
    });
    config.client?.set_socket_open_listener((nsp: string) => {
      this.on_socket_open(clientType, nsp);
    });
    config.client?.set_socket_close_listener((nsp: string) => {
      this.on_socket_close(clientType, nsp);
    });
    if (config.headers && config.headers.trim().length > 0) {
      config.client?.set_headers(config.headers);
    }
    if (config.option && config.option.trim().length > 0) {
      config.client?.set_option(config.option);
    }
    if (config.nsp !== undefined && config.nsp !== null) {
      config.client?.set_nsp(config.nsp);
    }
    config.client?.connect(config.uri);
  }

  // 配置Socket
  private configureSocket(clientType: 'A' | 'B') {
    const config = this.getClientConfig(clientType);
    hilog.info(0x0000, 'testTag', '%{public}s', `Client${clientType} configureSocket`);

    // 在默认命名空间和配置命名空间都注册监听，以便按 nsp 分栏显示
    const nspRoot = '/';
    const nspCfg = this.normalizeNsp(config.nsp);

    const registerFor = (nsp: string) => {
      try {
        config.client?.set_nsp(nsp);
        config.client?.on("new message", (event_json: string) => {
          this.on_new_message_listener_nsp(clientType, nsp, event_json);
        });
        config.client?.on("user joined", (event_json: string) => {
          this.on_user_joined_listener_nsp(clientType, nsp, event_json);
        });
        config.client?.on("user left", (event_json: string) => {
          this.on_user_left_listener_nsp(clientType, nsp, event_json);
        });
        config.client?.on("login", (event_json: string) => {
          this.on_login_listener_nsp(clientType, nsp, event_json);
        });
        config.client?.on("disconnect", (data: string) => {
          hilog.info(0x0000, 'testTag', '%{public}s', `Client${clientType} disconnect[${nsp}]: ${data}`);
          this.checkConnectionState(clientType, "disconnect")
        });
        config.client?.on("ping_pong", (data: string) => {
          hilog.info(0x0000, 'testTag', '%{public}s', `Client${clientType} ping_pong[${nsp}]: ${data}`);
        });
      } catch (e) {
        hilog.error(0x0000, 'testTag', '%{public}s',
                    `Client${clientType} registerFor '${nsp}' failed: ${JSON.stringify(e)}`);
      }
    };

    registerFor(nspRoot);
    if (nspCfg !== nspRoot) {
      registerFor(nspCfg);
    }

    // 恢复当前命名空间为配置 nsp，和发送保持一致
    try {
      config.client?.set_nsp(nspCfg);
    } catch {}
  }

  // 连接单个客户端
  connect(clientType: 'A' | 'B') {
    const config = this.getClientConfig(clientType);
    if (!this.checkUrl(config.uri)) {
      console.error(`Client${clientType}服务器地址异常，请检查url信息。`);
      prompt.showToast({ message: `客户端${clientType}服务器地址异常` });
      return;
    }
    this.initClient(clientType);
  }

  // 同时连接两个客户端
  connectBoth() {
    if (!this.checkUrl(this.clientA.uri)) {
      prompt.showToast({ message: "客户端A服务器地址异常" });
      return;
    }
    if (!this.checkUrl(this.clientB.uri)) {
      prompt.showToast({ message: "客户端B服务器地址异常" });
      return;
    }
    
    // 同时连接两个客户端
    this.initClient('A');
    this.initClient('B');
  }

  // 登录
  login(clientType: 'A' | 'B', username: string) {
    const config = this.getClientConfig(clientType);
    hilog.info(0x0000, 'testTag', '%{public}s', `Client${clientType} login`);
    
    if (!config.connect_finish) {
      prompt.showToast({ message: `客户端${clientType}尚未连接到服务器` });
      return;
    }
    
    config.username = username;

    // 在默认命名空间"/"登录
    try {
      config.client?.set_nsp('/');
      config.client?.emit("add user", username);
    } catch (e) {
      hilog.error(0x0000, 'testTag', '%{public}s', `Client${clientType} login on '/' failed: ${JSON.stringify(e)}`);
    }

    // 如果配置了自定义 nsp，则在该 nsp 下也进行登录
    const cfgNsp = this.normalizeNsp(config.nsp);
    if (cfgNsp !== '/') {
      try {
        config.client?.set_nsp(cfgNsp);
        config.client?.emit("add user", username);
      } catch (e) {
        hilog.error(0x0000, 'testTag', '%{public}s', `Client${clientType} login on '${cfgNsp}' failed: ${JSON.stringify(e)}`);
      }
    }
    // 维持默认“当前”命名空间为配置的 nsp（若有），便于后续发送默认走配置 nsp
    try {
      config.client?.set_nsp(cfgNsp);
    } catch {}
    config.login_finish = true;
  }

  // 发送消息
  sendMessage(clientType: 'A' | 'B', message: string) {
    const config = this.getClientConfig(clientType);
    hilog.info(0x0000, 'testTag', '%{public}s', `Client${clientType} sendMessage`);
    
    if (!config.connect_finish) {
      hilog.error(0x0000, 'testTag', '%{public}s', `Client${clientType} not connected to the server yet`);
      return;
    }
    // 默认走配置的 nsp；未配置则走“/”
    const target = this.normalizeNsp(config.nsp);
    this.sendMessageInNsp(clientType, message, target);
  }

  // 在指定命名空间发送消息
  sendMessageInNsp(clientType: 'A' | 'B', message: string, nsp: string) {
    const config = this.getClientConfig(clientType);
    if (!config.connect_finish) {
      hilog.error(0x0000, 'testTag', '%{public}s', `Client${clientType} not connected to the server yet`);
      return;
    }
    const target = this.normalizeNsp(nsp);
    try {
      config.client?.set_nsp(target);
      config.client?.emit("new message", message, (emit_callback_json: string) => {
        this.on_emit_callback(clientType, emit_callback_json);
      });
    } catch (e) {
      hilog.error(0x0000, 'testTag', '%{public}s', `Client${clientType} sendMessageInNsp '${target}' failed: ${JSON.stringify(e)}`);
    }
  }

  // 关闭连接
  close(clientType: 'A' | 'B') {
    const config = this.getClientConfig(clientType);
    if (!config.connect_finish) {
      hilog.error(0x0000, 'testTag', '%{public}s', `Client${clientType} not connected to the server yet`);
      return;
    }
    hilog.info(0x0000, 'testTag', '%{public}s', `Client${clientType} close`);
    this.destroyClient(clientType);
    this.checkConnectionState(clientType, "close");
  }

  // 关闭所有连接
  closeAll() {
    if (this.clientA.connect_finish) {
      this.close('A');
    }
    if (this.clientB.connect_finish) {
      this.close('B');
    }
  }
}

export const multiSocketManager = new MultiSocketManager()