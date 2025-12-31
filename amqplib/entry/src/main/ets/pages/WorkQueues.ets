/*
 * Copyright (C) 2024 Huawei Device Co., Ltd.
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

import { Options, Channel, Connection, ConsumeMessage, connect } from '@ohos/amqplib';
import { buffer } from '@ohos/node-polyfill';
import { Unit8ArrayUtils } from './Unit8ArrayUtils';
import ConsoleN from '../components/ConsoleN';
import { Console } from '../components/Console';
import { Contents } from '../Contents';

const Buffer: ESObject = buffer.Buffer;
//定义交换机
const exchangeName = 'directExchange';
const exchangeType = Contents.exchangeType_direct;
//定义队列
const queueName = 'myQueue';
//绑定队列到交换机
const routingKey = 'myRoutingKey';

@Entry
@Component
struct WorkQueues {
  @State consoleReceive: ConsoleN.Model = new ConsoleN.Model();
  @State consoleSend: ConsoleN.Model = new ConsoleN.Model();
  @State serverIp: string = Contents.serverIp
  connection: Connection | null = null
  channel: Channel | null = null

  async connect() {
    this.connection = await connect(`amqp://admin:123456@${this.serverIp}:5672`);
    this.connection?.on('close', () => {
      console.log('on close: Connection closed');
    })
    this.connection?.on('error', (err: Error) => {
      console.log('on error: Connection error: ' + err.message);
    })
    this.connection?.on('blocked', (reason: string) => {
      console.log('Connection blocked: ' + reason);
    })
    this.connection?.on('unblocked', () => {
      console.log('Connection unblocked');
    })
    this.connection?.on('update-secret-ok', () => {
      console.log('Connection secret updated');
    })
    console.log('Connected to RabbitMQ server');
    this.channel = await this.connection.createChannel();
    this.channel?.on('error', (err: Error) => {
      console.log('Channel error: ' + err.message);
    })
    this.channel?.on('close', () => {
      console.log('Channel closed event');
    })
    this.channel?.on('return', (msg: ESObject) => {
      console.log('Message returned: ' + JSON.stringify(msg));
    })
    this.channel?.on('drain', () => {
      console.log('Channel drained');
    })

    // 定义交换机
    const exchangeOptions: Options.AssertExchange = { durable: true };
    await this.channel.assertExchange(exchangeName, exchangeType, exchangeOptions);

    // 定义队列
    const queueOptions: Options.AssertQueue = { durable: true };
    await this.channel.assertQueue(queueName, queueOptions);

    // 绑定队列到交换机
    await this.channel.bindQueue(queueName, exchangeName, routingKey);
  };

  aboutToAppear() {
    this.connect()
  }
  aboutToDisappear(){
    this.channel?.close().then(()=>{
      console.log('Channel closed');
      this.connection?.close().then(()=>{
        console.log('then close: Connection closed');
      }).catch((err: Error)=>{
        console.log('catch close:Connection close err:' + err.message)
      })
    }).catch(( err: Error)=>{
      console.log('Channel close err:' + err.message)
    })
  }
  build() {
    Row() {
      Column() {
        Console({ model: $consoleSend }).height('30%')
        Button($r('app.string.Publish_a_message')).onClick(async () => {
          // 发布消息
          const message = 'Hello, World!';
          const publishOptions: Options.Publish = { persistent: true };
          let isPush: boolean | undefined = this.channel?.publish(exchangeName, routingKey, Buffer.from(message), publishOptions);
          let isPush2: boolean | undefined = this.channel?.publish(exchangeName, routingKey, Buffer.from(message+'2'), publishOptions);
          this.consoleSend.info('publish message:' + isPush)
          this.consoleSend.info('publish message:' + isPush2)
        })
        Button('触发return事件').onClick(async () => {
          // 发送到不存在的路由键，触发return事件
          const publishOptions: Options.Publish = { mandatory: true };
          this.channel?.publish(exchangeName, 'nonexistent-key', Buffer.from('test'), publishOptions);
          this.consoleSend.info('已发送mandatory消息到不存在的路由')
        })
        Button('触发channel error').onClick(async () => {
          // 声明一个已存在但参数不同的队列，会导致服务器关闭channel并触发error
          try {
            const conflictOptions: Options.AssertQueue = { 
              durable: false,  // 与原队列的durable:true冲突
              exclusive: true 
            };
            await this.channel?.assertQueue(queueName, conflictOptions);
          } catch (err) {
            this.consoleSend.info('catch到错误，同时应该触发error事件')
          }
        })
        Console({ model: $consoleReceive }).height('30%')
        Button($r('app.string.Consumer_News')).onClick(async () => {
          // 消费消息
          const consumeOptions: Options.Consume = { noAck: false };
          await this.channel?.consume(queueName, (msg: ConsumeMessage | null) => {
            this.consoleReceive.log('Received message: ' + Unit8ArrayUtils.Uint8ArrayToString(msg?.content));
            this.channel?.ack(msg);
          }, consumeOptions);
        })
      }.width('100%')
    }.height('100%')
  }
}