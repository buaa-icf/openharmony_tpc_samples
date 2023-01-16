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

import { CustomTabsIntent, CustomTabColorSchemeParams } from '@ohos/browser_customtabs';
import rpc from '@ohos.rpc';


@Entry
@Component
struct Index {
  @State message: string = '显示数据'
  @State want: string = ''

  build() {
    Row() {
      Column() {
        Scroll() {
          Text(this.want)
            .width('100%')
            .fontSize(20)
            .align(Alignment.Start)
            .textAlign(TextAlign.Start)
            .padding(15)
            .margin({ top: 10 })
            .onAppear(() => {
            })
        }
      }
      .width('100%')
      .height('90%')
    }
    .width('100%')
    .height('100%')
    .padding({ left: 15, right: 20 })
  }

  startBrowser() {
    let remoteObject = new Stub('want-test');
    let media = new Uint8Array();
    let schemeParams = new CustomTabColorSchemeParams.Builder()
      .setToobarColor(0xff0000)
      .setNavigationBarColor(0x00ff00)
      .setNavigationBarColor(0x0000ff)
      .setSecondaryToolbarColor(0xffff00)
        // @ts-ignore
      .building();
    let customTabsIntent = new CustomTabsIntent.Builder()
      .setDefaultColorSchemeParams(schemeParams)
      .setActionButton(media, 'action-button', remoteObject)
      .setCloseButtonIcon(media)
      .setShareState(true)
      .setUrlBarHidingEnabled(false)
      .setShowTitle(true)
      .addMenuItem('menu-item', remoteObject)
      .addToobarItem(0, media, 'toolbar-item', remoteObject)
      .building();

    customTabsIntent.launchUrl(globalThis.ability, 'https://www.baidu.com');
    this.want = customTabsIntent.getWant();
  }
}

class Stub extends rpc.RemoteObject {
  constructor(des) {
    if (typeof des == 'string') {
      super(des);
    } else {
      return null;
    }
  }

  onRemoteRequest(code, data, reply, option) {
    if (code === 1) {
      let token = data.readInterfaceToken();
      let num = data.readInt();
      this.method();
      return true;
    }
    return false;
  }

  method() {
    console.log('method called');
  }
}


