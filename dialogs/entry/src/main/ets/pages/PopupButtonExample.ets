import { ButtonAttributeModel, PopupButton } from '@ohos/dialogs'
import Prompt from '@system.prompt'

@Entry
@Component
struct PopupButtonExample {
  @State model1: ButtonAttributeModel = new ButtonAttributeModel()
  @State model2: ButtonAttributeModel = new ButtonAttributeModel()
  @State model3: ButtonAttributeModel = new ButtonAttributeModel()

  aboutToAppear() {
    this.model1.placement = Placement.Right
    this.model1.firstText = '赞'
    this.model1.secondText = '评论评论评论评论评论评论评论评论评论评论评论评论评论评论评论评论评论评论评论评论评论评论'
    this.model1.secondWidth = 150
    this.model1.firstAction = () => {
      Prompt.showToast({ message: JSON.stringify(this.model1.firstText) })
    }
    this.model1.secondAction = () => {
      Prompt.showToast({ message: JSON.stringify(this.model1.secondText) })
    }

    this.model2.placement = Placement.Top
    this.model3.placement = Placement.Left
    this.model3.firstText = '赞'
    this.model3.secondText = '评论评论评论评论评论'
    this.model3.secondWidth = 150
  }

  // action(model) {
  //   Prompt.showToast({ message: JSON.stringify(model.firstText) })
  // }

  build() {
    Column() {
      Row() {
        PopupButton({ model: this.model1 })
      }
      .layoutWeight(1)
      .width('100%')

      Row() {
        PopupButton({ model: this.model2 })
      }
      .layoutWeight(1)
      .justifyContent(FlexAlign.Center)
      .width('100%')

      Row() {
        PopupButton({ model: this.model3 })
      }
      .layoutWeight(1)
      .justifyContent(FlexAlign.End)
      .width('100%')
    }
    .width('100%')
    .height('100%')
  }
}