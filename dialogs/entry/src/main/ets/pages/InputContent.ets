import { InputDialog,inputModel } from '@ohos/dialogs'

@Entry
@Component
struct InputDialogExample {
  @State inputValue: string = ''
  @State title: string = '标题'
  @State placeholder: string = '请输入'
  @State model:inputModel = new inputModel()
  aboutToAppear() {
    this.model.titleFontColor = '#ffffff'
    this.model.titleHeight = 60,
    this.model.contentFontColor = '#ffffff',
    this.model.cancelBtnFontColor = '#ffffff',
    this.model.cancelBtnBgColor = '#232323',
    this.model.cancelBtnTitle = 'cancel',
    this.model.btnBorder = {
      width: {right: 1},
      color:{right:'#ffffff'},
      style:{top:BorderStyle.Solid}
    },
    this.model.confirmBtnFontColor = '#ffffff',
    this.model.confirmBtnBgColor = '#232323',
    this.model.confirmBtnTitle = 'OK',
    this.model.isDisplayBtn = true,
    this.model.btnWidth = '50%',
    this.model.btnHeight = 60,
    this.model.btnContentMargin = {top: 30},
    this.model.placeholderColor = '#ffffff',
    this.model.dialogBgColor = '#232323',
    this.model.dialogPadding = {top: 10},
    this.model.inputBgColor =  '#232323',
    this.model.inputPadding = 0,
    this.model.inputMargin ={left:20,right:20},
    this.model.inputMargin = {left:20,right:20},
    this.model.inputBorderRadius = 0,
    this.model.btnContentBorder ={
      width: {top: 1},
      color:{top:'#ffffff'},
      style:{top:BorderStyle.Solid},
    },
    this.model.inputBorder ={
      width: {bottom: 1},
      color:{bottom:'#008577'},
      style:{top:BorderStyle.Solid}
   },
    this.model.titleFontColor = '#ffffff'
  }

  InputController: CustomDialogController = new CustomDialogController({
    builder: InputDialog({
      model: this.model,
      cancel: this.onCancel,
      confirm: this.confirm,
      inputValue: this.inputValue
    }),
    customStyle: true,
    alignment: DialogAlignment.Center,
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