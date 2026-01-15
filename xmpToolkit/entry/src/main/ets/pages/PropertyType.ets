import { XMPDateTime, XMPMeta, XMPProperty, XMPMetaFactory, XMPDateTimeFactory,
  PropertyOptions } from '@ohos/xmp_toolkit';
import { util } from '@kit.ArkTS';

/**
 * 测试结果项
 */
class TestResult {
  public name: string = '';
  public passed: boolean = false;
  public message: string = '';
  public time: string = '';

  constructor(name: string, passed: boolean, message: string) {
    this.name = name;
    this.passed = passed;
    this.message = message;
    this.time = new Date().toLocaleTimeString();
  }
}

@Entry
@Component
struct Index {
  @State message: string = '选择要测试的接口';
  @State isRunning: boolean = false;
  @State testResults: TestResult[] = [];
  @State currentTest: string = '';

  // 命名空间
  private readonly NS1 = 'ns:test1/';

  // 选项列表
  private readonly optionList: SelectOption[] = [
    { value: '无选项' },
    { value: 'language' },
    { value: 'type' },
    { value: 'qualifier' }
  ];

  // 输入参数状态
  @State booleanPropName: string = 'BoolProp';
  @State booleanValue: string = 'true';
  @State booleanOption: string = '无选项';
  @State booleanResult: string = '';

  @State integerPropName: string = 'IntProp';
  @State integerValue: string = '42';
  @State integerOption: string = '无选项';
  @State integerResult: string = '';

  @State longPropName: string = 'LongProp';
  @State longValue: string = '1234567890';
  @State longOption: string = '无选项';
  @State longResult: string = '';

  @State doublePropName: string = 'DoubleProp';
  @State doubleValue: string = '3.1415926';
  @State doubleOption: string = '无选项';
  @State doubleResult: string = '';

  @State datePropName: string = 'DateProp';
  @State dateValue: string = '2025-12-26T14:30:45';
  @State dateOption: string = '无选项';
  @State dateResult: string = '';

  @State calendarPropName: string = 'CalendarProp';
  @State calendarValue: string = '2025-11-10T14:30:45';
  @State calendarOption: string = '无选项';
  @State calendarResult: string = '';

  @State base64PropName: string = 'Base64Prop';
  @State base64Value: string = 'Hello World';
  @State base64Option: string = '无选项';
  @State base64Result: string = '';

  addResult(name: string, passed: boolean, message: string) {
    this.testResults.unshift(new TestResult(name, passed, message));
  }

  // 解析PropertyOptions字符串
  parsePropertyOptions(option: string): PropertyOptions | null {
    if (!option || option === '无选项') {
      return null;
    }

    const options = new PropertyOptions();

    switch(option) {
      case 'language':
        options.setHasLanguage(true);
        break;
      case 'type':
        options.setHasType(true);
        break;
      case 'qualifier':
        options.setQualifier(true);
        break;
    }

    return options;
  }

  // 布尔类型测试
  async testBoolean() {
    this.currentTest = '测试布尔类型';
    this.isRunning = true;

    try {
      const registry = XMPMetaFactory.getSchemaRegistry();
      registry.registerNamespace(this.NS1, 'ns1');

      const meta = XMPMetaFactory.create();
      const options = this.parsePropertyOptions(this.booleanOption);

      // 转换布尔值
      const boolValue = this.booleanValue.toLowerCase() === 'true';

      // 设置布尔属性
      meta.setPropertyBoolean(this.NS1, this.booleanPropName, boolValue, options || undefined);

      // 获取布尔属性
      const result = meta.getPropertyBoolean(this.NS1, this.booleanPropName);

      // 验证
      const passed = result === boolValue;
      this.booleanResult = `设置值: ${boolValue}, 获取值: ${result}, ${passed ? '✓ 通过' : '✗ 失败'}`;

      // 获取属性对象检查选项
      const prop = meta.getProperty(this.NS1, this.booleanPropName);
      const optionsStr = prop?.getOptions()?.toString() || '无选项';

      this.addResult(
        '布尔类型测试',
        passed,
        `属性: ${this.booleanPropName}, 值: ${boolValue}, 结果: ${result}, 选项: ${optionsStr}`
      );

    } catch (e) {
      this.booleanResult = `错误: ${(e as Error).message}`;
      this.addResult('布尔类型测试', false, (e as Error).message);
    } finally {
      this.isRunning = false;
    }
  }

