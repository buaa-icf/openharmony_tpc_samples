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

import { SwipeMenu } from '../model/SwipeMenu';

/**
 * 菜单项点击监听器接口
 * 用于处理菜单项的点击事件
 */
export interface OnMenuItemClickListener {
  /**
   * 菜单项被点击时触发
   * @param position 列表项的位置
   * @param menu 完整的菜单对象，包含所有菜单项信息
   * @param menuIndex 被点击的菜单项索引
   * @returns boolean 返回true表示事件已处理，菜单不会自动关闭；返回false或undefined表示菜单会自动关闭
   */
  onMenuItemClick(position: number, menu: SwipeMenu, menuIndex: number): boolean | void;
}