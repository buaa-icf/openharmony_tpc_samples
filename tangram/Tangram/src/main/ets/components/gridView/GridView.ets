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
import { GridAttributes } from './GridAttributes'
import { ScreenUtil } from '../utils/ScreenUtil'

/**
 * 1.条目高度会以第一个条目的高度为准，使用此布局所有的条目高度应该一致
 */
@Component
export struct GridView {
  @BuilderParam vLayoutContent?: (item?, position?) => any //布局
  vLayoutData?: any[] = [] // 数据源
  @Watch('defaultInfo') @State vLayoutAttribute?: GridAttributes = {} //属性
  @State private GridInfo?: GridAttributes = {} //属性

  private lastWeights: number[] = []
  private weightsSum: number = 0
  private lastWeightSum: number = 0
  private weightsCommonMultiple: number = 0
  private columnsTemplate: string = ''
  private gridWidthPercent: Length = '' // grid所有权重加起来的百分比
  private gridMaxWidth: number = undefined; // grid百分百时的宽度
  @State private gridMaxWidthPercent: string = '100%' // grid减去左右margin后的百分比
  @State private oneRowHeight: number = undefined

  aboutToAppear() {
    this.defaultInfo();
  }

  /**
   * 先赋默认值，再进行初始化计算
   */
  defaultInfo() {
    console.error('GridLayoutHelper:' + '计算页面数据：====================================================================')
    //赋默认值
    this.GridInfo = {
      aspectRatio: this.vLayoutAttribute.aspectRatio == undefined ? 0 : this.vLayoutAttribute.aspectRatio,
      layoutHeight: this.vLayoutAttribute.layoutHeight == undefined ? 0 : this.vLayoutAttribute.layoutHeight,
      spanCount: this.vLayoutAttribute.spanCount == undefined && this.vLayoutAttribute.weights == undefined ? 4 :
          this.vLayoutAttribute.spanCount == undefined ? this.vLayoutAttribute.weights.length :
        this.vLayoutAttribute.spanCount,
      weights: this.vLayoutAttribute.spanCount == undefined && this.vLayoutAttribute.weights == undefined ? [25, 25, 25, 25] :
          this.vLayoutAttribute.weights == undefined ? [] : this.vLayoutAttribute.weights,
      autoExpand: this.vLayoutAttribute.autoExpand == undefined ? false : this.vLayoutAttribute.autoExpand,
      vGap: this.vLayoutAttribute.vGap == undefined ? 0 : this.vLayoutAttribute.vGap,
      hGap: this.vLayoutAttribute.hGap == undefined ? 0 : this.vLayoutAttribute.hGap,
      bgColor: this.vLayoutAttribute.bgColor == undefined ? 'rgba(0,0,0,0)' : this.vLayoutAttribute.bgColor,
      zIndex: this.vLayoutAttribute.zIndex == undefined ? 0 : this.vLayoutAttribute.zIndex,
      topPadding: this.vLayoutAttribute.topPadding == undefined ? 0 : this.vLayoutAttribute.topPadding,
      bottomPadding: this.vLayoutAttribute.bottomPadding == undefined ? 0 : this.vLayoutAttribute.bottomPadding,
      leftPadding: this.vLayoutAttribute.leftPadding == undefined ? 0 : this.vLayoutAttribute.leftPadding,
      rightPadding: this.vLayoutAttribute.rightPadding == undefined ? 0 : this.vLayoutAttribute.rightPadding,
      topMargin: this.vLayoutAttribute.topMargin == undefined ? 0 : this.vLayoutAttribute.topMargin,
      bottomMargin: this.vLayoutAttribute.bottomMargin == undefined ? 0 : this.vLayoutAttribute.bottomMargin,
      leftMargin: this.vLayoutAttribute.leftMargin == undefined ? 0 : this.vLayoutAttribute.leftMargin,
      rightMargin: this.vLayoutAttribute.rightMargin == undefined ? 0 : this.vLayoutAttribute.rightMargin,
    }

    if (this.GridInfo.spanCount == 1) {
      this.GridInfo.autoExpand = false;
    }

    this.computeWidth();
    this.computeHeight();
    this.computeColumnsTemplate();

    console.error('GridLayoutHelper: ' + 'vGap = ' + this.GridInfo.vGap + 'and hGap = ' + this.GridInfo.hGap);
    console.error('GridLayoutHelper: ' + 'bgColor = ' + this.GridInfo.bgColor + ' and zIndex =' + this.GridInfo.zIndex);
    console.error('GridLayoutHelper: ' + 'padding = top- ' + this.GridInfo.topPadding + ' bottom - ' + this.GridInfo.bottomPadding +
    ' left-' + this.GridInfo.leftPadding + ' right-' + this.GridInfo.rightPadding);
    console.error('GridLayoutHelper: ' + 'margin = top- ' + this.GridInfo.topMargin + ' bottom - ' + this.GridInfo.bottomMargin +
    ' left-' + this.GridInfo.leftMargin + ' right-' + this.GridInfo.rightMargin);
    console.error('GridLayoutHelper:' + '计算页面数据完成：====================================================================')
  }

