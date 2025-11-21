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

import { EvaFileContainer } from './file/EvaFileContainer';
import { IEvaFileContainer } from './file/IEvaFileContainer';
import { IEvaFetchResource } from './inter/IEvaFetchResource';
import { OnEvaResourceClickListener } from './inter/OnEvaResourceClickListener';
import { EvaAnimPluginManager } from './plugin/EvaAnimPluginManager';
import { ELog, IELog } from './util/ELog';
import { EvaBlendMode } from './util/EvaBlendMode';
import { EvaConstant } from './util/EvaConstant';
import { IScaleType, ScaleType, ScaleTypeUtil } from './util/ScaleTypeUtil';
import { emitter } from '@kit.BasicServicesKit';
import { Decoder } from './decoder/EvaDecoder';
import { EvaHardDecoder } from './decoder/EvaHardDecoder';
import { EvaAnimConfigManager } from './EvaAnimConfigManager';
import { EvaUtil } from './EvaUtil';
// import { EvaMediaRecorder } from './recorder/EvaMediaRecorder';
import { common } from '@kit.AbilityKit';
import { EvaRawFileContainer } from './file/EvaRawFileContainer';
import { resourceManager } from '@kit.LocalizationKit';
import { EvaAnimConfig } from './EvaAnimConfig';
import { ComponentUtils, UIContext } from '@kit.ArkUI';
import { JSON } from '@kit.ArkTS';
import { SurfaceTexture } from '@ohos/mediacodec'

/**
 * EvaAnimComponent组件控制器
 */
@Observed
export class EvaAnimPlayer {
  static readonly TAG: string = `${EvaConstant.TAG}.EvaAnimPlayer`
  scaleTypeUtil: ScaleTypeUtil = new ScaleTypeUtil()
  @Track xArea: Area = {
    width: '100%',
    height: '100%',
    position: { x: 0, y: 0 },
    globalPosition: { x: 0, y: 0 }
  }
  uuid: string // player中的唯一标识，在player被创建的时候必须传入，可以用于同时存在多个视频动画时过滤当前播放的事件
  rect: SurfaceRect | null = null
  xController: XComponentController | null = null;
  configManager: EvaAnimConfigManager = new EvaAnimConfigManager(this)
  pluginManager: EvaAnimPluginManager = new EvaAnimPluginManager(this);
  decoder: Decoder | null = null
  // decoder.playLoop和evaAudioPlayer.playLoop值需要同步
  private _playLoop: number = 1; // 循环播放次数

  public set playLoop(value: number) {
    this._playLoop = value;
    if (this.decoder) {
      this.decoder.playLoop = value
    }
  }

  public get playLoop(): number {
    return this._playLoop;
  }

  // decoder.isLoop和evaAudioPlayer.isLoop值需要同步
  private _isLoop: boolean = false; // 是否循环播放

  public set isLoop(value: boolean) {
    this._isLoop = value;
    if (this.decoder) {
      this.decoder.isLoop = value
    }
  }

  public get isLoop(): boolean {
    return this._isLoop;
  }

  startPoint: number = 0 // 开启播放位置
  supportMaskBoolean: boolean = false
  maskEdgeBlurBoolean: boolean = false
  isSetLastFrame = false //是否停留在最后一帧
  videoMode: number = EvaConstant.VIDEO_MODE_NORMAL_MP4 // 正常mp4
  isSetFps: boolean = false;
  defaultFps: number = 30; // 设置默认的fps <= 0 表示以mp4内配置为准 > 0  表示以此设置为准
  blendMode: number = EvaBlendMode.BLEND_SRC_ALPHA
  // fps，decoder.fps的值也需要同步
  private _fps: number = 0;

  public get fps(): number {
    return this._fps;
  }

  public set fps(value: number) {
    this._fps = value;
    if (this.decoder) {
      this.decoder.fps = value
    }
  }

  // 用于存储正在运行的player，player开始运行加入set，结束运行从set中移除，加入的时候加入player对应的类名
  runningTask: Set<string> = new Set<string>()
  isStartPlay = false
  lastEvaFile: IEvaFileContainer | null = null;
  bg: PixelMap | null = null;
  isNormalMp4 = false //是否正常的不透明的mp4
  isSurfaceAvailable = false
  surfaceId: string | null = null
  surfaceTexure: SurfaceTexture | null = null;
  // 组件是否被卸载
  isDetachedFromWindow: boolean = false
  /**
   * 设置视频准备好后是否继续播放
   */
  isVideoConfigReady: boolean = true;
  controllerId: number = -1; //底层Native管理器id

