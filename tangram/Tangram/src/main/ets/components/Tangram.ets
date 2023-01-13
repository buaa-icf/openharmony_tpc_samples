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
import { TangramLayout } from './TangramLayout'
import { CardLoadSupport } from './support/CardLoadSupport'

@Component
export struct Tangram{
  private TAG = 'Tangram'
  cardProperties: CardProperty[]
  customLayoutType?:string[] = []
  customViewType?:string[] = []
  @BuilderParam customLayout?:(cardProperty: CardProperty, child :(any))=> void = null
  @BuilderParam customView?: (cardProperty: CardProperty) => void = null
  cardLoadSupport?: CardLoadSupport
  onScrollIndex?:(firstIndex: number,lastIndex: number) => void
  private page = 1

  build(){
    List(){
      ForEach(this.cardProperties, (item: CardProperty, position: number)=>{
        ListItem(){
          TangramLayout({
            cardProperty: item as any,
            customLayoutType: this.customLayoutType,
            customViewType: this.customViewType,
            customLayout: this.customLayout,
            customView: this.customView
          })
        }
      })
    }
    .height('100%')
    .width('100%')
    .onScrollIndex((firstIndex: number,lastIndex: number)=>{
      if(this.onScrollIndex){
        this.onScrollIndex(firstIndex, lastIndex);
      }
      if(lastIndex == this.cardProperties.length - 1){
        let lastCardProperty = this.cardProperties[lastIndex];
        //
        if(lastCardProperty.loadType == -1 && lastCardProperty.loaded == false){
          this.cardLoadSupport.asyncLoader(lastCardProperty.loadinfo);
          lastCardProperty.loaded = true;
        }else if(lastCardProperty.loadType == 1 && lastCardProperty.loaded == false){
          this.page++;
          this.cardLoadSupport.asyncPageLoader(this.page, lastCardProperty.loadinfo);
          lastCardProperty.loaded = true;
        }
      }
    })
  }

  log(text: string){
    console.info('Tangram:' + this.TAG + ':'+ text);
  }
}