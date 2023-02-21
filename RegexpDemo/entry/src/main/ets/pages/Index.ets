import JumpPathConfig from '../JumpPathConfig';
import router from '@ohos.router';

async function routePage(index: number) {
  try {
    let jumpUri = JumpPathConfig.getJumpPath(index);
    let options: router.RouterOptions = {
      url: jumpUri
    }
    await router.pushUrl(options)
  } catch (err) {
    // TODO  hilog
  }
}

@Entry
@Component
struct Index {
  @State message: string = 'Hello World'
  private arrStr: string[] = JumpPathConfig.getText();
  private arrIndex: number[] = JumpPathConfig.getIndex();

  build() {
    Row() {
      Column() {
        Flex({ alignItems: ItemAlign.Center, alignContent: FlexAlign.Center, justifyContent: FlexAlign.Center }) {
          List({ space: 20, initialIndex: 0 }) {
            ForEach(this.arrIndex, (item) => {
              ListItem() {
                Text(this.arrStr[item])
                  .width('100%')
                  .height(100)
                  .fontSize(16)
                  .textAlign(TextAlign.Center)
                  .borderRadius(10)
                  .backgroundColor(0xFFFFFF)
              }.onClick((event) => {
                routePage(parseInt(item))
              })
            }, item => item)
          }.listDirection(Axis.Vertical)
          .divider({ strokeWidth: 2, startMargin: 20, endMargin: 20 })
          .edgeEffect(EdgeEffect.None)
          .chainAnimation(false)
        }
      }
      .width('100%')
    }
    .height('100%')
  }
}