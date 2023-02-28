import TestApi from '../TestApi';
import CommonResultBean from '../CommonResultBean';
import promptAction from '@ohos.promptAction';
import router from '@ohos.router';
@Entry
@Component
struct ProcessPathnamePage {
  @State message0: string = '原始数据：const fn = match("/café", { encode: encodeURI });'
  @State message1: string = '原始数据：fn("/caf%C3%A9");'

  build() {
    Row() {
      Column() {
        Text(this.message0)
          .fontSize(16)
          .textAlign(TextAlign.Center)
          .fontWeight(FontWeight.Bold)
          .backgroundColor('#22E1E1E1')
          .fontColor(Color.Black)


        Text(this.message1)
          .fontSize(16)
          .textAlign(TextAlign.Center)
          .fontWeight(FontWeight.Bold)
          .backgroundColor(Color.Grey)
          .backgroundColor('#66E1E1E1')
          .fontColor(Color.Black)



        Button('开始转换')
          .backgroundColor(Color.Blue)
          .fontColor(Color.White)
          .width('80%')
          .height(100)
          .onClick((event) => {
            let api = new TestApi()
            let result = api.processPathnameTest()
            if (!result || result.length < 1) {
              promptAction.showToast({
                message: '数据处理结果与预期不符',
                duration: 6000
              })
              return;
            }
            let bean = new CommonResultBean();
            let arrBefore = new Array<string>();
            arrBefore.push('fn("/caf%C3%A9") 期待结果: \r\n ' + `{ path: '/caf%C3%A9', index: 0, params: {} }`);
            bean.setBefore(arrBefore);
            let arrAfter = new Array<string>();
            arrAfter.push(JSON.stringify(result[0]));
            bean.setAfter(arrAfter);
            router.pushUrl({
              url: 'pages/CommonResultPage',
              params: {
                dataObj: bean
              }
            })
          })
      }
      .width('100%')
    }
    .height('100%')
  }
}