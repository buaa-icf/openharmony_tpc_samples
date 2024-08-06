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

@ComponentV2
export struct DividerLine {
  @Param color: string | number = "red" //分割线颜色
  @Param lineWidth: number = 5 //分割线宽度
  @Param lineLength: number = 200 //分割线容器的长度
  @Param dashed: boolean = true //是否实线条
  @Param times: number = 15 //遍历次数
  @Param dashLength: number = 2 //单个虚线长度


  build() {
    Flex({ justifyContent: FlexAlign.SpaceBetween }) {
      if (this.dashed) {
        Divider().color(this.color).strokeWidth(this.lineWidth)
      }
      else {
        ForEach(new Array(this.times), () => {
          Divider().color(this.color).strokeWidth(this.lineWidth).width(this.dashLength)
        })
      }
    }.width(this.lineLength)
  }
}
