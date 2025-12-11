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
  ELog,
  EvaAnimComponent,
  EvaAnimPlayer,
  EvaConstant,
  IEvaFetchResource,
  OnEvaResourceClickListener
} from '@ohos/yyevac';
import { common } from '@kit.AbilityKit';
import { VideoInfo } from '../bean/VideoInfo';
import { EvaResource } from '@ohos/yyevac/src/main/ets/mix/EvaResource';
import { EvaSrc } from '@ohos/yyevac/src/main/ets/mix/EvaSrc';
import image from '@ohos.multimedia.image';
import { PromptAction, UIContext } from '@kit.ArkUI';
import { emitter, BusinessError } from '@kit.BasicServicesKit';
import { ScaleType } from '@ohos/yyevac/src/main/ets/util/ScaleTypeUtil';
import { MyElog } from '../bean/MyElog';

@Component
export struct EvaListDemo {
  @Consume('pageInfos') pageInfos: NavPathStack;
  @Prop title: string;
  public arr: string[] = ['PLAY', 'STOP', 'Pause', 'Mute', 'Re']
  @State players: EvaAnimPlayer[] = new Array()
  public context: common.UIAbilityContext = this.getUIContext().getHostContext() as common.UIAbilityContext;
  public dir: string = this.context.cacheDir
  public videoInfo: VideoInfo = new VideoInfo('car.mp4', '400a778f258ed6bd02ec32defe8ca8be')

  build() {
    NavDestination() {
      Column() {
        List() {
          Repeat<EvaAnimPlayer>(this.players)
            .each((data: RepeatItem<EvaAnimPlayer>) => {
              ListItem() {
                Column() {
                  EvaAnimComponent({ playerEva: data.item })
                    .width('100%')
                    .height('90%')
                  Row() {
                    Button('PLAY')
                      .onClick(async (event: ClickEvent) => {
                        await this.play(data.item)
                      })
                      .width('50%')
                    Button('STOP')
                      .onClick((event: ClickEvent) => {
                        data.item.stop()
                      })
                      .width('50%')
                  }.width('100%')
                  .height('10%')
                }.height('50%')
              }.onVisibleAreaChange([0.0, 1.0], async (isExpanding: boolean, currentRatio: number) => {
                console.info(`Test Text isExpanding: ` + isExpanding + `, currentRatio:` + currentRatio)
                if (isExpanding && currentRatio >= 1.0) {
                  console.info(`Test Text is fully visible. currentRatio: ${currentRatio}, data.item play: ${data.item.uuid}`)
                  await this.play(data.item)
                }

                if (!isExpanding && currentRatio <= 0.0) {
                  console.info(`Test Text is completely invisible. data.item.stop: ${data.item.uuid}}`)
                  data.item.stop()
                }
              })
              .width('100%')
            })
            .virtualScroll()
        }
        .listDirection(Axis.Vertical)
        .lanes(1)
        .height('100%')
        .width('100%')
        .padding({ bottom: 70 })
      }.width('100%')
      .height('100%')
      .backgroundImage($r('app.media.img'))
      .backgroundImageSize({ width: '100%', height: '100%' })
    }
    .title(this.title)
    .margin({ top: 56 })
    .width('100%')
    .height('100%')
    .onBackPressed(() => {
      const popDestinationInfo = this.pageInfos.pop(); // 弹出路由栈栈顶元素
      console.info('pop' + '返回值' + JSON.stringify(popDestinationInfo));
      return true;
    })
  }

