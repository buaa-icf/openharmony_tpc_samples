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

import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect } from '@ohos/hypium'
import EventBus from 'eventbusjs'

var TAG = 'EventBusDemo '

export default function eventBusTest() {
  describe('ActsEventBusTest', function () {
    it('addEventListener', 0, () => {
      console.info("addEventListener begin")
      let basicTestCallBack = (event) => {
        console.log(TAG + " basicTest message received " + event.type)
      }
      expect(EventBus.hasEventListener('basicTest', basicTestCallBack)).assertFalse()
      EventBus.addEventListener("basicTest", basicTestCallBack)
      expect(EventBus.hasEventListener('basicTest', basicTestCallBack)).assertTrue()
      console.info("addEventListener end")
    })

    it('removeEventListener', 1, () => {
      console.info("removeEventListener begin")
      let basicTestCallBack = (event) => {
        console.log(TAG + " basicTest message received " + event.type)
      }
      EventBus.addEventListener("basicTest", basicTestCallBack)
      expect(EventBus.hasEventListener('basicTest', basicTestCallBack)).assertTrue()
      EventBus.removeEventListener("basicTest", basicTestCallBack)
      expect(EventBus.hasEventListener('basicTest', basicTestCallBack)).assertFalse()
      console.info("removeEventListener end")
    })

    it('hasEventListener', 2, () => {
      console.info("hasEventListener begin")
      let basicEventBusCallBack = (event) => {
        console.log(TAG + " basicEventBus message received " + event.type)
      }
      let isHasFirst = EventBus.hasEventListener('basicEventBus', basicEventBusCallBack)
      expect(isHasFirst).assertFalse()
      EventBus.addEventListener("basicEventBus", basicEventBusCallBack)
      let isHasSecond = EventBus.hasEventListener('basicEventBus', basicEventBusCallBack)
      expect(isHasSecond).assertTrue()
      console.info("hasEventListener end")
    })

    it('dispatch', 3, () => {
      console.info("dispatch begin")
      let basicEventBusCallBack = (event) => {
        console.log(TAG + " basicEventBus message received " + event.type)
        expect(event.type).assertEqual("basicEventBus")
        console.info("dispatch end")
      }
      EventBus.addEventListener("basicEventBus", basicEventBusCallBack)
      EventBus.dispatch("basicEventBus")
    })

    it('getEvents', 4, () => {
      console.info("getEvents begin")
      let abcCallBack = (event) => {
      }
      let cbdCallBack = (event) => {
      }
      EventBus.addEventListener("abc", abcCallBack)
      EventBus.addEventListener("cbd", cbdCallBack)
      expect(EventBus.getEvents()).assertContain("abc")
      expect(EventBus.getEvents()).assertContain("cbd")
      console.info("getEvents end")
    })
  })
}