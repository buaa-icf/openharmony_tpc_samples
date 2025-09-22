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
  */

import { fileIo } from '@kit.CoreFileKit';


const MAX_BYTE = 0xFF; // 字节最大值（无符号）
const LUM_R = 0.2126; // 红色亮度系数
const LUM_G = 0.7152; // 绿色亮度系数
const LUM_B = 0.0722; // 蓝色亮度系数

export enum ColorSpace {
  Rgba = 4,
  Rgb = 3,
  Grayscale = 1
}


export function getBytesPerPixel(space: number): number {
  switch (space) {
    case ColorSpace.Rgba:
      return 4;
    case ColorSpace.Rgb:
      return 3;
    case ColorSpace.Grayscale:
      return 1;
    default:
      throw new Error(`Unsupported color space: ${space}`);
  }
}

class Converter {
  /**
   * 执行转换
   * @param input 输入字节数组（单个像素的原始数据）
   * @param inputOffset 输入数组的起始偏移量（通常为 0）
   * @param output 转换后数据的输出流
   * @throws IOException 写入输出流时可能抛出的异常
   */
  input: Uint8Array;
  inputOffset: number;
  output: fileIo.WriteStream;

  constructor(input: Uint8Array, inputOffset: number, output: fileIo.WriteStream) {
    this.input = input;
    this.inputOffset = inputOffset;
    this.output = output;
  }
}