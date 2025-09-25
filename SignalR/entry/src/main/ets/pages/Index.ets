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

import { HubConnection, HubConnectionBuilder, HubConnectionState, LogLevel, HttpTransportType, IHttpConnectionOptions, ISubscription } from '@ohos/signalr';
import { http } from '@kit.NetworkKit';
import { BusinessError } from '@kit.BasicServicesKit';
import EventSource from '@ohos/eventsource';



@Entry
@Component
struct Index {
  @State connectionStatus: string = '未连接';
  @State messages: string[] = [];
  @State inputMessage: string = '';
  @State serverUrl: string = 'http://119.29.249.146:5000/chatHub';
  @State userName: string = 'HarmonyUser';
  @State isConnected: boolean = false;
  @State selectedTransport: number = 0; // 0=自动, 1=WebSockets, 2=ServerSentEvents, 3=LongPolling
  @State isStreamTesting: boolean = false;
  
  private transportOptions: SelectOption[] = [
    { value: '自动选择' },
    { value: 'WebSockets' },
    { value: 'ServerSentEvents' },
    { value: 'LongPolling' }
  ];

  private hubConnection: HubConnection | null = null;
  private heartbeatTimer: number | undefined = undefined;
  private streamSubscription: ISubscription<number> | null = null;

  build() {
    Column() {
      // 标题
      Text('SignalR 鸿蒙测试Demo')
        .fontSize(24)
        .fontWeight(FontWeight.Bold)
        .margin({ top: 20, bottom: 20 })
      
      // 连接状态
      Row() {
        Text('连接状态: ')
          .fontSize(16)
        Text(this.connectionStatus)
          .fontSize(16)
          .fontColor(this.getStatusColor())
          .fontWeight(FontWeight.Bold)
      }
      .width('100%')
      .justifyContent(FlexAlign.Start)
      .margin({ bottom: 10 })
      
      // 服务器URL输入
      Row() {
        Text('服务器: ')
          .fontSize(14)
          .width(80)
        TextInput({ text: this.serverUrl })
          .fontSize(14)
          .layoutWeight(1)
          .onChange((value: string) => {
            this.serverUrl = value;
          })
      }
      .width('100%')
      .margin({ bottom: 10 })
      
      // 用户名输入
      Row() {
        Text('用户名: ')
          .fontSize(14)
          .width(80)
        TextInput({ text: this.userName })
          .fontSize(14)
          .layoutWeight(1)
          .onChange((value: string) => {
            this.userName = value;
          })
      }
      .width('100%')
      .margin({ bottom: 10 })
      
      // 传输方式选择
      Row() {
        Text('传输方式: ')
          .fontSize(14)
          .width(80)
        Select(this.transportOptions)
          .selected(this.selectedTransport)
          .value(this.transportOptions[this.selectedTransport].value)
          .font({ size: 14 })
          .layoutWeight(1)
          .enabled(!this.isConnected) // 连接状态下禁用传输方式选择
          .onSelect((index: number) => {
            if (!this.isConnected) {
              this.selectedTransport = index;
              this.addMessage(`切换传输方式: ${this.transportOptions[index].value}`);
            }
          })
      }
      .width('100%')
      .margin({ bottom: 20 })
      
      // 连接按钮
      Row() {
        Button('测试网络')
          .onClick(() => {
            this.testNetwork();
          })
          .margin({ right: 15 })
        
        Button('连接')
          .enabled(!this.isConnected)
          .onClick(() => {
            this.connectToHub();
          })
          .margin({ right: 15 })
        
        Button('断开')
          .enabled(this.isConnected)
          .onClick(() => {
            this.disconnectFromHub();
          })
      }
      .width('100%')
      .justifyContent(FlexAlign.Center)
      .margin({ bottom: 10 })
      
      // 流传输测试按钮
      Row() {
        Button('测试流传输')
          .enabled(this.isConnected && !this.isStreamTesting)
          .onClick(() => {
            this.testStreamTransport();
          })
          .margin({ right: 15 })
        
        Button('停止流传输')
          .enabled(this.isStreamTesting)
          .onClick(() => {
            this.stopStreamTransport();
          })
      }
      .width('100%')
      .justifyContent(FlexAlign.Center)
      .margin({ bottom: 20 })
      
      // 消息输入
      Row() {
        TextInput({ placeholder: '输入消息...' })
          .layoutWeight(1)
          .onChange((value: string) => {
            this.inputMessage = value;
          })
          .onSubmit(() => {
            this.sendMessage();
          })
        
        Button('发送')
          .enabled(this.isSendButtonEnabled())
          .onClick(() => {
            this.sendMessage();
          })
          .margin({ left: 10 })
      }
      .width('100%')
      .margin({ bottom: 20 })
      
      // 消息列表
      Text('消息记录:')
        .fontSize(16)
        .fontWeight(FontWeight.Bold)
        .width('100%')
        .textAlign(TextAlign.Start)
        .margin({ bottom: 10 })
      
      List() {
        ForEach(this.messages, (message: string, index: number) => {
          ListItem() {
            Text(message)
              .fontSize(14)
              .width('100%')
              .padding(10)
              .backgroundColor('#f5f5f5')
              .borderRadius(5)
          }
          .margin({ bottom: 5 })
        })
      }
      .layoutWeight(1)
      .width('100%')
      .backgroundColor($r('sys.color.white'))
      .borderRadius(10)
      .padding(10)
      
    }
    .width('100%')
    .height('100%')
    .padding(20)
    .backgroundColor('#fafafa')
  }
  
