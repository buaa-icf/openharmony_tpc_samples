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
export class GridStyle extends Style{
  column: number // 列数
  autoExpand: boolean // 最后一行条目宽度充满整行（此属性为true时，colspan属性失效，各自合并功能）
  hGap:number // 水平间距（列与列之间的距离）
  vGap:number // 数值间距（行与行之间的距离）
}