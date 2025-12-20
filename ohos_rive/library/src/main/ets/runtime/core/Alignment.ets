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

export enum Alignment {
  TOP_LEFT,
  TOP_CENTER,
  TOP_RIGHT,
  CENTER_LEFT,
  CENTER,
  CENTER_RIGHT,
  BOTTOM_LEFT,
  BOTTOM_CENTER,
  BOTTOM_RIGHT
}

const alignmentValues: Alignment[] = [
  Alignment.TOP_LEFT,
  Alignment.TOP_CENTER,
  Alignment.TOP_RIGHT,
  Alignment.CENTER_LEFT,
  Alignment.CENTER,
  Alignment.CENTER_RIGHT,
  Alignment.BOTTOM_LEFT,
  Alignment.BOTTOM_CENTER,
  Alignment.BOTTOM_RIGHT
];

export namespace Alignment {
  export function fromIndex(index: number): Alignment {
    const maxIndex = alignmentValues.length - 1;
    if (index < 0 || index > maxIndex) {
      throw new RangeError(`Invalid Alignment index value ${index}. It must be between 0 and ${maxIndex}`);
    }
    return alignmentValues[index];
  }
}