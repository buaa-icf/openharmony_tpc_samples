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
import {
  FontBytes,
  Weight,
  FontFallbackStrategy,
  FontOpts,
  RendererType,
  RiveAnimationView,
  RiveManager
} from '@ohos/rive';

class FontFallback extends FontFallbackStrategy {
  private riveViewStylePicker: RiveAnimationView | null = null;
  private riveViewThai: RiveAnimationView | null = null;

  constructor(riveViewStylePicker: RiveAnimationView | null, riveViewThai: RiveAnimationView | null) {
    super();
    this.riveViewStylePicker = riveViewStylePicker;
    this.riveViewThai = riveViewThai;
    this.updateTextRuns();
    this.updateThaiText();
    FontFallbackStrategy.stylePicker = this;
  }

  getFont(weight: Weight): FontBytes[] {
    let fontMatch = new FontOpts('serif');

    if (weight.weight < 400) {
      fontMatch = new FontOpts('sans-serif', null, new Weight(900));
    } else if (weight.weight > 400) {
      fontMatch = new FontOpts('sans-serif', null, new Weight(100));
    }

    const fonts = [
      fontMatch,
      new FontOpts('NotoSansThai-Regular.ttf')
    ];
    const resourceManager = getContext().resourceManager;
    const fontBytes = resourceManager.getRawFileContentSync('NotoSansThai-Regular.ttf');
    return fontBytes ? [fontBytes] : [];
  }

  /**
   * The Rive file displayed here contains four blocks of text each with three different runs
   * Also, the Rive file only exported the glyphs that have been specified in the file, and each
   * line is made of three runs: | ABC | DEF | GHI |
   *
   * Modifying these runs with glyphs that are not part of the { ABCDEFGHI } set will require a
   * fallback.
   */
  private updateTextRuns() {
    this.riveViewStylePicker?.setTextRunValue('ultralight_start', 'aBc ');
    this.riveViewStylePicker?.setTextRunValue('ultralight_mid', 'DeF');
    this.riveViewStylePicker?.setTextRunValue('ultralight_end', ' gHi');

    this.riveViewStylePicker?.setTextRunValue('regular_mid', ' def ');

    this.riveViewStylePicker?.setTextRunValue('bold_start', 'PQR ');
    this.riveViewStylePicker?.setTextRunValue('bold_end', 'XYZ');

    this.riveViewStylePicker?.setTextRunValue('black_mid', ' def ');
  }

  private updateThaiText() {
    const thaiHelloText = 'สวัสดี ';
    const thaiWorldText = ' โลก';
    this.riveViewThai?.setTextRunValue('regular_start', thaiHelloText);
    this.riveViewThai?.setTextRunValue('regular_end', thaiWorldText);
  }
}


@Entry
@Component
struct FontFallbackPage {
  private riveViewStylePicker: RiveAnimationView | null = null;
  private riveViewThai: RiveAnimationView | null = null;

  aboutToAppear(): void {
    console.info('snake FontFallbackPage: aboutToAppear');

    const resourceManager = getContext().resourceManager;
    const fontBytes = resourceManager.getRawFileContentSync('NotoSansThai-Regular.ttf');
    console.error(`snake setFallbackFont thaiFont : ${fontBytes.length}`);
    if (fontBytes) {
      RiveManager.getInstance().init(getContext(), RendererType.Rive);
      RiveManager.getInstance().setFallbackFont(getContext(), fontBytes);
    }

    const fontBytes2 = resourceManager.getRawFileContentSync('NotoSansThai-Bold.ttf');
    console.error(`snake setFallbackFont thaiFont2 : ${fontBytes2.length}`);
    if (fontBytes2) {
      RiveManager.getInstance().init(getContext(), RendererType.Rive);
      RiveManager.getInstance().setFallbackFont(getContext(), fontBytes2);
    }
    const fontBytes3 = resourceManager.getRawFileContentSync('Roboto-Black.ttf');
    console.error(`snake setFallbackFont thaiFont3 : ${fontBytes3.length}`);
    if (fontBytes3) {
      RiveManager.getInstance().init(getContext(), RendererType.Rive);
      RiveManager.getInstance().setFallbackFont(getContext(), fontBytes3);
    }
  }

  onPageShow(): void {
    new FontFallback(this.riveViewStylePicker, this.riveViewThai)
  }

  build() {
    Column() {
      Row() {
        Text('Rive Samples')
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

      RiveAnimationView({
        riveResource: '@rawfile/style_fallback_fonts.riv',
        onReady: (view) => {
          this.riveViewStylePicker = view
          new FontFallback(view, null)
        }
      })
        .width('100%')
        .height('40%')
        .margin(20)
      RiveAnimationView({
        riveResource: '@rawfile/style_fallback_fonts.riv',
        onReady: (view) => {
          this.riveViewThai = view
          new FontFallback(null, view)
        }
      })
        .width('100%')
        .height('40%')
        .margin(20)
    }

    .width('100%')
    .padding({ bottom: 5 })
  }
}