@Entry
@Component
struct Page {
  @State message: string = 'Hello World';

  build() {
    Column() {
      TextInput({ text: this.message})
      Text(this.message)
    }
    .height('100%')
    .width('100%')
  }
}