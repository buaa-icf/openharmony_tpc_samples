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
import buffer from '@ohos.buffer'

@Entry
@Component
struct ApiTest {
  @State message: string = getContext().resourceManager.getStringByNameSync('Message_Result')
  @State state: string = getContext().resourceManager.getStringByNameSync('State_Message')
  @State emitter: EventEmitter<string, Object> | undefined = undefined;

  aboutToAppear() {
    this.emitter = new EventEmitter<string, Object>();
    this.state = this.state + "\r\n" + `Test：new EventEmitter：${(this.emitter != undefined && this.emitter != null)}`
    this.state = this.state + "\r\n" + `<--------------------------------------------->`
  }

  build() {
    Row() {
      Scroll() {
        Column() {
          Text(this.message)
            .fontSize(20)
            .fontWeight(FontWeight.Bold)
            .width('100%')
            .textAlign(TextAlign.Center)
            .padding(10)

          Button($r('app.string.Button_test'))
            .width('100%')
            .height(50)
            .backgroundColor(Color.Blue)
            .fontColor(Color.White)
            .margin(20)
            .onClick(() => {
              this.testApi()
            })

          Text(this.state)
            .width('100%')
            .backgroundColor(Color.Red)
            .fontColor(Color.White)
            .margin(20)


        }
        .width('100%')
      }
    }
    .height('100%')
  }

