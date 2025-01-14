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

import media from '@ohos.multimedia.media';
import resourceManager from '@ohos.resourceManager';
import emitter from '@ohos.events.emitter';
import Logger from './utils/Logger';
import common from '@ohos.app.ability.common';
import { BusinessError } from '@kit.BasicServicesKit';
import { audio } from '@kit.AudioKit';
import { CacheListener, HttpProxyCacheServer, HttpProxyCacheServerBuilder } from '@ohos/video-cache';
import GlobalProxyServer from './GlobalProxyServer';
import fs from '@ohos.file.fs';
import { promptAction } from '@kit.ArkUI';
import { hilog } from '@kit.PerformanceAnalysisKit';


const CASE_ZERO = 0;
const CASE_ONE = 1;
const CASE_TWO = 2;
const CASE_THREE = 3;

export default class AvPlayManager {
  private tag: string = 'videoCache AVPlayManager ';
  private avPlayer: media.AVPlayer | null = null;
  private surfaceID: string | null = null;
  private mgr: resourceManager.ResourceManager | null = null;
  private currentTime: number = 0;
  // 视频当前时间
  private durationTime: number = 0;
  // 视频总长
  private videoSelectIndex: number | null = null;
  // 倍速选择
  private fileDescriptor: resourceManager.RawFileDescriptor | null = null;
  private videoSrc: string | null = null;
  private default_track_value: string = '';
  private track_name_value: string = '';
  private currentAudioTrackValue: number = 0;
  public arrList: Array<SelectOption> = [];
  // 字幕
  public arrSubTitleList: Array<SelectOption> = []
  private currentSubtitleStateValue: number = 0
  private text: string | null = ''
  private startTime: number | null = 0
  private duration: number | null = 0
  private sourceInfoCallBack: ((infoType: media.BufferingInfoType, value: number) => void) | null = null
  private errorTime: number = 0

  /**
   * 初始化视频
   */
  async initPlayer(ctx: common.UIAbilityContext, surfaceId: string,
    callback: (avPlayer: media.AVPlayer) => void): Promise<void> {
    Logger.info(this.tag, `initPlayer==initCamera surfaceId== ${surfaceId}`);
    this.surfaceID = surfaceId;
    Logger.info(this.tag, `initPlayer==this.surfaceID surfaceId== ${this.surfaceID}`);
    try {
      Logger.info(this.tag, 'initPlayer videoPlay avPlayerDemo');
      // 创建avPlayer实例对象
      this.avPlayer = await media.createAVPlayer();
      // 创建状态机变化回调函数
      await this.setAVPlayerCallback(callback);
      Logger.info(this.tag, 'initPlayer videoPlay setAVPlayerCallback');
      this.mgr = ctx.resourceManager;
      Logger.info(this.tag, 'initPlayer videoPlay this.mgr');
      this.videoSrc = 'test1.mp4'
      this.fileDescriptor = await this.mgr.getRawFd(this.videoSrc);
      Logger.info(this.tag, `initPlayer videoPlay fileDescriptor = ${JSON.stringify(this.fileDescriptor)}`);
      this.avPlayer.fdSrc = this.fileDescriptor;

      this.addSubtitleFdSrc()
      this.mgr.getStringValue($r('app.string.default_track')).then((value: string) => {
        this.default_track_value = value;
      }).catch((error: BusinessError) => {
        hilog.error(0x0001, "getStringValue", JSON.stringify(error), 3);
      });
      this.mgr.getStringValue($r('app.string.track_name')).then((value: string) => {
        this.track_name_value = value;
      }).catch((error: BusinessError) => {
        hilog.error(0x0001, "getStringValue", JSON.stringify(error), 3);
      });
      // 字幕相关
      await this.getSubtitleStates()
    } catch (err) {
      Logger.error(this.tag, `initPlayer initPlayer err：${JSON.stringify(err)}`);
    }
  }

