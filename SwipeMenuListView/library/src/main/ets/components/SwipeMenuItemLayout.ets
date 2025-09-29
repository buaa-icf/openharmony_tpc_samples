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

import { SwipeStateController, SwipeMenuItemController } from '../utils/SwipeStateController';
import { SwipeMenu } from '../model/SwipeMenu';
import { SwipeMenuItem } from '../model/SwipeMenuItem';
import { OnSwipeListener } from '../interfaces/OnSwipeListener';
import { OnMenuStateChangeListener } from '../interfaces/OnMenuStateChangeListener';
import { OnMenuItemClickListener } from '../interfaces/OnMenuItemClickListener';
import { OnAnimationStateChangeListener } from '../interfaces/OnAnimationStateChangeListener';
import { OnItemLongPressListener } from '../interfaces/OnItemLongPressListener';
import { SwipeDirection } from '../constants/SwipeDirection';
import { TouchState } from '../constants/TouchState';
import { TouchConfig } from '../model/TouchConfig';
import { AnimationConfig, AnimationType } from '../model/AnimationConfig';
import { logger } from '../utils/Logger';

/**
 * SwipeMenuItemController 接口的实现类
 */
class ItemControllerImpl implements SwipeMenuItemController {
  private layout: SwipeMenuItemLayout;

  constructor(layout: SwipeMenuItemLayout) {
    this.layout = layout;
  }

  openMenu(): void {
    this.layout.smoothOpenMenu();
  }

  closeMenu(): void {
    this.layout.smoothCloseMenu();
  }

  getPosition(): number {
    return this.layout.itemPosition;
  }

  updateTouchConfig(_config: TouchConfig): void {
    // 触摸配置更新由@ObjectLink自动处理，这里可以添加额外的处理逻辑
    logger.debug(`TouchConfig update received for position ${this.layout.itemPosition}`);
  }
}


@Builder function EmptyBuilder() {}

@Component
export struct SwipeMenuItemLayout {
  @Prop itemPosition: number = -1;
  @ObjectLink menu: SwipeMenu;
  @Prop item: Object = new Object();
  uiContext = this.getUIContext();
  hostContext = this.uiContext.getHostContext();
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
  @BuilderParam content: () => void = EmptyBuilder;
  getSwipeEnabled?: (position: number) => boolean;

  // --- 私有状态 ---
  @State private offsetX: number = 0;
  private lastOffsetX: number = 0;
  @State private isMenuOpen: boolean = false;
  private menuTotalWidth: number = 0;
  @State private touchState: number = TouchState.TOUCH_STATE_NONE;

  private startTouchTime: number = 0;
  private startTouchX: number = 0;
  private startTouchY: number = 0;
  private isDragging: boolean = false;
  private hasCalledSwipeStart: boolean = false;
  @Consume('swipeStateController') private stateController: SwipeStateController;

  // 动画状态管理
  @State private isAnimating: boolean = false;
  private animationCallbacks: Map<AnimationType, (() => void)[]> = new Map();
  private lastAnimationType: AnimationType = AnimationType.MENU_CLOSE;

  // SwipeMenuItemController 接口的内部控制器
  private itemController: SwipeMenuItemController = new ItemControllerImpl(this);

  // 监听全局状态，如果其他item打开，则关闭自己
  aboutToUpdate(_changedProps: Object) {
    const currentlyOpen = this.stateController.get();
    if (this.isMenuOpen && currentlyOpen !== this.itemPosition) {
      logger.debug(`StateWatch - Global state changed: ${currentlyOpen} opened, current item ${this.itemPosition} needs to close`);
      this.smoothCloseMenu();
    }
  }

  // aboutToAppear 是执行初始化逻辑的正确位置
  aboutToAppear() {
    logger.debug(`SwipeMenuItemLayout-${this.itemPosition} initializing with close animation: ${this.closeAnimationConfig.interpolator}, ${this.closeAnimationConfig.duration}ms`);
    
    // 根据传入的 menu 对象，动态计算菜单总宽度
    this.updateMenuWidth();

    // 初始化动画回调映射
    this.initAnimationCallbacks();

    // 注册到状态控制器
    this.stateController.registerItemController(this.itemPosition, this.itemController);
  }

  // 更新菜单宽度
  private updateMenuWidth() {
    const newWidth = this.menu.getTotalWidth();
    if (this.menuTotalWidth !== newWidth) {
      this.menuTotalWidth = newWidth;
      logger.debug(`SwipeMenuItemLayout-${this.itemPosition} menu width updated to ${this.menuTotalWidth}`);
    }
  }

  aboutToDisappear() {
    // 从状态控制器注销
    this.stateController.unregisterItemController(this.itemPosition);
  }

