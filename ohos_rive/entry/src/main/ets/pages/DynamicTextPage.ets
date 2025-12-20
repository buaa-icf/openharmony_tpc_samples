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


import { FontBytes, Weight, FontFallbackStrategy, RendererType, RiveAnimationView, RiveManager } from '@ohos/rive';

class FontFallback extends FontFallbackStrategy {
  constructor() {
    super();
    FontFallbackStrategy.stylePicker = this;
  }

  public getFont(weight: Weight): FontBytes[] {
    const resourceManager = getContext().resourceManager;
    const fontBytes = resourceManager.getRawFileContentSync('HarmonyOS_SansSC_Regular.ttf');
    return fontBytes ? [fontBytes] : [];
  }
}

@Entry
@Component
struct DynamicTextPage {
  riveView: RiveAnimationView |null = null;

  aboutToAppear(): void {
    console.info('DynamicTextPage: aboutToAppear');

    const resourceManager = getContext().resourceManager;
    const fontBytes = resourceManager.getRawFileContentSync('HarmonyOS_SansSC_Regular.ttf');
    console.error(`setFallbackFont SansSCFont : ${fontBytes.length}`);
    if (fontBytes) {
      RiveManager.getInstance().init(getContext(), RendererType.Rive);
      RiveManager.getInstance().setFallbackFont(getContext(), fontBytes);
    }
  }

  build() {
    Column() {
      RiveAnimationView({
        riveResource: '@rawfile/hello_world_text.riv',
        riveFit: 'contain',
        onReady: (view) => {
          this.riveView = view;
          new FontFallback();
        }
      })
        .width('100%')
        .height(200)
        .margin(8)

      TextInput({ text: 'world' })
        .showUnderline(true)
        .underlineColor({
          normal: Color.Gray,
          typing: Color.Blue
        })
        .onChange((data) => {
          this.riveView?.setTextRunValue('name', data);
        })
    }
    .width('100%')
    .height('100%')
    .padding(10)
  }
}