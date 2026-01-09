import { XMPMetaFactory } from '@ohos/xmp_toolkit';
import { PropertyOptions } from '@ohos/xmp_toolkit';
import { XMPUtils } from '@ohos/xmp_toolkit';
import { util } from '@kit.ArkTS';

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

    // 4个测试项目
    await this.test01_catenateArrayItems();
    await this.test02_removeProperties();
    await this.test03_appendProperties();
    await this.test04_dataTypeConvert();
  }

  async test01_catenateArrayItems() {
    this.currentTest = '[1/4] 数组合并为字符串';
    try {
      const meta = XMPMetaFactory.create();
      meta.appendArrayItem(this.NS1, 'Array', new PropertyOptions().setArray(true), 'Item1', null);
      meta.appendArrayItem(this.NS1, 'Array', 'Item2');
      meta.appendArrayItem(this.NS1, 'Array', 'Item3');
      const result = XMPUtils.catenateArrayItems(meta, this.NS1, 'Array', '; ', '"', true);

      const metaArray = XMPMetaFactory.create();
      XMPUtils.separateArrayItems(metaArray, this.NS1, 'Array', 'Item1; Item2; Item3',
        new PropertyOptions().setArray(true), false);
      const arrCount = metaArray.countArrayItems(this.NS1, 'Array')

      const passed = result.includes('Item1') && result.includes('Item2') &&
        result.includes('Item3') && arrCount > 0;

      this.addResult('1. 数组合并为字符串', passed, `数组合并为字符串=${result}, 字符串拆分数组,项数=${arrCount}`);
    } catch (e) {
      this.addResult('1. 数组合并为字符串', false, (e as Error).message);
    }
  }

  async test02_removeProperties() {
    this.currentTest = '[2/4] 批量删除属性';
    try {
      const meta = XMPMetaFactory.create();
      meta.setProperty(this.NS1, 'Prop1', 'Value1');
      meta.setProperty(this.NS1, 'Prop2', 'Value2');
      meta.setProperty(this.NS2, 'Prop3', 'Value3');
      const beforDelProp1 = meta.doesPropertyExist(this.NS1, 'Prop1');
      const beforDelProp2 = meta.doesPropertyExist(this.NS1, 'Prop2');

      XMPUtils.removeProperties(meta, this.NS1, '', true, true);
      const afterDelProp1 = meta.doesPropertyExist(this.NS1, 'Prop1');
      const afterDelProp2 = meta.doesPropertyExist(this.NS1, 'Prop2');

      let message = '删除前属性Prop1是否存在=' +beforDelProp1 + ', 删除前属性Prop2是否存在=' + beforDelProp2;
      message += '\n删除后属性Prop1是否存在==' + afterDelProp1 + ', 删除后属性Prop2是否存在=' + afterDelProp2;
      const passed = beforDelProp1 && beforDelProp2 &&
        !afterDelProp1 && !afterDelProp2;

      this.addResult('2. 批量删除属性', passed, message);
    } catch (e) {
      this.addResult('2. 批量删除属性', false, (e as Error).message);
    }
  }

  async test03_appendProperties() {
    this.currentTest = '[3/4] 追加属性';
    try {
      const source = XMPMetaFactory.create();
      source.setProperty(this.NS1, 'Prop1', 'Value1');
      source.setProperty(this.NS1, 'Prop2', 'Value2');

      const dest = XMPMetaFactory.create();
      dest.setProperty(this.NS1, 'ExistingProp', 'ExistingValue');
      const beforAppend = dest.doesPropertyExist(this.NS1, 'Prop2');
      XMPUtils.appendProperties(source, dest, true, true, false);
      const afterAppend = dest.doesPropertyExist(this.NS1, 'Prop2');
      const propValue = dest.getPropertyString(this.NS1, 'Prop2');

      let message = '追加前属性Prop2是否存在=' +beforAppend;
      message += '\n追加后属性Prop2是否存在=' + afterAppend + ', 属性值=' + propValue;

      const passed = !beforAppend && afterAppend;

      this.addResult('3. 追加属性', passed, message);
    } catch (e) {
      this.addResult('3. 追加属性', false, (e as Error).message);
    }
  }

  async test04_dataTypeConvert() {
    this.currentTest = '[4/4] 基础数据类型转换';
    try {
      const strConverBool1 = XMPUtils.convertToBoolean('true');
      const strConverBool2 = XMPUtils.convertToBoolean('0');
      const boolConverStr = XMPUtils.convertFromBoolean(true);
      const boolStr = strConverBool1 && !strConverBool2 && boolConverStr === 'True';

      const intConverStr = XMPUtils.convertFromInteger(-10);
      const strConverInt = XMPUtils.convertToInteger('-10');
      const intStr = strConverInt === -10 && intConverStr === '-10';

      const longConverStr = XMPUtils.convertFromLong(1234567890);
      const strConverLong = XMPUtils.convertToLong('1234567890');
      const longStr = longConverStr === '1234567890' && strConverLong === 1234567890;

      const doubleConverStr = XMPUtils.convertFromDouble(3.1415926);
      const strConverDouble = XMPUtils.convertToDouble('3.1415926');
      const doubleStr = doubleConverStr === '3.1415926' && Math.abs(strConverDouble - 3.1415926) < 0.001;

      const strConverDate = '2025-12-29T14:30:21';
      const xmpDate = XMPUtils.convertToDate(strConverDate);
      const dataConverStr = XMPUtils.convertFromDate(xmpDate);
      const dateStr = xmpDate.getYear() === 2025 && xmpDate.getMonth() === 12 &&
        xmpDate.getDay() === 29 && dataConverStr === '2025-12-29T14:30:21';

      const text = 'Hello, xmp_toolkit!';
      const encoder = new util.TextEncoder();
      const buffer = encoder.encode(text);
      const encoded = XMPUtils.encodeBase64(buffer);

      const binaryData = new Uint8Array([0x00, 0x01, 0x02, 0x7F, 0x80, 0xFF]);
      const binaryEncoded = XMPUtils.encodeBase64(binaryData);

      const originalText = 'Base64 Test Data';
      const encoderTest = new util.TextEncoder();
      const originalBuffer = encoderTest.encode(originalText);
      const encodedTest = XMPUtils.encodeBase64(originalBuffer);
      const decodedBuffer = XMPUtils.decodeBase64(encodedTest);
      const decoder = new util.TextDecoder();
      const decodedText = decoder.decode(decodedBuffer);

      const passed = boolStr && intStr && longStr && doubleStr && dateStr &&
        encoded !== '' && binaryEncoded !== '' && encoded.length > 0 &&
        binaryEncoded.length > 0 && decodedText === originalText;

      let message = '字符串‘true’转换为布尔=' + strConverBool1 + ', 字符串‘0’转换为布尔=' + strConverBool2;
      message += '\n布尔true转换为字符串=' + boolConverStr;
      message += '\n整型-10转换为字符串=' + intConverStr + ', 字符串‘-10’转换为整型=' + strConverInt;
      message += '\n长整型1234567890转换为字符串=' + longConverStr + ', 字符串‘1234567890’转换为长整型=' + strConverLong;
      message += '\n双精度3.1415926转换为字符串=' + doubleConverStr + ', 字符串‘3.1415926’转换为双精度=' + strConverDouble;
      message += '\n字符串‘2025-12-29T14:30:21’转换为日期=';
      message += xmpDate.getYear() + '年' + xmpDate.getMonth() + '月' + xmpDate.getDay() + '日 ';
      message += xmpDate.getHour() + '时' + xmpDate.getMinute() + '分' + xmpDate.getSecond() + '秒';
      message += '\n文本 \'Hello, XMPTool!\' 转Base64编码结果: ' + encoded;
      message += ', 二进制数据 [0x00,0x01,0x02,0x7F,0x80,0xFF] 转Base64编码结果: ' + binaryEncoded;
      message += '\n编码前文本: \'' + originalText + ', Base64编码: ' + encoded;
      message += ', 解码后文本: \'' + decodedText;

      this.addResult('4. 基础数据类型转换', passed, message);
    } catch (e) {
      this.addResult('4. 基础数据类型转换', false, (e as Error).message);
    }
  }

  build() {
    Column() {
      // 标题
      Text('xmpTool 自动化接口测试')
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
