import { XMPMetaFactory, PropertyOptions, XMPUtils } from '@ohos/xmp_toolkit';
import { util } from '@kit.ArkTS';
import promptAction from '@ohos.promptAction';

// 定义一个接口来处理XMPProperty对象
interface XMPProperty {
  getValue?: () => string;
  value?: string;
  toString?: () => string;
}

@Entry
@Component
struct XMPUtilsTest {
  @State message: string = 'XMPUtils';

  // 命名空间常量
  private readonly NS1: string = 'ns:test1/';
  private readonly NS2: string = 'ns:test2/';

  // 测试结果
  @State catenateResult: string = '';
  @State separateResult: string = '';
  @State propOperationResult: string = '';
  @State conversionResult: string = '';
  @State base64Result: string = '';

  // 属性列表状态
  @State currentProperties: string[] = [];

  // 数组合并与分割输入参数
  @State arrayItemsInput: string = 'Item1,Item2,Item3';
  @State separatorInput: string = '; ';
  @State quotesInput: string = '"';
  @State allowCommasInput: boolean = true;
  @State catedStringInput: string = 'Item1; Item2; Item3';
  @State preserveCommasInput: boolean = false;

  // 属性操作相关状态
  @State prop1Selected: boolean = false;
  @State prop2Selected: boolean = false;
  @State prop3Selected: boolean = false;

  // 数据类型转换输入参数
  // 布尔相关
  @State booleanStrInput: string = "'true'";
  @State booleanBoolInput: boolean = true;

  // 整数相关
  @State integerInput: string = '-10';
  @State integerStrInput: string = "'-10'";

  // 长整型相关
  @State longInput: string = '1234567890';
  @State longStrInput: string = "'1234567890'";

  // 双精度相关
  @State doubleInput: string = '3.1415926';
  @State doubleStrInput: string = "'3.1415926'";

  // 日期相关
  @State dateInput: string = '2025-12-29T14:30:21';
  @State dateStrInput: string = '2025-12-29T14:30:21';

  // Base64编码相关状态
  @State base64TextInput: string = 'Hello, xmp_toolkit!';

  // 初始化命名空间
  aboutToAppear() {
    const registry = XMPMetaFactory.getSchemaRegistry();
    registry.registerNamespace(this.NS1, 'ns1');
    registry.registerNamespace(this.NS2, 'ns2');
  }

