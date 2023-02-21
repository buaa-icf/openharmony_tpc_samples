@Entry
@Component
struct UnnamedParametersPage {
  @State message: string = 'UnnamedParametersPage'

  build() {
    Row() {
      Column() {
        Text(this.message)
          .fontSize(50)
          .fontWeight(FontWeight.Bold)
      }
      .width('100%')
    }
    .height('100%')
  }
}