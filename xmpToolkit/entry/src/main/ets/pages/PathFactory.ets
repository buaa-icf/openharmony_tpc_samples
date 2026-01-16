import { XMPMetaFactory, XMPPathFactory, XMPSchemaRegistry } from '@ohos/xmp_toolkit';

// 历史记录项类型定义
interface HistoryItem {
  function: string;
  params: string;
  result: string;
  time: number;
  timestamp: string;
}

@Entry
@Component
struct XMPPathFactoryValidator {
  // 功能选择
  @State selectedFunction: string = 'composeArrayItemPath';

  // composeArrayItemPath 参数
  @State arrayName: string = 'photoshop:History';
  @State itemIndex: number = 1;

  // composeStructFieldPath 参数
  @State structFieldNS: string = 'local://xap/1.0/';
  @State structFieldName: string = 'CreatorTool';

  // composeQualifierPath 参数
  @State qualifierNS: string = 'local://dc/elements/1.1/';
  @State qualifierName: string = 'description';

  // composeLangSelector 参数
  @State langArrayName: string = 'dc:title';
  @State langName: string = 'en-US';

  // composeFieldSelector 参数
  @State fieldArrayName: string = 'dc:subject';
  @State fieldSelectorNS: string = 'local://xap/1.0/';
  @State fieldSelectorName: string = 'type';
  @State fieldValue: string = 'keyword';

  // 输出结果
  @State result: string = '';
  @State errorMessage: string = '';
  @State executionTime: number = 0;
  @State showResult: boolean = false;

  // 历史记录
  @State history: HistoryItem[] = [];

  // 预定义数组
  @State predefinedArrays: string[] = [
    'photoshop:History',
    'dc:creator',
    'dc:title',
    'dc:description',
    'dc:subject',
    'xmp:Rating',
    'xmp:Label',
    'ArrayProp'
  ];

  // 预定义命名空间 - 使用本地URI
  @State predefinedNamespaces: string[] = [
    'local://xap/1.0/',
    'local://dc/elements/1.1/',
    'local://exif/1.0/',
    'local://photoshop/1.0/',
    'local://tiff/1.0/'
  ];

  // 预定义语言
  @State predefinedLanguages: string[] = [
    'en-US',
    'zh-CN',
    'zh-TW',
    'ja-JP',
    'ko-KR',
    'fr-FR',
    'de-DE',
    'es-ES'
  ];

  // 已注册的命名空间映射
  private registeredNamespaces: Map<string, string> = new Map();

  aboutToAppear() {
    // 初始化时自动注册常用命名空间
    this.registerCommonNamespaces();
  }

  // 注册常用命名空间
  private registerCommonNamespaces(): void {
    try {
      const registry = XMPMetaFactory.getSchemaRegistry();

      // XMP命名空间 - 使用本地URI
      registry.registerNamespace('local://xap/1.0/', 'xmp');
      this.registeredNamespaces.set('local://xap/1.0/', 'xmp');

      // DC命名空间 - 使用本地URI
      registry.registerNamespace('local://dc/elements/1.1/', 'dc');
      this.registeredNamespaces.set('local://dc/elements/1.1/', 'dc');

      // EXIF命名空间 - 使用本地URI
      registry.registerNamespace('local://exif/1.0/', 'exif');
      this.registeredNamespaces.set('local://exif/1.0/', 'exif');

      // Photoshop命名空间 - 使用本地URI
      registry.registerNamespace('local://photoshop/1.0/', 'photoshop');
      this.registeredNamespaces.set('local://photoshop/1.0/', 'photoshop');

      // TIFF命名空间 - 使用本地URI
      registry.registerNamespace('local://tiff/1.0/', 'tiff');
      this.registeredNamespaces.set('local://tiff/1.0/', 'tiff');

      // XMP-Rights命名空间 - 使用本地URI
      registry.registerNamespace('local://xap/1.0/rights/', 'xmpRights');
      this.registeredNamespaces.set('local://xap/1.0/rights/', 'xmpRights');

      // XMP-MM命名空间 - 使用本地URI
      registry.registerNamespace('local://xap/1.0/mm/', 'xmpMM');
      this.registeredNamespaces.set('local://xap/1.0/mm/', 'xmpMM');

    } catch (error) {
      console.error('注册命名空间失败:', error);
    }
  }

