/*
 * Copyright (c) 2021 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the 'License');
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *   http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an 'AS IS' BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import EventEmitter from 'eventemitter3'

@Entry
@Component
struct EventSequencing {
  @State message: string = getContext().resourceManager.getStringByNameSync('Message_Listen')
  @State state: string = getContext().resourceManager.getStringByNameSync('State_Message')
  @State emitter: EventEmitter<string, Object> | undefined = undefined;

  aboutToAppear() {
    const ctx = this
    ctx.emitter = new EventEmitter<string, Object>();
    ctx.emitter.on('event', (name: string, age: number, message: string) => {
      console.log(`Listener 1: ${name} is ${age} years old`);
      ctx.state = ctx.state + "\r\n" + `aboutToAppear recive data,name:${name},age:${age},message:${message}`
    });


  }

  onPageShow() {
    const ctx = this
    let emitterInstance = this.emitter;
    if (emitterInstance) {
      emitterInstance.on('event', (name: string, age: number, message: string) => {
        console.log(`Listener 2: ${name} is ${age} years old`);
        ctx.state = ctx.state + "\r\n" + `onPageShow recive data,name:${name},age:${age},message:${message}`
      });
    }
  }

  build() {
    Row() {
      Column() {
        Text(this.message)
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
          .width('100%')
          .textAlign(TextAlign.Center)
          .padding(10)

        Button($r('app.string.Button_Send'))
          .width('100%')
          .height(50)
          .backgroundColor(Color.Blue)
          .fontColor(Color.White)
          .margin(20)
          .onClick(() => {
            this.startSendEvent()
          })

        Text(this.state)
          .width('100%')
          .backgroundColor(Color.Red)
          .fontColor(Color.White)
          .margin(20)


      }
      .width('100%')
    }
    .height('100%')
  }

  startSendEvent() {
    const ctx = this
    let emitterInstance = ctx.emitter;
    if (!emitterInstance) {
      return;
    }
    emitterInstance.on('event', (name: string, age: number, message: string) => {
      console.log(`Listener 3: ${name} is ${age} years old`);
      ctx.state = ctx.state + "\r\n" + `startSendEvent---1---recive,name:${name},age:${age},message:${message}`
      name = "ali"
      age = Number(age) + 30;
      message = '111112222333'
      // ctx.emitter.emit('event', '张三', 64, "这是倒数第二个监听器，修改信息试试");
    });
    emitterInstance.on('event', (name: string, age: number, message: string) => {
      console.log(`Listener 4: ${name} is ${age} years old`);
      ctx.state = ctx.state + "\r\n" + `startSendEvent---2---recive,name:${name},age:${age},message:${message}`
    });
    emitterInstance.emit('event', 'Tom', 18, getContext().resourceManager.getStringByNameSync('Emit_String1') );
  }
}