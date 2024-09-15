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

let TAG: string = "EventBusDemo ";



interface TargetType {
  className: string
}

interface Event {
  type: string
  target: TargetType
}

interface ThatType {
  comeDetailText: string
}

@Entry
@Component
struct Index {
  @State comeDetailText: string = "";
  @State changeText: string = "";
  testCount: number = 0;
  eventBusCount: number = 0;
  scroller: Scroller = new Scroller();
  basicTestCallBack: EventBus.EventListener = (event: Event) => {
    this.testCount++;
    this.changeText = getContext().resourceManager.getStringByNameSync('app.string.basicTest_listening_successfully_created') + this.testCount;
    console.log(TAG + " basicTest message received " + event.type);
  }
  basicEventBusCallBack: EventBus.EventListener = (event: Event) => {
    this.eventBusCount++;
    this.changeText = getContext().resourceManager.getStringByNameSync('app.string.basicEventBus_listening_successfully_created') + this.eventBusCount;
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

          Button($r('app.string.subscribe_to_basicTest_messages'))
            .fontSize(18)
            .height(80)
            .onClick(() => {
              let isHas: boolean = EventBus.hasEventListener('basicTest', this.basicTestCallBack);
              if (!isHas) {
                EventBus.addEventListener("basicTest", this.basicTestCallBack);
                console.log(TAG + " basicTest 订阅消息");
              }
            }).margin({ bottom: 20 })

          Button($r('app.string.send_basicTest_message'))
            .fontSize(18)
            .height(80)
            .onClick(() => {
              EventBus.dispatch("basicTest")
            }).margin({ bottom: 20 })

          Button($r('app.string.subscribe_to_basicEventBus_messages'))
            .fontSize(18)
            .height(80)
            .onClick(() => {
              let isHas: boolean = EventBus.hasEventListener('basicEventBus', this.basicEventBusCallBack);
              if (!isHas) {
                EventBus.addEventListener("basicEventBus", this.basicEventBusCallBack);
                console.log(TAG + " basicEventBus 订阅消息");
              }
            }).margin({ bottom: 20 })

          Button($r('app.string.send_basicEventBus_message'))
            .fontSize(18)
            .height(80)
            .onClick(() => {
              EventBus.dispatch("basicEventBus")
            }).margin({ bottom: 20 })

          Button($r('app.string.determine_whether_the_basicTest_subscription_exists'))
            .fontSize(18)
            .height(80)
            .onClick(() => {
              let isHas: boolean = EventBus.hasEventListener('basicTest', this.basicTestCallBack);
              this.changeText = isHas + ""
              console.log(TAG + " Determine whether the Basictest subscription exists " + isHas)
            }).margin({ bottom: 20 })

          Button($r('app.string.remove_basicTest_message'))
            .fontSize(18)
            .height(80)
            .onClick(() => {
              EventBus.removeEventListener('basicTest', this.basicTestCallBack);
              this.changeText = getContext().resourceManager.getStringByNameSync('app.string.successfully_removed_basicTest_message')
            }).margin({ bottom: 20 })

          Button($r('app.string.passing_parameter_testing'))
            .fontSize(18)
            .height(80)
            .onClick(() => {
              testAddParameters()
            }).margin({ bottom: 20 })

          Button($r('app.string.test_how_many_events_have_been_registered'))
            .fontSize(18)
            .height(80)
            .onClick(() => {
              testGetEvents()
            }).margin({ bottom: 20 })

          Button($r('app.string.go_to_detail'))
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
    this.comeDetailText = getContext().resourceManager.getStringByNameSync('app.string.refresh_and_display_the_global_monitoring_detail_page')
    refreshComeFromDetail(this)
  }
}


function testAddParameters() {
  class TestA {
    className: string = ''
    doSomething: EventBus.EventListener = (): void => {
    }
  }

  class TestB {
    className: string = ''
    ready: Function = () => {
    }
  }

  // 传递参数测试开始
  let TestClass1 = (): TestA => {
    let TestClass = new TestA()
    TestClass.className = "TestClass1";
    TestClass.doSomething = (event: Event, param1: string, param2: string) => {
      console.log(TAG + TestClass.className + ".doSomething");
      console.log(TAG + "type=" + event.type);
      console.log(TAG + "params=" + param1 + param2);
      console.log(TAG + "coming from=" + event.target.className);
    }
    return { className: TestClass.className, doSomething: TestClass.doSomething }
  };
  let TestClass2 = (): TestB => {
    let TestClass = new TestB()
    TestClass.className = "TestClass2";
    TestClass.ready = () => {
      EventBus.dispatch("testAddParameters", TestClass, "javascript events", " are really useful");
    }
    return { className: TestClass.className, ready: TestClass.ready }
  };

  let t1: TestA = TestClass1();
  let t2: TestB = TestClass2();

  EventBus.addEventListener("testAddParameters", t1.doSomething, t1);
  t2.ready();
}

function refreshComeFromDetail(that: ThatType) {
  interface formDetailA {
    className: string
    doSomething: EventBus.EventListener
  }

  // 刷新来自Detail测试开始
  let refreshComeFromDetail = (): formDetailA => {
    let className = "refreshComeFromDetail";
    let doSomething = (event: Event, param1: string, param2: string) => {
      console.log(TAG + className + ".doSomething");
      console.log(TAG + "type=" + event.type);
      console.log(TAG + "params=" + param1 + param2);
      console.log(TAG + "coming from=" + event.target.className);
      that.comeDetailText = param1 + "***" + param2
    }
    return { className, doSomething }
  };

  let t1: formDetailA = refreshComeFromDetail();
  // 有参数传递的
  EventBus.addEventListener("refreshComeFromDetail", t1.doSomething, t1);
}


function testGetEvents() {
  console.log(TAG + " How many events are registered for start ");
  console.log(TAG + " How many events name " + EventBus.getEvents());
  console.log(TAG + " How many events are registered for end ");
}