  async aboutToAppear(): Promise<void> {
    try {
      this.players.push(new EvaAnimPlayer(this.getUIContext(), 'pageFourTmp_1'))
      this.players.push(new EvaAnimPlayer(this.getUIContext(), 'pageFourTmp_2'))
      this.players.push(new EvaAnimPlayer(this.getUIContext(), 'pageFourTmp_3'))
      this.players.push(new EvaAnimPlayer(this.getUIContext(), 'pageFourTmp_4'))
      this.players.push(new EvaAnimPlayer(this.getUIContext(), 'pageFourTmp_5'))

      this.players.forEach(player => {
        player.setScaleType(ScaleType.CENTER_CROP)
        player.setFetchResource(new EvaFetchResource(this.context))
        player.setOnResourceClickListener(new EvaResourceClickListener(this.getUIContext()) as OnEvaResourceClickListener)
        player.isVideoConfigReady = true

        ELog.isDebug = false
        player.setLog(new MyElog())
        player.on(EvaConstant.EVENT_ID_ON_VIDEO_CONFIG_READY, (eventData: emitter.EventData) => {
          ELog.i(EvaAnimPlayer.TAG, `onVideoConfigReady eventData: ${JSON.stringify(eventData)}`);
          let uuid: string = eventData.data?.uuid
          console.log(`onVideoConfigReady, uuid = ${uuid}`);
        })
        player.on(EvaConstant.EVENT_ID_ON_VIDEO_START, (eventData: emitter.EventData) => {
          ELog.i(EvaAnimPlayer.TAG, `onVideoStart eventData: ${JSON.stringify(eventData)}`);
          let uuid: string = eventData.data?.uuid
          console.log(`onVideoStart, uuid = ${uuid}`);
        })
        player.on(EvaConstant.EVENT_ID_ON_VIDEO_RESTART, (eventData: emitter.EventData) => {
          ELog.i(EvaAnimPlayer.TAG, `onVideoRestart eventData: ${JSON.stringify(eventData)}`);
          let uuid: string = eventData.data?.uuid
          console.log(`onVideoRestart, uuid = ${uuid}`);
        })
        player.on(EvaConstant.EVENT_ID_ON_VIDEO_RENDER, (eventData: emitter.EventData) => {
          ELog.i(EvaAnimPlayer.TAG, `onVideoRender eventData: ${JSON.stringify(eventData)}`);
          let uuid: string = eventData.data?.uuid
          console.log(`onVideoRender, uuid = ${uuid}`);
        })
        player.on(EvaConstant.EVENT_ID_ON_VIDEO_COMPLETE, (eventData: emitter.EventData) => {
          ELog.i(EvaAnimPlayer.TAG, `onVideoComplete eventData: ${JSON.stringify(eventData)}`);
          let uuid: string = eventData.data?.uuid
          console.log(`onVideoComplete, uuid = ${uuid}`);

            this.closeListDemoRawFdFile();
        })
        player.on(EvaConstant.EVENT_ID_ON_VIDEO_DESTROY, (eventData: emitter.EventData) => {
          ELog.i(EvaAnimPlayer.TAG, `onVideoDestroy eventData: ${JSON.stringify(eventData)}`);
          let uuid: string = eventData.data?.uuid
          console.log(`onVideoDestroy, uuid = ${uuid}`);

            this.closeListDemoRawFdFile();
        })
        player.on(EvaConstant.EVENT_ID_ON_FAILED, (eventData: emitter.EventData) => {
          ELog.i(EvaAnimPlayer.TAG, `onFailed eventData: ${JSON.stringify(eventData)}`);
          let uuid: string = eventData.data?.uuid
          console.log(`onFailed, uuid = ${uuid}`);

          this.closeListDemoRawFdFile();
        })
      });
    } catch (error) {
      console.error(`创建player时发生错误error = ${JSON.stringify(error)}`)
    }

  }

  aboutToDisappear(): void {
    this.players.forEach((player) => {
      player.stop()
      player.off(EvaConstant.EVENT_ID_ON_VIDEO_CONFIG_READY)
      player.off(EvaConstant.EVENT_ID_ON_VIDEO_START)
      player.off(EvaConstant.EVENT_ID_ON_VIDEO_RESTART)
      player.off(EvaConstant.EVENT_ID_ON_VIDEO_RENDER)
      player.off(EvaConstant.EVENT_ID_ON_VIDEO_COMPLETE)
      player.off(EvaConstant.EVENT_ID_ON_VIDEO_DESTROY)
      player.off(EvaConstant.EVENT_ID_ON_FAILED)
    })
  }

