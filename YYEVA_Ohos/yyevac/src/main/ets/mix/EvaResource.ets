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
import { EvaSrc } from './EvaSrc'

/**
 * 资源描述类
 */
export class EvaResource {
  id: string = ''
  type: EvaSrc.SrcType = EvaSrc.SrcType.UNKNOWN
  loadType: EvaSrc.LoadType = EvaSrc.LoadType.UNKNOWN
  tag: string = ''
  scaleMode: string = '' // scaleFill, aspectFit, aspectFill
  bitmap: image.PixelMap | null = null  // ArkTS 中 Bitmap 对应 PixelMap

  text: string | null = null   // 文字，用户定制
  textColor: number = -1       // 文字颜色，用户定制
  fontSize: number = 0         // 文字大小，用户定制
  textAlign: string | null = null // 文字对齐方式，用户定制
  typeFace: string | null = null   // 字体样式，用字符串标识字体族名

  constructor(src: EvaSrc) {
    this.id = src.srcId
    this.type = src.srcType
    this.loadType = src.loadType
    this.tag = src.srcTag
    this.bitmap = src.bitmap
    if (src.scaleMode && src.scaleMode.length > 0) {
      this.scaleMode = src.scaleMode
    }
  }
}
