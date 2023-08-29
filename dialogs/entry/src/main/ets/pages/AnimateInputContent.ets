import { AnimateInputDialog,AnimateEffect,AnimateDialogOptions } from '@ohos/dialogs'

@Entry
@Component
struct AnimateInputContent {
  @State inputValue: string = ''
  @State title: string = '标题'
  @State placeholder: string = '请输入'
  @State animateOption: AnimateDialogOptions = { animate:AnimateEffect.ScaleCenterLeft}
  // CheckDialogController: CustomDialogController = new CustomDialogController
  InputController: CustomDialogController = new CustomDialogController({
    builder: AnimateInputDialog({
      animateOptions:$animateOption,
      cancel: () => this.onCancel(),
      confirm: () => this.confirm()
    }),
    customStyle: true,
    alignment: DialogAlignment.Center,
    openAnimation:{duration:3000},
    closeAnimation:{duration:3000}
  })
  onCancel() {
    console.info('Callback when the first button is clicked')
  }

  confirm() {
    console.info('Callback when the second button is clicked')
  }

  build() {
    Column(){
      Button('input弹窗').onClick(() => {
        this.InputController.open()
      })
    }
  }
}