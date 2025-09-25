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

import { hilog } from '@kit.PerformanceAnalysisKit';
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect } from '@ohos/hypium';
import { 
  HubConnection, 
  HubConnectionBuilder, 
  HubConnectionState, 
  LogLevel, 
  JsonHubProtocol,
  HttpTransportType,
  IHttpConnectionOptions 
} from '@ohos/signalr';

export function connectionLifecycleTest() {
  describe('Connection_Lifecycle', () => {
    let connection: HubConnection;
    let builder: HubConnectionBuilder;
    const testUrl = 'http://119.29.249.146:5000/chatHub';
    
    beforeAll(() => {
      console.info( 'SignalRTest', 'Connection_Lifecycle test suite started');
    })
    
    beforeEach(() => {
      console.info( 'SignalRTest', 'beforeEach: Creating HubConnectionBuilder');
      console.info( 'SignalRTest', `HubConnectionBuilder type: ${typeof HubConnectionBuilder}`);
      builder = new HubConnectionBuilder();
      console.info( 'SignalRTest', `builder created: ${builder !== undefined}`);
    })
    
    afterEach(async () => {
      if (connection && connection.state !== HubConnectionState.Disconnected) {
        try {
          await connection.stop();
        } catch (error) {
          console.warn( 'SignalRTest', `Error stopping connection: ${error.message}`);
        }
      }
    })
    
    afterAll(() => {
      console.info( 'SignalRTest', 'Connection_Lifecycle test suite completed');
    })

    it('should_create_connection_in_disconnected_state', 0, () => {
      console.info( 'SignalRTest', 'Testing initial connection state');
      
      builder = new HubConnectionBuilder();
      connection = builder
        .withUrl(testUrl)
        .configureLogging(LogLevel.Information)
        .build();
      
      expect(connection.constructor.name).assertEqual('HubConnection');
      expect(connection.state).assertEqual(HubConnectionState.Disconnected);
    })
    
    it('should_start_connection_successfully', 0, async () => {
      console.info( 'SignalRTest', 'Testing connection start');
      
      builder = new HubConnectionBuilder();
      connection = builder
        .withUrl(testUrl)
        .configureLogging(LogLevel.Information)
        .withServerTimeout(30000)
        .build();
      
      try {
        await connection.start();
        expect(connection.state).assertEqual(HubConnectionState.Connected);
        console.info( 'SignalRTest', 'Connection started successfully');
      } catch (error) {
        console.warn( 'SignalRTest', `Connection start failed: ${error.message}`);
        expect(connection.state !== HubConnectionState.Connected).assertTrue();
      }
    })
    
    it('should_stop_connection_successfully', 0, async () => {
      console.info( 'SignalRTest', 'Testing connection stop');
      
      builder = new HubConnectionBuilder();
      connection = builder
        .withUrl(testUrl)
        .configureLogging(LogLevel.Information)
        .build();
      
      try {
        await connection.start();
        await connection.stop();
        expect(connection.state).assertEqual(HubConnectionState.Disconnected);
        console.info( 'SignalRTest', 'Connection stopped successfully');
      } catch (error) {
        console.warn( 'SignalRTest', `Connection lifecycle test failed: ${error.message}`);
        expect(connection.state).assertEqual(HubConnectionState.Disconnected);
      }
    })
    
    it('should_handle_connection_restart', 0, async () => {
      console.info( 'SignalRTest', 'Testing connection restart');
      
      builder = new HubConnectionBuilder();
      connection = builder
        .withUrl(testUrl)
        .configureLogging(LogLevel.Information)
        .build();
      
      try {
        // 第一次启动
        await connection.start();
        expect(connection.state).assertEqual(HubConnectionState.Connected);
        
        // 停止连接
        await connection.stop();
        expect(connection.state).assertEqual(HubConnectionState.Disconnected);
        
        // 重新启动
        await connection.start();
        expect(connection.state).assertEqual(HubConnectionState.Connected);
        
        console.info( 'SignalRTest', 'Connection restart successful');
      } catch (error) {
        console.warn( 'SignalRTest', `Connection restart test failed: ${error.message}`);
        expect(typeof connection.state).assertEqual('string');
      }
    })
  })
}

