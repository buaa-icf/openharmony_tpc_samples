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
 * YYEVA 缩放类型
 * 定义视频缩放模式
 */
export class ScaleType {
  public static readonly CENTER_CROP: string = 'centerCrop'
  public static readonly CENTER_INSIDE: string = 'centerInside'
  public static readonly FIT_CENTER: string = 'fitCenter'
  public static readonly FIT_XY: string = 'fitXY'
  public static readonly MATRIX: string = 'matrix'
}