  closeListDemoRawFdFile() {
    try {
      this.context.resourceManager.closeRawFd(this.videoInfo.fileName, (error: BusinessError) => {
        if (error != null) {
          console.error(`closeRawFd ${this.videoInfo.fileName} error is ` + JSON.stringify(error));
          return;
        }
        console.info(`closeRawFd ${this.videoInfo.fileName} success.`);
      });
    } catch (error) {
      ELog.e(EvaAnimPlayer.TAG, `closeListDemoRawFdFile catch error: ${JSON.stringify(error)}`);
    }
  }

  async play(player: EvaAnimPlayer) {
    try {
      let rawFd = await this.context.resourceManager.getRawFd(this.videoInfo.fileName)
      let context = this.getUIContext().getHostContext()
      if (context) {
        player.startPlayByRawFile(context, this.videoInfo.fileName, rawFd)
      }
    } catch (error) {
      console.error(`播放失败，error = ${error}`)
    }
  }
}

class EvaResourceClickListener implements OnEvaResourceClickListener {
  uiContext: UIContext
  promptAction: PromptAction

  constructor(context: UIContext) {
    this.uiContext = context
    this.promptAction = this.uiContext.getPromptAction();
  }

  onClick(resource: EvaResource): void {
    console.log(`tag=${resource.tag} onClick`);
    this.promptAction.showToast({
      message: `tag=${resource.tag} onClick`,
      duration: 3000,
    })
  }
}


class EvaFetchResource implements IEvaFetchResource {
  context: common.UIAbilityContext
  dir: string

  constructor(context: common.UIAbilityContext) {
    this.context = context
    this.dir = this.context.cacheDir
  }

  async setImage(resource: EvaResource,
    result: (bitmap: image.PixelMap | null, fitType: EvaSrc.FitType | null) => void): Promise<void> {
    /**
     * tag是素材中的一个标记，在制作素材时定义
     * 解析时由业务读取tag决定需要播放的内容是什么
     * 比如：一个素材里需要显示多个头像，则需要定义多个不同的tag，表示不同位置，需要显示不同的头像，文字类似
     */
    let tag = resource.tag
    if (tag == 'anchor_avatar1') { // 此tag是已经写入到动画配置中的tag
      try {
        const resourceMgr = this.context.resourceManager;
        const fileData = await resourceMgr.getMediaContent($r('app.media.ball_1').id, 0);
        const imageSource = image.createImageSource(fileData.buffer);
        const pixelMap = await imageSource.createPixelMap();
        result(pixelMap, null)
        pixelMap.release()
      } catch (error) {
        console.error('setImage', error)
      }
    } else if (tag == 'anchor_avatar2') { // 此tag是已经写入到动画配置中的tag
      try {
        const resourceMgr = this.context.resourceManager;
        const fileData = await resourceMgr.getMediaContent($r('app.media.ball_2').id, 0);
        const imageSource = image.createImageSource(fileData.buffer);
        const pixelMap = await imageSource.createPixelMap();
        result(pixelMap, null)
        pixelMap.release()
      } catch (error) {
        console.error('setImage', error)
      }
    } else if (tag == 'anchor_avatar3') { // 此tag是已经写入到动画配置中的tag
      try {
        const resourceMgr = this.context.resourceManager;
        const fileData = await resourceMgr.getMediaContent($r('app.media.ball_3').id, 0);
        const imageSource = image.createImageSource(fileData.buffer);
        const pixelMap = await imageSource.createPixelMap();
        result(pixelMap, null)
        pixelMap.release()
      } catch (error) {
        console.error('setImage', error)
      }

    } else {
      result(null, null)
    }
  }

  setText(resource: EvaResource, result: (resource: EvaResource) => void): void {
    let tag = resource.tag
    if (tag == 'anchor_nick') { // 此tag是已经写入到动画配置中的tag
      resource.text = 'USERNICK'
      resource.textAlign = 'center'
      result(resource)
    } else {
      result(resource)
    }
  }

  releaseSrc(resources: EvaResource[]): void {
    throw new Error('Method not implemented.');
  }
}