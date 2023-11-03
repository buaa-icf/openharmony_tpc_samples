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

@Component
export struct AirplaneGameBody {
  @State model: SmartRefreshForGame.Model = new SmartRefreshForGame.Model()
  @State private i: number = 0
  @State private enemyPlainList: Array<any> = [] // 敌机的数组
  @State private bulletList: Array<any> = [] // 存放子弹
  @State private myPlainY: number = 0 // 自己飞机的y位置
  @State private isGameOver: boolean = false // 游戏时是否结束
  @State private tipText: string = this.model.textLoading
  private flySpeed: number = 3 // 敌机速度
  private bulletSpeed: number = 8 // 子弹速度
  private enemyShowTime: number = 1000 // 敌机刷新时间
  private bulletShowTime: number = 500 // 子弹刷新时间
  private enemyPlainSize: number = 50 // 敌机大小
  private myPlainSize: number = 60 // 自己飞机的大小
  private bulletSize: number = 20 // 子弹大小

  private timeOutPlain: number = -1
  private timeOutBullet: number = -1
  private screenWidth: number = px2vp(720)
  @State @Watch('onGameStateChange') gameIsStart: boolean = false
  @State @Watch('onYStateChange') downY: number = 0
  initBackgroundColor: Color | string | number = ''
  maxHeight: number = px2vp(150)
  @State @Watch('onFinishChange') isNotifyFinish: boolean = false

  private onFinishChange() {
    if (this.isNotifyFinish) {
      this.tipText = this.model.isFinishSuccess? this.model.textLoadingFinish: this.model.textLoadingFailed
    }
  }

  private onGameStateChange() {
    if (this.gameIsStart) {
      this.startGame()
    } else {
      this.stopGame()
    }
  }

  private onYStateChange() {
    if (this.downY < 0) {
      this.myPlainY = 0
    } else if (this.downY > (this.maxHeight - this.myPlainSize)) {
      this.myPlainY = (this.maxHeight - this.myPlainSize)
    } else {
      this.myPlainY = this.downY
    }
  }

  private startGame() {
    this.timeOutBullet = -1
    this.timeOutPlain = -1
    this.gameIsStart = true
    this.isGameOver = false
    this.tipText = this.model.textLoading
  }

  private stopGame() {
    this.gameIsStart = false
    this.isGameOver = false
    this.bulletList = []
    this.enemyPlainList = []
    this.tipText = this.model.textLoading
  }

