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


import {
  ChronoField,
  ChronoUnit,
  DateTimeFormatter,
  LocalDate,
  LocalDateTime,
  LocalTime,
  Period,
  TemporalAdjusters
} from '@js-joda/core'

import { describe, expect, it } from '@ohos/hypium'


export default function jodaTest22() {

  describe('JsJodaTest1', () => {
      it('assertLocalDate_parse', 0, () => {
        let a = '2022-07-21';
        let b = LocalDate.parse("2022-07-21").toString();
        expect(a).assertEqual(b);
      })


      it('assertLocalDate_dayOfMonth', 0, () => {
        let a = '21';
        let b = LocalDate.parse("2022-07-21").dayOfMonth().toString();

        expect(a).assertEqual(b);
      })


      it('assertLocalDate_month', 0, () => {
        let a = 'JULY';
        let b = LocalDate.parse("2022-07-21").month().toString();

        expect(a).assertEqual(b);
      })


      it('assertLocalDate_monthValue', 0, () => {
        let a = '7';
        let b = LocalDate.parse("2022-07-21").monthValue().toString();

        expect(a).assertEqual(b);
      })


      it('assertLocalDate_year', 0, () => {
        let a = '2022';
        let b = LocalDate.parse("2022-07-21").year().toString();

        expect(a).assertEqual(b);
      })


      it('assertLocalDate_dayOfWeek', 0, () => {
        let a = 'THURSDAY';
        let b = LocalDate.parse("2022-07-21").dayOfWeek().toString();

        expect(a).assertEqual(b);
      })


      it('assertLocalDate_dayOfWeekValue', 0, () => {
        let a = '4';
        let b = LocalDate.parse("2022-07-21").dayOfWeek().value().toString();

        expect(a).assertEqual(b);
      })


      it('assertLocalDate_dayOfYear', 0, () => {
        let a = '202';
        let b = LocalDate.parse("2022-07-21").dayOfYear().toString();

        expect(a).assertEqual(b);
      })


      it('assertLocalDate_isLeapYear', 0, () => {
        let a = false;
        let b = LocalDate.parse("2022-07-21").isLeapYear();

        expect(a).assertEqual(b);
      })


      it('assertLocalDate_lengthOfMonth', 0, () => {
        let a = '31';
        let b = LocalDate.parse("2022-07-21").lengthOfMonth().toString();

        expect(a).assertEqual(b);
      })


      it('assertLocalDate_lengthOfYear', 0, () => {
        let a = '365';
        let b = LocalDate.parse("2022-07-21").lengthOfYear().toString();

        expect(a).assertEqual(b);
      })


      it('assertLocalDate_ALIGNED_WEEK_OF_YEAR', 0, () => {
        let a = '29';
        let b = LocalDate.parse("2022-07-21").get(ChronoField.ALIGNED_WEEK_OF_YEAR).toString();

        expect(a).assertEqual(b);
      })


      it('assertLocalDate_plusDays', 0, () => {
        let a = '2023-07-22';
        let b = LocalDate.parse("2022-07-21").plusDays(366).toString();

        expect(a).assertEqual(b);
      })


      it('assertLocalDate_minusDays', 0, () => {
        let a = '2021-07-20';
        let b = LocalDate.parse("2022-07-21").minusDays(366).toString();

        expect(a).assertEqual(b);
      })


      it('assertLocalDate_plusMonths', 0, () => {
        let a = '2023-07-21';
        let b = LocalDate.parse("2022-07-21").plusMonths(12).toString();

        expect(a).assertEqual(b);
      })


      it('assertLocalDate_minusMonths', 0, () => {
        let a = '2021-07-21';
        let b = LocalDate.parse("2022-07-21").minusMonths(12).toString();

        expect(a).assertEqual(b);
      })


      it('assertLocalDate_plusWeeks', 0, () => {
        let a = '2022-08-18';
        let b = LocalDate.parse("2022-07-21").plusWeeks(4).toString();

        expect(a).assertEqual(b);
      })


      it('assertLocalDate_minusWeeks', 0, () => {
        let a = '2022-06-23';
        let b = LocalDate.parse("2022-07-21").minusWeeks(4).toString();

        expect(a).assertEqual(b);
      })


      it('assertLocalDate_plusYears', 0, () => {
        let a = '2023-07-21';
        let b = LocalDate.parse("2022-07-21").plusYears(1).toString();

        expect(a).assertEqual(b);
      })


      it('assertLocalDate_minusYears', 0, () => {
        let a = '2021-07-21';
        let b = LocalDate.parse("2022-07-21").minusYears(1).toString();

        expect(a).assertEqual(b);
      })


      it('assertLocalDate_plus', 0, () => {
        let a = '2022-08-24';
        let b = LocalDate.parse("2022-07-21").plus(Period.ofMonths(1).plusDays(3)).toString();

        expect(a).assertEqual(b);
      })


      it('assertLocalDate_minus', 0, () => {
        let a = '2022-06-18';
        let b = LocalDate.parse("2022-07-21").minus(Period.ofMonths(1).plusDays(3)).toString();

        expect(a).assertEqual(b);
      })


      it('assertLocalDate_withDayOfMonth', 0, () => {
        let a = '2022-07-01';
        let b = LocalDate.parse("2022-07-21").withDayOfMonth(1).toString();

        expect(a).assertEqual(b);
      })


      it('assertLocalDate_withDayOfYear', 0, () => {
        let a = '2021-02-11';
        let b = LocalDate.parse("2021-07-21").withDayOfYear(42).toString();

        expect(a).assertEqual(b);
      })


      it('assertLocalDate_withMonth_withDayOfMonth', 0, () => {
        let a = '2021-01-01';
        let b = LocalDate.parse("2021-07-21").withMonth(1).withDayOfMonth(1).toString();

        expect(a).assertEqual(b);
      })


      it('assertLocalDate_withYear', 0, () => {
        let a = '0001-07-21';
        let b = LocalDate.parse("2021-07-21").withYear(1).toString();

        expect(a).assertEqual(b);
      })


      it('assertLocalDate_isAfter', 0, () => {
        let mDate1 = LocalDate.parse('2022-07-25');
        let mDate2 = mDate1.plusDays(2)

        expect(false).assertEqual(mDate1.isAfter(mDate2));
      })


      it('assertLocalDate_isBefore', 0, () => {
        let mDate1 = LocalDate.parse('2022-07-25');
        let mDate2 = mDate1.plusDays(2)

        expect(true).assertEqual(mDate1.isBefore(mDate2));
      })


      it('assertLocalDate_with', 0, () => {
        let mDate1 = LocalDate.parse('2022-07-25');
        let mDate2 = '2022-07-31'

        expect(mDate2).assertEqual(mDate1.with(TemporalAdjusters.lastDayOfMonth()).toString());
      })


      it('assertLocalTime_of', 0, () => {
        let mDate1 = '23:55:42'
        let mDate2 = LocalTime.of(23, 55, 42).toString()

        expect(mDate1).assertEqual(mDate2);
      })


      it('assertLocalTime_ofSecondDay', 0, () => {
        let mDate1 = '01:01:06'
        let mDate2 = LocalTime.ofSecondOfDay(3666).toString()

        expect(mDate1).assertEqual(mDate2);
      })


      it('assertLocalTime_ofSecondDay1', 0, () => {
        let mDate1 = '01:01:06'
        let mDate2 = LocalTime.ofSecondOfDay(3666).toString()

        expect(mDate1).assertEqual(mDate2);
      })


      it('assertLocalTime_truncatedTo', 0, () => {
        let mDate1 = '23:55:42'
        let mDate2 = LocalTime.parse('23:55:42.123').truncatedTo(ChronoUnit.SECONDS).toString()

        expect(mDate1).assertEqual(mDate2);
      })


      it('assertLocalTime_hour', 0, () => {
        let mDate1 = '23'
        let mDate2 = LocalTime.parse('23:55:42.123').hour().toString()

        expect(mDate1).assertEqual(mDate2);
      })


      it('assertLocalTime_minute', 0, () => {
        let mDate1 = '55'
        let mDate2 = LocalTime.parse('23:55:42.123').minute().toString()

        expect(mDate1).assertEqual(mDate2);
      })


      it('assertLocalTime_second', 0, () => {
        let mDate1 = '42'
        let mDate2 = LocalTime.parse('23:55:42.123').second().toString()

        expect(mDate1).assertEqual(mDate2);
      })


      it('assertLocalTime_second_of_day', 0, () => {
        let mDate1 = '86142'
        let mDate2 = LocalTime.parse('23:55:42.123').get(ChronoField.SECOND_OF_DAY).toString()

        expect(mDate1).assertEqual(mDate2);
      })


      it('assertLocalTime_HOUR_OF_AMPM', 0, () => {
        let mDate1 = '11'
        let mDate2 = LocalTime.parse('23:55:42.123').get(ChronoField.HOUR_OF_AMPM).toString()

        expect(mDate1).assertEqual(mDate2);
      })


      it('assertLocalTime_plusHours', 0, () => {
        let mDate1 = '23:55:42'
        let mDate2 = LocalTime.parse('11:55:42').plusHours(12).toString()

        expect(mDate1).assertEqual(mDate2);
      })


      it('assertLocalTime_plusMinutes', 0, () => {
        let mDate1 = '12:25:42'
        let mDate2 = LocalTime.parse('11:55:42').plusMinutes(30).toString()

        expect(mDate1).assertEqual(mDate2);
      })


      it('assertLocalTime_plusSeconds', 0, () => {
        let mDate1 = '11:56:12'
        let mDate2 = LocalTime.parse('11:55:42').plusSeconds(30).toString()

        expect(mDate1).assertEqual(mDate2);
      })


      it('assertLocalTime_withHour', 0, () => {
        let mDate1 = '01:55:42'
        let mDate2 = LocalTime.parse('11:55:42').withHour(1).toString()

        expect(mDate1).assertEqual(mDate2);
      })


      it('assertLocalTime_withMinute', 0, () => {
        let mDate1 = '11:01:42'
        let mDate2 = LocalTime.parse('11:55:42').withMinute(1).toString()

        expect(mDate1).assertEqual(mDate2);
      })

      it('assertLocalTime_withSecond', 0, () => {
        let mDate1 = '11:55:01'
        let mDate2 = LocalTime.parse('11:55:42').withSecond(1).toString()

        expect(mDate1).assertEqual(mDate2);
      })


      it('assertLocalDateTime_format', 0, () => {
        let mDate1 = '4/28/2018';
        let mDate2 = LocalDateTime.parse('2018-04-28T12:34')
          .format(DateTimeFormatter.ofPattern('M/d/yyyy')).toString()

        expect(mDate1).assertEqual(mDate2);
      })
  })

}
 