  // 检查并注册命名空间
  private ensureNamespaceRegistered(namespaceURI: string, preferredPrefix?: string): boolean {
    if (this.registeredNamespaces.has(namespaceURI)) {
      return true;
    }

    try {
      const registry = XMPMetaFactory.getSchemaRegistry();

      // 如果没有提供前缀，尝试从URI中提取
      let prefix = preferredPrefix;
      if (!prefix) {
        // 从URI中提取一个简单的名字作为前缀
        const matches = namespaceURI.match(/\/([^\/]+)\/$/);
        prefix = matches ? matches[1] : 'ns';
      }

      // 尝试注册
      const actualPrefix = registry.registerNamespace(namespaceURI, prefix);
      this.registeredNamespaces.set(namespaceURI, actualPrefix);
      return true;
    } catch (error) {
      console.error(`注册命名空间失败: ${namespaceURI}`, error);
      return false;
    }
  }

  build() {
    Column() {
      // 标题 - 固定在顶部
      this.buildHeader()

      // 主要内容区域 - 固定位置，不要居中
      Column() {
        // 功能选择区域
        this.buildFunctionSelector()

        // 参数输入区域 - 紧挨着功能选择
        this.buildParameterInputs()

        // 执行按钮 - 紧挨着参数输入
        this.buildExecutionButtons()

        // 结果区域 - 有条件显示，位置固定
        if (this.showResult) {
          this.buildResultPanel()
        }

        // 历史记录区域 - 使用Scroll只滚动历史部分
        this.buildHistoryPanel()
      }
      .width('100%')
      .layoutWeight(1)
    }
    .width('100%')
    .height('100%')
    .padding({ left: 12, right: 12 })
    .backgroundColor('#F5F7FA')
  }

  @Builder
  buildHeader() {
    Column({ space: 4 }) {
      Text('XMP路径生成功能验证')
        .fontSize(20)
        .fontWeight(FontWeight.Bold)
        .fontColor('#1A1A1A')

      Text('输入参数测试XMP路径生成')
        .fontSize(12)
        .fontColor('#666666')
    }
    .width('100%')
    .padding({ top: 12, bottom: 8 })
    .backgroundColor('#F5F7FA')
  }

  @Builder
  buildFunctionSelector() {
    Column() {
      Text('选择功能')
        .fontSize(14)
        .fontWeight(FontWeight.Medium)
        .fontColor('#1A1A1A')
        .width('100%')
        .margin({ bottom: 8 })

      Scroll() {
        Row({ space: 8 }) {
          Button('数组路径')
            .height(36)
            .backgroundColor(this.selectedFunction === 'composeArrayItemPath' ? '#1890FF' : '#F0F0F0')
            .fontColor(this.selectedFunction === 'composeArrayItemPath' ? Color.White : '#666666')
            .fontSize(13)
            .padding({ left: 12, right: 12 })
            .onClick(() => {
              this.selectedFunction = 'composeArrayItemPath';
              this.clearResult();
            })

          Button('结构体字段')
            .height(36)
            .backgroundColor(this.selectedFunction === 'composeStructFieldPath' ? '#1890FF' : '#F0F0F0')
            .fontColor(this.selectedFunction === 'composeStructFieldPath' ? Color.White : '#666666')
            .fontSize(13)
            .padding({ left: 12, right: 12 })
            .onClick(() => {
              this.selectedFunction = 'composeStructFieldPath';
              this.clearResult();
            })

          Button('限定符')
            .height(36)
            .backgroundColor(this.selectedFunction === 'composeQualifierPath' ? '#1890FF' : '#F0F0F0')
            .fontColor(this.selectedFunction === 'composeQualifierPath' ? Color.White : '#666666')
            .fontSize(13)
            .padding({ left: 12, right: 12 })
            .onClick(() => {
              this.selectedFunction = 'composeQualifierPath';
              this.clearResult();
            })

          Button('语言选择器')
            .height(36)
            .backgroundColor(this.selectedFunction === 'composeLangSelector' ? '#1890FF' : '#F0F0F0')
            .fontColor(this.selectedFunction === 'composeLangSelector' ? Color.White : '#666666')
            .fontSize(13)
            .padding({ left: 12, right: 12 })
            .onClick(() => {
              this.selectedFunction = 'composeLangSelector';
              this.clearResult();
            })

          Button('字段选择器')
            .height(36)
            .backgroundColor(this.selectedFunction === 'composeFieldSelector' ? '#1890FF' : '#F0F0F0')
            .fontColor(this.selectedFunction === 'composeFieldSelector' ? Color.White : '#666666')
            .fontSize(13)
            .padding({ left: 12, right: 12 })
            .onClick(() => {
              this.selectedFunction = 'composeFieldSelector';
              this.clearResult();
            })
        }
        .padding(4)
      }
      .scrollable(ScrollDirection.Horizontal)
      .scrollBar(BarState.Off)
      .height(48)
    }
    .width('100%')
    .padding({ left: 2, right: 2, bottom: 8 })
  }