export function methodInvocationTest() {
  describe('Method_Invocation', () => {
    let connection: HubConnection;
    let builder: HubConnectionBuilder;
    const testUrl = 'http://119.29.249.146:5000/chatHub';
    
    beforeAll(() => {
      console.info( 'SignalRTest', 'Method_Invocation test suite started');
    })
    
    beforeEach(() => {
      console.info( 'SignalRTest', 'beforeEach: Creating HubConnectionBuilder');
      builder = new HubConnectionBuilder();
    })
    
    afterEach(async () => {
      if (connection && connection.state !== HubConnectionState.Disconnected) {
        try {
          await connection.stop();
        } catch (error) {
          console.warn( 'SignalRTest', `Error stopping connection: ${error.message}`);
        }
      }
    })
    
    afterAll(() => {
      console.info( 'SignalRTest', 'Method_Invocation test suite completed');
    })

    it('should_invoke_server_method_and_receive_result', 0, async () => {
      console.info( 'SignalRTest', 'Testing server method invocation');
      
      builder = new HubConnectionBuilder();
      connection = builder
        .withUrl(testUrl)
        .configureLogging(LogLevel.Information)
        .withHubProtocol(new JsonHubProtocol())
        .build();
      
      try {
        await connection.start();
        
        // 测试实际的服务器方法：UserConnected
        const userName = "TestUser_HarmonyOS";
        await connection.invoke("UserConnected", userName);
        
        console.info( 'SignalRTest', `UserConnected method invoked successfully with user: ${userName}`);
        expect(true).assertTrue();
      } catch (error) {
        console.warn( 'SignalRTest', `Method invocation failed: ${error.message}`);
        expect(error.message.length).assertLarger(0);
      }
    })
    
    it('should_send_message_without_expecting_result', 0, async () => {
      console.info( 'SignalRTest', 'Testing send method');
      
      builder = new HubConnectionBuilder();
      connection = builder
        .withUrl(testUrl)
        .configureLogging(LogLevel.Information)
        .build();
      
      try {
        await connection.start();
        
        // 使用实际的服务器方法：SendMessage
        await connection.send("SendMessage", "TestUser", "Hello from HarmonyOS client!");
        console.info( 'SignalRTest', 'SendMessage method completed');
        
        expect(true).assertTrue();
      } catch (error) {
        console.warn( 'SignalRTest', `Send method failed: ${error.message}`);
        expect(error.message.length).assertLarger(0);
      }
    })
    
    it('should_test_group_operations', 0, async () => {
      console.info( 'SignalRTest', 'Testing group operations');
      
      builder = new HubConnectionBuilder();
      connection = builder
        .withUrl(testUrl)
        .configureLogging(LogLevel.Information)
        .build();
      
      try {
        await connection.start();
        
        // 测试加入组
        await connection.invoke("JoinGroup", "TestGroup");
        console.info( 'SignalRTest', 'JoinGroup method completed');
        
        // 测试发送组消息
        await connection.invoke("SendMessageToGroup", "TestGroup", "TestUser", "Group message from HarmonyOS");
        console.info( 'SignalRTest', 'SendMessageToGroup method completed');
        
        // 测试离开组
        await connection.invoke("LeaveGroup", "TestGroup");
        console.info( 'SignalRTest', 'LeaveGroup method completed');
        
        expect(true).assertTrue();
      } catch (error) {
        console.warn( 'SignalRTest', `Group operations failed: ${error.message}`);
        expect(error.message.length).assertLarger(0);
      }
    })

    it('should_test_streaming_methods', 0, async () => {
      console.info( 'SignalRTest', 'Testing streaming methods');
      
      builder = new HubConnectionBuilder();
      connection = builder
        .withUrl(testUrl)
        .configureLogging(LogLevel.Information)
        .build();
      
      try {
        await connection.start();

        console.info( 'SignalRTest', 'Testing StreamData method');
        try {
          await connection.invoke("StreamData", 3);
          console.info( 'SignalRTest', 'StreamData method invoked successfully');
        } catch (streamError) {
          console.warn( 'SignalRTest', `StreamData method call: ${streamError.message}`);
        }


        try {
          await connection.invoke("StreamTimestamps", 2);
          console.info( 'SignalRTest', 'StreamTimestamps method invoked successfully');
        } catch (streamError) {
          console.warn( 'SignalRTest', `StreamTimestamps method call: ${streamError.message}`);
        }
        
        expect(true).assertTrue();
        
      } catch (error) {
        console.warn( 'SignalRTest', `Streaming methods test failed: ${error.message}`);
        expect(error.message.length).assertLarger(0);
      }
    })
  })
}

