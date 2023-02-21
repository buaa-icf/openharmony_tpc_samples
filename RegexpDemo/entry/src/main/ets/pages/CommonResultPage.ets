@Entry
@Component
struct CommonResultPage {
  @State message: string = 'Hello World'
  beforeIndex: Array<number> = new Array<number>();
  beforeStr: Array<string> = new Array<string>();
  afterIndex: Array<number> = new Array<number>();
  afterStr: Array<string> = new Array<string>();

  build() {
    Row() {
      Column() {
        Flex({ direction: FlexDirection.Row }) {
          List({ space: 20, initialIndex: 0 }) {
            ForEach(this.beforeIndex, (item) => {
              ListItem() {
                Text(this.beforeStr[item])
                  .width('100%')
                  .height(100)
                  .fontSize(16)
                  .textAlign(TextAlign.Center)
                  .borderRadius(10)
                  .backgroundColor(0xFFFFFF)
              }
            }, item => item)
          }
          .listDirection(Axis.Vertical)
          .divider({ strokeWidth: 2, startMargin: 20, endMargin: 20 })
          .edgeEffect(EdgeEffect.None)
          .chainAnimation(false)
          .backgroundColor(Color.Red)
          .width('50%')
          .height('100%')

          List({ space: 20, initialIndex: 0 }) {
            ForEach(this.afterIndex, (item) => {
              ListItem() {
                Text(this.afterStr[item])
                  .width('100%')
                  .height(100)
                  .fontSize(16)
                  .textAlign(TextAlign.Center)
                  .borderRadius(10)
                  .backgroundColor(0xFFFFFF)
              }
            }, item => item)
          }
          .listDirection(Axis.Vertical)
          .divider({ strokeWidth: 2, startMargin: 20, endMargin: 20 })
          .edgeEffect(EdgeEffect.None)
          .chainAnimation(false)
          .backgroundColor(Color.Green)
          .width('50%')
          .height('100%')
        }.width('100%')
        .height('100%')
      }
      .width('100%')
      .height('100%')
    }
    .width('100%')
    .height('100%')
  }
}