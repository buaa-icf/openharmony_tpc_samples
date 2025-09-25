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

import { SwipeMenu } from './SwipeMenu';

/**
 * 菜单创建器接口
 */
export interface SwipeMenuCreator {
  /**
   * 创建菜单的方法
   * @param menu 要构建的菜单对象
   * @param item 当前数据项（可选，用于支持多视图类型）
   * @param position 当前位置（可选，用于支持多视图类型）
   */
  create(menu: SwipeMenu, item?: Object, position?: number): void;
}

class DefaultMenuCreatorImpl implements SwipeMenuCreator {
  create(menu: SwipeMenu): void {
    // 默认空实现
  }
}

/**
 * 默认菜单创建器实例
 */
export const DefaultMenuCreator = new DefaultMenuCreatorImpl();