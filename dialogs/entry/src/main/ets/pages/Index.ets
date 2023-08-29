import router from '@ohos.router'

@Entry
@Component
struct Index {

  private pageList: string[] = [
    'SideBarContainerExample',
    'Confirm',
    'InputContent',
    'ListSelect',
    'Loading',
    'PositionContent',
    'FullScreen',
    'RealtimeInput',
    'Message',
    'PopupButtonExample',
    'TopContent',
    'BottomScrollDialogExample',
    'BottomTextDialogExample',
    'BottomListDialogExample',
    'ImageBrowser',
    'RepeatContent',
    'AnimateInputContent',
    'AnimateContent'
  ]


  @Builder buildPage(page: string) {
    Text(page)
      .width('100%')
      .height(60)
      .fontColor(Color.White)
      .fontSize(30)
      .textAlign(TextAlign.Center)
      .margin({ top: 10 })
      .onClick(() => {
        let path = 'pages/' + page
        console.log("jump:" + path);
        router.pushUrl({
          url: path,
        })
      })
  }

  build() {
    Flex({ direction: FlexDirection.Column }) {
      ForEach(this.pageList, (page) => {
        this.buildPage(page)
      })
    }
    .backgroundColor(Color.Black)
  }
}