  // 整数类型测试
  async testInteger() {
    this.currentTest = '测试整数类型';
    this.isRunning = true;

    try {
      const registry = XMPMetaFactory.getSchemaRegistry();
      registry.registerNamespace(this.NS1, 'ns1');

      const meta = XMPMetaFactory.create();
      const options = this.parsePropertyOptions(this.integerOption);

      // 转换整数值
      const intValue = parseInt(this.integerValue);
      if (isNaN(intValue)) {
        throw new Error('请输入有效的整数');
      }

      // 设置整数属性
      meta.setPropertyInteger(this.NS1, this.integerPropName, intValue, options || undefined);

      // 获取整数属性
      const result = meta.getPropertyInteger(this.NS1, this.integerPropName);

      // 验证
      const passed = result === intValue;
      this.integerResult = `设置值: ${intValue}, 获取值: ${result}, ${passed ? '✓ 通过' : '✗ 失败'}`;

      // 获取属性对象
      const prop = meta.getProperty(this.NS1, this.integerPropName);
      const optionsStr = prop?.getOptions()?.toString() || '无选项';

      this.addResult(
        '整数类型测试',
        passed,
        `属性: ${this.integerPropName}, 值: ${intValue}, 结果: ${result}, 选项: ${optionsStr}`
      );

    } catch (e) {
      this.integerResult = `错误: ${(e as Error).message}`;
      this.addResult('整数类型测试', false, (e as Error).message);
    } finally {
      this.isRunning = false;
    }
  }

  // 长整数类型测试
  async testLong() {
    this.currentTest = '测试长整数类型';
    this.isRunning = true;

    try {
      const registry = XMPMetaFactory.getSchemaRegistry();
      registry.registerNamespace(this.NS1, 'ns1');

      const meta = XMPMetaFactory.create();
      const options = this.parsePropertyOptions(this.longOption);

      // 转换长整数值
      const longValue = parseInt(this.longValue);
      if (isNaN(longValue)) {
        throw new Error('请输入有效的长整数');
      }

      // 设置长整数属性
      meta.setPropertyLong(this.NS1, this.longPropName, longValue, options || undefined);

      // 获取长整数属性
      const result = meta.getPropertyLong(this.NS1, this.longPropName);

      // 验证
      const passed = result === longValue;
      this.longResult = `设置值: ${longValue}, 获取值: ${result}, ${passed ? '✓ 通过' : '✗ 失败'}`;

      // 获取属性对象
      const prop = meta.getProperty(this.NS1, this.longPropName);
      const optionsStr = prop?.getOptions()?.toString() || '无选项';

      this.addResult(
        '长整数类型测试',
        passed,
        `属性: ${this.longPropName}, 值: ${longValue}, 结果: ${result}, 选项: ${optionsStr}`
      );

    } catch (e) {
      this.longResult = `错误: ${(e as Error).message}`;
      this.addResult('长整数类型测试', false, (e as Error).message);
    } finally {
      this.isRunning = false;
    }
  }