  // 视频信息上报函数
  async setSourceInfo(): Promise<void> {

    if (this.avPlayer === null) {
      Logger.info(this.tag, 'this.avPlayer is null')
    }
    // 音量变化回调函数
    this.avPlayer?.on('volumeChange', (vol: number) => {
      Logger.info(this.tag, 'volumeChange success,and new volume is :' + vol);
    });
    // 视频播放结束触发回调
    this.avPlayer?.on('endOfStream', () => {
      Logger.info(this.tag, 'endOfStream success');
    });
    // seek操作回调函数
    this.avPlayer?.on('seekDone', (seekDoneTime: number) => {
      Logger.info(this.tag, 'seekDone success,and seek time is:' + seekDoneTime);
    });
    // 视频总时长上报函数
    this.avPlayer?.on('durationUpdate', (duration: number) => {
      Logger.info(this.tag, 'durationUpdate success,and durationUpdate is:' + duration);
    });
    // 设置倍速播放回调函数
    this.avPlayer?.on('speedDone', (speed: number) => {
      Logger.info(this.tag, 'speedDone success,and speed value is:' + speed);
      Logger.info(this.tag, 'speed state is :' + this.getState());
    });
    // bitrate设置成功回调函数
    this.avPlayer?.on('bitrateDone', (bitrate: number) => {
      Logger.info(this.tag, 'bitrateDone success,and bitrate value is:' + bitrate);
    });
    // 缓冲上报回调函数
    this.avPlayer?.on('bufferingUpdate', (infoType: media.BufferingInfoType, value: number) => {
      // Logger.info(this.tag, 'bufferingUpdate  infoType = ' + infoType + ', value = ' + value);
      if (this.sourceInfoCallBack) {
        this.sourceInfoCallBack(infoType, value)
      }
    });
    // 首帧上报回调函数
    this.avPlayer?.on('startRenderFrame', () => {
      Logger.info(this.tag, 'startRenderFrame success');
    });
    // 视频宽高上报回调函数
    this.avPlayer?.on('videoSizeChange', (width: number, height: number) => {
      Logger.info(this.tag, 'videoSizeChange success,and width is:' + width + ', height is :' + height);
    });
    // 焦点上报回调函数
    this.avPlayer?.on('audioInterrupt', (info: audio.InterruptEvent) => {
      // 触发焦点上报后调用暂停接口暂停播放
      // this.pause();
      // this.isPlaying = !this.isPlaying;
      Logger.info(this.tag, 'audioInterrupt success,and InterruptEvent info is:' + JSON.stringify(info));
    });
    // HLS上报所有支持的比特率
    this.avPlayer?.on('availableBitrates', (bitrates: Array<number>) => {
      Logger.info(this.tag, 'availableBitrates success,and availableBitrates length is:' + bitrates.length);
    });
  }

  getState(): string {
    return this.avPlayer?.state ? this.avPlayer?.state : '';
  }


