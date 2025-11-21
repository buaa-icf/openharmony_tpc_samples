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

import { EvaAnimPlayer } from '../EvaAnimPlayer'
import { EvaConstant } from '../util/EvaConstant'
import { ELog } from '../util/ELog'
import { EvaUtil } from '../EvaUtil'
import { SpeedControlUtil } from '../util/SpeedControlUtil'
import { emitter } from '@kit.BasicServicesKit'
import { collections } from '@kit.ArkTS';
import { IEvaFileContainer } from '../file/IEvaFileContainer'

export abstract class Decoder {
  public static readonly TAG: string = `${EvaConstant.TAG}.Decoder`
  public readonly playerEva: EvaAnimPlayer;
  public completeBlock: ((lastFrame: boolean) => void) | null | undefined = null;
  public readonly speedControlUtil: SpeedControlUtil = new SpeedControlUtil();
  public playLoop: number = 1; // 循环播放次数
  public isLoop: boolean = false; //无限循环

  public isStopReq: boolean = false // 是否需要停止
  public blendMode: number = 1;
  private _fps: number = 0

  protected constructor(playerEva: EvaAnimPlayer) {
    this.playerEva = playerEva;
  }

  get fps(): number {
    return this._fps;
  }

  set fps(value: number) {
    ELog.i(Decoder.TAG, `set fps: ${value}`);
    this._fps = value;
    if (value > 0) {
      this.speedControlUtil.setFixedPlaybackRate(value);
    }
  }

  abstract start(evaFileContainer: IEvaFileContainer): void;

  abstract prepareToPlay(evaFileContainer: IEvaFileContainer): void;

  abstract play(): void;

  abstract restart(): void;

  abstract pause(): void;

  abstract resume(): void;

  abstract destroy(): void;

  abstract stop(completeBlock?: ((lastFrame: boolean) => void) | null): void;

  abstract setSpeed(speed: number): void;

  abstract setMute(flag: boolean): void;

  prepareThread(): boolean {
    ELog.i(Decoder.TAG, `prepareThread`);
    return true;
  }

  protected getEventNumber(eventData: collections.Map<string, number | boolean> | undefined, key: string): number {
    if (!eventData) {
      return 0;
    }
    const value = eventData.get(key);
    if (typeof value === 'number') {
      return value;
    }
    return 0;
  }

  protected getEventBoolean(eventData: collections.Map<string, number | boolean> | undefined, key: string): boolean {
    if (!eventData) {
      return false;
    }
    const value = eventData.get(key);
    if (typeof value === 'boolean') {
      return value;
    }
    return false;
  }

  preparePlay(videoWidth: number, videoHeight: number): void {
    ELog.i(Decoder.TAG, `preparePlay videoWidth: ${videoWidth}, videoHeight: ${videoHeight}`);
    try {
      ELog.i(Decoder.TAG, `EvaUtil.setBlendMode 调用前`);
      EvaUtil.setBlendMode(this.playerEva.controllerId, this.blendMode);
      ELog.i(Decoder.TAG, `EvaUtil.setBlendMode 调用后`);
      this.playerEva.configManager.defaultConfig(videoWidth, videoHeight);
      const config = this.playerEva.configManager.config;
      if (config) {
        ELog.i(Decoder.TAG, `preparePlay config.isDefaultConfig: ${config.isDefaultConfig}`);
        if (config.isDefaultConfig) {
          let mode = EvaConstant.VIDEO_MODE_NORMAL_MP4;
          if (this.playerEva.isNormalMp4) {
            mode = EvaConstant.VIDEO_MODE_NORMAL_MP4;
          } else {
            mode = config.defaultVideoMode;
          }
          EvaUtil.defaultConfig(this.playerEva.controllerId, videoWidth, videoHeight, mode);

          let eventData: emitter.EventData = {
            data: {
              uuid: this.playerEva.uuid,
              config: config
            }
          };
          ELog.i(Decoder.TAG, "ON_VIDEO_CONFIG_READY 1");
          emitter.emit(EvaConstant.EVENT_ID_ON_VIDEO_CONFIG_READY, { priority: emitter.EventPriority.IMMEDIATE },
            eventData); //发出onVideoConfigReady事件
          emitter.emit(EvaConstant.EVENT_ID_SIZE_CHANGED, { priority: emitter.EventPriority.IMMEDIATE },
            { data: { uuid: this.playerEva.uuid } });
          ELog.i(Decoder.TAG, "ON_VIDEO_CONFIG_READY 2");
        } else if (config.jsonConfig != null) {
          ELog.i(Decoder.TAG, `EvaUtil.setRenderConfig 调用前`);
          EvaUtil.setRenderConfig(this.playerEva.controllerId, JSON.stringify(config.jsonConfig));
          ELog.i(Decoder.TAG, `EvaUtil.setRenderConfig 调用后`);
        }
      }

      this.playerEva.pluginManager.onRenderCreate();
    } catch (e) {
      ELog.e(Decoder.TAG, `preparePlay error: ${e?.message}`);
    }
  }

  videoSizeChange(newWidth: number, newHeight: number): void {
    ELog.i(Decoder.TAG, `videoSizeChange newWidth: ${newWidth}, newHeight: ${newHeight}`);
    EvaUtil.videoSizeChange(this.playerEva.controllerId, newWidth, newHeight);
  }

  destroyThread(): void {
    ELog.i(Decoder.TAG, `destroyThread this.playerEva.isDetachedFromWindow: ${this.playerEva.isDetachedFromWindow}`);
    if (this.playerEva.isDetachedFromWindow) {}
  }

  onSurfaceSizeChanged(width: number, height: number): void {
    ELog.i(Decoder.TAG, `EvaUtil.updateViewPoint 调用前`);
    EvaUtil.updateViewPoint(this.playerEva.controllerId, width, height);
    ELog.i(Decoder.TAG, `EvaUtil.updateViewPoint 调用后, width: ${width}, height: ${height}`);
  }

  setBlend(blend: number): void {
    this.blendMode = blend;
  }
}
