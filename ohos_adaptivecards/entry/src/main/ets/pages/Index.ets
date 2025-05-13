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

import router from '@ohos.router'

@Entry
@Component
struct indexPage {
  build() {
    Scroll() {
      Column() {
        Button('AdaptiveCard')
          .margin({ bottom: 10 })
          .width(200)
          .onClick(() => {
            router.pushUrl({ url: 'pages/RenderNode', params: { title: 'AdaptiveCard', jsonPath: 'test.json' } })
          })
        Button('Column')
          .width(200)
          .margin({ bottom: 10 })
          .onClick(() => {
            router.pushUrl({ url: 'pages/RenderNode', params: { title: 'Column', jsonPath: 'Column.json' } })
          })
        Button('ColumnSet')
          .width(200)
          .margin({ bottom: 10 })
          .onClick(() => {
            router.pushUrl({ url: 'pages/RenderNode', params: { title: 'ColumnSet', jsonPath: 'Column.json' } })
          })
        Button('Container')
          .width(200)
          .margin({ bottom: 10 })
          .onClick(() => {
            router.pushUrl({
              url: 'pages/RenderNode',
              params: { title: 'Container', jsonPath: 'Container.Style.json' }
            })
          })

        Button('TextBlock')
          .width(200)
          .margin({ bottom: 10 })
          .onClick(() => {
            router.pushUrl({ url: 'pages/RenderNode', params: { title: 'TextBlock', jsonPath: 'test.json' } })
          })

        Button('Image')
          .width(200)
          .margin({ bottom: 10 })
          .onClick(() => {
            router.pushUrl({ url: 'pages/RenderNode', params: { title: 'Image', jsonPath: 'test.json' } })
          })

        Button('RichTextBlock')
          .width(200)
          .margin({ bottom: 10 })
          .onClick(() => {
            router.pushUrl({
              url: 'pages/RenderNode',
              params: { title: 'RichTextBlock', jsonPath: 'RichTextBlock.json' }
            })
          })

        Button('Input.Text')
          .width(200)
          .margin({ bottom: 10 })
          .onClick(() => {
            router.pushUrl({ url: 'pages/RenderNode', params: { title: 'Input.Text', jsonPath: 'Input.Text.json' } })
          })

        Button('TextRun')
          .width(200)
          .margin({ bottom: 10 })
          .onClick(() => {
            router.pushUrl({ url: 'pages/RenderNode', params: { title: 'TextRun', jsonPath: 'TextRun.json' } })
          })

        Button('ActionSet')
          .width(200)
          .margin({ bottom: 10 })
          .onClick(() => {
            router.pushUrl({ url: 'pages/RenderNode', params: { title: 'ActionSet', jsonPath: 'Column.json' } })
          })

        Button('Action.Submit')
          .width(200)
          .margin({ bottom: 10 })
          .onClick(() => {
            router.pushUrl({
              url: 'pages/RenderNode',
              params: { title: 'Action.Submit', jsonPath: 'Action.Submit.json' }
            })
          })

        Button('Action.OpenUrl')
          .width(200)
          .margin({ bottom: 10 })
          .onClick(() => {
            router.pushUrl({
              url: 'pages/RenderNode',
              params: { title: 'Action.OpenUrl', jsonPath: 'Action.OpenUrl.json' }
            })
          })

        Button('Action.ToggleVisibility')
          .width(200)
          .margin({ bottom: 10 })
          .onClick(() => {
            router.pushUrl({
              url: 'pages/RenderNode',
              params: { title: 'Action.ToggleVisibility', jsonPath: 'ToggleVisibility.json' }
            })
          })

        Button('ImageSet')
          .width(200)
          .margin({ bottom: 10 })
          .onClick(() => {
            router.pushUrl({ url: 'pages/RenderNode', params: { title: 'ImageSet', jsonPath: 'ImageSet.json' } })
          })

        Button('FactSet')
          .width(200)
          .margin({ bottom: 10 })
          .onClick(() => {
            router.pushUrl({ url: 'pages/RenderNode', params: { title: 'FactSet', jsonPath: 'FactSet.json' } })
          })

        Button('Input.Number')
          .width(200)
          .margin({ bottom: 10 })
          .onClick(() => {
            router.pushUrl({
              url: 'pages/RenderNode',
              params: { title: 'Input.Number', jsonPath: 'Input.Number.json' }
            })
          })

        Button('Action.ShowCard')
          .width(200)
          .margin({ bottom: 10 })
          .onClick(() => {
            router.pushUrl({
              url: 'pages/RenderNode',
              params: { title: 'Action.ShowCard', jsonPath: 'Action.ShowCard.json' }
            })
          })

        Button('Action.Execute')
          .width(200)
          .margin({ bottom: 10 })
          .onClick(() => {
            router.pushUrl({
              url: 'pages/RenderNode',
              params: { title: 'Action.Execute', jsonPath: 'Action.Execute.json' }
            })
          })

        Button('Carousel')
          .width(200)
          .margin({ bottom: 10 })
          .onClick(() => {
            router.pushUrl({
              url: 'pages/RenderNode',
              params: { title: 'Carousel', jsonPath: 'Carousel.Properties.json' }
            })
          })

        Button('Table')
          .width(200)
          .margin({ bottom: 10 })
          .onClick(() => {
            router.pushUrl({ url: 'pages/RenderNode', params: { title: 'Table', jsonPath: 'Table.json' } })
          })
      }
    }
    .width('100%')
    .height('100%')
    .backgroundColor(Color.Gray)
    .scrollable(ScrollDirection.Vertical)
    .scrollBar(BarState.On)
  }
}