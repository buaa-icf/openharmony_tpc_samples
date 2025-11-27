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

import { EvaConstant } from './EvaConstant'
import { ELog } from './ELog'

/**
 * 缩放类型枚举
 */
export enum ScaleType {
  FIT_XY = 0, // 完整填充整个布局 default
  FIT_VIDEO = 1, // 按视频比例完整显示
  CENTER_CROP = 2, // 按视频比例完整填充布局（多余部分不显示）
}

/**
 * 缩放类型接口
 */
export interface IScaleType {
  /**
   * 获取布局参数
   * @param layoutWidth 布局宽度
   * @param layoutHeight 布局高度
   * @param videoWidth 视频宽度
   * @param videoHeight 视频高度
   * @param size 布局参数
   * @return 布局参数
   */
  getLayoutParam(
    layoutWidth: number,
    layoutHeight: number,
    videoWidth: number,
    videoHeight: number,
    size: Area
  ): Area

  /**
   * 获取实际尺寸
   * @return 实际尺寸
   */
  getRealSize(): Size
}

/**
 * FIT_XY 缩放类型实现
 */
export class ScaleTypeFitXY implements IScaleType {
  private realWidth: number = 0
  private realHeight: number = 0

  getLayoutParam(
    layoutWidth: number,
    layoutHeight: number,
    videoWidth: number,
    videoHeight: number,
    area: Area
  ): Area {
    area.width = '100%'
    area.height = '100%'
    this.realWidth = layoutWidth
    this.realHeight = layoutHeight
    return area
  }

  getRealSize(): Size {
    return { width: this.realWidth, height: this.realHeight }
  }
}

/**
 * FIT_CENTER 缩放类型实现
 */
export class ScaleTypeFitVideo implements IScaleType {
  private realWidth: number = 0
  private realHeight: number = 0

  getLayoutParam(
    layoutWidth: number,
    layoutHeight: number,
    videoWidth: number,
    videoHeight: number,
    area: Area
  ): Area {
    let mSize = this.getFitCenterSize(layoutWidth, layoutHeight, videoWidth, videoHeight)
    if (mSize.width <= 0 && mSize.height <= 0) {
      return area
    }

    this.realWidth = mSize.width
    this.realHeight = mSize.height
    area.width = mSize.width
    area.height = mSize.height

    return area
  }

  getRealSize(): Size {
    return { width: this.realWidth, height: this.realHeight }
  }

  private getFitCenterSize(
    layoutWidth: number,
    layoutHeight: number,
    videoWidth: number,
    videoHeight: number
  ): Size {
    const layoutRatio = layoutWidth / layoutHeight
    const videoRatio = videoWidth / videoHeight

    let realWidth: number
    let realHeight: number

    if (layoutRatio > videoRatio) {
      realHeight = layoutHeight
      realWidth = videoRatio * realHeight
    } else {
      realWidth = layoutWidth
      realHeight = realWidth / videoRatio
    }

    return { width: realWidth, height: realHeight }
  }
}

/**
 * CENTER_CROP 缩放类型实现
 */
export class ScaleTypeCenterCrop implements IScaleType {
  private realWidth: number = 0
  private realHeight: number = 0

  getLayoutParam(
    layoutWidth: number,
    layoutHeight: number,
    videoWidth: number,
    videoHeight: number,
    area: Area
  ): Area {
    const mSize = this.getCenterCropSize(layoutWidth, layoutHeight, videoWidth, videoHeight)
    if (mSize.width <= 0 && mSize.height <= 0) {
      return area
    }

    this.realWidth = mSize.width
    this.realHeight = mSize.height
    area.width = mSize.width
    area.height = mSize.height

    return area
  }

  getRealSize(): Size {
    return { width: this.realWidth, height: this.realHeight }
  }

  private getCenterCropSize(
    layoutWidth: number,
    layoutHeight: number,
    videoWidth: number,
    videoHeight: number
  ): Size {
    const layoutRatio = layoutWidth / layoutHeight
    const videoRatio = videoWidth / videoHeight

    let realWidth: number
    let realHeight: number

    if (layoutRatio > videoRatio) {
      realWidth = layoutWidth
      realHeight = realWidth / videoRatio
    } else {
      realHeight = layoutHeight
      realWidth = videoRatio * realHeight
    }

    return { width: realWidth, height: realHeight }
  }
}

/**
 * YYEVA 缩放类型工具类
 */
export class ScaleTypeUtil {
  private static readonly TAG = `${EvaConstant.TAG}.ScaleTypeUtil`
  private scaleTypeFitXY: ScaleTypeFitXY = new ScaleTypeFitXY()
  private scaleTypeFitVideo: ScaleTypeFitVideo = new ScaleTypeFitVideo()
  private scaleTypeCenterCrop: ScaleTypeCenterCrop = new ScaleTypeCenterCrop()
  private layoutWidth: number = 0
  private layoutHeight: number = 0
  private videoWidth: number = 0
  private videoHeight: number = 0
  public currentScaleType: ScaleType = ScaleType.FIT_XY
  public scaleTypeImpl: IScaleType | null = null

  /**
   * 设置布局尺寸
   * @param w 宽度
   * @param h 高度
   */
  setLayoutSize(w: number, h: number): void {
    this.layoutWidth = w
    this.layoutHeight = h
  }

  /**
   * 设置视频尺寸
   * @param w 宽度
   * @param h 高度
   */
  setVideoSize(w: number, h: number): void {
    this.videoWidth = w
    this.videoHeight = h
  }

  /**
   * 获取实际视频容器宽高
   * @return 实际尺寸
   */
  getRealSize(): Size {
    const size = this.getCurrentScaleType().getRealSize()
    ELog.i(ScaleTypeUtil.TAG, `get real size (${size.width}, ${size.height})`)
    return size
  }

  /**
   * 获取布局参数
   * @param view 视图对象
   * @return 布局参数
   */
  getLayoutParam(size: Area) {
    if (!this.checkParams()) {
      ELog.e(
        ScaleTypeUtil.TAG,
        `params error: layoutWidth=${this.layoutWidth}, layoutHeight=${this.layoutHeight}, videoWidth=${this.videoWidth}, videoHeight=${this.videoHeight}`
      )
      return size
    }

    return this.getCurrentScaleType().getLayoutParam(
      this.layoutWidth,
      this.layoutHeight,
      this.videoWidth,
      this.videoHeight,
      size
    )
  }

  /**
   * 获取当前缩放类型实现
   * @return 缩放类型实现
   */
  private getCurrentScaleType(): IScaleType {
    const tmpScaleType = this.scaleTypeImpl
    if (tmpScaleType !== null) {
      ELog.i(ScaleTypeUtil.TAG, 'custom scaleType')
      return tmpScaleType
    } else {
      ELog.i(ScaleTypeUtil.TAG, `scaleType=${this.currentScaleType}`)
      switch (this.currentScaleType) {
        case ScaleType.FIT_XY:
          return this.scaleTypeFitXY
        case ScaleType.FIT_VIDEO:
          return this.scaleTypeFitVideo
        case ScaleType.CENTER_CROP:
          return this.scaleTypeCenterCrop
        default:
          return this.scaleTypeFitXY
      }
    }
  }

  /**
   * 检查参数是否有效
   * @return 是否有效
   */
  private checkParams(): boolean {
    return this.layoutWidth > 0 && this.layoutHeight > 0 &&
      this.videoWidth > 0 && this.videoHeight > 0
  }
}