  private isSendButtonEnabled(): boolean {
    const methodName = 'isSendButtonEnabled';
    const startTime = Date.now();
    console.info(`[SignalR-Performance] [${methodName}] 开始检查发送按钮状态, 开始时间: ${new Date(startTime).toISOString()}`);
    
    const hasMessage = this.inputMessage.length > 0;
    const result = this.isConnected && hasMessage;
    
    const endTime = Date.now();
    const duration = endTime - startTime;
    console.info(`[SignalR-Performance] [${methodName}] 发送按钮状态检查完成, 连接状态: ${this.isConnected}, 有消息: ${hasMessage}, 结果: ${result}, 耗时: ${duration}ms`);
    
    return result;
  }

  private getStatusColor(): ResourceColor {
    const methodName = 'getStatusColor';
    const startTime = Date.now();
    console.info(`[SignalR-Performance] [${methodName}] 开始获取状态颜色, 当前状态: ${this.connectionStatus}, 开始时间: ${new Date(startTime).toISOString()}`);
    
    let result: ResourceColor;
    switch (this.connectionStatus) {
      case '已连接':
        result = '#00ff00';
        break;
      case '连接中...':
        result = '#ffaa00';
        break;
      case '断开连接中...':
        result = '#ffaa00';
        break;
      case '连接失败':
      case '连接错误':
        result = '#ff0000';
        break;
      default:
        result = '#666666';
    }
    
    const endTime = Date.now();
    const duration = endTime - startTime;
    console.info(`[SignalR-Performance] [${methodName}] 状态颜色获取完成, 状态: ${this.connectionStatus}, 颜色: ${result}, 耗时: ${duration}ms`);
    
    return result;
  }
  
  private addMessage(message: string) {
    const timestamp = new Date().toLocaleTimeString();
    this.messages.push(`[${timestamp}] ${message}`);
    
    // 限制消息数量，避免内存过多
    if (this.messages.length > 100) {
      this.messages = this.messages.slice(-50);
    }
  }
  
  private async testNetwork() {
    const methodName = 'testNetwork';
    const startTime = Date.now();
    console.info(`[SignalR-Performance] [${methodName}] 开始时间: ${new Date(startTime).toISOString()}`);
    
    try {
      this.addMessage('开始网络连通性测试...');
      
      const httpRequest = http.createHttp();
      
      // 测试简单的HTTP请求
      const testUrl = 'http://www.baidu.com';
      this.addMessage(`测试连接到: ${testUrl}`);
      
      const requestStartTime = Date.now();
      
      httpRequest.request(testUrl, {
        method: http.RequestMethod.GET,
        connectTimeout: 5000,
        readTimeout: 5000
      }, (err: BusinessError, data: http.HttpResponse) => {
        const requestEndTime = Date.now();
        const requestDuration = requestEndTime - requestStartTime;
        
        if (!err) {
          this.addMessage(`网络连接正常！耗时: ${requestDuration}ms`);
          this.addMessage(`响应状态: ${data.responseCode}`);
          console.info(`[SignalR-Performance] [${methodName}] HTTP请求耗时: ${requestDuration}ms, 状态码: ${data.responseCode}`);
          
          // 现在测试SignalR服务器
          this.testSignalRServer();
        } else {
          this.addMessage(`网络连接失败: ${err.message}`);
          console.error(`[SignalR-Performance] [${methodName}] HTTP请求失败: ${err.message}, 耗时: ${requestDuration}ms`);
        }
        
        httpRequest.destroy();
        
        const endTime = Date.now();
        const totalDuration = endTime - startTime;
        console.info(`[SignalR-Performance] [${methodName}] 结束时间: ${new Date(endTime).toISOString()}`);
        console.info(`[SignalR-Performance] [${methodName}] 总耗时: ${totalDuration}ms`);
      });
      
    } catch (error) {
      this.addMessage(`网络测试异常: ${error}`);
      const endTime = Date.now();
      const duration = endTime - startTime;
      console.error(`[SignalR-Performance] [${methodName}] 异常结束时间: ${new Date(endTime).toISOString()}`);
      console.error(`[SignalR-Performance] [${methodName}] 异常耗时: ${duration}ms`);
    }
  }
  
