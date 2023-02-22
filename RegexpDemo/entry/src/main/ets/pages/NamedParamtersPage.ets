import TestApi from '../TestApi';
import CommonResultBean from '../CommonResultBean';
import promptAction from '@ohos.promptAction';
import router from '@ohos.router';

@Entry
@Component
struct NamedParamtersPage {
  @State message0: string = '原始数据：const regexp = pathToRegexp("/:foo/:bar");'
  @State message1: string = '原始数据：regexp.exec("/test/route");'

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
            let result = api.namedParametersTest("/:foo/:bar")
            if (!result) {
              promptAction.showToast({
                message: '数据处理结果与预期不符',
                duration: 6000
              })
              return;
            }
            let bean = new CommonResultBean();
            let arrBefore = new Array<string>();
            arrBefore.push('regexp  期待结果: \r\n ' + `[ '/test/route', 'test', 'route', index: 0, input: '/test/route', groups: undefined ]`);
//            arrBefore.push('keys   期待结果: \r\n' + `[{ name: 'foo', prefix: '/', ... }, { name: 'bar', prefix: '/', ... }]`);
            bean.setBefore(arrBefore);
            let arrAfter = new Array<string>();
            arrAfter.push(JSON.stringify(result));
//            arrAfter.push(JSON.stringify(keys));
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