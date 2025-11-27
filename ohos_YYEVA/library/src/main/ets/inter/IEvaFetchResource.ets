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

import { EvaResource } from '../mix/EvaResource'
import { EvaSrc } from '../mix/EvaSrc'
import { image } from '@kit.ImageKit'

/**
 * YYEVA 资源获取器接口
 * 定义动态资源获取和替换功能
 */
export interface IEvaFetchResource {
  /**
   * 获取图片 (暂时不支持Bitmap.Config.ALPHA_8 主要是因为一些机型opengl兼容问题)
   * @param resource 资源信息
   * @param result 结果回调 (bitmap, fitType)
   */
  setImage(resource: EvaResource, result: (bitmap: image.PixelMap | null, fitType: EvaSrc.FitType | null) => void): void

  /**
   * 获取文字
   * @param resource 资源信息
   * @param result 结果回调
   */
  setText(resource: EvaResource, result: (resource: EvaResource) => void): void

  /**
   * 资源释放通知
   * @param resources 资源列表
   */
  releaseSrc(resources: EvaResource[]): void
}