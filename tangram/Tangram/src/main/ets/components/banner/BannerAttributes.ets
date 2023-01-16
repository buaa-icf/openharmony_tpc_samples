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
export declare type BannerAttributes = {
  /**
   * BannerLayoutHelper
   */
  layoutWidth?: Length //容器宽度
  layoutHeight?: number //容器高度
  aspectRatio?: number //容器纵横比
  bgColor?: ResourceColor // 容器背景颜色，默认值为透明
  zIndex?: number //z序,默认值为0
  padding?: Length[] //内边距,默认值为0
  topPadding?: Length //上内边距,默认值为0
  rightPadding?: Length
  bottomPadding?: Length
  leftPadding?: Length
  margin?: Length[]
  topMargin?: Length
  rightMargin?: Length
  bottomMargin?: Length
  leftMargin?: Length
  pageRatio?: number // 内部View 宽度占总屏幕宽度的比例
  itemRatio?: number // 内部View的宽高比，高度=根据ratio计算高度
  autoScroll?: number //自动滚动，大于0具有自动滚动效果，此值为自动滚动间隔时间
  specialInterval?: string //特殊间隔
  infinite?: boolean //是否无限循环
  hGap?: number //横向每一帧之间的间距
  indicatorImg1?: string //指示器选中状态的图片
  indicatorImg2?: string //指示器未被选中状态的图片
  indicatorGravity?: number //指示器位置,居中 居左居右
  indicatorPosition?: string //指示器位置,在内部还是在外部
  indicatorGap?: number //指示器间距
  indicatorHeight?: number //指示器高度
  indicatorMargin?: number //指示器相对于布局底端间距
  indicatorRadius?: number // 指示器圆角度数
  indicatorColor?: string //指示器选中状态的颜色
  defaultIndicatorColor?: string //指示器违背选中状态的颜色
  infiniteMinCount?: number
  scrollMarginLeft?: number // 最左边一帧举例布局左边的间距
  scrollMarginRight?: number // 最右边一帧举例布局右边的间距
}