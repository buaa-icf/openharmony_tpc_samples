@CustomDialog
export struct InputCustomDialog {
  text:string = ""
  controller: CustomDialogController
  onButtonClick: (value:string) => void;

  build() {
    Column() {
      Column() {
        Text("带有输入框并贴着输入法的弹窗").fontSize(18).fontColor('#333').fontWeight(FontWeight.Bold)
      }
      .width('100%').height(48).backgroundColor('#eee').justifyContent(FlexAlign.Center)
      Column(){
        TextArea({placeholder:"请输入"}).backgroundColor("#fff").onChange((value:string) => {
          this.text = value;
        })
      }.width('100%').margin({top:15,left:20,right:20})
      Column(){
        Button("发表评论").width(150).onClick(() => {
          console.log("text: " + this.text)
          this.onButtonClick(this.text);
          this.controller.close();
        })
      }.width('100%').margin({top:10,bottom:10})
    }
    .width('100%').backgroundColor("#fff")
  }
}