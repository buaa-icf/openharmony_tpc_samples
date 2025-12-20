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

export enum Direction {
  BACKWARDS,
  FORWARDS,
  AUTO
}

export namespace Direction {
  export function getValue(direction: Direction): number {
    switch (direction) {
      case Direction.BACKWARDS:
        return -1;
      case Direction.FORWARDS:
        return 1;
      case Direction.AUTO:
        return 0;
      default:
        return 0;
    }
  }
  export function fromInt(value: number): Direction | undefined {
    switch (value) {
      case -1:
        return Direction.BACKWARDS;
      case 1:
        return Direction.FORWARDS;
      case 0:
        return Direction.AUTO;
      default:
        return undefined;
    }
  }
}