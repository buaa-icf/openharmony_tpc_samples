@Entry
@Component
struct NamedParamtersPage {
  @State message: string = 'NamedParamtersPage'

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