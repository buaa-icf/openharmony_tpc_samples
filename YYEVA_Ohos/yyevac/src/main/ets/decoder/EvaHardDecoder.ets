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

import { Decoder } from './EvaDecoder'
import { EvaAnimPlayer } from '../EvaAnimPlayer'
import { IEvaFileContainer } from '../file/IEvaFileContainer'
import { EvaConstant } from '../util/EvaConstant'
import { ELog } from '../util/ELog'
import { EvaUtil } from '../EvaUtil'
import { emitter } from '@kit.BasicServicesKit'
import { MediaFormat, MediaExtractor, MediaCodec, MediaConstant, CodeInfoAttr, SurfaceTexture } from '@ohos/mediacodec'
import { fileUri } from '@kit.CoreFileKit'
import { collections } from '@kit.ArkTS'

interface LastFrameInterface {
  lastFrame?: boolean;
}

export class EvaHardDecoder extends Decoder {
  public static readonly TAG: string = `${EvaConstant.TAG}.HardDecoder`;
  private glTexture: SurfaceTexture | null = null;
  private textureID: number = 0;
  private needDestroy: boolean = false;
  // 动画的原始尺寸
  private videoWidth: number = 0;
  private videoHeight: number = 0;
  // 动画对齐后的尺寸
  private alignWidth: number = 0;
  private alignHeight: number = 0;
  // 动画是否需要走YUV渲染逻辑的标志位
  private needYUV: boolean = false;
  // 暂停
  private isPause: boolean = false;
  private isRestart: boolean = false;
  private retryCount: number = 0; //初始化失败重试次数
  private evaFileContainer: IEvaFileContainer | null = null;
  private extractor: MediaExtractor | null = null;
  private decoder: MediaCodec | null = null;
  private outputDone: boolean = false;
  private frameIndex: number = 0;
  private failDequeueCount: number = 0;

  constructor(playerEva: EvaAnimPlayer) {
    super(playerEva);
    // 注册emitter监听
    emitter.on(EvaConstant.EVENT_ID_ON_VIDEO_COMPLETE, (eventData: emitter.EventData): void => {
      ELog.i(EvaAnimPlayer.TAG, `onVideoConfigReady eventData: ${JSON.stringify(eventData)}`);
      let uuid: string = eventData.data?.uuid
      if (uuid != this.playerEva.uuid) {
        ELog.e(EvaAnimPlayer.TAG, `uuid不匹配 uuid = ${uuid}, EvaAnimPlayer.uuid = ${this.playerEva.uuid}`)
        return
      }
      const payload = eventData.data as LastFrameInterface;
      const lastFrame = payload?.lastFrame === true;
      ELog.i(Decoder.TAG, `emitter.on onVideoComplete: ${lastFrame}`);
      const callback = this.completeBlock;
      if (callback) {
        callback(lastFrame);
      }
    });
  }

  prepareToPlay(evaFileContainer: IEvaFileContainer): void {
    ELog.i(EvaHardDecoder.TAG, 'prepareToPlay');
    this.isStopReq = false;
    this.isPause = true;
    this.needDestroy = false;
    this.playerEva.runningTask.add(Decoder.TAG);
    setTimeout(() => {
      this.startPlay(evaFileContainer);
    }, 5);
  }

  play(): void {
    ELog.i(EvaHardDecoder.TAG, 'play');
    this.resume();
  }

  start(evaFileContainer: IEvaFileContainer): void {
    ELog.i(EvaHardDecoder.TAG, 'start');
    this.isStopReq = false;
    this.isPause = false;
    this.needDestroy = false;
    this.playerEva.runningTask.add(Decoder.TAG);
    setTimeout(() => {
      this.startPlay(evaFileContainer);
    }, 5);
  }

  onFrameAvailable() {
    ELog.i(EvaHardDecoder.TAG, `onFrameAvailable this.isStopReq: ${this.isStopReq}`);
    if (this.isStopReq) {
      return;
    }

    this.renderData()
  }

