import { ButtonAttributeModel } from '../model/ButtonAttributeModel'

@Component
export struct AttachButton {
  @State model: ButtonAttributeModel = new ButtonAttributeModel()
  @State customPopup: boolean = false
  @BuilderParam noParam: () => void;

  @Builder attachBuilder() {
    Column() {
      this.noParam()
    }
  }

  build() {
    Column(){
      Button(this.model.buttonText)
          .type(this.model.buttonType)
          .borderRadius(this.model.buttonBorderRadius)
          .backgroundColor(this.model.buttonBgColor)
          .fontSize(this.model.buttonFontSize)
          .fontColor(this.model.buttonFontColor)
          .width(this.model.buttonWidth)
          .height(this.model.buttonHeight)
        .onClick(() => {
          this.customPopup = !this.customPopup
        })
        .bindPopup(this.customPopup, {
          builder: this.attachBuilder,
          targetSpace: this.model.targetSpace,
          placement: this.model.placement,
          // maskColor: 0x33000000,
          popupColor: this.model.popupColor,
          enableArrow: this.model.enableArrow,
          onStateChange: (e) => {
            if (!e.isVisible) {
              this.customPopup = false
            }
          }
        })
    }.height(30)
  }
}