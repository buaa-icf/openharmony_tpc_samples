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

import { AbstractFullFillAttributes } from './VLayoutAttributes'

const TAG = 'vlayout ONEN_LAYOUT '

@Component
export struct ONEN_LAYOUT {
  @BuilderParam vLayoutContent: (item?) => any //布局
  vLayoutData: any[] = [] //数据源
  @Watch('defaultValueInit') @State vLayoutAttribute?: AbstractFullFillAttributes = {} //属性
  @State private onePlusNInfo: AbstractFullFillAttributes = {} //属性

  @State private colWeightArray: number[] = [] //列权重
  @State private rowWeightArray: number[] = [] //行权重
  @State private layoutHeight: number = undefined //一拖n布局的高度
  private itemWidth: number = 0; //每个item的宽度
  private itemHeight: number = 0; //第一个item的高度
  private itemHeight1: number = 0; //第2个item的高度
  private itemHeight2: number = 0; //第3个item的高度
  private itemHeight3: number = 0; //第4个item的高度
  private itemHeight4: number = 0; //第5个item的高度

  aboutToAppear() {
    this.defaultValueInit()
  }

  defaultValueInit() {
    this.onePlusNInfo = {
      range: this.vLayoutAttribute.range == undefined ? [] : this.vLayoutAttribute.range,
      rowWeights: this.vLayoutAttribute.rowWeights == undefined || this.vLayoutAttribute.rowWeights.length == 0 ? [] : this.vLayoutAttribute.rowWeights,
      colWeights: this.vLayoutAttribute.colWeights == undefined || this.vLayoutAttribute.colWeights.length == 0 ? [] : this.vLayoutAttribute.colWeights,
      hasHeader: this.vLayoutAttribute.hasHeader == undefined ? false : this.vLayoutAttribute.hasHeader,
      hasFooter: this.vLayoutAttribute.hasFooter == undefined ? false : this.vLayoutAttribute.hasFooter,
      layoutWidth: this.vLayoutAttribute.layoutWidth,
      layoutHeight: this.vLayoutAttribute.layoutHeight,
      aspectRatio: this.vLayoutAttribute.aspectRatio,
      bgColor: this.vLayoutAttribute.bgColor == undefined ? 'rgba(0,0,0,0)' : this.vLayoutAttribute.bgColor,
      zIndex: this.vLayoutAttribute.zIndex == undefined ? 0 : this.vLayoutAttribute.zIndex,
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
    if (this.onePlusNInfo.padding.length == 4) {
      this.onePlusNInfo.topPadding = this.onePlusNInfo.padding[0]
      this.onePlusNInfo.rightPadding = this.onePlusNInfo.padding[1]
      this.onePlusNInfo.bottomPadding = this.onePlusNInfo.padding[2]
      this.onePlusNInfo.leftPadding = this.onePlusNInfo.padding[3]
    }
    if (this.onePlusNInfo.margin.length == 4) {
      this.onePlusNInfo.topMargin = this.onePlusNInfo.margin[0]
      this.onePlusNInfo.rightMargin = this.onePlusNInfo.margin[1]
      this.onePlusNInfo.bottomMargin = this.onePlusNInfo.margin[2]
      this.onePlusNInfo.leftMargin = this.onePlusNInfo.margin[3]
    }
    this.computedRange()
    this.computedColWeights()
    this.computedRowWeights()
  }

  computedRange() {
    //可显示的条目range数组长度为2并且数组元素第一项大于等于0并且第二项大于第一项
    if (this.onePlusNInfo.range.length == 2 && this.onePlusNInfo.range[0] >= 0 && this.onePlusNInfo.range[1] > this.onePlusNInfo.range[0]) {
      this.vLayoutData = this.vLayoutData.splice(this.onePlusNInfo.range[0], this.onePlusNInfo.range[1])
    } else {
      this.vLayoutData = this.vLayoutData
    }
    console.info(TAG + 'vLayoutData = ' + JSON.stringify(this.vLayoutData))
  }

  computedColWeights() {
    this.colWeightArray = this.onePlusNInfo.colWeights
    if (this.vLayoutData.length > this.onePlusNInfo.colWeights.length) { // 数据源数组长度大于列权重数组长度时
      if (this.onePlusNInfo.colWeights.length == 1) {
        let sum = 0
        for (let i = 0; i < this.onePlusNInfo.colWeights.length; i++) {
          let element = this.onePlusNInfo.colWeights[i];
          sum += element
        }
        if (this.vLayoutData.length == 2) {
          if (sum <= 100) {
            this.colWeightArray.push(100 - sum)
          }
        }
        if (this.vLayoutData.length == 3) {
          if (sum <= 100) {
            for (let j = 0; j < 2; j++) {
              this.colWeightArray.push(100 - sum)
            }
          }
        }
        if (this.vLayoutData.length == 4) {
          if (sum < 100) {
            this.colWeightArray.push(100 - sum)
            for (let j = 0; j < 2; j++) {
              this.colWeightArray.push((100 - sum) / 2)
            }
          }
        }
        if (this.vLayoutData.length == 5) {
          if (sum < 100) {
            this.colWeightArray.push(100 - sum)
            for (let j = 0; j < 3; j++) {
              this.colWeightArray.push((100 - sum) / 3)
            }
          }
        }
      } else if (this.onePlusNInfo.colWeights.length == 2) {
        if (this.vLayoutData.length == 3) {
          this.colWeightArray.push(100 - this.colWeightArray[0])
        }
        if (this.vLayoutData.length == 4) {
          for (let j = 0; j < 2; j++) {
            this.colWeightArray.push((100 - this.colWeightArray[0]) / 2)
          }
        }
        if (this.vLayoutData.length == 5) {
          for (let j = 0; j < 3; j++) {
            this.colWeightArray.push((100 - this.colWeightArray[0]) / 3)
          }
        }
      } else if (this.onePlusNInfo.colWeights.length == 3) {
        if (this.vLayoutData.length == 4) {
          this.colWeightArray.push(100 - this.colWeightArray[0] - this.colWeightArray[2])
        }
        if (this.vLayoutData.length == 5) {
          for (let j = 0; j < 2; j++) {
            this.colWeightArray.push((100 - this.colWeightArray[0] - this.colWeightArray[2]) / 2)
          }
        }
      } else if (this.onePlusNInfo.colWeights.length == 4) {
        if (this.vLayoutData.length == 5) {
          this.colWeightArray.push(100 - this.colWeightArray[0] - this.colWeightArray[2] - this.colWeightArray[3])
        }
      } else {
        console.error(TAG + 'computedColWeights else')
      }
      console.info(TAG + '> colWeightArray =' + JSON.stringify(this.colWeightArray))
    } else { //数据源数组长度小于等于列权重数组长度时
      console.info(TAG + '<= colWeightArray =' + JSON.stringify(this.colWeightArray))
    }
  }

  computedRowWeights() {
    this.rowWeightArray = this.onePlusNInfo.rowWeights
    if (this.onePlusNInfo.rowWeights.length == 1) {
      if (this.vLayoutData.length == 3 || this.vLayoutData.length == 4 || this.vLayoutData.length == 5) {
        this.rowWeightArray.push(this.onePlusNInfo.rowWeights[0])
      }
    } else {
      console.error(TAG + 'computedRowWeights else')
    }
    console.info(TAG + 'rowWeightArray =' + JSON.stringify(this.rowWeightArray))
  }

  computedSize() {
    //当容器宽度定义了，无法同时给左右外边距
    //当容器纵横比定义了就相当于容器宽度定义了
    if (this.onePlusNInfo.layoutWidth == undefined && this.onePlusNInfo.layoutHeight == undefined && this.onePlusNInfo.aspectRatio == undefined) {
      //当不设置容器宽度、高度、纵横比时，子项请勿提供百分比的高度，请提供数值的高度；
      this.onePlusNInfo.layoutWidth = undefined
      this.onePlusNInfo.layoutHeight = undefined
      this.onePlusNInfo.aspectRatio = undefined
      this.computedLayoutHeight()
    } else if (this.onePlusNInfo.layoutWidth != undefined && this.onePlusNInfo.layoutHeight == undefined && this.onePlusNInfo.aspectRatio == undefined) {
      //当设置容器宽度、不设置高度、纵横比，子项请勿提供百分比高度，请提供数值高度；
      this.onePlusNInfo.layoutWidth = this.onePlusNInfo.layoutWidth
      this.onePlusNInfo.layoutHeight = undefined
      this.onePlusNInfo.aspectRatio = undefined
      this.computedLayoutHeight()
    } else if (this.onePlusNInfo.layoutWidth == undefined && this.onePlusNInfo.layoutHeight != undefined && this.onePlusNInfo.aspectRatio == undefined) {
      this.onePlusNInfo.layoutWidth = undefined
      this.onePlusNInfo.layoutHeight = this.onePlusNInfo.layoutHeight
      this.onePlusNInfo.aspectRatio = undefined
    } else if (this.onePlusNInfo.layoutWidth == undefined && this.onePlusNInfo.layoutHeight == undefined && this.onePlusNInfo.aspectRatio != undefined) {
      //当不设置容器宽度、不设置高度、设置了纵横比，子项请勿提供百分比高度，请提供数值高度；
      this.onePlusNInfo.layoutWidth = undefined
      this.onePlusNInfo.layoutHeight = undefined
      this.onePlusNInfo.aspectRatio = this.onePlusNInfo.aspectRatio
      this.computedLayoutHeight()
    } else if (this.onePlusNInfo.layoutWidth != undefined && this.onePlusNInfo.layoutHeight != undefined && this.onePlusNInfo.aspectRatio != undefined) {
      //当设置容器宽度、高度、纵横比，子项请提供百分比高度，请不要提供数值高度；
      this.onePlusNInfo.layoutWidth = this.onePlusNInfo.layoutWidth
      this.onePlusNInfo.layoutHeight = this.onePlusNInfo.layoutHeight
      this.onePlusNInfo.aspectRatio = this.onePlusNInfo.aspectRatio
    } else if (this.onePlusNInfo.layoutWidth != undefined && this.onePlusNInfo.layoutHeight != undefined && this.onePlusNInfo.aspectRatio == undefined) {
      //当设置容器宽度、高度、不设置纵横比，子项请提供百分比高度，请不要提供数值高度；
      this.onePlusNInfo.layoutWidth = this.onePlusNInfo.layoutWidth
      this.onePlusNInfo.layoutHeight = this.onePlusNInfo.layoutHeight
      this.onePlusNInfo.aspectRatio = undefined
    } else if (this.onePlusNInfo.layoutWidth != undefined && this.onePlusNInfo.layoutHeight == undefined && this.onePlusNInfo.aspectRatio != undefined) {
      //当设置容器宽度、纵横比、不设置高度，子项不建议提供百分比高度，请提供数值高度；
      this.onePlusNInfo.layoutWidth = this.onePlusNInfo.layoutWidth
      this.onePlusNInfo.layoutHeight = undefined
      this.onePlusNInfo.aspectRatio = this.onePlusNInfo.aspectRatio
      this.computedLayoutHeight()
    } else if (this.onePlusNInfo.layoutWidth == undefined && this.onePlusNInfo.layoutHeight != undefined && this.onePlusNInfo.aspectRatio != undefined) {
      //当设置容器纵横比、高度、不设置宽度，子项不建议提供百分比高度，请提供数值高度；
      this.onePlusNInfo.layoutWidth = undefined
      this.onePlusNInfo.layoutHeight = this.onePlusNInfo.layoutHeight
      this.onePlusNInfo.aspectRatio = this.onePlusNInfo.aspectRatio
    } else {
      console.error(TAG + ' computedSize else')
    }
  }

  computedLayoutHeight() {
    if (this.vLayoutData.length == 1) {
      this.layoutHeight = this.itemHeight
    } else if (this.vLayoutData.length == 2) {
      this.layoutHeight = Math.max(this.itemHeight1, this.itemHeight2)
    } else if (this.vLayoutData.length == 3) {
      if (this.vLayoutAttribute.hasHeader && !this.vLayoutAttribute.hasFooter) {
        this.layoutHeight = Math.max(this.itemHeight1, this.itemHeight2) + this.itemHeight
      } else if (!this.vLayoutAttribute.hasHeader && this.vLayoutAttribute.hasFooter) {
        this.layoutHeight = Math.max(this.itemHeight, this.itemHeight1) + this.itemHeight2
      } else if (this.vLayoutAttribute.hasHeader && this.vLayoutAttribute.hasFooter) {
        this.layoutHeight = this.itemHeight + this.itemHeight1 + this.itemHeight2
      } else {
        if (this.itemHeight1 + this.itemHeight2 >= this.itemHeight) {
          this.layoutHeight = this.itemHeight1 + this.itemHeight2
        } else {
          this.layoutHeight = Math.max(this.itemHeight, this.itemHeight1, this.itemHeight2)
        }
      }
    } else if (this.vLayoutData.length == 4) {
      if (this.vLayoutAttribute.hasHeader && !this.vLayoutAttribute.hasFooter) {
        if (this.itemHeight1 >= this.itemHeight2 + this.itemHeight3) {
          this.layoutHeight = this.itemHeight + this.itemHeight1
        } else {
          this.layoutHeight = this.itemHeight + this.itemHeight2 + this.itemHeight3
        }
      } else if (!this.vLayoutAttribute.hasHeader && this.vLayoutAttribute.hasFooter) {
        if (this.itemHeight1 + this.itemHeight2 >= this.itemHeight) {
          this.layoutHeight = this.itemHeight1 + this.itemHeight2 + this.itemHeight3
        } else {
          this.layoutHeight = this.itemHeight + this.itemHeight3
        }
      } else if (this.vLayoutAttribute.hasHeader && this.vLayoutAttribute.hasFooter) {
        this.layoutHeight = this.itemHeight + Math.max(this.itemHeight1, this.itemHeight2) + this.itemHeight3
      } else {
        if (this.itemHeight1 + Math.max(this.itemHeight2, this.itemHeight3) >= this.itemHeight) {
          this.layoutHeight = this.itemHeight1 + Math.max(this.itemHeight2, this.itemHeight3)
        } else {
          this.layoutHeight = Math.max(this.itemHeight, this.itemHeight1, this.itemHeight2, this.itemHeight3)
        }
      }
    } else if (this.vLayoutData.length == 5) {
      if (this.vLayoutAttribute.hasHeader && !this.vLayoutAttribute.hasFooter) {
        if (this.itemHeight2 + Math.max(this.itemHeight3, this.itemHeight4) >= this.itemHeight1) {
          this.layoutHeight = this.itemHeight + this.itemHeight2 + Math.max(this.itemHeight3, this.itemHeight4)
        } else {
          this.layoutHeight = this.itemHeight + this.itemHeight1
        }
      } else if (!this.vLayoutAttribute.hasHeader && this.vLayoutAttribute.hasFooter) {
        if (this.itemHeight1 + Math.max(this.itemHeight2, this.itemHeight3) >= this.itemHeight) {
          this.layoutHeight = this.itemHeight1 + Math.max(this.itemHeight2, this.itemHeight3) + this.itemHeight4
        } else {
          this.layoutHeight = this.itemHeight + this.itemHeight4
        }
      } else if (this.vLayoutAttribute.hasHeader && this.vLayoutAttribute.hasFooter) {
        if (this.itemHeight2 + this.itemHeight3 >= this.itemHeight1) {
          this.layoutHeight = this.itemHeight + this.itemHeight2 + this.itemHeight3 + this.itemHeight4
        } else {
          this.layoutHeight = this.itemHeight + this.itemHeight1 + this.itemHeight4
        }
      } else {
        if (this.itemHeight1 + Math.max(this.itemHeight2, this.itemHeight3, this.itemHeight4) >= this.itemHeight) {
          this.layoutHeight = this.itemHeight1 + Math.max(this.itemHeight2, this.itemHeight3, this.itemHeight4)
        } else {
          this.layoutHeight = Math.max(this.itemHeight, this.itemHeight1, this.itemHeight2, this.itemHeight3, this.itemHeight4)
        }
      }
    } else {
      console.error(TAG + 'computedLayoutHeight else')
    }
    this.computedExtraHeight()
  }

  computedExtraHeight() {
    if (this.onePlusNInfo.topPadding >= 0 && typeof (this.onePlusNInfo.topPadding) == 'number') {
      this.layoutHeight = this.layoutHeight + this.onePlusNInfo.topPadding
    } else if (typeof (this.onePlusNInfo.topPadding) == 'string' && this.onePlusNInfo.topPadding != '' && this.onePlusNInfo.topPadding.includes('%')) {
      let topPadding = Number(this.onePlusNInfo.topPadding.substring(0, this.onePlusNInfo.topPadding.indexOf('%'))) * 0.01 * this.layoutHeight
      this.layoutHeight = this.layoutHeight + topPadding
    } else {
      console.error(TAG + 'something else topPadding')
    }
    if (this.onePlusNInfo.bottomPadding >= 0 && typeof (this.onePlusNInfo.bottomPadding) == 'number') {
      this.layoutHeight = this.layoutHeight + this.onePlusNInfo.bottomPadding
    } else if (typeof (this.onePlusNInfo.bottomPadding) == 'string' && this.onePlusNInfo.bottomPadding != '' && this.onePlusNInfo.bottomPadding.includes('%')) {
      let bottomPadding = Number(this.onePlusNInfo.bottomPadding.substring(0, this.onePlusNInfo.bottomPadding.indexOf('%'))) * 0.01 * this.layoutHeight
      this.layoutHeight = this.layoutHeight + bottomPadding
    } else {
      console.error(TAG + 'something else bottomPadding')
    }
  }

  toPercent(num) {
    let str = Number(num).toFixed(0)
    str += '%'
    return str
  }

  build() {
    Column() {
      Row() {
        if (this.vLayoutData.length == 1) {
          Row() {
            Column() {
              this.vLayoutContent(this.vLayoutData[0])
            }
            .onAreaChange((oldValue, newValue) => {
              this.itemWidth = (Number(newValue.width))
              this.itemHeight = (Number(newValue.height))
              console.error(TAG + 'itemWidth =' + this.itemWidth + ', itemHeight =' + this.itemHeight)
              this.computedSize()
            })
            .alignItems(HorizontalAlign.Start)
            .width(this.colWeightArray.length == 0 ? '100%' : this.toPercent(this.colWeightArray[0]))
          }
        } else if (this.vLayoutData.length == 2) {
          Row() {
            Column() {
              this.vLayoutContent(this.vLayoutData[0])
            }
            .onAreaChange((oldValue, newValue) => {
              this.itemWidth = (Number(newValue.width))
              this.itemHeight1 = (Number(newValue.height))
              console.error(TAG + 'itemWidth =' + this.itemWidth + ', itemHeight1 =' + this.itemHeight1)
              this.computedSize()
            })
            .alignItems(HorizontalAlign.Start)
            .width(this.colWeightArray.length == 0 ? '50%' : this.toPercent(this.colWeightArray[0]))

            Column() {
              this.vLayoutContent(this.vLayoutData[1])
            }
            .onAreaChange((oldValue, newValue) => {
              this.itemWidth = (Number(newValue.width))
              this.itemHeight2 = (Number(newValue.height))
              console.error(TAG + 'itemWidth =' + this.itemWidth + ', itemHeight2 =' + this.itemHeight2)
              this.computedSize()
            })
            .alignItems(HorizontalAlign.Start)
            .width(this.colWeightArray.length == 0 ? '50%' : this.toPercent(this.colWeightArray[1]))
          }
        } else if (this.vLayoutData.length == 3) {
          if (this.vLayoutAttribute.hasHeader && !this.vLayoutAttribute.hasFooter) {
            Column() {
              Row() {
                this.vLayoutContent(this.vLayoutData[0])
              }
              .onAreaChange((oldValue, newValue) => {
                this.itemWidth = (Number(newValue.width))
                this.itemHeight = (Number(newValue.height))
                console.error(TAG + 'itemWidth =' + this.itemWidth + ', itemHeight =' + this.itemHeight)
                this.computedSize()
              })
              .width(this.colWeightArray.length == 0 ? '100%' : this.toPercent(this.colWeightArray[0]))
              .layoutWeight(this.onePlusNInfo.layoutHeight == undefined ? undefined : (this.rowWeightArray.length == 0 ? 1 : this.rowWeightArray[0]))

              Row() {
                Column() {
                  this.vLayoutContent(this.vLayoutData[1])
                }
                .onAreaChange((oldValue, newValue) => {
                  this.itemWidth = (Number(newValue.width))
                  this.itemHeight1 = (Number(newValue.height))
                  console.error(TAG + 'itemWidth =' + this.itemWidth + ', itemHeight1 =' + this.itemHeight1)
                  this.computedSize()
                })
                .width(this.colWeightArray.length == 0 ? '50%' : this.toPercent(this.colWeightArray[1]))

                Column() {
                  this.vLayoutContent(this.vLayoutData[2])
                }
                .onAreaChange((oldValue, newValue) => {
                  this.itemWidth = (Number(newValue.width))
                  this.itemHeight2 = (Number(newValue.height))
                  console.error(TAG + 'itemWidth =' + this.itemWidth + ', itemHeight2 =' + this.itemHeight2)
                  this.computedSize()
                })
                .width(this.colWeightArray.length == 0 ? '50%' : this.toPercent(this.colWeightArray[2]))
              }
              .layoutWeight(this.onePlusNInfo.layoutHeight == undefined ? undefined : (this.rowWeightArray.length == 0 ? 1 : this.rowWeightArray[1]))
            }.alignItems(HorizontalAlign.Start)
          } else if (!this.vLayoutAttribute.hasHeader && this.vLayoutAttribute.hasFooter) {
            Column() {
              Row() {
                Column() {
                  this.vLayoutContent(this.vLayoutData[0])
                }
                .onAreaChange((oldValue, newValue) => {
                  this.itemWidth = (Number(newValue.width))
                  this.itemHeight = (Number(newValue.height))
                  console.error(TAG + 'itemWidth =' + this.itemWidth + ', itemHeight =' + this.itemHeight)
                  this.computedSize()
                })
                .width(this.colWeightArray.length == 0 ? '50%' : this.toPercent(this.colWeightArray[0]))

                Column() {
                  this.vLayoutContent(this.vLayoutData[1])
                }
                .onAreaChange((oldValue, newValue) => {
                  this.itemWidth = (Number(newValue.width))
                  this.itemHeight1 = (Number(newValue.height))
                  console.error(TAG + 'itemWidth =' + this.itemWidth + ', itemHeight1 =' + this.itemHeight1)
                  this.computedSize()
                })
                .width(this.colWeightArray.length == 0 ? '50%' : this.toPercent(this.colWeightArray[1]))
              }
              .layoutWeight(this.onePlusNInfo.layoutHeight == undefined ? undefined : (this.rowWeightArray.length == 0 ? 1 : this.rowWeightArray[0]))

              Row() {
                this.vLayoutContent(this.vLayoutData[2])
              }
              .onAreaChange((oldValue, newValue) => {
                this.itemWidth = (Number(newValue.width))
                this.itemHeight2 = (Number(newValue.height))
                console.error(TAG + 'itemWidth =' + this.itemWidth + ', itemHeight2 =' + this.itemHeight2)
                this.computedSize()
              })
              .width(this.colWeightArray.length == 0 ? '100%' : this.toPercent(this.colWeightArray[2]))
              .layoutWeight(this.onePlusNInfo.layoutHeight == undefined ? undefined : (this.rowWeightArray.length == 0 ? 1 : this.rowWeightArray[1]))
            }.alignItems(HorizontalAlign.Start)
          } else if (this.vLayoutAttribute.hasHeader && this.vLayoutAttribute.hasFooter) {
            Column() {
              Row() {
                this.vLayoutContent(this.vLayoutData[0])
              }
              .onAreaChange((oldValue, newValue) => {
                this.itemWidth = (Number(newValue.width))
                this.itemHeight = (Number(newValue.height))
                console.error(TAG + 'itemWidth =' + this.itemWidth + ', itemHeight =' + this.itemHeight)
                this.computedSize()
              })
              .width(this.colWeightArray.length == 0 ? '100%' : this.toPercent(this.colWeightArray[0]))
              .layoutWeight(this.onePlusNInfo.layoutHeight == undefined ? undefined : (this.rowWeightArray.length == 0 ? 1 : this.rowWeightArray[0]))

              Row() {
                this.vLayoutContent(this.vLayoutData[1])
              }
              .onAreaChange((oldValue, newValue) => {
                this.itemWidth = (Number(newValue.width))
                this.itemHeight1 = (Number(newValue.height))
                console.error(TAG + 'itemWidth =' + this.itemWidth + ', itemHeight1 =' + this.itemHeight1)
                this.computedSize()
              })
              .width(this.colWeightArray.length == 0 ? '100%' : this.toPercent(this.colWeightArray[1]))
              .layoutWeight(this.onePlusNInfo.layoutHeight == undefined ? undefined : (this.rowWeightArray.length == 0 ? 1 : this.rowWeightArray[1]))

              Row() {
                this.vLayoutContent(this.vLayoutData[2])
              }
              .onAreaChange((oldValue, newValue) => {
                this.itemWidth = (Number(newValue.width))
                this.itemHeight2 = (Number(newValue.height))
                console.error(TAG + 'itemWidth =' + this.itemWidth + ', itemHeight2 =' + this.itemHeight2)
                this.computedSize()
              })
              .width(this.colWeightArray.length == 0 ? '100%' : this.toPercent(this.colWeightArray[2]))
              .layoutWeight(this.onePlusNInfo.layoutHeight == undefined ? undefined : (this.rowWeightArray.length == 0 ? 1 : this.rowWeightArray[0]))
            }.alignItems(HorizontalAlign.Start)
          } else {
            Row() {
              Column() {
                this.vLayoutContent(this.vLayoutData[0])
              }
              .onAreaChange((oldValue, newValue) => {
                this.itemWidth = (Number(newValue.width))
                this.itemHeight = (Number(newValue.height))
                console.error(TAG + 'itemWidth =' + this.itemWidth + ', itemHeight =' + this.itemHeight)
                this.computedSize()
              })
              .alignItems(HorizontalAlign.Start)
              .width(this.colWeightArray.length == 0 ? '50%' : this.toPercent(this.colWeightArray[0]))

              Column() {
                Row() {
                  this.vLayoutContent(this.vLayoutData[1])
                }
                .onAreaChange((oldValue, newValue) => {
                  this.itemWidth = (Number(newValue.width))
                  this.itemHeight1 = (Number(newValue.height))
                  console.error(TAG + 'itemWidth =' + this.itemWidth + ', itemHeight1 =' + this.itemHeight1)
                  this.computedSize()
                })
                .width(this.colWeightArray.length == 0 ? '50%' : this.toPercent(this.colWeightArray[1]))
                .layoutWeight(this.onePlusNInfo.layoutHeight == undefined ? undefined : (this.rowWeightArray.length == 0 ? 1 : this.rowWeightArray[0]))

                Row() {
                  this.vLayoutContent(this.vLayoutData[2])
                }
                .onAreaChange((oldValue, newValue) => {
                  this.itemWidth = (Number(newValue.width))
                  this.itemHeight2 = (Number(newValue.height))
                  console.error(TAG + 'itemWidth =' + this.itemWidth + ', itemHeight2 =' + this.itemHeight2)
                  this.computedSize()
                })
                .width(this.colWeightArray.length == 0 ? '50%' : this.toPercent(this.colWeightArray[2]))
                .layoutWeight(this.onePlusNInfo.layoutHeight == undefined ? undefined : (this.rowWeightArray.length == 0 ? 1 : this.rowWeightArray[1]))
              }
              .alignItems(HorizontalAlign.Start)
            }
          }
        } else if (this.vLayoutData.length == 4) {
          if (this.vLayoutAttribute.hasHeader && !this.vLayoutAttribute.hasFooter) {
            Column() {
              Row() {
                this.vLayoutContent(this.vLayoutData[0])
              }
              .onAreaChange((oldValue, newValue) => {
                this.itemWidth = (Number(newValue.width))
                this.itemHeight = (Number(newValue.height))
                console.error(TAG + 'itemWidth =' + this.itemWidth + ', itemHeight =' + this.itemHeight)
                this.computedSize()
              })
              .width(this.colWeightArray.length == 0 ? '100%' : this.toPercent(this.colWeightArray[0]))
              .layoutWeight(this.onePlusNInfo.layoutHeight == undefined ? undefined : (this.rowWeightArray.length == 0 ? 1 : this.rowWeightArray[0]))

              Row() {
                Column() {
                  this.vLayoutContent(this.vLayoutData[1])
                }
                .onAreaChange((oldValue, newValue) => {
                  this.itemWidth = (Number(newValue.width))
                  this.itemHeight1 = (Number(newValue.height))
                  console.error(TAG + 'itemWidth =' + this.itemWidth + ', itemHeight1 =' + this.itemHeight1)
                  this.computedSize()
                })
                .width(this.colWeightArray.length == 0 ? '50%' : this.toPercent(this.colWeightArray[1]))

                Column() {
                  Row() {
                    this.vLayoutContent(this.vLayoutData[2])
                  }
                  .onAreaChange((oldValue, newValue) => {
                    this.itemWidth = (Number(newValue.width))
                    this.itemHeight2 = (Number(newValue.height))
                    console.error(TAG + 'itemWidth =' + this.itemWidth + ', itemHeight2 =' + this.itemHeight2)
                    this.computedSize()
                  })
                  .width(this.colWeightArray.length == 0 ? '50%' : this.toPercent(this.colWeightArray[2]))
                  .layoutWeight(this.onePlusNInfo.layoutHeight == undefined ? undefined : 1)

                  Row() {
                    this.vLayoutContent(this.vLayoutData[3])
                  }
                  .onAreaChange((oldValue, newValue) => {
                    this.itemWidth = (Number(newValue.width))
                    this.itemHeight3 = (Number(newValue.height))
                    console.error(TAG + 'itemWidth =' + this.itemWidth + ', itemHeight3 =' + this.itemHeight3)
                    this.computedSize()
                  })
                  .width(this.colWeightArray.length == 0 ? '50%' : this.toPercent(this.colWeightArray[3]))
                  .layoutWeight(this.onePlusNInfo.layoutHeight == undefined ? undefined : 1)
                }.alignItems(HorizontalAlign.Start)
              }
              .layoutWeight(this.onePlusNInfo.layoutHeight == undefined ? undefined : (this.rowWeightArray.length == 0 ? 1 : this.rowWeightArray[1]))
            }.alignItems(HorizontalAlign.Start)
          } else if (!this.vLayoutAttribute.hasHeader && this.vLayoutAttribute.hasFooter) {
            Column() {
              Row() {
                Column() {
                  this.vLayoutContent(this.vLayoutData[0])
                }
                .onAreaChange((oldValue, newValue) => {
                  this.itemWidth = (Number(newValue.width))
                  this.itemHeight = (Number(newValue.height))
                  console.error(TAG + 'itemWidth =' + this.itemWidth + ', itemHeight =' + this.itemHeight)
                  this.computedSize()
                })
                .width(this.colWeightArray.length == 0 ? '50%' : this.toPercent(this.colWeightArray[0]))

                Column() {
                  Row() {
                    this.vLayoutContent(this.vLayoutData[1])
                  }
                  .onAreaChange((oldValue, newValue) => {
                    this.itemWidth = (Number(newValue.width))
                    this.itemHeight1 = (Number(newValue.height))
                    console.error(TAG + 'itemWidth =' + this.itemWidth + ', itemHeight1 =' + this.itemHeight1)
                    this.computedSize()
                  })
                  .width(this.colWeightArray.length == 0 ? '50%' : this.toPercent(this.colWeightArray[1]))
                  .layoutWeight(this.onePlusNInfo.layoutHeight == undefined ? undefined : 1)

                  Row() {
                    this.vLayoutContent(this.vLayoutData[2])
                  }
                  .onAreaChange((oldValue, newValue) => {
                    this.itemWidth = (Number(newValue.width))
                    this.itemHeight2 = (Number(newValue.height))
                    console.error(TAG + 'itemWidth =' + this.itemWidth + ', itemHeight2 =' + this.itemHeight2)
                    this.computedSize()
                  })
                  .width(this.colWeightArray.length == 0 ? '50%' : this.toPercent(this.colWeightArray[2]))
                  .layoutWeight(this.onePlusNInfo.layoutHeight == undefined ? undefined : 1)
                }.alignItems(HorizontalAlign.Start)
              }
              .layoutWeight(this.onePlusNInfo.layoutHeight == undefined ? undefined : (this.rowWeightArray.length == 0 ? 1 : this.rowWeightArray[0]))

              Row() {
                this.vLayoutContent(this.vLayoutData[3])
              }
              .onAreaChange((oldValue, newValue) => {
                this.itemWidth = (Number(newValue.width))
                this.itemHeight3 = (Number(newValue.height))
                console.error(TAG + 'itemWidth =' + this.itemWidth + ', itemHeight3 =' + this.itemHeight3)
                this.computedSize()
              })
              .width(this.colWeightArray.length == 0 ? '100%' : this.toPercent(this.colWeightArray[3]))
              .layoutWeight(this.onePlusNInfo.layoutHeight == undefined ? undefined : (this.rowWeightArray.length == 0 ? 1 : this.rowWeightArray[1]))
            }.alignItems(HorizontalAlign.Start)
          } else if (this.vLayoutAttribute.hasHeader && this.vLayoutAttribute.hasFooter) {
            Column() {
              Row() {
                this.vLayoutContent(this.vLayoutData[0])
              }
              .onAreaChange((oldValue, newValue) => {
                this.itemWidth = (Number(newValue.width))
                this.itemHeight = (Number(newValue.height))
                console.error(TAG + 'itemWidth =' + this.itemWidth + ', itemHeight =' + this.itemHeight)
                this.computedSize()
              })
              .width(this.colWeightArray.length == 0 ? '100%' : this.toPercent(this.colWeightArray[0]))
              .layoutWeight(this.onePlusNInfo.layoutHeight == undefined ? undefined : (this.rowWeightArray.length == 0 ? 1 : this.rowWeightArray[0]))

              Row() {
                Column() {
                  this.vLayoutContent(this.vLayoutData[1])
                }
                .onAreaChange((oldValue, newValue) => {
                  this.itemWidth = (Number(newValue.width))
                  this.itemHeight1 = (Number(newValue.height))
                  console.error(TAG + 'itemWidth =' + this.itemWidth + ', itemHeight1 =' + this.itemHeight1)
                  this.computedSize()
                })
                .width(this.colWeightArray.length == 0 ? '50%' : this.toPercent(this.colWeightArray[1]))

                Column() {
                  this.vLayoutContent(this.vLayoutData[2])
                }
                .onAreaChange((oldValue, newValue) => {
                  this.itemWidth = (Number(newValue.width))
                  this.itemHeight2 = (Number(newValue.height))
                  console.error(TAG + 'itemWidth =' + this.itemWidth + ', itemHeight2 =' + this.itemHeight2)
                  this.computedSize()
                })
                .width(this.colWeightArray.length == 0 ? '50%' : this.toPercent(this.colWeightArray[2]))
              }
              .layoutWeight(this.onePlusNInfo.layoutHeight == undefined ? undefined : (this.rowWeightArray.length == 0 ? 1 : this.rowWeightArray[1]))

              Row() {
                this.vLayoutContent(this.vLayoutData[3])
              }
              .onAreaChange((oldValue, newValue) => {
                this.itemWidth = (Number(newValue.width))
                this.itemHeight3 = (Number(newValue.height))
                console.error(TAG + 'itemWidth =' + this.itemWidth + ', itemHeight3 =' + this.itemHeight3)
                this.computedSize()
              })
              .width(this.colWeightArray.length == 0 ? '100%' : this.toPercent(this.colWeightArray[3]))
              .layoutWeight(this.onePlusNInfo.layoutHeight == undefined ? undefined : (this.rowWeightArray.length == 0 ? 1 : this.rowWeightArray[0]))
            }.alignItems(HorizontalAlign.Start)
          } else {
            Row() {
              Column() {
                this.vLayoutContent(this.vLayoutData[0])
              }
              .onAreaChange((oldValue, newValue) => {
                this.itemWidth = (Number(newValue.width))
                this.itemHeight = (Number(newValue.height))
                console.error(TAG + 'itemWidth =' + this.itemWidth + ', itemHeight =' + this.itemHeight)
                this.computedSize()
              })
              .alignItems(HorizontalAlign.Start)
              .width(this.colWeightArray.length == 0 ? '50%' : this.toPercent(this.colWeightArray[0]))

              Column() {
                Column() {
                  this.vLayoutContent(this.vLayoutData[1])
                }
                .onAreaChange((oldValue, newValue) => {
                  this.itemWidth = (Number(newValue.width))
                  this.itemHeight1 = (Number(newValue.height))
                  console.error(TAG + 'itemWidth =' + this.itemWidth + ', itemHeight1 =' + this.itemHeight1)
                  this.computedSize()
                })
                .alignItems(HorizontalAlign.Start)
                .width(this.colWeightArray.length == 0 ? '50%' : this.toPercent(this.colWeightArray[1]))
                .layoutWeight(this.onePlusNInfo.layoutHeight == undefined ? undefined : (this.rowWeightArray.length == 0 ? 1 : this.rowWeightArray[0]))

                Row() {
                  Column() {
                    this.vLayoutContent(this.vLayoutData[2])
                  }
                  .onAreaChange((oldValue, newValue) => {
                    this.itemWidth = (Number(newValue.width))
                    this.itemHeight2 = (Number(newValue.height))
                    console.error(TAG + 'itemWidth =' + this.itemWidth + ', itemHeight2 =' + this.itemHeight2)
                    this.computedSize()
                  })
                  .width(this.colWeightArray.length == 0 ? '50%' : this.toPercent(this.colWeightArray[2]))

                  Column() {
                    this.vLayoutContent(this.vLayoutData[3])
                  }
                  .onAreaChange((oldValue, newValue) => {
                    this.itemWidth = (Number(newValue.width))
                    this.itemHeight3 = (Number(newValue.height))
                    console.error(TAG + 'itemWidth =' + this.itemWidth + ', itemHeight3 =' + this.itemHeight3)
                    this.computedSize()
                  })
                  .width(this.colWeightArray.length == 0 ? '50%' : this.toPercent(this.colWeightArray[3]))
                }
                .width(this.colWeightArray.length == 0 ? '50%' : '100%')
                .layoutWeight(this.onePlusNInfo.layoutHeight == undefined ? undefined : (this.rowWeightArray.length == 0 ? 1 : this.rowWeightArray[1]))
              }
              .alignItems(HorizontalAlign.Start)
            }
          }
        } else if (this.vLayoutData.length == 5) {
          if (this.vLayoutAttribute.hasHeader && !this.vLayoutAttribute.hasFooter) {
            Column() {
              Row() {
                this.vLayoutContent(this.vLayoutData[0])
              }
              .onAreaChange((oldValue, newValue) => {
                this.itemWidth = (Number(newValue.width))
                this.itemHeight = (Number(newValue.height))
                console.error(TAG + 'itemWidth =' + this.itemWidth + ', itemHeight =' + this.itemHeight)
                this.computedSize()
              })
              .width(this.colWeightArray.length == 0 ? '100%' : this.toPercent(this.colWeightArray[0]))
              .layoutWeight(this.onePlusNInfo.layoutHeight == undefined ? undefined : (this.rowWeightArray.length == 0 ? 1 : this.rowWeightArray[0]))

              Row() {
                Column() {
                  this.vLayoutContent(this.vLayoutData[1])
                }
                .onAreaChange((oldValue, newValue) => {
                  this.itemWidth = (Number(newValue.width))
                  this.itemHeight1 = (Number(newValue.height))
                  console.error(TAG + 'itemWidth =' + this.itemWidth + ', itemHeight1 =' + this.itemHeight1)
                  this.computedSize()
                })
                .width(this.colWeightArray.length == 0 ? '50%' : this.toPercent(this.colWeightArray[1]))

                Column() {
                  Row() {
                    this.vLayoutContent(this.vLayoutData[2])
                  }
                  .onAreaChange((oldValue, newValue) => {
                    this.itemWidth = (Number(newValue.width))
                    this.itemHeight2 = (Number(newValue.height))
                    console.error(TAG + 'itemWidth =' + this.itemWidth + ', itemHeight2 =' + this.itemHeight2)
                    this.computedSize()
                  })
                  .width(this.colWeightArray.length == 0 ? '50%' : this.toPercent(this.colWeightArray[2]))
                  .layoutWeight(this.onePlusNInfo.layoutHeight == undefined ? undefined : 1)

                  Row() {
                    Column() {
                      this.vLayoutContent(this.vLayoutData[3])
                    }
                    .onAreaChange((oldValue, newValue) => {
                      this.itemWidth = (Number(newValue.width))
                      this.itemHeight3 = (Number(newValue.height))
                      console.error(TAG + 'itemWidth =' + this.itemWidth + ', itemHeight3 =' + this.itemHeight3)
                      this.computedSize()
                    })
                    .width(this.colWeightArray.length == 0 ? '25%' : this.toPercent(this.colWeightArray[3]))

                    Column() {
                      this.vLayoutContent(this.vLayoutData[4])
                    }
                    .onAreaChange((oldValue, newValue) => {
                      this.itemWidth = (Number(newValue.width))
                      this.itemHeight4 = (Number(newValue.height))
                      console.error(TAG + 'itemWidth =' + this.itemWidth + ', itemHeight4 =' + this.itemHeight4)
                      this.computedSize()
                    })
                    .width(this.colWeightArray.length == 0 ? '25%' : this.toPercent(this.colWeightArray[4]))
                  }
                  .layoutWeight(this.onePlusNInfo.layoutHeight == undefined ? undefined : 1)
                }
                .alignItems(HorizontalAlign.Start)
                .layoutWeight(this.onePlusNInfo.layoutHeight == undefined ? undefined : 1)
              }
              .layoutWeight(this.onePlusNInfo.layoutHeight == undefined ? undefined : (this.rowWeightArray.length == 0 ? 1 : this.rowWeightArray[1]))
            }.alignItems(HorizontalAlign.Start)
          } else if (!this.vLayoutAttribute.hasHeader && this.vLayoutAttribute.hasFooter) {
            Column() {
              Row() {
                Column() {
                  this.vLayoutContent(this.vLayoutData[0])
                }
                .onAreaChange((oldValue, newValue) => {
                  this.itemWidth = (Number(newValue.width))
                  this.itemHeight = (Number(newValue.height))
                  console.error(TAG + 'itemWidth =' + this.itemWidth + ', itemHeight =' + this.itemHeight)
                  this.computedSize()
                })
                .width(this.colWeightArray.length == 0 ? '50%' : this.toPercent(this.colWeightArray[0]))

                Column() {
                  Row() {
                    this.vLayoutContent(this.vLayoutData[1])
                  }
                  .onAreaChange((oldValue, newValue) => {
                    this.itemWidth = (Number(newValue.width))
                    this.itemHeight1 = (Number(newValue.height))
                    console.error(TAG + 'itemWidth =' + this.itemWidth + ', itemHeight1 =' + this.itemHeight1)
                    this.computedSize()
                  })
                  .width(this.colWeightArray.length == 0 ? '50%' : this.toPercent(this.colWeightArray[1]))
                  .layoutWeight(this.onePlusNInfo.layoutHeight == undefined ? undefined : 1)

                  Row() {
                    Column() {
                      this.vLayoutContent(this.vLayoutData[2])
                    }
                    .onAreaChange((oldValue, newValue) => {
                      this.itemWidth = (Number(newValue.width))
                      this.itemHeight2 = (Number(newValue.height))
                      console.error(TAG + 'itemWidth =' + this.itemWidth + ', itemHeight2 =' + this.itemHeight2)
                      this.computedSize()
                    })
                    .width(this.colWeightArray.length == 0 ? '25%' : this.toPercent(this.colWeightArray[2]))

                    Column() {
                      this.vLayoutContent(this.vLayoutData[3])
                    }
                    .onAreaChange((oldValue, newValue) => {
                      this.itemWidth = (Number(newValue.width))
                      this.itemHeight3 = (Number(newValue.height))
                      console.error(TAG + 'itemWidth =' + this.itemWidth + ', itemHeight3 =' + this.itemHeight3)
                      this.computedSize()
                    })
                    .width(this.colWeightArray.length == 0 ? '25%' : this.toPercent(this.colWeightArray[3]))
                  }
                  .layoutWeight(this.onePlusNInfo.layoutHeight == undefined ? undefined : 1)
                }
                .alignItems(HorizontalAlign.Start)
                .layoutWeight(this.onePlusNInfo.layoutHeight == undefined ? undefined : 1)
              }
              .layoutWeight(this.onePlusNInfo.layoutHeight == undefined ? undefined : (this.rowWeightArray.length == 0 ? 1 : this.rowWeightArray[0]))

              Row() {
                this.vLayoutContent(this.vLayoutData[4])
              }
              .onAreaChange((oldValue, newValue) => {
                this.itemWidth = (Number(newValue.width))
                this.itemHeight4 = (Number(newValue.height))
                console.error(TAG + 'itemWidth =' + this.itemWidth + ', itemHeight4 =' + this.itemHeight4)
                this.computedSize()
              })
              .width(this.colWeightArray.length == 0 ? '100%' : this.toPercent(this.colWeightArray[4]))
              .layoutWeight(this.onePlusNInfo.layoutHeight == undefined ? undefined : (this.rowWeightArray.length == 0 ? 1 : this.rowWeightArray[1]))
            }.alignItems(HorizontalAlign.Start)
          } else if (this.vLayoutAttribute.hasHeader && this.vLayoutAttribute.hasFooter) {
            Column() {
              Row() {
                this.vLayoutContent(this.vLayoutData[0])
              }
              .onAreaChange((oldValue, newValue) => {
                this.itemWidth = (Number(newValue.width))
                this.itemHeight = (Number(newValue.height))
                console.error(TAG + 'itemWidth =' + this.itemWidth + ', itemHeight =' + this.itemHeight)
                this.computedSize()
              })
              .width(this.colWeightArray.length == 0 ? '100%' : this.toPercent(this.colWeightArray[0]))
              .layoutWeight(this.onePlusNInfo.layoutHeight == undefined ? undefined : (this.rowWeightArray.length == 0 ? 1 : this.rowWeightArray[0]))

              Row() {
                Column() {
                  this.vLayoutContent(this.vLayoutData[1])
                }
                .onAreaChange((oldValue, newValue) => {
                  this.itemWidth = (Number(newValue.width))
                  this.itemHeight1 = (Number(newValue.height))
                  console.error(TAG + 'itemWidth =' + this.itemWidth + ', itemHeight1 =' + this.itemHeight1)
                  this.computedSize()
                })
                .width(this.colWeightArray.length == 0 ? '50%' : this.toPercent(this.colWeightArray[1]))

                Column() {
                  Row() {
                    this.vLayoutContent(this.vLayoutData[2])
                  }
                  .onAreaChange((oldValue, newValue) => {
                    this.itemWidth = (Number(newValue.width))
                    this.itemHeight2 = (Number(newValue.height))
                    console.error(TAG + 'itemWidth =' + this.itemWidth + ', itemHeight2 =' + this.itemHeight2)
                    this.computedSize()
                  })
                  .width(this.colWeightArray.length == 0 ? '50%' : this.toPercent(this.colWeightArray[2]))
                  .layoutWeight(this.onePlusNInfo.layoutHeight == undefined ? undefined : 1)

                  Row() {
                    this.vLayoutContent(this.vLayoutData[3])
                  }
                  .onAreaChange((oldValue, newValue) => {
                    this.itemWidth = (Number(newValue.width))
                    this.itemHeight3 = (Number(newValue.height))
                    console.error(TAG + 'itemWidth =' + this.itemWidth + ', itemHeight3 =' + this.itemHeight3)
                    this.computedSize()
                  })
                  .width(this.colWeightArray.length == 0 ? '50%' : this.toPercent(this.colWeightArray[3]))
                  .layoutWeight(this.onePlusNInfo.layoutHeight == undefined ? undefined : 1)
                }
                .alignItems(HorizontalAlign.Start)
                .layoutWeight(this.onePlusNInfo.layoutHeight == undefined ? undefined : 1)
              }
              .layoutWeight(this.onePlusNInfo.layoutHeight == undefined ? undefined : (this.rowWeightArray.length == 0 ? 1 : this.rowWeightArray[1]))

              Row() {
                this.vLayoutContent(this.vLayoutData[4])
              }
              .onAreaChange((oldValue, newValue) => {
                this.itemWidth = (Number(newValue.width))
                this.itemHeight4 = (Number(newValue.height))
                console.error(TAG + 'itemWidth =' + this.itemWidth + ', itemHeight4 =' + this.itemHeight4)
                this.computedSize()
              })
              .width(this.colWeightArray.length == 0 ? '100%' : this.toPercent(this.colWeightArray[4]))
              .layoutWeight(this.onePlusNInfo.layoutHeight == undefined ? undefined : (this.rowWeightArray.length == 0 ? 1 : this.rowWeightArray[0]))
            }.alignItems(HorizontalAlign.Start)
          } else {
            Row() {
              Column() {
                this.vLayoutContent(this.vLayoutData[0])
              }
              .onAreaChange((oldValue, newValue) => {
                this.itemWidth = (Number(newValue.width))
                this.itemHeight = (Number(newValue.height))
                console.error(TAG + 'itemWidth =' + this.itemWidth + ', itemHeight =' + this.itemHeight)
                this.computedSize()
              })
              .alignItems(HorizontalAlign.Start)
              .width(this.colWeightArray.length == 0 ? '50%' : this.toPercent(this.colWeightArray[0]))

              Column() {
                Column() {
                  this.vLayoutContent(this.vLayoutData[1])
                }
                .onAreaChange((oldValue, newValue) => {
                  this.itemWidth = (Number(newValue.width))
                  this.itemHeight1 = (Number(newValue.height))
                  console.error(TAG + 'itemWidth =' + this.itemWidth + ', itemHeight1 =' + this.itemHeight1)
                  this.computedSize()
                })
                .alignItems(HorizontalAlign.Start)
                .width(this.colWeightArray.length == 0 ? '50%' : this.toPercent(this.colWeightArray[1]))
                .layoutWeight(this.onePlusNInfo.layoutHeight == undefined ? undefined : (this.rowWeightArray.length == 0 ? 1 : this.rowWeightArray[0]))

                Row() {
                  Column() {
                    this.vLayoutContent(this.vLayoutData[2])
                  }
                  .onAreaChange((oldValue, newValue) => {
                    this.itemWidth = (Number(newValue.width))
                    this.itemHeight2 = (Number(newValue.height))
                    console.error(TAG + 'itemWidth =' + this.itemWidth + ', itemHeight2 =' + this.itemHeight2)
                    this.computedSize()
                  })
                  .width(this.colWeightArray.length == 0 ? '33%' : this.toPercent(this.colWeightArray[2]))
                  .layoutWeight(this.onePlusNInfo.layoutHeight == undefined ? undefined : (this.colWeightArray.length == 0 ? 1 : 0))

                  Column() {
                    this.vLayoutContent(this.vLayoutData[3])
                  }
                  .onAreaChange((oldValue, newValue) => {
                    this.itemWidth = (Number(newValue.width))
                    this.itemHeight3 = (Number(newValue.height))
                    console.error(TAG + 'itemWidth =' + this.itemWidth + ', itemHeight3 =' + this.itemHeight3)
                    this.computedSize()
                  })
                  .width(this.colWeightArray.length == 0 ? '33%' : this.toPercent(this.colWeightArray[3]))
                  .layoutWeight(this.onePlusNInfo.layoutHeight == undefined ? undefined : (this.colWeightArray.length == 0 ? 1 : 0))

                  Column() {
                    this.vLayoutContent(this.vLayoutData[4])
                  }
                  .onAreaChange((oldValue, newValue) => {
                    this.itemWidth = (Number(newValue.width))
                    this.itemHeight4 = (Number(newValue.height))
                    console.error(TAG + 'itemWidth =' + this.itemWidth + ', itemHeight4 =' + this.itemHeight4)
                    this.computedSize()
                  })
                  .width(this.colWeightArray.length == 0 ? '33%' : this.toPercent(this.colWeightArray[4]))
                  .layoutWeight(this.onePlusNInfo.layoutHeight == undefined ? undefined : (this.colWeightArray.length == 0 ? 1 : 0))

                }
                .width(this.colWeightArray.length == 0 ? '50%' : '100%')
                .layoutWeight(this.onePlusNInfo.layoutHeight == undefined ? undefined : (this.rowWeightArray.length == 0 ? 1 : this.rowWeightArray[1]))
              }
              .alignItems(HorizontalAlign.Start)
            }
          }
        } else {
          Text('please less than 1+5')
            .width('100%')
            .height('100%')
            .backgroundColor(0x22EEEEEE)
            .border({ width: 1, color: '#000000', radius: 0, style: BorderStyle.Solid })
            .fontSize(25)
            .fontColor('#999999')
            .fontWeight(FontWeight.Bold)
            .textAlign(TextAlign.Center)
            .textOverflow({ overflow: TextOverflow.Ellipsis })
        }
      }
      .width(this.onePlusNInfo.layoutWidth)
      .height(this.onePlusNInfo.layoutHeight == undefined ? this.layoutHeight : this.onePlusNInfo.layoutHeight)
      .aspectRatio(this.onePlusNInfo.aspectRatio)
      .padding({
        top: this.onePlusNInfo.topPadding,
        right: this.onePlusNInfo.rightPadding,
        bottom: this.onePlusNInfo.bottomPadding,
        left: this.onePlusNInfo.leftPadding
      })
    }
    .backgroundColor(this.onePlusNInfo.bgColor)
    .zIndex(this.onePlusNInfo.zIndex)
    .margin({
      top: this.onePlusNInfo.topMargin,
      right: this.onePlusNInfo.rightMargin,
      bottom: this.onePlusNInfo.bottomMargin,
      left: this.onePlusNInfo.leftMargin
    })
  }
}