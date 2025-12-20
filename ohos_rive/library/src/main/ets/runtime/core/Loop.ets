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

export enum Loop {
  ONESHOT,
  LOOP,
  PINGPONG,
  AUTO
}

export class LoopUtils {
  /**
   * Returns the Loop associated to index.
   *
   * @throws Error If the index is out of bounds.
   */
  static fromIndex(index: number): Loop {
    const values = [Loop.ONESHOT, Loop.LOOP, Loop.PINGPONG, Loop.AUTO];
    const maxIndex = values.length - 1;
    if (index < 0 || index > maxIndex) {
      throw new RangeError(`Invalid Loop index value ${index}. It must be between 0 and ${maxIndex}`);
    }
    return values[index];
  }
}