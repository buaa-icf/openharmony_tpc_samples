import { E as EventEmitter_1 } from './event-polyfill';
import socket from '@ohos.net.socket';
import connection from '@ohos.net.connection';
import buffer from '@ohos.buffer';
import './common.js';

var tag = "dudu---";
class OhosTcpSocket {
  tcp_socket; // TcpSocket实例
  options; //配置
  net_handle; //网络句柄
  net_address; //网络地址
  connecting = false; // 连接状态
  constructor(options) {
    console.info('xmpp--- options-'+JSON.stringify(options))
    this.tcp_socket = socket.constructTCPSocketInstance();
    this.options = options;
  }

  async getDefaultNet() {
    this.net_handle = await connection.getDefaultNet();
  }

  async getConnectionProperties() {
    const res = await connection.getConnectionProperties(this.net_handle);
    if (!res || !res.linkAddresses || res.linkAddresses.length === 0) {
      throw new Error('无法获取网络地址：linkAddresses为空');
    }
    this.net_address = res.linkAddresses[0].address;
    console.log(tag + `获取网络地址: ${this.net_address.address}`);
  }

  async bind() {
    await this.tcp_socket.bind(this.net_address);
  }

  async connect() {
    await this.tcp_socket.connect({
      address: {
        address: this.options.host,
        port: this.options.port,
        family: 1,
      },
      timeout: 6000,
    });
    return this;
  }

  async close() {
    // 先清理监听器
    this.cleanupListeners();
    // 再关闭socket
    await this.tcp_socket.close();
  }

  registerListener(socketInstance) {
    this.cleanupListeners();
    this.tcp_socket.on('message', (data) => {
      console.log(
          tag + `服务端发来消息 :${buffer.from(data.message).toString()}`
      );
      socketInstance.emit('data', buffer.from(data.message).toString());
    });
    this.tcp_socket.on('error', (err) => {
      console.error(tag + `TCP Socket错误:`, JSON.stringify(err));
      socketInstance.emit('error', err);
    });
    this.tcp_socket.on('close', () => {
      console.info(tag + 'TCP Socket已关闭');
      socketInstance.emit('close');
    });
  }

  cleanupListeners() {
    if (this.tcp_socket) {
      this.tcp_socket.off('message');
      this.tcp_socket.off('error');
      this.tcp_socket.off('close');
      console.info(tag + 'TCP Socket监听器已移除');
    }
  }
}

class Socket extends EventEmitter_1 {
  ohos_tcp_socket;
  constructor(options) {
    super();
    this.options = options;
    this.ohos_tcp_socket = new OhosTcpSocket(options);
  }
  async connect() {
    // 防止重复连接
    if (this.ohos_tcp_socket.connecting) {
      console.warn(tag + '已经在连接中，忽略重复调用');
      return;
    }

    try {
      this.ohos_tcp_socket.connecting = true;
      await this.ohos_tcp_socket.getDefaultNet();
      console.log(tag + `getDefaultNet 成功`);
      await this.ohos_tcp_socket.getConnectionProperties();
      console.log(tag + `getConnectionProperties 成功`);
      await this.ohos_tcp_socket.bind();
      console.log(tag + `bind 成功`);
      await this.ohos_tcp_socket.connect();
      console.log(tag + `connect 成功`);
      this.ohos_tcp_socket.connecting = false;
      // 注册监听器，传入this以便emit事件
      this.ohos_tcp_socket.registerListener(this);
      this.emit('connect');
    } catch (err) {
      console.error(tag + `TCP Socket 出现异常:`, err);
      this.ohos_tcp_socket.connecting = false;
      this.emit('error', err);
      this.emit('close', true);
    }
  }

  async write(data, cb) {
    console.log(tag + `write 开始发送消息`);
    // 如果正在连接，等待连接完成
    if (this.ohos_tcp_socket.connecting) {
      console.log(tag + `等待连接建立...`);
      await new Promise(resolve => this.once('connect', resolve));
    }

    // 检查socket是否存在
    if (!this.ohos_tcp_socket.tcp_socket) {
      const err = new Error('TCP Socket未连接，请先调用connect()');
      console.error(tag + err.message);
      if (cb) {
        cb(err);
      }
      return;
    }

    // 连接已建立，发送数据
    console.log(tag + `write--发送 `);
    try {
      await this.ohos_tcp_socket.tcp_socket.send({ data, encoding:'utf8' });
      console.log(tag + `发送成功`);
      if (cb) {
        cb();
      }
    } catch (err) {
      console.error(tag + `发送失败:`, err);
      if (cb) {
        cb(err);
      }
    }
  }

  async end() {
    try {
      if (this.ohos_tcp_socket) {
        // 直接调用close()，内部会cleanupListeners
        await this.ohos_tcp_socket.close();
      }
      // 先emit事件
      this.emit('close', false);
      // 再移除监听器
      this.removeAllListeners();
    } catch (error) {
      console.error(tag + `关闭异常:`, error);
      this.emit('error', error);
      this.emit('close', true);
    }
  }
  destroy() {
    try {
      console.log(tag + `强制销毁连接`);
      if (this.ohos_tcp_socket) {
        this.ohos_tcp_socket.cleanupListeners();
        if (this.ohos_tcp_socket.tcp_socket) {
          this.ohos_tcp_socket.tcp_socket.close();
        }
        this.ohos_tcp_socket.connecting = false;
      }
      // 先emit事件
      this.emit('close', true);
      // 再移除监听器
      this.removeAllListeners();
    } catch (err) {
      console.error(tag + 'destroy失败:', err);
    }
  }
  removeAllListeners(event) {
    if (event) {
      super.removeAllListeners(event);
    } else {
      super.removeAllListeners();
    }
  }
  unref() {
    // OpenHarmony暂不支持unref功能
    // 此方法保留仅为兼容Node.js API
    console.warn(tag + 'unref() 在OpenHarmony中暂不支持');
  }
}

export { Socket };
