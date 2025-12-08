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

import { EvaSrc } from '../mix/EvaSrc';
import { BusinessError } from '@kit.BasicServicesKit';
import { drawing, text } from '@kit.ArkGraphics2D'
import { image } from '@kit.ImageKit'

export class EvaBitmapUtil {
  public static r: number = 0;
  public static g: number = 0;
  public static b: number = 0;
  public static a: number = 0;

  static async createEmptyBitmap(): Promise<image.PixelMap | null> {
    let result: image.PixelMap | null = null;
    const color: ArrayBuffer = new ArrayBuffer(256);
    let opts: image.InitializationOptions =
      { editable: true, pixelFormat: image.PixelMapFormat.RGBA_8888, size: { height: 16, width: 16 } }
    try {
      const pixelMap = await image.createPixelMap(color, opts);
      console.info('Succeeded in creating pixelmap.');
      result = pixelMap;
    } catch (error) {
      console.error(`Failed to create pixelmap. code is ${error.code}, message is ${error.message}`);
    }
    return result;
  }

  static createTextPixmap(src: EvaSrc): image.PixelMap {

    EvaBitmapUtil.colorToRGBA(src.color);
    let textStyle: text.TextStyle = {
      color: {
        alpha: EvaBitmapUtil.a,
        red: EvaBitmapUtil.r,
        green: EvaBitmapUtil.g,
        blue: EvaBitmapUtil.b
      },
      fontSize: src.fontSize,
    };
    let txtAlig = text.TextAlign.LEFT;
    console.error('src.textAlign', src.textAlign)
    switch (src.textAlign) {
      case 'left':
        txtAlig = text.TextAlign.LEFT;
        break;
      case 'right':
        txtAlig = text.TextAlign.RIGHT;
        break;
      default:
        txtAlig = text.TextAlign.CENTER;
        break;
    }

    let paragraphStyle: text.ParagraphStyle = {
      textStyle: textStyle,
      align: txtAlig,
    };
    let fontCollection: text.FontCollection = new text.FontCollection();
    let paragraphBuilder = new text.ParagraphBuilder(paragraphStyle, fontCollection);
    paragraphBuilder.addText(src.txt);
    let paragraph = paragraphBuilder.build();
    const color: ArrayBuffer = new ArrayBuffer(160000);
    let opts: image.InitializationOptions = { editable: true, pixelFormat: 3, size: { height: src.h, width: src.w } }

    paragraph.layout(200).then((data) => {
    }).catch((error: Error) => {
    });
    let pixelmap: image.PixelMap = image.createPixelMapSync(color, opts);
    let canvas = new drawing.Canvas(pixelmap);
    paragraph.paint(canvas, 0, 0);
    return pixelmap;
  }

  static colorToRGBA(color: number) {
    let aColor = (color >> 24) & 0xFF;
    const rColor = (color >> 16) & 0xFF;
    const gColor = (color >> 8) & 0xFF;
    const bColor = color & 0xFF;
    EvaBitmapUtil.a = aColor;
    EvaBitmapUtil.r = rColor;
    EvaBitmapUtil.g = gColor;
    EvaBitmapUtil.b = bColor;
  }
}