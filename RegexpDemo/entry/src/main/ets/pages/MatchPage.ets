import TestApi from '../TestApi';
import CommonResultBean from '../CommonResultBean';
import promptAction from '@ohos.promptAction';
import router from '@ohos.router';

@Entry
@Component
struct MatchPage {
  @State message0: string = '原始数据：const fn = match("/user/:id", { decode: decodeURIComponent });'
  @State message1: string = '原始数据：fn("/user/123");'
  @State message2: string = '原始数据：fn("/invalid");'
  @State message3: string = '原始数据：fn("/user/caf%C3%A9");'
  @State message4: string = '原始数据：'+`const urlMatch = match("/users/:id/:tab(home|photos|bio)", {decode: decodeURIComponent,})`
  @State message5: string = '原始数据：urlMatch("/users/1234/photos");'
  @State message6: string = '原始数据：urlMatch("/users/1234/bio");'
  @State message7: string = '原始数据：urlMatch("/users/1234/otherstuff");'

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

        Text(this.message6)
          .fontSize(16)
          .textAlign(TextAlign.Center)
          .fontWeight(FontWeight.Bold)
          .backgroundColor(Color.Grey)
          .backgroundColor('#66E1E1E1')
          .fontColor(Color.Black)


        Text(this.message7)
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
            let result = api.matchTest()
            if (!result || result.length < 6) {
              promptAction.showToast({
                message: '数据处理结果与预期不符',
                duration: 6000
              })
              return;
            }
            let bean = new CommonResultBean();
            let arrBefore = new Array<string>();
            arrBefore.push('fn("/user/123") 期待结果: \r\n ' + `{ path: '/user/123', index: 0, params: { id: '123' } }`);
            arrBefore.push('fn("/invalid") 期待结果: \r\n ' + `false`);
            arrBefore.push('fn("/user/caf%C3%A9") 期待结果: \r\n ' + `{ path: '/user/caf%C3%A9', index: 0, params: { id: 'café' } }`);
            arrBefore.push('urlMatch("/users/1234/photos") 期待结果: \r\n ' + `{ path: '/users/1234/photos', index: 0, params: { id: '1234', tab: 'photos' } }`);
            arrBefore.push('urlMatch("/users/1234/bio") 期待结果: \r\n ' + `{ path: '/users/1234/bio', index: 0, params: { id: '1234', tab: 'bio' } }`);
            arrBefore.push('urlMatch("/users/1234/otherstuff") 期待结果: \r\n ' + `false`);
            bean.setBefore(arrBefore);
            let arrAfter = new Array<string>();
            arrAfter.push(JSON.stringify(result[0]));
            arrAfter.push(JSON.stringify(result[1]));
            arrAfter.push(JSON.stringify(result[2]));
            arrAfter.push(JSON.stringify(result[3]));
            arrAfter.push(JSON.stringify(result[4]));
            arrAfter.push(JSON.stringify(result[5]));
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