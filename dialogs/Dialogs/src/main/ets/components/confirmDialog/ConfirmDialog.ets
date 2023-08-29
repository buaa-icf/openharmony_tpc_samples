import { BaseCenterMode } from '../model/BaseCenterModel'

@CustomDialog
export struct ConfirmDialog {
  @BuilderParam slotContent?: () => any;
  @State model: BaseCenterMode = new BaseCenterMode();
  controller: CustomDialogController
  // 若尝试在CustomDialog中传入多个其他的Controller，以实现在CustomDialog中打开另一个或另一些CustomDialog，那么此处需要将指向自己的controller放在最后

  build() {
    Column() {
      Text(this.model.title).fontSize(this.model.titleFontSize).margin(this.model.titleMargin).textAlign(this.model.titleTextAlign)
      Column(){
        this.slotContent()
      }
      if(this.model.isDisplayBtn) {
        Column(){
          Button(this.model.confirmBtnTitle,{ type: this.model.btnType })
            .fontColor(this.model.confirmBtnFontColor)
            .fontSize(this.model.btnFontSize)
            .backgroundColor(this.model.confirmBtnBgColor)
            .width(this.model.btnWidth)
            .height(this.model.btnHeight)
            .onClick(() =>{
              this.controller.close()
              this.model.confirm()

            })
            .borderRadius(this.model.confirmBtnBorderRadius)
        }
        .height(this.model.btnContentHeight).width(this.model.btnContentWidth)
        .margin(this.model.btnContentMargin)
        .border(this.model.btnContentBorder)
      }
    }
    .width(this.model.dialogWidth)
    .backgroundColor(this.model.dialogBgColor)
    .borderRadius(this.model.dialogBorderRadius)
  }
}