  @Builder
  buildParameterInputs() {
    Column({ space: 12 }) {
      Text('输入参数')
        .fontSize(15)
        .fontWeight(FontWeight.Medium)
        .fontColor('#1A1A1A')
        .width('100%')

      if (this.selectedFunction === 'composeArrayItemPath') {
        this.buildArrayItemPathInputs()
      } else if (this.selectedFunction === 'composeStructFieldPath') {
        this.buildStructFieldPathInputs()
      } else if (this.selectedFunction === 'composeQualifierPath') {
        this.buildQualifierPathInputs()
      } else if (this.selectedFunction === 'composeLangSelector') {
        this.buildLangSelectorInputs()
      } else if (this.selectedFunction === 'composeFieldSelector') {
        this.buildFieldSelectorInputs()
      }
    }
    .width('100%')
    .padding(12)
    .backgroundColor(Color.White)
    .borderRadius(8)
  }

  @Builder
  buildArrayItemPathInputs() {
    Column({ space: 10 }) {
      Row({ space: 10 }) {
        Text('数组名称:')
          .fontSize(14)
          .fontColor('#666666')
          .width(70)

        TextInput({ text: this.arrayName, placeholder: '输入数组名称' })
          .layoutWeight(1)
          .height(34)
          .fontSize(14)
          .onChange((value: string) => {
            this.arrayName = value;
            this.clearResult();
          })
      }

      Row({ space: 10 }) {
        Text('索引值:')
          .fontSize(14)
          .fontColor('#666666')
          .width(70)

        TextInput({ text: this.itemIndex.toString(), placeholder: '输入索引值' })
          .layoutWeight(1)
          .height(34)
          .fontSize(14)
          .type(InputType.Number)
          .onChange((value: string) => {
            const num = parseInt(value);
            if (!isNaN(num)) {
              this.itemIndex = num;
              this.clearResult();
            }
          })
      }

      // 预设值选择
      if (this.predefinedArrays.length > 0) {
        Column({ space: 6 }) {
          Text('快捷选择:')
            .fontSize(13)
            .fontColor('#666666')

          Scroll() {
            Row({ space: 6 }) {
              ForEach(this.predefinedArrays, (item: string) => {
                Text(item)
                  .fontSize(12)
                  .padding({ left: 10, right: 10, top: 6, bottom: 6 })
                  .backgroundColor(this.arrayName === item ? '#E6F7FF' : '#F5F5F5')
                  .border({ width: 1, color: this.arrayName === item ? '#91D5FF' : '#D9D9D9' })
                  .borderRadius(4)
                  .onClick(() => {
                    this.arrayName = item;
                    this.clearResult();
                  })
              })
            }
            .padding({ right: 6 })
          }
          .scrollable(ScrollDirection.Horizontal)
          .scrollBar(BarState.Off)
          .height(38)
        }
      }
    }
  }