  isVideoRecord: boolean = false //是否开启录制

  //mediaRecorder: EvaMediaRecorder = new EvaMediaRecorder()
  context: common.UIAbilityContext
  uiContext: UIContext
  startRunnable: (() => void) | null = null
  isPause: boolean = false
  /**
   * 准备纹理视图，（Android上的接口，但由于鸿蒙是响应式布局所以应该不需要实现）
   */
  prepareTextureView = (): void => {
    throw Error('Method is not implemented')
  }

  constructor(context: UIContext, uuid: string) {
    this.uiContext = context
    this.context = context.getHostContext() as common.UIAbilityContext
    this.uuid = uuid

    // 注册emitter监听
    emitter.on(EvaConstant.EVENT_ID_ON_VIDEO_CONFIG_READY, (eventData: emitter.EventData): void => {
      ELog.i(EvaAnimPlayer.TAG, `onVideoConfigReady eventData: ${JSON.stringify(eventData)}`);
      let uuid: string = eventData.data?.uuid
      if (uuid != this.uuid) {
        ELog.e(EvaAnimPlayer.TAG, `uuid不匹配 uuid = ${uuid}, EvaAnimPlayer.uuid = ${this.uuid}`)
        return
      }
      let config: EvaAnimConfig = eventData.data?.config
      ELog.i(EvaAnimPlayer.TAG, `onVideoConfigReady width ${config.width}, height ${config.height}`)
      this.scaleTypeUtil.setVideoSize(context.px2vp(config.videoWidth), context.px2vp(config.videoHeight))
      this.updateUI()
    })
    emitter.on(EvaConstant.EVENT_ID_SIZE_CHANGED, (eventData: emitter.EventData) => {
      ELog.i(EvaAnimPlayer.TAG, `sieze_changed eventData: ${JSON.stringify(eventData)}`);
      let uuid: string = eventData.data?.uuid
      if (uuid != this.uuid) {
        ELog.e(EvaAnimPlayer.TAG, `uuid不匹配 uuid = ${uuid}, EvaAnimPlayer.uuid = ${this.uuid}`)
        return
      }
      ELog.i(EvaAnimPlayer.TAG, `size_changed`);
      this.updateUI()
    })
  }

  /**
   * 设置布局的初始尺寸
   */
  setLayoutSize() {
    try {
      let componentUtils: ComponentUtils = this.uiContext.getComponentUtils();
      let modePosition = componentUtils.getRectangleById("eva_anim_component_stack");
      ELog.i(EvaAnimPlayer.TAG, `setLayoutSize, modePosition = ${JSON.stringify(modePosition)}`)
      this.scaleTypeUtil.setLayoutSize(this.uiContext.px2vp(modePosition.size.width),
        this.uiContext.px2vp(modePosition.size.height))
    } catch (error) {
      ELog.e(EvaAnimPlayer.TAG, `setLayoutSize, error = ${JSON.stringify(error)}`)
    }
  }


  /**
   * 替代Android端，getSurfaceTexture()，getSurface()
   */
  getSurfaceId(): string | null {
    return this.surfaceId;
  }

  getSurfaceTexture(): SurfaceTexture | null {
    return this.surfaceTexure;
  }

  /**
   * 设置资源获取器
   */
  setFetchResource(evaFetchResource: IEvaFetchResource | null): void {
    let mixAnimPlugin = this.pluginManager.getMixAnimPlugin();
    if (mixAnimPlugin) {
      mixAnimPlugin.resourceRequestEva = evaFetchResource
    }
  }

  /**
   * 设置资源点击监听器
   */
  setOnResourceClickListener(evaResourceClickListener: OnEvaResourceClickListener | null): void {
    let mixAnimPlugin = this.pluginManager.getMixAnimPlugin();
    if (mixAnimPlugin) {
      mixAnimPlugin.evaResourceClickListener = evaResourceClickListener
    }
  }

  /**
   * 兼容方案，优先保证表情显示
   */
  enableAutoTxtColorFill(enable: boolean): void {
    let mixAnimPlugin = this.pluginManager.getMixAnimPlugin();
    if (mixAnimPlugin) {
      mixAnimPlugin.autoTxtColorFill = enable
    }
  }

  /**
   * 循环播放数，（对应Android中IEvaAnimView中的playLoop接口）
   */
  setPlayLoop(playLoop: number): void {
    this.playLoop = playLoop
  }

