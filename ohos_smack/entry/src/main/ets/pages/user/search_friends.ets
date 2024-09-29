/**
 * Copyright (C) 2023 Huawei Device Co., Ltd.
 *
 * This software is distributed under a license. The full license
 * agreement can be found in the file LICENSE in this distribution.
 * This software may not be copied, modified, sold or distributed
 * other than expressed in the named license agreement.
 *
 * This software is distributed without any warranty.
 */

import { Toolbar } from '../base/toolbar'

@Entry
@Component
struct Search_friends {
  @State resultList: Array<string> = []
  @State searchText: string = ''

  aboutToAppear() {
    this.onSearch()
  }

  build() {
    Column() {
      Toolbar({ title: getContext().resourceManager.getStringByNameSync('Search_String1') , isBack: true })

      Column() {
        TextInput({ placeholder: getContext().resourceManager.getStringByNameSync('Search_String1') })
          .width('100%')
          .padding(px2vp(10))
          .fontSize(px2fp(30))
          .height(px2vp(80))
          .fontColor(Color.Black)
          .onChange((value: string) => {
            this.searchText = value
            this.resultList = []
          })
          .onSubmit(v => {
            this.onSearch()
          })
      }
      .padding(10)
      .backgroundColor('#ffffff')

      List() {
        ForEach(this.resultList, (item:string) => {
          ListItem() {
            Flex({ direction: FlexDirection.Column }) {
              Text(item)
                .fontSize(px2fp(30))
                .padding(13)
                .margin({ top: 1 })
                .width('100%')
                .backgroundColor('#ffffff')
            }
          }
        }, (item:string) => JSON.stringify(item))
      }
    }
    .width('100%')
    .backgroundColor('#ececec')
  }

  // 搜索好友
  private onSearch() {
    for (let i = 0; i < 20; i++) {
      this.resultList.push(getContext().resourceManager.getStringByNameSync('Search_String2'))
    }
  }
}

