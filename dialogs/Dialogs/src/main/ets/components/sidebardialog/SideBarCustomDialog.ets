import { SideBarModel } from '../model/SideBarModel'
const TAG = "SideBarCustomDialog"
@CustomDialog
export struct SideBarCustomDialog {
  @BuilderParam customComponent: () => void
  @State isShow: boolean = true
  @State model: SideBarModel = new SideBarModel();
  controller: CustomDialogController
  aboutToAppear() {
    this.isShow = this.model.initShow
    console.log(TAG, "isShow: " + this.isShow)
  }
  build(){
    SideBarContainer(SideBarContainerType.Embed) {
      Stack() {
          if (this.customComponent != undefined) {
            this.customComponent();
          }
      }
      Stack(){}
      .onClick(() => {
        console.info('onClick isShow: ' + this.isShow)
        this.isShow = false
      })
    }
    .sideBarPosition(this.model.sideBarPosition ? this.model.sideBarPosition : SideBarPosition.Start)
    .showControlButton(false)
    .showSideBar(this.isShow)
    .minSideBarWidth(this.model.minSideBarWidth ? this.model.minSideBarWidth : '30%')
    .maxSideBarWidth(this.model.maxSideBarWidth ? this.model.maxSideBarWidth : '100%')
    .onChange((value: boolean) => {
      this.isShow = value;
      if (!this.isShow) {
        this.controller.close();
      }
      console.info('status:' + value)
    })
  }
}
