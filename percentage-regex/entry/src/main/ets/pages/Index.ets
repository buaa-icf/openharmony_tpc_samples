import percentageRegex from 'percentage-regex';
import prompt from '@ohos.promptAction';

@Entry
@Component
struct Index {
  @State strArray: Array<string> = []
  @State data: Array<Object> = [
    { str: "检查字符串是否是百分数", str1: "80%", mode: 1 },
    { str: "匹配字符串中的百分数", str1: "weafdz 80% dawedafa", mode: 2 }
  ]

  build() {
    Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Start }) {
      List({ space: 20, initialIndex: 0 }) {
        ForEach(this.data, (item, index) => {
          ListItem() {
            Column() {
              Text(item.str)
                .fontSize(16)
                .margin({ top: 5 })
              TextInput({ text: item.str1, placeholder: '请输入字符串' })
                .height(60)
                .fontSize(18)
                .onChange((value: string) => {
                  item.str1 = value
                })
              Button('验证', { type: ButtonType.Normal })
                .fontSize(18)
                .fontColor('#000')
                .height(60)
                .width(300)
                .margin({ top: 20 })
                .backgroundColor('#12939f')
                .onClick(() => {
                  if (item.mode == 1) {
                    let result: boolean = percentageRegex({ exact: true }).test(item.str1)
                    prompt.showToast({ message: result.toString(), duration: 3000 })
                  } else {
                    this.strArray = item.str1.match(percentageRegex({ exact: false }))
                  }
                })
              if (item.mode == 2) {
                Text(JSON.stringify(this.strArray))
                  .fontSize(16)
                  .margin({ top: 5 })
              }
            }
          }
        })
      }
    }
  }
}