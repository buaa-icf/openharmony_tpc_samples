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
import { ELog } from './util/ELog';
import { EvaConstant } from './util/EvaConstant';

type Log = (level: string, tag: string, message: string) => void;

/** 视频渲染模式枚举 */
export enum VideoMode {
  SPLIT_HORIZONTAL_REVERSE = 0,
  // 其他模式需补充...
}

/**
 * OhosYYEva 动效渲染引擎原生模块声明
 * @syscap SystemCapability.Multimedia.Graphics.Core
 * @since 11
 */
export class EvaUtil {
  public static readonly TAG: string = `${EvaConstant.TAG}.EvaUtil`;

  /**
   * 处理图像像素（替代 Android Bitmap）
   * @param pixelMap - 鸿蒙图像对象
   */
  static nativeProcessPixelMap(pixelMap: image.PixelMap): void {
    ELog.i(EvaUtil.TAG, `nativeProcessPixelMap pixelMap: ${pixelMap}`);
  }

  /**
   * 获取外部纹理 ID
   * @param controllerId - 渲染控制器 ID
   * @returns 纹理 ID（失败返回错误码）
   */
  static getExternalTexture(controllerId: number): number {
    ELog.i(EvaUtil.TAG, `getExternalTexture controllerId: ${controllerId}`);
    return 0;
  }

  /**
   * 更新渲染视图尺寸
   * @param controllerId - 控制器 ID
   * @param width - 新宽度
   * @param height - 新高度
   */
  static updateViewPoint(controllerId: number, width: number, height: number): void {
    ELog.i(EvaUtil.TAG, `updateViewPoint controllerId: ${controllerId}, width: ${width}, height: ${height}`);
  }

  /**
   * 处理视频尺寸变化
   * @param controllerId - 控制器 ID
   * @param newWidth - 新宽度
   * @param newHeight - 新高度
   */
  static videoSizeChange(controllerId: number, newWidth: number, newHeight: number): void {
    ELog.i(EvaUtil.TAG,
      `videoSizeChange controllerId: ${controllerId}, newWidth: ${newWidth}, newHeight: ${newHeight}`);
  }

  /**
   * 初始化 MP4 渲染器
   * @param controllerId - 控制器 ID
   * @param surface - 鸿蒙 Surface 对象（替代 Android Surface）
   * @param isNeedYuv - 是否需要 YUV 格式输出
   * @param isNormalMp4 - 是否为标准 MP4 格式
   * @returns 管理器 ID（失败返回 -1）
   */
  static initRender(
    controllerId: number,
    surfaceId: string,
    isNeedYuv: boolean,
    isNormalMp4: boolean,
    isVideoRecord?: boolean
  ): number {
    ELog.i(EvaUtil.TAG,
      `initRender controllerId: ${controllerId}, surfaceId: ${surfaceId}, isNeedYuv: ${isNeedYuv}, isNormalMp4: ${isNormalMp4}, isVideoRecord: ${isVideoRecord}`);
    return 0;
  }

  /**
   * 设置动效 JSON 配置
   * @param controllerId - 控制器 ID
   * @param json - 动效配置数据
   */
  static setRenderConfig(controllerId: number, json: string): void {
    ELog.i(EvaUtil.TAG, `setRenderConfig controllerId: ${controllerId}, json: ${json}`);
  }

  /**
   * 设置默认渲染配置
   * @param controllerId - 控制器 ID
   * @param width - 视图宽度
   * @param height - 视图高度
   * @param defaultVideoMode - 视频模式（见下方枚举）
   */
  static defaultConfig(
    controllerId: number,
    width: number,
    height: number,
    defaultVideoMode?: VideoMode
  ): void {
    ELog.i(EvaUtil.TAG,
      `defaultConfig controllerId: ${controllerId}, width: ${width}, height: ${height}, defaultVideoMode: ${defaultVideoMode}`);
  }

  /**
   * 设置背景图像
   * @param controllerId - 控制器 ID
   * @param pixelMap - 图像对象（null 表示清空背景）
   */
  static setBgPixelMap(controllerId: number, pixelMap: image.PixelMap | null): void {
    ELog.i(EvaUtil.TAG, `setBgPixelMap controllerId: ${controllerId}, pixelMap: ${pixelMap}`);
  }

  /**
   * 设置动效元素图像
   * @param controllerId - 控制器 ID
   * @param srcId - 动效元素 ID
   * @param pixelMap - 图像对象
   * @param scaleMode - 缩放模式（"fitXY" | "centerCrop" | "centerInside"）
   */
  static setSrcPixelMap(
    controllerId: number,
    srcId: string,
    pixelMap: image.PixelMap | null,
    scaleMode: string
  ): void {
    ELog.i(EvaUtil.TAG,
      `setSrcPixelMap controllerId: ${controllerId}, srcId: ${srcId}, pixelMap: ${pixelMap}, scaleMode: ${scaleMode}`);
  }

