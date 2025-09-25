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
 * 长按事件监听器接口
 */
export interface OnItemLongPressListener {
  /**
   * 项目被长按时触发
   * @param position 被长按项目的位置
   * @param item 被长按的数据项
   * @returns 如果返回true，表示事件已被处理，阻止其他长按处理；返回false或void则继续默认处理
   */
  onItemLongPress(position: number, item: Object): boolean | void;
}