  // 注册avplayer回调函数
  async setAVPlayerCallback(callback: (avPlayer: media.AVPlayer) => void, videoSrc?: string): Promise<void> {
    // seek操作结果回调函数
    if (this.avPlayer === null) {
      Logger.info(this.tag, 'avPlayer has not init');
      return;
    }
    this.avPlayer.on('seekDone', (seekDoneTime) => {
      Logger.info(this.tag, `setAVPlayerCallback AVPlayer seek succeeded, seek time is ${seekDoneTime}`);
    });
    // error回调监听函数,当avPlayer在操作过程中出现错误时调用reset接口触发重置流程
    this.avPlayer.on('error', async (err) => {
      this.errorTime = this.currentTime
      Logger.error(this.tag, `avPlayer error: ${JSON.stringify(err)}`);
      if (this.avPlayer === null) {
        Logger.info(this.tag, 'avPlayer has not init');
        return;
      }

      if (err.code === 5400103) {
        promptAction.showToast({
          message: JSON.stringify(err),
          duration: 2000
        });
      }
    });

    // 状态机变化回调函数
    this.avPlayer.on('stateChange', async (state, reason) => {
      Logger.info(this.tag, 'stateChange is called >> state = ' + state + '   reason=' + JSON.stringify(reason))
      if (this.avPlayer === null) {
        Logger.info(this.tag, 'avPlayer has not init');
        return;
      }
      switch (state) {
        case 'idle': // 成功调用reset接口后触发该状态机上报
          Logger.info(this.tag, 'setAVPlayerCallback AVPlayer state idle called.');
          this.avPlayer.release();
          this.avPlayerChoose(callback);
          break;
        case 'initialized': // avplayer 设置播放源后触发该状态上报
          Logger.info(this.tag, 'setAVPlayerCallback AVPlayerstate initialized called.');
          if (this.surfaceID) {
            this.avPlayer.surfaceId = this.surfaceID; // 设置显示画面，当播放的资源为纯音频时无需设置
            Logger.info(this.tag, `setAVPlayerCallback this.avPlayer.surfaceId = ${this.avPlayer.surfaceId}`);
            await this.avPlayer.prepare();
            Logger.info(this.tag, `prepare------`);
          }
          break;
        case 'prepared': // prepare调用成功后上报该状态机
          Logger.info(this.tag, 'setAVPlayerCallback AVPlayer state prepared called.');
          this.getAudioTrack();
          this.durationTime = this.avPlayer.duration;
          this.currentTime = this.avPlayer.currentTime;
          this.avPlayer.seek(this.errorTime)
          this.avPlayer.play(); // 调用播放接口开始播放
          callback(this.avPlayer);
          break;
        case 'playing': // play成功调用后触发该状态机上报
          Logger.info(this.tag, 'setAVPlayerCallback AVPlayer state playing called.');
          let eventDataTrue: emitter.EventData = {
            data: {
              'flag': true
            }
          };
          let innerEventTrue: emitter.InnerEvent = {
            eventId: 2,
            priority: emitter.EventPriority.HIGH
          };
          emitter.emit(innerEventTrue, eventDataTrue);
          break;
        case 'completed': // 播放结束后触发该状态机上报
          Logger.info(this.tag, 'setAVPlayerCallback AVPlayer state completed called.');
          let eventDataFalse: emitter.EventData = {
            data: {
              'flag': false
            }
          };
          let innerEvent: emitter.InnerEvent = {
            eventId: 1,
            priority: emitter.EventPriority.HIGH
          };
          emitter.emit(innerEvent, eventDataFalse);
          break;
        case 'error':
          Logger.info(this.tag, 'setAVPlayerCallback AVPlayer state error.');
          'break'
        case 'released':
          Logger.info(this.tag, 'setAVPlayerCallback AVPlayer state released.');
          // this.videoReset()
          // this.avPlayerChoose(callback)
          'break'
        default:
          Logger.info(this.tag, 'setAVPlayerCallback AVPlayer state unknown called.');
          break;
      }
    });
    // 时间上报监听函数
    this.avPlayer.on('timeUpdate', (time: number) => {
      this.currentTime = time;
    });
    // 字幕回调函数
    this.avPlayer.on('subtitleUpdate', (info: media.SubtitleInfo) => {
      if (!!info) {
        this.text = (!info.text) ? '' : info.text
        this.startTime = (!info.startTime) ? 0 : info.startTime
        this.duration = (!info.duration) ? 0 : info.duration
      } else {
        Logger.info(this.tag, 'subtitleUpdate info is null')
      }
    })
  }

  /**
   * 获取总时间
   */
  getDurationTime(): number {
    return this.durationTime;
  }

  /**
   * 获取当前时间
   */
  getCurrentTime(): number {
    return this.currentTime;
  }

  /**
   * 视频播放
   */
  videoPlay(): void {
    if (this.avPlayer) {
      try {
        this.avPlayer.play();
      } catch (e) {
        Logger.error(this.tag, `videoPlay err : ${JSON.stringify(e)}`);
      }
    }
  }

  /**
   * 视频暂停
   */
  videoPause(): void {
    if (this.avPlayer) {
      try {
        this.avPlayer.pause();
        Logger.info(this.tag, 'videoPause');
      } catch (e) {
        Logger.info(this.tag, `videoPause err : ${JSON.stringify(e)}`);
      }
    }
  }

  /**
   * 调节1.0倍速
   */
  videoSpeedOne(): void {
    if (this.avPlayer) {
      try {
        this.avPlayer.setSpeed(media.PlaybackSpeed.SPEED_FORWARD_1_00_X);
        Logger.info(this.tag, 'videoSpeed_1_00');
      } catch (e) {
        Logger.info(this.tag, `videoSpeed_1_00 err : ${JSON.stringify(e)}`);
      }
    }
  }

