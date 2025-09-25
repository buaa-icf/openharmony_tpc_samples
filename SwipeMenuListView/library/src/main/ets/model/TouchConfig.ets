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
 * 触摸事件配置类
 */
@Observed
export class TouchConfig {
  /**
   * 最小滑动距离（px）
   */
  minSwipeDistance: number = 10;

  /**
   * 快速滑动的最小速度（px/ms）
   */
  minFlingVelocity: number = 500;

  /**
   * 触摸超时时间（ms），超过此时间认为是长按而非滑动
   */
  touchTimeout: number = 100;

  /**
   * 触摸拦截（防止与父组件手势冲突）
   */
  enableTouchIntercept: boolean = true;

  /**
   * 菜单打开阈值（0.0-1.0），滑动距离超过菜单宽度的此比例则打开
   */
  menuOpenThreshold: number = 0.5;

  /**
   * 构造函数
   */
  constructor(config?: TouchConfig) {
    if (config) {
      this.minSwipeDistance = config.minSwipeDistance ?? this.minSwipeDistance;
      this.minFlingVelocity = config.minFlingVelocity ?? this.minFlingVelocity;
      this.touchTimeout = config.touchTimeout ?? this.touchTimeout;
      this.enableTouchIntercept = config.enableTouchIntercept ?? this.enableTouchIntercept;
      this.menuOpenThreshold = config.menuOpenThreshold ?? this.menuOpenThreshold;
    }
  }

  /**
   * 创建默认配置
   */
  static default(): TouchConfig {
    return new TouchConfig();
  }

  /**
   * 敏感配置（容易触发滑动）
   */
  static sensitive(): TouchConfig {
    let config = new TouchConfig();
    config.minSwipeDistance = 3;     // 距离
    config.minFlingVelocity = 200;   // 速度阈值
    config.menuOpenThreshold = 0.2;  // 20%打开
    return config;
  }

  /**
   * 严格配置（难触发滑动）
   */
  static strict(): TouchConfig {
    let config = new TouchConfig();
    config.minSwipeDistance = 30;    // 距离
    config.minFlingVelocity = 1000;  // 速度阈值
    config.menuOpenThreshold = 0.8;  // 80%打开
    return config;
  }
}