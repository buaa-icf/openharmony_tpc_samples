import { VAPPlayer } from '@ohos/vap'

@Entry
@Component
struct VapPage {
  @State showXComponent: boolean = false
  private xComponentId: string = 'vap_xcomponent'
  private vapPlayer?: VAPPlayer

  build() {
    Column() {
      Stack() {
        if (this.showXComponent) {
          XComponent({
            id: this.xComponentId,
            type: 'surface',
            libraryname: 'vap'
          })
            .onLoad((context?: object) => {
              if (context) {
                this.vapPlayer = new VAPPlayer(this.xComponentId)
                this.vapPlayer.setContext(context)
                this.vapPlayer?.play(getContext(this).filesDir + '/123.mp4')
              }
            })
            .backgroundColor(Color.Black)
            .width('80%')
            .height('90%')
        }
      }
      .layoutWeight(1)

      Row() {
        Button('Play')
          .onClick(() => {
              this.showXComponent = true
          })
          .margin({ right: 20 })

        Button('Stop')
          .onClick(() => {
            this.vapPlayer?.stop()
            this.vapPlayer = undefined
            this.showXComponent = false
          })
      }
      .width('100%')
      .justifyContent(FlexAlign.Center)
      .padding(20)
    }
    .width('100%')
    .height('100%')
  }
}
