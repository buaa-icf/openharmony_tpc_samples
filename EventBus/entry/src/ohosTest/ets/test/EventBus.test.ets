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

let TAG: string = 'EventBusDemo '
const BASE_COUNT: number = 2000;
const HTTP_COUNT: number = 2;
const BASELINE_HASSIMECASR: number = 500;
const BASELINE_CREATEHTTP: number = 500;
const BASELINE_REQUEST: number = 2500;
const BASELINE_DESTROY: number = 30;

interface TargetType {
  className: string
}

interface Event {
  type: string,
  target: TargetType
}

export default function eventBusTest() {
  describe('ActsEventBusTest', () => {
    it('addEventListener', 0, () => {
      console.info("addEventListener begin")
      let basicTestCallBack = (event: Event) => {
        console.log(TAG + " basicTest message received " + event.type)
      }
      expect(EventBus.hasEventListener('basicTest', basicTestCallBack)).assertFalse()
      let startTime = new Date().getTime();
      for (let index = 0; index < BASE_COUNT; index++) {
        EventBus.addEventListener("basicTest", basicTestCallBack)
      }
      endTime(startTime, TAG + ' addEventListener', BASELINE_CREATEHTTP);
      expect(EventBus.hasEventListener('basicTest', basicTestCallBack)).assertTrue()
      console.info("addEventListener end")
    })

    it('removeEventListener', 1, () => {
      console.info("removeEventListener begin")
      let basicTestCallBack = (event: Event) => {
        console.log(TAG + " basicTest message received " + event.type)
      }
      EventBus.addEventListener("basicTest", basicTestCallBack)
      expect(EventBus.hasEventListener('basicTest', basicTestCallBack)).assertTrue()
      let startTime = new Date().getTime();
      for (let index = 0; index < BASE_COUNT; index++) {
        EventBus.removeEventListener("basicTest", basicTestCallBack)
      }
      endTime(startTime, TAG + ' removeEventListener', BASELINE_CREATEHTTP);
      expect(EventBus.hasEventListener('basicTest', basicTestCallBack)).assertFalse()
      console.info("removeEventListener end")
    })

    it('hasEventListener', 2, () => {
      console.info("hasEventListener begin")
      let basicEventBusCallBack = (event: Event) => {
        console.log(TAG + " basicEventBus message received " + event.type)
      }
      let isHasFirst: boolean = EventBus.hasEventListener('basicEventBus', basicEventBusCallBack)
      expect(isHasFirst).assertFalse()
      EventBus.addEventListener("basicEventBus", basicEventBusCallBack)
      let isHasSecond: boolean = false;
      let startTime = new Date().getTime();
      for (let index = 0; index < BASE_COUNT; index++) {
        isHasSecond = EventBus.hasEventListener("basicEventBus", basicEventBusCallBack)
      }
      endTime(startTime, TAG + ' hasEventListener', BASELINE_CREATEHTTP);
      expect(isHasSecond).assertTrue()
      console.info("hasEventListener end")
    })

    it('dispatch', 3, () => {
      console.info("dispatch begin")
      let basicEventBusCallBack = (event: Event) => {
        console.log(TAG + " basicEventBus message received " + event.type)
        expect(event.type).assertEqual("basicEventBus")
        console.info("dispatch end")
      }
      EventBus.addEventListener("basicEventBus", basicEventBusCallBack)
      let startTime = new Date().getTime();
      for (let index = 0; index < BASE_COUNT; index++) {
        EventBus.dispatch("basicEventBus")
      }
      endTime(startTime, TAG + ' dispatch', BASELINE_CREATEHTTP);

    })

    it('getEvents', 4, () => {
      console.info("getEvents begin")
      let abcCallBack = (event: Event) => {
      }
      let cbdCallBack = (event: Event) => {
      }
      EventBus.addEventListener("abc", abcCallBack)
      EventBus.addEventListener("cbd", cbdCallBack)
      expect(EventBus.getEvents()).assertContain("abc")
      let startTime = new Date().getTime();
      for (let index = 0; index < BASE_COUNT; index++) {
        expect(EventBus.getEvents()).assertContain("cbd")
      }
      endTime(startTime, TAG + ' getEvents', BASELINE_CREATEHTTP);
      console.info("getEvents end")
    })
  })
}

function endTime(startTime: number, tag: string, BASELINE_CREATEHTTP: number) {
  let endTime: number = new Date().getTime();
  let averageTime = ((endTime - startTime) * 1000 / BASE_COUNT)
  console.info(tag + " endTime" + endTime)
  console.log(tag + " averageTime:" + averageTime + "μs");
  expect(averageTime < BASELINE_CREATEHTTP).assertTrue();
}