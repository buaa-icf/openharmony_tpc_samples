/**
 * Copyright (C) 2025 Huawei Device Co., Ltd.
 *
 * This software is distributed under a license. The full license
 * agreement can be found in the file LICENSE in this distribution.
 * This software may not be copied, modified, sold or distributed
 * other than expressed in the named license agreement.
 *
 * This software is distributed without any warranty.
 */

import { router } from '@kit.ArkUI';

@Entry
@Component
struct Index {
  build() {
    Column() {
      // 标题栏
      Text('SwipeMenuListView Demo')
        .fontSize(24)
        .fontWeight(FontWeight.Bold)
        .fontColor('#1976D2')
        .width('100%')
        .height(80)
        .textAlign(TextAlign.Center)
        .backgroundColor('#FFFFFF')

      // 内容区域
      Column({ space: 30 }) {
        Text('请选择演示页面')
          .fontSize(18)
          .fontColor('#333333')
          .margin({ top: 40 })

        // Demo 按钮区域
        Column({ space: 16 }) {
          // 综合演示按钮
          Button('综合演示')
            .width('70%')
            .height(50)
            .fontSize(16)
            .backgroundColor('#2196F3')
            .borderRadius(8)
            .onClick(() => {
              this.navigateToPage('pages/ComprehensiveDemo');
            })

          // 插值器演示按钮
          Button('插值器演示')
            .width('70%')
            .height(50)
            .fontSize(16)
            .backgroundColor('#4CAF50')
            .borderRadius(8)
            .onClick(() => {
              this.navigateToPage('pages/InterpolatorDemo');
            })

          // TouchConfig演示按钮
          Button('TouchConfig 演示')
            .width('70%')
            .height(50)
            .fontSize(16)
            .backgroundColor('#FF5722')
            .borderRadius(8)
            .onClick(() => {
              this.navigateToPage('pages/TouchConfigDemo');
            })
        }
        .width('100%')
        .alignItems(HorizontalAlign.Center)

        // 说明文字
        Column({ space: 8 }) {
          Text('使用说明：')
            .fontSize(14)
            .fontWeight(FontWeight.Medium)
            .fontColor('#666666')

          Text('左滑列表项可显示操作菜单')
            .fontSize(12)
            .fontColor('#999999')

          Text('不同用户类型有不同菜单选项')
            .fontSize(12)
            .fontColor('#999999')
        }
        .alignItems(HorizontalAlign.Start)
        .width('70%')
        .padding(16)
        .backgroundColor('#F8F8F8')
        .borderRadius(8)

      }
      .layoutWeight(1)
      .width('100%')
      .justifyContent(FlexAlign.Center)
      .alignItems(HorizontalAlign.Center)

    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F5F5F5')
  }

  // 页面跳转方法
  private navigateToPage(url: string): void {
    router.pushUrl({ url: url });
  }
}