  /**
   * 设置无限循环,（对应Android中IEvaAnimView中的isLoop接口）
   */
  setIsLoop(isLoop: boolean): void {
    this.isLoop = isLoop
  }

  /**
   * 设置起始播放位置 毫秒
   * 硬解某些机型会有跳帧前几帧解析异常的问题，不建议使用。
   */
  setStartPoint(startPoint: number): void {
    this.startPoint = startPoint
  }

  /**
   * 支持遮罩
   */
  supportMask(isSupport: boolean, isEdgeBlur: boolean): void {
    this.supportMaskBoolean = isSupport
    this.maskEdgeBlurBoolean = isEdgeBlur
  }

  /**
   * 设置视频模式
   */
  setVideoMode(mode: number): void {
    this.videoMode = mode
  }

  /**
   * 设置视频帧数和倍率
   */
  setVideoFps(fps: number, speed: number): void {
    ELog.i(EvaAnimPlayer.TAG, "setVideoFps=$fps， speed=$speed")
    this.isSetFps = true
    this.defaultFps = fps * speed
  } // speed为倍速

  /**
   * 设置音频倍速
   */
  setAudioSpeed(speed: number): void {
    ELog.i(EvaAnimPlayer.TAG, "setAudioSpeed=$speed")
    this.decoder?.setSpeed(speed)
  }

  /**
   * 设置缩放类型
   */
  setScaleType(type: ScaleType): void {
    this.scaleTypeUtil.currentScaleType = type
  }

  /**
   * 设置缩放类型
   */
  setIScaleType(scaleType: IScaleType): void {
    this.scaleTypeUtil.scaleTypeImpl = scaleType
  }

  /**
   * 设置静音
   */
  setMute(isMute: boolean): void {
    ELog.i(EvaAnimPlayer.TAG, "set mute=$isMute")
    if (this.isRunning()) {
      this.decoder?.setMute(isMute)
    }
  }

  /**
   * 准备播放文件
   */
  async prepareToPlay(file: string, repeatCount: number = 0): Promise<void> {
    try {
      this.playLoop = repeatCount
      let fileContainer = new EvaFileContainer(file)
      fileContainer.init()
      await this.startPlayByFileContainer(fileContainer, true)
    } catch (err) {
      let eventData: emitter.EventData = {
        data: {
          uuid: this.uuid,
          errorType: EvaConstant.REPORT_ERROR_TYPE_FILE_ERROR,
          errorMsg: EvaConstant.ERROR_MSG_FILE_ERROR
        }
      };
      emitter.emit(EvaConstant.EVENT_ID_ON_FAILED, { priority: emitter.EventPriority.IMMEDIATE }, eventData)
      emitter.emit(EvaConstant.EVENT_ID_ON_VIDEO_COMPLETE, { priority: emitter.EventPriority.IMMEDIATE },
        { data: { uuid: this.uuid } })
    }
  }

  /**
   * 重新开始
   */
  restart(): void {
    if (this.isRunning()) {
      this.decoder?.restart();
    }
  }

  /**
   * 播放
   */
  play(): void {
    this.isStartPlay = true
    if (this.runningTask.has(Decoder.TAG)) { //解码器准备完毕
      this.decoder?.play()
    }
  }

  /**
   * 播放文件
   * @param context 上下文对象
   * @param fileName 文件名称
   * @param rawFileDescriptor 资源文件对象
   */
  async startPlayByRawFile(context: Context, fileName: string,
    rawFileDescriptor: resourceManager.RawFileDescriptor): Promise<void> {
    try {
      let fileContainer = new EvaRawFileContainer(context, fileName, rawFileDescriptor)
      await fileContainer.init()
      await this.startPlayByFileContainer(fileContainer)
    } catch (err) {
      let eventData: emitter.EventData = {
        data: {
          uuid: this.uuid,
          errorType: EvaConstant.REPORT_ERROR_TYPE_FILE_ERROR,
          errorMsg: EvaConstant.ERROR_MSG_FILE_ERROR
        }
      };
      emitter.emit(EvaConstant.EVENT_ID_ON_FAILED, { priority: emitter.EventPriority.IMMEDIATE }, eventData)
      emitter.emit(EvaConstant.EVENT_ID_ON_VIDEO_COMPLETE, { priority: emitter.EventPriority.IMMEDIATE },
        { data: { uuid: this.uuid } })
    }
  }