  /**
   * 初始化动画回调映射
   */
  private initAnimationCallbacks(): void {
    this.animationCallbacks.set(AnimationType.MENU_OPEN, []);
    this.animationCallbacks.set(AnimationType.MENU_CLOSE, []);
    this.animationCallbacks.set(AnimationType.DRAG_FOLLOW, []);
    this.animationCallbacks.set(AnimationType.SPRING_BACK, []);
  }

  propertyHasChanged(newValue: number): void {
    if (newValue !== this.itemPosition && this.isMenuOpen) {
      this.smoothCloseMenu();
    }
  }

  /**
   * 设置触摸状态
   */
  private setTouchState(state: number): void {
    if (this.touchState !== state) {
      this.touchState = state;
    }
  }

  /**
   * 添加动画监听器
   */
  public addAnimationListener(type: AnimationType, callback: () => void): void {
    const callbacks = this.animationCallbacks.get(type);
    if (callbacks) {
      callbacks.push(callback);
    }
  }

  /**
   * 移除动画监听器
   */
  public removeAnimationListener(type: AnimationType, callback: () => void): void {
    const callbacks = this.animationCallbacks.get(type);
    if (callbacks) {
      const index = callbacks.indexOf(callback);
      if (index > -1) {
        callbacks.splice(index, 1);
      }
    }
  }

  /**
   * 触发动画回调
   */
  private triggerAnimationCallbacks(type: AnimationType): void {
    const callbacks = this.animationCallbacks.get(type);
    if (callbacks) {
      callbacks.forEach(callback => {
        try {
          callback();
        } catch (error) {
          logger.error(`Animation callback execution error: ${error}`);
        }
      });
    }
  }

  /**
   * 设置动画状态
   */
  private setAnimationState(isAnimating: boolean, animationType?: AnimationType): void {
    const wasAnimating = this.isAnimating;
    this.isAnimating = isAnimating;

    if (animationType) {
      this.lastAnimationType = animationType;
      logger.debug(`Animation state change: ${animationType}, in progress: ${isAnimating}`);

      if (this.onAnimationStateChangeListener) {
        if (isAnimating && !wasAnimating) {
          this.onAnimationStateChangeListener.onAnimationStart?.(this.itemPosition, animationType);
        } else if (!isAnimating && wasAnimating) {
          this.onAnimationStateChangeListener.onAnimationEnd?.(this.itemPosition, animationType);
        }
      }
    }
  }

  /**
   * 检查是否应该开始滑动
   */
  private shouldStartSwipe(deltaX: number, deltaY: number): boolean {
    if (this.getSwipeEnabled && !this.getSwipeEnabled(this.itemPosition)) {
      logger.debug(`TouchEvent - Swipe disabled for position ${this.itemPosition}`);
      return false;
    }

    const absDeltaX = Math.abs(deltaX);
    const absDeltaY = Math.abs(deltaY);

    if (absDeltaX < this.touchConfig.minSwipeDistance) {
      return false;
    }

    if (absDeltaX <= absDeltaY) {
      return false;
    }

    if (this.isMenuOpen) {
      return true;
    } else {
      if (this.swipeDirection === SwipeDirection.DIRECTION_LEFT) {
        return deltaX < 0;
      } else {
        return deltaX > 0;
      }
    }
  }

  /**
   * 检查触摸超时
   */
  private isTimeoutReached(): boolean {
    const touchDuration = Date.now() - this.startTouchTime;
    return touchDuration > this.touchConfig.touchTimeout;
  }

  public smoothOpenMenu() {
    if (this.isAnimating) {
      return;
    }
    this.stateController.smoothCloseMenu();
    this.stateController.set(this.itemPosition);
    const wasOpen = this.isMenuOpen;

    if (!this.openAnimationConfig.enabled) {
      this.offsetX = this.swipeDirection === SwipeDirection.DIRECTION_LEFT ? -this.menuTotalWidth : this.menuTotalWidth;
      this.isMenuOpen = true;
      if (!wasOpen && this.onMenuStateChangeListener) {
        this.onMenuStateChangeListener.onMenuOpen(this.itemPosition);
      }
      return;
    }

    this.setAnimationState(true, AnimationType.MENU_OPEN);
    this.triggerAnimationCallbacks(AnimationType.MENU_OPEN);

    const animOptions = this.openAnimationConfig.toAnimateToOptions();
    animOptions.onFinish = () => {
      this.setAnimationState(false, AnimationType.MENU_OPEN);
    };

    this.uiContext.animateTo(animOptions, () => {
      this.offsetX = this.swipeDirection === SwipeDirection.DIRECTION_LEFT ? -this.menuTotalWidth : this.menuTotalWidth;
    });

    this.isMenuOpen = true;

    if (!wasOpen && this.onMenuStateChangeListener) {
      this.onMenuStateChangeListener.onMenuOpen(this.itemPosition);
    }
  }

