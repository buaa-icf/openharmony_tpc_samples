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

import router from '@ohos.router';
import { TitleBar } from '../common/TitleBar'

@Entry
@Component
struct Index {
  build() {
    Column() {
      TitleBar()
      Scroll() {
        Column({ space: 8 }) {
          this.btn('Simple', () => router.pushUrl({ url: 'pages/SimplePage' }))
          this.btn('Events', () => router.pushUrl({ url: 'pages/EventsPage' }))
          this.btn('Interactive Samples', () => router.pushUrl({ url: 'pages/InteractiveSamplesPage' }))
          this.btn('Multiple Artboards', () => router.pushUrl({ url: 'pages/MultipleArtboardsPage' }))
          this.btn('Fragment', () => router.pushUrl({ url: 'pages/FragmentPage' }))
          this.btn('Low Level Renderer', () => router.pushUrl({ url: 'pages/LowLevelRendererPage' }))
          this.btn('HTTP', () => router.pushUrl({ url: 'pages/HttpPage' }))
          this.btn('State Machine', () => router.pushUrl({ url: 'pages/StateMachinePage' }))
          this.btn('Nested Text Runs', () => router.pushUrl({ url: 'pages/NestedTextRunsPage' }))
          this.btn('Button Presses', () => router.pushUrl({ url: 'pages/ButtonPressesPage' }))
          this.btn('Blend Modes', () => router.pushUrl({ url: 'pages/BlendModesPage' }))
          this.btn('Metrics', () => router.pushUrl({ url: 'pages/MetricsPage' }))
          this.btn('Assets', () => router.pushUrl({ url: 'pages/AssetsPage' }))
          this.btn('Recycler', () => router.pushUrl({ url: 'pages/RecyclerPage' }))
          this.btn('ViewPager', () => router.pushUrl({ url: 'pages/ViewPagerPage' }))
          this.btn('ViewStub', () => router.pushUrl({ url: 'pages/ViewStubPage' }))
          this.btn('Compose (Legacy)', () => router.pushUrl({ url: 'pages/ComposeLegacyPage' }))
          this.btn('Frame', () => router.pushUrl({ url: 'pages/FramePage' }))
          this.btn('Dynamic Text', () => router.pushUrl({ url: 'pages/DynamicTextPage' }))
          this.btn('Asset Loader', () => router.pushUrl({ url: 'pages/AssetLoaderPage' }))
          this.btn('Stress Test', () => router.pushUrl({ url: 'pages/StressTestPage' }))
          this.btn('Rive Font Load', () => router.pushUrl({ url: 'pages/RiveFontLoadPage' }))
          this.btn('Audio Assets', () => router.pushUrl({ url: 'pages/AudioAssetsPage' }))
          this.btn('External Audio Assets', () => router.pushUrl({ url: 'pages/ExternalAudioAssetsPage' }))
          this.btn('Font Fallback', () => router.pushUrl({ url: 'pages/FontFallbackPage' }))
          this.btn('Touch Passthrough', () => router.pushUrl({ url: 'pages/TouchPassthroughPage' }))
        }
        .width('100%')
        .padding({ left: 24, right: 24, top: 12, bottom: 24 })
      }
      .layoutWeight(1)
      .scrollable(ScrollDirection.Vertical)
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F5F5F5')
  }

  @Builder
  private btn(label: string, onClick: () => void) {
    Button(label)
      .width('100%')
      .height(48)
      .fontSize(16)
      .borderRadius(8)
      .onClick(onClick)
  }
}