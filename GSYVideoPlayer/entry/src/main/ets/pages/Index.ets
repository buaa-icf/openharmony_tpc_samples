/*
 * Copyright (c) 2023 Huawei Device Co., Ltd.
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
import router from "@ohos.router";
import {GlobalContext, LogUtils, PlayerType } from '@ohos/gsyvideoplayer'
import promptAction from '@ohos.promptAction';

@Entry
@Component
struct Index {
  getResourceString(res:Resource) {
    return getContext().resourceManager.getStringSync(res.id)
  }
  build() {
    Row() {
      Column() {
        Button($r('app.string.Switch_kernel_player')).margin(10).onClick(() => {
          if(GlobalContext.getContext().getObject("playType") == PlayerType.IJK_PLAYER) {
            GlobalContext.getContext().setObject("playType", PlayerType.SYSTEM_AVPLAYER);
          } else {
            GlobalContext.getContext().setObject("playType", PlayerType.IJK_PLAYER);
          }

          promptAction.showToast({
            message: GlobalContext.getContext()
              .getObject("playType") == PlayerType.IJK_PLAYER ? this.getResourceString($r('app.string.ijkPlayer_player')) : this.getResourceString($r('app.string.avplayer_player'))
          })
        })
        Button($r('app.string.Simple_player')).margin(10).onClick(() => {
          router.pushUrl({ url: "pages/SimpleDemo" });
        })
        Button($r('app.string.Cache_playing')).margin(10).onClick(() => {
          router.pushUrl({ url: "pages/PlayWithCacheDemo" });
        })
        Button($r('app.string.Simple_list_function')).margin(10).onClick(() => {
          router.pushUrl({ url: "pages/SimpleList" });
        })
        Button($r('app.string.Danmaku_player_function')).margin(10).onClick(() => {
          router.pushUrl({ url: "pages/DanmakuVideoDemo" });
        })
      }.width('100%')
    }.height('100%')
  }

  async aboutToAppear(){
    LogUtils.getInstance().setLogSwitch(true);
  }
}