  build() {
    Scroll() {
      Column({ space: 15 }) {
        Text(this.message)
          .fontSize(32)
          .fontWeight(FontWeight.Bold)
          .margin({ top: 10, bottom: 20 })

        // 1. 数组合并为字符串
        Text('数组合并为字符串')
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
          .width('100%')
          .textAlign(TextAlign.Start)
          .margin({ left: 10, bottom: 10 })

        Column({ space: 10 }) {
          Row({ space: 10 }) {
            Text('数组项:')
              .fontSize(14)
              .width('20%')
            TextInput({ text: this.arrayItemsInput })
              .width('75%')
              .maxLength(50)
              .onChange((value: string) => {
                this.arrayItemsInput = value;
              })
          }

          Row({ space: 10 }) {
            Button('合并')
              .width('45%')
              .onClick(() => {
                this.testCatenateArrayItems();
              })

            Button('清除结果')
              .width('45%')
              .backgroundColor('#FF6B6B')
              .onClick(() => {
                this.catenateResult = '';
                promptAction.showToast({ message: '已清除合并结果' });
              })
          }
          .margin({ top: 5 })
        }
        .padding(10)
        .border({ width: 1, color: Color.Gray, radius: 8 })
        .margin({ left: 10, right: 10 })

        // 合并结果展示 - 始终显示
        Row({ space: 10 }) {
          Text('结果:')
            .fontSize(14)
            .fontWeight(FontWeight.Medium)
            .width('15%')
          Scroll() {
            Text(this.catenateResult)
              .fontSize(14)
              .fontColor(this.catenateResult ? Color.Blue : Color.Gray)
              .width('100%')
              .textOverflow({ overflow: TextOverflow.None })
          }
          .height(40)
          .width('80%')
        }
        .padding(10)
        .margin({ left: 10, right: 10, top: 5 })

        Divider()
          .strokeWidth(1)
          .color(Color.Gray)
          .margin({ top: 15, bottom: 15 })

        // 2. 字符串分割为数组
        Text('字符串分割为数组')
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
          .width('100%')
          .textAlign(TextAlign.Start)
          .margin({ left: 10, bottom: 10 })

        Column({ space: 10 }) {
          Row({ space: 10 }) {
            Text('待分割字符串:')
              .fontSize(14)
              .width('30%')
            TextInput({ text: this.catedStringInput })
              .width('65%')
              .maxLength(100)
              .onChange((value: string) => {
                this.catedStringInput = value;
              })
          }

          Row({ space: 10 }) {
            Text('保留逗号:')
              .fontSize(14)
              .width('30%')
            Toggle({ type: ToggleType.Checkbox, isOn: this.preserveCommasInput })
              .onChange((isOn: boolean) => {
                this.preserveCommasInput = isOn;
              })
          }

          Text('说明: 保留逗号决定在分割时是否将逗号视为普通字符而非分隔符')
            .fontSize(12)
            .fontColor(Color.Gray)
            .width('100%')
            .margin({ top: 5 })

          Row({ space: 10 }) {
            Button('分割')
              .width('45%')
              .onClick(() => {
                this.testSeparateArrayItems();
              })

            Button('清除结果')
              .width('45%')
              .backgroundColor('#FF6B6B')
              .onClick(() => {
                this.separateResult = '';
                promptAction.showToast({ message: '已清除分割结果' });
              })
          }
          .margin({ top: 5 })
        }
        .padding(10)
        .border({ width: 1, color: Color.Gray, radius: 8 })
        .margin({ left: 10, right: 10 })

        // 分割结果展示 - 始终显示
        Row({ space: 10 }) {
          Text('结果:')
            .fontSize(14)
            .fontWeight(FontWeight.Medium)
            .width('15%')
          Scroll() {
            Text(this.separateResult)
              .fontSize(14)
              .fontColor(this.separateResult ? Color.Blue : Color.Gray)
              .width('100%')
              .textOverflow({ overflow: TextOverflow.None })
          }
          .height(60)
          .width('80%')
        }
        .padding(10)
        .margin({ left: 10, right: 10, top: 5 })

        Divider()
          .strokeWidth(1)
          .color(Color.Gray)
          .margin({ top: 15, bottom: 15 })

        // 3. 属性操作
        Text('属性操作')
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
          .width('100%')
          .textAlign(TextAlign.Start)
          .margin({ left: 10, bottom: 10 })

        Column({ space: 10 }) {
          Text('选择属性:')
            .fontSize(14)
            .width('100%')
            .textAlign(TextAlign.Start)

          Row({ space: 20 }) {
            Row({ space: 5 }) {
              Toggle({ type: ToggleType.Checkbox, isOn: this.prop1Selected })
                .onChange((isOn: boolean) => {
                  this.prop1Selected = isOn;
                })
              Text('Prop1')
                .fontSize(14)
            }

            Row({ space: 5 }) {
              Toggle({ type: ToggleType.Checkbox, isOn: this.prop2Selected })
                .onChange((isOn: boolean) => {
                  this.prop2Selected = isOn;
                })
              Text('Prop2')
                .fontSize(14)
            }

            Row({ space: 5 }) {
              Toggle({ type: ToggleType.Checkbox, isOn: this.prop3Selected })
                .onChange((isOn: boolean) => {
                  this.prop3Selected = isOn;
                })
              Text('Prop3')
                .fontSize(14)
            }
          }

          Row({ space: 10 }) {
            Button('添加')
              .width('45%')
              .onClick(() => {
                this.addSelectedProperties();
              })

            Button('移除')
              .width('45%')
              .onClick(() => {
                this.removeSelectedProperties();
              })
          }
          .margin({ top: 5 })
        }
        .padding(10)
        .border({ width: 1, color: Color.Gray, radius: 8 })
        .margin({ left: 10, right: 10 })

        // 属性操作结果展示 - 显示当前属性列表
        Column({ space: 5 }) {
          Text('当前属性:')
            .fontSize(14)
            .fontWeight(FontWeight.Medium)
            .width('100%')
            .textAlign(TextAlign.Start)
            .margin({ bottom: 5 })

          if (this.currentProperties.length > 0) {
            ForEach(this.currentProperties, (prop: string, index: number) => {
              Row({ space: 10 }) {
                Text(`${index + 1}. ${prop}`)
                  .fontSize(14)
                  .fontColor(Color.Blue)
              }
              .width('100%')
              .padding(5)
              .border({ width: 1, color: Color.Gray, radius: 4 })
              .margin({ bottom: 3 })
            })
          } else {
            Text('暂无属性')
              .fontSize(14)
              .fontColor(Color.Gray)
              .width('100%')
              .textAlign(TextAlign.Center)
              .padding(10)
          }
        }
        .padding(10)
        .margin({ left: 10, right: 10, top: 5 })

        Divider()
          .strokeWidth(1)
          .color(Color.Gray)
          .margin({ top: 15, bottom: 15 })

        // 4. 类型转换
        Text('类型转换')
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
          .width('100%')
          .textAlign(TextAlign.Start)
          .margin({ left: 10, bottom: 10 })

        Column({ space: 10 }) {
          // 布尔转换
          Row({ space: 10 }) {
            Text('字符串->布尔:')
              .fontSize(14)
              .width('35%')
            TextInput({ text: this.booleanStrInput })
              .width('60%')
              .maxLength(10)
              .onChange((value: string) => {
                this.booleanStrInput = value;
              })
          }

          Row({ space: 10 }) {
            Text('布尔->字符串:')
              .fontSize(14)
              .width('35%')
            Row({ space: 5 }) {
              Toggle({ type: ToggleType.Checkbox, isOn: this.booleanBoolInput })
                .onChange((isOn: boolean) => {
                  this.booleanBoolInput = isOn;
                })
              Text(this.booleanBoolInput ? 'true' : 'false')
                .fontSize(14)
            }
            .width('60%')
            .justifyContent(FlexAlign.Start)
          }

          // 整数转换
          Row({ space: 10 }) {
            Text('整数->字符串:')
              .fontSize(14)
              .width('35%')
            TextInput({ text: this.integerInput })
              .width('60%')
              .maxLength(15)
              .onChange((value: string) => {
                this.integerInput = value;
              })
          }

          Row({ space: 10 }) {
            Text('字符串->整数:')
              .fontSize(14)
              .width('35%')
            TextInput({ text: this.integerStrInput })
              .width('60%')
              .maxLength(20)
              .onChange((value: string) => {
                this.integerStrInput = value;
              })
          }

          // 长整型转换
          Row({ space: 10 }) {
            Text('长整型->字符串:')
              .fontSize(14)
              .width('35%')
            TextInput({ text: this.longInput })
              .width('60%')
              .maxLength(20)
              .onChange((value: string) => {
                this.longInput = value;
              })
          }

          Row({ space: 10 }) {
            Text('字符串->长整型:')
              .fontSize(14)
              .width('35%')
            TextInput({ text: this.longStrInput })
              .width('60%')
              .maxLength(30)
              .onChange((value: string) => {
                this.longStrInput = value;
              })
          }

          // 双精度转换
          Row({ space: 10 }) {
            Text('双精度->字符串:')
              .fontSize(14)
              .width('35%')
            TextInput({ text: this.doubleInput })
              .width('60%')
              .maxLength(30)
              .onChange((value: string) => {
                this.doubleInput = value;
              })
          }

          Row({ space: 10 }) {
            Text('字符串->双精度:')
              .fontSize(14)
              .width('35%')
            TextInput({ text: this.doubleStrInput })
              .width('60%')
              .maxLength(30)
              .onChange((value: string) => {
                this.doubleStrInput = value;
              })
          }

          // 日期转换
          Row({ space: 10 }) {
            Text('日期->字符串:')
              .fontSize(14)
              .width('35%')
            TextInput({ text: this.dateInput })
              .width('60%')
              .maxLength(30)
              .onChange((value: string) => {
                this.dateInput = value;
              })
          }

          Row({ space: 10 }) {
            Text('字符串->日期:')
              .fontSize(14)
              .width('35%')
            TextInput({ text: this.dateStrInput })
              .width('60%')
              .maxLength(30)
              .onChange((value: string) => {
                this.dateStrInput = value;
              })
          }

          Row({ space: 10 }) {
            Button('转换')
              .width('45%')
              .onClick(() => {
                this.testDataTypeConversion();
              })

            Button('清除结果')
              .width('45%')
              .backgroundColor('#FF6B6B')
              .onClick(() => {
                this.conversionResult = '';
                promptAction.showToast({ message: '已清除转换结果' });
              })
          }
          .margin({ top: 10 })
        }
        .padding(10)
        .border({ width: 1, color: Color.Gray, radius: 8 })
        .margin({ left: 10, right: 10 })

        // 类型转换结果展示 - 始终显示
        Column({ space: 5 }) {
          Text('转换结果:')
            .fontSize(14)
            .fontWeight(FontWeight.Medium)
            .width('100%')
            .textAlign(TextAlign.Start)
            .margin({ bottom: 5 })

          Scroll() {
            Text(this.conversionResult)
              .fontSize(14)
              .fontColor(this.conversionResult ? Color.Blue : Color.Gray)
              .width('100%')
              .textOverflow({ overflow: TextOverflow.None })
          }
          .height(120)
          .width('100%')
        }
        .padding(10)
        .margin({ left: 10, right: 10, top: 5 })

        Divider()
          .strokeWidth(1)
          .color(Color.Gray)
          .margin({ top: 15, bottom: 15 })

        // 5. Base64 编码
        Text('Base64编码')
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
          .width('100%')
          .textAlign(TextAlign.Start)
          .margin({ left: 10, bottom: 10 })

        Column({ space: 10 }) {
          Row({ space: 10 }) {
            Text('文本:')
              .fontSize(14)
              .width('20%')
            TextInput({ text: this.base64TextInput })
              .width('75%')
              .maxLength(50)
              .onChange((value: string) => {
                this.base64TextInput = value;
              })
          }

          Row({ space: 10 }) {
            Button('编码')
              .width('45%')
              .onClick(() => {
                this.testBase64Encoding();
              })

            Button('清除结果')
              .width('45%')
              .backgroundColor('#FF6B6B')
              .onClick(() => {
                this.base64Result = '';
                promptAction.showToast({ message: '已清除编码结果' });
              })
          }
          .margin({ top: 5 })
        }
        .padding(10)
        .border({ width: 1, color: Color.Gray, radius: 8 })
        .margin({ left: 10, right: 10 })

        // Base64编码结果展示 - 始终显示
        Column({ space: 5 }) {
          Text('编码结果:')
            .fontSize(14)
            .fontWeight(FontWeight.Medium)
            .width('100%')
            .textAlign(TextAlign.Start)
            .margin({ bottom: 5 })

          Scroll() {
            Text(this.base64Result)
              .fontSize(14)
              .fontColor(this.base64Result ? Color.Blue : Color.Gray)
              .width('100%')
              .textOverflow({ overflow: TextOverflow.None })
          }
          .height(100)
          .width('100%')
        }
        .padding(10)
        .margin({ left: 10, right: 10, top: 5 })
      }
      .width('100%')
    }
    .scrollable(ScrollDirection.Vertical)
    .scrollBar(BarState.On)
  }

