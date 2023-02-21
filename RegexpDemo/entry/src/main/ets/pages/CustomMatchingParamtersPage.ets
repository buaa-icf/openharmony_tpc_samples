@Entry
@Component
struct CustomMatchingParamtersPage {
  @State message: string = 'CustomMatchingParamtersPage'

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