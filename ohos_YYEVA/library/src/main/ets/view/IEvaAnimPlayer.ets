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

import { ELog } from '../util/ELog';
import { EvaPref } from '../file/EvaPref';
import { common } from '@kit.AbilityKit';
import { EvaConstant } from '../util/EvaConstant';
import { ComponentUtils } from '@kit.ArkUI';
import { IScaleType, ScaleType, ScaleTypeUtil } from '../util/ScaleTypeUtil';
import { emitter } from '@kit.BasicServicesKit';

type EventCallback = Callback<emitter.EventData>;

@Observed
export abstract class IEvaAnimPlayer {
  static readonly TAG: string = `${EvaConstant.TAG}.IEvaAnimPlayer`
  public uuid: string

  @Track xArea: Area = {
    width: "100%",
    height: "100%",
    position: { x: 0, y: 0 },
    globalPosition: { x: 0, y: 0 }
  }
  @Track isNormalMp4 = false; //是否正常的不透明的mp4

  public controllerId: number = -1; //底层Native管理器id
  private uiContext: UIContext;
  public context: common.UIAbilityContext
  scaleTypeUtil: ScaleTypeUtil;


  constructor(context: UIContext, uuid: string) {
    this.uiContext = context;
    this.context = context.getHostContext() as common.UIAbilityContext
    this.uuid = uuid;
    this.scaleTypeUtil = new ScaleTypeUtil();
  }

  abstract isRunning(): boolean;
  abstract hasBgImage(): boolean;
  abstract onDispatchTouchEvent(event: TouchEvent): boolean;
  abstract onConfigReady(eventData: emitter.EventData): void;
  abstract onSizeChanged(eventData: emitter.EventData): void;

  abstract aboutToAppear(): Promise<void>;
  abstract aboutToDisappear(): Promise<void>;
  // abstract onPageShow();
  // abstract onPageHide();

  abstract onSurfaceCreated(surfaceId: string): void;
  abstract onSurfaceDestroyed(surfaceId: string): void;
  abstract onSurfaceChanged(surfaceId: string, rect: SurfaceRect): void;

  async onLoad() {
    // 注册emitter监听
    this.on(EvaConstant.EVENT_ID_ON_VIDEO_CONFIG_READY, (eventData: emitter.EventData): void => {
      ELog.i(IEvaAnimPlayer.TAG, `onVideoConfigReady eventData: ${JSON.stringify(eventData)}`);
      this.onConfigReady(eventData);
    })
    this.on(EvaConstant.EVENT_ID_SIZE_CHANGED, (eventData: emitter.EventData) => {
      ELog.i(IEvaAnimPlayer.TAG, `onSizeChanged eventData: ${JSON.stringify(eventData)}`);
      this.onSizeChanged(eventData);
    })
    await this.aboutToAppear();
  }

  onDestroy(): void {
    this.off(EvaConstant.EVENT_ID_ON_VIDEO_CONFIG_READY);
    this.off(EvaConstant.EVENT_ID_SIZE_CHANGED);
    this.aboutToDisappear();
  }

  on(event: string, callback: Callback<emitter.EventData>) {
    emitter.on(event + this.uuid, callback);
  }

  off(event: string) {
    emitter.off(event + this.uuid);
  }

  sendEvent(event: string, eventData: emitter.EventData) {
    emitter.emit(event + this.uuid, { priority: emitter.EventPriority.IMMEDIATE }, eventData)
  }

  px2vp(x: number): number {
    try {
      let y = this.uiContext.px2vp(x);
      if (y == undefined) {
        return x;
      }
      return y;
    } catch (e) {
      ELog.e(IEvaAnimPlayer.TAG, `px2vp error: ${e}`)
    }
    return x;
  }

  vp2px(x: number): number {
    return this.uiContext.vp2px(x);
  }

  /**
   * 设置布局的初始尺寸
   */
  setLayoutSize() {
    try {
      let componentUtils: ComponentUtils = this.uiContext.getComponentUtils();
      let modePosition = componentUtils.getRectangleById("eva_anim_component_stack");
      this.scaleTypeUtil.setLayoutSize(this.px2vp(modePosition.size.width),
        this.px2vp(modePosition.size.height))
    } catch (error) {
      ELog.e(IEvaAnimPlayer.TAG, `setLayoutSize, error = ${JSON.stringify(error)}`)
    }
  }

  /**
   * 触发UI更新
   */
  updateUI() {
    try {
      let componentUtils: ComponentUtils = this.uiContext.getComponentUtils();
      let modePosition = componentUtils.getRectangleById("eva_anim_component_stack");
      const area: Area = {
        width: this.px2vp(modePosition.size.width),
        height: this.px2vp(modePosition.size.height),
        position: {
          x: this.px2vp(modePosition.localOffset.x),
          y: this.px2vp(modePosition.localOffset.y)
        },
        globalPosition: {
          x: this.px2vp(modePosition.windowOffset.x),
          y: this.px2vp(modePosition.windowOffset.y)
        }
      }
      let newArea: Area = this.scaleTypeUtil.getLayoutParam(area)
      this.xArea = newArea;
      ELog.i(IEvaAnimPlayer.TAG, `updateUI, ${modePosition.size.width}x${modePosition.size.height} -> ${this.xArea.width}x${this.xArea.height}`)
    } catch (error) {
      ELog.e(IEvaAnimPlayer.TAG, `updataUI, error = ${JSON.stringify(error)}`)
    }
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
      ELog.d(IEvaAnimPlayer.TAG, `onStackAreaChange nw = ${nw}, nh = ${nh}`)
      if (this && this.scaleTypeUtil) {
        // this.scaleTypeUtil.setVideoSize(this.uiContext.px2vp(nw as number), this.uiContext.px2vp(nh as number));
        this.scaleTypeUtil.setLayoutSize(nw as number, nh as number)
        // 触发尺寸变化，更新UI
        this.updateUI()
      }
    }
  }

  /**
   *  设置视频长宽
   */
  setVideoSize(width: number, height: number): void {
    this.scaleTypeUtil.setVideoSize(width, height);
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
   * 获取实际尺寸
   */
  getRealSize(): Size {
    return this.scaleTypeUtil.getRealSize()
  }
}