/*
 * Copyright (C) 2023 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the 'License');
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an 'AS IS' BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import avPlayManage from '../AvPlayManager';
import wf from '@ohos.wifiManager';

const VIDEOSELECT = 2; // 网络视频索引

@Component
export struct VideoPanel {
  @State videoList: string[] = ['test1.mp4',
    'https://vd3.bdstatic.com/mda-pdc2kmwtd2vxhiy4/cae_h264/1681502407203843413/mda-pdc2kmwtd2vxhiy4.mp4',
    'http://music.163.com/song/media/outer/url?id=447925558.mp3',
    'https://vd3.bdstatic.com/mda-nmh2004d24kf4bjh/hd/h264/1671326683061787710/mda-nmh2004d24kf4bjh.mp4',
    'https://video.chinanews.com/flv/2019/04/23/400/111773_web.mp4'];
  @State selectColor: boolean = true;
  @Link show: boolean;
  @Link videoSelect: number; // 当前选择项的索引
  @StorageLink('avPlayManage') avPlayManage: avPlayManage | null = null;
  @State linkSpeed: number = 0;

  // 判断是否联网
  async checkWifiState(): Promise<boolean> {
    let linkInfo = await wf.getLinkedInfo();
    if (linkInfo.connState !== wf.ConnState.CONNECTED) {
      return false;
    }
    return true;
  }

  build() {
    Panel(this.show) {
      Column() {
        RelativeContainer() {
          Text(this.videoList[this.videoSelect].substring(this.videoList[this.videoSelect].length - 20,
            this.videoList[this.videoSelect].length))
            .fontColor(Color.White)
            .fontSize($r('app.float.size_18'))
            .fontWeight(FontWeight.Regular)
            .alignRules({
              middle: { anchor: '__container__', align: HorizontalAlign.Center },
              center: { anchor: '__container__', align: VerticalAlign.Center }
            })
            .id('test1')
          Image($r('app.media.ic_video_list_down'))
            .width($r('app.float.size_30'))
            .height($r('app.float.size_20'))
            .alignRules({
              right: { anchor: '__container__', align: HorizontalAlign.End },
              center: { anchor: '__container__', align: VerticalAlign.Center }
            }).id('test2')
        }
        .height($r('app.float.size_20'))
        .width('90%')
        .margin({ top: $r('app.float.size_20'), bottom: $r('app.float.size_20') })

        List() {
          ForEach(this.videoList, (item: string, index: number) => {
            ListItem() {
              Column() {
                Row() {
                  Text(item)
                    .fontSize($r('app.float.size_12'))
                    .fontColor(Color.White)
                    .fontWeight(FontWeight.Regular)
                    .textAlign(TextAlign.Center)
                    .width('80%')

                  Blank()

                  if (this.videoSelect === index) {
                    Text($r('app.string.playing'))
                      .fontSize($r('app.float.size_16'))
                      .fontColor(Color.White)
                      .opacity($r('app.float.size_zero_six'))
                      .fontWeight(FontWeight.Regular)
                      .textAlign(TextAlign.Center)
                      .width('20%')
                  }
                }
                .width('90%')
              }
              .width('100%')
            }
            .backgroundColor(this.videoSelect === index ? $r('app.color.video_play_selected') : '')
            .width('100%')
            .height($r('app.float.size_64'))
            .onClick(async () => {
              this.videoSelect = index;
              AppStorage.setOrCreate('videoName', this.videoList[this.videoSelect]);
              AppStorage.setOrCreate('videoIndex', this.videoSelect);
              this.show = false;
              let str: string = this.videoList[this.videoSelect];
              if (this.avPlayManage) {
                this.avPlayManage.videoChoose(str, this.videoSelect);
              }
            })
          })
        }
        .width('100%')
      }
    }
    .onClick(() => {
      this.show = false;
    })
    .onChange(() => {
      this.show = false;
    })
    .backgroundColor($r('app.color.video_play'))
    .type(PanelType.Foldable)
    .mode(PanelMode.Half)
    .dragBar(false)
    .halfHeight(400)
    .width('100%')
    .padding({ top: $r('app.float.size_5') })
  }
}