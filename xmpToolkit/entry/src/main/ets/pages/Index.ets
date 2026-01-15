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
    { text: '元数据对象创建与管理', url: 'pages/Meta' },
    { text: 'XMPSchemaRegistry命名空间和别名管理', url: 'pages/SchemaRegistry' },
    { text: 'XMPDateTime日期时间处理', url: 'pages/DateTime' },
    { text: '获取版本信息VersionInfo', url: 'pages/VersionInfo' },
    { text: '元数据解析与序列化', url: 'pages/MetaFactory' },
    { text: 'PathFactory路径构建', url: 'pages/PathFactory' },
    { text: '工具函数Utils', url: 'pages/Utils' },
    { text: '属性读写操作以及遍历', url: 'pages/Property' },
    { text: '不同类型属性访问与操作', url: 'pages/PropertyType' }
  ]

  build() {
    Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Center, justifyContent: FlexAlign.Center }) {
      Column() {
        ForEach(this.buttonConfigs, (item: ButtonConfig, index: number) => {
          Button(item.text, { type: ButtonType.Normal, stateEffect: true })
            .borderRadius(8)
            .width('80%')
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