  /**
   * 调节1.25倍速
   */
  videoSpeedOnePointTwentyFive(): void {
    if (this.avPlayer) {
      try {
        this.avPlayer.setSpeed(media.PlaybackSpeed.SPEED_FORWARD_1_25_X);
        Logger.info(this.tag, 'videoSpeed_1_25');
      } catch (e) {
        Logger.info(this.tag, `videoSpeed_1_25 err : ${JSON.stringify(e)}`);
      }
    }
  }

  /**
   * 调节1.75倍速
   */
  videoSpeedOnePointSeventyFive(): void {
    if (this.avPlayer) {
      try {
        this.avPlayer.setSpeed(media.PlaybackSpeed.SPEED_FORWARD_1_75_X);
        Logger.info(this.tag, 'videoSpeed_1_75');
      } catch (e) {
        Logger.info(this.tag, `videoSpeed_1_75 err :` + JSON.stringify(e));
      }
    }
  }

  /**
   * 调节2.0倍速
   */
  videoSpeedTwo(): void {
    if (this.avPlayer) {
      try {
        this.avPlayer.setSpeed(media.PlaybackSpeed.SPEED_FORWARD_2_00_X);
        Logger.info(this.tag, 'videoSpeed_2_0');
      } catch (e) {
        Logger.info(this.tag, `videoSpeed_2_0 err : ${JSON.stringify(e)}`);
      }
    }
  }

  /**
   * 视频跳转
   */
  async videoSeek(seekTime: number): Promise<void> {
    if (this.avPlayer) {
      try {
        this.avPlayer.seek(seekTime, media.SeekMode.SEEK_PREV_SYNC);
        this.currentTime = seekTime;
        Logger.info(this.tag, `videoSeek: ${seekTime}`);
      } catch (e) {
        Logger.info(this.tag, `videoSeek err: ${JSON.stringify(e)}`);
      }
    }
  }

  setVideoScaleType(sacleValue: number): void {
    Logger.info(this.tag, 'set videoScaleType value is:' + sacleValue);
    switch (sacleValue) {
      case 0:
        if (this.avPlayer != undefined) {
          this.avPlayer.videoScaleType = media.VideoScaleType.VIDEO_SCALE_TYPE_FIT;
        }
        break;
      case 1:
        if (this.avPlayer != undefined) {
          this.avPlayer.videoScaleType = media.VideoScaleType.VIDEO_SCALE_TYPE_FIT_CROP;
        }
        break;
      default:
        Logger.info(this.tag, 'no this mode videoScaleType:' + sacleValue);
        break;
    }
  }

  /**
   * 视频重置
   */
  async videoReset(): Promise<void> {
    if (this.avPlayer === null) {
      Logger.info(this.tag, 'avPlayer has not init');
      return;
    }
    this.avPlayer.reset();
    this.clearSubtitle()
  }

  /**
   * 视频预下载
   */
  async preDownload(url: string): Promise<void> {
    if (this.avPlayer) {
      let mediaSource: media.MediaSource = media.createMediaSourceWithUrl(url, {
        'aa': 'bb', 'cc': 'dd'
      });
      let playbackStrategy: media.PlaybackStrategy = {
        preferredWidth: 1,
        preferredHeight: 2,
        preferredBufferDuration: 3,
        preferredHdr: false
      };
      this.avPlayer.setMediaSource(mediaSource, playbackStrategy)
      Logger.info(this.tag, 'setMediaSource  success  ');
    }
  }

