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
import { Style } from './Style'

export class BannerStyle extends Style{
  autoScroll: number // 自动滚动，大于0时具有自动滚动效果,此值为自动滚动间隔时间
  specialInterval: string // 特殊间隔,未实现
  infinite:boolean // 是否为无限循环
  indicatorImg1: string // 指示器选中状态的图片
  indicatorImg2: string // 指示器未被选中状态的图片
  indicatorPosition: string // 指示器位置，在内部还是在外部
  indicatorGap:number // 每个指示器间距
  indicatorHeight:number // 指示器高度
  indicatorMargin:number// 指示器相对于布局底端的间距
  indicatorRadius:number // 指示器圆角度数
  indicatorColor: string// 指示器选中状态的颜色
  defaultIndicatorColor: string//指示器未被选中状态颜色
  hGap:number // 横向每一帧之间的间距
  pageRatio:number // 内部View宽度占总屏幕宽度的比例,0-1f
  itemRatio:number// 内部view的宽高比, 宽度=满屏幕, 高度 = 根据ratio计算高度
}