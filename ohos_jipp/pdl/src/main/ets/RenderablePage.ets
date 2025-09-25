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

import { ColorSpace, getBytesPerPixel } from './OhColorSpace';

export class RenderablePage {
  DPI: number = 300;
  widthPixels: number = 0;
  /** Height of the entire page, in pixels. */
  heightPixels: number = 0;
  // 声明回调函数类型
  render: (yOffset: number, swathHeight: number,
    colorSpace: ColorSpace, bytes: Uint8Array) => void | null;
  WHITE_BYTE: number = 0XFF

  constructor(
    widthPixels: number,
    heightPixels: number,
    dpi: number,
    renderCallback: (
      yOffset: number,
      swathHeight: number,
      colorSpace: ColorSpace,
      bytes: Uint8Array
    ) => void
  ) {
    this.DPI = dpi
    this.widthPixels = widthPixels;
    this.heightPixels = heightPixels;
    this.render = renderCallback;
  }


  getHeightPixels() :number{
    return this.heightPixels;
  }

  getWidthPixels() :number{
    return this.widthPixels;
  }

  flipX(): RenderablePage{
    return new RenderablePage(this.widthPixels, this.heightPixels, this.DPI,
      (yOffset: number, swathHeight: number, colorSpace: ColorSpace, byteArray: Uint8Array) => {
        this.render(yOffset, swathHeight, colorSpace, byteArray)
        RenderablePage.flipX(byteArray, this.widthPixels, getBytesPerPixel(colorSpace))
      })
  }

  flipY(): RenderablePage {
    return new RenderablePage(this.widthPixels, this.heightPixels, this.DPI,
      (yOffset: number, swathHeight: number, colorSpace: ColorSpace, byteArray: Uint8Array) => {
        this.render(this.heightPixels - yOffset - swathHeight, swathHeight, colorSpace, byteArray)
        RenderablePage.flipY(byteArray, this.widthPixels, getBytesPerPixel(colorSpace))
      })
  }

  rotated() : RenderablePage{
    return new RenderablePage(this.widthPixels, this.heightPixels, this.DPI,
      (yOffset: number, swathHeight: number, colorSpace: ColorSpace, byteArray: Uint8Array) => {
        this.render(this.heightPixels - yOffset - swathHeight, swathHeight, colorSpace, byteArray)
        RenderablePage.rotate180(byteArray, this.widthPixels, getBytesPerPixel(colorSpace))
      })
  }

  renderSize(swathHeight: number, colorSpace: ColorSpace) :number{
    return this.widthPixels * getBytesPerPixel(colorSpace) * swathHeight
  }

  blank() : RenderablePage{
    return new RenderablePage(this.widthPixels, this.heightPixels, this.DPI,
      (yOffset: number, swathHeight: number, colorSpace: ColorSpace, byteArray: Uint8Array) => {
        byteArray.fill(this.WHITE_BYTE)
      })
  }


  private static rotate180(byteArray: Uint8Array, width: number, bytesPerPixel: number): void {
    const pixelCount = byteArray.length / bytesPerPixel;
    const height = pixelCount / width;

    // 交换上下行像素
    for (let y = 0; y < Math.floor(height / 2); y++) {
      for (let x = 0; x < width; x++) {
        const pos1 = (y * width + x) * bytesPerPixel;
        const pos2 = ((height - y - 1) * width + (width - x - 1)) * bytesPerPixel;
        RenderablePage.swap(byteArray, pos1, pos2, bytesPerPixel);
      }
    }

    // 如果高度是奇数，处理中间行的左右翻转
    const middle = Math.floor(height / 2);
    if (height % 2 !== 0) {
      for (let x = 0; x < Math.floor(width / 2); x++) {
        const pos1 = (middle * width + x) * bytesPerPixel;
        const pos2 = (middle * width + width - x - 1) * bytesPerPixel;
        RenderablePage.swap(byteArray, pos1, pos2, bytesPerPixel);
      }
    }
  }

  /**
   * 将字节数组中的像素左右翻转（X轴翻转）
   * @param byteArray 包含像素数据的字节数组
   * @param width 图像宽度（像素）
   * @param bytesPerPixel 每个像素的字节数
   */
  private static flipX(byteArray: Uint8Array, width: number, bytesPerPixel: number): void {
    const pixelCount = byteArray.length / bytesPerPixel;
    const height = pixelCount / width;

    // 逐行左右翻转
    for (let y = 0; y < height; y++) {
      for (let x = 0; x < Math.floor(width / 2); x++) {
        const pos1 = (y * width + x) * bytesPerPixel;
        const pos2 = (y * width + width - x - 1) * bytesPerPixel;
        RenderablePage.swap(byteArray, pos1, pos2, bytesPerPixel);
      }
    }
  }

  /**
   * 将字节数组中的像素上下翻转（Y轴翻转）
   * @param byteArray 包含像素数据的字节数组
   * @param width 图像宽度（像素）
   * @param bytesPerPixel 每个像素的字节数
   */
  private static flipY(byteArray: Uint8Array, width: number, bytesPerPixel: number): void {
    const pixelCount = byteArray.length / bytesPerPixel;
    const height = pixelCount / width;
    const rowSize = width * bytesPerPixel;

    // 交换上下行
    for (let y = 0; y < Math.floor(height / 2); y++) {
      const pos1 = y * rowSize;
      const pos2 = (height - y - 1) * rowSize;
      RenderablePage.swap(byteArray, pos1, pos2, rowSize);
    }
  }

  /**
   * 在字节数组中交换两个指定位置的块
   * @param byteArray 目标字节数组
   * @param pos1 第一个块的起始位置
   * @param pos2 第二个块的起始位置
   * @param size 每个块的大小（字节）
   */
  private static swap(byteArray: Uint8Array, pos1: number, pos2: number, size: number): void {
    if (size === 1) {
      // 单个字节交换优化
      const temp = byteArray[pos1];
      byteArray[pos1] = byteArray[pos2];
      byteArray[pos2] = temp;
    } else {
      // 多字节块交换
      // 复制第一个块
      const temp = new Uint8Array(size);
      for (let i = 0; i < size; i++) {
        temp[i] = byteArray[pos1 + i];
      }
      // 将第二个块复制到第一个块位置
      for (let i = 0; i < size; i++) {
        byteArray[pos1 + i] = byteArray[pos2 + i];
      }
      // 将临时保存的第一个块复制到第二个块位置
      for (let i = 0; i < size; i++) {
        byteArray[pos2 + i] = temp[i];
      }
    }
  }
}