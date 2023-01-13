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

import { GridAttributes } from './VLayoutAttributes'

const TAG = 'vlayout GRID_LAYOUT'

@Component
export struct GRID_LAYOUT{
  @BuilderParam vLayoutContent: (item?, position?, gridItemHeight?) => any //布局
  vLayoutData: any[] = [] // 数据源
  @Watch('defaultValueInit')@State vLayoutAttribute?:GridAttributes = {}//属性
  @State private gridInfo: GridAttributes={}//属性

  private columnsTemplate: string//列
  private rowsTemplate: string//行
  @State private oneRowHeight: number = undefined //单行高度
  @State private layoutHeight: number = undefined //grid高度
  @State private rightPadding: number = undefined //右内边距
  private gridWidth:number = 0
  private gridHeight:number =0;
  private gridItemWidth:number = 0
  private gridItemHeight:number = 0

  aboutToAppear(){
    this.defaultValueInit()
  }

  defaultValueInit(){
    this.gridInfo = {
      range: this.vLayoutAttribute.range == undefined ? []: this.vLayoutAttribute.range,
      spanCount: this.vLayoutAttribute.spanCount,
      weights: this.vLayoutAttribute.weights,
      autoExpand: this.vLayoutAttribute.autoExpand == undefined ? true : this.vLayoutAttribute.autoExpand,
      aspectRatio: this.vLayoutAttribute.aspectRatio == undefined ? 0 : this.vLayoutAttribute.aspectRatio,
      layoutHeight: this.vLayoutAttribute.layoutHeight,
      bgColor: this.vLayoutAttribute.bgColor == undefined ? 'rgba(0,0,0,0)': this.vLayoutAttribute.bgColor,
      zIndex: this.vLayoutAttribute.zIndex == undefined ? 0: this.vLayoutAttribute.zIndex,
      gap: this.vLayoutAttribute.gap == undefined ? 0: this.vLayoutAttribute.gap,
      vGap: this.vLayoutAttribute.vGap == undefined ? 0: this.vLayoutAttribute.vGap,
      hGap: this.vLayoutAttribute.hGap == undefined ? 0: this.vLayoutAttribute.hGap,
      padding: this.vLayoutAttribute.padding == undefined ? [] : this.vLayoutAttribute.padding,
      topPadding: this.vLayoutAttribute.topPadding == undefined ? 0 : this.vLayoutAttribute.topPadding,
      rightPadding: this.vLayoutAttribute.rightPadding == undefined ? 0 : this.vLayoutAttribute.rightPadding,
      bottomPadding: this.vLayoutAttribute.bottomPadding == undefined ? 0 : this.vLayoutAttribute.bottomPadding,
      leftPadding: this.vLayoutAttribute.leftPadding == undefined ? 0 : this.vLayoutAttribute.leftPadding,
      margin: this.vLayoutAttribute.margin == undefined ? [] : this.vLayoutAttribute.margin,
      topMargin: this.vLayoutAttribute.topMargin == undefined ? 0 : this.vLayoutAttribute.topMargin,
      rightMargin: this.vLayoutAttribute.rightMargin == undefined ? 0 : this.vLayoutAttribute.rightMargin,
      bottomMargin: this.vLayoutAttribute.bottomMargin == undefined ? 0 : this.vLayoutAttribute.bottomMargin,
      leftMargin: this.vLayoutAttribute.leftMargin == undefined ? 0 : this.vLayoutAttribute.leftMargin
    }
    if(this.gridInfo.gap > 0){
      this.gridInfo.vGap = this.gridInfo.gap
      this.gridInfo.hGap = this.gridInfo.gap
    }
    if(this.gridInfo.padding.length == 4){
      this.gridInfo.topPadding = this.gridInfo.padding[0]
      this.gridInfo.rightPadding = this.gridInfo.padding[1]
      this.gridInfo.bottomPadding = this.gridInfo.padding[2]
      this.gridInfo.leftPadding = this.gridInfo.padding[3]
    }
    if(this.gridInfo.margin.length == 4){
      this.gridInfo.topMargin = this.gridInfo.margin[0]
      this.gridInfo.rightMargin = this.gridInfo.margin[1]
      this.gridInfo.bottomMargin = this.gridInfo.margin[2]
      this.gridInfo.leftMargin = this.gridInfo.margin[3]
    }
    this.computedSpanCountAndWeights()
    this.computedRange()
    this.computedColumnsTemplate()
    this.computedRowsTemplate()
    this.computedHeight()
  }

