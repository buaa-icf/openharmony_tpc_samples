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

@Component
struct SmartRefreshForGame {
  @BuilderParam header?: () => void
  @BuilderParam main?: () => void
  @State model: SmartRefreshForGame.Model = new SmartRefreshForGame.Model()
  private intervalId: number = 0
  private intervalId2: number = 0
  private intervalId3: number = 0
  private intervalId4: number = 0
  private touchDownY: number = 0
  private isMoveTopEnd: boolean = true
  @State private marginTop: number = 0

  public aboutToAppear() {
    if (this.header) {
      this.marginTop = -this.model.initHeaderHeight
    } else {
      this.marginTop = 0
    }
    this.model.finishRefresh1 = this.finishRefresh.bind(this)
    this.model.autoRefresh1 = this.autoRefresh.bind(this)
  }

  private autoRefresh() {
    if (this.marginTop <= -this.model.initHeaderHeight) {
      this.intervalId4 = setInterval(() => {
        if (this.marginTop <= 0) {
          this.marginTop += 20
          this.model.refreshState = SmartRefreshForGame.REFRESHSTATE.TOREFRESH
        } else {
          this.marginTop = 0
          this.model.refreshState = SmartRefreshForGame.REFRESHSTATE.REFRESHING
          if (this.model.refreshCallback) {
            if (!this.model.isNotifyFinish) {
              this.model.refreshCallback()
            }
          }
          clearInterval(this.intervalId4)
        }
      }, 1)
    }
  }

  private finishRefresh() {
    if (this.model.refreshState == SmartRefreshForGame.REFRESHSTATE.NONE) {
      return
    }
    if (this.marginTop < 0) {
      return
    }
    this.intervalId = setInterval(() => {
      if (this.marginTop > -this.model.initHeaderHeight) {
        this.marginTop -= 20
        this.model.refreshState = SmartRefreshForGame.REFRESHSTATE.TOREFRESH
      } else {
        this.model.refreshState = SmartRefreshForGame.REFRESHSTATE.NONE
        this.marginTop = -this.model.initHeaderHeight
        this.model.isNotifyFinish = false
        clearInterval(this.intervalId)
      }
    }, 1)
  }

  build() {
    Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Center, justifyContent: FlexAlign.Center }) {
      Column() {
        if (this.header) {
          this.header()
        }
        Scroll() {
          Column() {
            this.main()
          }
        }
        .onScrollEdge((side: Edge) => {
          if (side.valueOf() == Edge.Top) {
            this.isMoveTopEnd = true
          }
        })
        .onTouch(event => {
          let that = this
          let moveY = event.touches[0].y
          switch (event.type) {
            case TouchType.Down:
              that.touchDownY = moveY
            case TouchType.Move:
              let moveDistance = moveY - that.touchDownY
              that.model.downY = moveDistance
              that.model.isTouchMove = true
              if (that.marginTop != 0) {
                if (moveDistance >= 0 && that.isMoveTopEnd) { // 向下滑动
                  that.marginTop = -(that.model.initHeaderHeight - moveDistance)
                  that.model.refreshState = SmartRefreshForGame.REFRESHSTATE.TOREFRESH
                } else {
                  that.isMoveTopEnd = false
                }
              }
              break
            case TouchType.Up:
              if (that.marginTop < 0) {
                that.intervalId3 = setInterval(() => {
                  if (that.marginTop > -that.model.initHeaderHeight) {
                    that.marginTop -= 20
                  } else {
                    that.marginTop = -that.model.initHeaderHeight
                    that.model.refreshState = SmartRefreshForGame.REFRESHSTATE.NONE
                    clearInterval(that.intervalId3)
                  }
                }, 1)
              } else {
                that.model.isTouchMove = false
                if (that.model.isNotifyFinish) {
                  that.finishRefresh()
                }
                if (that.marginTop >= 0) {
                  that.intervalId2 = setInterval(() => {
                    if (that.marginTop > 0) {
                      that.marginTop -= 20
                    } else {
                      that.marginTop = 0
                      that.model.refreshState = SmartRefreshForGame.REFRESHSTATE.REFRESHING
                      if (this.model.refreshCallback) {
                        if (!this.model.isNotifyFinish) {
                          this.model.refreshCallback()
                        }
                      }
                      clearInterval(that.intervalId2)
                    }
                  }, 1)
                }
              }
              break
          }
        })
      }
      .margin({
        top: this.marginTop
      })
    }
    .width('100%')
    .height('100%')
  }
}

export default SmartRefreshForGame

namespace SmartRefreshForGame {

  export enum REFRESHSTATE {
    NONE = 0,
    TOREFRESH = 1,
    REFRESHING = 2,
  }