  renderData() {
    ELog.i(EvaHardDecoder.TAG, `renderData this.glTexture: ${this.glTexture}`);
    if (this.glTexture) {
      try {
        //渲染mp4数据
        EvaUtil.renderFrame(this.playerEva.controllerId)
        //元素混合
        this.playerEva.pluginManager.onRendering()
        //录制
        // if (this.playerEva.isVideoRecord) {
        //   this.playerEva.mediaRecorder.encodeFrameInThread(false, timestamp)
        // }
        //交换前后景数据
        EvaUtil.renderSwapBuffers(this.playerEva.controllerId);
      } catch (e) {
        ELog.e(EvaHardDecoder.TAG, `render exception=${e}`);
      }
    }
  }

  async startPlay(evaFileContainer: IEvaFileContainer) {
    ELog.i(EvaHardDecoder.TAG, "startPlay");
    this.evaFileContainer = evaFileContainer;

    let format: MediaFormat | null = null;
    let trackIndex: number = 0;
    let duration: number = 0;

    //重置输出数据
    this.outputDone = false; //重置outputDone
    this.frameIndex = 0;

    try {
      if (this.extractor == null) {
        this.extractor = new MediaExtractor();
        console.debug(`create MediaExtractor: ${this.extractor}`);
        let avFileDescriptor = await evaFileContainer.getFile();
        let uri = fileUri.getUriFromPath(avFileDescriptor);
        this.extractor.setMediaUrl(uri);
      }

      trackIndex = this.extractor.getTrackIndex('Video');
      if (trackIndex < 0) {
        ELog.e(EvaHardDecoder.TAG, 'No video track found');
      }

      format = this.extractor.getTrackFormat(trackIndex);
      ELog.i(EvaHardDecoder.TAG, `startPlay format: ${format}`);
      if (format == null) {
        ELog.e(EvaHardDecoder.TAG, 'format is null');
      }

      let videoWidth = format.getInteger(MediaConstant.KEY_WIDTH);
      let videoHeight = format.getInteger(MediaConstant.KEY_HEIGHT);
      let duration = format.getLong(MediaConstant.KEY_DURATION);
      let fps = format.getFloat(MediaConstant.KEY_FRAME_RATE);

      console.debug(`format info, width ${videoWidth}, height: ${videoHeight}, fps:${fps}`);
      if (videoWidth <= 0 || videoHeight <= 0 || fps <= 0) {
        console.error(`get error, width:${videoWidth}, height:${videoHeight}, fps: ${fps}`)
        return;
      }

      ELog.i(EvaHardDecoder.TAG,
        `startPlay videoWidth: ${videoWidth}, videoHeight: ${videoHeight}, duration: ${duration}`);

      if (this.checkIsHevc(format)) {
        let supportFlag = this.extractor.isSupportCodec(EvaConstant.MIME_HEVC);
        if (!supportFlag) {
          let notSupportEventData: emitter.EventData = {
            data: {
              uuid: this.playerEva.uuid,
              errorType: EvaConstant.REPORT_ERROR_TYPE_HEVC_NOT_SUPPORT,
              errorMsg: "${EvaConstant.ERROR_MSG_HEVC_NOT_SUPPORT} " +
                "sdk:${Build.VERSION.SDK_INT}" +
                ",support hevc: video/hevc"
            }
          };
          emitter.emit(EvaConstant.EVENT_ID_ON_FAILED, { priority: emitter.EventPriority.IMMEDIATE },
            notSupportEventData);
          // this.extractor = null;
          return;
        }
      }

      if (!this.playerEva.isSetFps) {
        let fpsTempNum: number = 0;
        ELog.i(EvaHardDecoder.TAG,
          `startPlay format.getFloat(MediaConstant.KEY_FRAME_RATE): ${format.getFloat(MediaConstant.KEY_FRAME_RATE)}`);
        if (format.getFloat(MediaConstant.KEY_FRAME_RATE) != 0) { //防止读不到fps参数的导致无法播放
          fpsTempNum = format.getFloat(MediaConstant.KEY_FRAME_RATE);
          ELog.i(EvaHardDecoder.TAG, `fpsTempNum: ${format.getFloat(MediaConstant.KEY_FRAME_RATE)}`);
        } else {
          ELog.i(EvaHardDecoder.TAG, "can not get frame-rate from media format");
          fpsTempNum = this.playerEva.defaultFps;
        }
        this.playerEva.fps = fpsTempNum;
        ELog.i(EvaHardDecoder.TAG, `this.playerEva.fps: ${this.playerEva.fps}`);
      }

      // 防止没有INFO_OUTPUT_FORMAT_CHANGED时导致alignWidth和alignHeight不会被赋值一直是0
      this.alignWidth = videoWidth
      this.alignHeight = videoHeight
      ELog.i(EvaHardDecoder.TAG, `Video size is ${videoWidth}  x ${videoHeight}`);

      this.needYUV = false; //videoWidth % 16 != 0 && playerEva.enableVersion1;
      this.preparePlay(videoWidth, videoHeight);

      ELog.e(EvaHardDecoder.TAG, `startPlay this.glTexture: ${this.glTexture} `);
      this.glTexture = this.playerEva.getSurfaceTexture();
      if (this.glTexture == null) {
        this.textureID = EvaUtil.getExternalTexture(this.playerEva.controllerId);
        this.glTexture = new SurfaceTexture(this.textureID);
        ELog.e(EvaHardDecoder.TAG,
          `startPlay controllerId: ${this.playerEva.controllerId}, textureID:  ${this.textureID}, glTexture: ${this.glTexture}  `);
      }

      if (videoWidth <= 0 || videoHeight <= 0) {
        ELog.e(EvaHardDecoder.TAG, `error Video size is ${videoWidth}  x ${videoHeight}`);
        let failedEventData: emitter.EventData = {
          data: {
            uuid: this.playerEva.uuid,
            errorType: EvaConstant.REPORT_ERROR_TYPE_EXTRACTOR_EXC,
            errorMsg: `error Video size is ${videoWidth}  x ${videoHeight}`
          }
        };
        emitter.emit(EvaConstant.EVENT_ID_ON_FAILED, { priority: emitter.EventPriority.IMMEDIATE }, failedEventData);
        // this.extractor = null;
        return;
      } else if (this.textureID != -1 && this.glTexture != null) {
        this.glTexture.setOnFrameAvailableListener(() => {
          this.onFrameAvailable();
        });
        this.glTexture.setDefaultBufferSize(videoWidth, videoHeight);
      } else {
        if (this.retryCount > 5) {
          ELog.e(EvaHardDecoder.TAG, "eva not init, can not get glTexture");
          let excEventData: emitter.EventData = {
            data: {
              uuid: this.playerEva.uuid,
              errorType: EvaConstant.REPORT_ERROR_TYPE_EXTRACTOR_EXC,
              errorMsg: "eva not init, can not get glTexture"
            }
          };
          emitter.emit(EvaConstant.EVENT_ID_ON_FAILED, { priority: emitter.EventPriority.IMMEDIATE }, excEventData);
          this.release(this.decoder!, this.extractor);
        } else {
          ELog.e(EvaHardDecoder.TAG, `retryCount ${this.retryCount} eva not init, can not get glTexture`);
          this.retryCount++;
          // this.extractor = null;
          setTimeout(() => {
            this.startPlay(evaFileContainer);
          }, 5);
        }
        return;
      }
      EvaUtil.renderClearFrame(this.playerEva.controllerId);

    } catch (e) {
      if (this.retryCount > 5) {
        ELog.e(EvaHardDecoder.TAG, `MediaExtractor exception e=${e}`);
        let excEventData: emitter.EventData = {
          data: {
            uuid: this.playerEva.uuid,
            errorType: EvaConstant.REPORT_ERROR_TYPE_EXTRACTOR_EXC,
            errorMsg: `${EvaConstant.ERROR_MSG_EXTRACTOR_EXC} e=${e}`
          }
        };
        emitter.emit(EvaConstant.EVENT_ID_ON_FAILED, { priority: emitter.EventPriority.IMMEDIATE }, excEventData);
        this.release(this.decoder!, this.extractor);
      } else {
        ELog.e(EvaHardDecoder.TAG, `retryCount ${this.retryCount}, MediaCodec configure exception e=${e}`);
        this.retryCount++;
        // this.extractor = null;
        setTimeout(() => {
          this.startPlay(evaFileContainer);
        }, 5);
      }
      return;
    }

    try {
      if (this.decoder == null) {
        let mime: string = format.getString(MediaConstant.KEY_MIME);
        this.decoder = new MediaCodec(mime);
        ELog.i(EvaHardDecoder.TAG, `Video MIME is ${mime}, decoder: ${this.decoder}`);
      }
      
      if (this.needYUV) {
        this.decoder.configure(MediaConstant.COLOR_FormatNV12);
      } else {
        this.decoder.configure(-1, this.glTexture);
      }
      
      this.decoder?.bind(this.extractor, (status: number, codecInfo: CodeInfoAttr) => {
        ELog.e(EvaHardDecoder.TAG,
          `bind回调 decoder callback status: ${status}, frameIndex: ${codecInfo.frameIndex}`);
        try {
          if (status < 0) {
            // this.release(this.decoder, this.extractor);
            ELog.e(EvaHardDecoder.TAG, `unexpected result from decoder.dequeueOutputBuffer: ${status}}`);
            return;
          }
          switch (status) {
            case MediaConstant.PLAY_INIT:
              return;
              break;
            case MediaConstant.PLAY_START:
              break;
            case MediaConstant.PLAY_ON:
              this.startDecode(status, codecInfo, evaFileContainer);
              break;
            case MediaConstant.PLAY_PAUSE:
              return;
            case MediaConstant.PLAY_EOS:
            case MediaConstant.PLAY_END:
              if (!this.outputDone) {
                this.DecodeEnd(status);
              }
              break;
          }
        } catch (e) {
          ELog.e(EvaHardDecoder.TAG, `MediaCodec exception e=${e}`);
          let decodeExcEventData: emitter.EventData = {
            data: {
              uuid: this.playerEva.uuid,
              errorType: EvaConstant.REPORT_ERROR_TYPE_DECODE_EXC,
              errorMsg: `${EvaConstant.ERROR_MSG_DECODE_EXC} e=${e}`
            }
          };
          emitter.emit(EvaConstant.EVENT_ID_ON_FAILED, { priority: emitter.EventPriority.IMMEDIATE },
            decodeExcEventData);
          this.release(this.decoder, this.extractor);
        }
      });

      this.decoder?.start();
    } catch (e) {
      ELog.e(EvaHardDecoder.TAG, `retryCount ${this.retryCount}, MediaCodec configure exception e=${e}`);
      if (this.retryCount > 5) {
        let decodeExcEventData: emitter.EventData = {
          data: {
            uuid: this.playerEva.uuid,
            errorType: EvaConstant.REPORT_ERROR_TYPE_DECODE_EXC,
            errorMsg: `${EvaConstant.ERROR_MSG_DECODE_EXC} e=${e}`
          }
        };
        emitter.emit(EvaConstant.EVENT_ID_ON_FAILED, { priority: emitter.EventPriority.IMMEDIATE }, decodeExcEventData);
        this.release(this.decoder, this.extractor);
        return;
      } else { //加入重试机制
        this.retryCount++;
        setTimeout(() => {
          this.startPlay(evaFileContainer);
        }, 5);
      }
    }
  }

