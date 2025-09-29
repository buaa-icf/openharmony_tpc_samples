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

import { SwipeMenuItem } from './SwipeMenuItem';
import { common } from '@kit.AbilityKit';

@Observed
export class SwipeMenu {
  private items: SwipeMenuItem[] = [];
  private context?: common.UIAbilityContext | common.ApplicationContext;
  private viewType: number = 0;

  /**
   * 构造函数
   * @param context 可选的上下文对象
   */
  constructor(context?: common.UIAbilityContext | common.ApplicationContext) {
    this.context = context;
  }

  // 添加菜单项
  addMenuItem(item: SwipeMenuItem): void {
    this.items.push(item);
  }

  // 移除菜单项
  removeMenuItem(item: SwipeMenuItem): void {
    const index = this.items.indexOf(item);
    if (index > -1) {
      this.items.splice(index, 1);
    }
  }

  // 获取所有菜单项
  getMenuItems(): SwipeMenuItem[] {
    return this.items;
  }

  // 获取指定索引的菜单项
  getMenuItem(index: number): SwipeMenuItem | undefined {
    return this.items[index];
  }

  // 计算菜单总宽度
  getTotalWidth(): number {
    return this.items.reduce((sum, item) => sum + item.width, 0);
  }

  /**
   * 获取上下文对象
   * @returns 上下文对象
   */
  public getContext(): common.UIAbilityContext | common.ApplicationContext | undefined {
    return this.context;
  }

  /**
   * 获取视图类型
   * @returns 视图类型
   */
  public getViewType(): number {
    return this.viewType;
  }

  /**
   * 设置视图类型
   * @param viewType 视图类型
   */
  public setViewType(viewType: number): void {
    this.viewType = viewType;
  }
}