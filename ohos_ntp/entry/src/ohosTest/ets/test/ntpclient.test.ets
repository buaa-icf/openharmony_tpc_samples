/*
 * Copyright (c) 2024 Huawei Device Co., Ltd.
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

import { describe, it, expect, TestType } from '@ohos/hypium';
import { getNetworkTime } from '@ohos/ntp';

const BASE_COUNT = 2

export default function abilityTest() {
  describe('ntpTest', () => {
    it('getNetworkTimeTest', 0, () => {
      getNetworkTime({
        server: 'ntp.aliyun.com',
        port: 123,
        delayTime: 2000
      })
        .then((date) => {
          expect(!!date).assertTrue()
        })
        .catch((err: string) => {
          expect(!!err).assertFalse()
        })
    })

    it('getNetworkTimePerformanceTest', TestType.PERFORMANCE, async () => {
      let startTime = new Date().getTime()
      const test = (index: number) => {
        getNetworkTime({
          server: 'ntp.aliyun.com',
          port: 123,
          delayTime: 2000
        })
          .then((date) => {
            if (index < BASE_COUNT) {
              expect(!!date).assertTrue()
              test(index + 1)
            } else {
              let endTime = new Date().getTime()
              console.info("EndTime:" + endTime)
              let averageTime = ((endTime - startTime) * 1000) / BASE_COUNT
              console.info("AverageTime:" + averageTime)
              expect(averageTime).assertLess(500)
            }
          })
      }
      test(0)
    })
  })
}