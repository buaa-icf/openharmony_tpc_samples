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
 * 菜单状态变化监听器接口
 * 用于监听菜单的打开和关闭状态变化
 */
export interface OnMenuStateChangeListener {
  /**
   * 菜单打开时触发
   * @param position 打开菜单的列表项位置
   */
  onMenuOpen(position: number): void;

  /**
   * 菜单关闭时触发
   * @param position 关闭菜单的列表项位置
   */
  onMenuClose(position: number): void;
}