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

import { VAPPlayer } from '@ohos/vap';
import { util } from '@kit.ArkTS';
import { LogUtil } from '../common/LogUtil';

@Entry
@Component
struct MultiAnimation {
  private vapPlayer1: VAPPlayer | undefined = undefined;
  private vapPlayer2: VAPPlayer | undefined = undefined;
  private vapPlayer3: VAPPlayer | undefined = undefined;
  private vapPlayer4: VAPPlayer | undefined = undefined;
  private vapPlayer5: VAPPlayer | undefined = undefined;
  private vapPlayer6: VAPPlayer | undefined = undefined;
  private vapPlayer7: VAPPlayer | undefined = undefined;
  private vapPlayer8: VAPPlayer | undefined = undefined;
  private xComponentId1: string = 'xcomponentId_' + util.generateRandomUUID()
  private xComponentId2: string = 'xcomponentId_' + util.generateRandomUUID()
  private xComponentId3: string = 'xcomponentId_' + util.generateRandomUUID()
  private xComponentId4: string = 'xcomponentId_' + util.generateRandomUUID()
  private xComponentId5: string = 'xcomponentId_' + util.generateRandomUUID()
  private xComponentId6: string = 'xcomponentId_' + util.generateRandomUUID()
  private xComponentId7: string = 'xcomponentId_' + util.generateRandomUUID()
  private xComponentId8: string = 'xcomponentId_' + util.generateRandomUUID()
  private videoPath1: string = getContext(this).filesDir + "/123.mp4";
  private videoPath2: string = getContext(this).filesDir + "/demo.mp4";
  private videoPath3: string = getContext(this).filesDir + "/vapx.mp4";
  private WIDTH: string = "100%";
  private HEIGHT: string = "200";

  aboutToDisappear(): void {
    this.vapPlayer1?.stop()
    this.vapPlayer2?.stop()
    this.vapPlayer3?.stop()
    this.vapPlayer4?.stop()
    this.vapPlayer5?.stop()
    this.vapPlayer6?.stop()
    this.vapPlayer7?.stop()
    this.vapPlayer8?.stop()
  }

  build() {
    Scroll() {
      Column({space: 10}) {
        XComponent({
          id: this.xComponentId1,
          type: XComponentType.SURFACE,
          libraryname: 'vap'
        })
          .width(this.WIDTH)
          .height(this.HEIGHT)
          .onLoad((context?: object) => {
            if (context) {
              this.vapPlayer1 = new VAPPlayer(this.xComponentId1);
              this.vapPlayer1.setContext(context);
              this.vapPlayer1.setLoop(Infinity)
              this.vapPlayer1.play(this.videoPath1, [], () => {
                LogUtil.info("xComponentId1 callback")
              })
            }
          })

        XComponent({
          id: this.xComponentId2,
          type: XComponentType.SURFACE,
          libraryname: 'vap'
        })
          .width(this.WIDTH)
          .height(this.HEIGHT)
          .onLoad((context?: object) => {
            if (context) {
              this.vapPlayer2 = new VAPPlayer(this.xComponentId2);
              this.vapPlayer2.setContext(context);
              this.vapPlayer2.setLoop(Infinity)
              this.vapPlayer2.play(this.videoPath2, [], () => {
                LogUtil.info("xComponentId2 callback")
              })
            }
          })

        XComponent({
          id: this.xComponentId3,
          type: XComponentType.SURFACE,
          libraryname: 'vap'
        })
          .width(this.WIDTH)
          .height(this.HEIGHT)
          .onLoad((context?: object) => {
            if (context) {
              this.vapPlayer3 = new VAPPlayer(this.xComponentId3);
              this.vapPlayer3.setContext(context);
              this.vapPlayer3.setLoop(Infinity)
              this.vapPlayer3.play(this.videoPath3, [], () => {
                LogUtil.info("xComponentId3 callback")
              })
            }
          })

        XComponent({
          id: this.xComponentId4,
          type: XComponentType.SURFACE,
          libraryname: 'vap'
        })
          .width(this.WIDTH)
          .height(this.HEIGHT)
          .onLoad((context?: object) => {
            if (context) {
              this.vapPlayer4 = new VAPPlayer(this.xComponentId4);
              this.vapPlayer4.setContext(context);
              this.vapPlayer4.setLoop(Infinity)
              this.vapPlayer4.play(this.videoPath1, [], () => {
                LogUtil.info("xComponentId4 callback")
              })
            }
          })

        XComponent({
          id: this.xComponentId5,
          type: XComponentType.SURFACE,
          libraryname: 'vap'
        })
          .width(this.WIDTH)
          .height(this.HEIGHT)
          .onLoad((context?: object) => {
            if (context) {
              this.vapPlayer5 = new VAPPlayer(this.xComponentId5);
              this.vapPlayer5.setContext(context);
              this.vapPlayer5.setLoop(Infinity)
              this.vapPlayer5.play(this.videoPath2, [], () => {
                LogUtil.info("xComponentId5 callback")
              })
            }
          })

        XComponent({
          id: this.xComponentId6,
          type: XComponentType.SURFACE,
          libraryname: 'vap'
        })
          .width(this.WIDTH)
          .height(this.HEIGHT)
          .onLoad((context?: object) => {
            if (context) {
              this.vapPlayer6 = new VAPPlayer(this.xComponentId6);
              this.vapPlayer6.setContext(context);
              this.vapPlayer6.setLoop(Infinity)
              this.vapPlayer6.play(this.videoPath3, [], () => {
                LogUtil.info("xComponentId6 callback")
              })
            }
          })

        XComponent({
          id: this.xComponentId7,
          type: XComponentType.SURFACE,
          libraryname: 'vap'
        })
          .width(this.WIDTH)
          .height(this.HEIGHT)
          .onLoad((context?: object) => {
            if (context) {
              this.vapPlayer7 = new VAPPlayer(this.xComponentId7);
              this.vapPlayer7.setContext(context);
              this.vapPlayer7.setLoop(Infinity)
              this.vapPlayer7.play(this.videoPath1, [], () => {
                LogUtil.info("xComponentId7 callback")
              })
            }
          })

        XComponent({
          id: this.xComponentId8,
          type: XComponentType.SURFACE,
          libraryname: 'vap'
        })
          .width(this.WIDTH)
          .height(this.HEIGHT)
          .onLoad((context?: object) => {
            if (context) {
              this.vapPlayer8 = new VAPPlayer(this.xComponentId8);
              this.vapPlayer8.setContext(context);
              this.vapPlayer8.setLoop(Infinity)
              this.vapPlayer8.play(this.videoPath2, [], () => {
                LogUtil.info("xComponentId8 callback")
              })
            }
          })
      }
    }

  }
}