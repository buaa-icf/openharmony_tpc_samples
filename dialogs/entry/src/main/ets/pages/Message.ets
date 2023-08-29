import { MessageDialog, BaseCenterMode } from '@ohos/dialogs'

@Entry
@Component
struct Message {
  @State model:BaseCenterMode = new BaseCenterMode()
  @State textValue: string = '这里是消息内容'
  @State inputValue: string = '消息弹窗'
  @State isFixPosition: boolean = true
  @State positionDialog: string = 'top'
  @State blurValue: number = 0

  aboutToAppear(){
    this.model.contentValue = '这里是消息内容'
    this.model.contentPadding = 10
    this.model.dialogWidth = 300
    this.model.dialogBgColor = Color.Pink
  }

  dialogController: CustomDialogController = new CustomDialogController({
    builder: MessageDialog({
      model:this.model,
      isFixPosition: this.isFixPosition,
      positionDialog: this.positionDialog,
      blurValue: this.blurValue
    }),
    autoCancel: true,
    alignment: DialogAlignment.Center,
    offset: { dx: 0, dy: 0 },
    gridCount: 4,
    customStyle: true,
    maskColor: Color.Transparent,
  })
  // 在自定义组件即将析构销毁时将dialogControlle删除和置空
  aboutToDisappear() {
    delete this.dialogController, // 删除dialogController
    this.dialogController = undefined // 将dialogController置空
  }

  build() {
    Column() {
      Column().height(200).width(200).backgroundColor(Color.Yellow)
      Text('模糊效果')
      Button(this.inputValue)
        .onClick(() => {
          if (this.dialogController != undefined) {
            this.dialogController.open()
            this.blurValue = 50
          }
        })
    }.width('100%').height('100%').margin({ top: 25 })
    .backgroundColor(Color.White)
    .blur(this.blurValue)
  }
}