  testApi(): void {
    const ctx = this
    ctx.state = ctx.state + "\r\n" + getContext().resourceManager.getStringByNameSync('State_Sting1')
    let emitterInstance: EventEmitter<string, Object> | undefined = ctx.emitter;
    if (!emitterInstance) {
      return;
    }
    emitterInstance.on('event', (data: Object) => {
      ctx.state = ctx.state + "\r\n" + `Recive event Callback，data：${data}`
    });
    emitterInstance.emit('event', getContext().resourceManager.getStringByNameSync('Emit_String1'));
    this.state = this.state + "\r\n" + `<--------------------------------------------->`
    ctx.state = ctx.state + "\r\n" + getContext().resourceManager.getStringByNameSync('State_Sting2')
    emitterInstance.emit('before', getContext().resourceManager.getStringByNameSync('Emit_String2'));
    emitterInstance.on('before', (data: Object) => {
      ctx.state = ctx.state + "\r\n" + `Recive before Callback，data：${data}`
    });


    this.state = this.state + "\r\n" + `<--------------------------------------------->`
    ctx.state = ctx.state + "\r\n" + getContext().resourceManager.getStringByNameSync('State_Sting3')
    emitterInstance.on('multi', (data: Object) => {
      ctx.state = ctx.state + "\r\n" + `Recive multi CallBack，data：${data}`
    });
    emitterInstance.emit('multi', "multi first send");
    emitterInstance.emit('multi', "multi second send");
    emitterInstance.emit('multi', "multi 3th send");
    this.state = this.state + "\r\n" + `<--------------------------------------------->`
    ctx.state = ctx.state + "\r\n" + getContext().resourceManager.getStringByNameSync('State_Sting4')
    emitterInstance.once('single', (data: Object) => {
      ctx.state = ctx.state + "\r\n" + `收到事件single回调，数据为：${data}`
    });
    emitterInstance.emit('single', "single first send");
    emitterInstance.emit('single', "single second send");
    emitterInstance.emit('single', "single 3th send");
    this.state = this.state + "\r\n" + `<--------------------------------------------->`
    ctx.state = ctx.state + "\r\n" + getContext().resourceManager.getStringByNameSync('State_Sting5')
    let listener1 = () => {
    }
    let listener2 = () => {
    }
    let listener3 = () => {
    }
    emitterInstance.on('listenNum', listener1);
    emitterInstance.on('listenNum', listener2);
    emitterInstance.once('listenNum', listener3);
    const listeners = emitterInstance.listeners('event');
    const listenerListenNum = emitterInstance.listeners('listenNum');
    ctx.state = ctx.state + "\r\n" + `event counts,expected 1,actual${listeners.length}`
    if (listenerListenNum.length === 3) {
      ctx.state = ctx.state + "\r\n" + `listenNum event counts,expected 3,actual ${listenerListenNum.length},on sucess ,once sucess`
    } else if (listenerListenNum.length === 2) {
      ctx.state = ctx.state + "\r\n" + `listenNum event counts,expected 3,actual ${listenerListenNum.length},on sucess, once error`
    } else if (listenerListenNum.length === 1) {
      ctx.state = ctx.state + "\r\n" + `listenNum event counts,expected 3,actual ${listenerListenNum.length},once sucess, on error`
    } else {
      ctx.state = ctx.state + "\r\n" + `listenNum event counts,expected 3,actual ${listenerListenNum.length},Count Error`
    }
    this.state = this.state + "\r\n" + `<--------------------------------------------->`
    const count = emitterInstance.listenerCount('listenNum');
    ctx.state = ctx.state + "\r\n" + `listenerCount，expected 3,actual ${count}`

    this.state = this.state + "\r\n" + `<--------------------------------------------->`
    emitterInstance.off('listenNum', listener1);
    emitterInstance.off('listenNum', listener2);
    emitterInstance.off('listenNum', listener3);

    const count1 = emitterInstance.listenerCount('listenNum');
    if (count1 === 0) {
      ctx.state = ctx.state + "\r\n" + `original 3,after remove expected is 0,actual ${count1},once sucess`
    } else if (count1 === 1) {
      ctx.state = ctx.state + "\r\n" + `original 3,after remove expected is 0,actual ${count},once error`
    } else {
      ctx.state = ctx.state + "\r\n" + `original 3,after remove expected is 0,actual ${count},Failed to unbind the listener`
    }
    this.state = this.state + "\r\n" + `<--------------------------------------------->`
    ctx.state = ctx.state + "\r\n" + getContext().resourceManager.getStringByNameSync('State_Sting6')
    emitterInstance.addListener('addListener', () => {
      ctx.state = ctx.state + "\r\n" + `Recive addListener Callback`
    });
    emitterInstance.emit("addListener")
    this.state = this.state + "\r\n" + `<--------------------------------------------->`
    ctx.state = ctx.state + "\r\n" + getContext().resourceManager.getStringByNameSync('State_Sting7')
    emitterInstance.emit("callback")
    let callback = (data: Object) => {
      ctx.state = ctx.state + "\r\n" + `Recive callback Callback，data：${data}`
    }
    emitterInstance.addListener('callback', callback);
    this.state = this.state + "\r\n" + `<--------------------------------------------->`


    const count2: number = emitterInstance.listeners('event').length;
    const count3: number = emitterInstance.listeners('before').length;
    const count4: number = emitterInstance.listeners('multi').length;
    const count5: number = emitterInstance.listeners('single').length; // once使用过后即会删除，这里的个数为0
    const count6: number = emitterInstance.listeners('listenNum').length;
    const count7: number = emitterInstance.listeners('addListener').length;
    const count8: number = emitterInstance.listeners('callback').length;
    let total = count2 + count3 + count4 + count5 + count6 + count7 + count8;
    ctx.state = ctx.state + "\r\n" + `Number of events before unbinding all events :${total}`
    this.state = this.state + "\r\n" + `<--------------------------------------------->`

    const names: string[] = emitterInstance.eventNames();

    ctx.state = ctx.state + "\r\n" + `The names before unbinding all events：${JSON.stringify(names)}`
    this.state = this.state + "\r\n" + `<--------------------------------------------->`

    emitterInstance.removeAllListeners();
    const count22: number = emitterInstance.listeners('event').length;
    const count33: number = emitterInstance.listeners('before').length;
    const count44: number = emitterInstance.listeners('multi').length;
    const count55: number = emitterInstance.listeners('single').length;
    const count66: number = emitterInstance.listeners('listenNum').length;
    const count77: number = emitterInstance.listeners('addListener').length;
    const count88: number = emitterInstance.listeners('callback').length;
    let total1 = count22 + count33 + count44 + count55 + count66 + count77 + count88;
    ctx.state = ctx.state + "\r\n" + `unbing API---removeAllListeners，Number of events after unbinding all events: ${total1}`
    this.state = this.state + "\r\n" + `<--------------------------------------------->${'\r\n'}`


    emitterInstance.addListener('newListener', (data: Object) => {
      ctx.state = ctx.state + "\r\n" + `Recive newListener Callback，data：${JSON.stringify(data)}`
    });
    const beforeCount = emitterInstance.listenerCount('newListener');
    const nameBefore = emitterInstance.eventNames();
    ctx.state = ctx.state + "\r\n" + `Unbing API---removeListener，Number of events before unbinding event:${beforeCount}，Name:${JSON.stringify(nameBefore)}}`
    emitterInstance.emit('newListener', {
      name: "ali",
      age: 21,
      isMan: true,
      info: {
        msg: "This test data",
        data: buffer.from("Test whether it supports ArrayBuffer").buffer,
        list: [1, 2, 3, 4]
      }
    })
    emitterInstance.removeListener('newListener');
    const afterCount = emitterInstance.listenerCount('newListener');
    const nameAfter = emitterInstance.eventNames();
    ctx.state = ctx.state + "\r\n" + `Test unbing API---removeListener，Number of events after unbinding all events: ${afterCount}，Name:${JSON.stringify(nameAfter)}}`
    this.state = this.state + "\r\n" + `<--------------------------------------------->${'\r\n'}`
    emitterInstance.on('newListener', () => {
    });
    emitterInstance.on('newListener', () => {
    });
    emitterInstance.on('newListener', () => {
    });
    emitterInstance.on('newListener', () => {
    });
    const beforeCount1 = emitterInstance.listenerCount('newListener');
    const nameBefore1 = emitterInstance.eventNames();
    ctx.state = ctx.state + "\r\n" + getContext().resourceManager.getStringByNameSync('State_Sting8') + `${beforeCount1}，Name:${JSON.stringify(nameBefore1)}}`
    emitterInstance.removeListener('newListener');
    const afterCount1 = emitterInstance.listenerCount('newListener');
    const nameAfter1 = emitterInstance.eventNames();
    ctx.state = ctx.state + "\r\n" + getContext().resourceManager.getStringByNameSync('State_Sting9') + `${afterCount1}，Name：${JSON.stringify(nameAfter1)}}`
    this.state = this.state + "\r\n" + `<--------------------------------------------->${'\r\n'}`
    let obj1 = () => {
    }
    let obj2 = () => {
    }
    let obj3 = () => {
    }
    let obj4 = () => {
    }
    emitterInstance.on('newListener', obj1);
    emitterInstance.on('newListener', obj2);
    emitterInstance.on('newListener', obj3);
    emitterInstance.on('newListener', obj4);
    const beforeCount2 = emitterInstance.listenerCount('newListener');
    const nameBefore3 = emitterInstance.eventNames();
    ctx.state = ctx.state + "\r\n" + getContext().resourceManager.getStringByNameSync('State_Sting10') + `${beforeCount2}，Name:${JSON.stringify(nameBefore3)}}`
    emitterInstance.removeListener('newListener', obj3);
    const afterCount2 = emitterInstance.listenerCount('newListener');
    const nameAfter2 = emitterInstance.eventNames();
    ctx.state = ctx.state + "\r\n" + getContext().resourceManager.getStringByNameSync('State_Sting11') + `${afterCount2}，Name:${JSON.stringify(nameAfter2)}}`
    this.state = this.state + "\r\n" + `<--------------------------------------------->${'\r\n'}`
  }
}