  aboutToAppear() {
    setInterval(() => {
      if (this.gameIsStart) {
        if (!this.isGameOver) {
          this.i++
        } else {
          clearTimeout(this.timeOutBullet)
          clearTimeout(this.timeOutPlain)
        }
      } else {
        clearTimeout(this.timeOutBullet)
        clearTimeout(this.timeOutPlain)
        //        this.timeOutBullet = -1
        //        this.timeOutPlain = -1
      }
    }, 10)
  }

// 主入口  绘制
  private onDraw() {
    if (!this.gameIsStart) {
      return
    }
    this.drawEnemyPlain() // 画敌机
    this.drawBullet() // 画子弹
    this.enemyPlainCollision() // 判断敌机是否被子弹击中
    this.isDie() // 判断自己是否死亡
    return ''
  }

// 绘制敌机且让敌机移动
  private drawEnemyPlain() {
    if (this.timeOutPlain == -1) {
      this.timeOutPlain = setTimeout(() => {
        let temp = {
          x: -(this.enemyPlainSize),
          y: Math.random() * (130 - this.enemyPlainSize)
        }
        this.enemyPlainList.push(temp)
        clearTimeout(this.timeOutPlain)
        this.timeOutPlain = -1
      }, this.enemyShowTime)
    }

    this.enemyPlainList.forEach((item, index) => {
      item.x = item.x + (this.flySpeed)
      if (item.x > this.screenWidth) {
        this.enemyPlainList.splice(index, 1)
      }
    })
  }

// 绘制子弹
  private drawBullet() {
    if (this.timeOutBullet == -1) {
      this.timeOutBullet = setTimeout(() => {
        let temp = {
          x: this.screenWidth - this.myPlainSize,
          y: this.myPlainY + (this.myPlainSize / 2) - (this.bulletSize / 2),
        }
        this.bulletList.push(temp)
        clearTimeout(this.timeOutBullet)
        this.timeOutBullet = -1
      }, this.bulletShowTime)
    }

    this.bulletList.forEach((item, index) => {
      item.x = item.x - this.bulletSpeed
      if (item.x < -50) {
        this.bulletList.splice(index, 1)
      }
    })
  }

//  判断敌机是否被子弹击中
  private enemyPlainCollision() {
    this.enemyPlainList.forEach((enemyItem, enemyIndex) => {
      this.bulletList.forEach((bulletItem, bulletIndex) => {
        let bulletX = bulletItem.x
        let bulletY = bulletItem.y + (this.bulletSize / 2)
        let enemyX = enemyItem.x
        let enemyY = enemyItem.y

        if (
        ((bulletX > enemyX) && (bulletX <= (enemyX + this.enemyPlainSize)))
        &&
        ((bulletY > enemyY) && (bulletY <= (enemyY + this.enemyPlainSize)))
        ) {
          this.enemyPlainList.splice(enemyIndex, 1)
          this.bulletList.splice(bulletIndex, 1)
        }
      })
    })
  }

// 判断自己是否死亡
  private isDie() {
    this.enemyPlainList.forEach(item => {
      let a1 = this.screenWidth - (this.myPlainSize / 2)
      let b1 = this.myPlainY + (this.myPlainSize / 2)
      let a2 = item.x + (this.enemyPlainSize / 2)
      let b2 = item.y + (this.enemyPlainSize / 2)

      let centerDistance = Math.sqrt(Math.pow((a1 - a2), 2) + Math.pow((b1 - b2), 2))
      if (centerDistance <= (this.myPlainSize / 2 + this.enemyPlainSize / 5)) {
        this.isGameOver = true
        clearTimeout(this.timeOutBullet)
        clearTimeout(this.timeOutPlain)
        this.tipText = this.model.textGameOver
        this.enemyPlainList = []
        this.bulletList = []
      }
    })
  }

  build() {
    Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Start, justifyContent: FlexAlign.Start }) {
      Text(this.i + this.onDraw() + '').visibility(Visibility.None)
      Stack({ alignContent: Alignment.TopStart }) {
        ForEach(this.enemyPlainList, item => {
          Image(this.initBackgroundColor == '#ffffff' ? $r("app.media.plan_diren_b") : $r("app.media.plan_diren"))
            .width(this.enemyPlainSize)
            .height(this.enemyPlainSize)
            .translate({
              x: item.x,
              y: item.y
            })
        }, item => item.toString())

        ForEach(this.bulletList, item => {
          Image(this.initBackgroundColor == '#ffffff' ? $r("app.media.zidan_b") : $r("app.media.zidan"))
            .width(this.bulletSize)
            .height(this.bulletSize)
            .translate({
              x: item.x,
              y: item.y
            })
        })

        Image(this.initBackgroundColor == '#ffffff' ? $r("app.media.plan_me_b") : $r("app.media.plan_me"))
          .width(this.myPlainSize)
          .height(this.myPlainSize)
          .translate({
            x: this.screenWidth - this.myPlainSize,
            y: this.myPlainY
          })

        Text(this.tipText)
          .width('100%')
          .height('100%')
          .textAlign(TextAlign.Center)
          .fontSize(30)
          .fontColor(this.initBackgroundColor == '#ffffff' ? '#000000' : '#ffffff')
      }
      .width('100%')
      .height(this.maxHeight)
      .backgroundColor(this.initBackgroundColor)

    }
    .width('100%')
    .height(this.maxHeight)
  }
}