  /**
   * 播放文件
   * @param filePath 文件路径
   */
  async startPlayByFilePath(filePath: string): Promise<void> {
    try {
      let fileContainer = new EvaFileContainer(filePath)
      await fileContainer.init()
      await this.startPlayByFileContainer(fileContainer)
    } catch (err) {
      ELog.e(EvaAnimPlayer.TAG, `startPlayByFilePath err = ${JSON.stringify(err)}`)
      let eventData: emitter.EventData = {
        data: {
          uuid: this.uuid,
          errorType: EvaConstant.REPORT_ERROR_TYPE_FILE_ERROR,
          errorMsg: EvaConstant.ERROR_MSG_FILE_ERROR
        }
      };
      emitter.emit(EvaConstant.EVENT_ID_ON_FAILED, { priority: emitter.EventPriority.IMMEDIATE }, eventData)
      emitter.emit(EvaConstant.EVENT_ID_ON_VIDEO_COMPLETE, { priority: emitter.EventPriority.IMMEDIATE },
        { data: { uuid: this.uuid } })
    }
  }

  /**
   * 播放文件容器(对应Android中的startPlay(evaFileContainer: IEvaFileContainer, prepare: Boolean = false))
   */
  async startPlayByFileContainer(evaFileContainer: IEvaFileContainer, prepare: boolean = false): Promise<void> {
    if (this.isPause) {
      this.resume()
    }
    if (!(this.isRunning())) {
      this.lastEvaFile = evaFileContainer
      await this.startPlayCommon(evaFileContainer, prepare)
    } else {
      ELog.e(EvaAnimPlayer.TAG, "is running can not start")
    }
  }

  /**
   * 暂停播放
   */
  pause(): void {
    if (this.isRunning()) {
      this.isPause = true
      this.decoder?.pause()
    }
  }

  /**
   * 恢复播放
   */
  resume(): void {
    if (this.isRunning()) {
      this.isPause = false
      this.decoder?.resume()
    }
  }

  /**
   * 停止播放
   */
  stop(completeBlock?: (success: boolean) => void): void {
    // if (this.isRunning()) {
    this.decoder?.stop(completeBlock)
    // }
  }

  /**
   * 是否正在运行
   */
  isRunning(): boolean {
    ELog.i(EvaAnimPlayer.TAG, `isStartRunning $isStartRunning, decoderRunning ${this.runningTask.has(Decoder.TAG)}`)
    return this.runningTask.has(EvaAnimPlayer.TAG) || this.runningTask.has(Decoder.TAG)
  }

  /**
   * 获取实际尺寸
   */
  getRealSize(): Size {
    return this.scaleTypeUtil.getRealSize()
  }

  /**
   * 更新纹理视图布局
   */
  updateTextureViewLayout = (): void => {
    // todo 待确认是否需要实现
  }

  /**
   * 设置背景图
   */
  setBgImage(bg: PixelMap): void {
    this.bg = bg
  }

  /**
   * 是否有背景图
   */
  hasBgImage(): boolean {
    return this.bg != null
  }

  /**
   * 是否不透明度mp4
   */
  setNormalMp4(isNormalMp4: boolean): void {
    ELog.i(EvaAnimPlayer.TAG, `isNormalMp4=${isNormalMp4}`)
    this.isNormalMp4 = isNormalMp4
  }

  /**
   * 是否停留在最后一帧
   */
  setLastFrame(isSetLastFrame: boolean): void {
    this.isSetLastFrame = isSetLastFrame
  }

  /**
   * 设置日志打印
   */
  setLog(log: IELog): void {
    ELog.log = log
    ELog.setNapiLog()
  }

  /**
   * 设置混合模式
   */
  setBlend(blendMode: number): void {
    this.blendMode = blendMode
    this.decoder?.setBlend(blendMode)
  }

  setVideoRecord(isVideoRecord: boolean) {
    ELog.i(EvaAnimPlayer.TAG, `setVideoRecord=${isVideoRecord}`)
    this.isVideoRecord = isVideoRecord
  }

