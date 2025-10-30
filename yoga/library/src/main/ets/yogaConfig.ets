/**
 * Copyright (C) 2025 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import yoga from 'libyoga_native.so';
import { YogaErrata, YogaExperimentalFeature } from './yogaEnum';

export class YogaConfig {
  private nativeConfig: Object | null;

  constructor() {
    this.nativeConfig = yoga.configNew();
  }

  getNativeConfig(): Object | null {
    return this.nativeConfig;
  }

  /**
   * 设置是否使用Web默认值
   * @param enabled 是否启用Web默认值
   */
  setUseWebDefaults(enabled: boolean): void {
    if (this.nativeConfig) {
      yoga.configSetUseWebDefaults(this.nativeConfig, enabled);
    }
  }

  /**
   * 设置点缩放因子
   * @param pixelsInPoint 每个点的像素数
   */
  setPointScaleFactor(pixelsInPoint: number): void {
    if (this.nativeConfig) {
      yoga.configSetPointScaleFactor(this.nativeConfig, pixelsInPoint);
    }
  }

  /**
   * 设置错误修正选项
   * @param errata 错误修正选项
   */
  setErrata(errata: YogaErrata): void {
    if (this.nativeConfig) {
      yoga.configSetErrata(this.nativeConfig, errata);
    }
  }

  /**
   * 获取当前错误修正选项
   * @returns 当前错误修正选项
   */
  getErrata(): YogaErrata {
    if (this.nativeConfig) {
      return yoga.configGetErrata(this.nativeConfig) as YogaErrata;
    }
    return YogaErrata.NONE;
  }

  /**
   * 设置实验特性是否启用
   * @param feature 实验特性枚举值
   * @param enabled 是否启用
   * tips: 新功能实验性接口
   */
  setExperimentalFeatureEnabled(feature: YogaExperimentalFeature, enabled: boolean): void {
    if (this.nativeConfig) {
      yoga.configSetExperimentalFeatureEnabled(this.nativeConfig, feature, enabled);
    }
  }
}