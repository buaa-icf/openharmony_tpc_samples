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

import { YogaUnit, YogaMeasureMode, YogaDirection } from './yogaEnum';
import { YogaNode } from './yogaNode';

export class YogaValue {
  static readonly UNDEFINED = new YogaValue(NaN, YogaUnit.UNDEFINED);
  static readonly ZERO = new YogaValue(0, YogaUnit.POINT);
  static readonly AUTO = new YogaValue(NaN, YogaUnit.AUTO);

  value: number;
  unit: YogaUnit;

  constructor(value: number, unit: YogaUnit) {
    this.value = value;
    this.unit = unit;
  }

  equals(other: Object): boolean {
    if (other instanceof YogaValue) {
      const otherValue = other as YogaValue;
      if (this.unit === otherValue.unit) {
        return this.unit === YogaUnit.UNDEFINED
          || this.unit === YogaUnit.AUTO
          || (this.value === otherValue.value ||
            (isNaN(this.value) && isNaN(otherValue.value)));
      }
    }
    return false;
  }

  toString(): string {
    switch (this.unit) {
      case YogaUnit.UNDEFINED:
        return "undefined";
      case YogaUnit.AUTO:
        return "auto";
      case YogaUnit.PERCENT:
        return `${this.value}%`;
      default:
        return this.value.toString();
    }
  }
}

export class YogaConstants {
  static readonly UNDEFINED: number = NaN;

  static isUndefined(value: number | YogaValue): boolean {
    if (typeof value === 'number') {
      return isNaN(value);
    } else {
      return value.unit === YogaUnit.UNDEFINED;
    }
  }
}

export type YogaMeasureFunction = (
  node: YogaNode,
  width: number,
  widthMode: YogaMeasureMode,
  height: number,
  heightMode: YogaMeasureMode
) => number;

export type YogaBaselineFunction = (
  node: YogaNode,
  width: number,
  height: number,
) => number;

export interface EdgeValues {
  left: number;
  top: number;
  right: number;
  bottom: number;
}

export class LayoutData {
  left: number = 0;
  top: number = 0;
  width: number = 0;
  height: number = 0;
  direction: YogaDirection = YogaDirection.INHERIT;
  margin?: EdgeValues;
  padding?: EdgeValues;
  border?: EdgeValues;
  hasNewLayout: boolean = true;

  static defaultInit(): LayoutData {
    return new LayoutData();
  }

  static updateFromNative(nativeLayout: LayoutData): LayoutData {
    const layout = new LayoutData();
    if (nativeLayout) {
      layout.left = nativeLayout.left || 0;
      layout.top = nativeLayout.top || 0;
      layout.width = nativeLayout.width || 0;
      layout.height = nativeLayout.height || 0;
      layout.direction = nativeLayout.direction || YogaDirection.INHERIT;
      layout.hasNewLayout = nativeLayout.hasNewLayout || false;
      if (nativeLayout.margin) {
        layout.margin = nativeLayout.margin;
      }
      if (nativeLayout.padding) {
        layout.padding = nativeLayout.padding;
      }
      if (nativeLayout.border) {
        layout.border = nativeLayout.border;
      }
    }
    return layout;
  }
}
