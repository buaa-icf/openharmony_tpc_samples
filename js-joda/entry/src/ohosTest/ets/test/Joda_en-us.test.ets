/**
 * BSD License
 *
 * Copyright (c) 2023 Huawei Device Co., Ltd. All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without modification,
 * are permitted provided that the following conditions are met:
 *
 * * Redistributions of source code must retain the above copyright notice, this
 *  list of conditions and the following disclaimer.
 *
 * * Redistributions in binary form must reproduce the above copyright notice,
 * this list of conditions and the following disclaimer in the documentation
 * and/or other materials provided with the distribution.
 *
 * * Neither the name Facebook nor the names of its contributors may be used to
 * endorse or promote products derived from this software without specific
 * prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS 'AS IS' AND
 * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 * WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 * DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR
 * ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
 * LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
 * ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 * SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

import { Locale, WeekFields }  from '@ohos/localeenus'
import { describe, expect, it } from '@ohos/hypium'


export default function jodaEnUsTest() {
  describe('JsJodaEnUs', () => {
    it('language', 0, () => {
      try {
        let languageParam: string = new Locale("Chinese", "", "").language()
        expect(languageParam).assertEqual("Chinese");
      } catch (e) {
        console.info(e)
      }
    })

    it('country', 0, () => {
      try {
        let chinaParam: string = new Locale("Chinese", "china", "").country()
        expect(chinaParam).assertEqual("china");
      } catch (e) {
        console.info(e)
      }
    })


    it('localeString', 0, () => {
      try {
        let localeStringParam: string = new Locale("Chinese", "china", "localeString").localeString()
        expect(localeStringParam).assertEqual("localeString");
      } catch (e) {
        console.info(e)
      }
    })

    it('localeToString', 0, () => {
      try {
        let toStringParam: string = new Locale("Chinese", "china", "localeString").toString()
        expect(toStringParam).assertEqual("Locale[localeString]");
      } catch (e) {
      }
    })

    it('localeEquals', 0, () => {
      try {
        let equalsResult: boolean = new Locale("Chinese", "china", "localeString").equals("")
        expect(equalsResult).assertEqual(false);
      } catch (e) {
        console.info(e)
      }
    })


    it('firstDayOfWeek', 0, () => {
      try {
        let firstDayOfWeek: String = WeekFields.SUNDAY_START.firstDayOfWeek().name()
        expect(firstDayOfWeek).assertEqual("SUNDAY");
      } catch (e) {
        console.info(e)
      }
    })

    it('minimalDaysInFirstWeek', 0, () => {
      try {
        let minimalDaysInFirstWeek: number = WeekFields.SUNDAY_START.minimalDaysInFirstWeek()
        expect(minimalDaysInFirstWeek).assertEqual(1);
      } catch (e) {
        console.info(e)
      }
    })

    it('dayOfWeek', 0, () => {
      try {
        let dayOfWeek: string = WeekFields.SUNDAY_START.dayOfWeek().name()
        expect(dayOfWeek).assertEqual("DayOfWeek");
      } catch (e) {
        console.info(e)
      }
    })

    it('weekOfMonth', 0, () => {
      try {
        let weekOfMonth: string = WeekFields.SUNDAY_START.weekOfMonth().name()
        expect(weekOfMonth).assertEqual("WeekOfMonth");
      } catch (e) {
        console.info(e)
      }
    })

    it('weekOfYear', 0, () => {
      try {
        let weekOfYear: string = WeekFields.SUNDAY_START.weekOfYear().name()
        expect(weekOfYear).assertEqual("WeekOfYear");
      } catch (e) {
        console.info(e)
      }
    })

    it('weekOfWeekBasedYear', 0, () => {
      try {
        let weekOfWeekBasedYear: string = WeekFields.SUNDAY_START.weekOfWeekBasedYear().name()
        expect(weekOfWeekBasedYear).assertEqual("WeekOfWeekBasedYear");
      } catch (e) {
        console.info(e)
      }
    })

    it('weekBasedYear', 0, () => {
      try {
        let weekBasedYear: string = WeekFields.SUNDAY_START.weekBasedYear().name()
        expect(weekBasedYear).assertEqual("WeekBasedYear");
      } catch (e) {
        console.info(e)
      }
    })

    it('equals', 0, () => {
      try {
        let equalsParam: boolean = WeekFields.SUNDAY_START.equals(2)
        expect(equalsParam).assertEqual(false);
      } catch (e) {
        console.info(e)
      }
    })

    it('hashCode', 0, () => {
      try {
        let hashCodeParam: number = WeekFields.SUNDAY_START.hashCode()
        expect(hashCodeParam).assertEqual(43);
      } catch (e) {
        console.info(e)
      }
    })

    it('toString', 0, () => {
      try {
        let toStringParam: string = WeekFields.SUNDAY_START.toString()
        expect(toStringParam).assertEqual("WeekFields[SUNDAY,1]");
      } catch (e) {
        console.info(e)
      }
    })
  })
}