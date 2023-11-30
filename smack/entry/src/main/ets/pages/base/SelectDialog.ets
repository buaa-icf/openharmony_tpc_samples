@CustomDialog
export struct SelectDialog {
  controller: CustomDialogController
  @Link vue: string
  options: any = []

  build() {
    Column() {
      List({  }) {
        ForEach(this.options, (item) => {
          ListItem() {
            Text(item.label)
              .width('100%')
              .height(50)
              .fontSize(16)
              .textAlign(TextAlign.Center)
              .borderRadius(10)
              .backgroundColor(0xFFFFFF)
          }.editable(true).onClick(v => {
            this.vue = item.label
            this.controller.close()
          })
        }, item => item.label)
      }.height(50 * this.options.length) .width('100%')
      .listDirection(Axis.Vertical) // 排列方向
    }
    .height(50 * this.options.length)
    .backgroundColor('#ffffff')
    .borderRadius(10)
    .width('60%')
  }
}