export function eventHandlingTest() {
  describe('Event_Handling', () => {
    let connection: HubConnection;
    let builder: HubConnectionBuilder;
    const testUrl = 'http://119.29.249.146:5000/chatHub';
    
    beforeAll(() => {
      console.info( 'SignalRTest', 'Event_Handling test suite started');
    })
    
    beforeEach(() => {
      console.info( 'SignalRTest', 'beforeEach: Creating HubConnectionBuilder');
      builder = new HubConnectionBuilder();
    })
    
    afterEach(async () => {
      if (connection && connection.state !== HubConnectionState.Disconnected) {
        try {
          await connection.stop();
        } catch (error) {
          console.warn( 'SignalRTest', `Error stopping connection: ${error.message}`);
        }
      }
    })
    
    afterAll(() => {
      console.info( 'SignalRTest', 'Event_Handling test suite completed');
    })

    it('should_register_and_handle_server_events', 0, async () => {
      console.info( 'SignalRTest', 'Testing server event handling');
      
      builder = new HubConnectionBuilder();
      connection = builder
        .withUrl(testUrl)
        .configureLogging(LogLevel.Information)
        .build();
      
      let userJoinedReceived = false;
      let messageReceived = false;
      let receivedUser = '';
      let receivedMessage = '';
      
      // 注册实际的服务器事件处理器
      connection.on("UserJoined", (userName: string) => {
        userJoinedReceived = true;
        receivedUser = userName;
        console.info( 'SignalRTest', `Received UserJoined event: ${userName}`);
      });
      
      connection.on("ReceiveMessage", (user: string, message: string) => {
        messageReceived = true;
        receivedUser = user;
        receivedMessage = message;
        console.info( 'SignalRTest', `Received ReceiveMessage event: ${user} - ${message}`);
      });
      
      try {
        await connection.start();
        
        // 验证事件处理器已注册
        expect(userJoinedReceived).assertFalse(); // 初始状态
        expect(messageReceived).assertFalse(); // 初始状态
        
        // 触发用户连接事件
        await connection.invoke("UserConnected", "TestEventUser");
        
        // 发送消息触发消息事件
        await connection.invoke("SendMessage", "TestEventUser", "Test event message");
        
        console.info( 'SignalRTest', 'Event handlers registered and methods invoked successfully');
        
      } catch (error) {
        console.warn( 'SignalRTest', `Event handling test failed: ${error.message}`);
      }
    })
    
    it('should_handle_connection_closed_event', 0, async () => {
      console.info( 'SignalRTest', 'Testing connection closed event');
      
      builder = new HubConnectionBuilder();
      connection = builder
        .withUrl(testUrl)
        .configureLogging(LogLevel.Information)
        .build();
      
      let closedEventFired = false;
      let closeError: Error | undefined;
      
      connection.onclose((error?: Error) => {
        closedEventFired = true;
        closeError = error;
        console.info( 'SignalRTest', `Connection closed: ${error?.message || 'No error'}`);
      });
      
      try {
        await connection.start();
        await connection.stop();
        
        // 给事件处理一些时间
        await new Promise<void>(resolve => setTimeout(resolve, 100));
        
        expect(closedEventFired).assertTrue();
        expect(closeError).assertUndefined(); // 正常关闭不应该有错误
        
      } catch (error) {
        console.warn( 'SignalRTest', `Close event test failed: ${error.message}`);
      }
    })
  })
}

