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

import { SwipeStateController } from '../utils/SwipeStateController';
import { SwipeMenuListItem } from './SwipeMenuListItem';
import { SwipeMenuCreator, DefaultMenuCreator } from '../model/SwipeMenuCreator';
import { OnSwipeListener } from '../interfaces/OnSwipeListener';
import { OnMenuStateChangeListener } from '../interfaces/OnMenuStateChangeListener';
import { OnMenuItemClickListener } from '../interfaces/OnMenuItemClickListener';
import { OnAnimationStateChangeListener } from '../interfaces/OnAnimationStateChangeListener';
import { OnItemLongPressListener } from '../interfaces/OnItemLongPressListener';
import { SwipeDirection } from '../constants/SwipeDirection';
import { TouchConfig } from '../model/TouchConfig';
import { AnimationConfig, InterpolatorType } from '../model/AnimationConfig';
import { curves } from '@kit.ArkUI';
import { common, bundleManager } from '@kit.AbilityKit';
import { logger } from '../utils/Logger';

@Builder function DefaultItemBuilder(_item: Object, _index: number) {}

@Component
export struct SwipeMenuList {
  @Prop data: Array<Object> = [];
  menuCreator: SwipeMenuCreator = DefaultMenuCreator;
  @BuilderParam itemBuilder: (item: Object, index: number) => void = DefaultItemBuilder;
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
  keyGenerator: (item: Object) => string = (item: Object) => JSON.stringify(item);
  getSwipeEnabled?: (position: number) => boolean;
  uiContext = this.getUIContext();
  hostContext = this.uiContext.getHostContext();

  @Consume('swipeStateController') stateController: SwipeStateController;
  private context = getContext(this) as common.UIAbilityContext;

  /**
   * 设置菜单打开时的插值器
   * @param interpolator 插值器类型
   */
  setOpenInterpolator(interpolator: InterpolatorType): void {
    this.openAnimationConfig.setInterpolator(interpolator);
  }

  /**
   * 设置菜单关闭时的插值器
   * @param interpolator 插值器类型
   */
  setCloseInterpolator(interpolator: InterpolatorType): void {
    this.closeAnimationConfig.setInterpolator(interpolator);
  }

  /**
   * 获取菜单打开时的插值器
   */
  getOpenInterpolator(): InterpolatorType {
    return this.openAnimationConfig.interpolator;
  }

  /**
   * 获取菜单关闭时的插值器
   */
  getCloseInterpolator(): InterpolatorType {
    return this.closeAnimationConfig.interpolator;
  }

  /**
   * 设置菜单打开时的自定义动画曲线
   * @param curve 自定义曲线
   */
  setOpenCurve(curve: curves.ICurve): void {
    this.openAnimationConfig.setCustomCurve(curve);
  }

  /**
   * 设置菜单关闭时的自定义动画曲线
   * @param curve 自定义曲线
   */
  setCloseCurve(curve: curves.ICurve): void {
    this.closeAnimationConfig.setCustomCurve(curve);
  }

  /**
   * 设置动画持续时间
   * @param openDuration 打开动画持续时间
   * @param closeDuration 关闭动画持续时间
   */
  setAnimationDuration(openDuration: number, closeDuration?: number): void {
    this.openAnimationConfig.setDuration(openDuration);
    this.closeAnimationConfig.setDuration(closeDuration || openDuration);
  }

  /**
   * 获取上下文对象
   * @returns UIAbility的上下文对象
   */
  public getContext(): common.UIAbilityContext {
    return this.context;
  }

  /**
   * 获取应用信息
   * @returns 当前应用的信息
   */
  public getApplicationInfo(): bundleManager.ApplicationInfo {
    return this.context.applicationInfo;
  }

  /**
   * 获取应用上下文
   * @returns 应用级上下文对象
   */
  public getApplicationContext(): common.ApplicationContext {
    return this.context.getApplicationContext();
  }

  build() {
    List({ space: 1 }) {
      ForEach(this.data, (item: Object, index: number) => {
        SwipeMenuListItem({
          item: item,
          index: index,
          menuCreator: this.menuCreator,
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
          itemBuilder: this.itemBuilder,
          getSwipeEnabled: this.getSwipeEnabled
        })
      }, (item: Object) => this.keyGenerator(item))
    }
    .onScrollStart(() => {
      logger.debug("List scroll started, attempting to close menu");
      this.stateController.smoothCloseMenu();
    })
    .onTouch((event: TouchEvent) => {
      // 全局触摸事件处理：当触摸开始时，如果有菜单打开，则关闭菜单
      if (event.type === TouchType.Down) {
        const currentOpenPosition = this.stateController.get();
        if (currentOpenPosition !== -1) {
          logger.debug(`Global touch detected, closing menu at position ${currentOpenPosition}`);
          this.stateController.smoothCloseMenu();
        }
      }
    })
    .width('100%').backgroundColor($r('sys.color.comp_background_focus'))
    .height('100%')
  }
}