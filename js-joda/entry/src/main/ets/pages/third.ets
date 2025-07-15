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

import { DateTimeFormatter, LocalDateTime, ZoneId, Clock ,ZoneRegion, ZonedDateTime} from '@js-joda/core';
import hilog from '@ohos.hilog';

@Entry
@Component
struct Third {
  @State message: string = ''

  build() {
    Row() {
      Scroll() {
        Column() {
          Button($r('app.string.Local_date_and_time_testing'), { type: ButtonType.Capsule, stateEffect: true })
            .backgroundColor(0x317aff)
            .width(240)
            .onClick(() => {
              let context: Context | undefined = this.getUIContext().getHostContext();
              this.message = testLocalDateTime(context);
            })
          Text(this.message)
            .fontSize(15)
            .margin(10)
            .fontColor(Color.Blue)

          Button($r('app.string.next_page'), { type: ButtonType.Capsule, stateEffect: true })
            .backgroundColor(0x317aff)
            .width(240)
            .onClick(() => {
              this.getUIContext().getRouter().pushUrl({ url: 'pages/fourth' })
            })
        }
      }
      .width('100%')
    }
    .height('100%')
  }
}

// 本地日期时间测试
function testLocalDateTime(context: Context | undefined): string {
  // 获取日期时间（默认时区 UTC协调世界时）
  console.info(LocalDateTime.now().toString());
  // 获取指定城市的日期时间
  // 构建一个日期时间：2016-02-29T12:55:42.000000009
  console.info(LocalDateTime.of(2016, 2, 29, 12, 55, 42, 9).toString());
  // 获取日期时间类中的信息
  let mDateTime = LocalDateTime.parse("2016-02-29T12:55:42.000000009");

  // ISO 8601规范日期时间值
  console.info(mDateTime.toString());
  // 格式化日期 按照M/d/yyyy格式显示日期
  // 格式化时间 按照HH:mm来显示时间
  console.info(mDateTime.format(DateTimeFormatter.ofPattern('HH:mm')).toString());
  // 获取当年年份：2016
  console.info(mDateTime.year().toString());
  // 获取月份
  console.info(mDateTime.month().toString());
  // 获取月份的值
  console.info(mDateTime.monthValue().toString());
  // 获取当月日期
  console.info(mDateTime.dayOfMonth().toString());
  // 获取小时数
  console.info(mDateTime.hour().toString());
  // 获取分钟数
  console.info(mDateTime.minute().toString());
  // 获取秒数
  console.info(mDateTime.second().toString());
  // 获取纳秒数
  console.info(mDateTime.nano().toString());
  // 获取周几
  console.info(mDateTime.dayOfWeek().toString());
  // 获取周几的数字值
  console.info(mDateTime.dayOfWeek().value().toString());
  // 获取在一年中的日期
  console.info(mDateTime.dayOfYear().toString());
  // 判断是否为闰年
  console.info(mDateTime.toLocalDate().isLeapYear() + '');
  // 转换成日期展示
  console.info(mDateTime.toLocalDate().toString());
  // 转换成时间展示
  console.info(mDateTime.toLocalTime().toString());
  // 获取当月的天数
  console.info(mDateTime.toLocalDate().lengthOfMonth().toString());
  // 获取当前的总天数
  console.info(mDateTime.toLocalDate().lengthOfYear().toString());
  return getStringByNameSync(context, "Get_date_and_time") + LocalDateTime.now().toString() + '\n' +
    getStringByNameSync(context, "Obtain_domestic_city_date_and_time")+ LocalDateTime.now(ZoneId.systemDefault()).toString() + '\n' +
    getStringByNameSync(context, "Build_date_and_time_based_on_given_data") + LocalDateTime.of(2016, 2, 29, 12, 55, 42, 9).toString() + '\n' +
    getStringByNameSync(context, "Obtain_the_given_date_and_year")+ mDateTime.year().toString() + '\n' +
    getStringByNameSync(context, "Get_the_given_date_month") + mDateTime.month().toString() + '\n' +
    getStringByNameSync(context, "Get_the_value_of_the_given_date_and_month") + mDateTime.monthValue().toString() + '\n' +
    getStringByNameSync(context, "Get_the_given_date_on_which_day_of_the_month") + mDateTime.dayOfMonth().toString() + '\n' +
    getStringByNameSync(context, "Obtain_the_number_of_hours")+ mDateTime.hour().toString() + '\n' +
    getStringByNameSync(context, "Get_minutes") + mDateTime.minute().toString() + '\n' +
    getStringByNameSync(context, "Get_seconds") + mDateTime.second().toString() + '\n' +
    getStringByNameSync(context, "Obtain_nanosecond_count") + mDateTime.nano().toString() + '\n' +
    getStringByNameSync(context, "Obtain_the_day_of_the_week") + mDateTime.dayOfWeek().toString() + '\n' +
    getStringByNameSync(context, "Obtain_dates_within_a_year") + mDateTime.dayOfYear().toString() + '\n' +
    getStringByNameSync(context, "Get_the_total_number_of_days_in_a_given_month") + mDateTime.toLocalDate().lengthOfMonth().toString() + '\n' +
    getStringByNameSync(context, "Obtain_the_total_number_of_days_in_a_given_year") + mDateTime.toLocalDate().lengthOfYear().toString();
}

// 获取指定资源名称对应的字符串
function getStringByNameSync(context: Context | undefined, resName: string): string {
  try {
    return context?.resourceManager.getStringByNameSync(resName) || "";
  }catch (e){
    hilog.error(0x0001, "[js-joda]", "getStringByNameSync error, message %{private}d", JSON.stringify(e));
    return "";
  }
}