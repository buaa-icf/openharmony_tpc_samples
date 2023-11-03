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

import SmartRefreshForGame from './SmartRefreshForGame'
import {HitBlockGameCover} from './HitBlockGameCover'
import {HitBlockGameBody} from './HitBlockGameBody'

@Component
export struct HitBlock {
  @State model: SmartRefreshForGame.Model = new SmartRefreshForGame.Model()
  @State private welcomeIsStart: boolean = false
  @State private gameIsStart: boolean = false

  private changeState(state) {
    if (state == SmartRefreshForGame.REFRESHSTATE.TOREFRESH) { // 下拉中

    } else if (state == SmartRefreshForGame.REFRESHSTATE.REFRESHING) { // 刷新中
      if (!this.welcomeIsStart) {
        this.welcomeIsStart = true
        setTimeout(() => {
          this.gameIsStart = true
        }, 100)
      }
    } else { // 停止状态
      this.welcomeIsStart = false
      this.gameIsStart = false
    }
    return ''
  }

  build() {
    Stack({ alignContent: Alignment.TopStart }) {
      Text('' + this.changeState(this.model.refreshState)).visibility(Visibility.None)
      if (this.gameIsStart) {
        // 游戏主体界面
        HitBlockGameBody({
          downY: this.model.downY,
          mScreenHeight: this.model.initHeaderHeight,
          initBackgroundColor: this.model.backgroundColor,
          isNotifyFinish: this.model.isNotifyFinish
        })
      }
      // 游戏欢迎界面
      HitBlockGameCover({
        gameState: this.welcomeIsStart,
        maxHeight: this.model.initHeaderHeight,
        downY: this.model.downY,
        textColor: this.model.backgroundColor
      })
    }
    .height(this.model.initHeaderHeight)
  }
}