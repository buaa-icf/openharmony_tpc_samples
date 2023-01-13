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
export class Style{
  width?: Length //宽
  height?: number //高
  aspectRatio?:number // 单行布局的纵横比
  bgColor?:string //背景色
  background_image?:string // 背景图片,未用到
  zIndex?: number // 当布局重叠时,上下位置定位
  padding?: Array<number|string> //内边距
  margin?: Array<number|string> //外边距
  cols?:Array<number> //列占比集合
  display?: string // 字体显示风格，未用到
  animationDuration?: number // 当没有给固定位置卡片设置动画时,默认动画为Y轴位移动画，此属性时配置其动画执行时间，未用到
  slidable?:boolean // 卡片是否可滑动,未用到
  forLabel?:string //用于给卡片标记,未用到
}