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
import { HubConnectionBuilder, LogLevel, HubConnection, IHttpConnectionOptions, MessageHeaders } from '@ohos/signalr';

export default function hubConnectionBuilderTest() {
  describe('HubConnectionBuilder_Tests', () => {
    let builder: HubConnectionBuilder;
    
    beforeAll(() => {
      console.info( 'SignalRTest', 'HubConnectionBuilder test suite started');
    })
    
    beforeEach(() => {
      builder = new HubConnectionBuilder();
    })
    
    afterEach(() => {
      // 清理资源
    })
    
    afterAll(() => {
      console.info( 'SignalRTest', 'HubConnectionBuilder test suite completed');
    })
    
    it('should_create_HubConnectionBuilder_instance', 0, () => {
      console.info( 'SignalRTest', 'Testing HubConnectionBuilder instance creation');
      expect(builder.constructor.name).assertEqual('HubConnectionBuilder');
    })
    
    it('should_configure_URL_correctly', 0, () => {
      console.info( 'SignalRTest', 'Testing URL configuration');
      
      const testUrl = 'http://119.29.249.146:5000/chatHub';
      const connectionBuilder = builder.withUrl(testUrl);
      
      // withUrl 应该返回 builder 实例以支持链式调用
      expect(connectionBuilder.constructor.name).assertEqual('HubConnectionBuilder');
    })
    
    it('should_configure_URL_with_options_correctly', 0, () => {
      console.info( 'SignalRTest', 'Testing URL configuration with options');
      
      const testUrl = 'http://119.29.249.146:5000/chatHub';
      const headers: MessageHeaders = { 'User-Agent': 'HarmonyOS-SignalR-Client/1.0' };
      const options: IHttpConnectionOptions = {
        headers: headers,
        skipNegotiation: false,
        transport: undefined
      };
      
      const connectionBuilder = builder.withUrl(testUrl, options);
      
      expect(connectionBuilder.constructor.name).assertEqual('HubConnectionBuilder');
    })
    
    it('should_configure_logging_level_correctly', 0, () => {
      console.info( 'SignalRTest', 'Testing logging configuration');
      
      const connectionBuilder = builder.configureLogging(LogLevel.Debug);
      
      expect(connectionBuilder.constructor.name).assertEqual('HubConnectionBuilder');
    })
    
    it('should_configure_different_logging_levels', 0, () => {
      console.info( 'SignalRTest', 'Testing different logging levels');
      
      const logLevels = [
        LogLevel.None,
        LogLevel.Critical,
        LogLevel.Error,
        LogLevel.Warning,
        LogLevel.Information,
        LogLevel.Debug,
        LogLevel.Trace
      ];
      
      logLevels.forEach((level) => {
        const connectionBuilder = builder.configureLogging(level);
        expect(connectionBuilder.constructor.name).assertEqual('HubConnectionBuilder');
      });
    })
    
    it('should_configure_server_timeout_correctly', 0, () => {
      console.info( 'SignalRTest', 'Testing server timeout configuration');
      
      const timeout = 30000; // 30 seconds
      const connectionBuilder = builder.withServerTimeout(timeout);
      
      expect(connectionBuilder.constructor.name).assertEqual('HubConnectionBuilder');
    })
    
    it('should_configure_keep_alive_interval_correctly', 0, () => {
      console.info( 'SignalRTest', 'Testing keep alive interval configuration');
      
      const interval = 15000; // 15 seconds
      const connectionBuilder = builder.withKeepAliveInterval(interval);
      
      expect(connectionBuilder.constructor.name).assertEqual('HubConnectionBuilder');
    })
    
    it('should_configure_automatic_reconnect_correctly', 0, () => {
      console.info( 'SignalRTest', 'Testing automatic reconnect configuration');
      
      const delays = [0, 2000, 10000, 30000];
      const connectionBuilder = builder.withAutomaticReconnect(delays);
      
      expect(connectionBuilder.constructor.name).assertEqual('HubConnectionBuilder');
    })
    
    it('should_configure_automatic_reconnect_with_default_delays', 0, () => {
      console.info( 'SignalRTest', 'Testing automatic reconnect with default delays');
      
      const connectionBuilder = builder.withAutomaticReconnect();
      
      expect(connectionBuilder.constructor.name).assertEqual('HubConnectionBuilder');
    })
    
    it('should_support_method_chaining', 0, () => {
      console.info( 'SignalRTest', 'Testing method chaining');
      
      const connectionBuilder = builder
        .withUrl('http://119.29.249.146:5000/chatHub')
        .configureLogging(LogLevel.Debug)
        .withServerTimeout(30000)
        .withKeepAliveInterval(15000)
        .withAutomaticReconnect([0, 2000, 10000]);
      
      expect(connectionBuilder.constructor.name).assertEqual('HubConnectionBuilder');
    })
    
    it('should_build_HubConnection_instance', 0, () => {
      console.info( 'SignalRTest', 'Testing HubConnection building');
      
      const connection = builder
        .withUrl('http://119.29.249.146:5000/chatHub')
        .configureLogging(LogLevel.Information)
        .build();
      
      expect(connection.constructor.name).assertEqual('HubConnection');
    })
    
    it('should_build_connection_with_all_configurations', 0, () => {
      console.info( 'SignalRTest', 'Testing full configuration build');
      
      const authHeaders: MessageHeaders = { 'Authorization': 'Bearer token123' };
      const authOptions: IHttpConnectionOptions = {
        headers: authHeaders,
        skipNegotiation: true
      };
      
      const connection = builder
        .withUrl('http://119.29.249.146:5000/chatHub', authOptions)
        .configureLogging(LogLevel.Warning)
        .withServerTimeout(60000)
        .withKeepAliveInterval(10000)
        .withAutomaticReconnect([1000, 5000, 10000, 30000])
        .build();
      
      expect(connection.constructor.name).assertEqual('HubConnection');
    })
    
    it('should_handle_edge_case_configurations', 0, () => {
      console.info( 'SignalRTest', 'Testing edge case configurations');
      
      // 测试 0 超时
      const connection1 = builder
        .withUrl('http://119.29.249.146:5000/chatHub')
        .withServerTimeout(0)
        .build();
      
      expect(connection1.constructor.name).assertEqual('HubConnection');
      
      // 测试很大的超时值
      const connection2 = new HubConnectionBuilder()
        .withUrl('http://119.29.249.146:5000/chatHub')
        .withServerTimeout(999999)
        .build();
      
      expect(connection2.constructor.name).assertEqual('HubConnection');
    })
    
    it('should_handle_empty_reconnect_delays_array', 0, () => {
      console.info( 'SignalRTest', 'Testing empty reconnect delays');
      
      const connection = builder
        .withUrl('http://119.29.249.146:5000/chatHub')
        .withAutomaticReconnect([])
        .build();
      
      expect(connection.constructor.name).assertEqual('HubConnection');
    })
    
    it('should_create_multiple_independent_builders', 0, () => {
      console.info( 'SignalRTest', 'Testing multiple builder instances');
      
      const builder1 = new HubConnectionBuilder();
      const builder2 = new HubConnectionBuilder();
      
      const connection1 = builder1
        .withUrl('http://119.29.249.146:5000/chatHub')
        .configureLogging(LogLevel.Debug)
        .build();
      
      const connection2 = builder2
        .withUrl('http://119.29.249.146:5000/chatHub')
        .configureLogging(LogLevel.Error)
        .build();
      
      expect(connection1.constructor.name).assertEqual('HubConnection');
      expect(connection2.constructor.name).assertEqual('HubConnection');
      
      // 两个连接应该是不同的实例
      expect(connection1 === connection2).assertFalse();
    })
  })
}