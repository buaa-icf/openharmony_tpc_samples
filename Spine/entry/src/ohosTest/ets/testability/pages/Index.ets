import router from '@ohos.router';

@Entry
@Component
struct TestIndex {
  build() {
    Column({ space: 12 }) {
      Text('Spine UI Tests').fontSize(22).fontWeight(FontWeight.Bold).margin({ top: 40, bottom: 20 })

      Button('SingleExample').id('nav_single').width('80%')
        .onClick(() => { router.pushUrl({ url: 'pages/SingleExample' }); })

      Button('NetworkExample').id('nav_network').width('80%')
        .onClick(() => { router.pushUrl({ url: 'pages/NetworkExample' }); })

      Button('Example1').id('nav_example1').width('80%')
        .onClick(() => { router.pushUrl({ url: 'pages/Example1' }); })

      Button('Example2').id('nav_example2').width('80%')
        .onClick(() => { router.pushUrl({ url: 'pages/Example2' }); })

      Button('Example3').id('nav_example3').width('80%')
        .onClick(() => { router.pushUrl({ url: 'pages/Example3' }); })

      Button('Example4').id('nav_example4').width('80%')
        .onClick(() => { router.pushUrl({ url: 'pages/Example4' }); })
    }
    .width('100%').height('100%')
    .justifyContent(FlexAlign.Start)
    .alignItems(HorizontalAlign.Center)
  }
}
