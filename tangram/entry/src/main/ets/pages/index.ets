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

import {DataUtil} from './datautil'
import { CardProperty, Tangram, TangramLayout, CardLoadSupport, Style} from '@ohos/tangram'

@Entry
@Component
struct Index {
  private TAG = 'index'
  @State dataBean:CardProperty[] = [];
  @State text:string = ' 变更数据';
  customLayoutType?: string[] = ["container-custom"]
  customViewType?: string[] = ["100","1","redText","blueText"]

  aboutToAppear(){
    // 将本地json串作为数据
    this.dataBean = this.setStyle(this.parseJson(new DataUtil().getDataFormLocal()))
  }

  // 给所以体育的Styke赋默认值
  setStyle(cardPropertites: CardProperty[]){
    if(cardPropertites){
      if(cardPropertites.length > 0) {
        cardPropertites.forEach(cardProperty => {
          if(!cardProperty.style){
            //
            cardProperty.style = new Style();
          }
          this.setStyle(cardProperty.items)
        })
      }
    }
    return cardPropertites
  }

  build() {
    Column() {
      Stack({alignContent: Alignment.Center}) {
        Text(this.text)
          .fontSize(25)
          .fontColor("#000000")
          .fontWeight(FontWeight.Bold)
      }
      .width('100%')
      .height('10%')
      .borderRadius(5)
      .shadow({ radius: 8, color: "#ff696767", offsetX: 5, offsetY: 5})
      .onClick(()=>{
        if(this.dataBean[0].items.length > 2){
          this.dataBean[0].items[1].style.bgColor = '#984521'
          this.dataBean[0].items[1].msg = '变更数据完成'
          this.dataBean[0].items.splice(this.dataBean[0].items.length - 1)
          this.dataBean[0].items.splice(this.dataBean[0].items.length - 1)
          this.dataBean.push(null)
          this.dataBean.splice(this.dataBean.length - 1)
        }
      })

      Column(){
        Tangram({
          // 绑定json解析出来的对象
          cardProperties: this.dataBean,
          // 自定义布局的类型列表，列表中的类型才有解析
          customLayoutType: this.customLayoutType,
          // 自定义组件的类型列表，列表中有的类型才会解析
          customViewType: this.customViewType,
          // 自定义布局解析的UI方法
          customLayout:(cardProperty, child)=>{
            this.customLayout(cardProperty, child)
          },
          // 自定义组件解析的UI方法
          customView:(cardProperty) =>{
            this.customView(cardProperty)
          },
          // 异步加载、异步分页加载的合并类
          cardLoadSupport: new CardLoadSupport((loadinfo:string)=>{
          console.log('异步加载信息：'+loadinfo)
          setTimeout(()=>{
            let a = new CardProperty();
            a.type = '1'
            a.msg = '异步加载测试文本'
            a.style = new Style();
            this.dataBean.push(a);
          }, 5000)
          },(page:number, loadinfo: string)=>{
            console.log('异步分页加载：第'+page+'页')
            if(page <= 3){
              setTimeout(()=>{
                let newDataBean = this.parseJson(new DataUtil().getData2FormLocal())
                for(var i=0; i<newDataBean.length; i++){
                  this.dataBean.push(newDataBean[i])
                }
              },5000)
            }
          }),
          // 当前显示条目索引变化回调监听
          onScrollIndex: (firstIndex:number, lastIndex:number)=>{
            console.log("当前显示的条目头尾为"+firstIndex+'-'+lastIndex)
          }
        })
      }
      .backgroundColor("#ff3b3131")
      .width("90%")
      .height("80%")
    }
    .width('100%')
    .height('100%')
  }

  // 自定义解析布局
  @Builder customLayout(cardProperty: CardProperty, child:(any)){
    if(cardProperty.type == 'container-custom'){
      Column(){
        TangramLayout({
          cardProperty: cardProperty.items[0],
          customLayoutType: this.customLayoutType,
          customViewType: this.customViewType,
          customLayout: (cardProperty, child)=>{
            this.customLayout(cardProperty,child)
          },
          customView:(cardProperty)=>{
            this.customView(cardProperty)
          }
        })
      }
      .padding({
        top:10,
        bottom:10,
        left:'25%',
        right:'25%'
      })
      .backgroundColor(cardProperty.style.bgColor)
    }
  }

  // 自定义解析组件
  @Builder customView(cardProperty: CardProperty){
    if(cardProperty.type == '100'){
      Text(cardProperty.msg)
        .fontSize(20)
        .textAlign(TextAlign.Center)
        .width('100%')
        .height('100%')
        .fontColor('#000000')
        .backgroundColor(cardProperty.style.bgColor)
        .fontWeight(FontWeight.Bold)
    }else if(cardProperty.type == '1'){
      Text(cardProperty.msg)
        .fontSize(20)
        .textAlign(TextAlign.Center)
        .width('100%')
        .height('100')
        .fontColor('#000000')
        .backgroundColor(cardProperty.style.bgColor)
        .fontWeight(FontWeight.Bold)
    }else if(cardProperty.type == 'redText'){
      Text(cardProperty.msg)
        .fontSize(20)
        .textAlign(TextAlign.Center)
        .width('100%')
        .fontColor('red')
        .backgroundColor('green')
        .fontWeight(FontWeight.Bold)
    }else if(cardProperty.type == 'blueText'){
      Text(cardProperty.msg)
        .fontSize(20)
        .textAlign(TextAlign.Center)
        .width('100%')
        .fontColor('blue')
        .fontWeight(FontWeight.Bold)
        .backgroundColor('red')
    }
  }

  parseJson(dataJson):Array<CardProperty>{
    return JSON.parse(dataJson)
  }

  log(text:string){
    console.info("Tangram:"+this.TAG +':'+text)
  }
}