  // 获取视频多音轨列表
  async getAudioTrack(): Promise<void> {
    if (this.avPlayer) {
      this.avPlayer.getTrackDescription().then((arrList: Array<media.MediaDescription>) => {
        Logger.info('getTrackDescription success');
        Logger.info(this.tag, 'get AudioTrackList: ' + arrList.length);
        if (this.arrList.length === 0 && arrList !== null) {
          let selectOptions: SelectOption[] = [];
          for (let i = 0; i < arrList.length; i++) {
            if (i === 0) {
              selectOptions.push({
                value: this.default_track_value
              });
            } else {
              let property: Object = arrList[i][media.MediaDescriptionKey.MD_KEY_TRACK_INDEX];
              selectOptions.push({
                value: this.track_name_value + property.toString()
              });
            }
          }
          this.arrList = selectOptions
        } else {
          Logger.info(this.tag, 'audio getTrackDescription fail');
        }
      }).catch((error: BusinessError) => {
        Logger.error(`video catchCallback, error:${error}`);
      });
      return;
    }
  }

  // 设置视频多音轨轨道
  async setAudioTrack(audioTrackValue: number): Promise<void> {
    Logger.info(this.tag, 'selectTrack set AudioTrackType value is:' + audioTrackValue);
    switch (audioTrackValue) {
      case 0:
        if (this.avPlayer != null && this.currentAudioTrackValue != 0) {
          Logger.info(this.tag, 'deselectTrack start:' + (this.currentAudioTrackValue));
          this.avPlayer.deselectTrack(this.currentAudioTrackValue)
          Logger.info(this.tag, 'deselectTrack end:' + (this.currentAudioTrackValue));
        }
        break;
      default:
        if (this.avPlayer != null) {
          this.currentAudioTrackValue = audioTrackValue;
          Logger.info(this.tag, 'selectTrack start:' + (audioTrackValue));
          this.avPlayer.selectTrack(audioTrackValue)
          Logger.info(this.tag, 'selectTrack end:' + (audioTrackValue));
        }
        break;
    }
  }

  /**
   * 释放视频资源
   */
  async videoRelease(): Promise<void> {
    if (this.avPlayer === null) {
      Logger.info(this.tag, 'avPlayer has not init');
      return;
    }
    this.avPlayer.release((err) => {
      if (err === null) {
        Logger.info(this.tag, 'videoRelease release success');
      } else {
        Logger.error(this.tag, `videoRelease release filed,error message is = ${JSON.stringify(err)}`);
      }
    });
  }

  /**
   * 视频切换，前台调用
   */
  async videoChoose(videoSrc: string, videoSelectIndex: number): Promise<void> {
    try {
      this.videoSrc = videoSrc;
      this.videoSelectIndex = videoSelectIndex;
      Logger.info(this.tag, `videoChoose this.videoSrc = ${this.videoSrc}`);
      this.currentTime = 0;
      this.currentAudioTrackValue = 0;
      this.arrList = []
      this.videoReset();
    } catch (e) {
      Logger.info(this.tag, `videoChoose err = ${JSON.stringify(e)}`);
    }
  }

  setSourceInfoCallBack(callback: (infoType: media.BufferingInfoType, value: number) => void) {
    this.sourceInfoCallBack = callback
  }

  /**
   * 视频切换，换视频资源
   */
  async avPlayerChoose(callback: (avPlayer: media.AVPlayer) => void): Promise<void> {
    try {
      Logger.info(this.tag, 'avPlayerChoose avPlayerDemo');
      // 创建avPlayer实例对象
      this.avPlayer = await media.createAVPlayer();
      this.setSourceInfo()
      // 创建状态机变化回调函数
      await this.setAVPlayerCallback(callback);

      class MyCacheListener implements CacheListener {
        onCacheAvailable(cacheFilePath: string, url: string, percentsAvailable: number) {
          // Logger.info(self.tag, `currentCachePercent = ${percentsAvailable}`);
          AppStorage.setOrCreate('currentCachePercent', percentsAvailable);
        }
      }

      if (this.videoSrc?.startsWith("http") || this.videoSrc?.startsWith("https")) {
        Logger.info(this.tag, `videoSrc = ${this.videoSrc}`);
        let server: HttpProxyCacheServer = new HttpProxyCacheServerBuilder(getContext()).build();
        server.registerCacheListener(new MyCacheListener(), this.videoSrc);
        GlobalProxyServer?.getInstance()?.setServer(server)
        let proxyUrl: string | undefined =
          await GlobalProxyServer?.getInstance()?.getServer()?.getProxyUrl(this.videoSrc)
        Logger.info(this.tag, `proxyUrl = ${proxyUrl}`);
        let newUrl = proxyUrl ? proxyUrl : this.videoSrc;
        if (newUrl?.startsWith(getContext().cacheDir)) {
          let file = fs.openSync(newUrl, fs.OpenMode.READ_ONLY);
          newUrl = "fd://" + file.fd;
          AppStorage.setOrCreate('currentCachePercent', 100);
        }
        this.videoSrc = newUrl
      }

      if (this.videoSrc) {
        let regex = /^(https?:\/\/|fd:)/;
        let bool = regex.test(this.videoSrc);
        if (bool) {
          this.avPlayer.url = this.videoSrc;
        } else {
          if (this.mgr) {
            this.fileDescriptor = await this.mgr.getRawFd(this.videoSrc);
            Logger.info(this.tag,
              `avPlayerChoose avPlayerChoose  fdSrc fileDescriptor = ${JSON.stringify(this.fileDescriptor)}`);
            this.avPlayer.fdSrc = this.fileDescriptor;
            // 字幕
            this.addSubtitleFdSrc()
          }
        }
      }
    } catch (e) {
      Logger.info(this.tag, 'avPlayerChoose try catch avPlayerChoose');
      this.videoReset();
    }
  }