  private async testSignalRServer() {
    const methodName = 'testSignalRServer';
    const startTime = Date.now();
    console.info(`[SignalR-Performance] [${methodName}] 开始时间: ${new Date(startTime).toISOString()}`);
    
    try {
      this.addMessage('测试SignalR服务器连接...');
      
      const httpRequest = http.createHttp();
      
      // 测试SignalR服务器的根路径
      const baseUrl = this.serverUrl.replace('/chatHub', '');
      this.addMessage(`测试服务器: ${baseUrl}`);
      
      const requestStartTime = Date.now();
      
      httpRequest.request(baseUrl, {
        method: http.RequestMethod.GET,
        connectTimeout: 5000,
        readTimeout: 5000
      }, (err: BusinessError, data: http.HttpResponse) => {
        const requestEndTime = Date.now();
        const requestDuration = requestEndTime - requestStartTime;
        
        if (!err) {
          this.addMessage(`SignalR服务器可达！耗时: ${requestDuration}ms`);
          this.addMessage(`响应状态: ${data.responseCode}`);
          console.info(`[SignalR-Performance] [${methodName}] 服务器连接测试成功: ${baseUrl}, 耗时: ${requestDuration}ms, 状态码: ${data.responseCode}`);
          if (data.responseCode === 200) {
            this.addMessage('服务器运行正常，可以尝试连接SignalR');
          }
        } else {
          this.addMessage(`SignalR服务器无法访问: ${err.message}`);
          this.addMessage('请检查服务器地址是否正确');
          console.error(`[SignalR-Performance] [${methodName}] 服务器连接测试失败: ${baseUrl}, 错误: ${err.message}, 耗时: ${requestDuration}ms`);
        }
        
        httpRequest.destroy();
        
        const endTime = Date.now();
        const totalDuration = endTime - startTime;
        console.info(`[SignalR-Performance] [${methodName}] 结束时间: ${new Date(endTime).toISOString()}`);
        console.info(`[SignalR-Performance] [${methodName}] 总耗时: ${totalDuration}ms`);
      });
      
    } catch (error) {
      this.addMessage(`服务器测试异常: ${error}`);
      const endTime = Date.now();
      const duration = endTime - startTime;
      console.error(`[SignalR-Performance] [${methodName}] 异常结束时间: ${new Date(endTime).toISOString()}`);
      console.error(`[SignalR-Performance] [${methodName}] 异常耗时: ${duration}ms`);
    }
  }

  private getTransportType(): HttpTransportType | undefined {
    const methodName = 'getTransportType';
    const startTime = Date.now();
    console.info(`[SignalR-Performance] [${methodName}] 开始时间: ${new Date(startTime).toISOString()}`);
    
    let result: HttpTransportType | undefined;
    let transportName: string;
    switch (this.selectedTransport) {
      case 1: 
        result = HttpTransportType.WebSockets; 
        transportName = 'WebSockets';
        break;
      case 2: 
        result = HttpTransportType.ServerSentEvents; 
        transportName = 'ServerSentEvents';
        break;
      case 3: 
        result = HttpTransportType.LongPolling; 
        transportName = 'LongPolling';
        break;
      default: 
        result = undefined; // 自动选择
        transportName = '自动选择';
    }
    
    const endTime = Date.now();
    const duration = endTime - startTime;
    console.info(`[SignalR-Performance] [${methodName}] 传输方式选择: ${transportName}, 耗时: ${duration}ms`);
    console.info(`[SignalR-Performance] [${methodName}] 结束时间: ${new Date(endTime).toISOString()}`);
    
    return result;
  }

