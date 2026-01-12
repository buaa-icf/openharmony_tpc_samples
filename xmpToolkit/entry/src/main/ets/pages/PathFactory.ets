import { XMPMetaFactory } from '@ohos/xmp_toolkit';
import { XMPPathFactory } from '@ohos/xmp_toolkit';

/**
 * 测试结果项
 */
class TestResult {
  public name: string = '';
  public passed: boolean = false;
  public message: string = '';

  constructor(name: string, passed: boolean, message: string) {
    this.name = name;
    this.passed = passed;
    this.message = message;
  }
}

@Entry
@Component
struct Index {
  @State message: string = '点击运行测试';
  @State isRunning: boolean = false;
  @State testResults: TestResult[] = [];
  @State totalTests: number = 0;
  @State passedTests: number = 0;
  @State failedTests: number = 0;
  @State currentTest: string = '';

  private readonly NS1 = 'ns:test1/';
  private readonly NS2 = 'ns:test2/';

  addResult(name: string, passed: boolean, message: string) {
    this.testResults.push(new TestResult(name, passed, message));
    this.totalTests++;
    if (passed) {
      this.passedTests++;
    } else {
      this.failedTests++;
    }
  }

  async runAllTests() {
    this.testResults = [];
    this.totalTests = 0;
    this.passedTests = 0;
    this.failedTests = 0;

    const registry = XMPMetaFactory.getSchemaRegistry();
    registry.registerNamespace(this.NS1, 'ns1');
    registry.registerNamespace(this.NS2, 'ns2');

    // 5个测试项目
    await this.test01_createArrayPath();
    await this.test02_createStructFieldPath();
    await this.test03_createQualifierPath();
    await this.test04_createLangSelector();
    await this.test05_createFieldSelector();
  }

  async test01_createArrayPath() {
    this.currentTest = '[1/5] 创建数组路径';
    try {
      const arrayPath = XMPPathFactory.composeArrayItemPath('ArrayProp', 2);
      const passed = arrayPath === 'ArrayProp[2]';

      this.addResult('1. 创建数组路径', passed, `数组路径=${arrayPath}`);
    } catch (e) {
      this.addResult('1. 创建数组路径', false, (e as Error).message);
    }
  }

  async test02_createStructFieldPath() {
    this.currentTest = '[2/5] 创建结构体字段路径';
    try {
      const structPath = XMPPathFactory.composeStructFieldPath(this.NS2, 'Field1');
      const passed = structPath.includes('Field1');

      this.addResult('2. 创建结构体字段路径', passed, `结构体字段路径=${structPath}`);
    } catch (e) {
      this.addResult('2. 创建结构体字段路径', false, (e as Error).message);
    }
  }

  async test03_createQualifierPath() {
    this.currentTest = '[3/5] 创建限定符路径';
    try {
      const qualPath = XMPPathFactory.composeQualifierPath(this.NS1, 'Lang');
      const passed = qualPath.startsWith('/?') && qualPath.includes('Lang');

      this.addResult('3. 创建限定符路径', passed, `限定符路径=${qualPath}`);
    } catch (e) {
      this.addResult('3. 创建限定符路径', false, (e as Error).message);
    }
  }

  async test04_createLangSelector() {
    this.currentTest = '[4/5] 生成语言选择器路径';
    try {
      const arrayName = 'TextArray';
      const langName = 'en-US';
      const langPath = XMPPathFactory.composeLangSelector(arrayName, langName);

      const passed = langPath.includes('[?xml:lang=') && langPath.includes('en-US');

      this.addResult('4. 生成语言选择器路径', passed, `语言选择器路径=${langPath}`);
    } catch (e) {
      this.addResult('4. 生成语言选择器路径', false, (e as Error).message);
    }
  }

  async test05_createFieldSelector() {
    this.currentTest = '[5/5] 生成字段选择器路径';
    try {
      const arrayName = 'StructArray';
      const fieldNS = this.NS1;
      const fieldName = 'ID';
      const fieldValue = '12345';
      const fieldPath = XMPPathFactory.composeFieldSelector(arrayName, fieldNS, fieldName, fieldValue);
      const passed = fieldPath.includes(arrayName) && fieldPath.includes(fieldName) &&
         fieldPath.includes(fieldValue);


      this.addResult('5. 生成字段选择器路径', passed, `字段选择器路径=${fieldPath}`);
    } catch (e) {
      this.addResult('5. 生成字段选择器路径', false, (e as Error).message);
    }
  }

  build() {
    Column() {
      // 标题
      Text('xmp_toolkit 自动化接口测试')
        .fontSize(20)
        .fontWeight(FontWeight.Bold)
        .margin({ top: 12, bottom: 12 })

      // 运行按钮
      Button(this.isRunning ? `${this.currentTest}` : this.message)
        .fontSize(14)
        .fontWeight(FontWeight.Bold)
        .width('85%')
        .height(44)
        .enabled(!this.isRunning)
        .onClick(async () => {
          this.isRunning = true;
          this.message = '测试中...';
          try {
            await this.runAllTests();
            this.message = '重新运行测试';
          } catch (e) {
            this.message = '测试出错，点击重试';
          } finally {
            this.isRunning = false;
            this.currentTest = '';
          }
        })
        .margin({ bottom: 12 })

      // 统计信息
      if (this.totalTests > 0) {
        Row() {
          Text(`总计: ${this.totalTests}`)
            .fontSize(13)
            .margin({ right: 12 })
          Text(`✅ ${this.passedTests}`)
            .fontSize(13)
            .fontColor('#00AA00')
            .margin({ right: 12 })
          Text(`❌ ${this.failedTests}`)
            .fontSize(13)
            .fontColor('#FF0000')
        }
        .margin({ bottom: 8 })

        // 总体结果
        Text(this.failedTests === 0 ? '🎉 全部通过!' : `⚠️ ${this.failedTests}项失败`)
          .fontSize(16)
          .fontWeight(FontWeight.Bold)
          .fontColor(this.failedTests === 0 ? '#00AA00' : '#FF6600')
          .margin({ bottom: 10 })
      }

      // 测试结果列表
      if (this.testResults.length > 0) {
        List() {
          ForEach(this.testResults, (item: TestResult) => {
            ListItem() {
              Row() {
                Text(item.passed ? '✅' : '❌')
                  .fontSize(14)
                  .margin({ right: 6 })
                Column() {
                  Text(item.name)
                    .fontSize(13)
                    .fontWeight(FontWeight.Medium)
                  Text(item.message)
                    .fontSize(10)
                    .fontColor(item.passed ? '#666666' : '#FF0000')
                    .maxLines(12)
                    .textOverflow({ overflow: TextOverflow.Ellipsis })
                }
                .alignItems(HorizontalAlign.Start)
                .layoutWeight(1)
              }
              .width('100%')
              .padding({ top: 6, bottom: 6, left: 10, right: 10 })
              .backgroundColor(item.passed ? '#F0FFF0' : '#FFF0F0')
              .borderRadius(4)
            }
            .margin({ bottom: 4 })
          })
        }
        .width('94%')
        .layoutWeight(1)
        .divider({ strokeWidth: 0 })
      }
    }
    .width('100%')
    .height('100%')
    .padding({ left: 10, right: 10, top: 6, bottom: 6 })
  }
}