  public smoothCloseMenu() {
    if (this.isAnimating && this.lastAnimationType === AnimationType.MENU_CLOSE) {
      return;
    }

    const wasOpen = this.isMenuOpen;
    if (this.isMenuOpen && this.stateController.get() === this.itemPosition) {
      this.stateController.set(-1);
    }

    if (!this.closeAnimationConfig.enabled) {
      this.offsetX = 0;
      this.isMenuOpen = false;
      if (wasOpen && this.onMenuStateChangeListener) {
        this.onMenuStateChangeListener.onMenuClose(this.itemPosition);
      }
      return;
    }

    this.setAnimationState(true, AnimationType.MENU_CLOSE);
    this.triggerAnimationCallbacks(AnimationType.MENU_CLOSE);

    const animOptions = this.closeAnimationConfig.toAnimateToOptions();
    animOptions.onFinish = () => {
      this.setAnimationState(false, AnimationType.MENU_CLOSE);
    };

    this.uiContext.animateTo(animOptions, () => {
      this.offsetX = 0;
    });

    this.isMenuOpen = false;

    if (wasOpen && this.onMenuStateChangeListener) {
      this.onMenuStateChangeListener.onMenuClose(this.itemPosition);
    }
  }

  /**
   * 弹簧回弹到关闭位置
   */
  private springBackToClose() {
    if (this.isAnimating && this.lastAnimationType === AnimationType.SPRING_BACK) {
      return;
    }

    this.setAnimationState(true, AnimationType.SPRING_BACK);
    this.triggerAnimationCallbacks(AnimationType.SPRING_BACK);

    const springAnimOptions = this.closeAnimationConfig.toAnimateToOptions();
    springAnimOptions.onFinish = () => {
      this.setAnimationState(false, AnimationType.SPRING_BACK);
    };

    this.uiContext.animateTo(springAnimOptions, () => {
      this.offsetX = 0;
    });
  }

  @Builder
  private MenuComponent() {
    ForEach(this.menu.getMenuItems(), (menuItem: SwipeMenuItem, index: number) => {
      Column() {
        if (menuItem.icon) {
          Image(menuItem.icon).width(24).height(24).margin({ bottom: 2 })
        }
        if (menuItem.title) {
          Text(menuItem.title)
            .fontColor(menuItem.titleColor)
            .fontSize(menuItem.titleSize)
        }
      }
      .width(menuItem.width)
      .height('100%')
      .backgroundColor(menuItem.background)
      .justifyContent(FlexAlign.Center)
      .onClick(() => {
        let shouldKeepOpen = false;
        if (this.onMenuItemClick) {
          const result = this.onMenuItemClick.onMenuItemClick(this.itemPosition, this.menu, index);
          shouldKeepOpen = result === true;
        }
        if (!shouldKeepOpen) {
          this.smoothCloseMenu();
        }
      })
    }, (menuItem: SwipeMenuItem, index: number) => {
      // 为ForEach提供键生成函数，确保能正确跟踪菜单项变化
      return `${menuItem.getId()}_${index}`;
    })
  }

  @Builder
  private ContentComponent() {
    Row() {
      this.content()
    }
    .width('100%')
    .height('100%')
    .backgroundColor(Color.White)
    .onClick(() => {
      // 点击列表项内容时，如果菜单是打开状态，则自动关闭菜单
      if (this.isMenuOpen) {
        logger.debug(`ContentClick - Menu is open at position ${this.itemPosition}, closing menu`);
        this.smoothCloseMenu();
      }
    })
    .gesture(
      LongPressGesture({ repeat: false })
        .onAction(() => {
          if (this.onItemLongPress && this.item) {
            this.onItemLongPress.onItemLongPress(this.itemPosition, this.item);
          }
        })
    )
  }