  build() {
    Column() {
      Grid() {
        ForEach(this.vLayoutData, (item: any, position: number) => {
          GridItem() {
            this.vLayoutContent(item, position);
          }
          .height(this.oneRowHeight)
          .columnStart(1)
          .columnEnd(!this.GridInfo.autoExpand ? // 是否开启了最后一行条目自适应
            (Number(`${item.colspan}`) < 1 ? 1 : Number(`${item.colspan}`) > this.GridInfo.spanCount ? this.GridInfo.spanCount : Number(`${item.colspan}`)) :
              this.vLayoutData.length - position - 1 < this.vLayoutData.length % this.GridInfo.weights.length ? // 是否是最后一行的条目
              this.GridInfo.weights[position%(this.GridInfo.weights.length)] / this.lastWeightSum * this.weightsCommonMultiple :
              this.GridInfo.weights[position%(this.GridInfo.weights.length)] / this.weightsSum * this.weightsCommonMultiple)
          .onAreaChange((oldValue, newValue) => {
            if (this.oneRowHeight != (Number(newValue.height))) {
              // 单行高度自适应用到
              if (position == 0) {
                var oneRowHeight = (Number(newValue.height));
                if (this.oneRowHeight == undefined || this.oneRowHeight < oneRowHeight) {
                  this.oneRowHeight = oneRowHeight;
                  this.computeHeight();
                  console.error('GridView: ' + '宫格布局单行高度2 =' + this.oneRowHeight);
                }
              }
            }
          })
        })
      }
      .width(this.gridWidthPercent)
      .height('100%')
      .columnsTemplate(this.columnsTemplate)
      .columnsGap(this.GridInfo.hGap)
      .rowsGap(this.GridInfo.vGap)
      .padding({
        top: this.GridInfo.topPadding,
        bottom: this.GridInfo.bottomPadding,
        left: this.GridInfo.leftPadding,
        right: this.GridInfo.rightPadding,
      })
    }
    .width(this.gridMaxWidthPercent)
    .height(this.GridInfo.layoutHeight)
    //
    //
    //
    //
    //
    //
    //
    //
    //
    .id("vlayout.grid.max")
    .onAppear(() => {
      // 单行纵横比用到
      this.gridMaxWidth = ScreenUtil.getSize("vlayout.grid.max")[0] / 3;
      var height = ScreenUtil.getSize("vlayout.grid.max")[1] / 3;
      console.error('GridView: ' + '宫格布局的尺寸 =' + this.gridMaxWidth + ', ' + height);
      this.computeMargin();
    })
    .margin({
      top: this.GridInfo.topMargin,
      bottom: this.GridInfo.bottomMargin,
      left: this.GridInfo.leftMargin,
      right: this.GridInfo.rightMargin,
    })
    .backgroundColor(this.GridInfo.bgColor)
    .alignItems(HorizontalAlign.Start)
    .zIndex(this.GridInfo.zIndex)
  }

