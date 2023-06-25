/*
 * Copyright (c) 2022 Huawei Device Co., Ltd.
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

// @ts-ignore
import cache from 'memory-cache';

@Entry
@Component
struct CachePage {
  @State get: string = ''
  @State cacheSize: number = 0;
  @State cacheMemsize: number = 0;
  @State cacheHits: number = 0;
  @State cacheMisses: number = 0;
  @State cacheKeys: string = '';
  @State cacheExportJson: string = '';
  @State cacheImportJson: string = '';
  @State putData: string = ''
  private isDebug: boolean = true;

  build() {
    Column() {
      Column({ space: 12 }){
        TextInput({  placeholder: '请输入字符串' })
          .height(60)
          .fontSize(18)
          .onChange((value: string) => {
            this.putData = value
          })
        Button('put：写入缓存数据', { type: ButtonType.Normal })
          .fontSize(18)
          .fontColor('#000')
          .height(60)
          .width(300)
          .margin({ top: 20 })
          .backgroundColor('#12939f')
          .onClick(() => {
            cache.put(this.putData,this.putData);
          })

      }.margin({ top: 10 })


      Row() {

        Button('get()' + this.get)
          .fontSize(18)
          .margin({ left: 18 })
          .onClick(() => {
            this.get = cache.get('foo')
          })
        Button('del()')
          .fontSize(18)
          .margin({ left: 18 })
          .onClick(() => {
            cache.del('foo')
          })
        Button('clear ()')
          .fontSize(18)
          .margin({ left: 18 })
          .onClick(() => {
            cache.clear()
          })
      }

      Row() {
        Button('size()' + this.cacheSize)
          .fontSize(18)
          .margin({ left: 18 })
          .onClick(() => {
            this.cacheSize = cache.size();
          })
        Button('memsize()' + this.cacheMemsize)
          .fontSize(18)
          .margin({ left: 18 })
          .onClick(() => {
            this.cacheMemsize = cache.memsize();
          })
        Button('debug()')
          .fontSize(18)
          .margin({ left: 18 })
          .onClick(() => {
            this.isDebug = !this.isDebug;
            cache.debug(this.isDebug)
          })
        Button('hits()' + this.cacheHits)
          .fontSize(18)
          .margin({ left: 18 })
          .onClick(() => {
            cache.debug(true);
            this.cacheHits = cache.hits()
          })
      }
      .margin({ top: 18 })

      Row() {
        Button('misses()' + this.cacheMisses)
          .fontSize(18)
          .margin({ left: 18 })
          .onClick(() => {
            this.cacheMisses = cache.misses();
          })
        Button('keys()' + this.cacheKeys)
          .fontSize(18)
          .margin({ left: 18 })
          .onClick(() => {
            this.cacheKeys = cache.keys();
          })
        Button('exportJson()' + this.cacheExportJson)
          .fontSize(18)
          .margin({ left: 18 })
          .onClick(() => {
            this.cacheExportJson = cache.exportJson();
          })
      }
      .margin({ top: 18 })

      Row() {
        Button('importJson()' + this.cacheImportJson)
          .fontSize(18)
          .margin({ left: 18 })
          .onClick(() => {
            this.cacheImportJson = cache.importJson(cache.exportJson());
          })
      }.margin({ top: 18 })
    }
    .padding({ top: 18, bottom: 18 })

  }
}