import { BaseCenterMode } from  '../model/BaseCenterModel'
@CustomDialog
export struct TopDialog {
  @Link isAnimation:boolean
  @State model: BaseCenterMode = new BaseCenterMode()
  @BuilderParam slotContent?: () => any
  controller: CustomDialogController

  aboutToAppear() {
    this.isAnimation = true
  }
  aboutToDisappear(){
    this.isAnimation = false
  }

  build() {
    Stack(){
      if(this.isAnimation) {
        Column(){
          this.slotContent()
        }
        .position({x:0,y:0})
        .width(this.model.dialogWidth)
        .height(this.model.dialogHeight)
        .backgroundColor(this.model.dialogBgColor)
        .transition(this.model.popupAnimation)
        .onClick(() =>{
          return
        })
      }
    }
    .height('100%').width('100%')
    .onClick(() =>{
      this.isAnimation = false
      this.controller.close()
    })
  }
}