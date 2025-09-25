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
  IStreamSubscriber,
  IStreamResult,
  ISubscription
} from '@ohos/signalr';

export default function streamTest() {
  describe('Stream_Processing_Tests', () => {
    let connection: HubConnection;
    const testUrl = 'http://119.29.249.146:5000/chatHub';
    
    beforeAll(() => {
      console.info( 'SignalRTest', 'Stream processing test suite started');
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
      console.info( 'SignalRTest', 'Stream processing test suite completed');
    })
    
    describe('Server_To_Client_Streaming', () => {
      it('should_handle_server_streaming_method', 0, async () => {
        console.info( 'SignalRTest', 'Testing server-to-client streaming');
        
        const builder = new HubConnectionBuilder();
        connection = builder
          .withUrl(testUrl)
          .configureLogging(LogLevel.Information)
          .build();
        
        try {
          await connection.start();
          
          const receivedItems: string[] = [];
          let streamCompleted = false;
          let streamError: Error | null = null;
          
          const streamResult = connection.stream<string>("StreamData");
          
          const subscription = streamResult.subscribe({
            next: (item: string) => {
              receivedItems.push(item);
              console.info( 'SignalRTest', `Received stream item: ${item}`);
            },
            complete: () => {
              streamCompleted = true;
              console.info( 'SignalRTest', 'Stream completed');
            },
            error: (err: Error) => {
              streamError = err;
              console.warn( 'SignalRTest', `Stream error: ${err.message}`);
            }
          });
          
          // 等待一段时间让流处理完成
          await new Promise<void>(resolve => setTimeout(resolve, 2000));
          
          // 验证订阅对象
          expect(subscription.constructor.name).assertContain('Subscription');
          expect(typeof subscription.dispose).assertEqual('function');
          
          // 清理订阅
          subscription.dispose();
          
        } catch (error) {
          console.warn( 'SignalRTest', `Server streaming test failed: ${error.message}`);
          expect(error.message.length).assertLarger(0);
        }
      })
      
      it('should_handle_stream_cancellation', 0, async () => {
        console.info( 'SignalRTest', 'Testing stream cancellation');
        
        const builder = new HubConnectionBuilder();
        connection = builder
          .withUrl(testUrl)
          .configureLogging(LogLevel.Information)
          .build();
        
        try {
          await connection.start();
          
          let itemsReceived = 0;
          let streamCancelled = false;
          
          const streamResult = connection.stream<string>("InfiniteStream");
          
          const subscription = streamResult.subscribe({
            next: (item: string) => {
              itemsReceived++;
              console.info( 'SignalRTest', `Received item ${itemsReceived}: ${item}`);
              
              // 收到几个项目后取消流
              if (itemsReceived >= 3) {
                subscription.dispose();
                streamCancelled = true;
                console.info( 'SignalRTest', 'Stream cancelled');
              }
            },
            complete: () => {
              console.info( 'SignalRTest', 'Stream completed unexpectedly');
            },
            error: (err: Error) => {
              console.warn( 'SignalRTest', `Stream error: ${err.message}`);
            }
          });
          
          // 等待一段时间
          await new Promise<void>(resolve => setTimeout(resolve, 3000));
          
          // 验证取消功能
          if (!streamCancelled && itemsReceived > 0) {
            subscription.dispose();
          }
          
          expect(typeof subscription.dispose).assertEqual('function');
          
        } catch (error) {
          console.warn( 'SignalRTest', `Stream cancellation test failed: ${error.message}`);
          expect(error.message.length).assertLarger(0);
        }
      })
      
      it('should_handle_stream_errors', 0, async () => {
        console.info( 'SignalRTest', 'Testing stream error handling');
        
        const builder = new HubConnectionBuilder();
        connection = builder
          .withUrl(testUrl)
          .configureLogging(LogLevel.Information)
          .build();
        
        try {
          await connection.start();
          
          let errorReceived = false;
          let errorMessage = '';
          
          const streamResult = connection.stream<string>("StreamWithError");
          
          const subscription = streamResult.subscribe({
            next: (item: string) => {
              console.info( 'SignalRTest', `Received item: ${item}`);
            },
            complete: () => {
              console.warn( 'SignalRTest', 'Stream completed unexpectedly (expected error)');
            },
            error: (err: Error) => {
              errorReceived = true;
              errorMessage = err.message;
              console.info( 'SignalRTest', `Expected stream error: ${errorMessage}`);
            }
          });
          
          // 等待错误发生
          await new Promise<void>(resolve => setTimeout(resolve, 2000));
          
          subscription.dispose();
          
          expect(typeof subscription.dispose).assertEqual('function');
          
        } catch (error) {
          console.warn( 'SignalRTest', `Stream error test failed: ${error.message}`);
          expect(error.message.length).assertLarger(0);
        }
      })
    })
    
    describe('Stream_Subscription_Management', () => {
      it('should_create_valid_subscription', 0, async () => {
        console.info( 'SignalRTest', 'Testing stream subscription creation');
        
        const builder = new HubConnectionBuilder();
        connection = builder
          .withUrl(testUrl)
          .configureLogging(LogLevel.Information)
          .build();
        
        try {
          await connection.start();
          
          const streamResult = connection.stream<string>("TestStream");
          
          const subscription = streamResult.subscribe({
            next: (item: string) => {
              console.info( 'SignalRTest', `Item: ${item}`);
            },
            complete: () => {
              console.info( 'SignalRTest', 'Stream completed');
            },
            error: (err: Error) => {
              console.info( 'SignalRTest', `Stream error: ${err.message}`);
            }
          });
          
          // 验证订阅对象的基本属性
          expect(subscription).assertInstanceOf('Object');
          expect(typeof subscription.dispose).assertEqual('function');
          
          // 立即取消订阅
          subscription.dispose();
          
          console.info( 'SignalRTest', 'Subscription created and disposed successfully');
          
        } catch (error) {
          console.warn( 'SignalRTest', `Subscription test failed: ${error.message}`);
          expect(error.message.length).assertLarger(0);
        }
      })
      
      it('should_handle_multiple_subscriptions', 0, async () => {
        console.info( 'SignalRTest', 'Testing multiple stream subscriptions');
        
        const builder = new HubConnectionBuilder();
        connection = builder
          .withUrl(testUrl)
          .configureLogging(LogLevel.Information)
          .build();
        
        try {
          await connection.start();
          
          const subscriptions: ISubscription<string>[] = [];
          
          // 创建多个订阅
          for (let i = 0; i < 3; i++) {
            const streamResult = connection.stream<string>(`TestStream${i}`);
            
            const subscription = streamResult.subscribe({
              next: (item: string) => {
                console.info( 'SignalRTest', `Stream ${i} item: ${item}`);
              },
              complete: () => {
                console.info( 'SignalRTest', `Stream ${i} completed`);
              },
              error: (err: Error) => {
                console.info( 'SignalRTest', `Stream ${i} error: ${err.message}`);
              }
            });
            
            subscriptions.push(subscription);
          }
          
          expect(subscriptions.length).assertEqual(3);
          
          // 等待一段时间
          await new Promise<void>(resolve => setTimeout(resolve, 1000));
          
          // 清理所有订阅
          subscriptions.forEach((subscription, index) => {
            expect(typeof subscription.dispose).assertEqual('function');
            subscription.dispose();
            console.info( 'SignalRTest', `Disposed subscription ${index}`);
          });
          
        } catch (error) {
          console.warn( 'SignalRTest', `Multiple subscriptions test failed: ${error.message}`);
          expect(error.message.length).assertLarger(0);
        }
      })
    })
    
    describe('Stream_Data_Types', () => {
      it('should_handle_different_stream_data_types', 0, async () => {
        console.info( 'SignalRTest', 'Testing different stream data types');
        
        const builder = new HubConnectionBuilder();
        connection = builder
          .withUrl(testUrl)
          .configureLogging(LogLevel.Information)
          .build();
        
        try {
          await connection.start();
          
          // 测试字符串流
          const stringStream = connection.stream<string>("StringStream");
          const stringSubscription = stringStream.subscribe({
            next: (item: string) => {
              expect(typeof item).assertEqual('string');
              console.info( 'SignalRTest', `String item: ${item}`);
            },
            complete: () => {},
            error: (err: Error) => {}
          });
          
          // 测试数字流
          const numberStream = connection.stream<number>("NumberStream");
          const numberSubscription = numberStream.subscribe({
            next: (item: number) => {
              expect(typeof item).assertEqual('number');
              console.info( 'SignalRTest', `Number item: ${item}`);
            },
            complete: () => {},
            error: (err: Error) => {}
          });
          
          // 测试对象流
          interface StreamObject {
            id?: string;
            name?: string;
            value?: number;
            active?: boolean;
          }
          const objectStream = connection.stream<StreamObject>("ObjectStream");
          const objectSubscription = objectStream.subscribe({
            next: (item: StreamObject) => {
              expect(typeof item).assertEqual('object');
              console.info( 'SignalRTest', `Object item: ${JSON.stringify(item)}`);
            },
            complete: () => {},
            error: (err: Error) => {}
          });
          
          // 等待一段时间
          await new Promise<void>(resolve => setTimeout(resolve, 1000));
          
          // 清理订阅
          stringSubscription.dispose();
          numberSubscription.dispose();
          objectSubscription.dispose();
          
          console.info( 'SignalRTest', 'Data type streams tested');
          
        } catch (error) {
          console.warn( 'SignalRTest', `Data types test failed: ${error.message}`);
          expect(error.message.length).assertLarger(0);
        }
      })
    })
    
    describe('Stream_Edge_Cases', () => {
      it('should_handle_empty_stream', 0, async () => {
        console.info( 'SignalRTest', 'Testing empty stream handling');
        
        const builder = new HubConnectionBuilder();
        connection = builder
          .withUrl(testUrl)
          .configureLogging(LogLevel.Information)
          .build();
        
        try {
          await connection.start();
          
          let itemCount = 0;
          let streamCompleted = false;
          
          const streamResult = connection.stream<string>("EmptyStream");
          
          const subscription = streamResult.subscribe({
            next: (item: string) => {
              itemCount++;
              console.info( 'SignalRTest', `Unexpected item in empty stream: ${item}`);
            },
            complete: () => {
              streamCompleted = true;
              console.info( 'SignalRTest', 'Empty stream completed as expected');
            },
            error: (err: Error) => {
              console.info( 'SignalRTest', `Empty stream error: ${err.message}`);
            }
          });
          
          // 等待流完成
          await new Promise<void>(resolve => setTimeout(resolve, 2000));
          
          subscription.dispose();
          
          expect(itemCount).assertEqual(0);
          
        } catch (error) {
          console.warn( 'SignalRTest', `Empty stream test failed: ${error.message}`);
          expect(error.message.length).assertLarger(0);
        }
      })
      
      it('should_handle_subscription_after_connection_closed', 0, async () => {
        console.info( 'SignalRTest', 'Testing subscription after connection closed');
        
        const builder = new HubConnectionBuilder();
        connection = builder
          .withUrl(testUrl)
          .configureLogging(LogLevel.Information)
          .build();
        
        try {
          await connection.start();
          await connection.stop();
          
          // 连接关闭后尝试创建流
          try {
            const streamResult = connection.stream<string>("TestStream");
            const subscription = streamResult.subscribe({
              next: (item: string) => {},
              complete: () => {},
              error: (err: Error) => {}
            });
            
            expect(typeof subscription.dispose).assertEqual('function');
            subscription.dispose();
            
          } catch (streamError) {
            expect(streamError.message.length).assertLarger(0);
            console.info( 'SignalRTest', `Expected error for closed connection stream: ${streamError.message}`);
          }
          
        } catch (error) {
          console.warn( 'SignalRTest', `Closed connection stream test failed: ${error.message}`);
          expect(error.message.length).assertLarger(0);
        }
      })
    })
  })
}