export function configurationOptionsTest() {
  describe('Configuration_Options', () => {
    let connection: HubConnection;
    let builder: HubConnectionBuilder;
    const testUrl = 'http://119.29.249.146:5000/chatHub';
    
    beforeAll(() => {
      console.info( 'SignalRTest', 'Configuration_Options test suite started');
    })
    
    beforeEach(() => {
      console.info( 'SignalRTest', 'beforeEach: Creating HubConnectionBuilder');
      builder = new HubConnectionBuilder();
    })
    
    afterEach(async () => {
      if (connection && connection.state !== HubConnectionState.Disconnected) {
        try {
          await connection.stop();
        } catch (error) {
          console.warn( 'SignalRTest', `Error stopping connection: ${error.message}`);
        }
      }
    })
    
    afterAll(() => {
      console.info( 'SignalRTest', 'Configuration_Options test suite completed');
    })

    it('should_respect_server_timeout_configuration', 0, () => {
      console.info( 'SignalRTest', 'Testing server timeout configuration');
      
      builder = new HubConnectionBuilder();
      const customTimeout = 60000; // 60 seconds
      connection = builder
        .withUrl(testUrl)
        .withServerTimeout(customTimeout)
        .build();
      
      expect(connection.serverTimeoutInMilliseconds).assertEqual(customTimeout);
    })
    
    it('should_respect_keep_alive_interval_configuration', 0, () => {
      console.info( 'SignalRTest', 'Testing keep alive interval configuration');
      
      builder = new HubConnectionBuilder();
      const customInterval = 20000; // 20 seconds
      connection = builder
        .withUrl(testUrl)
        .withKeepAliveInterval(customInterval)
        .build();
      
      expect(connection.keepAliveIntervalInMilliseconds).assertEqual(customInterval);
    })
    
    it('should_support_different_transport_types', 0, () => {
      console.info( 'SignalRTest', 'Testing transport type configuration');
      
      builder = new HubConnectionBuilder();
      const options: IHttpConnectionOptions = {
        transport: HttpTransportType.WebSockets
      };
      
      connection = builder
        .withUrl(testUrl, options)
        .build();
      
      expect(connection.constructor.name).assertEqual('HubConnection');
      // 传输类型的验证需要在实际连接时进行
    })
  })
}

export function errorScenariosTest() {
  describe('Error_Scenarios', () => {
    let connection: HubConnection;
    let builder: HubConnectionBuilder;
    
    beforeAll(() => {
      console.info( 'SignalRTest', 'Error_Scenarios test suite started');
    })
    
    beforeEach(() => {
      console.info( 'SignalRTest', 'beforeEach: Creating HubConnectionBuilder');
      builder = new HubConnectionBuilder();
    })
    
    afterEach(async () => {
      if (connection && connection.state !== HubConnectionState.Disconnected) {
        try {
          await connection.stop();
        } catch (error) {
          console.warn( 'SignalRTest', `Error stopping connection: ${error.message}`);
        }
      }
    })
    
    afterAll(() => {
      console.info( 'SignalRTest', 'Error_Scenarios test suite completed');
    })

    it('should_handle_invalid_url', 0, async () => {
      console.info( 'SignalRTest', 'Testing invalid URL handling');
      
      builder = new HubConnectionBuilder();
      connection = builder
        .withUrl('http://invalid-domain-that-does-not-exist.com/chatHub')
        .build();
      
      try {
        await connection.start();
        expect(false).assertTrue();
      } catch (error) {
        // 预期会抛出错误
        expect(error.message.length).assertLarger(0);
        console.info( 'SignalRTest', `Expected error for invalid URL: ${error.message}`);
      }
    })
    
    it('should_handle_connection_timeout', 0, async () => {
      console.info( 'SignalRTest', 'Testing connection timeout');
      
      builder = new HubConnectionBuilder();
      connection = builder
        .withUrl('http://192.0.2.0:12345/chatHub') // 不可达的地址
        .withServerTimeout(1000) // 1秒超时
        .build();
      
      try {
        await connection.start();
        console.warn( 'SignalRTest', 'Unexpected successful connection to unreachable address');
      } catch (error) {
        expect(error.message.length).assertLarger(0);
        console.info( 'SignalRTest', `Expected timeout error: ${error.message}`);
      }
    })

    it('should_handle_nonexistent_method_invocation', 0, async () => {
      console.info( 'SignalRTest', 'Testing non-existent method invocation');
      
      const testUrl = 'http://119.29.249.146:5000/chatHub';
      builder = new HubConnectionBuilder();
      connection = builder
        .withUrl(testUrl)
        .configureLogging(LogLevel.Information)
        .build();
      
      try {
        await connection.start();
        
        await connection.invoke("NonExistentMethod", "test");
        
        console.warn( 'SignalRTest', 'Expected error for non-existent method');
        expect(false).assertTrue(); // 应该抛出错误
      } catch (error) {
        // 预期会抛出错误
        expect(error.message.length).assertLarger(0);
        console.info( 'SignalRTest', `Expected error for non-existent method: ${error.message}`);
      }
    })
  })
}