  @Builder
  buildStructFieldPathInputs() {
    Column({ space: 10 }) {
      Row({ space: 10 }) {
        Text('命名空间:')
          .fontSize(14)
          .fontColor('#666666')
          .width(70)

        TextInput({ text: this.structFieldNS, placeholder: '输入命名空间URI' })
          .layoutWeight(1)
          .height(34)
          .fontSize(14)
          .onChange((value: string) => {
            this.structFieldNS = value;
            this.clearResult();
          })
      }

      Row({ space: 10 }) {
        Text('字段名称:')
          .fontSize(14)
          .fontColor('#666666')
          .width(70)

        TextInput({ text: this.structFieldName, placeholder: '输入字段名称' })
          .layoutWeight(1)
          .height(34)
          .fontSize(14)
          .onChange((value: string) => {
            this.structFieldName = value;
            this.clearResult();
          })
      }

      // 预定义命名空间
      if (this.predefinedNamespaces.length > 0) {
        Column({ space: 6 }) {
          Text('常用命名空间:')
            .fontSize(13)
            .fontColor('#666666')

          Scroll() {
            Row({ space: 6 }) {
              ForEach(this.predefinedNamespaces, (ns: string) => {
                Text(ns.length > 25 ? ns.substring(0, 25) + '...' : ns)
                  .fontSize(12)
                  .padding({ left: 10, right: 10, top: 6, bottom: 6 })
                  .backgroundColor(this.structFieldNS === ns ? '#E6F7FF' : '#F5F5F5')
                  .border({ width: 1, color: this.structFieldNS === ns ? '#91D5FF' : '#D9D9D9' })
                  .borderRadius(4)
                  .onClick(() => {
                    this.structFieldNS = ns;
                    this.clearResult();
                  })
              })
            }
            .padding({ right: 6 })
          }
          .scrollable(ScrollDirection.Horizontal)
          .scrollBar(BarState.Off)
          .height(38)
        }
      }
    }
  }

  @Builder
  buildQualifierPathInputs() {
    Column({ space: 10 }) {
      Row({ space: 10 }) {
        Text('命名空间:')
          .fontSize(14)
          .fontColor('#666666')
          .width(70)

        TextInput({ text: this.qualifierNS, placeholder: '输入限定符命名空间URI' })
          .layoutWeight(1)
          .height(34)
          .fontSize(14)
          .onChange((value: string) => {
            this.qualifierNS = value;
            this.clearResult();
          })
      }

      Row({ space: 10 }) {
        Text('限定符名:')
          .fontSize(14)
          .fontColor('#666666')
          .width(70)

        TextInput({ text: this.qualifierName, placeholder: '输入限定符名称' })
          .layoutWeight(1)
          .height(34)
          .fontSize(14)
          .onChange((value: string) => {
            this.qualifierName = value;
            this.clearResult();
          })
      }
    }
  }

  @Builder
  buildLangSelectorInputs() {
    Column({ space: 10 }) {
      Row({ space: 10 }) {
        Text('数组名称:')
          .fontSize(14)
          .fontColor('#666666')
          .width(70)

        TextInput({ text: this.langArrayName, placeholder: '输入数组名称' })
          .layoutWeight(1)
          .height(34)
          .fontSize(14)
          .onChange((value: string) => {
            this.langArrayName = value;
            this.clearResult();
          })
      }

      Row({ space: 10 }) {
        Text('语言代码:')
          .fontSize(14)
          .fontColor('#666666')
          .width(70)

        TextInput({ text: this.langName, placeholder: '输入语言代码如 en-US' })
          .layoutWeight(1)
          .height(34)
          .fontSize(14)
          .onChange((value: string) => {
            this.langName = value;
            this.clearResult();
          })
      }

      // 常用语言
      if (this.predefinedLanguages.length > 0) {
        Column({ space: 6 }) {
          Text('常用语言:')
            .fontSize(13)
            .fontColor('#666666')

          Scroll() {
            Row({ space: 6 }) {
              ForEach(this.predefinedLanguages, (lang: string) => {
                Text(lang)
                  .fontSize(12)
                  .padding({ left: 10, right: 10, top: 6, bottom: 6 })
                  .backgroundColor(this.langName === lang ? '#E6F7FF' : '#F5F5F5')
                  .border({ width: 1, color: this.langName === lang ? '#91D5FF' : '#D9D9D9' })
                  .borderRadius(4)
                  .onClick(() => {
                    this.langName = lang;
                    this.clearResult();
                  })
              })
            }
            .padding({ right: 6 })
          }
          .scrollable(ScrollDirection.Horizontal)
          .scrollBar(BarState.Off)
          .height(38)
        }
      }
    }
  }

