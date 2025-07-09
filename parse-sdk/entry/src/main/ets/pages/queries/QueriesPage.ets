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
import router from '@ohos.router'

@Entry
@Component
struct Index {
  account: string = ''
  password: string = ''

  build() {
    Column({ space: 20 }) {
      Button('QueriesAdd')
        .borderRadius(4)
        .type(ButtonType.Normal)
        .width('100%')
        .onClick(async () => {
          router.pushUrl({ url: 'pages/queries/QueriesAdd' })
        })

      Button('QueriesModify')
        .borderRadius(4)
        .type(ButtonType.Normal)
        .width('100%')
        .onClick(async () => {
          router.pushUrl({ url: 'pages/queries/QueriesModify' })
        })

      Button('QueriesDelete')
        .borderRadius(4)
        .type(ButtonType.Normal)
        .width('100%')
        .onClick(async () => {
          router.pushUrl({ url: 'pages/queries/QueriesDelete' })
        })

      Button('QueriesObj')
        .borderRadius(4)
        .type(ButtonType.Normal)
        .width('100%')
        .onClick(async () => {
          router.pushUrl({ url: 'pages/queries/QueriesObj' })
        })

      Button('QueriesRelated')
        .borderRadius(4)
        .type(ButtonType.Normal)
        .width('100%')
        .onClick(async () => {
          router.pushUrl({ url: 'pages/queries/QueriesRelated' })
        })

      Button('QueriesArray')
        .borderRadius(4)
        .type(ButtonType.Normal)
        .width('100%')
        .onClick(async () => {
          router.pushUrl({ url: 'pages/queries/QueriesArray' })
        })

      Button('QueriesRelationship')
        .borderRadius(4)
        .type(ButtonType.Normal)
        .width('100%')
        .onClick(async () => {
          router.pushUrl({ url: 'pages/queries/QueriesRelationship' })
        })
    }
    .width('100%')
    .height('100%')
    .padding(20)
  }
}