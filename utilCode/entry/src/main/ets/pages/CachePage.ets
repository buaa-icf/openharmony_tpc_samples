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

import cache from 'memory-cache';
import prompt from '@ohos.promptAction';
interface skipDuplicatesType{
  skipDuplicates:boolean
}

let skipFn = (data: boolean): skipDuplicatesType => {
  const skipDuplicatesData: skipDuplicatesType = {
    skipDuplicates: data
  }
  return skipDuplicatesData
}

@Entry
@Component
struct CachePage {
  @State get: string = ''
  // @State cacheSize: number = 0;
  // @State cacheMemsize: number = 0;
  // @State cacheHits: number = 0;


  @State putKey: string = ''
  @State putValue: string = ''
  @State getKey: string = ''
  @State getValue: string = ''
  @State delKey: string = ''
  @State cacheSize: number = 0
  @State cacheMemsize: number = 0
  @State cacheHits: number = 0;
  @State cacheMisses: number = 0;
  @State cacheKeys: string[] = [];
  @State cacheExportJson: string = '';
  @State cacheImportJson: string = '';
  @State cacheImportJsonSize: number = 0;
  private default: string = " {\"0\":{\"value\":\""+this.getResourceString($r("app.string.Test_data"))+"\",\"expire\":\"NaN\"}}"
  scroller: Scroller = new Scroller()
  private getResourceString(res: Resource) {
    return getContext().resourceManager.getStringSync(res.id)
  }

