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

import { ChronoField, ChronoUnit, DayOfWeek, LocalDate, Month, Period, TemporalAdjusters, } from '@js-joda/core'
// import '@js-joda/timezone'
import router from '@ohos.router';

@Entry
@Component
struct Index {
  @State message: string = ''

  build() {
    Row() {
      Scroll() {
        Column() {
          Button($r('app.string.Local_date_testing'), { type: ButtonType.Capsule, stateEffect: true })
            .backgroundColor(0x317aff)
            .width(240)
            .onClick(() => {
              this.message = testLocalDate();
            })

          Text(this.message)
            .fontSize(15)
            .margin(10)
            .fontColor(Color.Blue)

          Button($r('app.string.next_page'), { type: ButtonType.Capsule, stateEffect: true })
            .backgroundColor(0x317aff)
            .width(240)
            .onClick(() => {
              router.pushUrl({ url: 'pages/second' })
            })
        }
      }
      .width('100%')
    }
    .height('100%')
  }
}

// 测试本地日期
function testLocalDate(): string {
  // 获取当前日期
  console.log(LocalDate.now().toString());

  // 解析日期2022-07-21
  console.log(LocalDate.now().toString());
  let mDate = LocalDate.parse("2022-07-21");

  console.info(mDate.toString());
  // 当前日期时半月的第几天:21

  console.info(mDate.dayOfMonth().toString());

  // 当前月份:JULY
  console.info(mDate.month().toString());
  // 当前月份对应的值:7

  console.info(mDate.monthValue().toString());

  // 当前年份:2022

  console.info(mDate.year().toString());
  // 当前日期是周几:THURSDAY

  console.info(mDate.dayOfWeek().toString());
  // 当前日期是周几对应的值:4

  console.info(mDate.dayOfWeek().value().toString());
  // 当前日期是一年中的第几天:202

  console.info(mDate.dayOfYear().toString());
  // 当前年根是否为闰年:false

  console.log(mDate.isLeapYear() + '');
  // 当前月有多少天:31

  console.info(mDate.lengthOfMonth().toString());
  // 当前年有多少天:365

  console.info(mDate.lengthOfYear().toString());
  // 当前日期在一年中的第几周：29

  console.info(mDate.get(ChronoField.ALIGNED_WEEK_OF_YEAR).toString());

  // ******************************************日期计算******************************************
  // 当前日期加上366天:2023-07-22
  console.info(mDate.plusDays(366).toString());
  // 当前日期减去366天：2021-7-20
  console.info(mDate.minusDays(366).toString());
  // 当前日期添加12个月：2023-07-21
  console.info(mDate.plusMonths(12).toString());
  // 当前日期减去12个月：2021-07-21
  console.info(mDate.minusMonths(12).toString());
  // 当前日期添加4周：2022-08-18
  console.info(mDate.plusWeeks(4).toString());
  // 当前日期减去4周：2022-06-23
  console.info(mDate.minusWeeks(4).toString());
  // 当前日期添加一年：2023-07-21
  console.info(mDate.plusYears(1).toString());
  // 当前日期减去一年：2021-07-21
  console.info(mDate.minusYears(1).toString());
  // 当前日期加上一个月零3天：2022-08-24
  console.info(mDate.plus(Period.ofMonths(1).plusDays(3)).toString());
  // 当前日期减去一个月零3天：2022-06-18
  console.info(mDate.minus(Period.ofMonths(1).plusDays(3)).toString());
  // 当前日期设置为1号：2022-07-01
  console.info(mDate.withDayOfMonth(1).toString());
  // 当前月和日期设置成1：2022-01-01
  console.info(mDate.withMonth(1).withDayOfMonth(1).toString());
  // 当前月设置成指定月份，日期设置为1:2022-11-01
  console.info(mDate.withMonth(Month.NOVEMBER).withDayOfMonth(1).toString());
  // 当前月份设置为1:0001-07-21
  console.info(mDate.withYear(1).toString());
  // 当前月最后一天
  console.log(LocalDate.now()
    .plusMonths(1)
    .withDayOfMonth(1)
    .minusDays(1)
    .toString());
  // 本年的第42天：2022-02-11
  console.info(mDate.withDayOfYear(42).toString());
  let mDate1 = LocalDate.parse("2022-07-25");
  let mDate2 = mDate1.plusDays(2);
  // 判断两个日期前后：false true
  console.info(mDate1.isAfter(mDate2) + '');
  console.info(mDate1.isBefore(mDate2) + '');
  // 判断两个日期是否相等 false
  console.info(mDate1.equals(mDate2) + '');
  // 判断两个日期间的间隔时间：P2D
  console.info(mDate1.until(mDate2).toString());
  // 判断两个日期间的间隔时间：2
  console.info(mDate1.until(mDate2, ChronoUnit.DAYS).toString());
  // 获取测试月的第一天：2022-07-01
  console.info(mDate1.with(TemporalAdjusters.firstDayOfMonth()).toString());
  // 获取测试月的最后一天：2022-07-31
  console.info(mDate1.with(TemporalAdjusters.lastDayOfMonth()).toString());
  // 获取不小于测试日期的下一个周日日期：2022-07-31
  console.info(mDate1.with(TemporalAdjusters.nextOrSame(DayOfWeek.SUNDAY)).toString());
  // 获取测试月份最后一个周日的日期：2022-07-31
  console.info(mDate1.with(TemporalAdjusters.lastInMonth(DayOfWeek.SUNDAY)).toString());

  return getContext().resourceManager.getStringByNameSync('Analyze_the_given_date') + mDate.toString() + '\n' +
  getContext().resourceManager.getStringByNameSync('What_day_of_the_month_is_the_given_date')  + mDate.dayOfMonth().toString() + '\n' +
  getContext().resourceManager.getStringByNameSync('Given_date_and_month')  + mDate.month().toString() + '\n' +
  getContext().resourceManager.getStringByNameSync('Given_the_value_of_the_month') + mDate.monthValue().toString() + '\n' +
  getContext().resourceManager.getStringByNameSync('Given_date_and_year') + mDate.year().toString() + '\n' +
  getContext().resourceManager.getStringByNameSync('What_day_of_the_week_is_the_given_date') + mDate.dayOfWeek().toString() + '\n' +
  getContext().resourceManager.getStringByNameSync('What_day_of_the_week_is_the_given_date_represented_by_a_numerical_value') + mDate.dayOfWeek().value().toString() + '\n' +
  getContext().resourceManager.getStringByNameSync('What_day_of_the_year_is_the_given_date_is_the_given_year_a_leap_year') + mDate.dayOfYear().toString() + '\n' +
  getContext().resourceManager.getStringByNameSync('Is_the_given_year_a_leap_year') + mDate.isLeapYear() + '\n' +
  getContext().resourceManager.getStringByNameSync('How_many_days_are_there_in_a_given_month') + mDate.lengthOfMonth().toString() + '\n' +
  getContext().resourceManager.getStringByNameSync('How_many_days_are_there_in_a_given_year') + mDate.lengthOfYear().toString() + '\n' +
  getContext().resourceManager.getStringByNameSync('What_week_of_the_year_is_the_given_date_in') + mDate.get(ChronoField.ALIGNED_WEEK_OF_YEAR).toString() + '\n' +
  getContext().resourceManager.getStringByNameSync('Add_366_days_to_the_given_date') + mDate.plusDays(366).toString() + '\n' +
  getContext().resourceManager.getStringByNameSync('Subtract_366_days_from_the_given_date') + mDate.minusDays(366).toString() + '\n' +
  getContext().resourceManager.getStringByNameSync('Given_date_plus_12_months') + mDate.plusMonths(12).toString() + '\n' +
  getContext().resourceManager.getStringByNameSync('Subtract_12_months_from_the_given_date') + mDate.minusMonths(12).toString() + '\n' +
  getContext().resourceManager.getStringByNameSync('Given_date_plus_4_weeks') + mDate.plusWeeks(4).toString() + '\n' +
  getContext().resourceManager.getStringByNameSync('Subtract_4_weeks_from_the_given_date') + mDate.minusWeeks(4).toString() + '\n' +
  getContext().resourceManager.getStringByNameSync('Given_date_plus_1_year') + mDate.plusYears(1).toString() + '\n' +
  getContext().resourceManager.getStringByNameSync('Subtract_1_year_from_the_given_date') + mDate.minusYears(1).toString() + '\n' +
  getContext().resourceManager.getStringByNameSync('Add_one_month_and_three_days_to_the_given_date') + mDate.plus(Period.ofMonths(1).plusDays(3)).toString() + '\n' +
  getContext().resourceManager.getStringByNameSync('Subtract_one_month_and_three_days_from_the_given_date') + mDate.minus(Period.ofMonths(1).plusDays(3)).toString() + '\n' +
  getContext().resourceManager.getStringByNameSync('Set_the_given_date_to_1')+ mDate.withDayOfMonth(1).toString() + '\n' +
  getContext().resourceManager.getStringByNameSync('Set_the_month_and_date_of_the_given_date_to_1') + mDate.withMonth(1).withDayOfMonth(1).toString() + '\n' +
  getContext().resourceManager.getStringByNameSync('On_the_42nd_day_of_a_given_year') + mDate.withDayOfYear(42).toString() + '\n' +
  getContext().resourceManager.getStringByNameSync('The_first_day_of_a_given_month') + mDate.with(TemporalAdjusters.firstDayOfMonth()).toString() + '\n' +
  getContext().resourceManager.getStringByNameSync('Get_current_date') + LocalDate.now().toString() + '\n' +
  getContext().resourceManager.getStringByNameSync('Obtain_the_last_day_of_the_month') + LocalDate.now().plusMonths(1).withDayOfMonth(1).minusDays(1).toString();
}