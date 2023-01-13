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

import { CardProperty } from './porterties/CardProperty'
import { GRID_LAYOUT} from './vlayout/GridLayoutHelper'
import { GridView } from './gridView/GridView'
import { GridStyle } from './porterties/style/GridStyle'
import { ONEN_LAYOUT } from './vlayout/OnePlusNLayoutHelper'
import { OnePlusNStyle } from './porterties/style/OnePlusNStyle'
import { BannerView } from './banner/BannerView'
import { BannerStyle } from './porterties/style/BannerStyle'

@Component
export struct TangramLayout {
  private TAG = "TangramLayout"
  @ObjectLink cardProperty: CardProperty
  customLayoutType: string[] = []
  customViewType: string[] = []
  @BuilderParam customLayout?: (cardProperty: CardProperty, child: (any)) => void = null
  @BuilderParam customView?: (cardProperty: CardProperty) => void = null

  build(){
    if(this.cardProperty.type == 'container-banner'){
      BannerView({
        vLayoutContent: (item: CardProperty) =>{
          this.nextChildLayout(item)
        },
        vLayoutData: this.cardProperty.items,
      vLayoutAttribute: {
      layoutWidth: this.cardProperty.style.width,
      layoutHeight: this.cardProperty.style.height,
      aspectRatio: Number(this.cardProperty.style.aspectRatio),
      bgColor: this.cardProperty.style.bgColor,
      zIndex: this.cardProperty.style.zIndex,
      topPadding: this.cardProperty.style.padding ? this.cardProperty.style.padding[0] : 0,
      bottomPadding: this.cardProperty.style.padding ? this.cardProperty.style.padding[1] : 0,
      leftPadding: this.cardProperty.style.padding ? this.cardProperty.style.padding[2] : 0,
      rightPadding: this.cardProperty.style.padding ? this.cardProperty.style.padding[3] : 0,
      topMargin: this.cardProperty.style.margin ? this.cardProperty.style.margin[0] : 0,
      bottomMargin: this.cardProperty.style.margin ? this.cardProperty.style.margin[1] : 0,
      leftMargin: this.cardProperty.style.margin ? this.cardProperty.style.margin[2] : 0,
      rightMargin: this.cardProperty.style.margin ? this.cardProperty.style.margin[3] : 0,
      pageRatio: (this.cardProperty.style as BannerStyle).pageRatio == undefined ?
      undefined : Number((this.cardProperty.style as BannerStyle).pageRatio),
      itemRatio: (this.cardProperty.style as BannerStyle).itemRatio == undefined ?
      undefined : Number((this.cardProperty.style as BannerStyle).itemRatio),
      autoScroll: (this.cardProperty.style as BannerStyle).autoScroll == undefined ?
      undefined : Number((this.cardProperty.style as BannerStyle).autoScroll),
      infinite: (this.cardProperty.style as BannerStyle).infinite == undefined ?
      undefined : Boolean((this.cardProperty.style as BannerStyle).infinite),
      indicatorImg1: (this.cardProperty.style as BannerStyle).indicatorImg1,
      indicatorImg2: (this.cardProperty.style as BannerStyle).indicatorImg2,
      //
      //
      indicatorPosition: (this.cardProperty.style as BannerStyle).indicatorPosition,
      indicatorGap: (this.cardProperty.style as BannerStyle).indicatorGap,
      indicatorHeight: Number((this.cardProperty.style as BannerStyle).indicatorHeight),
      indicatorMargin: Number((this.cardProperty.style as BannerStyle).indicatorMargin),
      indicatorRadius: Number((this.cardProperty.style as BannerStyle).indicatorRadius),
      indicatorColor: (this.cardProperty.style as BannerStyle).indicatorColor,
      defaultIndicatorColor: (this.cardProperty.style as BannerStyle).defaultIndicatorColor,
      hGap: Number((this.cardProperty.style as BannerStyle).hGap),
      },
      })
    }else if(this.cardProperty.type == 'container-onePlusN'){
    ONEN_LAYOUT({
      vLayoutContent: (item: CardProperty) =>{
      this.nextChildLayout(item)
      },
      vLayoutData: this.cardProperty.items,
      vLayoutAttribute:{
      aspectRatio: this.cardProperty.style.aspectRatio,
      layoutWidth: this.cardProperty.style.width,
      layoutHeight: this.cardProperty.style.height,
      rowWeights: (this.cardProperty.style as OnePlusNStyle).rows,
      colWeights: this.cardProperty.style.cols,
      bgColor: this.cardProperty.style.bgColor,
      zIndex: this.cardProperty.style.zIndex,
      topPadding: this.cardProperty.style.padding ? this.cardProperty.style.padding[0] : 0,
      bottomPadding: this.cardProperty.style.padding ? this.cardProperty.style.padding[1] : 0,
      leftPadding: this.cardProperty.style.padding ? this.cardProperty.style.padding[2] : 0,
      rightPadding: this.cardProperty.style.padding ? this.cardProperty.style.padding[3] : 0,
      topMargin: this.cardProperty.style.margin ? this.cardProperty.style.margin[0] : 0,
      bottomMargin: this.cardProperty.style.margin ? this.cardProperty.style.margin[1] : 0,
      leftMargin: this.cardProperty.style.margin ? this.cardProperty.style.margin[2] : 0,
      rightMargin: this.cardProperty.style.margin ? this.cardProperty.style.margin[3] : 0,
      },
    })
    } else if( this.cardProperty.type == 'container-grid'){
    this.gridLayout((this.cardProperty.style as GridStyle).column)
    }else if(this.cardProperty.type == 'one'){
    this.gridLayout(1)
    }else if(this.cardProperty.type == "container-oneColumn"){
    this.gridLayout((this.cardProperty.style as GridStyle).column)
    }else if(this.customLayoutType.includes(this.cardProperty.type)){
    this.customLayout(this.cardProperty, (itemData) =>{
    this.nextChildLayout(itemData)
    });
    }else if(this.customViewType.includes(this.cardProperty.type)){
    this.customView(this.cardProperty);
    }
  }

