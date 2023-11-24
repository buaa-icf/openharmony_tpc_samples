/*
 * Copyright (C) 2021 Huawei Device Co., Ltd.
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

import { now } from "lodash";

@Entry
@Component
struct Index {
  @State date: number = 0;

  build() {
    Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Center, justifyContent: FlexAlign.Center }) {
      Text('Unix 纪元 (1 January 1970 00:00:00 UTC) 直到现在的毫秒数: '+ this.date);
      Button('获得 Unix 纪元 (1 January 1970 00:00:00 UTC) 直到现在的毫秒数')
        .onClick(() => {
          this.date = now();
          console.log('获得 Unix 纪元 (1 January 1970 00:00:00 UTC) 直到现在的毫秒数:' + this.date)
        }).margin(10)
    }
    .width('100%')
    .height('100%')
  }
}