  /**
   * 对应Android中的EvaAnimPlayer中的startPlay()方法
   * @param evaFileContainer
   * @param prepare
   */
  async startPlayCommon(evaFileContainer: IEvaFileContainer, prepare: boolean = false) {
    // 开始运行
    this.runningTask.add(EvaAnimPlayer.TAG)
    this.prepareDecoder()
    if (this.decoder?.prepareThread() == false) {
      this.runningTask.delete(EvaAnimPlayer.TAG)
      let eventData: emitter.EventData = {
        data: {
          uuid: this.uuid,
          errorType: EvaConstant.REPORT_ERROR_TYPE_CREATE_THREAD,
          errorMsg: EvaConstant.ERROR_MSG_CREATE_THREAD
        }
      };
      emitter.emit(EvaConstant.EVENT_ID_ON_FAILED, { priority: emitter.EventPriority.IMMEDIATE }, eventData)
      emitter.emit(EvaConstant.EVENT_ID_ON_VIDEO_COMPLETE, { priority: emitter.EventPriority.IMMEDIATE },
        { data: { uuid: this.uuid } })
      this.decoder.completeBlock?.(false)
      return
    }

    let result = await this.configManager.parseConfig(evaFileContainer, this.defaultFps)
    if (result != EvaConstant.OK) {
      this.runningTask.delete(EvaAnimPlayer.TAG)
      let eventData: emitter.EventData = {
        data: {
          uuid: this.uuid,
          errorType: result,
          errorMsg: EvaConstant.getErrorMsg(result)
        }
      };
      emitter.emit(EvaConstant.EVENT_ID_ON_FAILED, { priority: emitter.EventPriority.IMMEDIATE }, eventData)
      emitter.emit(EvaConstant.EVENT_ID_ON_VIDEO_COMPLETE, { priority: emitter.EventPriority.IMMEDIATE },
        { data: { uuid: this.uuid } })
      this.decoder?.completeBlock?.(false)
      return
    }
    ELog.i(EvaAnimPlayer.TAG, `parse ${JSON.stringify(this.configManager.config)}`)
    let config = this.configManager.config
    // 如果是默认配置，因为信息不完整onVideoConfigReady不会被调用
    if (config != null) {
      if (this.rect) {
        this.decoder?.onSurfaceSizeChanged(this.rect.surfaceWidth, this.rect.surfaceHeight)
      } else {
        this.decoder?.onSurfaceSizeChanged(config.videoWidth, config.videoHeight)
      }
      let eventData: emitter.EventData = {
        data: {
          uuid: this.uuid,
          config: config
        }
      };
      ELog.i(EvaAnimPlayer.TAG, `发送事件：${EvaConstant.EVENT_ID_ON_VIDEO_CONFIG_READY}`);
      emitter.emit(EvaConstant.EVENT_ID_ON_VIDEO_CONFIG_READY, { priority: emitter.EventPriority.IMMEDIATE },
        eventData); //发出onVideoConfigReady事件
      if (config.isDefaultConfig || this.isVideoConfigReady == true) {
        this.innerStartPlay(evaFileContainer, prepare)
      } else {
        ELog.i(EvaAnimPlayer.TAG, "onVideoConfigReady return false")
      }
    }
  }

  private innerStartPlay(evaFileContainer: IEvaFileContainer, prepare: Boolean = false): void {
    if (this.isSurfaceAvailable) {
      ELog.i(EvaAnimPlayer.TAG, "decoder start")
      this.runningTask.delete(EvaAnimPlayer.TAG)
      if (prepare) { //准备播放
        this.decoder?.prepareToPlay(evaFileContainer);
      } else { //立刻播放
        this.decoder?.start(evaFileContainer);
      }
    } else {
      ELog.i(EvaAnimPlayer.TAG, "use startRunnable")
      this.startRunnable = async () => {
        this.innerStartPlay(evaFileContainer, prepare)
        if (this.isStartPlay) { //延迟调用触发
          this.play()
        }
      }
    }
  }

  /**
   * 创建编解码和音频播放实例
   */
  private prepareDecoder() {
    if (this.decoder == null) {
      this.decoder = new EvaHardDecoder(this)
      this.decoder.playLoop = this.playLoop
      this.decoder.isLoop = this.isLoop
      this.decoder.fps = this.fps
      this.decoder.blendMode = this.blendMode
    }
  }

