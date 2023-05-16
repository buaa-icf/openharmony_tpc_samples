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
import dayjs from 'dayjs/src'
import relativeTime from 'dayjs/src/plugin/relativeTime'
import 'dayjs/src/locale/ru'
import locale from 'dayjs/src/locale/ar-dz'
import {it ,expect,describe,responseTime } from "../utils/utils"
dayjs.extend(relativeTime)

export default function ar_dzTest() {
  describe('ar_dzTest', function () {
    it('Meridiem', () => {
      responseTime(() => dayjs.locale(locale),"dayjs.locale(locale)")


      responseTime(() => dayjs('2020-01-01 03:00:00').locale('ar-dz').format('A'),"dayjs('2020-01-01 03:00:00').locale('ar-dz').format('A')")


      expect(dayjs('2020-01-01 03:00:00').locale('ar-dz').format('A')).toEqual('ص')
      expect(dayjs('2020-01-01 11:00:00').locale('ar-dz').format('A')).toEqual('ص')
      expect(dayjs('2020-01-01 16:00:00').locale('ar-dz').format('A')).toEqual('م')
      expect(dayjs('2020-01-01 20:00:00').locale('ar-dz').format('A')).toEqual('م')
    })
  })
}