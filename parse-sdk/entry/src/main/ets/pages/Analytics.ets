/*
  * Copyright (c) 2025 Huawei Device Co., Ltd.
  *
  * Licensed under the Apache License, Version 2.0 (the "License");
  * you may not use this file except in compliance with the License.
  * You may obtain a copy of the License at
    *
  * http://www.apache.org/licenses/LICENSE-2.0
    *
  * Unless required by applicable law or agreed to in writing, software
  * distributed under the License is distributed on an "AS IS" BASIS,
  * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
  * See the License for the specific language governing permissions and
  * limitations under the License.
  */

import { Parse } from '@ohos/parser-sdk';
import { JSON } from '@kit.ArkTS';

@Entry
@Component
struct Analytics {
  @State message: string = '';

  // 模拟搜索事件跟踪
  async trackSearchEvent() {
    try {
      const searchDimensions: ESObject = {
        priceRange: '1000-1500', // 模拟价格区间
        source: 'internal',      // 数据来源
        searchType: 'apartment', // 搜索类型
        dayType: this.getDayType() // 自动获取日期类型
      };

      await Parse.Analytics.track('search', searchDimensions);
      this.message = '搜索事件已记录: ' + JSON.stringify(searchDimensions);
    } catch (e) {
      this.message = '记录失败: ' + e.message;
    }
  }

  // 模拟错误跟踪
  async trackErrorEvent() {
    try {
      const errorDimensions: ESObject = {
        code: '404',            // 模拟错误代码
        module: 'search',        // 模块名称
        platform: 'HarmonyOS'    // 平台信息
      };

      await Parse.Analytics.track('error', errorDimensions);
      this.message = '错误事件已记录: ' + JSON.stringify(errorDimensions);
    } catch (e) {
      this.message = '记录失败: ' + e.message;
    }
  }

  // 辅助方法：获取日期类型
  private getDayType(): string {
    const day = new Date().getDay();
    return (day === 0 || day === 6) ? 'weekend' : 'weekday';
  }

  build() {
    Column({ space: 20 }) {
      Text(this.message)
        .fontSize(16)
        .margin({ top: 16 })

      Button('模拟搜索事件')
        .borderRadius(4)
        .type(ButtonType.Normal)
        .width('100%')
        .onClick(() => this.trackSearchEvent())

      Button('模拟错误事件')
        .borderRadius(4)
        .type(ButtonType.Normal)
        .width('100%')
        .onClick(() => this.trackErrorEvent())
    }
    .width('100%')
    .padding(20)
  }
}