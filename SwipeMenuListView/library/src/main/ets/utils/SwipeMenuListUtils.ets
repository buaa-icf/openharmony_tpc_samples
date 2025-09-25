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

import { common } from '@kit.AbilityKit';
import resourceManager from '@ohos.resourceManager';
import { logger } from './Logger';

/**
 * SwipeMenuListView 工具类
 */
export class Point {
  x: number;
  y: number;

  constructor(x: number, y: number) {
    this.x = x;
    this.y = y;
  }
}

export class TouchPoint {
  x: number;
  y: number;

  constructor(x: number, y: number) {
    this.x = x;
    this.y = y;
  }
}

export class SwipeMenuListUtils {
  /**
   * 判断触摸点是否在指定组件范围内
   * @param componentArea 组件的区域信息
   * @param touchPoint 触摸点坐标
   * @returns boolean 返回true表示触摸点在组件范围内
   */
  public static inRangeOfView(
    componentArea: Area, 
    touchPoint: TouchPoint
  ): boolean {
    if (!componentArea || !componentArea.position) {
      return false;
    }
    
    const left = componentArea.position.x as number;
    const top = componentArea.position.y as number;
    const right = left + (componentArea.width as number);
    const bottom = top + (componentArea.height as number);
    
    return touchPoint.x >= left && 
           touchPoint.x <= right &&
           touchPoint.y >= top && 
           touchPoint.y <= bottom;
  }

  /**
   * 判断触摸点是否在指定矩形范围内
   * @param left 左边界
   * @param top 上边界  
   * @param right 右边界
   * @param bottom 下边界
   * @param touchPoint 触摸点坐标
   * @returns boolean 返回true表示触摸点在范围内
   */
  public static inRangeOfRect(
    left: number, 
    top: number, 
    right: number, 
    bottom: number,
    touchPoint: TouchPoint
  ): boolean {
    return touchPoint.x >= left && 
           touchPoint.x <= right &&
           touchPoint.y >= top && 
           touchPoint.y <= bottom;
  }

  /**
   * 计算两点之间的距离
   * @param point1 第一个点
   * @param point2 第二个点
   * @returns number 两点间的距离
   */
  public static distance(
    point1: Point,
    point2: Point
  ): number {
    const dx = point1.x - point2.x;
    const dy = point1.y - point2.y;
    return Math.sqrt(dx * dx + dy * dy);
  }

  /**
   * 获取资源管理器
   * @param context 上下文对象
   * @returns ResourceManager 资源管理器
   */
  public static getResourceManager(context?: common.UIAbilityContext): resourceManager.ResourceManager | undefined {
    return context?.resourceManager;
  }

  /**
   * 获取字符串资源
   * @param context 上下文对象
   * @param resId 资源ID
   * @returns Promise<string> 字符串资源内容
   */
  public static async getString(context: common.UIAbilityContext, resId: number): Promise<string> {
    try {
      return await context.resourceManager.getStringValue(resId);
    } catch (error) {
      logger.warn(`Failed to get string resource ${resId}:`, error);
      return '';
    }
  }

  /**
   * 获取字符串资源
   * @param context 上下文对象
   * @param resource 资源对象
   * @returns Promise<string> 字符串资源内容
   */
  public static async getStringByResource(context: common.UIAbilityContext, resource: Resource): Promise<string> {
    try {
      return await context.resourceManager.getStringValue(resource);
    } catch (error) {
      logger.warn(`Failed to get string resource by Resource:`, error);
      return '';
    }
  }

  /**
   * 获取颜色资源
   * @param context 上下文对象
   * @param resId 颜色资源ID
   * @returns Promise<string> 颜色值(十六进制字符串)
   */
  public static async getColor(context: common.UIAbilityContext, resId: number): Promise<string> {
    try {
      return await context.resourceManager.getStringValue(resId);
    } catch (error) {
      logger.warn(`Failed to get color resource ${resId}:`, error);
      return '#000000';
    }
  }

  /**
   * 获取颜色资源
   * @param context 上下文对象  
   * @param resource 颜色资源对象
   * @returns Promise<string> 颜色值(十六进制字符串)
   */
  public static async getColorByResource(context: common.UIAbilityContext, resource: Resource): Promise<string> {
    try {
      return await context.resourceManager.getStringValue(resource);
    } catch (error) {
      logger.warn(`Failed to get color resource by Resource:`, error);
      return '#000000';
    }
  }

  /**
   * 获取drawable资源路径
   * @param context 上下文对象
   * @param resId drawable资源ID
   * @returns Promise<string> 资源路径
   */
  public static async getDrawable(context: common.UIAbilityContext, resId: number): Promise<string> {
    try {
      return await context.resourceManager.getStringValue(resId);
    } catch (error) {
      logger.warn(`Failed to get drawable resource ${resId}:`, error);
      return '';
    }
  }

  /**
   * 获取尺寸资源
   * @param context 上下文对象
   * @param resId 尺寸资源ID
   * @returns Promise<number> 尺寸值
   */
  public static async getDimension(context: common.UIAbilityContext, resId: number): Promise<number> {
    try {
      const value = await context.resourceManager.getStringValue(resId);
      return parseFloat(value) || 0;
    } catch (error) {
      logger.warn(`Failed to get dimension resource ${resId}:`, error);
      return 0;
    }
  }

  /**
   * 检查资源是否存在
   * @param context 上下文对象
   * @param resId 资源ID
   * @returns Promise<boolean> 资源是否存在
   */
  public static async resourceExists(context: common.UIAbilityContext, resId: number): Promise<boolean> {
    try {
      await context.resourceManager.getStringValue(resId);
      return true;
    } catch (error) {
      logger.debug(`Resource ${resId} does not exist`);
      return false;
    }
  }
}