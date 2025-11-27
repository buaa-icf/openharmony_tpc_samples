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
import { EvaAnimConfig } from '../EvaAnimConfig'
import { IEvaFetchResource } from '../inter/IEvaFetchResource'
import { OnEvaResourceClickListener } from '../inter/OnEvaResourceClickListener'
import { IEvaAnimPlugin } from '../plugin/IEvaAnimPlugin'
import { ELog } from '../util/ELog'
import { EvaUtil } from '../EvaUtil'
import { EvaSrc, EvaSrcMap } from './EvaSrc'
import { EvaFrameAll } from './EvaFrame'
import { EvaMixTouch } from './EvaMixTouch'
import { EvaResource } from './EvaResource'
import { image } from '@kit.ImageKit'
import { BusinessError } from '@kit.BasicServicesKit'
import { EvaBitmapUtil } from '../util/EvaBitmapUtil'
import { JSON } from '@kit.ArkTS'
import { deviceInfo } from '@kit.BasicServicesKit';

/**
 * YYEVA 混合动画插件
 * 负责处理混合渲染功能
 */
export class EvaMixAnimPlugin implements IEvaAnimPlugin {
  private static readonly TAG = `${EvaConstant.TAG}.MixAnimPlugin`
  public resourceRequestEva: IEvaFetchResource | null = null
  public evaResourceClickListener: OnEvaResourceClickListener | null = null
  public srcMap: EvaSrcMap | null = null
  public frameAll: EvaFrameAll | null = null
  public curFrameIndex: number = -1
  private mixTouch: EvaMixTouch
  public autoTxtColorFill: boolean = true
  public playerEva: EvaAnimPlayer;

  constructor(playerEva: EvaAnimPlayer) {
    this.playerEva = playerEva;
    this.mixTouch = new EvaMixTouch(this);
  }

  /**
   * 配置创建
   */
  async onConfigCreate(config: EvaAnimConfig): Promise<number> {
    if (!config.isMix) {
      return EvaConstant.OK
    }

    if (this.resourceRequestEva === null) {
      ELog.e(EvaMixAnimPlugin.TAG, 'IFetchResource is empty')
      return EvaConstant.OK
    }
    this.dillSrc(config)
    this.dillFrame(config)
    const controllerId = EvaUtil.mixConfigCreate(this.playerEva.controllerId, JSON.stringify(config.jsonConfig));
    this.playerEva.controllerId = controllerId
    if (controllerId <= 0) {
      ELog.e(EvaMixAnimPlugin.TAG, 'mixConfigCreate failed')
      return EvaConstant.REPORT_ERROR_TYPE_CONFIG_PLUGIN_MIX
    }
    
    if (deviceInfo.sdkApiVersion >= 18) {
      await this.setResourceSync();
    }

    await this.setResourceSync();
    ELog.i(EvaMixAnimPlugin.TAG, `mixConfigCreate success controllerId=${controllerId}`)
    return EvaConstant.OK
  }

  /**
   * 处理源数据
   */
  private dillSrc(config: EvaAnimConfig): void {
    if (!config.effects || config.effects.length === 0) {
      return
    }

    this.srcMap = new EvaSrcMap(config.effects)
    ELog.i(EvaMixAnimPlugin.TAG, `dillSrc srcMap=${JSON.stringify(this.srcMap)}`)
  }

  /**
   * 处理帧数据
   */
  private dillFrame(config: EvaAnimConfig): void {
    if (!config.datas || config.datas.length === 0) {
      return
    }

    this.frameAll = new EvaFrameAll(config.datas)
    ELog.i(EvaMixAnimPlugin.TAG, `dillFrame frameAll=${this.frameAll}`)
  }

  /**
   * 渲染创建
   */
  onRenderCreate(): void {
    ELog.i(EvaMixAnimPlugin.TAG, 'onRenderCreate')
    if (!this.playerEva.configManager.config?.isMix) {
      return
    }
    ELog.i(EvaMixAnimPlugin.TAG, 'mix render init')
    EvaUtil.mixRenderCreate(this.playerEva.controllerId)
  }

  /**
   * 渲染处理
   */
  onRendering(frameIndex: number) {
    this.curFrameIndex = frameIndex
    EvaUtil.mixRendering(this.playerEva.controllerId, frameIndex);
  }

  /**
   * 解码通知
   */
  onDecoding(decodeIndex: number): void {
  }