  private async connectToHub() {
    const methodName = 'connectToHub';
    const transportType = this.transportOptions[this.selectedTransport].value;
    const startTime = Date.now();
    console.info(`[SignalR-Performance] [${methodName}] 开始连接, 传输方式: ${transportType}, 开始时间: ${new Date(startTime).toISOString()}`);
    
    try {
      this.connectionStatus = '连接中...';
      this.addMessage('开始连接到SignalR服务器...');
      this.addMessage(`使用传输方式: ${transportType}`);
      
      // 创建连接配置
      const connectionOptions: IHttpConnectionOptions = {
        headers: {
          'User-Agent': 'HarmonyOS-SignalR-Client/1.0'
        },
        skipNegotiation: false,
        transport: this.getTransportType()
      };

      if (this.selectedTransport === 0 || this.selectedTransport === 2) {
        connectionOptions.EventSource = (url: string) => {
          return new EventSource(url);
        };
      }

      // 创建连接
      const builderStartTime = Date.now();
      this.hubConnection = new HubConnectionBuilder()
        .withUrl(this.serverUrl, connectionOptions)
        .configureLogging(LogLevel.Debug)
        // .withServerTimeout(0) // 禁用服务器超时检查
        .withKeepAliveInterval(15000) // 保持15秒心跳间隔
        .withAutomaticReconnect([0, 2000, 10000, 30000]) // 重连间隔：立即、2秒、10秒、30秒
        .build();
      const builderEndTime = Date.now();
      const builderDuration = builderEndTime - builderStartTime;
      
      console.info(`[SignalR-Performance] [${methodName}] HubConnection构建耗时: ${builderDuration}ms, 传输方式: ${transportType}`);
      console.info('SignalR: HubConnection已创建');
      this.addMessage('√ HubConnection已创建');
      
      // 设置接收消息的处理器
      this.hubConnection.on('ReceiveMessage', (user: string, message: string) => {
        this.addMessage(`${user}: ${message}`);
      });
      
      // 设置用户加入的消息处理器
      this.hubConnection.on('UserJoined', (userName: string) => {
        this.addMessage(`${userName} 加入了聊天室`);
      });
      
      // 设置用户离开的消息处理器
      this.hubConnection.on('UserLeft', (userName: string) => {
        this.addMessage(`${userName} 离开了聊天室`);
      });
      
      // 设置连接状态变化的处理器
      this.hubConnection.onclose((error?: Error) => {
        console.warn('SignalR: 连接关闭事件', error);
        
        // 更新UI状态
        this.connectionStatus = '未连接';
        this.isConnected = false;
        
        // 清理连接对象
        if (this.hubConnection) {
          this.hubConnection = null;
        }
        
        if (error) {
          this.addMessage(`× 连接意外关闭: ${error.message}`);
          console.error('SignalR连接关闭错误:', error);
          
          // 添加更详细的错误分析
          if (error.message.includes('timeout')) {
            this.addMessage('可能原因：网络超时，请检查网络连接');
          } else if (error.message.includes('server')) {
            this.addMessage('可能原因：服务器主动关闭连接');
          } else {
            this.addMessage('建议：尝试重新连接');
          }
        } else {
          this.addMessage('√ 连接已正常关闭');
        }
      });
      
      this.hubConnection.onreconnecting((error?: Error) => {
        this.connectionStatus = '重连中...';
        this.isConnected = false;
        this.addMessage('正在重新连接...');
        console.info(`[SignalR-Performance] [${methodName}] 开始重连, 传输方式: ${transportType}`);
      });
      
      this.hubConnection.onreconnected((connectionId?: string) => {
        this.connectionStatus = '已连接';
        this.isConnected = true;
        this.addMessage(`重新连接成功: ${connectionId}`);
        console.info(`[SignalR-Performance] [${methodName}] 重连成功, 传输方式: ${transportType}, 连接ID: ${connectionId}`);
      });
      
      // 开始连接
      console.info('SignalR: 开始连接...');
      this.addMessage('开始连接...');
      const connectStartTime = Date.now();
      await this.hubConnection.start();
      const connectEndTime = Date.now();
      const connectDuration = connectEndTime - connectStartTime;
      console.info(`[SignalR-Performance] [${methodName}] SignalR连接建立耗时: ${connectDuration}ms, 传输方式: ${transportType}, 服务器: ${this.serverUrl}`);
      
      // 连接成功后验证状态
      console.info(`SignalR: 连接完成，状态=${this.hubConnection.state}`);
      this.connectionStatus = '已连接';
      this.isConnected = true;
      this.addMessage('成功连接到SignalR服务器!');
      this.addMessage(`连接状态: ${this.hubConnection.state}`);
      
      // 验证是否真的处于Connected状态
      if (this.hubConnection.state === HubConnectionState.Connected) {
        this.addMessage('连接状态验证成功，可以发送消息了！');
        console.info(`[SignalR-Performance] [${methodName}] 连接状态验证成功, 传输方式: ${transportType}`);
      } else {
        this.addMessage(`连接状态异常：期望Connected，实际${this.hubConnection.state}`);
        this.isConnected = false;
        console.error(`[SignalR-Performance] [${methodName}] 连接状态异常, 期望: Connected, 实际: ${this.hubConnection.state}, 传输方式: ${transportType}`);
      }
      
      // 服务器用户加入
      const invokeStartTime = Date.now();
      await this.hubConnection.invoke('UserConnected', this.userName);
      const invokeEndTime = Date.now();
      const invokeDuration = invokeEndTime - invokeStartTime;
      console.info(`[SignalR-Performance] [${methodName}] UserConnected调用耗时: ${invokeDuration}ms, 用户名: ${this.userName}, 传输方式: ${transportType}`);
      this.addMessage(`${this.userName} 加入了聊天室`);

      const endTime = Date.now();
      const totalDuration = endTime - startTime;
      console.info(`[SignalR-Performance] [${methodName}] 连接完成, 传输方式: ${transportType}, 结束时间: ${new Date(endTime).toISOString()}`);
      console.info(`[SignalR-Performance] [${methodName}] 连接总耗时: ${totalDuration}ms, 传输方式: ${transportType}`);
      
    } catch (error) {
      this.connectionStatus = '连接失败';
      this.isConnected = false;
      this.addMessage(`连接失败: ${error}`);
      console.error('SignalR连接错误:', error);
      
      const endTime = Date.now();
      const duration = endTime - startTime;
      console.error(`[SignalR-Performance] [${methodName}] 连接失败, 传输方式: ${transportType}, 异常结束时间: ${new Date(endTime).toISOString()}`);
      console.error(`[SignalR-Performance] [${methodName}] 连接失败耗时: ${duration}ms, 传输方式: ${transportType}, 错误: ${error}`);

      if (error instanceof Error) {
        this.addMessage(`错误详情: ${error.message}`);
        console.error('错误堆栈:', error.stack);
      }
    }
  }
  
