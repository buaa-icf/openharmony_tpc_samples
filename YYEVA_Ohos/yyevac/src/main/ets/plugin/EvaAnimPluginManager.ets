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
import { EvaMixAnimPlugin } from '../mix/EvaMixAnimPlugin'
import { ELog } from '../util/ELog'
import { IEvaAnimPlugin } from './IEvaAnimPlugin'

/**
 * YYEVA 动画插件管理器
 * 负责管理所有动画插件
 */
export class EvaAnimPluginManager {
  private static readonly TAG = `${EvaConstant.TAG}.AnimPluginManager`
  private static readonly DIFF_TIMES = 4

  private mixAnimPlugin: EvaMixAnimPlugin
  private plugins: IEvaAnimPlugin[]
  private frameIndex: number = 0
  private decodeIndex: number = 0
  private frameDiffTimes: number = 0

  playerEva: EvaAnimPlayer;

  constructor(playerEva: EvaAnimPlayer) {
    this.playerEva = playerEva;
    this.mixAnimPlugin = new EvaMixAnimPlugin(playerEva)
    this.plugins = [this.mixAnimPlugin]
  }

  /**
   * 获取混合动画插件
   */
  getMixAnimPlugin(): EvaMixAnimPlugin | null {
    return this.mixAnimPlugin
  }

  /**
   * 配置创建
   */
  async onConfigCreate(config: EvaAnimConfig): Promise<number> {
    ELog.i(EvaAnimPluginManager.TAG, 'onConfigCreateEva')
    for (const plugin of this.plugins) {
      const result = await plugin.onConfigCreate(config)
      if (result !== EvaConstant.OK) {
        return result
      }
    }
    return EvaConstant.OK
  }

  /**
   * 渲染创建
   */
  onRenderCreate(): void {
    ELog.i(EvaAnimPluginManager.TAG, 'onRenderCreate')
    this.frameIndex = 0
    this.decodeIndex = 0
    for (const plugin of this.plugins) {
      plugin.onRenderCreate()
    }
  }

  /**
   * 解码通知
   */
  onDecoding(decodeIndex: number): void {
    ELog.i(EvaAnimPluginManager.TAG, `onDecoding decodeIndex=${decodeIndex}`)
    this.decodeIndex = decodeIndex
    for (const plugin of this.plugins) {
      plugin.onDecoding(decodeIndex)
    }
  }

  /**
   * 开始循环调用
   */
  onLoopStart(): void {
    ELog.i(EvaAnimPluginManager.TAG, 'onLoopStart')
    this.frameIndex = 0
    this.decodeIndex = 0
  }

  /**
   * 渲染处理
   */
  onRendering(): void {
    if (!this.playerEva.configManager.config?.isMix) {
      return
    }
    
    if (this.decodeIndex > this.frameIndex + 1 || this.frameDiffTimes >= EvaAnimPluginManager.DIFF_TIMES) {
      ELog.i(EvaAnimPluginManager.TAG, `jump frameIndex=${this.frameIndex}, decodeIndex=${this.decodeIndex}, frameDiffTimes=${this.frameDiffTimes}`)
      this.frameIndex = this.decodeIndex
    }
    
    if (this.decodeIndex !== this.frameIndex) {
      this.frameDiffTimes++
    } else {
      this.frameDiffTimes = 0
    }
    
    ELog.d(EvaAnimPluginManager.TAG, `onRendering frameIndex=${this.frameIndex}`)
    for (const plugin of this.plugins) {
      plugin.onRendering(this.frameIndex)
    }
    this.frameIndex++
  }

  /**
   * 释放资源
   */
  onRelease(): void {
    ELog.i(EvaAnimPluginManager.TAG, 'onRelease')
    for (const plugin of this.plugins) {
      plugin.onRelease()
    }
  }

  /**
   * 销毁
   */
  onDestroy(): void {
    ELog.i(EvaAnimPluginManager.TAG, 'onDestroy')
    for (const plugin of this.plugins) {
      plugin.onDestroy()
    }
  }

  /**
   * 触摸事件分发
   */
  onDispatchTouchEvent(event: TouchEvent): boolean {
    for (const plugin of this.plugins) {
      if (plugin.onDispatchTouchEvent(event)) {
        return true
      }
    }
    return false
  }

}