  async onSurfaceCreated(surfaceId: string) {
    ELog.i(EvaAnimPlayer.TAG, `onSurfaceCreated surfaceId = ${surfaceId}`)
    this.surfaceId = surfaceId;
    this.controllerId = EvaUtil.initRender(this.controllerId, this.surfaceId,
      false, this.isNormalMp4, this.isVideoRecord)
    let textureId = EvaUtil.getExternalTexture(this.controllerId)
    if (textureId < 0) {
      ELog.e(EvaAnimPlayer.TAG, "surfaceCreated init OpenGL ES failed!")
    } else {
      if (this.bg != null) {
        EvaUtil.setBgPixelMap(this.controllerId, this.bg)
        this.bg.release()
      }
      if (this.isVideoRecord) {
        // this.mediaRecorder.initRecord(this.controllerId, this.getRealSize().width,
        //     this.getRealSize().height)
        let saveAddress = this.context?.getApplicationContext().filesDir as string;

        if (this.isVideoRecord) {
          //this.mediaRecorder.startCodecRecord(saveAddress, this._fps)
        }
      }
      this.surfaceTexure = new SurfaceTexture(textureId);
    }
    this.isSurfaceAvailable = true
    if (this.startRunnable != null) {
      this.startRunnable
    }
    this.startRunnable = null
    this.setLayoutSize()
  }

  onSurfaceTextureSizeChanged(surfaceId: string, rect: SurfaceRect) {
    ELog.i(EvaAnimPlayer.TAG, `onSurfaceTextureSizeChanged ${rect.surfaceWidth} x ${rect.surfaceHeight}`)
    this.rect = rect
    this.decoder?.onSurfaceSizeChanged(rect.surfaceWidth as number, rect.surfaceHeight)
  }

  /**
   * XComponent中的Surface插件卸载完成时回调事件。(对应Android中onSurfaceTextureDestroyed())
   */
  async onSurfaceDestroyed() {
    this.isSurfaceAvailable = false
    this.runningTask.delete(EvaAnimPlayer.TAG)
    this.startPoint = 0
    this.decoder?.destroy()
    if (this.bg != null) {
      await this.bg.release()
      this.bg = null
    }
    emitter.off(EvaConstant.EVENT_ID_ON_VIDEO_CONFIG_READY);
    emitter.off(EvaConstant.EVENT_ID_SIZE_CHANGED);
  }

  /**
   * 组件被挂载
   */
  async aboutToAppear(): Promise<void> {
    ELog.i(EvaAnimPlayer.TAG, "aboutToAppear")
    this.isDetachedFromWindow = false
    // 自动恢复播放
    if (this.playLoop > 0) {
      if (this.lastEvaFile != null) {
        await this.startPlayByFileContainer(this.lastEvaFile)
      }
    }
  }

  /**
   * 组件被卸载
   */
  aboutToDisappear(): void {
    ELog.i(EvaAnimPlayer.TAG, "aboutToDisappear")
    this.surfaceId = null
    this.bg = null
    this.isDetachedFromWindow = true
    this.runningTask.clear()
    this.onSurfaceDestroyed()
  }

  /**
   * 组件外部容器尺寸变化时回调
   *
   * @param oldValue
   * @param newValue
   */
  onStackAreaChange(oldValue: Area, newValue: Area) {
    let nw = newValue.width;
    let nh = newValue.height;
    if (nw && nh) {
      ELog.i(EvaAnimPlayer.TAG, `onStackAreaChange，新的尺寸：nw = ${nw}, nh = ${nh}`)
      if (this && this.scaleTypeUtil) {
        this.scaleTypeUtil.setLayoutSize(nw as number, nh as number)
        // 触发尺寸变化，更新UI
        this.updateUI()
      }
    }
  }

  /**
   * 触发UI更新
   */
  updateUI() {
    try {
      let componentUtils: ComponentUtils = this.uiContext.getComponentUtils();
      let modePosition = componentUtils.getRectangleById("eva_anim_component_stack");
      ELog.i(EvaAnimPlayer.TAG, `updataUI, modePosition = ${JSON.stringify(modePosition)}`)
      const area: Area = {
        width: this.uiContext.px2vp(modePosition.size.width),
        height: this.uiContext.px2vp(modePosition.size.height),
        position: {
          x: this.uiContext.px2vp(modePosition.localOffset.x),
          y: this.uiContext.px2vp(modePosition.localOffset.y)
        },
        globalPosition: {
          x: this.uiContext.px2vp(modePosition.windowOffset.x),
          y: this.uiContext.px2vp(modePosition.windowOffset.y)
        }
      }
      this.xArea = this.scaleTypeUtil.getLayoutParam(area)
    } catch (error) {
      ELog.e(EvaAnimPlayer.TAG, `updataUI, error = ${JSON.stringify(error)}`)
    }
  }

  /**
   * 页面被显示回调
   */
  onPageShow() {

  }

  /**
   * 页面被隐藏回调
   */
  onPageHide() {

  }
}