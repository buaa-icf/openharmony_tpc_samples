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

import { TouchConfig } from '../model/TouchConfig';
import { logger } from './Logger';

export interface SwipeMenuItemController {
  openMenu(): void;
  closeMenu(): void;
  getPosition(): number;
  updateTouchConfig(config: TouchConfig): void;
}

export class SwipeStateController extends SubscribedAbstractProperty<number> {
  private _currentOpenPosition: number = -1;
  private _itemControllers: Map<number, SwipeMenuItemController> = new Map();
  private _touchConfig: TouchConfig = TouchConfig.default();
  private _configUpdateCallback?: (config: TouchConfig) => void;

  constructor() {
    super();
  }

  public aboutToBeDeleted(): void {}

  public get(): number {
    return this._currentOpenPosition;
  }

  public set(newValue: number): void {
    if (this._currentOpenPosition !== newValue) {
      this._currentOpenPosition = newValue;
    }
  }

  /**
   * 注册列表项控制器
   */
  public registerItemController(position: number, controller: SwipeMenuItemController): void {
    this._itemControllers.set(position, controller);
  }

  /**
   * 注销列表项控制器
   */
  public unregisterItemController(position: number): void {
    this._itemControllers.delete(position);
  }

  /**
   * 打开指定位置的菜单
   */
  public smoothOpenMenu(position: number): void {
    if (this._currentOpenPosition !== -1 && this._currentOpenPosition !== position) {
      this.smoothCloseMenu();
    }

    const controller = this._itemControllers.get(position);
    if (controller) {
      controller.openMenu();
      this.set(position);
    } else {
      logger.warn(`SwipeStateController - Controller not found for position ${position}`);
    }
  }

  /**
   * 关闭当前打开的菜单
   */
  public smoothCloseMenu(): void {
    if (this._currentOpenPosition !== -1) {
      const controller = this._itemControllers.get(this._currentOpenPosition);
      if (controller) {
        controller.closeMenu();
        this.set(-1);
      }
    }
  }

  /**
   * 检查指定位置的菜单是否打开
   */
  public isMenuOpen(position: number): boolean {
    return this._currentOpenPosition === position;
  }

  /**
   * 获取当前触摸配置
   */
  public getTouchConfig(): TouchConfig {
    return this._touchConfig;
  }

  /**
   * 更新触摸配置并通知所有注册的控制器
   */
  public updateTouchConfig(config: TouchConfig): void {
    this._touchConfig = config;

    this._itemControllers.forEach((controller) => {
      controller.updateTouchConfig(config);
    });

    if (this._configUpdateCallback) {
      this._configUpdateCallback(config);
    }
  }

  /**
   * 设置配置更新回调函数
   */
  public setConfigUpdateCallback(callback: (config: TouchConfig) => void): void {
    this._configUpdateCallback = callback;
  }
}