  DecodeEnd(status: number): void {
    let loop: number = 0;
    if (status == MediaConstant.PLAY_EOS || status == MediaConstant.PLAY_END) { //整个视频播放到结尾
      ELog.i(EvaHardDecoder.TAG, ` 正常解析  视频播放结束了  this.isLoop: ${this.isLoop}`);
      if (this.isLoop) {
        loop = 1;
      } else {
        loop = --this.playLoop;
        this.playerEva.playLoop = this.playLoop; // 消耗loop次数 自动恢复后能有正确的loop次数
        this.outputDone = this.playLoop <= 0;
      }
    }

    ELog.e(EvaHardDecoder.TAG, `decode next frameIndex=${this.frameIndex}, loop: ${loop}`);
    if (loop > 0) {
      ELog.i(EvaHardDecoder.TAG, "Reached EOD, looping");
      this.playerEva.pluginManager.onLoopStart();
      this.extractor?.seekTo(0, MediaConstant.SEEK_TO_CLOSEST_SYNC);
      let presentationTimeUs = this.extractor?.getSampleTime();
      if (presentationTimeUs == -1) {
        ELog.i(EvaHardDecoder.TAG, `Reached EOD, presentationTimeUs ${presentationTimeUs}`);
        this.decoder?.stop();
        // this.decoder = null;
        // this.extractor = null;
        // this.glTexture = null;
      } else {
        this.decoder?.flush();
        this.speedControlUtil.reset();
        this.frameIndex = 0;
        this.isLoop = true;
        emitter.emit(EvaConstant.EVENT_ID_ON_VIDEO_RESTART, { priority: emitter.EventPriority.IMMEDIATE },
          { data: { uuid: this.playerEva.uuid } });
        let startEventData: emitter.EventData = {
          data: {
            uuid: this.playerEva.uuid,
            flag: true
          }
        };
        emitter.emit(EvaConstant.EVENT_ID_ON_VIDEO_START, { priority: emitter.EventPriority.IMMEDIATE },
          startEventData);
      }
    }
    ELog.e(EvaHardDecoder.TAG, `startDecode outputDone: ${this.outputDone}`);
    if (this.outputDone) { //输出完成
      if (this.playerEva.isSetLastFrame) {
        this.notReleaseLastFrame(this.decoder, this.extractor);
      } else {
        this.release(this.decoder, this.extractor);
      }
    }
  }