  build() {

    Scroll(this.scroller) {

      Column() {


        //写入数据
        Column({ space: 12 }) {
          Text($r("app.string.Write_10_pieces_data_key0_9_no_corresponding_interface_convenient_testing"))
            .margin({ top: 5 })
            .fontSize(16)
          Button(this.getResourceString($r("app.string.put_writes_cached_data")), { type: ButtonType.Normal })
            .fontSize(18)
            .fontColor('#000')
            .height(60)
            .width(300)
            .margin({ top: 20 })
            .backgroundColor('#12939f')
            .onClick(() => {
              for (let i = 0; i < 10; i++) {
                cache.put(i, this.getResourceString($r("app.string.Hello")) + i);
                prompt.showToast({ message: this.getResourceString($r("app.string.The_write_succeeded")), duration: 3000 })
              }
            })
          Divider().strokeWidth(2).color('#F1F3F5').margin({ top: 8, bottom: 8 })
        }.margin({ top: 10 })

        //put
        Column({ space: 12 }) {
          Text($r("app.string.Put_test_write_data_pass_key_write_value"))
            .margin({ top: 5 })
            .fontSize(16)
          TextInput({ placeholder: $r("app.string.Please_enter_key") })
            .height(60)
            .fontSize(18)
            .onChange((value: string) => {
              this.putKey = value
            })
          TextInput({ placeholder: $r("app.string.Please_enter_value") })
            .height(60)
            .fontSize(18)
            .onChange((value: string) => {
              this.putValue = value
            })
          Button($r("app.string.put_writes_cached_data"), { type: ButtonType.Normal })
            .fontSize(18)
            .fontColor('#000')
            .height(60)
            .width(300)
            .margin({ top: 20 })
            .backgroundColor('#12939f')
            .onClick(() => {
              try {
                if (this.putKey == undefined || this.putKey.length == 0) {
                  prompt.showToast({ message: $r("app.string.The_key_cannot_be_empty"), duration: 3000 })
                  return
                }
                let value:number = cache.put(this.putKey, this.putValue);
                prompt.showToast({ message: this.getResourceString($r("app.string.Write_value")) + " "+ value + " "+ this.getResourceString($r("app.string.succeed")), duration: 3000 })
              } catch (err) {
                prompt.showToast({ message: this.getResourceString($r("app.string.succeed")), duration: 3000 })
              }
            })
          Divider().strokeWidth(2).color('#F1F3F5').margin({ top: 8, bottom: 8 })
        }.margin({ top: 10 })

        //get
        Column({ space: 12 }) {
          Text($r("app.string.get_the_test_get_value_by_key"))
            .margin({ top: 5 })
            .fontSize(16)
          TextInput({ placeholder:$r("app.string.Please_enter_key") })
            .height(60)
            .fontSize(18)
            .onChange((value: string) => {
              this.getKey = value
            })
          Button(this.getResourceString($r("app.string.get_reads_data")), { type: ButtonType.Normal })
            .fontSize(18)
            .fontColor('#000')
            .height(60)
            .width(300)
            .margin({ top: 20 })
            .backgroundColor('#12939f')
            .onClick(() => {
              try {
                this.getValue = cache.get(this.getKey)
              } catch (err) {
                prompt.showToast({ message: $r("app.string.Read_failed"), duration: 3000 })
              }

            })
          Text(this.getResourceString($r("app.string.Read_failed")) + " " + this.getValue)
            .margin({ top: 5 })
            .fontSize(16)
          Divider().strokeWidth(2).color('#F1F3F5').margin({ top: 8, bottom: 8 })
        }.margin({ top: 10 })

        //del
        Column({ space: 12 }) {
          Text($r("app.string.del_test_remove_value_by_key"))
          TextInput({ placeholder: $r("app.string.Please_enter_key") })
            .height(60)
            .fontSize(18)
            .onChange((value: string) => {
              this.delKey = value
            })
          Button(this.getResourceString($r("app.string.del_deletes_data")), { type: ButtonType.Normal })
            .fontSize(18)
            .fontColor('#000')
            .height(60)
            .width(300)
            .margin({ top: 20 })
            .backgroundColor('#12939f')
            .onClick(() => {
              let is:boolean = cache.del(this.delKey)
              prompt.showToast({ message: this.getResourceString($r("app.string.Delete_the_results")) + " "+ is, duration: 3000 })

            })
          Divider().strokeWidth(2).color('#F1F3F5').margin({ top: 8, bottom: 8 })
        }.margin({ top: 10 })

        //clear
        Column({ space: 12 }) {
          Text($r("app.string.clear_test_delete_values_delete_size_and_set_memsize_to_0"))
          Button($r("app.string.clear_Deletes_all_values"), { type: ButtonType.Normal })
            .fontSize(18)
            .fontColor('#000')
            .height(60)
            .width(300)
            .margin({ top: 20 })
            .backgroundColor('#12939f')
            .onClick(() => {
              try {
                cache.clear()
              } catch (err) {
                prompt.showToast({ message: $r("app.string.Deletion_failed"), duration: 3000 })
              }
            })
          Divider().strokeWidth(2).color('#F1F3F5').margin({ top: 8, bottom: 8 })
        }.margin({ top: 10 })

        //size
        Column({ space: 12 }) {
          Text($r("app.string.size_test_which_entries_in_cache"))
          Button($r("app.string.size_test_which_entries_in_cache"), { type: ButtonType.Normal })
            .fontSize(18)
            .fontColor('#000')
            .height(60)
            .width(300)
            .margin({ top: 20 })
            .backgroundColor('#12939f')
            .onClick(() => {
              this.cacheSize = cache.size()
            })
          Text(this.getResourceString($r("app.string.The_number_entries_currently_in_cache")) + this.cacheSize)
            .height(60)
            .fontSize(18)
          Divider().strokeWidth(2).color('#F1F3F5').margin({ top: 8, bottom: 8 })
        }.margin({ top: 10 })

        //memsize
        Column({ space: 12 }) {
          Text($r("app.string.memsize_test_returns_entries_that_occupy_cache_space_usually_size"))
          Button($r("app.string.memsize_test_returns_entries_that_occupy_cache_space"), { type: ButtonType.Normal })
            .fontSize(18)
            .fontColor('#000')
            .height(60)
            .width(300)
            .margin({ top: 20 })
            .backgroundColor('#12939f')
            .onClick(() => {
              this.cacheMemsize = cache.memsize()
            })
          Text(this.getResourceString($r("app.string.The_number_of_entries_that_occupy_cache_space")) + this.cacheMemsize)
            .height(60)
            .fontSize(18)
          Divider().strokeWidth(2).color('#F1F3F5').margin({ top: 8, bottom: 8 })
        }.margin({ top: 10 })

        //debug
        Column({ space: 12 }) {
          Text($r("app.string.debug_test_debug_switch"))
          Button($r("app.string.Turn_on_debug"), { type: ButtonType.Normal })
            .fontSize(18)
            .fontColor('#000')
            .height(60)
            .width(300)
            .margin({ top: 20 })
            .backgroundColor('#12939f')
            .onClick(() => {
              cache.debug(true)
              prompt.showToast({ message: this.getResourceString($r("app.string.Turn_on_debug_mode")), duration: 3000 })
            })
          Button($r("app.string.Turn_off_debugging"), { type: ButtonType.Normal })
            .fontSize(18)
            .fontColor('#000')
            .height(60)
            .width(300)
            .margin({ top: 20 })
            .backgroundColor('#12939f')
            .onClick(() => {
              cache.debug(false)
              prompt.showToast({ message: $r("app.string.Disable_debug_mode"), duration: 3000 })
            })
          Divider().strokeWidth(2).color('#F1F3F5').margin({ top: 8, bottom: 8 })
        }.margin({ top: 10 })

        //hits
        Column({ space: 12 }) {
          Text($r("app.string.Hits_test_returns_cached_hits_only_available_in_debug_mode"))
          Button($r("app.string.Hits_test_returns_cached_hits_only_available_in_debug_mode"), { type: ButtonType.Normal })
            .fontSize(18)
            .fontColor('#000')
            .height(60)
            .width(300)
            .margin({ top: 20 })
            .backgroundColor('#12939f')
            .onClick(() => {
              this.cacheHits = cache.hits()
            })
          Text(this.getResourceString($r("app.string.Cache_clicks")) + this.cacheHits)
            .height(60)
            .fontSize(18)
          Divider().strokeWidth(2).color('#F1F3F5').margin({ top: 8, bottom: 8 })
        }.margin({ top: 10 })

        //misses
        Column({ space: 12 }) {
          Text($r("app.string.misses_test_returns_cache_no_clicks_monitored_in_debug_mode_only"))
          Button($r("app.string.misses_test_returns_cache_no_clicks_monitored_in_debug_mode_only"), { type: ButtonType.Normal })
            .fontSize(18)
            .fontColor('#000')
            .height(60)
            .width(300)
            .margin({ top: 20 })
            .backgroundColor('#12939f')
            .onClick(() => {
              this.cacheMisses = cache.misses()
            })
          Text(this.getResourceString($r("app.string.The_number_of_cache_unclicks")) + this.cacheMisses)
            .height(60)
            .fontSize(18)
          Divider().strokeWidth(2).color('#F1F3F5').margin({ top: 8, bottom: 8 })
        }.margin({ top: 10 })

        //keys
        Column({ space: 12 }) {
          Text($r("app.string.keys_test_returns_all_cached_keys"))
          Button($r("app.string.keys_test_returns_all_cached_keys"), { type: ButtonType.Normal })
            .fontSize(18)
            .fontColor('#000')
            .height(60)
            .width(300)
            .margin({ top: 20 })
            .backgroundColor('#12939f')
            .onClick(() => {
              this.cacheKeys = cache.keys();
            })
          Text(this.getResourceString($r("app.string.All_cache_keys")) + this.cacheKeys)
            .height(60)
            .fontSize(18)
          Divider().strokeWidth(2).color('#F1F3F5').margin({ top: 8, bottom: 8 })
        }.margin({ top: 10 })

        //exportJson
        Column({ space: 12 }) {
          Text($r("app.string.exportJson_test_returns_all_cached_data"))
          Button($r("app.string.exportJson_test_returns_all_cached_data"), { type: ButtonType.Normal })
            .fontSize(18)
            .fontColor('#000')
            .height(60)
            .width(300)
            .margin({ top: 20 })
            .backgroundColor('#12939f')
            .onClick(() => {
              this.cacheExportJson = cache.exportJson();
              console.log(this.cacheExportJson);
            })
          Text(this.getResourceString($r("app.string.All_cached_data")) + this.cacheExportJson)
            .height(60)
            .fontSize(18)
          Divider().strokeWidth(2).color('#F1F3F5').margin({ top: 8, bottom: 8 })
        }.margin({ top: 10 })


        //importJson
        Column({ space: 12 }) {
          Text($r("app.string.importJson_test_import_data_Json_format"))
            .margin({ top: 5 })
            .fontSize(16)
          Text($r("app.string.importJson_test_override_test"))
            .margin({ top: 5 })
            .fontSize(16)
          TextInput({ text: this.default, placeholder:$r("app.string.importJson_test_override_test") })
            .height(60)
            .fontSize(18)
            .onChange((value: string) => {
              this.cacheImportJson = value
            })
          Button($r("app.string.importJson_test_imports_data_in_Json_format"), { type: ButtonType.Normal })
            .fontSize(18)
            .fontColor('#000')
            .height(60)
            .width(300)
            .margin({ top: 20 })
            .backgroundColor('#12939f')
            .onClick(() => {
              try {
                this.cacheImportJsonSize = cache.importJson(this.cacheImportJson,skipFn(false));
                prompt.showToast({ message: $r("app.string.The_write_succeeded"), duration: 3000 })
              } catch (err) {
                prompt.showToast({ message: '请输入json格式数据', duration: 3000 })
              }

            })
          Text(this.getResourceString($r("app.string.current_number_of_entries_the_cache_after_successful_write"))+ this.cacheImportJsonSize)
            .margin({ top: 5 })
            .fontSize(16)
          Divider().strokeWidth(2).color('#F1F3F5').margin({ top: 8, bottom: 8 })
        }.margin({ top: 10 })


        //importJson
        Column({ space: 12 }) {
          Text($r("app.string.importJson_test_import_data_Json_format"))
            .margin({ top: 5 })
            .fontSize(16)
          Text($r("app.string.importJson_test_override_test"))
            .margin({ top: 5 })
            .fontSize(16)
          TextInput({ text: this.default, placeholder:  $r("app.string.Please_enter_your_data") })
            .height(60)
            .fontSize(18)
            .onChange((value: string) => {
              this.cacheImportJson = value
            })
          Button($r("app.string.importJson_test_imports_data_in_Json_format"), { type: ButtonType.Normal })
            .fontSize(18)
            .fontColor('#000')
            .height(60)
            .width(300)
            .margin({ top: 20 })
            .backgroundColor('#12939f')
            .onClick(() => {
              try {
                this.cacheImportJsonSize = cache.importJson(this.cacheImportJson, skipFn(true));
                prompt.showToast({ message:  $r("app.string.The_write_succeeded"), duration: 3000 })
              } catch (err) {
                prompt.showToast({ message: $r("app.string.Please_enter_the_data_in_JSON_format"), duration: 3000 })
              }

            })
          Text(this.getResourceString($r("app.string.current_number_of_entries_the_cache_after_successful_write")) + this.cacheImportJsonSize)
            .margin({ top: 5 })
            .fontSize(16)
          Divider().strokeWidth(2).color('#F1F3F5').margin({ top: 8, bottom: 8 })
        }.margin({ top: 10 })

      }

    }
    .scrollable(ScrollDirection.Vertical)
    .scrollBar(BarState.Off)
    .scrollBarColor(Color.Gray)
    .scrollBarWidth(1)

  }
}