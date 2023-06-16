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
  @State message: string = '对于EventEmitter公开的API进行测试并显示结果'
  @State state: string = '状态信息：\r\n'
  @State emitter: EventEmitter = undefined

  aboutToAppear() {
    this.emitter = new EventEmitter();
    this.state = this.state + "\r\n" + `测试初始化接口：new EventEmitter，看是否成功：${(this.emitter != undefined && this.emitter != null)}`
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

          Button('测试API')
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

  testApi() {
    const ctx = this
    ctx.state = ctx.state + "\r\n" + `测试先订阅事件event,然后发送事件event，看是否收到event事件回调`
    ctx.emitter.on('event', (data) => {
      ctx.state = ctx.state + "\r\n" + `收到事件event回调，数据为：${data}`
    });
    ctx.emitter.emit('event', "这是原始信息");
    this.state = this.state + "\r\n" + `<--------------------------------------------->`
    ctx.state = ctx.state + "\r\n" + `测试先发送事件before,然后订阅事件before，看是否收到before事件回调`
    ctx.emitter.emit('before', "在绑定之前先发送事件");
    ctx.emitter.on('before', (data) => {
      ctx.state = ctx.state + "\r\n" + `收到事件before回调，数据为：${data}`
    });


    this.state = this.state + "\r\n" + `<--------------------------------------------->`
    ctx.state = ctx.state + "\r\n" + `测试先订阅事件multi,然后多次发送事件multi，看是否收到多次multi事件回调`
    ctx.emitter.on('multi', (data) => {
      ctx.state = ctx.state + "\r\n" + `收到事件multi回调，数据为：${data}`
    });
    ctx.emitter.emit('multi', "这是multi第一次发送");
    ctx.emitter.emit('multi', "这是multi第二次发送");
    ctx.emitter.emit('multi', "这是multi第三次发送");
    this.state = this.state + "\r\n" + `<--------------------------------------------->`
    ctx.state = ctx.state + "\r\n" + `测试先once订阅事件single,然后多次发送事件single，看是否收到多次single事件回调`
    ctx.emitter.once('single', (data) => {
      ctx.state = ctx.state + "\r\n" + `收到事件single回调，数据为：${data}`
    });
    ctx.emitter.emit('single', "这是single第一次发送");
    ctx.emitter.emit('single', "这是single第二次发送");
    ctx.emitter.emit('single', "这是single第三次发送");
    this.state = this.state + "\r\n" + `<--------------------------------------------->`
    ctx.state = ctx.state + "\r\n" + `测试获取某个事件listeners数组的API---listeners，看看on绑定和once绑定是否都计数了`
    let listener1 = (data) => {
    }
    let listener2 = (data) => {
    }
    let listener3 = (data) => {
    }
    ctx.emitter.on('listenNum', listener1);
    ctx.emitter.on('listenNum', listener2);
    ctx.emitter.once('listenNum', listener3);
    const listeners = ctx.emitter.listeners('event');
    const listenerListenNum = ctx.emitter.listeners('listenNum');
    ctx.state = ctx.state + "\r\n" + `event事件计数个数，预期为1个，实际为${listeners.length}`
    if (listenerListenNum.length === 3) {
      ctx.state = ctx.state + "\r\n" + `listenNum事件计数个数，预期为3个，实际为${listenerListenNum.length},on和once绑定的listener都计数`
    } else if (listenerListenNum.length === 2) {
      ctx.state = ctx.state + "\r\n" + `listenNum事件计数个数，预期为3个，实际为${listenerListenNum.length},on绑定的listener都计数，once绑定的不计数`
    } else if (listenerListenNum.length === 1) {
      ctx.state = ctx.state + "\r\n" + `listenNum事件计数个数，预期为3个，实际为${listenerListenNum.length},once绑定的listener都计数，on绑定的不计数`
    } else {
      ctx.state = ctx.state + "\r\n" + `listenNum事件计数个数，预期为3个，实际为${listenerListenNum.length},计数错误`
    }
    this.state = this.state + "\r\n" + `<--------------------------------------------->`
    const count = ctx.emitter.listenerCount('listenNum');
    ctx.state = ctx.state + "\r\n" + `测试获取某个事件listeners个数API---listenerCount，预期为3个，实际为${count}`

    this.state = this.state + "\r\n" + `<--------------------------------------------->`
    ctx.emitter.off('listenNum', listener1);
    ctx.emitter.off('listenNum', listener2);
    ctx.emitter.off('listenNum', listener3);

    const count1 = ctx.emitter.listenerCount('listenNum');
    if (count1 === 0) {
      ctx.state = ctx.state + "\r\n" + `测试解除事件绑定API---off，原有绑定接口为3个，解绑后预期为0个，实际为${count1},once绑定的监听器也可解绑`
    } else if (count1 === 1) {
      ctx.state = ctx.state + "\r\n" + `测试解除事件绑定API---off，原有绑定接口为3个，解绑后预期为0个，实际为${count},once绑定的监听器不可解绑`
    } else {
      ctx.state = ctx.state + "\r\n" + `测试解除事件绑定API---off，原有绑定接口为3个，解绑后预期为0个，实际为${count},监听器解绑失败`
    }
    this.state = this.state + "\r\n" + `<--------------------------------------------->`
    ctx.state = ctx.state + "\r\n" + `测试添加事件绑定API---addListener,先添加addListener 然后发送事件addListener，看是否收到addListener事件回调`
    ctx.emitter.addListener('addListener', () => {
      ctx.state = ctx.state + "\r\n" + `收到事件addListener回调`
    });
    ctx.emitter.emit("addListener")
    this.state = this.state + "\r\n" + `<--------------------------------------------->`
    ctx.state = ctx.state + "\r\n" + `测试添加事件绑定API---callback,先发送事件callback,然后添加callback，看是否收到callback事件回调`
    ctx.emitter.emit("callback")
    let callback = (data) => {
      ctx.state = ctx.state + "\r\n" + `收到事件callback回调，数据为：${data}`
    }
    ctx.emitter.addListener('callback', callback);
    this.state = this.state + "\r\n" + `<--------------------------------------------->`


    const count2 = ctx.emitter.listeners('event').length;
    const count3 = ctx.emitter.listeners('before').length;
    const count4 = ctx.emitter.listeners('multi').length;
    const count5 = ctx.emitter.listeners('single').length; // once使用过后即会删除，这里的个数为0
    const count6 = ctx.emitter.listeners('listenNum').length;
    const count7 = ctx.emitter.listeners('addListener').length;
    const count8 = ctx.emitter.listeners('callback').length;
    let total = count2 + count3 + count4 + count5 + count6 + count7 + count8;
    ctx.state = ctx.state + "\r\n" + `测试解除事件绑定API---off，解除所有绑定的事件之前事件个数${total}`
    this.state = this.state + "\r\n" + `<--------------------------------------------->`

    const names = ctx.emitter.eventNames();

    ctx.state = ctx.state + "\r\n" + `测试获取所有事件绑定API---eventNames，解除所有绑定的事件之前所有事件名称是：${JSON.stringify(names)}`
    this.state = this.state + "\r\n" + `<--------------------------------------------->`

    ctx.emitter.removeAllListeners();
    const count22 = ctx.emitter.listeners('event').length;
    const count33 = ctx.emitter.listeners('before').length;
    const count44 = ctx.emitter.listeners('multi').length;
    const count55 = ctx.emitter.listeners('single').length;
    const count66 = ctx.emitter.listeners('listenNum').length;
    const count77 = ctx.emitter.listeners('addListener').length;
    const count88 = ctx.emitter.listeners('callback').length;
    let total1 = count22 + count33 + count44 + count55 + count66 + count77 + count88;
    ctx.state = ctx.state + "\r\n" + `测试解除所有事件绑定API---removeAllListeners，解除所有绑定的事件之后事件个数${total1}`
    this.state = this.state + "\r\n" + `<--------------------------------------------->${'\r\n'}`


    ctx.emitter.addListener('newListener', (data) => {
      ctx.state = ctx.state + "\r\n" + `收到事件newListener回调，数据为：${JSON.stringify(data)}`
    });
    const beforeCount = ctx.emitter.listenerCount('newListener');
    const nameBefore = ctx.emitter.eventNames();
    ctx.state = ctx.state + "\r\n" + `测试解除事件绑定API---removeListener，解除绑定的事件之前事件个数${beforeCount}，事件名称${JSON.stringify(nameBefore)}}`
    ctx.emitter.emit('newListener', {
      name: "张三",
      age: 21,
      isMan: true,
      info: {
        msg: "这是测试数据",
        data: buffer.from("测试是否支持ArrayBuffer").buffer,
        list: [1, 2, 3, 4]
      }
    })
    ctx.emitter.removeListener('newListener');
    const afterCount = ctx.emitter.listenerCount('newListener');
    const nameAfter = ctx.emitter.eventNames();
    ctx.state = ctx.state + "\r\n" + `测试解除事件绑定API---removeListener，解除绑定的事件之后事件个数${afterCount}，事件名称${JSON.stringify(nameAfter)}}`
    this.state = this.state + "\r\n" + `<--------------------------------------------->${'\r\n'}`
    ctx.emitter.on('newListener', (data) => {
    });
    ctx.emitter.on('newListener', (data) => {
    });
    ctx.emitter.on('newListener', (data) => {
    });
    ctx.emitter.on('newListener', (data) => {
    });
    const beforeCount1 = ctx.emitter.listenerCount('newListener');
    const nameBefore1 = ctx.emitter.eventNames();
    ctx.state = ctx.state + "\r\n" + `测试解除事件绑定API---removeListener，一次性添加多个同名事件不指定解除某一个监听器回调接口，解除绑定的事件之前事件个数${beforeCount1}，事件名称${JSON.stringify(nameBefore1)}}`
    ctx.emitter.removeListener('newListener');
    const afterCount1 = ctx.emitter.listenerCount('newListener');
    const nameAfter1 = ctx.emitter.eventNames();
    ctx.state = ctx.state + "\r\n" + `测试解除事件绑定API---removeListener，一次性添加多个同名事件不指定解除某一个监听器回调接口，解除绑定的事件之后事件个数${afterCount1}，事件名称${JSON.stringify(nameAfter1)}}`
    this.state = this.state + "\r\n" + `<--------------------------------------------->${'\r\n'}`
    let obj1 = (data) => {
    }
    let obj2 = (data) => {
    }
    let obj3 = (data) => {
    }
    let obj4 = (data) => {
    }
    ctx.emitter.on('newListener', obj1);
    ctx.emitter.on('newListener', obj2);
    ctx.emitter.on('newListener', obj3);
    ctx.emitter.on('newListener', obj4);
    const beforeCount2 = ctx.emitter.listenerCount('newListener');
    const nameBefore3 = ctx.emitter.eventNames();
    ctx.state = ctx.state + "\r\n" + `测试解除事件绑定API---removeListener，一次性添加多个同名事件指定解除某一个监听器回调接口，解除绑定的事件之前事件个数${beforeCount2}，事件名称${JSON.stringify(nameBefore3)}}`
    ctx.emitter.removeListener('newListener', obj3);
    const afterCount2 = ctx.emitter.listenerCount('newListener');
    const nameAfter2 = ctx.emitter.eventNames();
    ctx.state = ctx.state + "\r\n" + `测试解除事件绑定API---removeListener，一次性添加多个同名事件指定解除某一个监听器回调接口，解除绑定的事件之后事件个数${afterCount2}，事件名称${JSON.stringify(nameAfter2)}}`
    this.state = this.state + "\r\n" + `<--------------------------------------------->${'\r\n'}`
  }
}