  @Builder
  buildFieldSelectorInputs() {
    Column({ space: 10 }) {
      Row({ space: 10 }) {
        Text('数组名称:')
          .fontSize(14)
          .fontColor('#666666')
          .width(70)

        TextInput({ text: this.fieldArrayName, placeholder: '输入数组名称' })
          .layoutWeight(1)
          .height(34)
          .fontSize(14)
          .onChange((value: string) => {
            this.fieldArrayName = value;
            this.clearResult();
          })
      }

      Row({ space: 10 }) {
        Text('命名空间:')
          .fontSize(14)
          .fontColor('#666666')
          .width(70)

        TextInput({ text: this.fieldSelectorNS, placeholder: '输入字段命名空间URI' })
          .layoutWeight(1)
          .height(34)
          .fontSize(14)
          .onChange((value: string) => {
            this.fieldSelectorNS = value;
            this.clearResult();
          })
      }

      Row({ space: 10 }) {
        Text('字段名称:')
          .fontSize(14)
          .fontColor('#666666')
          .width(70)

        TextInput({ text: this.fieldSelectorName, placeholder: '输入字段名称' })
          .layoutWeight(1)
          .height(34)
          .fontSize(14)
          .onChange((value: string) => {
            this.fieldSelectorName = value;
            this.clearResult();
          })
      }

      Row({ space: 10 }) {
        Text('字段值:')
          .fontSize(14)
          .fontColor('#666666')
          .width(70)

        TextInput({ text: this.fieldValue, placeholder: '输入字段值' })
          .layoutWeight(1)
          .height(34)
          .fontSize(14)
          .onChange((value: string) => {
            this.fieldValue = value;
            this.clearResult();
          })
      }
    }
  }

  @Builder
  buildExecutionButtons() {
    Row({ space: 8 }) {
      Button('生成路径')
        .width('48%')
        .height(38)
        .backgroundColor('#52C41A')
        .fontColor(Color.White)
        .fontSize(14)
        .fontWeight(FontWeight.Medium)
        .onClick(() => this.executeFunction())

      Button('重置参数')
        .width('48%')
        .height(38)
        .backgroundColor('#FAAD14')
        .fontColor(Color.White)
        .fontSize(14)
        .onClick(() => this.resetParameters())
    }
    .width('100%')
    .padding(12)
    .backgroundColor(Color.White)
    .borderRadius(8)
    .margin({ top: 8 })
  }

