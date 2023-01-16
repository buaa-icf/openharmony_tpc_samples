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

import http from '@ohos.net.http'
import ResponseCode from '@ohos.net.http'
import image from '@ohos.multimedia.image'
import { BannerAttributes } from './BannerAttributes'

const TAG = 'vlayout BANNER_LAYOUT'

@Component
export struct BannerView {
  @BuilderParam vLayoutContent: (item?, position?) => any //布局
  vLayoutData: any[] = [] //数据源
  @Watch('defaultInfo') @State vLayoutAttribute?: BannerAttributes = {} //属性
  @State layoutWidthPercent: string = '100%'
  @State pageWidthPercent: string = '100%'
  @State indicatorIsImg: boolean = false;
  @State image: PixelMap = undefined // 默认状态下指示器的图片
  @State imageCheck: PixelMap = undefined //选中状态下指示器的图片
  @State imageBili: number = 0 //指示器宽高比
  @State checkItem: number = 0 // 当前选中的条目索引
  @State private bannerInfo: BannerAttributes = {} //属性
  private layoutWidth: number = undefined // 布局宽度
  @State private layoutHeight: number = undefined // 布局的高
  @State private componentFirstMeasure: boolean = true;
  private bannerFirstMeasure: boolean = true;
  private pageWidth: number = undefined // banner布局的宽
  private pageHeight: number = undefined // banner布局的高
  private itemWidth: Length = '100%' // 每个item的宽度
  private itemHeight: number = undefined //每个item的高度

  aboutToAppear() {
    this.defaultInfo();
  }

  defaultInfo() {
    this.bannerInfo = {
      layoutWidth: this.vLayoutAttribute.layoutWidth == undefined ? '100%' : this.vLayoutAttribute.layoutWidth,
      layoutHeight: this.vLayoutAttribute.layoutHeight == undefined ? undefined : this.vLayoutAttribute.layoutHeight,
      aspectRatio: this.vLayoutAttribute.aspectRatio == undefined ? 0 : this.vLayoutAttribute.aspectRatio,
      bgColor: this.vLayoutAttribute.bgColor == undefined ? 'rgba(0,0,0,0)' : this.vLayoutAttribute.bgColor,
      zIndex: this.vLayoutAttribute.zIndex == undefined ? 0 : this.vLayoutAttribute.zIndex,
      topPadding: this.vLayoutAttribute.topPadding == undefined ? 0 : this.vLayoutAttribute.topPadding,
      rightPadding: this.vLayoutAttribute.rightPadding == undefined ? 0 : this.vLayoutAttribute.rightPadding,
      bottomPadding: this.vLayoutAttribute.bottomPadding == undefined ? 0 : this.vLayoutAttribute.bottomPadding,
      leftPadding: this.vLayoutAttribute.leftPadding == undefined ? 0 : this.vLayoutAttribute.leftPadding,
      topMargin: this.vLayoutAttribute.topMargin == undefined ? 0 : this.vLayoutAttribute.topMargin,
      rightMargin: this.vLayoutAttribute.rightMargin == undefined ? 0 : this.vLayoutAttribute.rightMargin,
      bottomMargin: this.vLayoutAttribute.bottomMargin == undefined ? 0 : this.vLayoutAttribute.bottomMargin,
      leftMargin: this.vLayoutAttribute.leftMargin == undefined ? 0 : this.vLayoutAttribute.leftMargin,
      pageRatio: this.vLayoutAttribute.pageRatio == undefined ? 1 : this.vLayoutAttribute.pageRatio,
      itemRatio: this.vLayoutAttribute.itemRatio == undefined ? 0 : this.vLayoutAttribute.itemRatio,
      autoScroll: this.vLayoutAttribute.autoScroll == undefined ? 3000 : this.vLayoutAttribute.autoScroll,
      infinite: this.vLayoutAttribute.infinite == undefined ? true : this.vLayoutAttribute.infinite,
      hGap: this.vLayoutAttribute.hGap == undefined ? 0 : this.vLayoutAttribute.hGap,
      indicatorImg1: this.vLayoutAttribute.indicatorImg1,
      indicatorImg2: this.vLayoutAttribute.indicatorImg2,
      indicatorPosition: this.vLayoutAttribute.indicatorPosition == undefined ? 'inside' : this.vLayoutAttribute.indicatorPosition,
      indicatorGap: this.vLayoutAttribute.indicatorGap == undefined ? 10 : this.vLayoutAttribute.indicatorGap,
      indicatorHeight: this.vLayoutAttribute.indicatorHeight == undefined ? 8 : this.vLayoutAttribute.indicatorHeight,
      indicatorMargin: this.vLayoutAttribute.indicatorMargin == undefined ? 8 : this.vLayoutAttribute.indicatorMargin,
      indicatorRadius: this.vLayoutAttribute.indicatorRadius == undefined ? 4 : this.vLayoutAttribute.indicatorRadius,
      indicatorColor: this.vLayoutAttribute.indicatorColor == undefined ? 'white' : this.vLayoutAttribute.indicatorColor,
      defaultIndicatorColor: this.vLayoutAttribute.defaultIndicatorColor == undefined ? 'black' : this.vLayoutAttribute.defaultIndicatorColor,
    }
    if (this.vLayoutAttribute.padding) {
      this.bannerInfo.topPadding = this.vLayoutAttribute.padding[0] == undefined ? 0 : this.vLayoutAttribute.padding[0]
      this.bannerInfo.bottomPadding = this.vLayoutAttribute.padding[1] == undefined ? 0 : this.vLayoutAttribute.padding[1]
      this.bannerInfo.leftPadding = this.vLayoutAttribute.padding[2] == undefined ? 0 : this.vLayoutAttribute.padding[2]
      this.bannerInfo.rightPadding = this.vLayoutAttribute.padding[3] == undefined ? 0 : this.vLayoutAttribute.padding[3]
    }
    if (this.vLayoutAttribute.margin) {
      this.bannerInfo.topMargin = this.vLayoutAttribute.margin[0] == undefined ? 0 : this.vLayoutAttribute.margin[0]
      this.bannerInfo.bottomMargin = this.vLayoutAttribute.margin[1] == undefined ? 0 : this.vLayoutAttribute.margin[1]
      this.bannerInfo.leftMargin = this.vLayoutAttribute.margin[2] == undefined ? 0 : this.vLayoutAttribute.margin[2]
      this.bannerInfo.rightMargin = this.vLayoutAttribute.margin[3] == undefined ? 0 : this.vLayoutAttribute.margin[3]
    }
  }

