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

/**
 * 滑动监听器接口
 * 用于监听列表项滑动的开始和结束事件
 */
export interface OnSwipeListener {
  /**
   * 滑动开始时触发
   * @param position 正在滑动的列表项位置
   */
  onSwipeStart(position: number): void;

  /**
   * 滑动结束时触发
   * @param position 滑动结束的列表项位置
   */
  onSwipeEnd(position: number): void;
}