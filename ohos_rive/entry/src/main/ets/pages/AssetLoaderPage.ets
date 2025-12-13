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

import { RandomNetworkLoader } from './RandomNetworkLoader';
import { WalleAssetLoader } from './WalleAssetLoader';
import { ArrayList } from '@kit.ArkTS';
import http from '@ohos.net.http';
import {
  FileAsset,
  FileAssetLoader,
  FontAsset,
  ImageAsset,
  Loop,
  RiveAnimationView,
  RiveFont,
  RiveRenderImage
} from '@ohos/rive';

@Entry
@Component
struct AssetLoaderPage {
  @State fontColor: string = '#182431';
  @State selectedFontColor: string = '#007DFF';
  @State currentIndex: number = 0;
  @State selectedIndex: number = 0;
  lastAssetChanged: number = 0;
  private controller: TabsController = new TabsController();
  private context: Context = getContext() as Context;
  @State fontCoder: RandomFontDecoder = new RandomFontDecoder(this.context);
  @State image: RandomNetworkLoader = new RandomNetworkLoader(this.context);
  @State walleCoder: WalleAssetLoader = new WalleAssetLoader(this.context);
  @State assetStore: ImageAssetStore = new ImageAssetStore(this.context);
  private fontPool: string[] = [
    'comic-neue.ttf',
    'IndieFlower-Regular.ttf',
    'inter.ttf',
    'inter-tight.ttf',
    'josefin-sans.ttf',
    'send-flowers.ttf'
  ];

  changeFont() {

    const ttf: string = this.fontPool[Math.floor(Math.random() * this.fontPool.length)];

    console.error('RandomFontDecoder', ttf)

    const context: Context = this.getUIContext().getHostContext()?.getApplicationContext() as Context;

    const resourceMgr = context.resourceManager;

    const bytes = resourceMgr.getRawFileContentSync(ttf);

    console.error('RandomFontDecoder', bytes)

    this.fontCoder.fontAssent!!.font = RiveFont.make(bytes);
  }

  aboutToAppear(): void {
    this.changeImage();
    setTimeout(() => {
      this.changeImage();
    }, 1000);
  }

  changeImage() {
    const urls = [
      'https://picsum.photos/id/722/802/795',
      'https://picsum.photos/id/806/988/764',
      'https://picsum.photos/id/122/898/756',
      'https://picsum.photos/id/569/786/943',
      'https://picsum.photos/id/316/924/756',
      'https://picsum.photos/id/978/938/970',
      'https://picsum.photos/id/503/846/794',
      'https://picsum.photos/id/887/846/786',
      'https://picsum.photos/id/407/888/962',
      'https://picsum.photos/id/366/897/928',
      'https://picsum.photos/id/265/800/985',
      'https://picsum.photos/id/260/861/901',
      'https://picsum.photos/id/442/768/963',
      'https://picsum.photos/id/174/766/949',
      'https://picsum.photos/id/732/792/866',
      'https://picsum.photos/id/1070/761/787',
      'https://picsum.photos/id/424/781/993',
      'https://picsum.photos/id/393/879/844',
      'https://picsum.photos/id/361/780/863'
    ];

    const randomIndex = Math.floor(Math.random() * urls.length);
    const randomUrl = urls[randomIndex];

    this.downloadImg(randomUrl);
  }

  downloadImg(url: string) {
    try {
      console.info(`ImageAssetStore download img from network: ${url}`);

      const httpRequest = http.createHttp();

      httpRequest.request(url, {
        method: http.RequestMethod.GET,
        connectTimeout: 60000,
        readTimeout: 60000
      }).then((response) => {

        if (response.responseCode === 200) {

          console.info(`ImageAssetStore download img: Network request successful`);

          const arrayBuffer = response.result as ArrayBuffer;

          const bytes = new Uint8Array(arrayBuffer);

          this.lastAssetChanged ++ ;
          if (this.assetStore.assetList.length > 0) {
            this.assetStore
              .assetList[this.lastAssetChanged % this.assetStore.assetList.length]
              .image = RiveRenderImage.fromEncoded(bytes);
          }
        } else {

          console.error(`ImageAssetStore download img: Network request failed: ${response.responseCode}`);

        }
      }).catch((error: Error) => {

        console.error(`ImageAssetStore download img: Network request error: ${error}`);

      }).finally(() => {

        httpRequest.destroy();

      });
    } catch (error) {

      console.error(`ImageAssetStore download img: Error loading file from network: ${error}`);

    }
  }

  @Builder
  tabBuilder(index: number, name: string) {
    Column() {
      Text(name)
        .fontColor(this.selectedIndex === index ? this.selectedFontColor : this.fontColor)
        .fontSize(16)
        .fontWeight(this.selectedIndex === index ? 500 : 400)
        .lineHeight(22)
        .margin({ top: 10, bottom: 7 })
      Divider()
        .strokeWidth(2)
        .color('#007DFF')
        .opacity(this.selectedIndex === index ? 1 : 0)
    }.width('100%')
  }