  resizeComponentSize() {
    if (this.bannerInfo.layoutHeight == undefined) {
      // 如果高度未定义只能在子View中重置
    } else {
      this.layoutHeight = this.bannerInfo.layoutHeight
    }
  }

  resizeBannerUISizeFirst() {
    if (this.bannerInfo.itemRatio > 0) {
      this.itemHeight = this.itemWidth as number / this.bannerInfo.itemRatio
    }
    if (this.bannerInfo.aspectRatio > 0) {
      this.pageHeight = this.pageWidth as number / this.bannerInfo.aspectRatio
    } else {
      this.pageHeight = this.itemHeight
    }
    if (this.bannerInfo.layoutHeight == undefined) {
      let topRatio = 0;
      let bottomRatio = 0;
      if (this.bannerInfo.topPadding && (this.bannerInfo.topPadding + "").endsWith("%")) {
        topRatio = parseInt(this.bannerInfo.topPadding + "") / 100.0;
      }
      if (this.bannerInfo.bottomPadding && (this.bannerInfo.bottomPadding + "").endsWith("%")) {
        bottomRatio = parseInt(this.bannerInfo.bottomPadding + "") / 100.0
      }

      let topPadValue = 0;
      let bottomPadValue = 0;

      if (typeof this.bannerInfo.topPadding == 'number') {
        topPadValue = this.bannerInfo.topPadding;
      } else if (this.checkIsNumber(this.bannerInfo.topPadding + "")) {
        topPadValue = parseInt(this.bannerInfo.topPadding + "")
      }

      if (typeof this.bannerInfo.bottomPadding == 'number') {
        bottomPadValue = this.bannerInfo.bottomPadding;
      } else if (this.checkIsNumber(this.bannerInfo.bottomPadding + "")) {
        bottomPadValue = parseInt(this.bannerInfo.bottomPadding + "")
      }


      if (this.bannerInfo.indicatorPosition == 'inside') {
        this.layoutHeight = this.pageHeight / (1 - (topRatio + bottomRatio)) + (topPadValue + bottomPadValue)
      } else {
        this.layoutHeight = this.pageHeight / (1 - (topRatio + bottomRatio)) + (topPadValue + bottomPadValue) + this.bannerInfo.indicatorHeight + this.bannerInfo.indicatorMargin + this.bannerInfo.indicatorMargin;
      }
    } else {
      this.layoutHeight = this.bannerInfo.layoutHeight
    }
  }

