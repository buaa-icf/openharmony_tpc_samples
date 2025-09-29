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
import { fileIo as fs } from '@kit.CoreFileKit';
import { TouchConfig } from '../model/TouchConfig';
import { AnimationConfig, InterpolatorType } from '../model/AnimationConfig';
import { logger } from './Logger';

/**
 * SwipeMenuPreferences 配置持久化类
 */
export class SwipeMenuPreferences {
  private context: common.UIAbilityContext;
  private fileName: string;
  private filePath: string;

  constructor(context: common.UIAbilityContext, fileName: string = 'swipe_menu_preferences') {
    this.context = context;
    this.fileName = fileName;
    this.filePath = `${context.filesDir}/${fileName}.json`;
  }

  public async putString(key: string, value: string): Promise<void> {
    await this.setValue(key, value);
  }

  public async getString(key: string, defaultValue: string = ''): Promise<string> {
    const value = await this.getValue(key);
    return typeof value === 'string' ? value : defaultValue;
  }

  public async putInt(key: string, value: number): Promise<void> {
    await this.setValue(key, value);
  }

  public async getInt(key: string, defaultValue: number = 0): Promise<number> {
    const value = await this.getValue(key);
    return typeof value === 'number' ? value : defaultValue;
  }

  public async putBoolean(key: string, value: boolean): Promise<void> {
    await this.setValue(key, value);
  }

  public async getBoolean(key: string, defaultValue: boolean = false): Promise<boolean> {
    const value = await this.getValue(key);
    return typeof value === 'boolean' ? value : defaultValue;
  }

  public async putFloat(key: string, value: number): Promise<void> {
    await this.setValue(key, value);
  }

  public async getFloat(key: string, defaultValue: number = 0.0): Promise<number> {
    const value = await this.getValue(key);
    return typeof value === 'number' ? value : defaultValue;
  }

  public async contains(key: string): Promise<boolean> {
    try {
      const data = await this.loadAllData();
      return Object.keys(data).indexOf(key) !== -1;
    } catch (error) {
      logger.warn(`Failed to check key existence '${key}':`, error);
      return false;
    }
  }

  public async remove(key: string): Promise<void> {
    try {
      const oldData = await this.loadAllData();
      const newData: Record<string, string | number | boolean> = {};
      Object.keys(oldData).forEach(k => {
        if (k !== key) {
          newData[k] = oldData[k];
        }
      });
      await this.saveAllData(newData);
    } catch (error) {
      logger.warn(`Failed to remove key '${key}':`, error);
    }
  }

  public async clear(): Promise<void> {
    try {
      await this.saveAllData({});
    } catch (error) {
      logger.warn('Failed to clear preferences:', error);
    }
  }

  public async saveTouchConfig(touchConfig: TouchConfig): Promise<void> {
    try {
      const configJson = JSON.stringify({
        minSwipeDistance: touchConfig.minSwipeDistance,
        minFlingVelocity: touchConfig.minFlingVelocity,
        touchTimeout: touchConfig.touchTimeout,
        enableTouchIntercept: touchConfig.enableTouchIntercept,
        menuOpenThreshold: touchConfig.menuOpenThreshold
      });
      await this.putString('touch_config', configJson);
    } catch (error) {
      logger.warn('Failed to save touch config:', error);
    }
  }

  public async loadTouchConfig(): Promise<TouchConfig | null> {
    try {
      const jsonStr = await this.getString('touch_config');
      if (!jsonStr) return null;

      const obj = JSON.parse(jsonStr) as Record<string, string | number | boolean>;
      const cfg = TouchConfig.default();

      if (typeof obj.minSwipeDistance === 'number') {
        cfg.minSwipeDistance = obj.minSwipeDistance;
      }
      if (typeof obj.minFlingVelocity === 'number') {
        cfg.minFlingVelocity = obj.minFlingVelocity;
      }
      if (typeof obj.touchTimeout === 'number') {
        cfg.touchTimeout = obj.touchTimeout;
      }
      if (typeof obj.enableTouchIntercept === 'boolean') {
        cfg.enableTouchIntercept = obj.enableTouchIntercept;
      }
      if (typeof obj.menuOpenThreshold === 'number') {
        cfg.menuOpenThreshold = obj.menuOpenThreshold;
      }

      return cfg;
    } catch (err) {
      logger.warn('Failed to load touch config', err);
      return null;
    }
  }