  export class Model {
    finishRefresh1: () => void
    autoRefresh1: () => void
    isTouchMove: boolean = false // 当前手指是否在移动
    isNotifyFinish: boolean = false // 是否通知了要停止刷新

    downY: number = 0 // 偏移量
    backgroundColor: Color | string | number = Color.Gray // 主题色
    initHeaderHeight: number = 200 // 头部高度
    refreshCallback: () => void // 刷新监听器
    refreshState: SmartRefreshForGame.REFRESHSTATE = SmartRefreshForGame.REFRESHSTATE.NONE // 刷新状态
    textGameOver: string = '游戏结束'
    textLoading: string = '玩个游戏解解闷'
    textLoadingFinish: string = '刷新完成'
    textLoadingFailed: string = '刷新失败'
    maskTextTopPull: string = '下拉开始游戏!'
    maskTextTopRelease: string = '释放立刻开始!'
    maskTextBottom: string = '上下滑动控制游戏'
    maskTextSizeTop: number = 20
    maskTextSizeBottom: number = 20
    blockHorizontalNum: number = 3
    ballSpeed: number = 3
    isFinishSuccess: boolean = true

    getDownY(): number{
      return this.downY
    }

    setBackgroundColor(color: Color | string | number): Model {
      this.backgroundColor = color
      return this
    }

    getBackgroundColor(): Color | string | number {
      return this.backgroundColor
    }

    setHeaderHeight(height: number): Model{
      this.initHeaderHeight = height
      return this
    }

    getHeaderHeight(): number{
      return this.initHeaderHeight
    }

    setRefreshCallback(callback: () => void): Model {
      this.refreshCallback = callback
      return this
    }

    getRefreshState(): SmartRefreshForGame.REFRESHSTATE{
      return this.refreshState
    }

    setTextGameOver(str: string): Model{
      this.textGameOver = str
      return this
    }

    getTextGameOver(): string{
      return this.textGameOver
    }

    setTextLoading(str: string): Model {
      this.textLoading = str
      return this
    }

    getTextLoading(): string{
      return this.textLoading
    }

    setTextLoadingFinish(str: string): Model{
      this.textLoadingFinish = str
      return this
    }

    getTextLoadingFinish(): string{
      return this.textLoadingFinish
    }

    setTextLoadingFailed(str: string): Model{
      this.textLoadingFailed = str
      return this
    }

    getTextLoadingFailed(): string{
      return this.textLoadingFailed
    }

    finishRefresh(isSuccess: boolean) {
      this.isFinishSuccess = isSuccess
      this.isNotifyFinish = true
      if (!this.isTouchMove) {
        this.finishRefresh1()
      }
    }

    autoRefresh() {
      this.autoRefresh1()
    }

    getMaskTextTopPull(): string{
      return this.maskTextTopPull
    }

    getMaskTextTopRelease(): string{
      return this.maskTextTopRelease
    }

    getMaskTextBottom(): string{
      return this.maskTextBottom
    }

    getMaskTextSizeTop(): number{
      return this.maskTextSizeTop
    }

    getMaskTextSizeBottom(): number{
      return this.maskTextSizeBottom
    }

    setMaskTextTopPull(maskTextTopPull: string): Model{
      this.maskTextTopPull = maskTextTopPull
      return this
    }

    setMaskTextTopRelease(maskTextTopRelease: string): Model{
      this.maskTextTopRelease = maskTextTopRelease
      return this
    }

    setMaskTextBottom(maskTextBottom: string): Model{
      this.maskTextBottom = maskTextBottom
      return this
    }

    setMaskTextSizeTop(maskTextSizeTop: number): Model{
      this.maskTextSizeTop = maskTextSizeTop
      return this
    }

    setMaskTextSizeBottom(maskTextSizeBottom: number): Model{
      this.maskTextSizeBottom = maskTextSizeBottom
      return this
    }

    setBlockHorizontalNum(blockHorizontalNum: number): Model{
      if (blockHorizontalNum > 10) {
        blockHorizontalNum = 10
      }
      if (blockHorizontalNum < 1) {
        blockHorizontalNum = 1
      }
      this.blockHorizontalNum = blockHorizontalNum
      return this
    }

    getBlockHorizontalNum(): number{
      return this.blockHorizontalNum
    }

    setBallSpeed(ballSpeed: number): Model{
      if (ballSpeed > 9) {
        ballSpeed = 9
      }
      if (ballSpeed < 1) {
        ballSpeed = 1
      }
      this.ballSpeed = ballSpeed
      return this
    }

    getBallSpeed(): number{
      return this.blockHorizontalNum
    }
  }
}