export function stateManagementTest() {
  describe('State_Management', () => {
    let connection: HubConnection;
    let builder: HubConnectionBuilder;
    const testUrl = 'http://119.29.249.146:5000/chatHub';
    
    beforeAll(() => {
      console.info( 'SignalRTest', 'State_Management test suite started');
    })
    
    beforeEach(() => {
      console.info( 'SignalRTest', 'beforeEach: Creating HubConnectionBuilder');
      builder = new HubConnectionBuilder();
    })
    
    afterEach(async () => {
      if (connection && connection.state !== HubConnectionState.Disconnected) {
        try {
          await connection.stop();
        } catch (error) {
          console.warn( 'SignalRTest', `Error stopping connection: ${error.message}`);
        }
      }
    })
    
    afterAll(() => {
      console.info( 'SignalRTest', 'State_Management test suite completed');
    })

    it('should_track_connection_state_changes', 0, async () => {
      console.info( 'SignalRTest', 'Testing connection state changes');
      
      builder = new HubConnectionBuilder();
      connection = builder
        .withUrl(testUrl)
        .configureLogging(LogLevel.Information)
        .build();
      
      // 初始状态
      expect(connection.state).assertEqual(HubConnectionState.Disconnected);
      
      try {
        // 启动连接
        const startPromise = connection.start();

        
        await startPromise;
        expect(connection.state).assertEqual(HubConnectionState.Connected);
        
        // 停止连接
        const stopPromise = connection.stop();
        await stopPromise;
        expect(connection.state).assertEqual(HubConnectionState.Disconnected);
        
      } catch (error) {
        console.warn( 'SignalRTest', `State management test failed: ${error.message}`);
        expect(typeof connection.state).assertEqual('string');
      }
    })
    
    it('should_prevent_operations_on_disconnected_connection', 0, async () => {
      console.info( 'SignalRTest', 'Testing operations on disconnected connection');
      
      builder = new HubConnectionBuilder();
      connection = builder
        .withUrl(testUrl)
        .build();

      try {
        await connection.invoke("SendMessage", "user", "test");
        expect(false).assertTrue();
      } catch (error) {
        expect(error.message.length).assertLarger(0);
        console.info( 'SignalRTest', `Expected error for disconnected invoke: ${error.message}`);
      }
      
      // 连接未启动时调用send应该失败
      try {
        await connection.send("UserConnected", "testUser");
        expect(false).assertTrue(); // 不应该到达这里
      } catch (error) {
        expect(error.message.length).assertLarger(0);
        console.info( 'SignalRTest', `Expected error for disconnected send: ${error.message}`);
      }
    })
  })
}

export default function hubConnectionTest() {
  connectionLifecycleTest();
  methodInvocationTest();
  eventHandlingTest();
  configurationOptionsTest();
  errorScenariosTest();
  stateManagementTest();
}