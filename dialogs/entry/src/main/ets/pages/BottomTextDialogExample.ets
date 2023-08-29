import { BottomScrollDialog } from '@ohos/dialogs'

@Entry
@Component
struct BottomTextDialogExample {
  @State arr: string[] = ["这是一个自定义Bottom类型的弹窗！"]
  @Builder TextCustom() {
    Column() {
      Column(){
        Text("XPopup中通过View来加载Fragment的功能。\n\n在openHarmony中要实现弹框的功能，必须使用CustomDialog来进行自定义控件的实现").fontSize(20).fontColor('#444')
      }.padding(30)
    }.backgroundColor(0xFFFFFF).borderRadius(15).height('100%').width('100%')
  }

  dialogController:CustomDialogController = new CustomDialogController({
    builder: BottomScrollDialog({
      customComponent: (item, itemIndex) => {
        this.TextCustom();
      },
      arr:this.arr,
      dialogTitle: "下面是： 只给单独的Text控件的场景",
      scrollEmptyHeight: 0
    }),
    customStyle: true,
    autoCancel: true,
    alignment: DialogAlignment.Center,
    offset: { dx: 0, dy: 0 },
  })


  onBackPress() {
    console.log("onBackPress")
  }
  aboutToAppear(){

  }
  build(){
    Column(){
      Button("复杂交互的Bottom弹窗").onClick(() => {
        this.dialogController.open()
      })
    }.width('100%')
  }
}