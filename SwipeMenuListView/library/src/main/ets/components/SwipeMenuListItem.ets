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

import { SwipeMenuItemLayout } from './SwipeMenuItemLayout';
import { SwipeMenu } from '../model/SwipeMenu';
import { SwipeMenuCreator, DefaultMenuCreator } from '../model/SwipeMenuCreator';
import { OnSwipeListener } from '../interfaces/OnSwipeListener';
import { OnMenuStateChangeListener } from '../interfaces/OnMenuStateChangeListener';
import { OnMenuItemClickListener } from '../interfaces/OnMenuItemClickListener';
import { OnAnimationStateChangeListener } from '../interfaces/OnAnimationStateChangeListener';
import { OnItemLongPressListener } from '../interfaces/OnItemLongPressListener';
import { SwipeDirection } from '../constants/SwipeDirection';
import { TouchConfig } from '../model/TouchConfig';
import { AnimationConfig } from '../model/AnimationConfig';
import { logger } from '../utils/Logger';

@Builder function DefaultItemBuilder(item: Object, _index: number) {}

@Component
export struct SwipeMenuListItem {

  @Prop @Watch('onItemChanged') item: Object = new Object();
  @Prop @Watch('onIndexChanged') index: number = -1;
  menuCreator: SwipeMenuCreator = DefaultMenuCreator;
  onMenuItemClick?: OnMenuItemClickListener;
  onSwipeListener?: OnSwipeListener;
  onMenuStateChangeListener?: OnMenuStateChangeListener;
  onAnimationStateChangeListener?: OnAnimationStateChangeListener;
  onItemLongPress?: OnItemLongPressListener;
  swipeDirection: number = SwipeDirection.DEFAULT;
  @ObjectLink touchConfig: TouchConfig;
  @ObjectLink openAnimationConfig: AnimationConfig;
  @ObjectLink closeAnimationConfig: AnimationConfig;
  dragFollowAnimation: boolean = true;
  enableSpringBack: boolean = true;
  @BuilderParam itemBuilder: (item: Object, index: number) => void = DefaultItemBuilder;
  getSwipeEnabled?: (position: number) => boolean;

  @State private menu: SwipeMenu = new SwipeMenu();

  aboutToAppear() {
    logger.debug(`SwipeMenuListItem-${this.index} initializing with close animation: ${this.closeAnimationConfig.interpolator}, ${this.closeAnimationConfig.duration}ms`);
    this.createMenu();
  }

  aboutToReuse(params: Record<string, Object>) {
    logger.debug(`SwipeMenuListItem-${this.index} reusing, recreating menu`);
    this.createMenu();
  }

  // 监听item变化 - 重新创建菜单以确保菜单项正确更新
  onItemChanged() {
    logger.debug(`SwipeMenuListItem-${this.index} item changed, recreating menu`);
    this.createMenu();
  }

  // 监听index变化 - 重新创建菜单以确保菜单项正确更新
  onIndexChanged() {
    logger.debug(`SwipeMenuListItem-${this.index} index changed, recreating menu`);
    this.createMenu();
  }

  private createMenu() {
    // 创建一个全新的菜单对象，确保引用发生变化
    let newMenu = new SwipeMenu();
    this.menuCreator.create(newMenu, this.item, this.index);
    
    this.menu = newMenu;
    console.log(`=== SwipeMenuListItem-${this.index} 菜单已创建，包含 ${this.menu.getMenuItems().length} 个菜单项 ===`);
    
    // 输出菜单项详情用于调试
    const menuItems = this.menu.getMenuItems();
    menuItems.forEach((item, index) => {
      console.log(`菜单项 ${index}: ID=${item.getId()}, 标题=${item.getTitle()}`);
    });
    
    logger.debug(`SwipeMenuListItem-${this.index} menu created with ${this.menu.getMenuItems().length} items`);
  }

  build() {
    ListItem() {
      SwipeMenuItemLayout({
        itemPosition: this.index,
        menu: this.menu,
        item: this.item,
        onMenuItemClick: this.onMenuItemClick,
        onSwipeListener: this.onSwipeListener,
        onMenuStateChangeListener: this.onMenuStateChangeListener,
        onAnimationStateChangeListener: this.onAnimationStateChangeListener,
        onItemLongPress: this.onItemLongPress,
        swipeDirection: this.swipeDirection,
        touchConfig: this.touchConfig,
        openAnimationConfig: this.openAnimationConfig,
        closeAnimationConfig: this.closeAnimationConfig,
        dragFollowAnimation: this.dragFollowAnimation,
        enableSpringBack: this.enableSpringBack,
        getSwipeEnabled: this.getSwipeEnabled,
        content: () => {
          this.itemBuilder(this.item, this.index)
        }
      })
    }
  }
}