import router from '@ohos.router'

// 声明按钮配置的类型
interface ButtonConfig {
  text: string;
  url: string;
}

@Entry
@Component
struct Index {
  // 按钮配置数组，使用显式类型
  private buttonConfigs: ButtonConfig[] = [
    { text: 'Meta接口测试', url: 'pages/Meta' },
    { text: 'SchemaRegistry接口测试', url: 'pages/SchemaRegistry' },
    { text: 'DateTime接口测试', url: 'pages/DateTime' },
    { text: 'VersionInfo接口测试', url: 'pages/VersionInfo' },
    { text: 'MetaFactory接口测试', url: 'pages/MetaFactory' },
    { text: 'PathFactory接口测试', url: 'pages/PathFactory' },
    { text: 'Utils接口测试', url: 'pages/Utils' },
    { text: 'Property接口测试', url: 'pages/Property' },
    { text: '提取文件XMP数据', url: 'pages/ExtractXmpData' }
  ]

  build() {
    Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Center, justifyContent: FlexAlign.Center }) {
      Column() {
        ForEach(this.buttonConfigs, (item: ButtonConfig, index: number) => {
          Button(item.text, { type: ButtonType.Normal, stateEffect: true })
            .borderRadius(8)
            .width('70%')
            .height('8%')
            .margin('2%')
            .onClick(() => {
              router.pushUrl({
                url: item.url
              })
            })
        }, (item: ButtonConfig) => item.text + item.url)
      }
    }
    .width('100%')
    .height('100%')
  }
}