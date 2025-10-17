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
/**
 * Copyright (C) 2023-2025 Huawei Device Co., Ltd.
 *
 * Socket 管理器 - 重构版
 * 支持内存安全、事件解绑、防重连、状态管理
 */
import prompt from '@ohos.promptAction';
import { client_socket } from '@ohos/socketio';
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
  };

  public get connect_finish(): boolean {
    return this._connect_finish;
  };

  setUri(uri:string) {
    this.uri = uri;
  };

  destroyCurrentClient(): void {
    if (this.client) {
      this.client.close();
      this.client = null;
      this._connect_finish = false;
      this.login_finish = false;
    };
  };
  // 2. 关闭连接
  destroySyncCurrentClient(): void {
    if (this.client) {
      this.client.sync_close();
      this.client = null;
      this._connect_finish = false;
      this.login_finish = false;
    };
  };
  commonInit() {
    // 销毁当前连接
    this.destroySyncCurrentClient();
    // 创建新连接
    this.client = new client_socket();
    if(this.client) {
      hilog.info(0x0000, 'testTag', '%{public}s', 'client instance created successfully');
      this.initClient();
      this.initSocket();
    } else {
      hilog.error(0x0000, 'testTag', '%{public}s', 'client instance creation failed');
      return;
    };
  };

  checkConnectionState(func:string) {
    if (!this.client) {
      hilog.info(0x0000, 'testTag', '%{public}s', 'no active connection');
      return;
    }
    this.currentState = this.client?.get_current_state() ?? 0;
    hilog.info(0x0000, 'testTag', '%{public}s', func + ' current connection state: ' + ConnState[this.currentState]);
  };

  on_open(): void {
    hilog.info(0x0000, 'testTag', '%{public}s', 'SOCKET_IO_INDEX on_open：连接服务器成功');
    this.connect_finish = true;
    prompt.showToast({ message: $r("app.string.Successfully") });
    this.checkConnectionState("on_open")
  };

  on_fail(): void {
    hilog.info(0x0000, 'testTag', '%{public}s', 'SOCKET_IO_INDEX on_fail');
    prompt.showToast({ message: $r("app.string.Failed") });
    this.checkConnectionState("on_fail")
  };

  on_reconnecting(): void {
    hilog.info(0x0000, 'testTag', '%{public}s', 'SOCKET_IO_INDEX on_reconnecting');
    this.checkConnectionState("on_reconnecting")
  };

  on_reconnect(): void {
    hilog.info(0x0000, 'testTag', '%{public}s', 'SOCKET_IO_INDEX on_reconnect');
    this.checkConnectionState("on_reconnect")
  };

  on_close(reason: string): void {
    this.connect_finish = false;
    hilog.info(0x0000, 'testTag', '%{public}s', 'SOCKET_IO_INDEX on_close: ' + reason);
  };

  on_socket_open(nsp: string): void {
    hilog.info(0x0000, 'testTag', '%{public}s', 'SOCKET_IO_INDEX on_socket_open: ' + nsp);
  };

  on_socket_close(nsp: string): void {
    hilog.info(0x0000, 'testTag', '%{public}s', 'SOCKET_IO_INDEX on_socket_close: ' + nsp);
    this.checkConnectionState("on_socket_close")
  };

  on_login_listener(event_json: string): void {
    hilog.info(0x0000, 'testTag', '%{public}s', 'SOCKET_IO_INDEX on_login_listener: ' + event_json);
    let loginCall: ESObject = JSON.parse(event_json);
    let notice =
      "Welcome to Socket.IO Chat,there " + (loginCall.numUsers != 1 ? " are " : "\'s ") + loginCall.numUsers +
        (loginCall.numUsers != 1 ? " participants" : " participant");
    let serviceMessage: ESObject = { message: notice, id: 0 };
    chatDetailData.pushData(serviceMessage);
  };

  on_new_message_listener(event_json: string): void {
    hilog.info(0x0000, 'testTag', '%{public}s', 'SOCKET_IO_INDEX on_new_message_listener: ' + event_json);
    let messageCall: ESObject = JSON.parse(event_json);
    let serviceMessage: ESObject = { username: messageCall.username, message: messageCall.message, id: 1 };
    chatDetailData.pushData(serviceMessage);
  };

  on_user_joined_listener(event_json: string): void {
    hilog.info(0x0000, 'testTag', '%{public}s', 'SOCKET_IO_INDEX on_user_joined_listener: ' + event_json);
    let userJoinCall: ESObject = JSON.parse(event_json);
    let notice = userJoinCall.username + " joined" + ",there" + (userJoinCall.numUsers != 1 ? " are " : "\'s ") +
    userJoinCall.numUsers + (userJoinCall.numUsers != 1 ? " participants" : " participant");
    prompt.showToast({ message: userJoinCall.username + '进入链接' });
    let serviceMessage: ESObject = { message: notice, id: 0 };
    chatDetailData.pushData(serviceMessage);
  };

  on_user_left_listener(event_json: string): void {
    hilog.info(0x0000, 'testTag', '%{public}s', 'SOCKET_IO_INDEX on_user_left_listener: ' + event_json);
    let userLeftCall: ESObject = JSON.parse(event_json);
    let notice = userLeftCall.username + " left" + ",there" + (userLeftCall.numUsers != 1 ? "are " : "\'s ") +
    userLeftCall.numUsers + (userLeftCall.numUsers != 1 ? " participants" : " participant");
    prompt.showToast({ message:userLeftCall.username + '断开链接' });
    let serviceMessage: ESObject = { message: notice, id: 0 };
    chatDetailData.pushData(serviceMessage);
  };

  on_emit_callback(emit_callback_json: string): void {
    hilog.info(0x0000, 'testTag', '%{public}s', 'SOCKET_IO_INDEX on_emit_callback：' + emit_callback_json);
  };

  private initClient() {
    hilog.info(0x0000, 'testTag', '%{public}s', 'SOCKET_IO_INDEX initClient');

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
    this.client?.connect(this.uri);

    // 通过set_option设置服务器重连功能：开启自动重连，重连尝试次数：5，// 初始重连延迟1000（毫秒），// 最大重连延迟5000（毫秒）
    this.client?.set_option('{reconnection: true, reconnectionAttempts: 5, reconnectionDelay: 1000, reconnectionDelayMax: 5000}');
  };

  //配置socket
  private initSocket() {
    hilog.info(0x0000, 'testTag', '%{public}s', 'SOCKET_IO_INDEX initSocket');
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
    this.client?.on("disconnect", (data: string) => {
      hilog.info(0x0000, 'testTag', '%{public}s', 'SOCKET_IO_INDEX disconnect: ' + data);
      this.checkConnectionState("disconnect");
    });
    // 注册一个二进制事件监听器 例如监听二进制消息（比如服务器推送的文件流），并处理接收到的数据
    this.client?.on_binary('on binary', (data: ArrayBuffer) => {
      hilog.info(0x0000, 'testTag', `收到二进制数据，大小: ${data.byteLength} 字节`);
    });
    // 使用 once：只响应第一次 'welcome' 消息
    this.client?.once('welcome', (data: string) => {
      hilog.info(0x0000, 'testTag', '%{public}s', `${data}`);
    });
  };

  //登录
  login(username: string) {
    hilog.info(0x0000, 'testTag', '%{public}s', 'SOCKET_IO_INDEX login');
    if (!this.connect_finish) {
      prompt.showToast({ message: "暂未连接服务器" });
      return;
    };
    let notice = username + " joined" ;
    prompt.showToast({ message: username + '进入链接' });
    this.username = username;
    this.client?.emit("add user", username);
    this.login_finish = true;
    let serviceMessage: ESObject = { message: notice, id: 0 };
    chatDetailData.pushData(serviceMessage);
  };

  close() {
    if (!this._connect_finish) {
      hilog.info(0x0000, 'testTag', '%{public}s', 'SOCKET_IO_INDEX 暂未连接服务器');
      return;
    };
    hilog.info(0x0000, 'testTag', '%{public}s', 'SOCKET_IO_INDEX close');
    this.destroyCurrentClient();
    this.checkConnectionState("close");
  };

  // set_nsp 设置命名空间
  setNsp(nsp:string) {
    if (!this.connect_finish) {
      hilog.info(0x0000, 'testTag', '%{public}s', 'SOCKET_IO_INDEX 暂未连接服务器');
      return;
    };
    this.client?.set_nsp(nsp);
  };

  // 设置其头部信息
  setHeaders(headers:string) {
    if (!this.connect_finish) {
      hilog.info(0x0000, 'testTag', '%{public}s', 'SOCKET_IO_INDEX 暂未连接服务器');
      return;
    };
    this.client?.set_headers(headers);
  };
  // 关闭一个由 classId 标识的 Socket.IO 客户端连接
  socketClose() {
    if (!this.connect_finish) {
      hilog.info(0x0000, 'testTag', '%{public}s', 'SOCKET_IO_INDEX 暂未连接服务器');
      return;
    };
    this.client?.socket_close();
  };
  getResourceString(resourceName:Resource) {
    return getContext().resourceManager.getStringSync(resourceName.id);
  };
  //发送消息
  sendEmitAckBinaryMessage(message: ESObject) {
    hilog.info(0x0000, 'testTag', '%{public}s', 'SOCKET_IO_INDEX sendMessage');
    if (!this.connect_finish) {
      hilog.info(0x0000, 'testTag', '%{public}s', 'SOCKET_IO_INDEX 暂未连接服务器');
      return;
    };
    this.client?.emitAckBinary("new message", message);
  };
  //发送消息
  sendMessage(message: ESObject) {
    hilog.info(0x0000, 'testTag', '%{public}s', 'SOCKET_IO_INDEX sendMessage');
    if (!this.connect_finish) {
      hilog.info(0x0000, 'testTag', '%{public}s', 'SOCKET_IO_INDEX 暂未连接服务器');
      return;
    };
    this.client?.emit("new message", message, this.on_emit_callback);
  };
  // - 处理buffer数据导致应用崩溃。
  // - 支持八种数据类型传输（整数、浮点数、二进制、字符串、数组、对象、布尔值、空）
  // 发送字符串
  sendStringMessage(message: ESObject) {
    if (!this.connect_finish) {
      hilog.info(0x0000, 'testTag', '%{public}s', 'SOCKET_IO_INDEX 暂未连接服务器');
      return;
    };
    this.client?.emit("new message string", message, this.on_emit_callback_string);
  };
  private on_emit_callback_string(emit_callback_json: string): void {
    hilog.info(0x0000, 'testTag', '%{public}s', '[on_emit_callback_string] ' + emit_callback_json);
    try {
      const params:ESObject = JSON.parse(emit_callback_json);
      prompt.showToast({ message:`这是一个${typeof  params.message}数据: ${params.message}`, duration:2000 });
    } catch (e) {
      this.client?.emit("error", '数据转化错误');
    };
  };
  // 发送 null
  sendNullMessage(message: ESObject) {
    if (!this.connect_finish) {
      hilog.info(0x0000, 'testTag', '%{public}s', 'SOCKET_IO_INDEX 暂未连接服务器');
      return;
    };
    this.client?.emit("new message null", JSON.stringify(message), this.on_emit_callback_null);
  };
  private on_emit_callback_null(emit_callback_json: string): void {
    hilog.info(0x0000, 'testTag', '%{public}s', '[SOCKET_IO_INDEX] ' + emit_callback_json);
    try {
      const params:ESObject = JSON.parse(emit_callback_json);
      const is = params.message === null;
      prompt.showToast({ message:`这是一个${is ? 'null': '其他'}数据: ${params.message}`, duration:2000 });
    } catch (e) {
      this.client?.emit("error message", '数据转化错误');
    };
  };
  // 发送整数 / 发送浮点数
  sendNumberMessage(message: ESObject) {
    if (!this.connect_finish) {
      hilog.info(0x0000, 'testTag', '%{public}s', 'SOCKET_IO_INDEX 暂未连接服务器');
      return;
    };
    // 把数据转化成number
    const num = Number(message)
    if (typeof num === 'number' && !Number.isNaN(num)) {
      this.client?.emit("new message number", message, this.on_emit_callback_number);
      return;
    };
    prompt.showToast({ message:'这不是一个数值类型', duration:2000 });
  };
  private on_emit_callback_number(emit_callback_json: string): void {
    hilog.info(0x0000, 'testTag', '%{public}s', '[SOCKET_IO_INDEX] ' + emit_callback_json);
    try {
      const params:ESObject = JSON.parse(emit_callback_json);
      const  is = typeof  params.message === 'number';
      if (is) {
        const  isFinite =  Number.isFinite(params.message) && !Number.isInteger(params.message);
        hilog.info(0x0000, 'testTag', '%{public}s', '[SOCKET_IO_INDEX] ' + Number.isFinite(params) + !Number.isInteger(params));
        if (isFinite) {
          prompt.showToast({ message:`这是一个浮点数: ${Number(params.message)}`, duration:2000 });
        }else {
          prompt.showToast({ message:`这是一个${typeof  params.message}数据: ${Number(params.message)}`, duration:2000 });
        }
      }else{
        prompt.showToast({ message:'这不是一个数值类型', duration:2000 });
      };
    } catch (e) {
      this.client?.emit("error message", '数据转化错误');
    };
  };
  // 发送buff
  sendBufferMessage(message: ESObject) {
    if (!this.connect_finish) {
      hilog.info(0x0000, 'testTag', '%{public}s', 'SOCKET_IO_INDEX 暂未连接服务器');
      return;
    };
    this.client?.emit("new message buffer", message , this.on_emit_callback_buffer);
  };

  private on_emit_callback_buffer(emit_callback_json: string): void {
    hilog.info(0x0000, 'testTag', '%{public}s', '[SOCKET_IO_INDEX] ' + emit_callback_json);
    try {
      const params:ESObject = JSON.parse(emit_callback_json);
      console.log( '这是一个buff数据 SOCKET_IO_INDEX', params.binary  );
      if (params.binary) {
        prompt.showToast({ message:`这是一个buff数据: ${JSON.stringify(params.message)}`, duration:2000 });
      } else {
        prompt.showToast({ message:`这不是一个buff数据`, duration:2000 });
      };
    } catch (e) {
      prompt.showToast({ message:`数据转化错误`, duration:2000 });
    };
  };
  // 发送对象
  sendObjectMessage(message: ESObject) {
    if (!this.connect_finish) {
      hilog.info(0x0000, 'testTag', '%{public}s', 'SOCKET_IO_INDEX 暂未连接服务器');
      return;
    };
    this.client?.emit("new message object", message, this.on_emit_callback_object);
  };
  private on_emit_callback_object(emit_callback_json: string): void {
    hilog.info(0x0000, 'testTag', '%{public}s', '[SOCKET_IO_INDEX] ' + emit_callback_json);
    try {
      const params:ESObject = JSON.parse(emit_callback_json)
      const  is = params.message !== null && typeof params.message === 'object' && params.message.constructor === Object
      prompt.showToast({ message:`这是一个${is?'对象':'其他'}数据: ${JSON.stringify(params.message)}`, duration:2000 });
    } catch (e) {
      this.client?.emit("error message", '数据转化错误');
    }
  };
  // 发送数组
  sendArrayMessage(message: ESObject) {
    if (!this.connect_finish) {
      hilog.info(0x0000, 'testTag', '%{public}s', 'SOCKET_IO_INDEX 暂未连接服务器');
      return;
    }
    this.client?.emit("new message array", message, this.on_emit_callback_array);
  };
  private on_emit_callback_array(emit_callback_json: string): void {
    hilog.info(0x0000, 'testTag', '%{public}s', '[SOCKET_IO_INDEX] ' + emit_callback_json);
    try {
      const params:ESObject = JSON.parse(emit_callback_json);
      const  is = JSON.parse(params.message) !== null && typeof JSON.parse(params.message) === 'object' && Array.isArray(JSON.parse(params.message));
      prompt.showToast({ message:`这是一个${is?'数组':'其他'}数据: ${JSON.stringify(params.message)}`, duration:2000 });
    } catch (e) {
      prompt.showToast({ message:`数据转化错误`, duration:2000 });
    };
  };
  // 发送布尔值
  sendBooleanMessage(message: ESObject) {
    if (!this.connect_finish) {
      hilog.info(0x0000, 'testTag', '%{public}s', 'SOCKET_IO_INDEX 暂未连接服务器');
      return;
    };
    this.client?.emit("new message boolean", JSON.stringify(message), this.on_emit_callback_boolean);
  };
  private on_emit_callback_boolean(emit_callback_json: string): void {
    hilog.info(0x0000, 'testTag', '%{public}s', '[SOCKET_IO_INDEX] ' + emit_callback_json);
    try {
      const params:ESObject = JSON.parse(emit_callback_json)
      const  is = params.message === true || params.message === false
      prompt.showToast({ message:`这是一个${is?'布尔':'其他'}数据: ${JSON.stringify(params.message)}`, duration:2000 });
    } catch (e) {
      this.client?.emit("error message", '数据转化错误');
    };
  };
  // 多参数的回调
  sendMultiParameterCallbackMessage(message: ESObject) {
    if (!this.connect_finish) {
      hilog.info(0x0000, 'testTag', '%{public}s', 'SOCKET_IO_INDEX 暂未连接服务器');
      return;
    };
    this.client?.emit("new message multi parameter", message, this.on_emit_callback_multi_parameter);
  };
  private on_emit_callback_multi_parameter(emit_callback_json: string): void {
    hilog.info(0x0000, 'testTag', '%{public}s', '[SOCKET_IO_INDEX] ' + emit_callback_json);
    try {
      const params:ESObject = JSON.parse(emit_callback_json)
      let message:ESObject = params.map((item:ESObject, index:number) => {
        let type = Array.isArray(item) ? 'array' :item === null? 'null' : typeof item;
        return `索引 ${index}: 值=${JSON.stringify(item)}, 类型=${type}`;
      }).join('\n');

      prompt.showDialog({
        title: '多参回调数据类型',
        message: message,
      });
    } catch (e) {
      this.client?.emit("error message", '数据转化错误');
    };
  };
};

export const socketManager = new SocketManager();