  async startDecode(status: number, codecInfo: CodeInfoAttr, evaFileContainer: IEvaFileContainer): Promise<void> {
    ELog.i(EvaHardDecoder.TAG, `startDecode status: ${status}`);
    try {
      if (!this.outputDone) {
        this.frameIndex = codecInfo.frameIndex;

        if (!this.needYUV) {
          this.glTexture?.updateTexImage();
        }

        let doRender: boolean = !this.outputDone;
        if (doRender) { //控制帧率时间
          this.speedControlUtil.preRender(codecInfo.pts);
        }

        if (this.needYUV && doRender) {
          // yuvProcess(decoder, decoderStatus)
        }

        ELog.i(EvaHardDecoder.TAG, `doRender: ${doRender}, decoder?.releaseOutputBuffer`);
        this.decoder?.releaseOutputBuffer(codecInfo.frameIndex);

        ELog.i(EvaHardDecoder.TAG, `codecInfo.frameIndex: ${codecInfo.frameIndex}, !isLoop: ${!this.isLoop}`);
        if (this.frameIndex == 0 && !this.isLoop) {
          emitter.emit(EvaConstant.EVENT_ID_ON_VIDEO_START, { priority: emitter.EventPriority.IMMEDIATE },
            { data: { uuid: this.playerEva.uuid } });
        }

        this.playerEva.pluginManager.onDecoding(this.frameIndex);
        let frameIndexEventData: emitter.EventData = {
          data: {
            uuid: this.playerEva.uuid,
            frameIndex: this.frameIndex,
            config: this.playerEva.configManager.config
          }
        };
        emitter.emit(EvaConstant.EVENT_ID_ON_VIDEO_RENDER, { priority: emitter.EventPriority.IMMEDIATE },
          frameIndexEventData);

      }
    } catch (e) { //解码帧失败跳过，直接继续解尝试
      if (this.failDequeueCount > 5) {
        ELog.e(EvaHardDecoder.TAG, "failDequeueCount $failDequeueCount reason:$e")
        // this.release(this.decoder, this.extractor)
      } else {
        this.failDequeueCount++
      }
    }
  }

