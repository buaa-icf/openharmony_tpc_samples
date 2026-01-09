import { XMPMetaFactory } from '@ohos/xmp_toolkit';
import { XMPPropertyInfo } from '@ohos/xmp_toolkit';
import { PropertyOptions } from '@ohos/xmp_toolkit';
import { XMPProperty } from '@ohos/xmp_toolkit';
import { XMPException } from '@ohos/xmp_toolkit';

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

    // 1个测试项目
    await this.test01_getPropertyInfo();
    await this.test02_getPropertyException();
  }

  async test01_getPropertyInfo() {
    this.currentTest = '[1/2] 获取属性';
    try {
      const meta = XMPMetaFactory.create();
      meta.setLocalizedText(this.NS1, 'AltText', 'zh', 'zh-CN', '中文简体值', new PropertyOptions().setArrayAltText(true));
      const isAltText  = meta.getProperty(this.NS1, 'AltText')?.getOptions()?.isArrayAltText();

      const metaLan = XMPMetaFactory.create();
      metaLan.setLocalizedText(this.NS1, 'AltText', 'en', 'en-us', 'English', null);
      const prop = metaLan.getLocalizedText(this.NS1, 'AltText', 'en', 'en-us');
      const hasLanguage = prop!.getLanguage();

      meta.setProperty(this.NS1, 'Prop', 'Value');
      const iterator = meta.iterator();
      let hasNameSpace = false;
      let valuePass = false;
      let nameSpace = '';
      let path = '';
      let propValue = '';

      while (iterator.hasNext()) {
        const prop = iterator.next() as XMPPropertyInfo;
        path = prop.getPath();
        if (path === 'ns1:Prop') {
          nameSpace = prop.getNamespace();
          propValue = prop.getValue();
          hasNameSpace = nameSpace === this.NS1;
          valuePass = propValue === 'Value';
        }
      }

      let message = '获取XMPProperty属性选项=' + isAltText + ', 获取XMPProperty属性语言=' + hasLanguage;
      message += '\n获取XMPPropertyInfo命名空间=' + nameSpace + ', 获取XMPPropertyInfo路径' + path;
      message += '\n获取XMPPropertyInfo属性值=' + propValue;

      const passed = hasNameSpace && valuePass;

      this.addResult('1. 获取属性', passed, message);
    } catch (e) {
      this.addResult('1. 获取属性', false, (e as Error).message);
    }
  }

  async test02_getPropertyException() {
    this.currentTest = '[2/2] 获取不存在属性';

    const meta = XMPMetaFactory.create();
    meta.setProperty(this.NS1, 'Prop1', 'Prop value1');
    meta.setProperty(this.NS1, 'Prop2', 'Prop value2');

    let errNum: number = 0;
    let errMessage: string = '';
    let item: XMPProperty| null = null;
    try {
      item = meta.getProperty('ns:bogus/', 'Bogus');
    } catch (e) {
      if (e instanceof XMPException) {
        errNum = e.getErrorCode();
        errMessage = e.message;
        console.error('getProperty with bogus schema URI - threw XMPException #' + errNum + ' :   ' + errMessage + ')');
      }
    }

    let message = '获取不存在的属性异常, 错误码=' + errNum + '; 错误信息=' + errMessage;
    const passed = item === null && errNum !==0 && errMessage !=='';

    this.addResult('2. 获取不存在属性', passed, message);
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
                    .maxLines(15)
                    .textOverflow({ overflow: TextOverflow.Ellipsis })
                }
                .alignItems(HorizontalAlign.Start)
                .layoutWeight(1)
              }
              .width('100%')
              .padding({
                top: 6,
                bottom: 6,
                left: 10,
                right: 10
              })
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