  /**
   * 计算宽度相关
   */
  private computeWidth() {
    // 当列权重和大于100时，将其缩小，列入，将权重【80，60，30】变更为【80，20】
    var usedWights = 0;
    for (var i = 0; i < this.GridInfo.weights.length; i++) {
      if (usedWights + this.GridInfo.weights[i] >= 100) {
        this.GridInfo.weights.splice(i + 1)
        this.GridInfo.weights[i] = 100 - usedWights
        this.GridInfo.spanCount = this.GridInfo.spanCount > this.GridInfo.weights.length ? this.GridInfo.weights.length : this.GridInfo.spanCount
        break;
      } else {
        usedWights += this.GridInfo.weights[i]
      }
    }

    // 计算列权重和列数的兼容
    if (this.GridInfo.spanCount > this.GridInfo.weights.length) { // 当列数大于权重集合长度时，剩余权重平均分
      usedWights = 0;
      for (let i = 0; i < this.GridInfo.weights.length; i++) {
        usedWights += this.GridInfo.weights[i];
      }
      var everoOneWeights = (100 - usedWights) > 0 ? (100 - usedWights) / (this.GridInfo.spanCount - this.GridInfo.weights.length) : 0;
      var weightLength = this.GridInfo.spanCount - this.GridInfo.weights.length;
      for (let i = 0; i < weightLength; i++) {
        this.GridInfo.weights.push(everoOneWeights)
      }
    } else { // 当列数小于权重集合长度时, 以列数为准
      while (this.GridInfo.spanCount < this.GridInfo.weights.length) {
        this.GridInfo.weights.splice(this.GridInfo.weights.length - 1);
      }
    }
    // 计算Grid实际占的宽度百分比
    this.weightsSum = 0;
    this.GridInfo.weights.forEach(weight => {
      this.weightsSum += weight;
    });
    this.gridWidthPercent = this.toPercent(this.weightsSum);

    console.error('GridLayoutHelper: ' + 'spanCount = ' + this.GridInfo.spanCount + 'and weights = ' + this.GridInfo.weights.toString());
    console.error('GridLayoutHelper: ' + 'gridWidthPercent = ' + this.gridWidthPercent);
  }

  /**
   * 计算左右margin
   */
  private computeMargin() {
    // 将左右Margin转换为数字类型
    if (this.gridMaxWidth != undefined) {
      if ((typeof (this.GridInfo.leftMargin)) == 'string') {
        this.GridInfo.leftMargin = Math.round(parseInt((this.GridInfo.leftMargin) as string) / 100.0 * this.gridMaxWidth);
      }
      if ((typeof (this.GridInfo.rightMargin)) == 'string') {
        this.GridInfo.rightMargin = Math.round(parseInt((this.GridInfo.rightMargin) as string) / 100.0 * this.gridMaxWidth);
      }
      this.gridMaxWidth = this.gridMaxWidth - (this.GridInfo.leftMargin as number) - (this.GridInfo.rightMargin as number);
      this.gridMaxWidthPercent = this.toPercent(this.gridMaxWidth * 100 / (this.gridMaxWidth + (this.GridInfo.leftMargin as number) + (this.GridInfo.rightMargin as number)));
      console.error('GridLayoutHelper: ' + 'gridWidthMax =' + this.gridMaxWidth + ' and leftMargin =' + this.GridInfo.leftMargin + ' and rightMargin=' + this.GridInfo.rightMargin)
    }
  }

