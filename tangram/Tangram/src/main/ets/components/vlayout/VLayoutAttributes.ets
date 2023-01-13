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
   * RangeGridLayoutHelper
   */
  range?: Array<number> //可显示的条目,默认值[0,数据源长度]
  spanCount?: number //列数,默认为1
  weights?: Array<number> // 列占比集合：数组元素数值约分为占比,默认值为[100]
  autoExpand?: boolean // 余下项宽度自适应，当weights未定义时有效，且与clsSpan存在互斥关系，默认值为true
  aspectRatio?: number // GridItem的单行纵横比,默认值为0
  layoutHeight?:Length // Grid容器高度
  bgColor?:ResourceColor // Grid容器背景颜色，默认透明
  zIndex?:number// z序列
  gap?:number// 行列间距默认0
  vGap?:number//行间距
  hGap?:number//列间距
  padding?: Length[] //内边距
  topPadding?: Length
  rightPadding?: Length
  bottomPadding?: Length
  leftPadding?: Length
  margin?: Length[]
  topMargin?: Length
  rightMargin?:Length
  bottomMargin?:Length
  leftMargin?:Length
}

export declare type AbstractFullFillAttributes = {
  /**
   * SingleLayoutHelper
   * ColumnLayoutHelper
   * OnePlusNLayoutHelper
   * OnePlusNLayoutHelperEx
   */
  range?: Array<number> //可现实的条目, 默认为[0,数据源长度]
  rowWeights?: Array<number> //行权重，默认值[],仅支持OnePlusNLayoutHelper\ onePlusNLayoutHelperEx支持
  colWeights?: Array<number> //列权重，默认值为[]
  hasHeader?:boolean //第一个子项变成一行一列。默认值为false。仅OnePlusNLayoutHelper支持
  hasFooter?:boolean // 最后一个子项变成一行一列，默认值为false,j仅OnePlusNLayoutHelper支持
  layoutWidth?: Length
  layoutHeight?: Length
  aspectRatio?:number //容器纵横比
  bgColor?:ResourceColor
  zIndex?:number // z序
  padding?: Length[] //内边距
  topPadding?: Length
  rightPadding?: Length
  bottomPadding?: Length
  leftPadding?: Length
  margin?: Length[]
  topMargin?: Length
  rightMargin?:Length
  bottomMargin?:Length
  leftMargin?:Length
}