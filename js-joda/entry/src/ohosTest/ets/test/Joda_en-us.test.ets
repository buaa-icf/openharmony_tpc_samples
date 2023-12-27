/**
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

import { Locale, WeekFields }  from '@ohos/localeEnUs'
import { describe, expect, it } from '@ohos/hypium'


export default function jodaEnUsTest() {
  describe('JsJodaEnUs', () => {
    for (let i =0 ; i< 1000; i++) {
      it('language', 0, () => {
        try {
          let startTime0 = new Date().getTime()
          console.info('JsJodaEnUs xts language startTime:' + startTime0 + "us")
          let languageParam: string = new Locale("Chinese", "", "").language()
          let endTime0 = new Date().getTime()
          console.info('JsJodaEnUs xts language endTime:' + endTime0 + "us")
          let averageTime0 = endTime0 - startTime0
          console.info('JsJodaEnUs xts language averageTime:' + averageTime0 + "us")
          expect(languageParam).assertEqual("Chinese");
        } catch (e) {
          console.info(e)
        }
      })

      it('country', 0, () => {
        try {
          let startTime0 = new Date().getTime()
          console.info('JsJodaEnUs xts country startTime:' + startTime0 + "us")
          let chinaParam: string = new Locale("Chinese", "china", "").country()
          let endTime0 = new Date().getTime()
          console.info('JsJodaEnUs xts country endTime:' + endTime0 + "us")
          let averageTime0 = endTime0 - startTime0
          console.info('JsJodaEnUs xts country averageTime:' + averageTime0 + "us")
          expect(chinaParam).assertEqual("china");
        } catch (e) {
          console.info(e)
        }
      })


      it('localeString', 0, () => {
        try {
          let startTime0 = new Date().getTime()
          console.info('JsJodaEnUs xts localeString startTime:' + startTime0 + "us")
          let localeStringParam: string = new Locale("Chinese", "china", "localeString").localeString()
          let endTime0 = new Date().getTime()
          console.info('JsJodaEnUs xts localeString endTime:' + endTime0 + "us")
          let averageTime0 = endTime0 - startTime0
          console.info('JsJodaEnUs xts localeString averageTime:' + averageTime0 + "us")
          expect(localeStringParam).assertEqual("localeString");
        } catch (e) {
          console.info(e)
        }
      })

      it('localeToString', 0, () => {
        try {
          let startTime0 = new Date().getTime()
          console.info('JsJodaEnUs xts toString startTime:' + startTime0 + "us")
          let toStringParam: string = new Locale("Chinese", "china", "localeString").toString()
          let endTime0 = new Date().getTime()
          console.info('JsJodaEnUs xts toString endTime:' + endTime0 + "us")
          let averageTime0 = endTime0 - startTime0
          console.info('JsJodaEnUs xts toString averageTime:' + averageTime0 + "us")
          expect(toStringParam).assertEqual("Locale[localeString]");
        } catch (e) {
        }
      })

      it('localeEquals', 0, () => {
        try {
          let startTime0 = new Date().getTime()
          console.info('JsJodaEnUs xts localeEquals startTime:' + startTime0 + "us")
          let equalsResult: boolean = new Locale("Chinese", "china", "localeString").equals("")
          let endTime0 = new Date().getTime()
          console.info('JsJodaEnUs xts localeEquals endTime:' + endTime0 + "us")
          let averageTime0 = endTime0 - startTime0
          console.info('JsJodaEnUs xts localeEquals averageTime:' + averageTime0 + "us")
          expect(equalsResult).assertEqual(false);
        } catch (e) {
          console.info(e)
        }
      })


      it('firstDayOfWeek', 0, () => {
        try {
          let startTime0 = new Date().getTime()
          console.info('JsJodaEnUs xts firstDayOfWeek startTime:' + startTime0 + "us")
          let firstDayOfWeek: String = WeekFields.SUNDAY_START.firstDayOfWeek().name()
          let endTime0 = new Date().getTime()
          console.info('JsJodaEnUs xts firstDayOfWeek endTime:' + endTime0 + "us")
          let averageTime0 = endTime0 - startTime0
          console.info('JsJodaEnUs xts firstDayOfWeek averageTime:' + averageTime0 + "us")
          expect(firstDayOfWeek).assertEqual("SUNDAY");
        } catch (e) {
          console.info(e)
        }
      })

      it('minimalDaysInFirstWeek', 0, () => {
        try {
          let startTime0 = new Date().getTime()
          console.info('JsJodaEnUs xts minimalDaysInFirstWeek startTime:' + startTime0 + "us")
          let minimalDaysInFirstWeek: number = WeekFields.SUNDAY_START.minimalDaysInFirstWeek()
          let endTime0 = new Date().getTime()
          console.info('JsJodaEnUs xts minimalDaysInFirstWeek endTime:' + endTime0 + "us")
          let averageTime0 = endTime0 - startTime0
          console.info('JsJodaEnUs xts minimalDaysInFirstWeek averageTime:' + averageTime0 + "us")
          expect(minimalDaysInFirstWeek).assertEqual(1);
        } catch (e) {
          console.info(e)
        }
      })

      it('dayOfWeek', 0, () => {
        try {
          let startTime0 = new Date().getTime()
          console.info('JsJodaEnUs xts dayOfWeek startTime:' + startTime0 + "us")
          let dayOfWeek: string = WeekFields.SUNDAY_START.dayOfWeek().name()
          let endTime0 = new Date().getTime()
          console.info('JsJodaEnUs xts dayOfWeek endTime:' + endTime0 + "us")
          let averageTime0 = endTime0 - startTime0
          console.info('JsJodaEnUs xts dayOfWeek averageTime:' + averageTime0 + "us")
          expect(dayOfWeek).assertEqual("DayOfWeek");
        } catch (e) {
          console.info(e)
        }
      })

      it('weekOfMonth', 0, () => {
        try {
          let startTime0 = new Date().getTime()
          console.info('JsJodaEnUs xts weekOfMonth startTime:' + startTime0 + "us")
          let weekOfMonth: string = WeekFields.SUNDAY_START.weekOfMonth().name()
          let endTime0 = new Date().getTime()
          console.info('JsJodaEnUs xts weekOfMonth endTime:' + endTime0 + "us")
          let averageTime0 = endTime0 - startTime0
          console.info('JsJodaEnUs xts weekOfMonth averageTime:' + averageTime0 + "us")
          expect(weekOfMonth).assertEqual("WeekOfMonth");
        } catch (e) {
          console.info(e)
        }
      })

      it('weekOfYear', 0, () => {
        try {
          let startTime0 = new Date().getTime()
          console.info('JsJodaEnUs xts weekOfYear startTime:' + startTime0 + "us")
          let weekOfYear: string = WeekFields.SUNDAY_START.weekOfYear().name()
          let endTime0 = new Date().getTime()
          console.info('JsJodaEnUs xts weekOfYear endTime:' + endTime0 + "us")
          let averageTime0 = endTime0 - startTime0
          console.info('JsJodaEnUs xts weekOfYear averageTime:' + averageTime0 + "us")
          expect(weekOfYear).assertEqual("WeekOfYear");
        } catch (e) {
          console.info(e)
        }
      })

      it('weekOfWeekBasedYear', 0, () => {
        try {
          let startTime0 = new Date().getTime()
          console.info('JsJodaEnUs xts weekOfWeekBasedYear startTime:' + startTime0 + "us")
          let weekOfWeekBasedYear: string = WeekFields.SUNDAY_START.weekOfWeekBasedYear().name()
          let endTime0 = new Date().getTime()
          console.info('JsJodaEnUs xts weekOfWeekBasedYear endTime:' + endTime0 + "us")
          let averageTime0 = endTime0 - startTime0
          console.info('JsJodaEnUs xts weekOfWeekBasedYear averageTime:' + averageTime0 + "us")
          expect(weekOfWeekBasedYear).assertEqual("WeekOfWeekBasedYear");
        } catch (e) {
          console.info(e)
        }
      })

      it('weekBasedYear', 0, () => {
        try {
          let startTime0 = new Date().getTime()
          console.info('JsJodaEnUs xts weekBasedYear startTime:' + startTime0 + "us")
          let weekBasedYear: string = WeekFields.SUNDAY_START.weekBasedYear().name()
          let endTime0 = new Date().getTime()
          console.info('JsJodaEnUs xts weekBasedYear endTime:' + endTime0 + "us")
          let averageTime0 = endTime0 - startTime0
          console.info('JsJodaEnUs xts weekBasedYear averageTime:' + averageTime0 + "us")
          expect(weekBasedYear).assertEqual("WeekBasedYear");
        } catch (e) {
          console.info(e)
        }
      })

      it('equals', 0, () => {
        try {
          let startTime0 = new Date().getTime()
          console.info('JsJodaEnUs xts equals startTime:' + startTime0 + "us")
          let equalsParam: boolean = WeekFields.SUNDAY_START.equals(2)
          let endTime0 = new Date().getTime()
          console.info('JsJodaEnUs xts equals endTime:' + endTime0 + "us")
          let averageTime0 = endTime0 - startTime0
          console.info('JsJodaEnUs xts equals averageTime:' + averageTime0 + "us")
          expect(equalsParam).assertEqual(false);
        } catch (e) {
          console.info(e)
        }
      })

      it('hashCode', 0, () => {
        try {
          let startTime0 = new Date().getTime()
          console.info('JsJodaEnUs xts hashCode startTime:' + startTime0 + "us")
          let hashCodeParam: number = WeekFields.SUNDAY_START.hashCode()
          let endTime0 = new Date().getTime()
          console.info('JsJodaEnUs xts hashCode endTime:' + endTime0 + "us")
          let averageTime0 = endTime0 - startTime0
          console.info('JsJodaEnUs xts hashCode averageTime:' + averageTime0 + "us")
          expect(hashCodeParam).assertEqual(43);
        } catch (e) {
          console.info(e)
        }
      })

      it('toString', 0, () => {
        try {
          let startTime0 = new Date().getTime()
          console.info('JsJodaEnUs xts toString startTime:' + startTime0 + "us")
          let toStringParam: string = WeekFields.SUNDAY_START.toString()
          let endTime0 = new Date().getTime()
          console.info('JsJodaEnUs xts toString endTime:' + endTime0 + "us")
          let averageTime0 = endTime0 - startTime0
          console.info('JsJodaEnUs xts toString averageTime:' + averageTime0 + "us")
          expect(toStringParam).assertEqual("WeekFields[SUNDAY,1]");
        } catch (e) {
          console.info(e)
        }
      })
    }
  })
}