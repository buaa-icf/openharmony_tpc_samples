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

var TAG = "EventBusDemo ";
var EventBus = globalThis.eventBus

@Entry
@Component
struct Detail {
  build() {
    Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Center, justifyContent: FlexAlign.Center }) {
      Text('Hello Detail')
        .fontSize(50)
        .fontWeight(FontWeight.Bold)
    }
    .width('100%')
    .height('100%')
  }

  aboutToAppear()  {
    console.log(TAG + "aboutToAppear")

    var TestClass2 = function () {
      this.className = "TestClass2";
      this.ready = function () {
        console.log(TAG + "发送刷新refreshComeFromDetail事件----------");
        EventBus.dispatch("refreshComeFromDetail", this, "javascript events", " come from detail params");
      }
    };
    var t2 = new TestClass2();
    t2.ready();
  }
}