  // 双精度类型测试
  async testDouble() {
    this.currentTest = '测试双精度类型';
    this.isRunning = true;

    try {
      const registry = XMPMetaFactory.getSchemaRegistry();
      registry.registerNamespace(this.NS1, 'ns1');

      const meta = XMPMetaFactory.create();
      const options = this.parsePropertyOptions(this.doubleOption);

      // 转换双精度值
      const doubleValue = parseFloat(this.doubleValue);
      if (isNaN(doubleValue)) {
        throw new Error('请输入有效的浮点数');
      }

      // 设置双精度属性
      meta.setPropertyDouble(this.NS1, this.doublePropName, doubleValue, options || undefined);

      // 获取双精度属性
      const result = meta.getPropertyDouble(this.NS1, this.doublePropName);

      // 验证（允许微小的浮点误差）
      const epsilon = 0.0000001;
      const passed = Math.abs(result - doubleValue) < epsilon;
      this.doubleResult = `设置值: ${doubleValue}, 获取值: ${result.toFixed(7)}, ${passed ? '✓ 通过' : '✗ 失败'}`;

      // 获取属性对象
      const prop = meta.getProperty(this.NS1, this.doublePropName);
      const optionsStr = prop?.getOptions()?.toString() || '无选项';

      this.addResult(
        '双精度类型测试',
        passed,
        `属性: ${this.doublePropName}, 值: ${doubleValue}, 结果: ${result.toFixed(7)}, 选项: ${optionsStr}`
      );

    } catch (e) {
      this.doubleResult = `错误: ${(e as Error).message}`;
      this.addResult('双精度类型测试', false, (e as Error).message);
    } finally {
      this.isRunning = false;
    }
  }

  // 日期类型测试
  async testDate() {
    this.currentTest = '测试日期类型';
    this.isRunning = true;

    try {
      const registry = XMPMetaFactory.getSchemaRegistry();
      registry.registerNamespace(this.NS1, 'ns1');

      const meta = XMPMetaFactory.create();
      const options = this.parsePropertyOptions(this.dateOption);

      // 创建日期对象
      const dateObj: XMPDateTime = XMPDateTimeFactory.createFromISO8601(this.dateValue);

      // 设置日期属性
      meta.setPropertyDate(this.NS1, this.datePropName, dateObj, options || undefined);

      // 获取日期属性
      const result: XMPDateTime | null = meta.getPropertyDate(this.NS1, this.datePropName);

      // 验证
      let passed = false;
      let resultStr = '';

      if (result) {
        resultStr = result.getISO8601String();
        passed = resultStr === this.dateValue;
      }

      this.dateResult = `设置值: ${this.dateValue}, 获取值: ${resultStr}, ${passed ? '✓ 通过' : '✗ 失败'}`;

      // 获取属性对象
      const prop = meta.getProperty(this.NS1, this.datePropName);
      const optionsStr = prop?.getOptions()?.toString() || '无选项';

      this.addResult(
        '日期类型测试',
        passed,
        `属性: ${this.datePropName}, 值: ${this.dateValue}, 结果: ${resultStr}, 选项: ${optionsStr}`
      );

    } catch (e) {
      this.dateResult = `错误: ${(e as Error).message}`;
      this.addResult('日期类型测试', false, (e as Error).message);
    } finally {
      this.isRunning = false;
    }
  }

  // 日历类型测试
  async testCalendar() {
    this.currentTest = '测试日历类型';
    this.isRunning = true;

    try {
      const registry = XMPMetaFactory.getSchemaRegistry();
      registry.registerNamespace(this.NS1, 'ns1');

      const meta = XMPMetaFactory.create();
      const options = this.parsePropertyOptions(this.calendarOption);

      meta.setPropertyCalendar(this.NS1, this.calendarPropName, this.calendarValue, options || undefined);
      const result: XMPDateTime | null = meta.getPropertyDate(this.NS1, this.calendarPropName);

      let passed = false;
      let resultStr = '';

      if (result) {
        resultStr = result.getISO8601String();

        // 处理时区差异：移除尾部的 .000Z 或 Z
        let normalizedResult = resultStr;
        if (normalizedResult.endsWith('Z')) {
          normalizedResult = normalizedResult.substring(0, normalizedResult.length - 1);
        }
        if (normalizedResult.endsWith('.000')) {
          normalizedResult = normalizedResult.substring(0, normalizedResult.length - 4);
        }

        let normalizedInput = this.calendarValue;
        if (normalizedInput.endsWith('Z')) {
          normalizedInput = normalizedInput.substring(0, normalizedInput.length - 1);
        }

        passed = normalizedResult === normalizedInput;
        if (!passed) {
          try {
            const inputDate = new Date(this.calendarValue);
            const resultDate = new Date(resultStr);

            const timeDiff = Math.abs(inputDate.getTime() - resultDate.getTime());
            passed = timeDiff < 1000;
          } catch (e) {
            const mainPart = this.calendarValue.substring(0, 19);
            passed = resultStr.includes(mainPart);
          }
        }
      }

      this.calendarResult = `设置值: ${this.calendarValue}, 获取值: ${resultStr}, ${passed ? '✓ 通过' : '✗ 失败'}`;

      // 获取属性对象
      const prop = meta.getProperty(this.NS1, this.calendarPropName);
      const optionsStr = prop?.getOptions()?.toString() || '无选项';

      this.addResult(
           '日历类型测试', passed,
           `属性: ${this.calendarPropName}, 值: ${this.calendarValue}, 结果: ${resultStr}, 选项: ${optionsStr}`
      );

    } catch (e) {
      this.calendarResult = `错误: ${(e as Error).message}`;
      this.addResult('日历类型测试', false, (e as Error).message);
    } finally {
      this.isRunning = false;
    }
  }