  private async disconnectFromHub() {
    const methodName = 'disconnectFromHub';
    const transportType = this.transportOptions[this.selectedTransport].value;
    const startTime = Date.now();
    console.info(`[SignalR-Performance] [${methodName}] 开始断开连接, 传输方式: ${transportType}, 开始时间: ${new Date(startTime).toISOString()}`);
    
    try {
      if (this.hubConnection) {
        this.connectionStatus = '断开连接中...';
        this.addMessage('正在断开连接...');

        this.stopHeartbeat();
        
        try {
          const stopStartTime = Date.now();
          await this.hubConnection.stop();
          const stopEndTime = Date.now();
          const stopDuration = stopEndTime - stopStartTime;
          console.info(`[SignalR-Performance] [${methodName}] SignalR stop()耗时: ${stopDuration}ms, 传输方式: ${transportType}`);
          console.info('SignalR stop() 方法完成');
        } catch (stopError) {
          console.warn('SignalR stop() 方法失败:', stopError);
          this.addMessage(`断开过程中出现问题: ${stopError}`);
          console.error(`[SignalR-Performance] [${methodName}] SignalR stop()失败, 传输方式: ${transportType}, 错误: ${stopError}`);

          this.hubConnection = null;
          this.connectionStatus = '未连接';
          this.isConnected = false;
          this.addMessage('√ 已强制断开连接');
        }
        
        console.info('断开连接操作完成');
      }
      
      const endTime = Date.now();
      const duration = endTime - startTime;
      console.info(`[SignalR-Performance] [${methodName}] 断开连接完成, 传输方式: ${transportType}, 结束时间: ${new Date(endTime).toISOString()}`);
      console.info(`[SignalR-Performance] [${methodName}] 断开连接总耗时: ${duration}ms, 传输方式: ${transportType}`);
    } catch (error) {
      this.addMessage(`× 断开连接时发生错误: ${error}`);
      console.error('SignalR断开连接错误:', error);
      
      const endTime = Date.now();
      const duration = endTime - startTime;
      console.error(`[SignalR-Performance] [${methodName}] 断开连接异常, 传输方式: ${transportType}, 异常结束时间: ${new Date(endTime).toISOString()}`);
      console.error(`[SignalR-Performance] [${methodName}] 断开连接异常耗时: ${duration}ms, 传输方式: ${transportType}, 错误: ${error}`);
      
      // 即使出错也要清理状态
      this.hubConnection = null;
      this.connectionStatus = '未连接';
      this.isConnected = false;
    }
  }

