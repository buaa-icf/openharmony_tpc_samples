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
/**
 * Spine Native 模块类型声明
 */

  /**
   * 初始化资源管理器
   * @param resourceManager 鸿蒙资源管理器对象
   * @returns 是否成功
   */
  export const initResourceManager: (resourceManager: object)=> boolean;
  /**
   * 注册 XComponent
   * @param xComponentId XComponent 的 ID
   * @returns 是否成功
   */
  export const registerXComponent: (xComponentId: string)=> boolean;

  /**
   * 加载 Spine 骨骼
   * @param xComponentId XComponent ID
   * @param instanceName 实例名称（用于后续操作）
   * @param atlasPath atlas 文件路径（相对于 rawfile）
   * @param skeletonPath skeleton 文件路径（相对于 rawfile）
   * @param scale 缩放比例
   * @returns 是否成功
   */
  export const loadSkeleton: (
    xComponentId: string,
    instanceName: string,
    atlasPath: string,
    skeletonPath: string,
    scale: number
  )=> boolean;

  /**
   * 设置动画
   * @param xComponentId XComponent ID
   * @param instanceName 实例名称
   * @param trackIndex 轨道索引
   * @param animationName 动画名称
   * @param loop 是否循环
   * @returns 是否成功
   */
  export const setAnimation: (
    xComponentId: string,
    instanceName: string,
    trackIndex: number,
    animationName: string,
    loop: boolean
  )=> boolean;

  /**
   * 设置位置
   * @param xComponentId XComponent ID
   * @param instanceName 实例名称
   * @param x X 坐标
   * @param y Y 坐标
   */
  export const setPosition: (
    xComponentId: string,
    instanceName: string,
    x: number,
    y: number
  )=> void;

  /**
   * 设置缩放
   * @param xComponentId XComponent ID
   * @param instanceName 实例名称
   * @param scaleX X 缩放
   * @param scaleY Y 缩放
   */
  export const setScale: (
    xComponentId: string,
    instanceName: string,
    scaleX: number,
    scaleY: number
  )=> void;

  /**
   * 渲染一帧
   * @param xComponentId XComponent ID（可选，不传则渲染所有）
   */
  export const renderFrame:(xComponentId?: string)=> void;

  /**
   * 获取动画列表
   * @param xComponentId XComponent ID
   * @param instanceName 实例名称
   * @returns 动画名称数组
   */
  export const getAnimations:(xComponentId: string, instanceName: string)=> string[];

  /**
   * 移除实例
   * @param xComponentId XComponent ID
   * @param instanceName 实例名称
   */
  export const removeInstance:(xComponentId: string, instanceName: string)=> void;

/**
 * 设置皮肤
 * @param xComponentId XComponent ID
 * @param instanceName 实例名称
 * @param skinName 皮肤名称（传空字符串清除皮肤）
 * @returns 是否成功
 */
export const setSkin: (
  xComponentId: string,
  instanceName: string,
  skinName: string
) => boolean;

/**
 * 获取皮肤列表
 * @param xComponentId XComponent ID
 * @param instanceName 实例名称
 * @returns 皮肤名称数组
 */
export const getSkins: (
  xComponentId: string,
  instanceName: string
) => string[];


