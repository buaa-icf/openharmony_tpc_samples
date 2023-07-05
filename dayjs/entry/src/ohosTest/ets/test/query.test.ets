/*
 * Copyright (C) 2023 Huawei Device Co., Ltd.
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
//@ts-nocheck
import {it,expect,describe } from "../utils/utils"
import dayjs from 'dayjs'



export default function queryTest() {
  describe('queryTest', function () {

    it('Compare_to_dayjs_object', () => {
      const dayA = dayjs()
      const dayB = dayA.clone().add(1, 'day')
      const dayC = dayA.clone().subtract(1, 'day')
      expect(dayC.isBefore(dayA)).toBe(true)
      expect(dayB.isAfter(dayA)).toBe(true)
      expect(dayA.isSame()).toBe(false)
      expect(dayB.isAfter()).toBe(true)
      expect(dayC.isBefore()).toBe(true)
    })

    it('No_value', () => {
      const dayA = dayjs('2022.3.6 12:00:00')
      const dayB = dayA.clone().add(1, 'day')
      const dayC = dayA.clone().subtract(1, 'day')
      expect(dayA.isSame(dayjs('2022.3.6 12:00:00'))).toBe(true)
      expect(dayB.isAfter()).toBe(false)
      expect(dayC.isBefore()).toBe(true)
    })


  })
}