  release(decoder: MediaCodec | null, extractor: MediaExtractor | null) {
    ELog.i(EvaHardDecoder.TAG, `release decoder: ${decoder}`);
    EvaUtil.renderClearFrame(this.playerEva.controllerId);
    try {
      //decoder?.stop();
      // this.glTexture?.release();
      // this.decoder = null;
      // this.extractor = null;
      // this.glTexture = null;
      this.speedControlUtil.reset();
      this.playerEva.pluginManager.onRelease();
      this.playerEva.videoMode = EvaConstant.VIDEO_MODE_NORMAL_MP4; //重置为MP4
      // EvaUtil.releaseTexture(this.playerEva.controllerId);
    } catch (e) {
      ELog.e(EvaHardDecoder.TAG, `release catch error: ${e}`);
    }
    this.playerEva?.runningTask.delete(Decoder.TAG);
    emitter.emit(EvaConstant.EVENT_ID_ON_VIDEO_COMPLETE, { priority: emitter.EventPriority.IMMEDIATE },
      { data: { uuid: this.playerEva.uuid } });

    // if (this.playerEva.isVideoRecord) {
    //   this.playerEva.mediaRecorder.stopCodecRecordInThread()
    // }

    if (this.needDestroy) {
      this.destroyInner();
    }
    this.playLoop = 1;
  }