  private stopHeartbeat() {
    const methodName = 'stopHeartbeat';
    const startTime = Date.now();
    console.info(`[SignalR-Performance] [${methodName}] 开始停止心跳监控, 开始时间: ${new Date(startTime).toISOString()}`);
    
    if (this.heartbeatTimer) {
      clearInterval(this.heartbeatTimer);
      this.heartbeatTimer = undefined;
      console.info('心跳监控已停止');
    }
    
    const endTime = Date.now();
    const duration = endTime - startTime;
    console.info(`[SignalR-Performance] [${methodName}] 停止心跳监控完成, 结束时间: ${new Date(endTime).toISOString()}`);
    console.info(`[SignalR-Performance] [${methodName}] 停止心跳监控耗时: ${duration}ms`);
  }
  
  private async sendMessage() {
    const methodName = 'sendMessage';
    const transportType = this.transportOptions[this.selectedTransport].value;
    const startTime = Date.now();
    console.info(`[SignalR-Performance] [${methodName}] 开始发送消息, 传输方式: ${transportType}, 开始时间: ${new Date(startTime).toISOString()}`);
    
    try {
      if (!this.hubConnection) {
        this.addMessage('× 连接对象不存在');
        const endTime = Date.now();
        const duration = endTime - startTime;
        console.warn(`[SignalR-Performance] [${methodName}] 连接对象不存在, 传输方式: ${transportType}, 提前结束耗时: ${duration}ms`);
        return;
      }

      if (this.hubConnection.state !== HubConnectionState.Connected) {
        this.addMessage(`× 连接状态异常: ${this.hubConnection.state}`);
        const endTime = Date.now();
        const duration = endTime - startTime;
        console.warn(`[SignalR-Performance] [${methodName}] 连接状态异常: ${this.hubConnection.state}, 传输方式: ${transportType}, 提前结束耗时: ${duration}ms`);
        return;
      }

      if (this.inputMessage.trim().length === 0) {
        this.addMessage('× 消息不能为空');
        const endTime = Date.now();
        const duration = endTime - startTime;
        console.warn(`[SignalR-Performance] [${methodName}] 消息为空, 传输方式: ${transportType}, 提前结束耗时: ${duration}ms`);
        return;
      }

      const messageToSend = this.inputMessage.trim();
      const messageLength = messageToSend.length;
      console.info(`发送消息前连接状态: ${this.hubConnection.state}`);
      this.addMessage(`正在发送: "${messageToSend}"`);

      const invokeStartTime = Date.now();
      await this.hubConnection.invoke('SendMessage', this.userName, messageToSend);
      const invokeEndTime = Date.now();
      const invokeDuration = invokeEndTime - invokeStartTime;
      console.info(`[SignalR-Performance] [${methodName}] SendMessage调用耗时: ${invokeDuration}ms, 消息长度: ${messageLength}字符, 传输方式: ${transportType}, 用户: ${this.userName}`);
      
      console.info(`发送消息后连接状态: ${this.hubConnection.state}`);
      this.inputMessage = '';
      this.addMessage(`√ 消息发送成功`);
      
      // 检查发送后连接是否还正常
      if (this.hubConnection.state !== HubConnectionState.Connected) {
        this.addMessage(`警告: 发送后连接状态变为 ${this.hubConnection.state}`);
        console.warn(`[SignalR-Performance] [${methodName}] 发送后连接状态异常: ${this.hubConnection.state}, 传输方式: ${transportType}`);
      }

      const endTime = Date.now();
      const totalDuration = endTime - startTime;
      console.info(`[SignalR-Performance] [${methodName}] 消息发送完成, 传输方式: ${transportType}, 结束时间: ${new Date(endTime).toISOString()}`);
      console.info(`[SignalR-Performance] [${methodName}] 消息发送总耗时: ${totalDuration}ms, 传输方式: ${transportType}`);

    } catch (error) {
      this.addMessage(`× 发送消息失败: ${error}`);
      console.error('发送消息错误:', error);
      
      const endTime = Date.now();
      const duration = endTime - startTime;
      console.error(`[SignalR-Performance] [${methodName}] 消息发送失败, 传输方式: ${transportType}, 异常结束时间: ${new Date(endTime).toISOString()}`);
      console.error(`[SignalR-Performance] [${methodName}] 消息发送失败耗时: ${duration}ms, 传输方式: ${transportType}, 错误: ${error}`);
      
      // 检查发送失败后的连接状态
      if (this.hubConnection) {
        this.addMessage(`发送失败时连接状态: ${this.hubConnection.state}`);
        console.error(`[SignalR-Performance] [${methodName}] 发送失败时连接状态: ${this.hubConnection.state}, 传输方式: ${transportType}`);
      }
    }
  }
  
