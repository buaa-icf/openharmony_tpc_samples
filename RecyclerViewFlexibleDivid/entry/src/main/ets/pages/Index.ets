/*
 * Copyright (C) 2022 Huawei Device Co., Ltd.
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

import { DividerLine } from "recyclerviewflexibledivid"

@Entry
@ComponentV2
struct Index {
  build() {
    Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Center }) {
      Column() {
        DividerLine({ lineLength: 200, color: "blue" })
      }.margin({ top: 20, bottom: 20 })

      Column() {
        DividerLine({ lineLength: 300, color: "#FF66CC", lineWidth: 10 })
      }.margin({ top: 30, bottom: 40 })

      Column() {
        DividerLine({ lineLength: 300, color: "#FF0000", lineWidth: 1 })
      }.margin({ top: 50, bottom: 40 })

      Column() {
        DividerLine({
          lineLength: 300,
          color: "#FF6699",
          dashed: false,
          dashLength: 3,
          times: 15
        })
      }

      Column() {
        DividerLine({
          lineLength: 200,
          color: "#66CCFF",
          dashed: false,
          dashLength: 10,
          times: 15
        })
      }.margin({ top: 60 })
    }.height("100%")
    .width("100%")
  }
}