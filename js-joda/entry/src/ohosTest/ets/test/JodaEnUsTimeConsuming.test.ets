/**
 * BSD License
 *
 * Copyright (c) 2024 Huawei Device Co., Ltd. All rights reserved.
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


import { Locale, WeekFields }  from '@ohos/localeEnUs'
import { describe, expect, it } from '@ohos/hypium'


export default function jodaEnUsTestTimeConsuming() {
  describe('JsJodaEnUsTimeConsuming', () => {
    const BASE_COUNT = 2000
    const BASELINE_CREATEHTTP = 2000
    it('language', 0, () => {
      let startTime0 = new Date().getTime()
      console.info('appInfoTest xts language startTime:' + startTime0)
      for (let index = 0; index < BASE_COUNT; index++) {
        try {
          let languageParam: string = new Locale("Chinese", "", "").language()
        } catch (e) {
          console.info(e)
        }
      }
      let endTime0= new Date().getTime()
      console.info('appInfoTest xts language endTime:' + endTime0)
      let averageTime0 = (endTime0 - startTime0) * 1000 / BASE_COUNT
      console.info('appInfoTest xts language averageTime:' + averageTime0 + "us")
      expect(averageTime0 < BASELINE_CREATEHTTP).assertTrue();
    })

    it('country', 0, () => {
      let startTime1 = new Date().getTime()
      console.info('appInfoTest xts country startTime:' + startTime1)
      for (let index = 0; index < BASE_COUNT; index++) {
        try {
          let chinaParam: string = new Locale("Chinese", "china", "").country()
        } catch (e) {
          console.info(e)
        }
      }
      let endTime1= new Date().getTime()
      console.info('appInfoTest xts country endTime:' + endTime1)
      let averageTime1 = (endTime1 - startTime1) * 1000 / BASE_COUNT
      console.info('appInfoTest xts country averageTime:' + averageTime1 + "us")
      expect(averageTime1 < BASELINE_CREATEHTTP).assertTrue();
    })


    it('localeString', 0, () => {
      let startTime2 = new Date().getTime()
      console.info('appInfoTest xts localeString startTime:' + startTime2)
      for (let index = 0; index < BASE_COUNT; index++) {
        try {
          let localeStringParam: string = new Locale("Chinese", "china", "localeString").localeString()
        } catch (e) {
          console.info(e)
        }
      }
      let endTime2= new Date().getTime()
      console.info('appInfoTest xts localeString endTime:' + endTime2)
      let averageTime2 = (endTime2 - startTime2) * 1000 / BASE_COUNT
      console.info('appInfoTest xts localeString averageTime:' + averageTime2 + "us")
      expect(averageTime2 < BASELINE_CREATEHTTP).assertTrue();
    })

    it('localeToString', 0, () => {
      let startTime3 = new Date().getTime()
      console.info('appInfoTest xts localeToString startTime:' + startTime3)
      for (let index = 0; index < BASE_COUNT; index++) {
        try {
          let toStringParam: string = new Locale("Chinese", "china", "localeString").toString()
        } catch (e) {
        }
      }
      let endTime3= new Date().getTime()
      console.info('appInfoTest xts localeToString endTime:' + endTime3)
      let averageTime3 = (endTime3 - startTime3) * 1000 / BASE_COUNT
      console.info('appInfoTest xts localeToString averageTime:' + averageTime3 + "us")
      expect(averageTime3 < BASELINE_CREATEHTTP).assertTrue();
    })

    it('localeEquals', 0, () => {
      let startTime4 = new Date().getTime()
      console.info('appInfoTest xts localeEquals startTime:' + startTime4)
      for (let index = 0; index < BASE_COUNT; index++) {
        try {
          let equalsResult: boolean = new Locale("Chinese", "china", "localeString").equals("")
        } catch (e) {
          console.info(e)
        }
      }
      let endTime4= new Date().getTime()
      console.info('appInfoTest xts localeEquals endTime:' + endTime4)
      let averageTime4 = (endTime4 - startTime4) * 1000 / BASE_COUNT
      console.info('appInfoTest xts localeEquals averageTime:' + averageTime4 + "us")
      expect(averageTime4 < BASELINE_CREATEHTTP).assertTrue();
    })


    it('firstDayOfWeek', 0, () => {
      let startTime5 = new Date().getTime()
      console.info('appInfoTest xts firstDayOfWeek startTime:' + startTime5)
      for (let index = 0; index < BASE_COUNT; index++) {
        try {
          let firstDayOfWeek: String = WeekFields.SUNDAY_START.firstDayOfWeek().name()
        } catch (e) {
          console.info(e)
        }
      }
      let endTime5= new Date().getTime()
      console.info('appInfoTest xts firstDayOfWeek endTime:' + endTime5)
      let averageTime5 = (endTime5 - startTime5) * 1000 / BASE_COUNT
      console.info('appInfoTest xts firstDayOfWeek averageTime:' + averageTime5 + "us")
      expect(averageTime5 < BASELINE_CREATEHTTP).assertTrue();
    })

    it('minimalDaysInFirstWeek', 0, () => {
      let startTime6 = new Date().getTime()
      console.info('appInfoTest xts minimalDaysInFirstWeek startTime:' + startTime6)
      for (let index = 0; index < BASE_COUNT; index++) {
        try {
          let minimalDaysInFirstWeek: number = WeekFields.SUNDAY_START.minimalDaysInFirstWeek()
        } catch (e) {
          console.info(e)
        }
      }
      let endTime6= new Date().getTime()
      console.info('appInfoTest xts minimalDaysInFirstWeek endTime:' + endTime6)
      let averageTime6 = (endTime6 - startTime6) * 1000 / BASE_COUNT
      console.info('appInfoTest xts minimalDaysInFirstWeek averageTime:' + averageTime6 + "us")
      expect(averageTime6 < BASELINE_CREATEHTTP).assertTrue();
    })

    it('dayOfWeek', 0, () => {
      let startTime7 = new Date().getTime()
      console.info('appInfoTest xts dayOfWeek startTime:' + startTime7)
      for (let index = 0; index < BASE_COUNT; index++) {
        try {
          let dayOfWeek: string = WeekFields.SUNDAY_START.dayOfWeek().name()
        } catch (e) {
          console.info(e)
        }
      }
      let endTime7= new Date().getTime()
      console.info('appInfoTest xts dayOfWeek endTime:' + endTime7)
      let averageTime7 = (endTime7 - startTime7) * 1000 / BASE_COUNT
      console.info('appInfoTest xts dayOfWeek averageTime:' + averageTime7 + "us")
      expect(averageTime7 < BASELINE_CREATEHTTP).assertTrue();
    })

    it('weekOfMonth', 0, () => {
      let startTime8 = new Date().getTime()
      console.info('appInfoTest xts weekOfMonth startTime:' + startTime8)
      for (let index = 0; index < BASE_COUNT; index++) {
        try {
          let weekOfMonth: string = WeekFields.SUNDAY_START.weekOfMonth().name()
        } catch (e) {
          console.info(e)
        }
      }
      let endTime8= new Date().getTime()
      console.info('appInfoTest xts weekOfMonth endTime:' + endTime8)
      let averageTime8 = (endTime8 - startTime8) * 1000 / BASE_COUNT
      console.info('appInfoTest xts weekOfMonth averageTime:' + averageTime8 + "us")
      expect(averageTime8 < BASELINE_CREATEHTTP).assertTrue();
    })

    it('weekOfYear', 0, () => {
      let startTime9 = new Date().getTime()
      console.info('appInfoTest xts weekOfYear startTime:' + startTime9)
      for (let index = 0; index < BASE_COUNT; index++) {
        try {
          let weekOfYear: string = WeekFields.SUNDAY_START.weekOfYear().name()
        } catch (e) {
          console.info(e)
        }
      }
      let endTime9= new Date().getTime()
      console.info('appInfoTest xts weekOfYear endTime:' + endTime9)
      let averageTime9 = (endTime9 - startTime9) * 1000 / BASE_COUNT
      console.info('appInfoTest xts weekOfYear averageTime:' + averageTime9 + "us")
      expect(averageTime9 < BASELINE_CREATEHTTP).assertTrue();
    })

    it('weekOfWeekBasedYear', 0, () => {
      let startTime10 = new Date().getTime()
      console.info('appInfoTest xts weekOfWeekBasedYear startTime:' + startTime10)
      for (let index = 0; index < BASE_COUNT; index++) {
        try {
          let weekOfWeekBasedYear: string = WeekFields.SUNDAY_START.weekOfWeekBasedYear().name()
        } catch (e) {
          console.info(e)
        }
      }
      let endTime10= new Date().getTime()
      console.info('appInfoTest xts weekOfWeekBasedYear endTime:' + endTime10)
      let averageTime10 = (endTime10 - startTime10) * 1000 / BASE_COUNT
      console.info('appInfoTest xts weekOfWeekBasedYear averageTime:' + averageTime10 + "us")
      expect(averageTime10 < BASELINE_CREATEHTTP).assertTrue();
    })

    it('weekBasedYear', 0, () => {
      let startTime11 = new Date().getTime()
      console.info('appInfoTest xts weekBasedYear startTime:' + startTime11)
      for (let index = 0; index < BASE_COUNT; index++) {
        try {
          let weekBasedYear: string = WeekFields.SUNDAY_START.weekBasedYear().name()
        } catch (e) {
          console.info(e)
        }
      }
      let endTime11= new Date().getTime()
      console.info('appInfoTest xts weekBasedYear endTime:' + endTime11)
      let averageTime11 = (endTime11 - startTime11) * 1000 / BASE_COUNT
      console.info('appInfoTest xts weekBasedYear averageTime:' + averageTime11 + "us")
      expect(averageTime11 < BASELINE_CREATEHTTP).assertTrue();
    })

    it('equals', 0, () => {
      let startTime12 = new Date().getTime()
      console.info('appInfoTest xts equals startTime:' + startTime12)
      for (let index = 0; index < BASE_COUNT; index++) {
        try {
          let equalsParam: boolean = WeekFields.SUNDAY_START.equals(2)
        } catch (e) {
          console.info(e)
        }
      }
      let endTime12= new Date().getTime()
      console.info('appInfoTest xts equals endTime:' + endTime12)
      let averageTime12 = (endTime12 - startTime12) * 1000 / BASE_COUNT
      console.info('appInfoTest xts equals averageTime:' + averageTime12 + "us")
      expect(averageTime12 < BASELINE_CREATEHTTP).assertTrue();
    })

    it('hashCode', 0, () => {
      let startTime13 = new Date().getTime()
      console.info('appInfoTest xts hashCode startTime:' + startTime13)
      for (let index = 0; index < BASE_COUNT; index++) {
        try {
          let hashCodeParam: number = WeekFields.SUNDAY_START.hashCode()
        } catch (e) {
          console.info(e)
        }
      }
      let endTime13= new Date().getTime()
      console.info('appInfoTest xts hashCode endTime:' + endTime13)
      let averageTime13 = (endTime13 - startTime13) * 1000 / BASE_COUNT
      console.info('appInfoTest xts hashCode averageTime:' + averageTime13 + "us")
      expect(averageTime13 < BASELINE_CREATEHTTP).assertTrue();
    })

    it('toString', 0, () => {
      let startTime14 = new Date().getTime()
      console.info('appInfoTest xts toString startTime:' + startTime14)
      for (let index = 0; index < BASE_COUNT; index++) {
        try {
          let toStringParam: string = WeekFields.SUNDAY_START.toString()
        } catch (e) {
          console.info(e)
        }
      }
      let endTime14= new Date().getTime()
      console.info('appInfoTest xts toString endTime:' + endTime14)
      let averageTime14 = (endTime14 - startTime14) * 1000 / BASE_COUNT
      console.info('appInfoTest xts toString averageTime:' + averageTime14 + "us")
      expect(averageTime14 < BASELINE_CREATEHTTP).assertTrue();
    })
  })
}