  notReleaseLastFrame(decoder: MediaCodec | null, extractor: MediaExtractor | null) {
    ELog.i(EvaHardDecoder.TAG, "notReleaseLastFrame");
    decoder?.stop();

    // this.decoder = null;
    // this.extractor = null;
    // this.glTexture = null;

    this.speedControlUtil.reset();
    this.playerEva.pluginManager.onRelease();
    this.playerEva?.runningTask.delete(Decoder.TAG);

    //播放到最后一帧，也认为播放完成
    let eventData: emitter.EventData = {
      data: {
        uuid: this.playerEva.uuid,
        lastFrame: true
      }
    };
    emitter.emit(EvaConstant.EVENT_ID_ON_VIDEO_COMPLETE, { priority: emitter.EventPriority.IMMEDIATE }, eventData);
  }

  checkIsHevc(videoFormat: MediaFormat): Boolean {
    let mime: string = videoFormat.getString(MediaConstant.KEY_MIME);
    return mime.includes("hevc")
  }

  restart(): void {
    ELog.i(EvaHardDecoder.TAG, 'restart');
    this.isRestart = true;
    try {
      if (this.glTexture != null && this.decoder != null && this.extractor != null && !this.outputDone) {
        //重置输出数据
        this.frameIndex = 0;
        this.outputDone = false;

        this.decoder?.restart();
      }
    } catch (e) {
      ELog.i(EvaHardDecoder.TAG, `restart catch error: ${e}`);
    }
  }

  pause(): void {
    ELog.i(EvaHardDecoder.TAG, 'pause');
    this.isPause = true;
    try {
      if (!this.outputDone) { //播放结束了
        this.decoder?.pause();
      }
    } catch (e) {
      ELog.i(EvaHardDecoder.TAG, `pause catch error: ${e}`);
    }
  }

  resume(): void {
    ELog.i(EvaHardDecoder.TAG, `resume, this.outputDone: ${this.outputDone}`);
    this.isPause = false;
    try {
      if (this.glTexture != null && this.decoder != null && this.extractor != null && !this.outputDone) {
        this.decoder?.resume();
      }
    } catch (e) {
      ELog.i(EvaHardDecoder.TAG, `resume catch error: ${e}`);
    }
  }

