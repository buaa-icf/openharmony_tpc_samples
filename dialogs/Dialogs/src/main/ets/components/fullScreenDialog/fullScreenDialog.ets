
@CustomDialog
export struct fullScreenDialog {
  controller: CustomDialogController
  @Prop slotBgColor:string = '#ffffff'

  @BuilderParam slotContent?: () => any;

  build() {
    Column() {
      this.slotContent()
    }.width('100%').height('100%').backgroundColor(this.slotBgColor)
  }
}