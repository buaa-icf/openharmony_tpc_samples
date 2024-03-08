/*
 * MIT License
 *
 * Copyright (C) 2024 Huawei Device Co., Ltd.
 *
 * Permission is hereby granted, free of charge, to any person
 * obtaining a copy of this software and associated documentation
 * files (the "Software"), to deal in the Software without
 * restriction, including without limitation the rights to use,
 * copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the
 * Software is furnished to do so, subject to the following
 * conditions:
 *
 * The above copyright notice and this permission notice shall be
 * included in all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
 * OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
 * HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
 * WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
 * OTHER DEALINGS IN THE SOFTWARE.
 */


import Eventsource from '@ohos/eventsource'
import promptAction from '@ohos.promptAction';
@Entry
@Component

struct Parent {
  @State simpleList: Array<string> = [];
  @State es: null | Eventsource = null;
  @State text: string = 'http://192.168.8.129:8080/sse';
  eventListener:null|((e: Record<"data", string>)=>void) = (e: Record<"data", string>) => {
    this.simpleList.push(e.data);
  }
  aboutToDisappear(): void {
    this.simpleList = [];
    this.es = null;
    this.eventListener = null;
  }
  onPageShow():void{
    this.simpleList = [];
    this.es = null;
  }
  onPageHide():void{
    this.simpleList = [];
    this.es = null;
    this.eventListener = null;
  }
  build() {
    Row() {
      Column() {
        TextInput({text:this.text}).onChange((value:string)=>{
          this.text = value;
        }).margin({top:20})
        Button('创建连接')
          .margin({ top: 20, bottom: 10 })
          .size({
            width: 200,
            height: 50
          })
          .onClick(() => {
            this.es = new Eventsource(this.text);
            if(this.es===null) return
            this.es.onFailure((e: Record<"message", string>) => {
              promptAction.showToast({ message: JSON.stringify(e.message) });
            })
          })
        Button('开始监听')
          .margin({ top: 20, bottom: 10 })
          .size({
            width: 200,
            height: 50
          })
          .onClick(() => {
            if (!this.es) return;
            this.es.addEventListener("server-time", this.eventListener);
            promptAction.showToast({ message: '监听开始' });

          })
        Button('取消监听')
          .margin({ top: 20, bottom: 10 })
          .size({
            width: 200,
            height: 50
          })
          .onClick(() => {
            if (!this.es) return;
            this.es.removeEventListener("server-time", this.eventListener);
            promptAction.showToast({ message: '监听取消' });
          })
        Button('断开连接')
          .margin({ top: 20, bottom: 10 })
          .size({
            width: 200,
            height: 50
          })
          .onClick(() => {
            if (!this.es) return;
            this.es.close();
            promptAction.showToast({ message: '连接断开' });
          })
        Scroll() {
          Column() {
            ForEach(this.simpleList, (item: string) => {
              ChildItem({ 'item': item } as Record<string, string>);
            }, (item: string) => item)
          }
        }.height(300)

      }
      .width('100%')
      .height('100%')
    }
    .height('100%')
    .backgroundColor(0xF1F3F5)
  }
}

@Component
struct ChildItem {
  @Prop item: string = '';
  aboutToDisappear(): void {
    this.item = '';
  }
  build() {
    Text(this.item)
      .fontSize(12)
  }
}