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
import moment from '../moment/moment'
import dayjs from 'dayjs/src'
import 'dayjs/src/locale/zh-cn'
import 'dayjs/src/locale/ar'
import {it,expect,describe,responseTime } from "../utils/utils"

export default function manipulateTest() {
  describe('StartOf_EndOf', () => {
    it('StartOf_EndOf_Year_with_s_and_upper_case', () => {
      const testArr = ['Year', 'year', 'YearS', 'month', 'day', 'date',
        'week', 'hour', 'minute', 'second']

      responseTime(() =>dayjs().startOf("Year").valueOf() ,"dayjs().startOf("+"Year"+").valueOf()")

      testArr.forEach((d) => {
        expect(dayjs().startOf(d).valueOf()).toBe(moment().startOf(d).valueOf())
        expect(dayjs().endOf(d).valueOf()).toBe(moment().endOf(d).valueOf())
      })
    })
  })

}