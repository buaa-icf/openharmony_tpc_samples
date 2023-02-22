import TestApi from '../TestApi';
import CommonResultBean from '../CommonResultBean';
import promptAction from '@ohos.promptAction';
import router from '@ohos.router';

@Entry
@Component
struct CustomMatchingParamtersPage {
  @State message0: string = '原始数据：const regexpNumbers = pathToRegexp("/icon-:foo(\\d+).png");'
  @State message1: string = '原始数据：regexpNumbers.exec("/icon-123.png");'
  @State message2: string = '原始数据：regexpNumbers.exec("/icon-abc.png");'
  @State message3: string = '原始数据：const regexpWord = pathToRegexp("/(user|u)");'
  @State message4: string = '原始数据：regexpWord.exec("/u");'
  @State message5: string = '原始数据：regexpWord.exec("/users");'

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
        Text(this.message2)
          .fontSize(16)
          .textAlign(TextAlign.Center)
          .fontWeight(FontWeight.Bold)
          .backgroundColor(Color.Grey)
          .backgroundColor('#66E1E1E1')
          .fontColor(Color.Black)
        Text(this.message3)
          .fontSize(16)
          .textAlign(TextAlign.Center)
          .fontWeight(FontWeight.Bold)
          .backgroundColor(Color.Grey)
          .backgroundColor('#66E1E1E1')
          .fontColor(Color.Black)
        Text(this.message4)
          .fontSize(16)
          .textAlign(TextAlign.Center)
          .fontWeight(FontWeight.Bold)
          .backgroundColor(Color.Grey)
          .backgroundColor('#66E1E1E1')
          .fontColor(Color.Black)
        Text(this.message5)
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
            let result = api.customMatchingParametersTest()
            if (!result || result.length < 4) {
              promptAction.showToast({
                message: '数据处理结果与预期不符',
                duration: 6000
              })
              return;
            }
            let bean = new CommonResultBean();
            let arrBefore = new Array<string>();
            arrBefore.push('exec("/icon-123.png")  期待结果: \r\n ' + `['/icon-123.png', '123']`);
            arrBefore.push('exec("/icon-abc.png")  期待结果: \r\n ' + `['/icon-123.png', '123']`);
            arrBefore.push('exec("/u")  期待结果: \r\n ' + `['/icon-123.png', '123']`);
            arrBefore.push('exec("/users")  期待结果: \r\n ' + `['/icon-123.png', '123']`);
            bean.setBefore(arrBefore);
            let arrAfter = new Array<string>();
            arrAfter.push(JSON.stringify(result[0]));
            arrAfter.push(JSON.stringify(result[1]));
            arrAfter.push(JSON.stringify(result[2]));
            arrAfter.push(JSON.stringify(result[3]));
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