  // Base64类型测试
  async testBase64() {
    this.currentTest = '测试Base64类型';
    this.isRunning = true;

    try {
      const registry = XMPMetaFactory.getSchemaRegistry();
      registry.registerNamespace(this.NS1, 'ns1');

      const meta = XMPMetaFactory.create();
      const options = this.parsePropertyOptions(this.base64Option);

      // 将字符串转换为Uint8Array
      const encoder = new util.TextEncoder();
      const byteData = encoder.encode(this.base64Value);

      // 设置Base64属性
      meta.setPropertyBase64(this.NS1, this.base64PropName, byteData, options || undefined);

      // 获取Base64属性
      const result: Uint8Array | null = meta.getPropertyBase64(this.NS1, this.base64PropName);

      // 验证
      let passed = false;
      let resultStr = '';

      if (result) {
        const decoder = new util.TextDecoder('utf-8');
        resultStr = decoder.decode(result);
        passed = resultStr === this.base64Value;
      }

      this.base64Result = `设置值: "${this.base64Value}", 获取值: "${resultStr}", ${passed ? '✓ 通过' : '✗ 失败'}`;

      // 获取属性对象
      const prop = meta.getProperty(this.NS1, this.base64PropName);
      const optionsStr = prop?.getOptions()?.toString() || '无选项';

      this.addResult(
        'Base64类型测试', passed,
        `属性: ${this.base64PropName}, 值: "${this.base64Value}", 结果: "${resultStr}",
         长度: ${result?.length}, 选项: ${optionsStr}`
      );

    } catch (e) {
      this.base64Result = `错误: ${(e as Error).message}`;
      this.addResult('Base64类型测试', false, (e as Error).message);
    } finally {
      this.isRunning = false;
    }
  }

  // 清空测试结果
  clearResults() {
    this.testResults = [];
    this.booleanResult = '';
    this.integerResult = '';
    this.longResult = '';
    this.doubleResult = '';
    this.dateResult = '';
    this.calendarResult = '';
    this.base64Result = '';
  }

