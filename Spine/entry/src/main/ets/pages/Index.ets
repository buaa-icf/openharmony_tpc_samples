/**
 * Apache License
 *
 * Copyright (C) 2025 Huawei Device Co., Ltd.
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

import router from '@ohos.router';

@Entry
@Component
struct Index {
  build() {
    Column() {
      Column() {
        Button('加载一个动画')
          .margin({ top: 10 })
          .onClick(() => {

            this.getUIContext()?.getRouter()?.pushUrl({ url: "pages/Example1" });
          })

        Button('加载网络动画')
          .margin({ top: 10 })
          .onClick(() => {
            this.getUIContext()?.getRouter()?.pushUrl({ url: "pages/NetworkExample" });
          })

        Button('加载动画')
          .margin({ top: 10 })
          .onClick(() => {
            this.getUIContext()?.getRouter()?.pushUrl({ url: "pages/SingleExample" });
          })
        Button('加载skel格式的动画')
          .margin({ top: 10 })
          .onClick(() => {
            this.getUIContext()?.getRouter()?.pushUrl({ url: "pages/Example2" });
          })
        Button('加载沙箱的动画')
          .margin({ top: 10 })
          .onClick(() => {
            this.getUIContext()?.getRouter()?.pushUrl({ url: "pages/Example3" });
          })
        Button('其它接口')
          .margin({ top: 10 })
          .onClick(() => {
            this.getUIContext()?.getRouter()?.pushUrl({ url: "pages/Example4" });
          })
      }
      .padding(10)
    }
    .height('100%')
    .width('100%')
  }

}
