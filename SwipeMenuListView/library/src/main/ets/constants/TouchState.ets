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
 * 触摸状态常量
 */
export class TouchState {
  /**
   * 无触摸状态
   */
  static readonly TOUCH_STATE_NONE: number = 0;

  /**
   * 正在滑动状态
   */
  static readonly TOUCH_STATE_SLIDING: number = 1;

  /**
   * 触摸按下但未开始滑动
   */
  static readonly TOUCH_STATE_DOWN: number = 2;

  /**
   * 滑动完成状态
   */
  static readonly TOUCH_STATE_DONE: number = 3;
}