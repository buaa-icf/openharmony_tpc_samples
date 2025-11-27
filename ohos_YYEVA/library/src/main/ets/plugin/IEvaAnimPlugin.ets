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

import { EvaAnimConfig } from '../EvaAnimConfig'

/**
 * YYEVA 动画插件接口
 * 定义插件的基本功能
 */
export interface IEvaAnimPlugin {
  /**
   * 配置生成
   * @param config 动画配置
   * @return 状态码
   */
  onConfigCreate(config: EvaAnimConfig): Promise<number>

  /**
   * 渲染初始化
   */
  onRenderCreate(): void

  /**
   * 解码通知
   * @param decodeIndex 解码索引
   */
  onDecoding(decodeIndex: number): void

  /**
   * 每一帧渲染
   * @param frameIndex 帧索引
   */
  onRendering(frameIndex: number): void

  /**
   * 每次播放完毕
   */
  onRelease(): void

  /**
   * 销毁
   */
  onDestroy(): void

  /**
   * 触摸事件
   * @param event 触摸事件
   * @return false 不拦截 true 拦截
   */
  onDispatchTouchEvent(event: TouchEvent): boolean
}