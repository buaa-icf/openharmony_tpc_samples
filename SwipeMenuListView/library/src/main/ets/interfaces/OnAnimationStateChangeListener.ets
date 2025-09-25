/**
 * Copyright (C) 2025 Huawei Device Co., Ltd.
 *
 * This software is distributed under a license. The full license
 * agreement can be found in the file LICENSE in this distribution.
 * This software may not be copied, modified, sold or distributed
 * other than expressed in the named license agreement.
 *
 * This software is distributed without any warranty.
 */

import { AnimationType } from '../model/AnimationConfig';

/**
 * 动画状态变化监听器
 * 用于监听滑动菜单的动画状态变化
 */
export interface OnAnimationStateChangeListener {
  /**
   * 动画开始时调用
   * @param itemPosition 列表项位置
   * @param animationType 动画类型
   */
  onAnimationStart?(itemPosition: number, animationType: AnimationType): void;

  /**
   * 动画结束时调用
   * @param itemPosition 列表项位置  
   * @param animationType 动画类型
   */
  onAnimationEnd?(itemPosition: number, animationType: AnimationType): void;

  /**
   * 动画取消时调用
   * @param itemPosition 列表项位置
   * @param animationType 动画类型
   */
  onAnimationCancel?(itemPosition: number, animationType: AnimationType): void;

  /**
   * 动画重复时调用（用于循环动画）
   * @param itemPosition 列表项位置
   * @param animationType 动画类型
   * @param iteration 当前迭代次数
   */
  onAnimationRepeat?(itemPosition: number, animationType: AnimationType, iteration: number): void;

  /**
   * 拖拽跟随动画进度更新时调用
   * @param itemPosition 列表项位置
   * @param progress 动画进度 (0.0-1.0)
   * @param offsetX 当前偏移量
   */
  onDragProgress?(itemPosition: number, progress: number, offsetX: number): void;
}