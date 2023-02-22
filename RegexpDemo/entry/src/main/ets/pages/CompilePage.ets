import TestApi from '../TestApi';
import CommonResultBean from '../CommonResultBean';
import promptAction from '@ohos.promptAction';
import router from '@ohos.router';

@Entry
@Component
struct CompilePage {
  @State message0: string = '原始数据：const toPath = compile("/user/:id", { encode: encodeURIComponent });'
  @State message1: string = '原始数据：toPath({ id: 123 });'
  @State message2: string = '原始数据：toPath({ id: "café" });'
  @State message3: string = '原始数据：toPath({ id: "/" });'
  @State message4: string = '原始数据：toPath({ id: ":/" })'
  @State message5: string = '原始数据：const toPathRaw = compile("/user/:id");'
  @State message6: string = '原始数据：toPathRaw({ id: "%3A%2F" });'
  @State message7: string = '原始数据：toPathRaw({ id: ":/" }, { validate: false });'
  @State message8: string = '原始数据：const toPathRepeated = compile("/:segment+");'
  @State message9: string = '原始数据：toPathRepeated({ segment: "foo" });'
  @State message10: string = '原始数据：toPathRepeated({ segment: ["a", "b", "c"] });'
  @State message11: string = '原始数据：const toPathRegexp = compile("/user/:id(\\d+)");'
  @State message12: string = '原始数据：toPathRegexp({ id: 123 });'
  @State message13: string = '原始数据：toPathRegexp({ id: "123" });'
  @State message14: string = '原始数据：toPathRegexp({ id: "abc" });'
  @State message15: string = '原始数据：toPathRegexp({ id: "abc" }, { validate: false });'

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
            let result = api.compileTest()
            if (!result || result.length < 12) {
              promptAction.showToast({
                message: '数据处理结果与预期不符',
                duration: 6000
              })
              return;
            }
            let bean = new CommonResultBean();
            let arrBefore = new Array<string>();
            arrBefore.push('toPath({ id: 123 }) 期待结果: \r\n ' + `/user/123`);
            arrBefore.push('toPath({ id: "café" }) 期待结果: \r\n ' + `/user/caf%C3%A9`);
            arrBefore.push('toPath({ id: "/" }) 期待结果: \r\n ' + `/user/%2F`);
            arrBefore.push('toPath({ id: ":/" }) 期待结果: \r\n ' + `/user/%3A%2F`);
            arrBefore.push('toPathRaw({ id: "%3A%2F" }) 期待结果: \r\n ' + `/user/%3A%2F`);
            arrBefore.push('toPathRaw({ id: ":/" }, { validate: false }) 期待结果: \r\n ' + `/user/:/`);
            arrBefore.push('toPathRepeated({ segment: "foo" }) 期待结果: \r\n ' + `/foo`);
            arrBefore.push('toPathRepeated({ segment: ["a", "b", "c"] }) 期待结果: \r\n ' + `/a/b/c`);
            arrBefore.push('toPathRegexp({ id: 123 }) 期待结果: \r\n ' + `/user/123`);
            arrBefore.push('toPathRegexp({ id: "123" }) 期待结果: \r\n ' + `/user/123`);
            arrBefore.push('toPathRegexp({ id: "abc" }) 期待结果: \r\n ' + `Throws TypeError`);
            arrBefore.push('toPathRegexp({ id: "abc" }, { validate: false }) 期待结果: \r\n ' + `/user/abc`);
            bean.setBefore(arrBefore);
            let arrAfter = new Array<string>();
            arrAfter.push(JSON.stringify(result[0]));
            arrAfter.push(JSON.stringify(result[1]));
            arrAfter.push(JSON.stringify(result[2]));
            arrAfter.push(JSON.stringify(result[3]));
            arrAfter.push(JSON.stringify(result[4]));
            arrAfter.push(JSON.stringify(result[5]));
            arrAfter.push(JSON.stringify(result[6]));
            arrAfter.push(JSON.stringify(result[7]));
            arrAfter.push(JSON.stringify(result[8]));
            arrAfter.push(JSON.stringify(result[9]));
            arrAfter.push(JSON.stringify(result[10]));
            arrAfter.push(JSON.stringify(result[11]));
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