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

export enum Fit {
  NONE,
  FILL,
  CONTAIN,
  COVER,
  FIT_WIDTH,
  FIT_HEIGHT,
  SCALE_DOWN,
  LAYOUT
}

// Use namespace to implement companion object functionality
export namespace Fit {
  /**
   * Returns the [Fit] associated to [index].
   *
   * @throws RangeError If the index is out of bounds.
   */
  export function fromIndex(index: number): Fit {
    // Directly define enum values array to avoid using Object.values
    const values = [
      Fit.NONE,
      Fit.FILL,
      Fit.CONTAIN,
      Fit.COVER,
      Fit.FIT_WIDTH,
      Fit.FIT_HEIGHT,
      Fit.SCALE_DOWN,
      Fit.LAYOUT
    ];
    
    const maxIndex = values.length - 1;
    
    if (index < 0 || index > maxIndex) {
      throw new RangeError(`Invalid Fit index value ${index}. It must be between 0 and ${maxIndex}`);
    }
    
    return values[index];
  }
  
  /**
   * Returns the [Fit] associated to the given string.
   * Defaults to [Fit.CONTAIN] if the string doesn't match any known fit type.
   */
  export function fromString(fitString: string): Fit {
    switch (fitString.toLowerCase()) {
      case 'fill':
        return Fit.FILL;
      case 'cover':
        return Fit.COVER;
      case 'fit_width':
        return Fit.FIT_WIDTH;
      case 'fit_height':
        return Fit.FIT_HEIGHT;
      case 'none':
        return Fit.NONE;
      case 'scale_down':
        return Fit.SCALE_DOWN;
      case 'layout':
        return Fit.LAYOUT;
      case 'contain':
      default:
        return Fit.CONTAIN;
    }
  }
}