  private async testStreamTransport() {
    const methodName = 'testStreamTransport';
    const transportType = this.transportOptions[this.selectedTransport].value;
    const startTime = Date.now();
    console.info(`[SignalR-Performance] [${methodName}] 开始流传输测试, 传输方式: ${transportType}, 开始时间: ${new Date(startTime).toISOString()}`);
    
    try {
      if (!this.hubConnection) {
        this.addMessage('× 连接对象不存在');
        const endTime = Date.now();
        const duration = endTime - startTime;
        console.warn(`[SignalR-Performance] [${methodName}] 连接对象不存在, 传输方式: ${transportType}, 提前结束耗时: ${duration}ms`);
        return;
      }

      if (this.hubConnection.state !== HubConnectionState.Connected) {
        this.addMessage(`× 连接状态异常: ${this.hubConnection.state}`);
        const endTime = Date.now();
        const duration = endTime - startTime;
        console.warn(`[SignalR-Performance] [${methodName}] 连接状态异常: ${this.hubConnection.state}, 传输方式: ${transportType}, 提前结束耗时: ${duration}ms`);
        return;
      }

      this.isStreamTesting = true;
      this.addMessage('开始测试流传输...');

      const streamStartTime = Date.now();
      const streamResult = this.hubConnection.stream<number>('StreamData', 10);
      console.info(`[SignalR-Performance] [${methodName}] 流传输订阅创建耗时: ${Date.now() - streamStartTime}ms, 传输方式: ${transportType}`);
      
      this.streamSubscription = streamResult.subscribe({
        next: (item: number) => {
          const receiveTime = Date.now();
          const receiveDuration = receiveTime - streamStartTime;
          this.addMessage(`收到流数据: ${JSON.stringify(item)}`);
          console.info(`[SignalR-Performance] [${methodName}] 收到流数据: ${item}, 从开始到接收耗时: ${receiveDuration}ms, 传输方式: ${transportType}`);
        },
        error: (err: Error) => {
          this.addMessage(`流传输错误: ${err}`);
          this.isStreamTesting = false;
          console.error('流传输错误:', err);
          
          const errorTime = Date.now();
          const errorDuration = errorTime - streamStartTime;
          console.error(`[SignalR-Performance] [${methodName}] 流传输错误, 传输方式: ${transportType}, 错误时间: ${new Date(errorTime).toISOString()}`);
          console.error(`[SignalR-Performance] [${methodName}] 流传输错误耗时: ${errorDuration}ms, 传输方式: ${transportType}, 错误: ${err}`);
        },
        complete: () => {
          this.addMessage('流传输完成');
          this.isStreamTesting = false;
          this.streamSubscription = null;
          
          const completeTime = Date.now();
          const completeDuration = completeTime - streamStartTime;
          console.info(`[SignalR-Performance] [${methodName}] 流传输完成, 传输方式: ${transportType}, 完成时间: ${new Date(completeTime).toISOString()}`);
          console.info(`[SignalR-Performance] [${methodName}] 流传输总耗时: ${completeDuration}ms, 传输方式: ${transportType}`);
        }
      });

      this.addMessage('流传输订阅成功，等待服务器数据...');

      const endTime = Date.now();
      const totalDuration = endTime - startTime;
      console.info(`[SignalR-Performance] [${methodName}] 流传输订阅完成, 传输方式: ${transportType}, 结束时间: ${new Date(endTime).toISOString()}`);
      console.info(`[SignalR-Performance] [${methodName}] 流传输订阅耗时: ${totalDuration}ms, 传输方式: ${transportType}`);

    } catch (error) {
      this.addMessage(`× 流传输测试失败: ${error}`);
      this.isStreamTesting = false;
      console.error('流传输测试错误:', error);
      
      const endTime = Date.now();
      const duration = endTime - startTime;
      console.error(`[SignalR-Performance] [${methodName}] 流传输测试失败, 传输方式: ${transportType}, 异常结束时间: ${new Date(endTime).toISOString()}`);
      console.error(`[SignalR-Performance] [${methodName}] 流传输测试失败耗时: ${duration}ms, 传输方式: ${transportType}, 错误: ${error}`);
    }
  }