  initComponentSize() {
    if (this.bannerInfo.itemRatio > 0) {
      this.itemHeight = this.itemWidth as number / this.bannerInfo.itemRatio
    }
    if (this.bannerInfo.aspectRatio > 0) {
      this.pageHeight = this.pageWidth as number / this.bannerInfo.aspectRatio
    } else {
      this.pageHeight = this.itemHeight
    }
    if (this.bannerInfo.layoutHeight == undefined) {
      if (this.bannerInfo.indicatorPosition == 'inside') {
        this.layoutHeight = this.pageHeight
      } else {
        this.layoutHeight = this.pageHeight + this.bannerInfo.indicatorHeight + this.bannerInfo.indicatorMargin + this.bannerInfo.indicatorMargin;
      }
    } else {
      this.layoutHeight = this.bannerInfo.layoutHeight
    }
  }

  build() {
    Column() {
      if (this.bannerInfo.indicatorPosition == 'inside') {
        Stack({ alignContent: Alignment.Center }) {
          this.BannerUI()
          this.indicatorUI()
        }
        .padding({
          top: this.bannerInfo.topPadding,
          bottom: this.bannerInfo.bottomPadding,
          left: this.bannerInfo.leftPadding,
          right: this.bannerInfo.rightPadding
        })
        .width('100%')
        .height('100%')
      } else {
        Stack({ alignContent: Alignment.Center }) {
          Column() {
            this.BannerUI()
            this.indicatorUI()
          }
        }
        .padding({
          top: this.bannerInfo.topPadding,
          bottom: this.bannerInfo.bottomPadding,
          left: this.bannerInfo.leftPadding,
          right: this.bannerInfo.rightPadding
        })
        .width('100%')
        .height('100%')
      }
    }
    .width(this.layoutWidthPercent)
    .height(this.bannerInfo.layoutHeight == undefined ?
      (this.componentFirstMeasure ? '50%' : this.layoutHeight) :
    this.layoutHeight)
    .backgroundColor(this.bannerInfo.bgColor)
    .zIndex(this.bannerInfo.zIndex)
    .margin({
      top: this.bannerInfo.topMargin,
      bottom: this.bannerInfo.bottomMargin,
      left: this.bannerInfo.leftMargin,
      right: this.bannerInfo.rightMargin
    })
    .onAreaChange((oldVlue, newValue) => {
      if (this.componentFirstMeasure) {
        this.componentFirstMeasure = false;
        this.resizeComponentSize();
        return;
      }
      if (this.layoutWidth != (Number(newValue.width)) || this.layoutHeight != (Number(newValue.height))) {
        this.layoutWidth = (Number(newValue.width))
        this.layoutHeight = (Number(newValue.height))
        this.resizeComponentSize();
        this.computeMargin()
      }
    })
  }

  @Builder BannerUI() {
    Swiper() {
      ForEach(this.vLayoutData, (item: any, position: number) => {
        Stack() {
          Stack() {
            Stack() {
              this.vLayoutContent(item, position)
            }
            .onAreaChange((oldValue, newValue) => {

              if (this.bannerFirstMeasure) {
                this.bannerFirstMeasure = false;
                this.itemWidth = (Number(newValue.width))
                this.itemHeight = (Number(newValue.height))
                this.resizeBannerUISizeFirst();
                return;
              }

              if (this.itemWidth != (Number(newValue.width)) || (this.itemHeight != (Number(newValue.height)) && this.itemHeight == undefined)) {
                this.itemWidth = (Number(newValue.width))
                this.itemHeight = (Number(newValue.height))
                this.initComponentSize()
              }
            })
          }
          .width(this.toPercent(this.bannerInfo.pageRatio * 100))
          .height(this.itemHeight)
        }
        .width('100%')
      })
    }
    .width(this.pageWidthPercent)
    .height(this.pageHeight)
    .index(this.bannerInfo.zIndex)
    .indicator(false)
    .autoPlay(this.bannerInfo.autoScroll > 0)
    .interval(this.bannerInfo.autoScroll)
    .loop(this.bannerInfo.infinite)
    .duration(400)
    .itemSpace(this.bannerInfo.hGap)
    .onAreaChange((oldValue, newValue) => {
      if (this.pageWidth != (Number(newValue.width)) || this.pageHeight != (Number(newValue.height))) {
        this.pageWidth = (Number(newValue.width))
        this.pageHeight = (Number(newValue.height))
      }
    })
    .onChange((index: number) => {
      this.checkItem = index;
    })
  }

