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

export class YogaMeasureOutput {

  static make(width: number, height: number): number {
    const wBits = YogaMeasureOutput.floatToRawIntBits(width);
    const hBits = YogaMeasureOutput.floatToRawIntBits(height);

    return ((wBits >>> 0) * 0x100000000) + (hBits >>> 0);
  }

  static getWidth(measureOutput: number): number {
    const wBits = Math.floor(measureOutput / 0x100000000);
    return YogaMeasureOutput.intBitsToFloat(wBits);
  }

  static getHeight(measureOutput: number): number {
    const hBits = measureOutput >>> 0;
    return YogaMeasureOutput.intBitsToFloat(hBits);
  }

  private static floatToRawIntBits(value: number): number {
    const buffer = new ArrayBuffer(4);
    const view = new DataView(buffer);
    view.setFloat32(0, value, true);
    return view.getInt32(0, true);
  }

  private static intBitsToFloat(bits: number): number {
    const buffer = new ArrayBuffer(4);
    const view = new DataView(buffer);
    view.setInt32(0, bits, true);
    return view.getFloat32(0, true);
  }
}