  private stopStreamTransport() {
    const methodName = 'stopStreamTransport';
    const transportType = this.transportOptions[this.selectedTransport].value;
    const startTime = Date.now();
    console.info(`[SignalR-Performance] [${methodName}] 开始停止流传输, 传输方式: ${transportType}, 开始时间: ${new Date(startTime).toISOString()}`);
    
    try {
      if (this.streamSubscription) {
        const disposeStartTime = Date.now();
        this.streamSubscription.dispose();
        const disposeEndTime = Date.now();
        const disposeDuration = disposeEndTime - disposeStartTime;
        console.info(`[SignalR-Performance] [${methodName}] dispose()耗时: ${disposeDuration}ms, 传输方式: ${transportType}`);
        
        this.streamSubscription = null;
        this.addMessage('流传输已停止');
      }
      this.isStreamTesting = false;
      
      const endTime = Date.now();
      const duration = endTime - startTime;
      console.info(`[SignalR-Performance] [${methodName}] 停止流传输完成, 传输方式: ${transportType}, 结束时间: ${new Date(endTime).toISOString()}`);
      console.info(`[SignalR-Performance] [${methodName}] 停止流传输总耗时: ${duration}ms, 传输方式: ${transportType}`);
    } catch (error) {
      this.addMessage(`停止流传输时出错: ${error}`);
      console.error('停止流传输错误:', error);
      
      const endTime = Date.now();
      const duration = endTime - startTime;
      console.error(`[SignalR-Performance] [${methodName}] 停止流传输异常, 传输方式: ${transportType}, 异常结束时间: ${new Date(endTime).toISOString()}`);
      console.error(`[SignalR-Performance] [${methodName}] 停止流传输异常耗时: ${duration}ms, 传输方式: ${transportType}, 错误: ${error}`);
    }
  }
  
  aboutToDisappear() {
    const methodName = 'aboutToDisappear';
    const transportType = this.transportOptions[this.selectedTransport].value;
    const startTime = Date.now();
    console.info(`[SignalR-Performance] [${methodName}] 页面销毁开始, 传输方式: ${transportType}, 开始时间: ${new Date(startTime).toISOString()}`);
    
    // 页面销毁时断开连接和流传输
    if (this.streamSubscription) {
      const disposeStartTime = Date.now();
      this.streamSubscription.dispose();
      const disposeEndTime = Date.now();
      const disposeDuration = disposeEndTime - disposeStartTime;
      console.info(`[SignalR-Performance] [${methodName}] streamSubscription.dispose()耗时: ${disposeDuration}ms, 传输方式: ${transportType}`);
    }
    if (this.hubConnection) {
      const stopStartTime = Date.now();
      this.hubConnection.stop().catch(() => {
        // 忽略断开连接时的错误
      }).finally(() => {
        const stopEndTime = Date.now();
        const stopDuration = stopEndTime - stopStartTime;
        console.info(`[SignalR-Performance] [${methodName}] hubConnection.stop()耗时: ${stopDuration}ms, 传输方式: ${transportType}`);
      });
    }
    
    const endTime = Date.now();
    const duration = endTime - startTime;
    console.info(`[SignalR-Performance] [${methodName}] 页面销毁完成, 传输方式: ${transportType}, 结束时间: ${new Date(endTime).toISOString()}`);
    console.info(`[SignalR-Performance] [${methodName}] 页面销毁总耗时: ${duration}ms, 传输方式: ${transportType}`);
  }
}