  // 字幕相关
  async getSubtitleStates(): Promise<void> {
    let selectOptions: SelectOption[] = []
    if (this.mgr) {
      this.mgr.getStringValue($r('app.string.subtitle_on')).then((v: string) => {
        selectOptions.push({
          value: v
        })
      }).catch((error: BusinessError) => {
        Logger.error('subtitle getStringValue promise error is ' + error)
      })
      this.mgr.getStringValue($r('app.string.subtitle_off')).then((v: string) => {
        selectOptions.push({
          value: v
        })
      }).catch((e: BusinessError) => {
        Logger.error('subtitle getStringValue promise error is ' + e)
      })
      this.arrSubTitleList = selectOptions
    }
    Logger.info(this.tag, 'subtitle getSubtitleStates end:' + `${JSON.stringify(this.arrSubTitleList.length)}`)
  }

  async setSubtitleState(subtitleState: number): Promise<void> {
    Logger.info(this.tag, 'subtitle  setSubtitleState value is:' + subtitleState)
    this.currentSubtitleStateValue = subtitleState
  }

  getSubTitle(): string {
    if (this.currentSubtitleStateValue === 0 && !!this.startTime && !!this.duration && !!this.text) {
      if (this.startTime > 0 && this.duration > 0 && this.currentTime > 0) {
        let dis = this.currentTime - this.startTime
        if (0 <= dis && dis <= this.duration) {
          return this.text
        }
      }
    }
    return ''
  }

  clearSubtitle(): void {
    this.text = ''
    this.startTime = 0
    this.duration = 0
    Logger.info(this.tag, 'subtitle clearSubtitle')
  }

  async addSubtitleFdSrc(): Promise<void> {
    if (!this.videoSrc) {
      Logger.info(this.tag, 'subtitle addSubtitleFdSrc videoSrc is null')
      return
    }
    if (!this.mgr) {
      Logger.info(this.tag, 'subtitle addSubtitleFdSrc this.mgr is null')
      return
    }
    let subtitleSource = this.videoSrc.split('.')[0] + '.srt'
    Logger.info(this.tag, 'subtitle addSubtitleFdSrc ' + subtitleSource)
    this.fileDescriptor = await this.mgr.getRawFd(subtitleSource)
    if (!this.fileDescriptor) {
      Logger.info(this.tag, 'subtitle subtitleSource maybe not exists')
      return
    }
    if (!this.avPlayer) {
      Logger.info(this.tag, 'subtitle addSubtitleFdSrc avPlayer has not init')
      return
    }
    Logger.info(this.tag,
      `subtitle fd=${this.fileDescriptor.fd}, offset=${this.fileDescriptor.offset}, length=${this.fileDescriptor.length}`)
    this.avPlayer.addSubtitleFromFd(this.fileDescriptor.fd, this.fileDescriptor.offset, this.fileDescriptor.length)
  }
}