  // 测试 catenateArrayItems
  private testCatenateArrayItems(): void {
    try {
      const meta = XMPMetaFactory.create();

      // 创建数组项
      const items = this.arrayItemsInput.split(',').filter(item => item.trim().length > 0);

      if (items.length > 0) {
        // 添加数组项
        meta.appendArrayItem(this.NS1, 'Array', new PropertyOptions().setArray(true), items[0], null);
        for (let i = 1; i < items.length; i++) {
          meta.appendArrayItem(this.NS1, 'Array', items[i].trim());
        }

        // 拼接数组项
        const result = XMPUtils.catenateArrayItems(
          meta,
          this.NS1,
          'Array',
          this.separatorInput,
          this.quotesInput,
          this.allowCommasInput
        );

        this.catenateResult = `'${result}'`;
        promptAction.showToast({ message: '数组合并成功' });
      } else {
        this.catenateResult = '请输入有效的数组项';
        promptAction.showToast({ message: '请输入有效的数组项', duration: 2000 });
      }
    } catch (error) {
      this.catenateResult = `合并失败: ${error}`;
      promptAction.showToast({ message: '数组合并失败', duration: 2000 });
    }
  }

  // 测试 separateArrayItems - 简化版本避免类型问题
  private testSeparateArrayItems(): void {
    try {
      const meta = XMPMetaFactory.create();

      // 分割字符串
      XMPUtils.separateArrayItems(
        meta,
        this.NS1,
        'SeparateArray',
        this.catedStringInput,
        new PropertyOptions().setArray(true),
        this.preserveCommasInput
      );

      // 获取分割后的数组项数量
      const arraySize = meta.countArrayItems(this.NS1, 'SeparateArray');

      // 简化处理：只显示数量信息，不尝试获取具体值
      this.separateResult = `分割成功，共生成 ${arraySize} 个数组项`;

      // 如果数组项大于0，尝试获取第一个项的值作为示例
      if (arraySize > 0) {
        try {
          // 使用更安全的方式获取数组项
          const arrayItem = meta.getArrayItem(this.NS1, 'SeparateArray', 1);
          if (arrayItem !== null && arrayItem !== undefined) {
            // 尝试将arrayItem转换为字符串
            let itemStr: string;
            if (typeof arrayItem === 'string') {
              itemStr = arrayItem;
            } else if (typeof arrayItem === 'object') {
              // 对于对象类型，使用JSON.stringify
              itemStr = JSON.stringify(arrayItem);
              // 如果显示为[object Object]，则简化显示
              if (itemStr === '{}' || itemStr.includes('[object')) {
                itemStr = '数组项对象';
              }
            } else {
              itemStr = String(arrayItem);
            }

            this.separateResult += `\n示例项: '${itemStr}'`;
          }
        } catch (e) {
          // 忽略获取具体值的错误
          this.separateResult += `\n(无法获取具体项值)`;
        }
      }

      promptAction.showToast({ message: '字符串分割成功' });
    } catch (error) {
      this.separateResult = `分割失败: ${error}`;
      promptAction.showToast({ message: '字符串分割失败', duration: 2000 });
    }
  }