  @Builder indicatorUI() {
    Stack({ alignContent: Alignment.Bottom }) {
      Stack() {
        Row() {
          ForEach(this.vLayoutData, (item: any, position: number) => {
            Image(this.checkItem == position ? this.imageCheck : this.image)
              .fitOriginalSize(true)
              .margin({ left: position != 0 ? this.bannerInfo.indicatorGap : 0 })
              .width(this.bannerInfo.indicatorHeight * this.imageBili)
              .height(this.bannerInfo.indicatorHeight)
              .borderRadius(5)
          })
        }
        .onAppear(() => {
          this.httpRequest();
        })
        .visibility(this.indicatorIsImg ? Visibility.Visible : Visibility.Hidden)

        Row() {
          ForEach(this.vLayoutData, (item: any, position: number) => {
            Stack()
              .backgroundColor(this.checkItem == position ? this.bannerInfo.indicatorColor : this.bannerInfo.defaultIndicatorColor)
              .width(this.bannerInfo.indicatorHeight)
              .height(this.bannerInfo.indicatorHeight)
              .margin({ left: position != 0 ? this.bannerInfo.indicatorGap : 0 })
              .borderRadius(this.bannerInfo.indicatorRadius)
          })
        }
        .visibility(this.indicatorIsImg ? Visibility.Hidden : Visibility.Visible)
      }
      .margin({ top: this.bannerInfo.indicatorMargin, bottom: this.bannerInfo.indicatorMargin })
    }
    .height(this.bannerInfo.indicatorPosition == 'inside' ?
    this.pageHeight : this.bannerInfo.indicatorHeight + this.bannerInfo.indicatorMargin + this.bannerInfo.indicatorMargin)
  }

  private checkIsNumber(input: string): boolean {
    var reg = /^[0-9]+.?[0-9]*$/;
    if (!reg.test(input)) {
      // 存在非数字不匹配
      return false;
    }
    return true;
  }

  /**
   * 计算左右margin
   */
  private computeMargin() {
    //将左右margin转换为数字类型
    if (this.layoutWidth != undefined && (this.bannerInfo.leftMargin != 0 || this.bannerInfo.rightMargin != 0) && this.layoutWidthPercent == '100%') {
      //计算margin
      if ((typeof (this.bannerInfo.leftMargin) == 'string')) {
        var leftMargin = Math.round(parseInt((this.bannerInfo.leftMargin) as string) / 100.0 * this.layoutWidth);
      }
      if ((typeof (this.bannerInfo.rightMargin) == 'string')) {
        var rightMargin = Math.round(parseInt((this.bannerInfo.rightMargin) as string) / 100.0 * this.layoutWidth);
      }
      this.layoutWidth = this.layoutWidth - leftMargin - rightMargin;
      this.layoutWidthPercent = this.toPercent(this.layoutWidth * 100 / (this.layoutWidth + leftMargin + leftMargin))
    }
  }

  private toPercent(num): string {
    let str = Number(num).toFixed(0);
    str += '%'
    return str;
  }

  // 网络图片请求方法
  private httpRequest() {
    let httpRequest = http.createHttp();
    httpRequest.request(
    this.bannerInfo.indicatorImg1, // 请填写一个具体的网络图片地址
      (error, data) => {
        if (error) {
          console.log('error code: ' + error.code + ', msg: ' + error.message)
        } else {
          let code = data.responseCode
          if (ResponseCode.ResponseCode.OK == code) {
            // @ts-ignore
            let imageSource = image.createImageSource(data.result)
            // 创建图片大小
            imageSource.createPixelMap({}).then((pixelMap) => {
              imageSource.getImageInfo().then((imageInfo) => {
                this.imageBili = imageInfo.size.width / imageInfo.size.height;
                this.indicatorIsImg = true;
              })
              this.imageCheck = pixelMap
            })
          } else {
            console.log('response code: ' + code)
          }
        }
      }
    )
    httpRequest.request(
    this.bannerInfo.indicatorImg2,
      (error, data) => {
        if (error) {
          console.log('error code: ' + error.code + ', msg: ' + error.message)
        } else {
          let code = data.responseCode
          if (ResponseCode.ResponseCode.OK == code) {
            // @ts-ignore
            let imageSource = image.createImageSource(data.result)
            // 创建图片大小
            imageSource.createPixelMap({}).then((pixelMap) => {
              this.image = pixelMap
            })
          } else {
            console.log('response code: ' + code)
          }
        }
      }
    )
  }
}