  @Builder
  buildResultPanel() {
    Column({ space: 8 }) {
      Row() {
        Text('测试结果')
          .fontSize(15)
          .fontWeight(FontWeight.Medium)
          .fontColor('#1A1A1A')
          .layoutWeight(1)

        if (this.executionTime > 0) {
          Text(`${this.executionTime}ms`)
            .fontSize(12)
            .fontColor('#8C8C8C')
        }
      }
      .width('100%')

      if (this.errorMessage) {
        Column({ space: 6 }) {
          Row() {
            Text('❌')
              .fontSize(14)
              .fontColor('#F5222D')
              .margin({ right: 6 })
            Text('执行失败')
              .fontSize(14)
              .fontColor('#F5222D')
              .layoutWeight(1)
          }

          Text(this.errorMessage)
            .fontSize(13)
            .fontColor('#F5222D')
            .width('100%')
            .backgroundColor('#FFF2F0')
            .padding(10)
            .borderRadius(6)
        }
      } else if (this.result) {
        Column({ space: 6 }) {
          Row() {
            Text('✅')
              .fontSize(14)
              .fontColor('#52C41A')
              .margin({ right: 6 })
            Text('执行成功')
              .fontSize(14)
              .fontColor('#52C41A')
          }

          Text('生成的XMP路径:')
            .fontSize(13)
            .fontColor('#666666')
            .width('100%')

          Text(this.result)
            .fontSize(15)
            .fontColor('#1A1A1A')
            .fontWeight(FontWeight.Medium)
            .width('100%')
            .backgroundColor('#F6FFED')
            .padding(10)
            .borderRadius(6)
            .border({ width: 1, color: '#B7EB8F' })
        }
      }
    }
    .width('100%')
    .padding(12)
    .backgroundColor(Color.White)
    .borderRadius(8)
    .margin({ top: 8 })
  }

  @Builder
  buildHistoryPanel() {
    Column({ space: 10 }) {
      Row() {
        Text('测试历史')
          .fontSize(15)
          .fontWeight(FontWeight.Medium)
          .fontColor('#1A1A1A')
          .layoutWeight(1)

        if (this.history.length > 0) {
          Button('清空历史')
            .height(28)
            .fontSize(12)
            .padding({ left: 12, right: 12 })
            .onClick(() => {
              this.history = [];
            })
        }
      }
      .width('100%')

      if (this.history.length === 0) {
        Text('暂无测试历史')
          .fontSize(13)
          .fontColor('#999999')
          .width('100%')
          .height(60)
          .textAlign(TextAlign.Center)
          .backgroundColor('#FAFAFA')
          .borderRadius(6)
      } else {
        // 只让历史记录部分可滚动
        Scroll() {
          Column({ space: 6 }) {
            ForEach(this.history, (item: HistoryItem, index: number) => {
              Column({ space: 4 }) {
                Row({ space: 8 }) {
                  Text(this.getFunctionLabel(item.function))
                    .fontSize(13)
                    .fontColor('#1890FF')
                    .fontWeight(FontWeight.Medium)
                    .maxLines(1)

                  Text(item.timestamp)
                    .fontSize(11)
                    .fontColor('#8C8C8C')
                    .layoutWeight(1)
                    .textAlign(TextAlign.End)

                  Text(`${item.time}ms`)
                    .fontSize(11)
                    .fontColor('#8C8C8C')
                }

                Text(`参数: ${item.params}`)
                  .fontSize(12)
                  .fontColor('#666666')
                  .width('100%')
                  .maxLines(1)
                  .textOverflow({ overflow: TextOverflow.Ellipsis })

                Text(`结果: ${item.result}`)
                  .fontSize(12)
                  .fontColor('#666666')
                  .width('100%')
                  .maxLines(1)
                  .textOverflow({ overflow: TextOverflow.Ellipsis })
              }
              .padding(10)
              .backgroundColor('#FAFAFA')
              .borderRadius(6)
              .border({ width: 1, color: '#F0F0F0' })
              .onClick(() => {
                this.fillFromHistory(item);
              })
            })
          }
        }
        .scrollBar(BarState.Off)
        .height(180) // 固定高度
      }
    }
    .width('100%')
    .padding(12)
    .backgroundColor(Color.White)
    .borderRadius(8)
    .margin({ top: 8, bottom: 12 })
    .layoutWeight(1) // 让历史区域占据剩余空间
  }

  // 获取功能显示标签
  private getFunctionLabel(funcName: string): string {
    const labels: Record<string, string> = {
      'composeArrayItemPath': '数组路径',
      'composeStructFieldPath': '结构体字段',
      'composeQualifierPath': '限定符',
      'composeLangSelector': '语言选择器',
      'composeFieldSelector': '字段选择器'
    };
    return labels[funcName] || funcName;
  }