  stop(completeBlock?: ((lastFrame: boolean) => void) | null): void {
    ELog.i(Decoder.TAG, `stop`);
    try {
      if (!this.outputDone) {
        this.isStopReq = true;
        this.completeBlock = completeBlock;
        this.decoder?.stop();
        // this.release(this.decoder, this.extractor);
      }
    } catch (e) {
      ELog.i(EvaHardDecoder.TAG, `stop catch error: ${e}`);
    }
  }

  setSpeed(speed: number): void {
    ELog.i(EvaHardDecoder.TAG, 'setSpeed');
    try {
      if (!this.outputDone) {
        this.isPause = false;
        this.decoder?.setSpeed(speed);
      }
    } catch (e) {
      ELog.i(EvaHardDecoder.TAG, `setSpeed catch error: ${e}`);
    }
  }

  setMute(flag: boolean): void {
    ELog.i(EvaHardDecoder.TAG, 'setMute');
    try {
      if (!this.outputDone) {
        this.isPause = false;
        this.decoder?.setMute(flag);
      }
    } catch (e) {
      ELog.i(EvaHardDecoder.TAG, `setMute catch error: ${e}`);
    }
  }

  destroy(): void {
    ELog.i(EvaHardDecoder.TAG, 'destroy');
    this.isPause = false;
    ELog.i(EvaHardDecoder.TAG,
      `destroy this.playerEva.runningTask.has(Decoder.TAG): ${this.playerEva.runningTask.has(Decoder.TAG)}`);
    try {
      if (this.playerEva.runningTask.has(Decoder.TAG)) {
        this.needDestroy = true;
        this.stop();
      } else {
        this.releaseLastFrame();
        this.destroyInner();
      }
    } catch (e) {
      ELog.i(EvaHardDecoder.TAG, `destroy catch error: ${e}`);
    } finally {
      emitter.off(EvaConstant.EVENT_ID_ON_VIDEO_COMPLETE);
    }
  }

  private destroyInner(): void {
    ELog.i(EvaHardDecoder.TAG, 'destroyInner');
    try {
      this.evaFileContainer?.close();
      this.playerEva.pluginManager.onDestroy()
      EvaUtil.destroyRender(this.playerEva.controllerId)
      // if (this.playerEva.isVideoRecord) {
      //   this.playerEva.mediaRecorder.stopCodecRecordInThread()
      // }
      // this.decoder = null;
      // this.extractor = null;
      // this.glTexture = null;
      this.playerEva.controllerId = -1;
      emitter.emit(EvaConstant.EVENT_ID_ON_VIDEO_DESTROY, { priority: emitter.EventPriority.IMMEDIATE },
        { data: { uuid: this.playerEva.uuid } });
      this.destroyThread();
      this.completeBlock = null;
    } catch (e) {
      ELog.i(EvaHardDecoder.TAG, `destroyInner catch error: ${e}`);
    }
  }

  private releaseLastFrame(): void {
    ELog.i(EvaHardDecoder.TAG, `releaseLastFrame controllerId: ${this.playerEva.controllerId}`);
    if (!this.playerEva.isSetLastFrame) {
      return;
    }

    try {
      EvaUtil.renderClearFrame(this.playerEva.controllerId);
      // this.glTexture = null;
      EvaUtil.releaseTexture(this.playerEva.controllerId);
    } catch (e) {
      ELog.e(EvaHardDecoder.TAG, `releaseLastFrame catch error: ${e}`);
    }

    this.playerEva?.runningTask.delete(Decoder.TAG);
    emitter.emit(EvaConstant.EVENT_ID_ON_VIDEO_COMPLETE, { priority: emitter.EventPriority.IMMEDIATE },
      { data: { uuid: this.playerEva.uuid } });

    if (this.needDestroy) {
      this.destroyInner();
    }
    this.playerEva.isSetLastFrame = false;
  }
}