  computedSpanCountAndWeights(){
    if(this.gridInfo.spanCount == undefined && this.gridInfo.weights == undefined){
      this.gridInfo.spanCount = 4
      this.gridInfo.weights = [25,25,25,25]
    }else if(this.gridInfo.spanCount == undefined && this.gridInfo.weights != undefined){
      this.gridInfo.spanCount = this.gridInfo.weights.length
    }else{
      this.gridInfo.spanCount = this.gridInfo.spanCount
    }
  }

  computedRange(){
    // 可显示的条目range数组长度为2并且数组元素内的第一项大于等于并且第二项大于第一项
    if(this.gridInfo.range.length == 2 && this.gridInfo.range[0] >= 0 && this.gridInfo.range[1] > this.gridInfo.range[0]){
      this.vLayoutData = this.vLayoutData.splice(this.gridInfo.range[0], this.gridInfo.range[1])
    }else{
      this.vLayoutData = this.vLayoutData
    }
    console.info(TAG + 'vLayoutData='+ JSON.stringify(this.vLayoutData))
  }

  computedColumnsTemplate(){
    let rightPadding = 0
    let element = 0
    let cols = []
    if(this.gridInfo.weights != undefined) {
      if(this.gridInfo.weights.length == this.gridInfo.spanCount){
        for(let i=0;i<this.gridInfo.weights.length;i++){
          cols.push(this.gridInfo.weights[i]+'fr')
          element += this.gridInfo.weights[i]
        }
        if(element < 100){
          rightPadding = (100- element) * 0.01 * this.gridWidth
        }else{
          rightPadding = 0
        }
        this.computedRightPadding(rightPadding)
        this.columnsTemplate = cols.join(' ')
      }else if(this.gridInfo.weights.length < this.gridInfo.spanCount){
        for(let i=0; i< this.gridInfo.weights.length; i++){
          cols.push(this.gridInfo.weights[i]+'fr')
          element += this.gridInfo.weights[i]
        }
        if(element < 100){
          for(let j=0; j< this.gridInfo.spanCount- this.gridInfo.weights.length; j++){
            cols.push((100-element)/(this.gridInfo.spanCount-this.gridInfo.weights.length)+'fr')
          }
          this.computedRightPadding(rightPadding)
          this.columnsTemplate = cols.join(' ')
        }else{
          this.computedRightPadding(rightPadding)
          this.columnsTemplate = cols.join(' ')
        }
      }else{ // 当weights数组长度大于列数时,若数组内前三项元素之和小于100 则进行空出
        for(let i=0;i<this.gridInfo.spanCount; i++) {
          cols.push(this.gridInfo.weights[i] + 'fr')
          element+=this.gridInfo.weights[i]
        }
        if(element < 100){
          rightPadding = (100-element) * 0.01 * this.gridWidth
        }else{
          rightPadding = 0
        }
        this.computedRightPadding(rightPadding)
        this.columnsTemplate = cols.join(' ')
      }
    }else{ // 当weight未定义时候，autoExpand才有效
      for(let i=0;i<this.gridInfo.spanCount; i++){
        element = 100/this.gridInfo.spanCount
        cols.push(element+'fr')
      }
      this.computedRightPadding(rightPadding)
      this.columnsTemplate = cols.join(' ')
      //autoExpand为true时，余下宽度自适配
      if(this.gridInfo.autoExpand){
        let mod = this.vLayoutData.length % cols.length //余子项目
        if(mod == 0){
          this.computedRightPadding(rightPadding)
          this.columnsTemplate = cols.join(' ')
        }else {
          let newCols = []
          let temp = this.gridInfo.spanCount * mod // 列数和余子项数的公倍数
          for(let i=0; i< temp; i++){
            newCols.push((100/temp).toFixed(2)+'fr')
          }
          for(let j=0; j<this.vLayoutData.length - mod; j++){
            this.vLayoutData[j] = {
              layoutText:`${this.vLayoutData[j].layoutText}`,
              columnStart: 1,
              colsSpan: mod
            }
          }
          for(let k=this.vLayoutData.length-mod; k<this.vLayoutData.length; k++){
            this.vLayoutData[k] = {
              layoutText:`${this.vLayoutData[k].layoutText}}`,
              columnStart:1,
              colsSpan: temp/mod
            }
          }
          this.computedRightPadding(rightPadding)
          this.columnsTemplate = newCols.join(' ')
        }
        let count = Math.ceil(this.vLayoutData.length / this.gridInfo.spanCount)
        let rows = []
        rows.push('1fr'.repeat(count))
        this.rowsTemplate = rows.join(' ')
      }else{
        console.error(TAG +'autoExpand false')
      }
    }
  }

