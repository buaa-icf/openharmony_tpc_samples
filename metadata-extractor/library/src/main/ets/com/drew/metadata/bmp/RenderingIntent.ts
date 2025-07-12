/*
Copyright (c) 2022 Huawei Device Co., Ltd.
Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
*/

import LogUtil from "../../tools/LogUtils";

const TAG: string = "RenderingIntent";

export enum RenderingIntent {
  /** Graphic, Saturation */
  LCS_GM_BUSINESS = 1,

  /** Proof, Relative Colorimetric */
  LCS_GM_GRAPHICS = 2,

  /** Picture, Perceptual */
  LCS_GM_IMAGES = 4,

  /** Match, Absolute Colorimetric */
  LCS_GM_ABS_COLORIMETRIC = 8
}

export namespace RenderingIntent {
  export function typeOf(value: number) {
    LogUtil.debug(TAG, `typeOf start, value=${value}`);
    switch (value) {
      case RenderingIntent.LCS_GM_BUSINESS:
        return RenderingIntent.LCS_GM_BUSINESS
      case RenderingIntent.LCS_GM_GRAPHICS:
        return RenderingIntent.LCS_GM_GRAPHICS
      case RenderingIntent.LCS_GM_IMAGES:
        return RenderingIntent.LCS_GM_IMAGES
      case RenderingIntent.LCS_GM_ABS_COLORIMETRIC:
        return RenderingIntent.LCS_GM_ABS_COLORIMETRIC
      default:
        LogUtil.error(TAG, `typeOf end, Unknown rendering intent type: ${value}`);
        return null
    }
  }

  export function toString(renderingIntent: RenderingIntent) {
    LogUtil.debug(TAG, `toString start, renderingIntent=${renderingIntent}`);
    switch (renderingIntent) {
      case RenderingIntent.LCS_GM_BUSINESS:
        return "Graphic, Saturation";
      case RenderingIntent.LCS_GM_GRAPHICS:
        return "Proof, Relative Colorimetric";
      case RenderingIntent.LCS_GM_IMAGES:
        return "Picture, Perceptual";
      case RenderingIntent.LCS_GM_ABS_COLORIMETRIC:
        return "Match, Absolute Colorimetric";
      default:
        LogUtil.error(TAG, `toString error: Unimplemented rendering intent ${renderingIntent}`);
        throw new Error("Unimplemented rendering intent " + renderingIntent);
    }
  }
}