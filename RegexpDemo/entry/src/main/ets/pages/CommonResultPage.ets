import router from '@ohos.router';
import promptAction from '@ohos.promptAction';
import CommonResultBean from '../CommonResultBean';

@Entry
@Component
struct CommonResultPage {
  @State message: string = 'Hello World'
  @State beforeIndex: Array<number> = new Array<number>();
  @State beforeStr: Array<string> = new Array<string>();
  @State afterIndex: Array<number> = new Array<number>();
  @State afterStr: Array<string> = new Array<string>();

  onPageShow() {
    let data: CommonResultBean = null;
    if (router.getParams() && router.getParams['dataObj'] && router.getParams['dataObj'] instanceof CommonResultBean) {
      data = router.getParams['dataObj'];
      this.beforeStr = data.beforeStr;
      this.afterStr = data.beforeStr;
      for (let index = 0; index < this.beforeStr.length; index++) {
        this.beforeIndex = new Array<number>(this.beforeStr.length)
        this.beforeIndex[index] = index;
      }
      for (let index = 0; index < this.afterStr.length; index++) {
        this.afterIndex = new Array<number>(this.afterStr.length)
        this.afterIndex[index] = index;
      }
    }

    if (this.beforeIndex.length === 0 || this.afterIndex.length === 0 || this.beforeIndex.length != this.afterIndex.length) {
      promptAction.showDialog({
        title: '是否关闭本页面',
        message: '由于数据不正确，是否关闭本页面',
        buttons: [
          {
            text: '是',
            color: '#4455FF'
          },
          {
            text: '否',
            color: '#4455FF'
          }
        ]
      }, (err, result) => {
        if (err || !result) {
          return
        }
        if (result.index === 0) {
          router.back({
            url: 'pages/Index'
          })
        } else {

        }
      })
    }
  }

  build() {
    Row() {
      Column() {
        Flex({ direction: FlexDirection.Row }) {
          List({ space: 20, initialIndex: 0 }) {
            ForEach(this.beforeIndex, (item) => {
              ListItem() {
                Text('期待结果： ' + this.beforeStr[item])
                  .width('100%')
                  .height(100)
                  .fontSize(16)
                  .textAlign(TextAlign.Center)
                  .borderRadius(10)
                  .backgroundColor(0xFFFFFF)
              }
            }, item => item)
          }
          .listDirection(Axis.Vertical)
          .divider({ strokeWidth: 2, startMargin: 20, endMargin: 20 })
          .edgeEffect(EdgeEffect.None)
          .chainAnimation(false)
          .backgroundColor(Color.Red)
          .width('50%')
          .height('100%')

          List({ space: 20, initialIndex: 0 }) {
            ForEach(this.afterIndex, (item) => {
              ListItem() {
                Text('转换后： ' + this.afterStr[item])
                  .width('100%')
                  .height(100)
                  .fontSize(16)
                  .textAlign(TextAlign.Center)
                  .borderRadius(10)
                  .backgroundColor(0xFFFFFF)
              }
            }, item => item)
          }
          .listDirection(Axis.Vertical)
          .divider({ strokeWidth: 2, startMargin: 20, endMargin: 20 })
          .edgeEffect(EdgeEffect.None)
          .chainAnimation(false)
          .backgroundColor(Color.Green)
          .width('50%')
          .height('100%')
        }.width('100%')
        .height('100%')
      }
      .width('100%')
      .height('100%')
    }
    .width('100%')
    .height('100%')
  }
}