  build() {
    Scroll() {
      Column() {
        // 标题
        Text('不同类型的属性访问与操作(boolean/int/long/double/date/calendar/base64)-测试')
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
          .margin({ top: 12, bottom: 12 })
          .textAlign(TextAlign.Center)
          .width('100%')

        // 布尔类型测试
        Column() {
          Text('1. 布尔类型测试')
            .fontSize(16)
            .fontWeight(FontWeight.Bold)
            .margin({ bottom: 8 })
            .width('100%')

          Row() {
            Text('属性名:')
              .fontSize(14)
              .width('30%')
            TextInput({ placeholder: '输入属性名', text: this.booleanPropName })
              .fontSize(14)
              .width('70%')
              .onChange((value: string) => {
                this.booleanPropName = value;
              })
          }
          .margin({ bottom: 6 })
          .width('100%')

          Row() {
            Text('布尔值:')
              .fontSize(14)
              .width('30%')
            TextInput({ placeholder: '输入 true 或 false', text: this.booleanValue })
              .fontSize(14)
              .width('70%')
              .onChange((value: string) => {
                this.booleanValue = value;
              })
          }
          .margin({ bottom: 6 })
          .width('100%')

          Row() {
            Text('选项:')
              .fontSize(14)
              .width('30%')
            Select(this.optionList)
              .value(this.booleanOption)
              .selectedOptionFont({ size: 14 })
              .optionFont({ size: 14 })
              .width('70%')
              .onSelect((index: number, value: string) => {
                this.booleanOption = value;
              })
          }
          .margin({ bottom: 8 })
          .width('100%')

          Row() {
            Button('设置布尔属性')
              .fontSize(12)
              .backgroundColor('#67C23A')
              .width('48%')
              .enabled(!this.isRunning)
              .onClick(async () => {
                await this.testBoolean();
              })

            Button('获取布尔属性')
              .fontSize(12)
              .backgroundColor('#E6A23C')
              .width('48%')
              .enabled(!this.isRunning)
              .onClick(async () => {
                await this.testBoolean();
              })
          }
          .width('100%')
          .justifyContent(FlexAlign.SpaceBetween)

          if (this.booleanResult) {
            Text(this.booleanResult)
              .fontSize(12)
              .margin({ top: 8 })
              .width('100%')
          }
        }
        .padding(12)
        .backgroundColor('#F8F9FA')
        .borderRadius(8)
        .margin({ bottom: 12 })

        // 整数类型测试
        Column() {
          Text('2. 整数类型测试')
            .fontSize(16)
            .fontWeight(FontWeight.Bold)
            .margin({ bottom: 8 })
            .width('100%')

          Row() {
            Text('属性名:')
              .fontSize(14)
              .width('30%')
            TextInput({ placeholder: '输入属性名', text: this.integerPropName })
              .fontSize(14)
              .width('70%')
              .onChange((value: string) => {
                this.integerPropName = value;
              })
          }
          .margin({ bottom: 6 })
          .width('100%')

          Row() {
            Text('整数值:')
              .fontSize(14)
              .width('30%')
            TextInput({ placeholder: '输入整数', text: this.integerValue })
              .fontSize(14)
              .width('70%')
              .type(InputType.Number)
              .onChange((value: string) => {
                this.integerValue = value;
              })
          }
          .margin({ bottom: 6 })
          .width('100%')

          Row() {
            Text('选项:')
              .fontSize(14)
              .width('30%')
            Select(this.optionList)
              .value(this.integerOption)
              .selectedOptionFont({ size: 14 })
              .optionFont({ size: 14 })
              .width('70%')
              .onSelect((index: number, value: string) => {
                this.integerOption = value;
              })
          }
          .margin({ bottom: 8 })
          .width('100%')

          Row() {
            Button('设置整数属性')
              .fontSize(12)
              .backgroundColor('#67C23A')
              .width('48%')
              .enabled(!this.isRunning)
              .onClick(async () => {
                await this.testInteger();
              })

            Button('获取整型属性')
              .fontSize(12)
              .backgroundColor('#E6A23C')
              .width('48%')
              .enabled(!this.isRunning)
              .onClick(async () => {
                await this.testInteger();
              })
          }
          .width('100%')
          .justifyContent(FlexAlign.SpaceBetween)

          if (this.integerResult) {
            Text(this.integerResult)
              .fontSize(12)
              .margin({ top: 8 })
              .width('100%')
          }
        }
        .padding(12)
        .backgroundColor('#F8F9FA')
        .borderRadius(8)
        .margin({ bottom: 12 })

        // 长整数类型测试
        Column() {
          Text('3. 长整数类型测试')
            .fontSize(16)
            .fontWeight(FontWeight.Bold)
            .margin({ bottom: 8 })
            .width('100%')

          Row() {
            Text('属性名:')
              .fontSize(14)
              .width('30%')
            TextInput({ placeholder: '输入属性名', text: this.longPropName })
              .fontSize(14)
              .width('70%')
              .onChange((value: string) => {
                this.longPropName = value;
              })
          }
          .margin({ bottom: 6 })
          .width('100%')

          Row() {
            Text('长整数值:')
              .fontSize(14)
              .width('30%')
            TextInput({ placeholder: '输入长整数', text: this.longValue })
              .fontSize(14)
              .width('70%')
              .type(InputType.Number)
              .onChange((value: string) => {
                this.longValue = value;
              })
          }
          .margin({ bottom: 6 })
          .width('100%')

          Row() {
            Text('选项:')
              .fontSize(14)
              .width('30%')
            Select(this.optionList)
              .value(this.longOption)
              .selectedOptionFont({ size: 14 })
              .optionFont({ size: 14 })
              .width('70%')
              .onSelect((index: number, value: string) => {
                this.longOption = value;
              })
          }
          .margin({ bottom: 8 })
          .width('100%')

          Row() {
            Button('设置长整数属性')
              .fontSize(12)
              .backgroundColor('#67C23A')
              .width('48%')
              .enabled(!this.isRunning)
              .onClick(async () => {
                await this.testLong();
              })

            Button('获取长整数属性')
              .fontSize(12)
              .backgroundColor('#E6A23C')
              .width('48%')
              .enabled(!this.isRunning)
              .onClick(async () => {
                await this.testLong();
              })
          }
          .width('100%')
          .justifyContent(FlexAlign.SpaceBetween)

          if (this.longResult) {
            Text(this.longResult)
              .fontSize(12)
              .margin({ top: 8 })
              .width('100%')
          }
        }
        .padding(12)
        .backgroundColor('#F8F9FA')
        .borderRadius(8)
        .margin({ bottom: 12 })

        // 双精度类型测试
        Column() {
          Text('4. 双精度类型测试')
            .fontSize(16)
            .fontWeight(FontWeight.Bold)
            .margin({ bottom: 8 })
            .width('100%')

          Row() {
            Text('属性名:')
              .fontSize(14)
              .width('30%')
            TextInput({ placeholder: '输入属性名', text: this.doublePropName })
              .fontSize(14)
              .width('70%')
              .onChange((value: string) => {
                this.doublePropName = value;
              })
          }
          .margin({ bottom: 6 })
          .width('100%')

          Row() {
            Text('双精度值:')
              .fontSize(14)
              .width('30%')
            TextInput({ placeholder: '输入浮点数', text: this.doubleValue })
              .fontSize(14)
              .width('70%')
              .onChange((value: string) => {
                this.doubleValue = value;
              })
          }
          .margin({ bottom: 6 })
          .width('100%')

          Row() {
            Text('选项:')
              .fontSize(14)
              .width('30%')
            Select(this.optionList)
              .value(this.doubleOption)
              .selectedOptionFont({ size: 14 })
              .optionFont({ size: 14 })
              .width('70%')
              .onSelect((index: number, value: string) => {
                this.doubleOption = value;
              })
          }
          .margin({ bottom: 8 })
          .width('100%')

          Row() {
            Button('设置双精度属性')
              .fontSize(12)
              .backgroundColor('#67C23A')
              .width('48%')
              .enabled(!this.isRunning)
              .onClick(async () => {
                await this.testDouble();
              })

            Button('获取双精度属性')
              .fontSize(12)
              .backgroundColor('#E6A23C')
              .width('48%')
              .enabled(!this.isRunning)
              .onClick(async () => {
                await this.testDouble();
              })
          }
          .width('100%')
          .justifyContent(FlexAlign.SpaceBetween)

          if (this.doubleResult) {
            Text(this.doubleResult)
              .fontSize(12)
              .margin({ top: 8 })
              .width('100%')
          }
        }
        .padding(12)
        .backgroundColor('#F8F9FA')
        .borderRadius(8)
        .margin({ bottom: 12 })

        // 日期类型测试
        Column() {
          Text('5. 日期类型测试')
            .fontSize(16)
            .fontWeight(FontWeight.Bold)
            .margin({ bottom: 8 })
            .width('100%')

          Row() {
            Text('属性名:')
              .fontSize(14)
              .width('30%')
            TextInput({ placeholder: '输入属性名', text: this.datePropName })
              .fontSize(14)
              .width('70%')
              .onChange((value: string) => {
                this.datePropName = value;
              })
          }
          .margin({ bottom: 6 })
          .width('100%')

          Row() {
            Text('日期值:')
              .fontSize(14)
              .width('30%')
            TextInput({ placeholder: 'ISO8601格式', text: this.dateValue })
              .fontSize(14)
              .width('70%')
              .onChange((value: string) => {
                this.dateValue = value;
              })
          }
          .margin({ bottom: 6 })
          .width('100%')

          Row() {
            Text('选项:')
              .fontSize(14)
              .width('30%')
            Select(this.optionList)
              .value(this.dateOption)
              .selectedOptionFont({ size: 14 })
              .optionFont({ size: 14 })
              .width('70%')
              .onSelect((index: number, value: string) => {
                this.dateOption = value;
              })
          }
          .margin({ bottom: 8 })
          .width('100%')

          Row() {
            Button('设置日期属性')
              .fontSize(12)
              .backgroundColor('#67C23A')
              .width('48%')
              .enabled(!this.isRunning)
              .onClick(async () => {
                await this.testDate();
              })

            Button('获取日期属性')
              .fontSize(12)
              .backgroundColor('#E6A23C')
              .width('48%')
              .enabled(!this.isRunning)
              .onClick(async () => {
                await this.testDate();
              })
          }
          .width('100%')
          .justifyContent(FlexAlign.SpaceBetween)

          if (this.dateResult) {
            Text(this.dateResult)
              .fontSize(12)
              .margin({ top: 8 })
              .width('100%')
          }
        }
        .padding(12)
        .backgroundColor('#F8F9FA')
        .borderRadius(8)
        .margin({ bottom: 12 })

        // 日历类型测试
        Column() {
          Text('6. 日历类型测试')
            .fontSize(16)
            .fontWeight(FontWeight.Bold)
            .margin({ bottom: 8 })
            .width('100%')

          Row() {
            Text('属性名:')
              .fontSize(14)
              .width('30%')
            TextInput({ placeholder: '输入属性名', text: this.calendarPropName })
              .fontSize(14)
              .width('70%')
              .onChange((value: string) => {
                this.calendarPropName = value;
              })
          }
          .margin({ bottom: 6 })
          .width('100%')

          Row() {
            Text('日历值:')
              .fontSize(14)
              .width('30%')
            TextInput({ placeholder: '日历值', text: this.calendarValue })
              .fontSize(14)
              .width('70%')
              .onChange((value: string) => {
                this.calendarValue = value;
              })
          }
          .margin({ bottom: 6 })
          .width('100%')

          Row() {
            Text('选项:')
              .fontSize(14)
              .width('30%')
            Select(this.optionList)
              .value(this.calendarOption)
              .selectedOptionFont({ size: 14 })
              .optionFont({ size: 14 })
              .width('70%')
              .onSelect((index: number, value: string) => {
                this.calendarOption = value;
              })
          }
          .margin({ bottom: 8 })
          .width('100%')

          Row() {
            Button('设置日历属性')
              .fontSize(12)
              .backgroundColor('#67C23A')
              .width('48%')
              .enabled(!this.isRunning)
              .onClick(async () => {
                await this.testCalendar();
              })

            Button('获取日历属性')
              .fontSize(12)
              .backgroundColor('#E6A23C')
              .width('48%')
              .enabled(!this.isRunning)
              .onClick(async () => {
                await this.testCalendar();
              })
          }
          .width('100%')
          .justifyContent(FlexAlign.SpaceBetween)

          if (this.calendarResult) {
            Text(this.calendarResult)
              .fontSize(12)
              .margin({ top: 8 })
              .width('100%')
          }
        }
        .padding(12)
        .backgroundColor('#F8F9FA')
        .borderRadius(8)
        .margin({ bottom: 12 })

        // Base64类型测试
        Column() {
          Text('7. Base64类型测试')
            .fontSize(16)
            .fontWeight(FontWeight.Bold)
            .margin({ bottom: 8 })
            .width('100%')

          Row() {
            Text('属性名:')
              .fontSize(14)
              .width('30%')
            TextInput({ placeholder: '输入属性名', text: this.base64PropName })
              .fontSize(14)
              .width('70%')
              .onChange((value: string) => {
                this.base64PropName = value;
              })
          }
          .margin({ bottom: 6 })
          .width('100%')

          Row() {
            Text('文本值:')
              .fontSize(14)
              .width('30%')
            TextInput({ placeholder: '输入要编码的文本', text: this.base64Value })
              .fontSize(14)
              .width('70%')
              .onChange((value: string) => {
                this.base64Value = value;
              })
          }
          .margin({ bottom: 6 })
          .width('100%')

          Row() {
            Text('选项:')
              .fontSize(14)
              .width('30%')
            Select(this.optionList)
              .value(this.base64Option)
              .selectedOptionFont({ size: 14 })
              .optionFont({ size: 14 })
              .width('70%')
              .onSelect((index: number, value: string) => {
                this.base64Option = value;
              })
          }
          .margin({ bottom: 8 })
          .width('100%')

          Row() {
            Button('设置Base64属性')
              .fontSize(12)
              .backgroundColor('#67C23A')
              .width('48%')
              .enabled(!this.isRunning)
              .onClick(async () => {
                await this.testBase64();
              })

            Button('获取Base64属性')
              .fontSize(12)
              .backgroundColor('#E6A23C')
              .width('48%')
              .enabled(!this.isRunning)
              .onClick(async () => {
                await this.testBase64();
              })
          }
          .width('100%')
          .justifyContent(FlexAlign.SpaceBetween)

          if (this.base64Result) {
            Text(this.base64Result)
              .fontSize(12)
              .margin({ top: 8 })
              .width('100%')
          }

          // 清空结果按钮移到Base64测试模块下面
          Button('清空结果')
            .fontSize(14)
            .backgroundColor('#909399')
            .width('100%')
            .margin({ top: 12 })
            .onClick(() => {
              this.clearResults();
            })
        }
        .padding(12)
        .backgroundColor('#F8F9FA')
        .borderRadius(8)
        .margin({ bottom: 12 })

        // 测试结果列表
        if (this.testResults.length > 0) {
          Column() {
            Text('测试结果历史')
              .fontSize(16)
              .fontWeight(FontWeight.Bold)
              .margin({ bottom: 8 })
              .width('100%')

            ForEach(this.testResults, (item: TestResult) => {
              Row() {
                Text(item.passed ? '✅' : '❌')
                  .fontSize(14)
                  .margin({ right: 8 })

                Column() {
                  Row() {
                    Text(item.name)
                      .fontSize(13)
                      .fontWeight(FontWeight.Medium)

                    Text(item.time)
                      .fontSize(11)
                      .fontColor('#909399')
                      .margin({ left: 8 })
                  }

                  Text(item.message)
                    .fontSize(11)
                    .fontColor(item.passed ? '#409EFF' : '#F56C6C')
                    .maxLines(3)
                    .textOverflow({ overflow: TextOverflow.Ellipsis })
                }
                .alignItems(HorizontalAlign.Start)
                .layoutWeight(1)
              }
              .padding(8)
              .backgroundColor(item.passed ? '#F0F9FF' : '#FFF0F0')
              .borderRadius(6)
              .margin({ bottom: 6 })
              .width('100%')
            })
          }
          .padding(12)
          .backgroundColor('#FFFFFF')
          .borderRadius(8)
          .margin({ bottom: 12 })
        }
      }
      .padding({ left: 16, right: 16, top: 8, bottom: 16 })
    }
    .width('100%')
    .height('100%')
  }
}