  // 从历史记录填充参数
  private fillFromHistory(item: HistoryItem): void {
    this.selectedFunction = item.function;
    this.result = item.result;
    this.errorMessage = '';
    this.executionTime = item.time;
    this.showResult = true;
  }

  // 清空结果
  private clearResult(): void {
    this.result = '';
    this.errorMessage = '';
    this.executionTime = 0;
    this.showResult = false;
  }

  // 重置参数
  private resetParameters(): void {
    this.arrayName = 'photoshop:History';
    this.itemIndex = 1;
    this.structFieldNS = 'local://xap/1.0/';
    this.structFieldName = 'CreatorTool';
    this.qualifierNS = 'local://dc/elements/1.1/';
    this.qualifierName = 'description';
    this.langArrayName = 'dc:title';
    this.langName = 'en-US';
    this.fieldArrayName = 'dc:subject';
    this.fieldSelectorNS = 'local://xap/1.0/';
    this.fieldSelectorName = 'type';
    this.fieldValue = 'keyword';
    this.clearResult();
  }

  // 执行功能
  private executeFunction(): void {
    const startTime = Date.now();
    this.clearResult();

    try {
      let output: string;
      let paramsStr: string;

      switch (this.selectedFunction) {
        case 'composeArrayItemPath':
          // 数组路径不需要注册命名空间
          output = XMPPathFactory.composeArrayItemPath(this.arrayName, this.itemIndex);
          paramsStr = `arrayName=${this.arrayName}, itemIndex=${this.itemIndex}`;
          break;

        case 'composeStructFieldPath':
          // 确保命名空间已注册
          if (!this.ensureNamespaceRegistered(this.structFieldNS)) {
            throw new Error(`无法注册命名空间: ${this.structFieldNS}`);
          }
          output = XMPPathFactory.composeStructFieldPath(this.structFieldNS, this.structFieldName);
          paramsStr = `fieldNS=${this.structFieldNS}, fieldName=${this.structFieldName}`;
          break;

        case 'composeQualifierPath':
          // 确保命名空间已注册
          if (!this.ensureNamespaceRegistered(this.qualifierNS)) {
            throw new Error(`无法注册命名空间: ${this.qualifierNS}`);
          }
          output = XMPPathFactory.composeQualifierPath(this.qualifierNS, this.qualifierName);
          paramsStr = `qualNS=${this.qualifierNS}, qualName=${this.qualifierName}`;
          break;

        case 'composeLangSelector':
          // 语言选择器不需要显式注册命名空间
          output = XMPPathFactory.composeLangSelector(this.langArrayName, this.langName);
          paramsStr = `arrayName=${this.langArrayName}, langName=${this.langName}`;
          break;

        case 'composeFieldSelector':
          // 确保字段选择器的命名空间已注册
          if (!this.ensureNamespaceRegistered(this.fieldSelectorNS)) {
            throw new Error(`无法注册命名空间: ${this.fieldSelectorNS}`);
          }
          output = XMPPathFactory.composeFieldSelector(
            this.fieldArrayName,
            this.fieldSelectorNS,
            this.fieldSelectorName,
            this.fieldValue
          );
          paramsStr = `arrayName=${this.fieldArrayName}, fieldNS=${this.fieldSelectorNS}, fieldName=${this.fieldSelectorName}, fieldValue=${this.fieldValue}`;
          break;

        default:
          throw new Error('未知的功能选择');
      }

      const endTime = Date.now();
      this.result = output;
      this.executionTime = endTime - startTime;
      this.showResult = true;

      // 添加到历史记录
      const newHistory: HistoryItem = {
        function: this.selectedFunction,
        params: paramsStr,
        result: output,
        time: this.executionTime,
        timestamp: new Date().toLocaleTimeString()
      };

      this.history = [newHistory, ...this.history].slice(0, 10);

    } catch (error) {
      const endTime = Date.now();
      if (error instanceof Error) {
        this.errorMessage = error.message;
      } else {
        this.errorMessage = '未知错误';
      }
      this.executionTime = endTime - startTime;
      this.showResult = true;
    }
  }
}