/*
 * Copyright (C) 2021 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import router from '@ohos.router';
import EventBus from "eventbusjs";

var TAG = "EventBusDemo ";

@Entry
@Component
struct Index {
  @State comeDetailText: string = "全局监听detail页面刷新展示";
  @State changeText: string = "";
  testCount: number = 0;
  eventBusCount: number = 0;
  scroller: Scroller = new Scroller();
  basicTestCallBack: Function = (event) => {
    this.testCount++;
    this.changeText = "basicTest监听创建成功 " + this.testCount;
    console.log(TAG + " basicTest message received " + event.type);
  }
  basicEventBusCallBack: Function = (event) => {
    this.eventBusCount++;
    this.changeText = "basicEventBus监听创建成功 " + this.eventBusCount;
    console.log(TAG + " basicEventBus message received " + event.type);
  }

  build() {
    Column() {
      Text(this.comeDetailText)
        .fontSize(30)
        .fontWeight(FontWeight.Bold)

      Scroll(this.scroller) {
        Text(this.changeText)
          .fontSize(30)
          .fontWeight(FontWeight.Bold)
      }
      .width("100%")
      .height("30%")
      .scrollable(ScrollDirection.Vertical)
      .scrollBar(BarState.On)
      .padding(16)
      .align(Alignment.TopStart)

      Scroll(this.scroller) {
        Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Center }) {

          Button("订阅basicTest消息")
            .fontSize(18)
            .height(80)
            .onClick(() => {
              let isHas = EventBus.hasEventListener('basicTest', this.basicTestCallBack);
              if (!isHas) {
                EventBus.addEventListener("basicTest", this.basicTestCallBack);
                console.log(TAG + " basicTest 订阅消息");
              }
            }).margin({ bottom: 20 })

          Button("发送basicTest消息")
            .fontSize(18)
            .height(80)
            .onClick(() => {
              EventBus.dispatch("basicTest")
            }).margin({ bottom: 20 })

          Button("订阅basicEventBus消息")
            .fontSize(18)
            .height(80)
            .onClick(() => {
              let isHas = EventBus.hasEventListener('basicEventBus', this.basicEventBusCallBack);
              if (!isHas) {
                EventBus.addEventListener("basicEventBus", this.basicEventBusCallBack);
                console.log(TAG + " basicEventBus 订阅消息");
              }
            }).margin({ bottom: 20 })

          Button("发送basicEventBus消息")
            .fontSize(18)
            .height(80)
            .onClick(() => {
              EventBus.dispatch("basicEventBus")
            }).margin({ bottom: 20 })

          Button("判断basicTest订阅是否存在")
            .fontSize(18)
            .height(80)
            .onClick(() => {
              let isHas = EventBus.hasEventListener('basicTest', this.basicTestCallBack);
              this.changeText = isHas
              console.log(TAG + " Determine whether the Basictest subscription exists " + isHas)
            }).margin({ bottom: 20 })

          Button("移除basicTest消息")
            .fontSize(18)
            .height(80)
            .onClick(() => {
              EventBus.removeEventListener('basicTest', this.basicTestCallBack);
              this.changeText = '移除basicTest消息成功'
            }).margin({ bottom: 20 })

          Button("传递参数测试")
            .fontSize(18)
            .height(80)
            .onClick(() => {
              testAddParameters()
            }).margin({ bottom: 20 })

          Button("测试获取有多少事件被注册")
            .fontSize(18)
            .height(80)
            .onClick(() => {
              testGetEvents()
            }).margin({ bottom: 20 })

          Button("GoToDetail")
            .fontSize(18)
            .height(80)
            .onClick(() => {
              router.push({ url: "pages/detail" })
            }).margin({ bottom: 20 })
        }
        .width('100%')
        .height('100%')
      }
      .width("100%")
      .height("55%")
      .scrollable(ScrollDirection.Vertical)
      .scrollBar(BarState.On)
      .padding(16)
      .align(Alignment.TopStart)
    }

  }

  aboutToAppear() {
    this.onInitEventBus()
  }

  onInitEventBus() {
    refreshComeFromDetail(this)
  }
}


function testAddParameters() {
  // 传递参数测试开始
  var TestClass1 = function () {
    this.className = "TestClass1";
    this.doSomething = function (event, param1, param2) {
      console.log(TAG + this.className + ".doSomething");
      console.log(TAG + "type=" + event.type);
      console.log(TAG + "params=" + param1 + param2);
      console.log(TAG + "coming from=" + event.target.className);
    }
  };
  var TestClass2 = function () {
    this.className = "TestClass2";
    this.ready = function () {
      EventBus.dispatch("testAddParameters", this, "javascript events", " are really useful");
    }
  };

  var t1 = new TestClass1();
  var t2 = new TestClass2();

  EventBus.addEventListener("testAddParameters", t1.doSomething, t1);
  t2.ready();
}

function refreshComeFromDetail(that) {
  // 刷新来自Detail测试开始
  var refreshComeFromDetail = function () {
    this.className = "refreshComeFromDetail";
    this.doSomething = function (event, param1, param2) {
      console.log(TAG + this.className + ".doSomething");
      console.log(TAG + "type=" + event.type);
      console.log(TAG + "params=" + param1 + param2);
      console.log(TAG + "coming from=" + event.target.className);
      that.comeDetailText = param1 + "***" + param2
    }
  };

  var t1 = new refreshComeFromDetail();
  // 有参数传递的
  globalThis.eventBus.addEventListener("refreshComeFromDetail", t1.doSomething, t1);
}


function testGetEvents() {
  console.log(TAG + " How many events are registered for start ");
  console.log(TAG + " How many events name " + EventBus.getEvents());
  console.log(TAG + " How many events are registered for end ");
}
