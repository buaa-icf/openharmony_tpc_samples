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
 * 滑动方向常量
 * 定义菜单从哪个方向滑出
 */
export class SwipeDirection {
  /**
   * 从左向右滑动（菜单在右侧）
   */
  static readonly DIRECTION_LEFT: number = 1;
  
  /**
   * 从右向左滑动（菜单在左侧）
   */
  static readonly DIRECTION_RIGHT: number = -1;
  
  /**
   * 默认方向：从右向左滑动
   */
  static readonly DEFAULT: number = SwipeDirection.DIRECTION_LEFT;
}