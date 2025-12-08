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

import { ELog, EvaAnimComponent, EvaAnimPlayer, EvaConstant, OnEvaResourceClickListener } from '@ohos/yyevac';
import { common } from '@kit.AbilityKit';
import { VideoInfo } from '../bean/VideoInfo';
import { MyElog } from '../bean/MyElog';
import { emitter, BusinessError } from '@kit.BasicServicesKit';
import { EvaResource } from '@ohos/yyevac/src/main/ets/mix/EvaResource';
import { PromptAction } from '@kit.ArkUI';
import { ScaleType } from '@ohos/yyevac/src/main/ets/util/ScaleTypeUtil';
import request from '@ohos.request';
import { fileIo as fs } from '@kit.CoreFileKit';

@Component
export struct EvaDownloadDemo {
  @Consume('pageInfos') pageInfos: NavPathStack;
  @Prop title: string;
  public arr: string[] = ['PLAY', 'STOP']
  @State player: EvaAnimPlayer = new EvaAnimPlayer(this.getUIContext(), 'EvaDownloadDemo')
  public context: common.UIAbilityContext = this.getUIContext().getHostContext() as common.UIAbilityContext;
  public dir: string = this.context.cacheDir
  public videoInfo: VideoInfo = new VideoInfo('effect.mp4', '400a778f258ed6bd02ec32defe8ca8be')
  public url: string = ''

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
                    } else if (data.item == this.arr[1]) {
                      this.player.stop()
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

      this.closeDownloadDemoRawFdFile();
    })
    emitter.on(EvaConstant.EVENT_ID_ON_VIDEO_DESTROY, (eventData: emitter.EventData) => {
      ELog.i(EvaAnimPlayer.TAG, `onVideoDestroy eventData: ${JSON.stringify(eventData)}`);
      let uuid: string = eventData.data?.uuid
      console.log(`onVideoDestroy, uuid = ${uuid}`);

      this.closeDownloadDemoRawFdFile();
    })
    emitter.on(EvaConstant.EVENT_ID_ON_FAILED, (eventData: emitter.EventData) => {
      ELog.i(EvaAnimPlayer.TAG, `onFailed eventData: ${JSON.stringify(eventData)}`);
      let uuid: string = eventData.data?.uuid
      console.log(`onFailed, uuid = ${uuid}`);

      this.closeDownloadDemoRawFdFile();
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

  closeDownloadDemoRawFdFile() {
    try {
      this.context.resourceManager.closeRawFd(this.videoInfo.fileName, (error: BusinessError) => {
        if (error != null) {
          console.error(`closeRawFd ${this.videoInfo.fileName} error is ` + JSON.stringify(error));
          return;
        }
        console.info(`closeRawFd ${this.videoInfo.fileName} success.`);
      });
    } catch (error) {
      ELog.e(EvaAnimPlayer.TAG, `closeDownloadDemoRawFdFile catch error: ${JSON.stringify(error)}`);
    }
  }

  initLog() {
    ELog.isDebug = false
    this.player.setLog(new MyElog())
  }

  async play() {
    await this.downloadVideo(this.url)
  }

  async downloadVideo(url: string): Promise<string | null> {
    const fileName = Date.now() + '.mp4'
    const sandboxPath = this.context.filesDir + '/' + fileName; // 沙箱路径

    try {
      if (await fs.access(sandboxPath)) {
        // 已经存在视频文件，则直接返回沙箱地址，防止重复创建
        console.info('沙箱路径中已有同名的视频文件直接返回')
        await fs.unlink(sandboxPath)
      }
      const downloadTask = await request.downloadFile(this.context, {
        url: url,
        filePath: sandboxPath // 直接保存到沙箱
      });
      downloadTask.on('fail', (err: number) => {
        console.error(`下载失败， err: ${err}`);
        downloadTask.off('complete')
        downloadTask.off('fail')
      });
      downloadTask.on('complete', async () => {
        console.info(`下载完成`);
        downloadTask.off('complete')
        downloadTask.off('fail')
        await this.player.startPlayByFilePath(sandboxPath)
      })
      return sandboxPath;
    } catch (err) {
      console.error(`下载失败: ${err.code}, ${err.message}`);
      return null
    }
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