  computedRightPadding(rightPadding: number){
    let temp = 0
    if(typeof(this.gridInfo.rightPadding)=='string' && this.gridInfo.rightPadding != '' && this.gridInfo.rightPadding.includes('%')){
      temp = Number(this.gridInfo.rightPadding.substring(0, this.gridInfo.rightPadding.indexOf('%')))*0.01*this.gridWidth
    }else{
      temp = Number(this.gridInfo.rightPadding)
    }
    this.rightPadding = temp + rightPadding
  }

  computedRowsTemplate(){
    let sum = 0
    let temp = 0
    for(let i=0;i<this.vLayoutData.length;i++){
     if(this.vLayoutData[i].colsSpan > this.gridInfo.spanCount){
       this.vLayoutData[i].colsSpan = this.gridInfo.spanCount
     }else if(this.vLayoutData[i].colsSpan < 1){
       this.vLayoutData[i].colsSpan = 1
     }else{
       console.info(TAG + 'colsSpan ='+this.vLayoutData[i].colsSpan)
     }
      let colsSpan = 0
      if(this.vLayoutData[i].colsSpan == undefined){
        colsSpan = 1
      }  else{
        colsSpan = this.vLayoutData[i].colsSpan
      }
      sum = sum+colsSpan
      if(temp + colsSpan > this.gridInfo.spanCount){
        sum = sum + this.gridInfo.spanCount - temp
        temp = colsSpan
      }else{
        temp = temp + colsSpan
      }
    }
    let count = Math.ceil(sum/this.gridInfo.spanCount)
    let rows=[]
    rows.push('1fr '.repeat(count))
    this.rowsTemplate = rows.join(' ')
  }

  /**
   * 1.当layoutHeight未定义并且aspectRatio等于0或未定义时,宫格不进行内部滑动，高度自适应
   * 2.layoutHeight未定义aspectRatio大于0时,请不要再提供组件高度
   * 3.layoutHeight定义了并且aspectRatio大于0时，请不要再提供组件高度
   * 4.当layoutHeight定义了并且aspectRatio等于0，grid总高度等于给定的高度，如需要宫格可以进行内部华东，那么使用者提供的组件高度的综合必须大于layoutHeight
   * vlayout原库,当单行纵横比>0时，使用者传递的组件的高度无效
   * 异常情况：同时提供了aspectRatio以及使用者提供的组件高度的情况下，会出现布局异常
   * 滑动冲突问题：grid无rowsTemplate属性时表示grid可以进行内部滑动，但嵌套在list里面时候，一旦list能开始滑动之后grid的内部滑动就失效了
   */
  computedHeight(){
    let rowCount = this.rowsTemplate.length / 4
    if(this.gridInfo.layoutHeight == undefined && this.gridInfo.aspectRatio == 0){
      this.layoutHeight = this.gridItemHeight * rowCount
      this.computedExtraHeight(rowCount)
      console.log(TAG + 'the first case layoutHeight =' + this.layoutHeight)
    }else if(this.gridInfo.layoutHeight == undefined && this.gridInfo.aspectRatio > 0){
      this.oneRowHeight = this.gridWidth/this.gridInfo.aspectRatio
      this.layoutHeight = this.oneRowHeight * rowCount
      this.computedExtraHeight(rowCount)
      console.log(TAG + 'the second case oneRowHeight = '+this.oneRowHeight + ', layoutHeight = '+this.layoutHeight)
    }else if(this.gridInfo.layoutHeight != undefined && this.gridInfo.aspectRatio > 0){
      this.oneRowHeight = this.gridWidth / this.gridInfo.aspectRatio
      console.log(TAG + 'the third case oneRowHeight = '+this.oneRowHeight + ', layoutHeight = '+this.layoutHeight)
    }else if(this.gridInfo.layoutHeight != undefined && this.gridInfo.aspectRatio == 0){
      this.gridInfo.layoutHeight = this.gridInfo.layoutHeight
      console.log(TAG + 'the fourth case  layoutHeight = '+this.gridInfo.layoutHeight)
    }else{
      console.error(TAG + 'something else computedHeight')
    }
  }