  // 获取选中的属性列表
  private getSelectedProperties(): string[] {
    const selected: string[] = [];
    if (this.prop1Selected){
      selected.push('Prop1');
    }
    if (this.prop2Selected){
      selected.push('Prop2');
    }
    if (this.prop3Selected){
      selected.push('Prop3');
    }
    return selected;
  }

  // 添加选中属性
  private addSelectedProperties(): void {
    try {
      const selectedProps = this.getSelectedProperties();

      if (selectedProps.length === 0) {
        promptAction.showToast({ message: '请选择要添加的属性', duration: 2000 });
        return;
      }

      // 添加选中的属性到当前属性列表
      const addedProps: string[] = [];
      selectedProps.forEach(prop => {
        if (!this.currentProperties.includes(prop)) {
          this.currentProperties.push(prop);
          addedProps.push(prop);
        }
      });

      if (addedProps.length > 0) {
        promptAction.showToast({ message: `成功添加属性: ${addedProps.join(', ')}` });
      } else {
        promptAction.showToast({ message: '选中的属性已存在', duration: 2000 });
      }
    } catch (error) {
      promptAction.showToast({ message: '属性添加失败', duration: 2000 });
    }
  }

  // 移除选中属性
  private removeSelectedProperties(): void {
    try {
      const selectedProps = this.getSelectedProperties();

      if (selectedProps.length === 0) {
        promptAction.showToast({ message: '请选择要移除的属性', duration: 2000 });
        return;
      }

      // 从当前属性列表中移除选中的属性
      const removedProps: string[] = [];
      const remainingProps: string[] = [];

      this.currentProperties.forEach(prop => {
        if (selectedProps.includes(prop)) {
          removedProps.push(prop);
        } else {
          remainingProps.push(prop);
        }
      });

      if (removedProps.length > 0) {
        this.currentProperties = remainingProps;
        promptAction.showToast({ message: `成功移除属性: ${removedProps.join(', ')}` });
      } else {
        promptAction.showToast({ message: '选中的属性不存在', duration: 2000 });
      }
    } catch (error) {
      promptAction.showToast({ message: '属性移除失败', duration: 2000 });
    }
  }

