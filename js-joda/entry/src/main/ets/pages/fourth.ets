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
  ZonedDateTime,
  ZoneId
} from '@js-joda/core'
import hilog from '@ohos.hilog';

@Entry
@Component
struct Fourth {
  @State message: string = ''

  build() {
    Row() {
      Scroll() {
        Column() {
          Button($r('app.string.Test_with_time_zone_date_and_time'), { type: ButtonType.Capsule, stateEffect: true })
            .backgroundColor(0x317aff)
            .width(240)
            .onClick(() => {
              let context: Context | undefined = this.getUIContext().getHostContext();
              this.message = testZonedDateTime(context);
            })
          Text(this.message)
            .fontSize(15)
            .margin(10)
            .fontColor(Color.Blue)

          Button($r('app.string.next_page'), { type: ButtonType.Capsule, stateEffect: true })
            .backgroundColor(0x317aff)
            .width(240)
            .onClick(() => {
              this.getUIContext().getRouter().pushUrl({ url: 'pages/fifth' })
            })
        }
      }
      .width('100%')
    }
    .height('100%')
  }
}

// 带时区日期时间测试
function testZonedDateTime(context: Context | undefined) {
  // 获取默认时区的日期时间 协调世界时
  console.info(ZonedDateTime.now().toString());
  // 转换固定偏移量日期时间
  console.info(ZonedDateTime.now().withFixedOffsetZone().toString());
  // 指定城市的日期时间
  console.info(ZonedDateTime.now(ZoneId.systemDefault()).toString());

  console.info(ZonedDateTime.now(ZoneId.systemDefault()).toString());

  return getStringByNameSync(context, "Get_date_and_time_with_time_zone") + ZonedDateTime.now().toString() + '\n' +
  getStringByNameSync(context, "Obtain_domestic_Shanghai_date_and_time")+ ZonedDateTime.now(ZoneId.systemDefault()).toString() + '\n';
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