/*
  * Copyright (c) 2025 Huawei Device Co., Ltd.
  *
  * Licensed under the Apache License, Version 2.0 (the "License");
  * you may not use this file except in compliance with the License.
  * You may obtain a copy of the License at
    *
  * http://www.apache.org/licenses/LICENSE-2.0
    *
  * Unless required by applicable law or agreed to in writing, software
  * distributed under the License is distributed on an "AS IS" BASIS,
  * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
  * See the License for the specific language governing permissions and
  * limitations under the License.
  * */

import { BitWidth } from './bit-width.js'

export function toByteWidth(bitWidth: BitWidth): number {
  return 1 << bitWidth;
}

export function iwidth(value: number | bigint): BitWidth {
  if (value >= -128 && value <= 127) return BitWidth.WIDTH8;
  if (value >= -32768 && value <= 32767) return BitWidth.WIDTH16;
  if (value >= -2147483648 && value <= 2147483647) return BitWidth.WIDTH32;
  return BitWidth.WIDTH64;
}

export function fwidth(value: number): BitWidth {
  return value === Math.fround(value) ? BitWidth.WIDTH32 : BitWidth.WIDTH64;
}

export function uwidth(value: number): BitWidth {
  if (value <= 255) return BitWidth.WIDTH8;
  if (value <= 65535) return BitWidth.WIDTH16;
  if (value <= 4294967295) return BitWidth.WIDTH32;
  return BitWidth.WIDTH64;
}

export function fromByteWidth(value: number): BitWidth {
  if (value === 1) return BitWidth.WIDTH8;
  if (value === 2) return BitWidth.WIDTH16;
  if (value === 4) return BitWidth.WIDTH32;
  return BitWidth.WIDTH64;
}

export function paddingSize(bufSize: number, scalarSize: number): number {
  return (~bufSize + 1) & (scalarSize - 1);
}