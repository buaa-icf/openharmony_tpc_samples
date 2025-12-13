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

import { image } from '@kit.ImageKit';
import { hilog } from '@kit.PerformanceAnalysisKit';

interface ImageInfo {
  width: number;
  height: number;
}

export class ImageDecoder {

  static decodeToBitmap(encoded: Uint8Array): number[] {
    try {
      hilog.info(0xFF00, 'ImageDecoder', 'Starting image decode, data length: %{public}d', encoded.length);

      const imageSource = image.createImageSource(encoded.buffer);

      const decodingOptions: image.DecodingOptions = {
        sampleSize: 1,
        editable: true
      };

      const pixelMap = imageSource.createPixelMapSync(decodingOptions);
      if (!pixelMap) {
        hilog.error(0xFF00, 'ImageDecoder', 'Failed to create PixelMap from image source');
        return [];
      }

      const imageInfo = pixelMap.getImageInfoSync();
      const width = imageInfo.size.width;
      const height = imageInfo.size.height;

      hilog.info(0xFF00, 'ImageDecoder', 'Decoded image dimensions: %{public}d x %{public}d', width, height);

      if (width <= 0 || height <= 0) {
        hilog.error(0xFF00, 'ImageDecoder', 'Invalid image dimensions: %{public}d x %{public}d', width, height);
        return [];
      }

      const offset = 2;
      const pixels = new Array<number>(offset + width * height);
      pixels[0] = width;
      pixels[1] = height;

      const pixelBuffer = new ArrayBuffer(width * height * 4);
      pixelMap.readPixelsToBufferSync(pixelBuffer);

      const rgbaData = new Uint8Array(pixelBuffer);
      const argbData = new Uint32Array(width * height);

      for (let i = 0; i < width * height; i++) {
        const r = rgbaData[i * 4];
        const g = rgbaData[i * 4 + 1];
        const b = rgbaData[i * 4 + 2];
        const a = rgbaData[i * 4 + 3];

        argbData[i] = (a << 24) | (r << 16) | (g << 8) | b;
      }

      for (let i = 0; i < width * height; i++) {
        pixels[offset + i] = argbData[i];
      }

      pixelMap.release();
      imageSource.release();

      hilog.info(0xFF00, 'ImageDecoder', 'Image decode completed successfully');
      return pixels;

    } catch (error) {
      hilog.error(0xFF00, 'ImageDecoder', 'Failed to decode image: %{public}s', JSON.stringify(error));

      return [];
    }
  }

  static isValidImageData(data: Uint8Array): boolean {
    if (!data || data.length < 4) {
      return false;
    }

    const header = data.subarray(0, 4);
    const headerString = Array.from(header).map(b => b.toString(16).padStart(2, '0')).join('');

    const imageHeaders = [
      'ffd8ff', // JPEG
      '89504e47', // PNG
      '47494638', // GIF
      '52494646'  // WebP/RIFF
    ];

    return imageHeaders.some(header => headerString.startsWith(header));
  }

  static getImageInfo(encoded: Uint8Array): ImageInfo | null {
    try {
      const imageSource = image.createImageSource(encoded.buffer);
      const imageInfo = imageSource.getImageInfoSync();

      const result: ImageInfo = {
        width: imageInfo.size.width,
        height: imageInfo.size.height
      };

      imageSource.release();
      return result;

    } catch (error) {
      hilog.error(0xFF00, 'ImageDecoder', 'Failed to get image info: %{public}s', JSON.stringify(error));
      return null;
    }
  }
}