  build() {
    Column() {
      Row() {
        Text('Rive Samples')
          .fontSize(20)
          .fontWeight(FontWeight.Medium)
          .textAlign(TextAlign.Center)
          .margin({ left: 20 })
      }
      .width('100%')
      .height(56)
      .alignItems(VerticalAlign.Center)

      Divider().strokeWidth(1).color('#F1F3F5')

      Tabs({ barPosition: BarPosition.Start, index: this.currentIndex, controller: this.controller }) {
        TabContent() {
          Column() {
            RiveAnimationView({
              riveResource: '@rawfile/walle.riv',
              riveAssetLoaderClass: this.walleCoder
            })
              .width('90%')
              .height(150)
              .margin({ top: 36, bottom: 20 })

            RiveAnimationView({
              riveResource: '@rawfile/walle.riv',
              riveAssetLoaderClass: this.image
            })
              .width('90%')
              .height(150)
              .margin({ top: 16, bottom: 20 })

            RiveAnimationView({
              riveResource: '@rawfile/cdn_image.riv',
            })
              .width('60%')
              .height(200)
              .margin({ top: 16, bottom: 20 })

          }.width('100%').height('100%')
        }.tabBar(this.tabBuilder(0, 'Asset Loader'))

        TabContent() {
          Column() {
            RiveAnimationView({
              riveResource: '@rawfile/asset_load_check.riv',
              riveAssetLoaderClass: this.assetStore
            })
              .width('95%')
              .height(300)
              .margin({ top: 150, bottom: 20 })

            Button('CHANGE IMAGE', { type: ButtonType.Normal })
              .onClick(() => {
                this.changeImage()
              })
              .fontColor('#000000')
              .backgroundColor(Color.Gray)
              .borderRadius(2)
              .controlSize(ControlSize.NORMAL)
              .width(180)
          }.width('100%').height('100%')
        }.tabBar(this.tabBuilder(1, 'Change Images'))

        TabContent() {
          Column() {
            RiveAnimationView({
              riveResource: '@rawfile/fontz_oob.riv',
              riveLoop: Loop.PINGPONG,
              riveAnimation: 'Bounce',
              riveAssetLoaderClass: this.fontCoder
            })
              .width('95%')
              .height(300)
              .margin({ top: 150, bottom: 20 })

            Button('CHANGE FONT', { type: ButtonType.Normal })
              .onClick(() => {
                this.changeFont();
              })
              .fontColor('#000000')
              .backgroundColor(Color.Gray)
              .borderRadius(2)
              .controlSize(ControlSize.NORMAL)
              .width(150)
          }.width('100%').height('100%')
        }.tabBar(this.tabBuilder(2, 'Fonts'))
      }
      .vertical(false)
      .barMode(BarMode.Fixed)
      .divider({ strokeWidth: 1, color: '#F1F3F5' })
      .barWidth(360)
      .barHeight(41)
      .animationDuration(400)
      .onChange((index: number) => {
        this.currentIndex = index;
        this.selectedIndex = index;
      })
      .onAnimationStart((index: number, targetIndex: number, event: TabsAnimationEvent) => {
        if (index === targetIndex) {
          return;
        }
        this.selectedIndex = targetIndex;
      })
      .width('100%')
      .height(800)
    }.width('100%')
  }
}

export class RandomFontDecoder extends FileAssetLoader {
  public readonly context: Context;
  public fontAssent: FontAsset | null = null;

  public constructor(context: Context) {

    super();

    this.context = context;
  }

  loadContents(asset: FileAsset, inBandBytes: Uint8Array): boolean {

    try {

      if (asset instanceof FontAsset) {

        this.fontAssent = asset;

        const context = this.context;

        const resourceMgr = context.resourceManager;

        const bytes = resourceMgr.getRawFileContentSync('roboto.ttf');

        console.error('RandomFontDecoder bytes ===', bytes)

        return asset.decode(bytes);

      }
    } catch (error) {

      console.error('RandomFontDecoder error===', error)

    }

    return false;

  }
}

export class ImageAssetStore extends FileAssetLoader {
  public readonly context: Context;
  public nextAsset: ImageAsset | null = null;
  public lastAssetChanged = 0
  public assetList: ArrayList<ImageAsset> = new   ArrayList<ImageAsset>()

  public constructor(context: Context) {

    super();

    this.context = context;

  }

  public getNextAsset(): ImageAsset {

    this.nextAsset = this.assetList[this.lastAssetChanged % this.assetList.length];

    this.lastAssetChanged++;

    return this.nextAsset;

  }

  loadContents(asset: FileAsset, inBandBytes: Uint8Array): boolean {

    try {

      if (asset instanceof ImageAsset) {

        return this.assetList.add(asset);

      }
    } catch (error) {

      console.error('ImageAssetStore error===', error)

    }

    return false;

  }
}