  /**
   * 设置动效元素文本
   * @param controllerId - 控制器 ID
   * @param srcId - 动效元素 ID
   * @param txt - 文本内容
   */
  static setSrcTxt(controllerId: number, srcId: string, txt: string): void {
    ELog.i(EvaUtil.TAG, `setSrcTxt controllerId: ${controllerId}, srcId: ${srcId}, txt: ${txt}`);
  }

  /**
   * 渲染单帧画面
   * @param controllerId - 控制器 ID
   */
  static renderFrame(controllerId: number): void {
    ELog.i(EvaUtil.TAG, `renderFrame controllerId: ${controllerId}`);
  }

  /**
   * 清空当前帧画面
   * @param controllerId - 控制器 ID
   */
  static renderClearFrame(controllerId: number): void {
    ELog.i(EvaUtil.TAG, `renderClearFrame controllerId: ${controllerId}`);
  }

  /**
   * 释放纹理资源
   * @param controllerId - 控制器 ID
   */
  static releaseTexture(controllerId: number): void {
    ELog.i(EvaUtil.TAG, `releaseTexture controllerId: ${controllerId}`);
  }

  /**
   * 交换渲染缓冲区（双缓冲机制）
   * @param controllerId - 控制器 ID
   */
  static renderSwapBuffers(controllerId: number): void {
    ELog.i(EvaUtil.TAG, `renderSwapBuffers controllerId: ${controllerId}`);
  }

  /**
   * 销毁渲染器
   * @param controllerId - 控制器 ID
   */
  static destroyRender(controllerId: number): void {
    ELog.i(EvaUtil.TAG, `destroyRender controllerId: ${controllerId}`);
  }

  /**
   * 创建动效混合渲染器
   * @param controllerId - 控制器 ID
   * @param json - 动效配置 JSON
   * @returns 渲染器 ID（失败返回 -1）
   */
  static mixConfigCreate(controllerId: number, json: string): number {
    ELog.i(EvaUtil.TAG, `mixConfigCreate controllerId: ${controllerId}, json: ${json}`);
    return 0;
  }

  /**
   * 初始化动效混合渲染
   * @param controllerId - 控制器 ID
   */
  static mixRenderCreate(controllerId: number): void {
    ELog.i(EvaUtil.TAG, `mixRenderCreate controllerId: ${controllerId}`);
  }

  /**
   * 执行动效混合渲染
   * @param controllerId - 控制器 ID
   * @param frameIndex - 目标帧索引
   */
  static mixRendering(controllerId: number, frameIndex: number): void {
    ELog.i(EvaUtil.TAG, `mixRendering controllerId: ${controllerId}, frameIndex: ${frameIndex}`);
  }

  /**
   * 销毁动效混合渲染器
   * @param controllerId - 控制器 ID
   */
  static mixRenderDestroy(controllerId: number): void {
    ELog.i(EvaUtil.TAG, `mixRenderDestroy controllerId: ${controllerId}`);
  }

  /**
   * 初始化录制视频
   */
  static initVideoRecord(controllerId: number, surface: string): number {
    ELog.i(EvaUtil.TAG, `initVideoRecord controllerId: ${controllerId}, surface: ${surface}`);
    return 0;
  }

  /**
   * 设置动效json数据
   */
  static setRecordRenderConfig(controllerId: number, json: string): void {
    ELog.i(EvaUtil.TAG, `setRecordRenderConfig controllerId: ${controllerId}, json: ${json}`);
  }


  /**
   * 触发录制绘制
   */
  static recordRender(controllerId: number, time: number): void {
    ELog.i(EvaUtil.TAG, `recordRender controllerId: ${controllerId}, time: ${time}`);
  }

  /**
   * 停止录制
   */
  static stopRecord(controllerId: number): void {
    ELog.i(EvaUtil.TAG, `stopRecord controllerId: ${controllerId}`);
  }

  /**
   * 是否开启视频录制
   * 需要在主渲染线程开启，不是录制线程开启
   */
  static setVideoRecord(controllerId: number, isVideoRecord: boolean): void {
    ELog.i(EvaUtil.TAG, `setVideoRecord controllerId: ${controllerId}, isVideoRecord: ${isVideoRecord}`);
  }

  static setLog(log: Log): void {
    ELog.i(EvaUtil.TAG, `setLog log: ${log}`);
  }

  static setBlendMode(controllerId: number, blendMode: number): void {
    ELog.i(EvaUtil.TAG, `setBlendMode controllerId: ${controllerId}, blendMode: ${blendMode}`);
  }
}