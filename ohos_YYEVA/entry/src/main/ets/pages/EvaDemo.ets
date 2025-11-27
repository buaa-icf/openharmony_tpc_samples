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
import { emitter } from '@kit.BasicServicesKit';
import { ScaleType } from '@ohos/yyevac/src/main/ets/util/ScaleTypeUtil';
import { MyElog } from '../bean/MyElog';

@Component
export struct EvaDemo {
  @Consume('pageInfos') pageInfos: NavPathStack;
  @Prop title: string;
  @State arr: string[] = ['PLAY', 'STOP', 'Pause', 'Mute', 'Re']
  @State player: EvaAnimPlayer = new EvaAnimPlayer(this.getUIContext(), 'EvaDemo')
  public context: common.UIAbilityContext = this.getUIContext().getHostContext() as common.UIAbilityContext;
  public dir: string = this.context.cacheDir
  public videoInfo: VideoInfo = new VideoInfo('car.mp4', '400a778f258ed6bd02ec32defe8ca8be')
  @State isMute: boolean = false;
  private isPause = false;

  build() {
    NavDestination() {
      Column() {
        EvaAnimComponent({ playerEva: this.player })
          .width('100%')
          .height('80%')
        List() {
          Repeat<string>(this.arr)
            .each((data: RepeatItem<string>) => {
              ListItem() {
                Button(data.item)
                  .onClick(async (event: ClickEvent) => {
                    if (data.item == this.arr[0]) {
                      await this.play()
                      if (this.isPause) {
                        this.isPause = false
                        this.arr[2] = 'Pause'
                      }
                    } else if (data.item == this.arr[1]) {
                      this.player.stop()
                    } else if (data.item == this.arr[2]) {
                      if (this.isPause && this.player.isRunning()) {
                        this.player.resume()
                        this.isPause = false
                        this.arr[2] = 'Pause'
                      } else {
                        if (this.player.isRunning()) {
                          this.player.pause()
                          this.isPause = true
                          this.arr[2] = 'Resume'
                        }
                      }
                    } else if (data.item == this.arr[3]) {
                      this.isMute = !this.isMute;
                      this.player.setMute(this.isMute)
                    } else if (data.item == this.arr[4]) {
                      this.player.restart()
                    }
                  })
              }
            })
            .virtualScroll()
        }
        .listDirection(Axis.Horizontal)
        .lanes(1)
        .height('10%')
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
    // 获取eventHub
    let eventhub = this.context.eventHub;
    // 执行订阅操作
    eventhub.on('onBackground', (data: string) => {
      // 触发事件，完成相应的业务操作
      this.player.stop();
    });

    this.initLog()
    this.player.setScaleType(ScaleType.CENTER_CROP)
    this.player.setFetchResource(new EvaFetchResource(this.context))
    this.player.setOnResourceClickListener(
      new EvaResourceClickListener(this.getUIContext()) as OnEvaResourceClickListener)
    this.player.isVideoConfigReady = true
    emitter.on(EvaConstant.EVENT_ID_ON_VIDEO_CONFIG_READY, (eventData: emitter.EventData) => {
      ELog.i(EvaAnimPlayer.TAG, `onVideoConfigReady eventData: ${JSON.stringify(eventData)}`);
      let uuid: string = eventData.data?.uuid
      console.log(`onVideoConfigReady, uuid = ${uuid}`);
    })
    emitter.on(EvaConstant.EVENT_ID_ON_VIDEO_START, (eventData: emitter.EventData) => {
      ELog.i(EvaAnimPlayer.TAG, `onVideoStart eventData: ${JSON.stringify(eventData)}`);
      let uuid: string = eventData.data?.uuid
      console.log(`onVideoStart, uuid = ${uuid}`);
    })
    emitter.on(EvaConstant.EVENT_ID_ON_VIDEO_RESTART, (eventData: emitter.EventData) => {
      ELog.i(EvaAnimPlayer.TAG, `onVideoRestart eventData: ${JSON.stringify(eventData)}`);
      let uuid: string = eventData.data?.uuid
      console.log(`onVideoRestart, uuid = ${uuid}`);
    })
    emitter.on(EvaConstant.EVENT_ID_ON_VIDEO_RENDER, (eventData: emitter.EventData) => {
      ELog.i(EvaAnimPlayer.TAG, `onVideoRender eventData: ${JSON.stringify(eventData)}`);
      let uuid: string = eventData.data?.uuid
      console.log(`onVideoRender, uuid = ${uuid}`);
    })
    emitter.on(EvaConstant.EVENT_ID_ON_VIDEO_COMPLETE, (eventData: emitter.EventData) => {
      ELog.i(EvaAnimPlayer.TAG, `onVideoComplete eventData: ${JSON.stringify(eventData)}`);
      let uuid: string = eventData.data?.uuid
      console.log(`onVideoComplete, uuid = ${uuid}`);
    })
    emitter.on(EvaConstant.EVENT_ID_ON_VIDEO_DESTROY, (eventData: emitter.EventData) => {
      ELog.i(EvaAnimPlayer.TAG, `onVideoDestroy eventData: ${JSON.stringify(eventData)}`);
      let uuid: string = eventData.data?.uuid
      console.log(`onVideoDestroy, uuid = ${uuid}`);
    })
    emitter.on(EvaConstant.EVENT_ID_ON_FAILED, (eventData: emitter.EventData) => {
      ELog.i(EvaAnimPlayer.TAG, `onFailed eventData: ${JSON.stringify(eventData)}`);
      let uuid: string = eventData.data?.uuid
      console.log(`onFailed, uuid = ${uuid}`);
    })

    await this.play()
  }

  aboutToDisappear(): void {
    this.player.stop()
    emitter.off(EvaConstant.EVENT_ID_ON_VIDEO_CONFIG_READY)
    emitter.off(EvaConstant.EVENT_ID_ON_VIDEO_START)
    emitter.off(EvaConstant.EVENT_ID_ON_VIDEO_RESTART)
    emitter.off(EvaConstant.EVENT_ID_ON_VIDEO_RENDER)
    emitter.off(EvaConstant.EVENT_ID_ON_VIDEO_COMPLETE)
    emitter.off(EvaConstant.EVENT_ID_ON_VIDEO_DESTROY)
    emitter.off(EvaConstant.EVENT_ID_ON_FAILED)
  }

  async play() {
    let rawFd = await this.context.resourceManager.getRawFd(this.videoInfo.fileName)
    let context = this.getUIContext().getHostContext()
    if (context) {
      this.player.startPlayByRawFile(context, this.videoInfo.fileName, rawFd)
    }
  }

  initLog() {
    ELog.isDebug = false
    this.player.setLog(new MyElog())
  }
}

class EvaResourceClickListener implements OnEvaResourceClickListener {
  public uiContext: UIContext
  public promptAction: PromptAction

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
  public context: common.UIAbilityContext
  public dir: string

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
      resource.text = 'USERNICK😄'
      resource.textAlign = 'left'
      result(resource)
    } else {
      result(resource)
    }
  }

  releaseSrc(resources: EvaResource[]): void {
    throw new Error('Method not implemented.');
  }
}