  /**
   * 计算高度相关
   */
  private computeHeight() {
    // 计算单行高度,当未设置单行纵横比时,高度自适配
    if (this.GridInfo.aspectRatio > 0 && this.gridMaxWidth != undefined) {
      this.oneRowHeight = Math.round(this.gridMaxWidth / this.GridInfo.aspectRatio);
    }
    var rows = 0;
    //计算Grid的高度
    if (this.oneRowHeight != undefined && this.GridInfo.layoutHeight <= 0) {
      // 如果用户没指定整个Grid的高度，则自己计算整个GridLayout的高度，否则则使用用户指定的高度
      // 如果有条目有colspan属性，且值大于2.则需要自己计算Grid的行数
      rows = 1;
      if (!this.GridInfo.autoExpand) {
        var usedWeights = 0;
        var currentIndex = 0;
        var currentWeight = 0;
        for (var i = 0; i < this.vLayoutData.length; i++) {
          currentWeight = this.getWeight(currentIndex, this.vLayoutData[i].colspan == undefined ? 1 : Number(`${this.vLayoutData[i].colspan}`));
          if (usedWeights + currentWeight > this.weightsSum) { // 当前条目需要换行
            rows++;
            currentIndex = 0;
            usedWeights = 0;
            currentWeight = this.getWeight(currentIndex, this.vLayoutData[i].colspan == undefined ? 1 : Number(`${this.vLayoutData[i].colspan}`));
          }
          currentIndex += this.vLayoutData[i].colspan == undefined ? 1 : Number(`${this.vLayoutData[i].colspan}`);
          currentIndex = currentIndex >= this.GridInfo.spanCount ? 0 : currentIndex;
          usedWeights += currentWeight;
        }
      } else {
        rows = Math.ceil((this.vLayoutData.length) / this.GridInfo.spanCount)
      }
      this.GridInfo.layoutHeight = (this.oneRowHeight + this.GridInfo.vGap) * rows
      - this.GridInfo.vGap + this.GridInfo.topPadding + this.GridInfo.bottomPadding;
    }
    console.error('GridLayoutHelper:' + 'oneRowHeight =' + this.oneRowHeight + ' and layoutHeight =' + this.GridInfo.layoutHeight);
  }

  /**
   * 如果开启了最后一行宽度自适应， 则需要计算权重公倍数， 用于融合条目
   */
  private computeColumnsTemplate() {
    // 如果开启了最后一条目的自适应，则需要计算公倍数
    this.columnsTemplate = '';
    if (this.GridInfo.autoExpand) {
      this.lastWeightSum = 0;
      this.lastWeights.splice(0);
      var remainder = this.vLayoutData.length % this.GridInfo.spanCount;
      for (let i = 0; i < remainder; i++) {
        this.lastWeights.push(this.GridInfo.weights[i]);
        this.lastWeightSum += this.GridInfo.weights[i];
      }
      if (this.lastWeightSum == 0) {
        this.weightsCommonMultiple = this.smallestCommons([this.weightsSum]);
      } else {
        this.weightsCommonMultiple = this.smallestCommons([this.weightsSum, this.lastWeightSum]);
      }
      for (var i = 0; i < this.weightsCommonMultiple; i++) {
        this.columnsTemplate = this.columnsTemplate + "1fr ";
      }
    } else {
      for (var i = 0; i < this.GridInfo.weights.length; i++) {
        this.columnsTemplate = this.columnsTemplate + this.GridInfo.weights[i] + "fr ";
      }
    }
    if (this.GridInfo.autoExpand) {
      console.error('GridLayoutHelper: ' + 'lastWeights =' + this.lastWeights.toString() + ' and weights 的最小公倍数=' + this.weightsCommonMultiple);
    } else {
      console.error('GridLayoutHelper: ' + 'columnsTemplate = ' + this.columnsTemplate);
    }
  }

  /**
   * 求最一个集合中所有数的小公倍数
   * @param arr 需要求最小公倍数的集合
   */
  private smallestCommons(arr: Array<number>): number {
    var minCom = arr[0];
    var divisor = 1;
    for (var i = 1; i < arr.length; i++) {
      var j = 2;
      var prev = minCom;
      var after = arr[i];

      var flag = false;
      if (prev % after != 0 && after % prev != 0) {
        while (j < prev && j < after) {
          if (prev % j == 0 && after % j == 0) {
            flag = true;
            divisor *= j;
            prev = prev / j;
            after = after / j;
            j = 1;
          }
          j++;
        }
        if (flag) {
          minCom *= (arr[i] / divisor);
        } else {
          minCom *= arr[i]
        }
      } else if (after % prev == 0) {
        minCom = after;
      }
    }
    return minCom;
  }

  /**
   * 将数字转换为百分比数字
   * @param num 数字
   */
  private toPercent(num): string {
    let str = Number(num).toFixed(0);
    str += '%';
    return str;
  }

  /**
   * 计算条目所占的权重
   * @param start 起始位置
   * @param num 需要统计的数量
   */
  private getWeight(start: number, num: number): number {
    let wi = 0
    for (var i = 0;i < num; i++) {
      wi += this.GridInfo.weights[(start + i)%this.GridInfo.weights.length];
    }
    return wi;
  }
}