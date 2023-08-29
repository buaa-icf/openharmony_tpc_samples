import { ConfirmDialog } from '@ohos/dialogs'
import { BaseCenterMode } from '@ohos/dialogs'
import { TestType } from '@ohos/hypium'

@Entry
@Component
struct ConfirmExample {
  @State textValue: string = '我是标题'
  @State contentValue: string = '床前明月光，疑是地上霜，举头望明月，低头思故乡。床前明月光，疑是地上霜，举头望明月，低头思故乡。'
  @State inputValue: string = 'click me'
  @State positionDialog: string = 'center'
  @State animitionMove:string = 'center'
  @State model:BaseCenterMode = new BaseCenterMode()

  aboutToAppear(){
    this.model.title = '我是标题',
    this.model.contentValue = '床前明月光，疑是地上霜，举头望明月，低头思故乡。床前明月光，疑是地上霜，举头望明月，低头思故乡。'
    // this.model.contentMargin = 20
    this.model.titleMargin = { top: 30,bottom: 10 }
    this.model.btnWidth = '100%'
    this.model.btnHeight = '100%'
    this.model.confirmBtnFontColor = '#87C5BF'
    this.model.confirmBtnBgColor = '#fff'
    this.model.confirm = this.onAccept
    this.model.btnContentHeight = 60
    this.model.btnContentMargin = { top: 20 }
    this.model.btnContentBorder = {
      width: { top: 1 },
      color:{ top:'#F0F0F0' },
      style:{ top:BorderStyle.Solid },
    }
  }

  dialogController: CustomDialogController = new CustomDialogController({
    builder: ConfirmDialog({
      slotContent: () => {
        this.componentBuilder()
      },
      model:this.model
    }),
    cancel: this.existApp,
    autoCancel: true,
    alignment: DialogAlignment.Center,
    offset: { dx: 0, dy: 0 },
    gridCount: 4,
    customStyle: true
  })

  // 在自定义组件即将析构销毁时将dialogControlle删除和置空
  aboutToDisappear() {
    delete this.dialogController, // 删除dialogController
    this.dialogController = undefined // 将dialogController置空
  }

  onAccept() {
    console.info('Callback when the second button is clicked')
  }

  existApp() {
    console.info('Click the callback in the blank area')
  }


  @Builder componentBuilder() {
    Text('床前明月光，疑是地上霜，举头望明月，低头思故乡。床前明月光，疑是地上霜，举头望明月，低头思故乡。')
      .fontSize(this.model.contentFontSize)
      .margin(20)
      .textAlign(this.model.contentTextAlign)
  }

  build() {
    Column() {
      Button('显示confirm弹窗').onClick(() => {
        this.dialogController.open()
      })
    }
  }
}
