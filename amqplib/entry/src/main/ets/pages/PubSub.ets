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
const exchangeName = 'fanoutExchange';
const exchangeType = Contents.exchangeType_fanout;
//定义队列
const queueName = 'myQueue';
//绑定队列到交换机
const routingKey = 'myRoutingKey';

@Entry
@Component
struct PubSub {
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
    console.log('Connected to RabbitMQ server');
    this.channel = await this.connection.createChannel();
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
    this.connection?.close()
    this.channel?.close()
  }
  build() {
    Row() {
      Column() {
        Console({ model: $consoleSend }).height('40%')
        Button($r('app.string.Publish_a_message')).onClick(async () => {
          // 发布消息
          const message = 'Hello, World!';
          const publishOptions: Options.Publish = { persistent: true };
          let isPush: boolean | undefined = this.channel?.publish(exchangeName, routingKey, Buffer.from(message), publishOptions);
          this.consoleSend.info('publish message:' + isPush)
        })
        Console({ model: $consoleReceive }).height('40%')
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