  /**
   * 同步加载资源
   */
  async setResourceSync(): Promise<void> {
    if (this.srcMap && this.srcMap) {

    }
    const totalSrc = this.srcMap!!.map.size ?? 0
    ELog.i(EvaMixAnimPlugin.TAG, `load resource totalSrc = ${totalSrc}`)

    const loadPromises: Promise<void>[] = []

    this.srcMap?.map?.forEach((src: EvaSrc) => {
      if (src.srcType === EvaSrc.SrcType.IMG) {
        ELog.i(EvaMixAnimPlugin.TAG, `setResourceSync image ${src.srcId}`)
        const promise = new Promise<void>((resolve) => {
          this.resourceRequestEva?.setImage(new EvaResource(src), (pixelMap, fixType) => {
            let pixelMaps: image.PixelMap | null = pixelMap
            if (pixelMaps == null) {
              ELog.e(EvaMixAnimPlugin.TAG, `setResourceSync image ${src.srcId} bitmap return null`);
              src.bitmap = EvaBitmapUtil.createEmptyBitmap();
            } else {
              if (pixelMap != undefined) {
                pixelMap.clone().then((clonePixelMap: image.PixelMap) => {
                  src.bitmap = clonePixelMap
                  let scaleMode: string = src.scaleMode
                  switch (fixType) {
                    case EvaSrc.FitType.CENTER_FULL:
                      scaleMode = 'aspectFill'
                      break
                    case EvaSrc.FitType.CENTER_FIT:
                      scaleMode = 'aspectFit'
                      break
                    default:
                      scaleMode = 'scaleFill'
                      break
                  }

                  ELog.e(EvaMixAnimPlugin.TAG, `setResourceSync pixelmap is ok ${src.bitmap}`);
                  EvaUtil.setSrcPixelMap(this.playerEva.controllerId, src.srcId, src.bitmap, scaleMode)
                  ELog.i(EvaMixAnimPlugin.TAG, `setResourceSync image ${src.srcId} finish pixelMap is ${src.bitmap}`)
                  resolve()
                }).catch((error: BusinessError) => {
                  ELog.e(EvaMixAnimPlugin.TAG, `clone errorr ${error}`);
                })
              }
            }
          })
        })
        loadPromises.push(promise)
      } else if (src.srcType === EvaSrc.SrcType.TXT) {
        ELog.i(EvaMixAnimPlugin.TAG, `setResourceSync txt ${src.srcId}`)
        const promise = new Promise<void>((resolve) => {
          this.resourceRequestEva?.setText(new EvaResource(src), async (eva: EvaResource) => {
            src.txt = eva.text ?? ''
            src.textAlign = eva.textAlign ?? 'center'
            if (eva.textColor !== -1) {
              src.color = eva.textColor
            }
            if (eva.fontSize > 0) {
              src.fontSize = eva.fontSize
            }
            let pixmap = EvaBitmapUtil.createTextPixmap(src);
            EvaUtil.setSrcPixelMap(this.playerEva.controllerId, src.srcId, pixmap, src.scaleMode)
            ELog.i(EvaMixAnimPlugin.TAG, `setResourceSync text ${src.srcId} finish txt is ${src.textAlign}`)
            resolve()
          })
        })
        loadPromises.push(promise)
      }
    })
    await Promise.all(loadPromises)
  }

  /**
   * 释放资源
   */
  onRelease(): void {
    ELog.i(EvaMixAnimPlugin.TAG, 'onRelease')
    this.curFrameIndex = -1
    if (!this.playerEva.configManager.config?.isMix) {
      return
    }
    EvaUtil.mixRenderDestroy(this.playerEva.controllerId)
  }

  /**
   * 销毁
   */
  onDestroy(): void {
    ELog.i(EvaMixAnimPlugin.TAG, 'onDestroy');
    this.resourceRequestEva = null;
    this.evaResourceClickListener = null;
    this.srcMap = null;
    this.frameAll = null;
  }

  /**
   * 触摸事件处理
   */
  onDispatchTouchEvent(ev: TouchEvent): boolean {
    if (this.evaResourceClickListener == null) {
      return true;
    }
    const resource = this.mixTouch.onTouchEvent(ev);

    console.error(`resource=`, resource)

    let config = this.playerEva.configManager.config;

    console.error(`resource=`, JSON.stringify(config))

    if (this.playerEva.configManager.config?.isMix && resource !== null) {

      this.evaResourceClickListener?.onClick(resource);

      return true;

    } else {

      return true;

    }
  }
}