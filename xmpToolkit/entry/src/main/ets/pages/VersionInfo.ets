import { XMPMetaFactory } from '@ohos/xmp_toolkit';

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

    // 2个测试项目
    await this.test01_getVersionInfo();
    await this.test02_getBuildInfo();
  }

  async test01_getVersionInfo() {
    this.currentTest = '[1/2] 获取版本信息';
    try {
      const versionInfo = XMPMetaFactory.getVersionInfo();
      if (!versionInfo) {
        this.addResult('获取版本信息对象', false, '版本信息对象为 null 或 undefined');
        return;
      }

      const majorVersion = versionInfo.getMajor();
      const minorVersion = versionInfo.getMinor();
      const versionMessage = versionInfo.getMessage();

      const passed =  typeof minorVersion === 'number' &&
        typeof majorVersion === 'number' ;

      let message = '版本信息: \n';
      message += '主版本号=' + majorVersion + ', 次版本号=' + minorVersion + ', 版本描述信息=' + versionMessage;
      this.addResult('1. 获取版本信息', passed, message);
    } catch (e) {
      this.addResult('1. 获取版本信息', false, (e as Error).message);
    }
  }

  async test02_getBuildInfo() {
    this.currentTest = '[2/2] 获取构建信息';
    try {
      const versionInfo = XMPMetaFactory.getVersionInfo();
      if (!versionInfo) {
        this.addResult('获取版本信息对象', false, '版本信息对象为 null 或 undefined');
        return;
      }

      const buildNumber = versionInfo.getBuild();
      const microVersion = versionInfo.getMicro();
      const isDebug = versionInfo.isDebug();

      const passed =  typeof buildNumber === 'number' &&
        typeof microVersion === 'number' ;

      let message = '构建信息: \n';
      message += '修订号=' + microVersion + ', 构建号=' + buildNumber + ', 是否为调式版本=' + isDebug;
      this.addResult('2. 获取构建信息', passed, message);
    } catch (e) {
      this.addResult('2. 获取构建信息', false, (e as Error).message);
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
