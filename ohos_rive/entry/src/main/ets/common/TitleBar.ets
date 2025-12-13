/*
 * Copyright (C) 2025 Huawei Device Co., Ltd.
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

/**
 * 通用标题栏组件
 * 所有页面可复用的标题栏
 */
@Component
export struct TitleBar {
  title: string = 'Rive Samples' // 默认标题
  
  build() {
    Row() {
      Text(this.title)
        .fontSize(20)
        .fontWeight(FontWeight.Medium)
        .textAlign(TextAlign.Center)
        .fontColor('#FFFFFF')
        .margin({ left: 20 })
    }
    .width('100%')
    .height(56)
    .backgroundColor('#6200EE')
    .alignItems(VerticalAlign.Center)
  }
}
