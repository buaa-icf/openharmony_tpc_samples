 /**
 * Copyright (C) 2022 Huawei Device Co., Ltd.
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

import { Locale, WeekFields }  from '@ohos/localeEnUs'
import { describe, expect, it } from '@ohos/hypium'


export default function jodaEnUsTest() {
  describe('JsJodaEnUs', () => {
    it('language', 0, () => {
      try {
        let languageParam: string  = new Locale("Chinese","","").language()
        expect(languageParam).assertEqual("Chinese");
      } catch (e) {
        console.info(e)
      }
    })

    it('country', 0, () => {
      try {
        let chinaParam: string  = new Locale("Chinese","china","").country()
        expect(chinaParam).assertEqual("china");
      } catch (e) {
        console.info(e)
      }
    })


    it('localeString', 0, () => {
      try {
        let localeStringParam: string  = new Locale("Chinese","china","localeString").localeString()
        expect(localeStringParam).assertEqual("localeString");
      } catch (e) {
        console.info(e)
      }
    })

    it('localeToString', 0, () => {
      try {
        let toStringParam: string  = new Locale("Chinese","china","localeString").toString()
        expect(toStringParam).assertEqual("Locale[localeString]");
      } catch (e) {
      }
    })

    it('localeEquals', 0, () => {
      try {
        let equalsResult: boolean  = new Locale("Chinese","china","localeString").equals("")
        expect(equalsResult).assertEqual(false);
      } catch (e) {
        console.info(e)
      }
    })


    it('firstDayOfWeek', 0, () => {
      try {
        let firstDayOfWeek: String  = WeekFields.SUNDAY_START.firstDayOfWeek().name()
        expect(firstDayOfWeek).assertEqual("SUNDAY");
      } catch (e) {
        console.info(e)
      }
    })

    it('minimalDaysInFirstWeek', 0, () => {
      try {
        let minimalDaysInFirstWeek: number  = WeekFields.SUNDAY_START.minimalDaysInFirstWeek()
        expect(minimalDaysInFirstWeek).assertEqual(1);
      } catch (e) {
        console.info(e)
      }
    })

    it('dayOfWeek', 0, () => {
      try {
        let dayOfWeek: string  = WeekFields.SUNDAY_START.dayOfWeek().name()
        expect(dayOfWeek).assertEqual("DayOfWeek");
      } catch (e) {
        console.info(e)
      }
    })

    it('weekOfMonth', 0, () => {
      try {
        let weekOfMonth: string  = WeekFields.SUNDAY_START.weekOfMonth().name()
        expect(weekOfMonth).assertEqual("WeekOfMonth");
      } catch (e) {
        console.info(e)
      }
    })

    it('weekOfYear', 0, () => {
      try {
        let weekOfYear: string  = WeekFields.SUNDAY_START.weekOfYear().name()
        expect(weekOfYear).assertEqual("WeekOfYear");
      } catch (e) {
        console.info(e)
      }
    })

    it('weekOfWeekBasedYear', 0, () => {
      try {
        let weekOfWeekBasedYear: string  = WeekFields.SUNDAY_START.weekOfWeekBasedYear().name()
        expect(weekOfWeekBasedYear).assertEqual("WeekOfWeekBasedYear");
      } catch (e) {
        console.info(e)
      }
    })

    it('weekBasedYear', 0, () => {
      try {
        let weekBasedYear: string  = WeekFields.SUNDAY_START.weekBasedYear().name()
        expect(weekBasedYear).assertEqual("WeekBasedYear");
      } catch (e) {
        console.info(e)
      }
    })

    it('equals', 0, () => {
      try {
        let equalsParam: boolean  = WeekFields.SUNDAY_START.equals(2)
        expect(equalsParam).assertEqual(false);
      } catch (e) {
        console.info(e)
      }
    })

    it('hashCode', 0, () => {
      try {
        let hashCodeParam: number  = WeekFields.SUNDAY_START.hashCode()
        expect(hashCodeParam).assertEqual(43);
      } catch (e) {
        console.info(e)
      }
    })

    it('toString', 0, () => {
      try {
        let toStringParam: string  = WeekFields.SUNDAY_START.toString()
        expect(toStringParam).assertEqual("WeekFields[SUNDAY,1]");
      } catch (e) {
        console.info(e)
      }
    })

  })
}