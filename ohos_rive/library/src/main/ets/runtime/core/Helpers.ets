/*
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

import rive from 'libohos_rive.so';
import { Fit } from './Fit';
import { Alignment } from './Alignment';


class EnumWrapper {
  private value: string;

  constructor(value: string) {
    this.value = value;
  }

  toString(): string {
    return this.value;
  }
}
export class PointF {
  public x: number;
  public y: number;

  constructor(x: number = 0, y: number = 0) {
    this.x = x;
    this.y = y;
  }
}

export class RectF {
  public left: number;
  public top: number;
  public right: number;
  public bottom: number;

  constructor(left: number = 0, top: number = 0, right: number = 0, bottom: number = 0) {
    this.left = left;
    this.top = top;
    this.right = right;
    this.bottom = bottom;
  }
}

export class Helpers {
  static convertToArtboardSpace(
    touchBounds: RectF,
    touchLocation: PointF,
    fit: Fit,
    alignment: Alignment,
    artboardBounds: RectF,
    scaleFactor: number = 1.0
  ): PointF {
    const resultPoint = rive.Napi_Helper_cppConvertToArtboardSpace(
      touchBounds,
      touchLocation,
      fit,
      alignment,
      artboardBounds,
      scaleFactor
    ) as PointF | undefined | null;

    if (!resultPoint || typeof resultPoint.x !== 'number' || typeof resultPoint.y !== 'number') {
      throw new Error('[Helpers] convertToArtboardSpace failed: invalid native result.');
    }

    return resultPoint;
  }

  private static fitToString(fit: Fit): string {
    switch (fit) {
      case Fit.FILL:
        return 'FILL';
      case Fit.CONTAIN:
        return 'CONTAIN';
      case Fit.COVER:
        return 'COVER';
      case Fit.FIT_WIDTH:
        return 'FIT_WIDTH';
      case Fit.FIT_HEIGHT:
        return 'FIT_HEIGHT';
      case Fit.NONE:
        return 'NONE';
      case Fit.SCALE_DOWN:
        return 'SCALE_DOWN';
      case Fit.LAYOUT:
        return 'LAYOUT';
      default:
        return 'CONTAIN';
    }
  }

  private static alignmentToString(alignment: Alignment): string {
    switch (alignment) {
      case Alignment.TOP_LEFT:
        return 'TOP_LEFT';
      case Alignment.TOP_CENTER:
        return 'TOP_CENTER';
      case Alignment.TOP_RIGHT:
        return 'TOP_RIGHT';
      case Alignment.CENTER_LEFT:
        return 'CENTER_LEFT';
      case Alignment.CENTER:
        return 'CENTER';
      case Alignment.CENTER_RIGHT:
        return 'CENTER_RIGHT';
      case Alignment.BOTTOM_LEFT:
        return 'BOTTOM_LEFT';
      case Alignment.BOTTOM_CENTER:
        return 'BOTTOM_CENTER';
      case Alignment.BOTTOM_RIGHT:
        return 'BOTTOM_RIGHT';
      default:
        return 'CENTER';
    }
  }

  private static createEnumWrapper(enumName: string): EnumWrapper {
    return new EnumWrapper(enumName);
  }
}

