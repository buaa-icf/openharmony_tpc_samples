import router from '@ohos.router';

@Entry
@Component
struct Index {
  build() {
    Column() {

      Column() {


        Button('加载一个动画')
          .margin({ top: 10 })
          .onClick(() => {
            router.pushUrl({ url: "pages/Example1" });
          })

        Button('加载网络动画')
          .margin({ top: 10 })
          .onClick(() => {
            router.pushUrl({ url: "pages/NetworkExample" });
          })

        Button('加载动画')
          .margin({ top: 10 })
          .onClick(() => {
            router.pushUrl({ url: "pages/SingleExample" });
          })


      }
      .padding(10)
    }
    .height('100%')
    .width('100%')
  }

}
