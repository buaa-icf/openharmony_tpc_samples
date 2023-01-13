/*
 * Copyright (C) 2022 Huawei Device Co., Ltd.
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
export declare type GridAttributes = {
  /**
   * GridLayoutHelper
   * RangeGridLayoutHeper
   */
  aspectRatio?:number //单行纵横比
  layoutHeight?: Length //容器高度
  spanCount?: number // 列数，当列数大于列权重集合时剩余权重评分，当列数大于列权重集合时以列数为准
  weights?:Array<number> // 列权重集合： 当列权重集合达到100时自动去除后面的权重
  autoExpand?:boolean // 最后一行是否自适应，与colsSpan属性互斥
  vGap?:number //列与行的间距
  hGap?:number // 行与行的间距
  bgColor?: ResourceColor //容器背景颜色
  zIndex?:number //z序
  topPadding?:number
  bottomPadding?:number
  leftPadding?:number | string
  rightPadding?:number | string
  topMargin?:number | string
  bottomMargin?:number | string
  leftMargin?:number|string
  rightMargin?:number|string
}