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
import { Style } from './style/style'

@Observed
export class CardProperty {
  type?: string //类型
  style: Style //样式
  id?: string // 对应id未用到
  items?: Array<CardProperty> //子元素条目
  msg?: string //信息
  loadType?: number = 0; //加载类型（-1为需要异步加载，1为异步加载且有分页，0则不需要加载更多）
  loadinfo?: string //加载更多用到的信息
  loaded?: boolean = false // 是否已经加载更多完毕
  colspan?: number //仅用于Grid布局,合并宫格
  header?: CardProperty // 头部条目,未用到
  footer?: CardProperty // 尾部条目,未用到
  maxChildren?: number // 子元素的最大值,未用到
}