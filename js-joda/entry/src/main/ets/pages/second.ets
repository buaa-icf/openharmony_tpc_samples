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
  DayOfWeek,
  Duration,
  LocalDate,
  LocalDateTime,
  LocalTime,
  Month,
  Period,
  TemporalAdjusters,
  ZonedDateTime,
  ZoneId,
  ZoneOffset
} from '@js-joda/core';
import router from '@ohos.router';

@Entry
@Component
struct Second {
  @State message: string = ''

  build() {
    Row() {
      Scroll() {
        Column() {
          Button($r('app.string.Local_time_testing'), { type: ButtonType.Capsule, stateEffect: true })
            .backgroundColor(0x317aff)
            .width(240)
            .onClick(() => {
              let context: Context | undefined = this.getUIContext().getHostContext();
              this.message = testLocalTime(context);
            })
          Text(this.message)
            .fontSize(15)
            .margin(10)
            .fontColor(Color.Blue)

          Button($r('app.string.next_page'), { type: ButtonType.Capsule, stateEffect: true })
            .backgroundColor(0x317aff)
            .width(240)
            .onClick(() => {
              this.getUIContext().getRouter().pushUrl({ url: 'pages/third' })
            })
        }
      }
      .width('100%')
    }
    .height('100%')
  }
}

// 测试本地时间
function testLocalTime(context: Context | undefined): string {
  // 获取当前时间（默认时区）
  console.info(LocalTime.now(ZoneOffset.UTC).toString());
  // 获取国内时间东8区时间（ZoneId城市对照表可在百度搜索）
  //console.info(LocalTime.now(ZoneId.of("Asia/Shanghai")).toString());
  // 从时分秒中格式化时间：23:55:42
  console.info(LocalTime.of(23, 55, 42).toString());
  // 根据提供的秒获取时间：01:01:06
  console.info(LocalTime.ofSecondOfDay(3666).toString());


  // 时间解析：23:55:42.123
  let mTime = LocalTime.parse("23:55:42.123");

  // 时间格式化截断到秒：23:55:42
  console.info(mTime.truncatedTo(ChronoUnit.SECONDS).toString());
  // 获取小时数：23
  console.info(mTime.hour().toString());
  // 获取分钟数：55
  console.info(mTime.minute().toString());
  // 获取秒数：42
  console.info(mTime.second().toString());
  // 获取纳秒：123000000
  console.info(mTime.nano().toString());
  // 测试时间在一天中秒数：86142
  console.info(mTime.get(ChronoField.SECOND_OF_DAY).toString());
  // 测试时间在AM PM中小时数：11
  console.info(mTime.get(ChronoField.HOUR_OF_AMPM).toString());

  // *********************************时间计算***************************
  let mTime1 = LocalTime.parse("11:55:42");

  // 增加12小时：23:55:42
  console.info(mTime1.plusHours(12).toString());
  // 增加30分钟：12:25:42
  console.info(mTime1.plusMinutes(30).toString());
  // 增加30秒：11:56:12
  console.info(mTime1.plusSeconds(30).toString());
  // 增加1000000纳秒：11:55:4.001
  console.info(mTime1.plusNanos(1000000).toString());
  // 增加1毫秒：11:55:42.001
  console.info(mTime1.plus(1, ChronoUnit.MILLIS).toString());
  // 增加半天：23:55:42
  console.info(mTime1.plus(1, ChronoUnit.HALF_DAYS).toString());
  // 将小时设置为1:  01：55:42
  console.info(mTime1.withHour(1).toString());
  // 将分钟设置为1：  11:01:42
  console.info(mTime1.withMinute(1).toString());
  // 将秒数设置为1：   11:55:01
  console.info(mTime1.withSecond(1).toString());
  // 比较两个时间
  let mTime2 = mTime1.plusHours(2);

  console.info(mTime1.isAfter(mTime2) + '');
  console.info(mTime1.isBefore(mTime2) + '');
  // 计算两个时间的间隔
  let mTime3 = mTime1.plusHours(2).plusMinutes(42).plusSeconds(12);

  // 两个时间间隔的小时数：2
  console.info(mTime1.until(mTime3, ChronoUnit.HOURS).toString())
  // 两个时间间隔的分钟数：162
  console.info(mTime1.until(mTime3, ChronoUnit.MINUTES).toString())
  // 两个时间间隔的秒数：9732
  console.info(mTime1.until(mTime3, ChronoUnit.SECONDS).toString())


  return context?.resourceManager.getStringByNameSync("Get_default_time") + LocalTime.now(ZoneOffset.UTC).toString() + '\n' +
    context?.resourceManager.getStringByNameSync("Format_time_from_hours_minutes_and_seconds")  + LocalTime.of(23, 55, 42).toString() + '\n' +
    context?.resourceManager.getStringByNameSync("Retrieve_time_from_the_provided_seconds")  + LocalTime.ofSecondOfDay(3666).toString() + '\n' +
    context?.resourceManager.getStringByNameSync("Given_time_analysis")  + mTime.toString() + '\n' +
    context?.resourceManager.getStringByNameSync("Time_formatting_truncated_to_seconds")  + mTime.truncatedTo(ChronoUnit.SECONDS).toString() + '\n' +
    context?.resourceManager.getStringByNameSync("Get_the_given_time_hours")  + mTime.hour().toString() + '\n' +
    context?.resourceManager.getStringByNameSync("Get_the_given_number_of_minutes_at_a_given_time") + mTime.minute().toString() + '\n' +
    context?.resourceManager.getStringByNameSync("Get_the_given_time_in_seconds")  + mTime.second().toString() + '\n' +
    context?.resourceManager.getStringByNameSync("Obtain_the_number_of_nanoseconds_at_a_given_time")  + mTime.nano().toString() + '\n' +
    context?.resourceManager.getStringByNameSync("Given_the_number_of_seconds_in_a_day_at_a_given_time") + mTime.get(ChronoField.SECOND_OF_DAY).toString() + '\n' +
    context?.resourceManager.getStringByNameSync("Test_time_in_AM_PM_hours")  + mTime.get(ChronoField.HOUR_OF_AMPM).toString() + '\n' +
    context?.resourceManager.getStringByNameSync("Add_12_hours_to_the_given_time")  + mTime1.plusHours(12).toString() + '\n' +
    context?.resourceManager.getStringByNameSync("Add_30_minutes_to_the_given_time")  + mTime1.plusMinutes(30).toString() + '\n' +
    context?.resourceManager.getStringByNameSync("Add_30_seconds_to_the_given_time")  + mTime1.plusSeconds(30).toString() + '\n' +
    context?.resourceManager.getStringByNameSync("Increase_the_given_time_by_1000000_nanoseconds")  + mTime1.plusNanos(1000000).toString() + '\n' +
    context?.resourceManager.getStringByNameSync("Add_1_millisecond_to_the_given_time")  + mTime1.plus(1, ChronoUnit.MILLIS).toString() + '\n' +
    context?.resourceManager.getStringByNameSync("Add_half_a_day_to_the_given_time") + mTime1.plus(1, ChronoUnit.HALF_DAYS).toString() + '\n' +
    context?.resourceManager.getStringByNameSync("Set_the_hour_to_1")  + mTime1.withHour(1).toString() + '\n' +
    context?.resourceManager.getStringByNameSync("Set_the_minute_to_1")  + mTime1.withMinute(1).toString() + '\n' +
    context?.resourceManager.getStringByNameSync("Set_the_number_of_seconds_to_1")  + mTime1.withSecond(1).toString();
}
