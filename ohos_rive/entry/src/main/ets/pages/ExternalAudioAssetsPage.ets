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
import { AudioAsset, FileAsset, FileAssetLoader, RiveAnimationView, RiveAudio } from '@ohos/rive';

class AudioDecoder extends FileAssetLoader {
  public context: Context;
  constructor(context: Context) {
    super();
    this.context = context
  }
  public loadContents(asset: FileAsset, inBandBytes: Uint8Array): boolean {
    if (asset instanceof AudioAsset) {
      const audioFilename = asset.uniqueFilename;
      console.info(`Loading audio asset: ${audioFilename}`);

      try {
        const resourceManager = this.context.resourceManager;
        let rawResourceName = '';

        if (audioFilename.startsWith('racket1')) {
          rawResourceName = 'racket1.wav';
        } else if (audioFilename.startsWith('racket2')) {
          rawResourceName = 'racket2.wav';
        } else if (audioFilename.startsWith('table')) {
          rawResourceName = 'table.wav';
        } else {
          console.warn(`Unknown audio resource: ${audioFilename}`);
          return false;
        }

        const audioBytes = resourceManager.getRawFileContentSync(rawResourceName);
        if (audioBytes) {
          console.info(`Successfully loaded audio resource: ${rawResourceName}`);
          const audio = RiveAudio.make(audioBytes);
          asset.audio = audio;
          return true;
        } else {
          console.error(`Failed to load audio resource: ${rawResourceName}`);
          return false;
        }
      } catch (error) {
        console.error(`Error loading audio asset ${audioFilename}: ${error}`);
        return false;
      }
    }
    return false;
  }
}

@Entry
@Component
struct ExternalAudioAssetsPage {
  @State riveView: RiveAnimationView | null = null;

  private context = getContext();
  private audioDecoder = new AudioDecoder(this.context);
  
  build() {
      Column() {
        Row() {
          Text('Rive Samples')
            .fontSize(20)
            .fontWeight(FontWeight.Medium)
            .textAlign(TextAlign.Center)
            .fontColor('#FFFFFF')
            .margin({left:20})
        }
        .width('100%')
        .height(56)
        .backgroundColor('#6200EE')
        .alignItems(VerticalAlign.Center)
        
        RiveAnimationView({
          riveResource: '@rawfile/ping_pong_audio_demo.riv',
          riveStateMachine: 'State Machine 1',
          riveAssetLoaderClass:this.audioDecoder,
          onReady: (view) => {
            view.setVolume(0.75)
            this.riveView = view;

          }
        })
        .width('100%')
        .height('70%')
        .margin({ top: 100, bottom: 20 })
    }
  }
}