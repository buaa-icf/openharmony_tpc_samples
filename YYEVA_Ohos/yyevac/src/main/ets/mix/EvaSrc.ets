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

import { Effect } from '../EvaAnimConfig'
import { ELog } from '../util/ELog'
import { EvaConstant } from '../util/EvaConstant'

/**
 * 资源描述类
 */
export class EvaSrc {
  static TAG: string = `${EvaConstant}.EvaSrc`

  srcId: string = ''
  w: number = 0
  h: number = 0
  srcType: EvaSrc.SrcType = EvaSrc.SrcType.UNKNOWN
  loadType: EvaSrc.LoadType = EvaSrc.LoadType.UNKNOWN
  srcTag: string = ''
  scaleMode: string = 'scaleFill'  // scaleFill aspectFit aspectFill
  bitmap: PixelMap | null = null
  txt: string = ''
  style: EvaSrc.Style = EvaSrc.Style.DEFAULT
  color: number = -1
  fitType: EvaSrc.FitType = EvaSrc.FitType.FIT_XY
  fontSize: number = 0
  textAlign: string = 'center' // center, right, left
  src: Promise<PixelMap> | undefined

  constructor(effect: Effect)
  constructor(json: Record<string, ESObject>)
  constructor(param: ESObject) {
    if (param instanceof Effect) {
      const effect = param as Effect
      this.srcId = effect.effectId.toString()
      this.w = effect.effectWidth
      this.h = effect.effectHeight

      let colorStr = effect.fontColor && effect.fontColor.length > 0 ? effect.fontColor : '#000000'
      this.color = this.parseColorSafe(colorStr)

      this.srcTag = effect.effectTag
      this.txt = this.srcTag
      this.fontSize = effect.fontSize
      this.textAlign = effect.textAlign
      this.srcType = (effect.effectType === EvaSrc.SrcType.IMG)
        ? EvaSrc.SrcType.IMG
        : (effect.effectType === EvaSrc.SrcType.TXT)
          ? EvaSrc.SrcType.TXT
          : EvaSrc.SrcType.UNKNOWN
      this.fitType = EvaSrc.FitType.FIT_XY
      ELog.i(EvaSrc.TAG, `${this.toString()} color=${colorStr}`)
    } else if (typeof param === 'object') {
      const json = param as Record<string, ESObject>
      this.srcId = json['srcId']
      this.w = json['w']
      this.h = json['h']

      let colorStr :string = json['color'] ?? '#000000'
      if (!colorStr || colorStr.length === 0) colorStr = '#000000'
      this.color = this.parseColorSafe(colorStr)

      this.srcTag = json['srcTag']
      this.txt = this.srcTag

      const srcTypeStr : string = json['srcType']
      if (srcTypeStr === EvaSrc.SrcType.IMG) {
        this.srcType = EvaSrc.SrcType.IMG
      } else if (srcTypeStr === EvaSrc.SrcType.TXT) {
        this.srcType = EvaSrc.SrcType.TXT
      } else {
        this.srcType = EvaSrc.SrcType.UNKNOWN
      }

      const loadTypeStr : string = json['loadType']
      if (loadTypeStr === EvaSrc.LoadType.NET) {
        this.loadType = EvaSrc.LoadType.NET
      } else if (loadTypeStr === EvaSrc.LoadType.LOCAL) {
        this.loadType = EvaSrc.LoadType.LOCAL
      } else {
        this.loadType = EvaSrc.LoadType.UNKNOWN
      }

      const fitTypeStr : string= json['fitType']
      if (fitTypeStr === EvaSrc.FitType.CENTER_FULL) {
        this.fitType = EvaSrc.FitType.CENTER_FULL
      } else {
        this.fitType = EvaSrc.FitType.FIT_XY
      }

      const styleStr :string= json['style'] ?? ''
      if (styleStr === EvaSrc.Style.BOLD) {
        this.style = EvaSrc.Style.BOLD
      } else {
        this.style = EvaSrc.Style.DEFAULT
      }

      ELog.i(EvaSrc.TAG, `${this.toString()} color=${this.color}`)
    }
  }

  parseColorSafe(colorStr?: string): number {
    let s = colorStr?.trim();
    if (!s || s.length === 0) {
      s = '#000000';
    }
    // 去掉前缀 #
    if (s.startsWith('#')) {
      s = s.slice(1);
    }
    // 支持 6 位（RRGGBB）或 8 位（AARRGGBB）
    if (s.length === 6) {
      // 默认 alpha 为 FF
      s = 'FF' + s;
    } else if (s.length !== 8) {
      // 不是合法长度，回退黑色
      s = 'FF000000';
    }
    // 转为整数
    const a = parseInt(s.slice(0, 2), 16);
    const r = parseInt(s.slice(2, 4), 16);
    const g = parseInt(s.slice(4, 6), 16);
    const b = parseInt(s.slice(6, 8), 16);
    // ARGB 拼成一个数值
    return ((a & 0xFF) << 24) | ((r & 0xFF) << 16) | ((g & 0xFF) << 8) | (b & 0xFF);
  }

  toString(): string {
    return `Src(srcId='${this.srcId}', srcType=${this.srcType}, loadType=${this.loadType}, srcTag='${this.srcTag}', bitmap=${this.bitmap}, txt='${this.txt}', textAlign=${this.textAlign})`
  }
}

/**
 * EvaSrc 辅助枚举
 */
export namespace EvaSrc {
  export enum SrcType {
    UNKNOWN = 'unknown',
    IMG = 'img',
    TXT = 'txt'
  }

  export enum LoadType {
    UNKNOWN = 'unknown',
    NET = 'net',
    LOCAL = 'local'
  }

  export enum FitType {
    FIT_XY = 'fitXY',
    CENTER_FULL = 'centerFull',
    CENTER_FIT = 'centerFit'
  }

  export enum Style {
    DEFAULT = 'default',
    BOLD = 'b'
  }
}

export class EvaSrcMap {
  map: Map<string, EvaSrc> = new Map<string, EvaSrc>()

  constructor(effects: Array<Effect>) {
    for (let i = 0; i < effects.length; i++) {
      const src = new EvaSrc(effects[i])
      if (src.srcType !== EvaSrc.SrcType.UNKNOWN) {
        this.map.set(src.srcId, src)
      }
    }
  }
}