  // 测试数据类型转换
  private testDataTypeConversion(): void {
    try {
      let result = '';

      // 1. 布尔字符串转布尔
      const cleanBooleanStr = this.booleanStrInput.replace(/'/g, '');
      const strToBool = XMPUtils.convertToBoolean(cleanBooleanStr);
      result += `字符串'${cleanBooleanStr}'转布尔: ${strToBool}\n`;

      // 2. 布尔转字符串
      const boolToStr = XMPUtils.convertFromBoolean(this.booleanBoolInput);
      result += `布尔${this.booleanBoolInput}转字符串: '${boolToStr}'\n\n`;

      // 3. 字符串转整数
      const cleanIntegerStr = this.integerStrInput.replace(/'/g, '');
      const strToInt = XMPUtils.convertToInteger(cleanIntegerStr);
      result += `字符串'${cleanIntegerStr}'转整数: ${strToInt}\n`;

      // 4. 整数转字符串
      const intValue = parseInt(this.integerInput);
      if (!isNaN(intValue)) {
        const intToStr = XMPUtils.convertFromInteger(intValue);
        result += `整数${intValue}转字符串: '${intToStr}'\n\n`;
      } else {
        result += `整数转换失败: 无效的整数格式\n\n`;
      }

      // 5. 字符串转长整型
      const cleanLongStr = this.longStrInput.replace(/'/g, '');
      const strToLong = XMPUtils.convertToLong(cleanLongStr);
      result += `字符串'${cleanLongStr}'转长整型: ${strToLong}\n`;

      // 6. 长整型转字符串
      const longValue = parseInt(this.longInput);
      if (!isNaN(longValue)) {
        const longToStr = XMPUtils.convertFromLong(longValue);
        result += `长整型${longValue}转字符串: '${longToStr}'\n\n`;
      } else {
        result += `长整型转换失败: 无效的长整型格式\n\n`;
      }

      // 7. 字符串转双精度
      const cleanDoubleStr = this.doubleStrInput.replace(/'/g, '');
      const strToDouble = XMPUtils.convertToDouble(cleanDoubleStr);
      result += `字符串'${cleanDoubleStr}'转双精度: ${strToDouble}\n`;

      // 8. 双精度转字符串
      const doubleValue = parseFloat(this.doubleInput);
      if (!isNaN(doubleValue)) {
        const doubleToStr = XMPUtils.convertFromDouble(doubleValue);
        result += `双精度${doubleValue}转字符串: '${doubleToStr}'\n\n`;
      } else {
        result += `双精度转换失败: 无效的双精度格式\n\n`;
      }

      // 9. 日期转字符串
      const cleanDateStr = this.dateInput.replace(/'/g, '');
      try {
        const xmpDate = XMPUtils.convertToDate(cleanDateStr);
        const dateStr = XMPUtils.convertFromDate(xmpDate);
        result += `日期${this.dateInput}转字符串: '${dateStr}'\n`;

        // 10. 字符串转日期
        const conDate = XMPUtils.convertToDate(this.dateStrInput);

        result += `字符串'${this.dateStrInput}'转日期:`;
        result += conDate.getYear() + '年' + conDate.getMonth() + '月' + conDate.getDay() + '日 ';
        result += conDate.getHour() + '时' + conDate.getMinute() + '分' + conDate.getSecond() + '秒';
      } catch (e) {
        result += `日期转换失败: ${e}`;
      }

      this.conversionResult = result;
      promptAction.showToast({ message: '数据类型转换成功' });
    } catch (error) {
      this.conversionResult = `数据类型转换失败: ${error}`;
      promptAction.showToast({ message: '数据类型转换失败', duration: 2000 });
    }
  }

  // 测试 Base64 编码
  private testBase64Encoding(): void {
    try {
      let result = '';

      // 文本Base64编码
      if (this.base64TextInput.trim().length > 0) {
        const encoder = new util.TextEncoder();
        const buffer = encoder.encode(this.base64TextInput);
        const encodedText = XMPUtils.encodeBase64(buffer);
        const decodedBuffer = XMPUtils.decodeBase64(encodedText);
        const decoder = new util.TextDecoder();
        const decodedText = decoder.decode(decodedBuffer);
        result += `原始文本: '${this.base64TextInput}'\n\n`;
        result += `文本编码:\n'${encodedText}'\n\n`;
        result += `文本解码:\n'${decodedText}'\n\n`;
      }

      this.base64Result = result;
      promptAction.showToast({ message: 'Base64编码成功' });
    } catch (error) {
      this.base64Result = `Base64编码失败: ${error}`;
      promptAction.showToast({ message: 'Base64编码失败', duration: 2000 });
    }
  }
}