  build() {
    Stack() {
      Row() {
        if (this.swipeDirection === SwipeDirection.DIRECTION_RIGHT) {
          this.MenuComponent()
          this.ContentComponent()
        } else {
          this.ContentComponent()
          this.MenuComponent()
        }
      }
      .translate({
        x: this.swipeDirection === SwipeDirection.DIRECTION_RIGHT
          ? this.offsetX - this.menuTotalWidth
          : this.offsetX
      })
    }
    .clip(true)
    .height(80)
    .width('100%')
    .border({ width: 1, color: '#f0f0f0' })
    .gesture(
      PanGesture({ direction: PanDirection.Horizontal, distance: this.touchConfig.minSwipeDistance })
        .onActionStart((event: GestureEvent) => {
          this.lastOffsetX = this.offsetX;
          this.startTouchTime = Date.now();
          this.startTouchX = event.offsetX;
          this.startTouchY = event.offsetY || 0;
          this.isDragging = false;
          this.hasCalledSwipeStart = false;
          this.setTouchState(TouchState.TOUCH_STATE_DOWN);
        })
        .onActionUpdate((event: GestureEvent) => {
          const deltaX = event.offsetX - this.startTouchX;
          const deltaY = (event.offsetY || 0) - this.startTouchY;

          if (this.touchState === TouchState.TOUCH_STATE_DOWN) {
            if (this.shouldStartSwipe(deltaX, deltaY)) {
              this.setTouchState(TouchState.TOUCH_STATE_SLIDING);
              this.isDragging = true;
              if (!this.hasCalledSwipeStart && this.onSwipeListener) {
                this.onSwipeListener.onSwipeStart(this.itemPosition);
                this.hasCalledSwipeStart = true;
              }
            } else {
              if (this.isTimeoutReached()) {
                this.setTouchState(TouchState.TOUCH_STATE_NONE);
                return;
              }
            }
          }

          if (this.touchState === TouchState.TOUCH_STATE_SLIDING) {
            let newOffsetX = this.lastOffsetX + deltaX;

            if (this.swipeDirection === SwipeDirection.DIRECTION_LEFT) {
              if (newOffsetX > 0) newOffsetX = 0;
              if (newOffsetX < -this.menuTotalWidth) newOffsetX = -this.menuTotalWidth;
            } else {
              if (newOffsetX < 0) newOffsetX = 0;
              if (newOffsetX > this.menuTotalWidth) newOffsetX = this.menuTotalWidth;
            }

            if (this.dragFollowAnimation) {
              this.uiContext.animateTo({ duration: 16, curve: Curve.Linear }, () => {
                this.offsetX = newOffsetX;
              });
              if (this.onAnimationStateChangeListener?.onDragProgress) {
                const progress = Math.abs(newOffsetX) / this.menuTotalWidth;
                this.onAnimationStateChangeListener.onDragProgress(this.itemPosition, progress, newOffsetX);
              }
            } else {
              this.offsetX = newOffsetX;
            }
          }
        })
        .onActionEnd((event: GestureEvent) => {
          if (this.touchState === TouchState.TOUCH_STATE_SLIDING && this.isDragging) {
            const threshold = this.menuTotalWidth * this.touchConfig.menuOpenThreshold;
            const gestureVelocity = event.velocityX;
            const isFling = (this.swipeDirection === SwipeDirection.DIRECTION_LEFT && gestureVelocity < -this.touchConfig.minFlingVelocity) ||
              (this.swipeDirection !== SwipeDirection.DIRECTION_LEFT && gestureVelocity > this.touchConfig.minFlingVelocity);
            const isDraggedFar = Math.abs(this.offsetX) >= threshold;
            const shouldOpen = isFling || isDraggedFar;

            if (shouldOpen) {
              this.smoothOpenMenu();
            } else {
              if (this.enableSpringBack && Math.abs(this.offsetX) > this.touchConfig.minSwipeDistance) {
                this.springBackToClose();
              } else {
                this.smoothCloseMenu();
              }
            }
            if (this.hasCalledSwipeStart && this.onSwipeListener) {
              this.onSwipeListener.onSwipeEnd(this.itemPosition);
            }
          } else if (this.touchState === TouchState.TOUCH_STATE_DOWN && !this.isDragging) {
            // 处理点击事件：如果菜单打开且没有发生拖拽，则关闭菜单
            if (this.isMenuOpen) {
              const deltaX = event.offsetX - this.startTouchX;
              const deltaY = (event.offsetY || 0) - this.startTouchY;
              const touchDistance = Math.sqrt(deltaX * deltaX + deltaY * deltaY);
              
              // 只有在触摸距离很小的情况下才认为是点击（而不是滑动）
              if (touchDistance < this.touchConfig.minSwipeDistance) {
                logger.debug(`Click detected on open menu at position ${this.itemPosition}, closing menu`);
                this.smoothCloseMenu();
              }
            }
          }
          this.setTouchState(TouchState.TOUCH_STATE_DONE);
          setTimeout(() => {
            this.setTouchState(TouchState.TOUCH_STATE_NONE);
            this.isDragging = false;
            this.hasCalledSwipeStart = false;
          }, 100);
        })
        .onActionCancel(() => {
          if (this.touchState === TouchState.TOUCH_STATE_SLIDING || this.isMenuOpen) {
            this.smoothCloseMenu();
          }
          this.setTouchState(TouchState.TOUCH_STATE_DONE);
          setTimeout(() => {
            this.setTouchState(TouchState.TOUCH_STATE_NONE);
            this.isDragging = false;
            this.hasCalledSwipeStart = false;
          }, 100);
        })
    )
  }
}