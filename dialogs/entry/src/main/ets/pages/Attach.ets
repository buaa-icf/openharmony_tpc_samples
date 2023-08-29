import { ButtonAttributeModel, AttachButton } from '@ohos/dialogs'
import Prompt from '@system.prompt'

@Entry
@Component
struct PopupButtonExample {
  @State model1: ButtonAttributeModel = new ButtonAttributeModel()
  scroller: Scroller = new Scroller()
  @State customPopup: boolean = false
  aboutToAppear() {
    this.model1.placement = Placement.Bottom
    this.model1.buttonHeight = 60
    this.model1.popupColor = Color.Blue
    this.model1.enableArrow = false
  }
  @Builder specificNoParam() {
    Column() {
      Text("noParam").fontSize(20)
        .height(200).width(100)
    }
  }
  build() {
    Stack() {
      Flex({direction:FlexDirection.Column}) {
        Column(){
          AttachButton({ model: this.model1,noParam: this.specificNoParam})
        }.margin({top:20})
      }
    }.width('100%')
    .height('100%')

  }
}