  computedExtraHeight(rowCount:number){
    if(this.gridInfo.vGap >=0 && typeof(this.gridInfo.vGap) == 'number'){
      this.layoutHeight = this.layoutHeight+this.gridInfo.vGap*rowCount
    }
    if(this.gridInfo.topPadding >= 0 && typeof(this.gridInfo.topPadding) == 'number'){
      this.layoutHeight = this.layoutHeight+this.gridInfo.topPadding
    }else if(typeof(this.gridInfo.topPadding) == 'string' && this.gridInfo.topPadding != '' && this.gridInfo.topPadding.includes('%')){
      let topPadding = Number(this.gridInfo.topPadding.substring(0, this.gridInfo.topPadding.indexOf('%')))*0.01 * this.layoutHeight
      this.layoutHeight = this.layoutHeight + topPadding
    }else{
      console.error(TAG+ 'something else topPadding')
    }
    if(this.gridInfo.bottomPadding >=0 && typeof (this.gridInfo.bottomPadding) == 'number'){
      this.layoutHeight = this.layoutHeight + this.gridInfo.bottomPadding
    }else if(typeof(this.gridInfo.bottomPadding) == 'string' && this.gridInfo.bottomPadding != '' && this.gridInfo.bottomPadding.includes('%')){
      let bottomPadding = Number(this.gridInfo.bottomPadding.substring(0, this.gridInfo.bottomPadding.indexOf('%'))) * 0.01 * this.layoutHeight
      this.layoutHeight = this.layoutHeight + bottomPadding
    }else{
      console.error(TAG + 'something else bottomPadding')
    }
  }

  build(){
    Column(){
      Grid(){
        ForEach(this.vLayoutData, (item: any, position: number)=>{
          GridItem(){
          this.vLayoutContent(item,position, this.oneRowHeight)
        }
          .onAreaChange((oldValue,newValue)=>{
            this.gridItemWidth = (Number(newValue.width))
            this.gridItemHeight = (Number(newValue.height))
            this.computedHeight()
            console.info(TAG + 'GridItem gridItemWidth ='+this.gridItemWidth + ', gridItemHeight ='+this.gridItemHeight)
          })
          .height(this.oneRowHeight)
          .columnStart(1)
          .columnEnd(Number(`${item.colsSpan}`) < 1 ? 1: Number(`${item.colsSpan}`) > this.gridInfo.spanCount ? this.gridInfo.spanCount: Number(`${item.colsSpan}`))
        })
      }
      .onAreaChange((oldValue, newValue)=>{
        this.gridWidth = (Number(newValue.width))
        this.gridHeight = (Number(newValue.height))
        this.computedColumnsTemplate()
        console.info(TAG+'Grid gridWidth='+this.gridWidth+', gridHeight='+this.gridHeight)
      })
      .width(undefined)
      .height(this.gridInfo.layoutHeight == undefined ? this.layoutHeight : this.gridInfo.layoutHeight)
      .columnsTemplate(this.columnsTemplate)
      .columnsGap(this.gridInfo.hGap)
      .rowsGap(this.gridInfo.vGap)
      .padding({
        top: this.gridInfo.topPadding,
        right:this.rightPadding,
        bottom:this.gridInfo.bottomPadding,
        left: this.gridInfo.leftPadding
      })
    }
    .backgroundColor(this.gridInfo.bgColor)
    .zIndex(this.gridInfo.zIndex)
    .margin({
      top: this.gridInfo.topMargin,
      right: this.gridInfo.rightMargin,
      bottom: this.gridInfo.bottomMargin,
      left: this.gridInfo.leftMargin
    })
  }
}