  public async saveAnimationConfig(animationConfig: AnimationConfig, configType: 'open' | 'close'): Promise<void> {
    try {
      const configJson = JSON.stringify({
        duration: animationConfig.duration,
        interpolator: animationConfig.interpolator
      });
      await this.putString(`animation_config_${configType}`, configJson);
    } catch (error) {
      logger.warn(`Failed to save ${configType} animation config:`, error);
    }
  }

  /**
   * 读取动画配置
   * @param configType 配置类型 ('open' | 'close')
   * @returns Promise<AnimationConfig | null> 动画配置对象或null
   */
  public async loadAnimationConfig(configType: 'open' | 'close'): Promise<AnimationConfig | null> {
    try {
      const configJson = await this.getString(`animation_config_${configType}`);
      if (!configJson) return null;

      const parsedData = JSON.parse(configJson) as Record<string, string | number | boolean>;

      if (typeof parsedData.duration !== 'number') {
        logger.warn(`Animation config 'duration' is missing or not a number for ${configType}.`);
        return null;
      }
      if (typeof parsedData.interpolator !== 'number') {
        logger.warn(`Animation config 'interpolator' is missing or not a number for ${configType}.`);
        return null;
      }

      const interpolatorValue = parsedData.interpolator as number;

      // 检查枚举中是否存在该值
      if (InterpolatorType[interpolatorValue] !== undefined) {
        const animationConfig = AnimationConfig.default();
        animationConfig.setDuration(parsedData.duration as number);

        // 验证通过后，直接进行安全的类型转换并设置
        const name: string = InterpolatorType[interpolatorValue] as string;
        if (typeof name !== 'string') {
          logger.warn(`Interpolator value ${interpolatorValue} is invalid for ${configType}.`);
          return null;
        }
        const enumVal: InterpolatorType = InterpolatorType[name];
        animationConfig.setInterpolator(enumVal);

        return animationConfig;
      } else {
        logger.warn(`Interpolator value ${interpolatorValue} is out of range for ${configType}.`);
        return null;
      }
    } catch (error) {
      logger.warn(`Failed to load ${configType} animation config:`, error);
      return null;
    }
  }

  private async setValue(key: string, value: string | number | boolean): Promise<void> {
    try {
      const data = await this.loadAllData();
      data[key] = value;
      await this.saveAllData(data);
    } catch (error) {
      logger.warn(`Failed to put value for key '${key}':`, error);
    }
  }

  private async getValue(key: string): Promise<string | number | boolean | undefined> {
    try {
      const data = await this.loadAllData();
      return data[key];
    } catch (error) {
      logger.warn(`Failed to get value for key '${key}':`, error);
      return undefined;
    }
  }

  private async loadAllData(): Promise<Record<string, string | number | boolean>> {
    try {
      if (!canIUse('SystemCapability.FileManagement.File.FileIO')) {
        return {};
      }
      const stat = await fs.stat(this.filePath);
      if (!stat.isFile()) {
        return {};
      }
      const file = fs.openSync(this.filePath, fs.OpenMode.READ_ONLY);
      const buffer = new ArrayBuffer(stat.size);
      fs.readSync(file.fd, buffer);
      fs.closeSync(file);
      const contentStr = String.fromCharCode(...new Uint8Array(buffer));
      return contentStr ? JSON.parse(contentStr) as Record<string, string | number | boolean> : {};
    } catch (error) {
      return {};
    }
  }

  private async saveAllData(data: Record<string, string | number | boolean>): Promise<void> {
    try {
      if (!canIUse('SystemCapability.FileManagement.File.FileIO')) {
        throw new Error('fs API not supported on this device');
      }
      const content = JSON.stringify(data, null, 2);
      const file = fs.openSync(this.filePath, fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE | fs.OpenMode.TRUNC);
      fs.writeSync(file.fd, content);
      fs.closeSync(file);
    } catch (error) {
      logger.error('Failed to save preferences data:', error);
      throw new Error('Failed to save data');
    }
  }

  public static getDefaultSharedPreferences(context: common.UIAbilityContext): SwipeMenuPreferences {
    return new SwipeMenuPreferences(context, 'swipe_menu_default_prefs');
  }

  public static getSharedPreferences(context: common.UIAbilityContext, name: string): SwipeMenuPreferences {
    return new SwipeMenuPreferences(context, name);
  }
}