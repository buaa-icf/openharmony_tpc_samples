@Entry
@Component
struct OAuthSample {
  controller: WebController = new WebController();
  @State mode:MixedMode = MixedMode.All
  build() {
    Row() {
      Column() {
        Web({ src: 'https://test2.chenyu520.cn', controller: this.controller })
          .javaScriptAccess(true)
          .domStorageAccess(true)
          .imageAccess(true)
          .mixedMode(this.mode)
          .onConsole((event) => {
            console.log('getMessage:' + event.message.getMessage());
            console.log('getSourceId:' + event.message.getSourceId());
            console.log('getLineNumber:' + event.message.getLineNumber());
            console.log('getMessageLevel:' + event.message.getMessageLevel());
            return false;
          })
          .onAlert((event) => {
            AlertDialog.show({
              title: 'ArkTs-OAuth',
              message: event.message,
              primaryButton: {
                value: 'cancel',
                action: () => {
                  event.result.handleCancel()
                }
              },
              secondaryButton: {
                value: 'ok',
                action: () => {
                  event.result.handleConfirm()
                }
              },
              cancel: () => {
                event.result.handleCancel()
              }
            })
            return true
          })
      }
      .width('100%')
    }
    .height('100%')
  }
}

