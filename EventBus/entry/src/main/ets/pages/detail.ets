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
import EventBus from "eventbusjs";

let TAG:string = "EventBusDemo ";


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
    class  TestA {
      className:string = ''
      ready:Function = () => {}
    }
    let TestClass2 = ():TestA=> {
      let TestClass = new TestA()
      TestClass.className = "TestClass2";
      TestClass.ready = () => {
        console.log(TAG + this.getResourceString('send_refreshComeFromDetail_event'));
        EventBus.dispatch("refreshComeFromDetail", TestClass, "javascript events", " come from detail params");
      }
      return {className:TestClass.className,ready:TestClass.ready }
    };
    let t2:TestA = TestClass2();
    t2.ready();
  }

  getResourceString(resourceName:string) {
    return getContext().resourceManager.getStringByNameSync(resourceName)
  }
}
