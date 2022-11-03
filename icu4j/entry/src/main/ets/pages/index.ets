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

import { parse } from '@f-fjs/intl-messageformat-parser'
import { setData, CustomDialogExample } from './loading'


@Entry
@Component
struct Index {
  dialogController: CustomDialogController = new CustomDialogController({
    builder: CustomDialogExample({}),
    autoCancel: true
  });

  build() {
    Row() {
      Column() {

        Text('On{takenDate,date,short} {name} took {numPhotos,plural, =0 {no photos.}} =1{one photo.} other {# photos}}').fontSize(18)

        Button('解析字符串').fontSize(24).onClick(() => {
          const ast = parse('On{takenDate,date,short} {name} took {numPhotos,plural, =0 {no photos.}} =1{one photo.} other {# photos}}')
          setData(JSON.stringify(ast), this)
        })

      }
      .width('100%')
    }
    .height('100%')
  }
}