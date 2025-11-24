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

import { PointRect } from '../util/PointRect'
import { Data } from '../EvaAnimConfig'
import { Datas } from '../EvaAnimConfig'

/**
 * 单帧描述
 */
export class EvaFrame {
  public srcId: string = ''
  public z: number = 0
  public frame: PointRect
  public mFrame: PointRect
  public mt: number = 0

  constructor(index: number, d: Data) {
    this.srcId = d.effectId.toString()
    this.z = index
    this.frame = d.renderFrame
    this.mFrame = d.outputFrame
  }
}

/**
 * 一帧的集合
 */
export class EvaFrameSet {
  public index: number = 0 // 哪一帧
  public list: Array<EvaFrame> = []

  constructor(data: Datas) {
    this.index = data.frameIndex
    for (let i = 0; i < data.data.length; i++) {
      const frame = new EvaFrame(i, data.data[i])
      this.list.push(frame)
    }
  }
}

/**
 * 所有帧
 */
export class EvaFrameAll {
  // 每一帧的集合
  public map: Map<number, EvaFrameSet> = new Map()

  constructor(datas: Array<Datas>) {
    for (let data of datas) {
      const frameSet = new EvaFrameSet(data)
      this.map.set(frameSet.index, frameSet)
    }
  }
}