  @Builder nextChildLayout(vLayoutData: CardProperty){
    TangramLayout({
      cardProperty: vLayoutData as any,
      customLayoutType: this.customLayoutType,
      customViewType: this.customViewType,
      customLayout: this.customLayout,
      customView: this.customView
    })
  }

  @Builder gridLayout(colum:number){
    GridView({
    vLayoutContent:(itemData: CardProperty,position)=>{
    this.nextChildLayout(itemData)
    },
    vLayoutData: this.cardProperty.items,
    vLayoutAttribute:{
    aspectRatio: this.cardProperty.style.aspectRatio,
    layoutHeight: this.cardProperty.style.height,
    spanCount: colum,
    weights: this.cardProperty.style.cols,
    autoExpand: (this.cardProperty.style as  GridStyle).autoExpand,
    vGap: (this.cardProperty.style as  GridStyle).vGap,
    hGap: (this.cardProperty.style as  GridStyle).hGap,
    bgColor: this.cardProperty.style.bgColor,
    zIndex:this.cardProperty.style.zIndex,
          topPadding: this.cardProperty.style.padding ? this.cardProperty.style.padding[0] as number : 0,
      bottomPadding: this.cardProperty.style.padding ? this.cardProperty.style.padding[1] as number: 0,
      leftPadding: this.cardProperty.style.padding ? this.cardProperty.style.padding[2] : 0,
      rightPadding: this.cardProperty.style.padding ? this.cardProperty.style.padding[3] : 0,
      topMargin: this.cardProperty.style.margin ? this.cardProperty.style.margin[0] : 0,
      bottomMargin: this.cardProperty.style.margin ? this.cardProperty.style.margin[1] : 0,
      leftMargin: this.cardProperty.style.margin ? this.cardProperty.style.margin[2] : 0,
      rightMargin: this.cardProperty.style.margin ? this.cardProperty.style.margin[3] : 0,
    },
    })
  }

  log(text: string){
  console.info("Tangram:"+ this.TAG +':'+text);
  }
}