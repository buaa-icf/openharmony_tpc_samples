import { XMPDateTimeFactory } from '@ohos/xmp_toolkit';
import type { XMPDateTime } from '@ohos/xmp_toolkit';

@Entry
@Component
struct DateTimeManager {
  @State message: string = 'XMPDateTime 时间管理器';

  // 输入字段
  @State inputYear: string = '';
  @State inputMonth: string = '';
  @State inputDay: string = '';
  @State inputHour: string = '';
  @State inputMinute: string = '';
  @State inputSecond: string = '';
  @State inputNanoSecond: string = '';

  // 标志位：是否已设置自定义时间
  @State hasCustomTimeSet: boolean = false;

  // 时区选择
  @State selectedTimeZoneIndex: number = 1; // 默认选择Asia/Shanghai（索引1）
  // 时区显示文本 - 补充了+2到+7的时区
  private timeZoneDisplayTexts: string[] = [
    'UTC',
    'Asia/Shanghai (中国标准时间 UTC+8)',
    'Asia/Tokyo (日本标准时间 UTC+9)',
    'Asia/Seoul (韩国标准时间 UTC+9)',
    'Asia/Hong_Kong (香港时间 UTC+8)',
    'Asia/Singapore (新加坡时间 UTC+8)',
    'America/New_York (美国东部时间 UTC-5)',
    'America/Los_Angeles (美国太平洋时间 UTC-8)',
    'Europe/London (格林尼治标准时间 UTC+0)',
    'Europe/Paris (中欧时间 UTC+1)',
    'Australia/Sydney (澳大利亚东部时间 UTC+10)',
    // 补充缺少的时区
    'Europe/Berlin (中欧时间 UTC+1)',
    'Europe/Moscow (莫斯科时间 UTC+3)',
    'Asia/Dubai (阿联酋时间 UTC+4)',
    'Asia/Kolkata (印度标准时间 UTC+5:30)',
    'Asia/Kathmandu (尼泊尔时间 UTC+5:45)',
    'Asia/Dhaka (孟加拉时间 UTC+6)',
    'Asia/Bangkok (泰国时间 UTC+7)',
    'Asia/Ho_Chi_Minh (越南时间 UTC+7)',
    'Asia/Jakarta (印尼西部时间 UTC+7)',
    'Asia/Manila (菲律宾时间 UTC+8)',
    'Australia/Perth (澳大利亚西部时间 UTC+8)',
    'Asia/Yakutsk (雅库茨克时间 UTC+9)',
    'Australia/Adelaide (澳大利亚中部时间 UTC+9:30)',
    'Australia/Brisbane (澳大利亚东部时间 UTC+10)',
    'Pacific/Guam (关岛时间 UTC+10)',
    'Asia/Magadan (马加丹时间 UTC+11)',
    'Pacific/Auckland (新西兰时间 UTC+12)'
  ];

  // 时区实际值
  private timeZoneValues: string[] = [
    'UTC',
    'Asia/Shanghai',
    'Asia/Tokyo',
    'Asia/Seoul',
    'Asia/Hong_Kong',
    'Asia/Singapore',
    'America/New_York',
    'America/Los_Angeles',
    'Europe/London',
    'Europe/Paris',
    'Australia/Sydney',
    // 补充缺少的时区
    'Europe/Berlin',
    'Europe/Moscow',
    'Asia/Dubai',
    'Asia/Kolkata',
    'Asia/Kathmandu',
    'Asia/Dhaka',
    'Asia/Bangkok',
    'Asia/Ho_Chi_Minh',
    'Asia/Jakarta',
    'Asia/Manila',
    'Australia/Perth',
    'Asia/Yakutsk',
    'Australia/Adelaide',
    'Australia/Brisbane',
    'Pacific/Guam',
    'Asia/Magadan',
    'Pacific/Auckland'
  ];

  // 显示结果
  @State displayLines: string[] = ['', '', '']; // 初始为空
  @State operationResult: string = '';
  @State resultColor: Color = Color.Black;

  // 存储已设置的时间对象
  private storedXmpDateTime: XMPDateTime | null = null;

  aboutToAppear() {
    // 不自动填充，初始为空
  }

  // 获取当前选中的时区字符串
  getSelectedTimeZone(): string {
    if (this.selectedTimeZoneIndex >= 0 && this.selectedTimeZoneIndex < this.timeZoneValues.length) {
      return this.timeZoneValues[this.selectedTimeZoneIndex];
    }
    return 'Asia/Shanghai'; // 默认
  }

  // 显示操作结果
  showResult(message: string, success: boolean) {
    this.operationResult = message;
    this.resultColor = success ? Color.Green : Color.Red;

    // 3秒后清除结果
    setTimeout(() => {
      this.operationResult = '';
    }, 3000);
  }

  // 检查是否有输入时间（年不为空表示有输入）
  hasInputTime(): boolean {
    console.log(`[DEBUG] hasInputTime调用 - 输入值:`);
    console.log(`[DEBUG] inputYear = "${this.inputYear}"`);
    console.log(`[DEBUG] inputYear.trim() = "${this.inputYear.trim()}"`);
    console.log(`[DEBUG] inputYear.trim() !== '' = ${this.inputYear.trim() !== ''}`);
    console.log(`[DEBUG] 输入框长度: ${this.inputYear.length}`);

    // 检查空字符串和空格
    console.log(`[DEBUG] 是否为undefined: ${this.inputYear === undefined}`);
    console.log(`[DEBUG] 是否为null: ${this.inputYear === null}`);

    const result = this.inputYear.trim() !== '';
    console.log(`[DEBUG] hasInputTime最终结果: ${result}`);

    return result;
  }

  // 验证输入的时间字段
  validateInputTime(): boolean {
    // 如果有年输入，则必须验证所有输入
    if (this.hasInputTime()) {
      if (!this.inputMonth.trim() || !this.inputDay.trim()) {
        this.showResult('❌ 如果输入年份，必须同时输入月份和日期', false);
        return false;
      }

      const year = parseInt(this.inputYear);
      const month = parseInt(this.inputMonth);
      const day = parseInt(this.inputDay);

      if (isNaN(year) || year < -9999 || year > 9999) {
        this.showResult('❌ 年份必须在-9999到9999之间', false);
        return false;
      }
      if (isNaN(month) || month < 1 || month > 12) {
        this.showResult('❌ 月份必须在1-12之间', false);
        return false;
      }
      if (isNaN(day) || day < 1 || day > 31) {
        this.showResult('❌ 日期必须在1-31之间', false);
        return false;
      }

      // 验证可选时间字段
      if (this.inputHour.trim()) {
        const hour = parseInt(this.inputHour);
        if (isNaN(hour) || hour < 0 || hour > 23) {
          this.showResult('❌ 小时必须在0-23之间', false);
          return false;
        }
      }

      if (this.inputMinute.trim()) {
        const minute = parseInt(this.inputMinute);
        if (isNaN(minute) || minute < 0 || minute > 59) {
          this.showResult('❌ 分钟必须在0-59之间', false);
          return false;
        }
      }

      if (this.inputSecond.trim()) {
        const second = parseInt(this.inputSecond);
        if (isNaN(second) || second < 0 || second > 59) {
          this.showResult('❌ 秒数必须在0-59之间', false);
          return false;
        }
      }

      if (this.inputNanoSecond.trim()) {
        const nanosecond = parseInt(this.inputNanoSecond);
        if (isNaN(nanosecond) || nanosecond < 0 || nanosecond > 999999999) {
          this.showResult('❌ 纳秒必须在0-999999999之间', false);
          return false;
        }
      }
    }

    return true;
  }

  // 根据输入创建日期时间对象
  createDateTimeFromInput(): XMPDateTime | null {
    if (!this.validateInputTime()) {
      return null;
    }

    try {
      // 判断使用输入时间还是当前时间
      if (this.hasInputTime()) {
        // 使用输入的时间
        const year: number = parseInt(this.inputYear);
        const month: number = parseInt(this.inputMonth);
        const day: number = parseInt(this.inputDay);

        let dateTime: XMPDateTime;

        // 判断是否有时间部分
        const hasTime = this.inputHour.trim() || this.inputMinute.trim() ||
        this.inputSecond.trim() || this.inputNanoSecond.trim();

        if (!hasTime) {
          // 只有日期部分，使用createDate方法
          dateTime = XMPDateTimeFactory.createDate(year, month, day);
        } else {
          // 有时分秒，使用完整的create方法
          const hour: number = this.inputHour.trim() ? parseInt(this.inputHour) : 0;
          const minute: number = this.inputMinute.trim() ? parseInt(this.inputMinute) : 0;
          const second: number = this.inputSecond.trim() ? parseInt(this.inputSecond) : 0;
          const nanosecond: number = this.inputNanoSecond.trim() ? parseInt(this.inputNanoSecond) : 0;

          dateTime = XMPDateTimeFactory.create(year, month, day, hour, minute, second, nanosecond);
        }

        // 设置时区
        dateTime.setTimeZone(this.getSelectedTimeZone());

        this.showResult('✅ 使用输入的时间', true);
        console.log(`set time suc1`);
        this.hasCustomTimeSet = true; // 设置标志位为true
        return dateTime;
      } else {
        console.log(`set current time suc1`);
        this.hasCustomTimeSet = false; // 设置标志位为true
        return null;
      }

    } catch (e) {
      this.showResult('❌ 创建时间对象失败: ' + (e as Error).message, false);
      return null;
    }
  }

  // 设置时间信息 - 点击"设置时间"按钮后执行
  setDateTime(): void {
    const dateTime = this.createDateTimeFromInput();
    if (dateTime) {
      this.storedXmpDateTime = dateTime;
      this.showResult('✅ 时间设置成功', true);
      console.log(`set time suc`);
    }
  }

  // 格式化时间显示：2016/1/13 19:35:10 时区：UTC+8
  formatDateTimeForDisplay(dateTime: XMPDateTime): string {
    try {
      // 直接从XMPDateTime对象获取时间值
      const year: number = dateTime.getYear();
      const month: number = dateTime.getMonth();
      const day: number = dateTime.getDay();
      const hour: number = dateTime.getHour();
      const minute: number = dateTime.getMinute();
      const second: number = dateTime.getSecond();

      // 直接获取设置的时区字符串
      const timeZoneStr = dateTime.getTimeZone();

      // 格式：2016/1/13 19:35:10 时区：Asia/Shanghai
      return `${year}/${month}/${day} ${hour.toString().padStart(2, '0')}:${minute.toString().padStart(2, '0')}:${second.toString().padStart(2, '0')} 时区：${timeZoneStr}`;

    } catch (e) {
      return '格式化失败: ' + (e as Error).message;
    }
  }

  // 获取时间信息（核心功能） - 修复：优先使用已设置的时间
  getAndDisplayTimeInfo(): void {
    let dateTime: XMPDateTime | null = null;

    // 修复逻辑：优先使用已存储的自定义时间，否则根据当前输入创建时间
    if (this.hasCustomTimeSet && this.storedXmpDateTime) {
      // 使用已设置的时间
      dateTime = this.storedXmpDateTime;
      this.showResult('✅ 使用已设置的时间', true);
      console.log(`use set time`);
    } else {
      // 获取当前时间
      dateTime = XMPDateTimeFactory.getCurrentDateTime();
      dateTime.setTimeZone(this.getSelectedTimeZone());
      console.log(`use current time`);
      if (dateTime) {
        // 如果没有设置过自定义时间，这里只是临时使用，不保存
        if (!this.hasCustomTimeSet) {
          this.showResult('✅ 使用当前的时间', true);
        }
      }
    }

    if (!dateTime) {
      this.showResult('❌ 无法获取时间信息', false);
      return;
    }

    try {
      this.displayLines[0] = this.formatDateTimeForDisplay(dateTime);
    } catch (e) {
      const errorMsg = '显示时间信息失败: ' + (e as Error).message;
      this.displayLines = [errorMsg, '', ''];
      this.showResult('❌ 获取时间信息失败', false);
    }
  }

  // 清除所有输入和存储的时间
  clearAll(): void {
    // 清空输入框
    this.inputYear = '';
    this.inputMonth = '';
    this.inputDay = '';
    this.inputHour = '';
    this.inputMinute = '';
    this.inputSecond = '';
    this.inputNanoSecond = '';

    // 重置标志位
    this.hasCustomTimeSet = false;

    // 重置时区为默认
    this.selectedTimeZoneIndex = 1;

    // 清空显示结果
    this.displayLines = ['', '', ''];

    // 清空存储的时间对象
    this.storedXmpDateTime = null;

    // 清空操作结果
    this.operationResult = '';

    // 关闭时区对话框（如果打开）
    this.showTimeZoneDialog = false;

    this.showResult('✅ 已清除所有输入和设置', true);
  }

  // 是否显示时区选择对话框
  @State showTimeZoneDialog: boolean = false;

  build() {
    Column({ space: 12 }) {
      // 标题
      Text(this.message)
        .fontSize(24)
        .fontWeight(FontWeight.Bold)
        .fontColor(Color.Blue)
        .margin({ top: 20, bottom: 10 })

      // 操作结果提示
      if (this.operationResult) {
        Text(this.operationResult)
          .fontSize(14)
          .fontColor(this.resultColor)
          .fontWeight(FontWeight.Medium)
          .margin({ bottom: 10 })
      }

      // 显示当前状态
      if (this.hasCustomTimeSet) {
        Text('已设置自定义时间 ✓')
          .fontSize(12)
          .fontColor(Color.Green)
          .margin({ bottom: 5 })
      }

      // 输入表单 - 使用Scroll实现滚动
      Scroll() {
        Column({ space: 10 }) {
          // 日期设置
          Text('日期设置:')
            .fontSize(16)
            .fontWeight(FontWeight.Medium)
            .width('90%')
            .textAlign(TextAlign.Start)
            .margin({ top: 10, bottom: 5 })

          Row({ space: 10 }) {
            // 年
            Column() {
              Text('年').fontSize(12).fontColor(Color.Gray)
              TextInput({ text: this.inputYear, placeholder: '年' })
                .type(InputType.Number)
                .maxLength(4)
                .height(40)
                .width('100%')
                .backgroundColor(Color.White)
                .border({ width: 1, color: Color.Grey })
                .onChange((value: string) => {
                  console.log(`[UI] 年输入框变化: "${value}"`);
                  this.inputYear = value;
                })
            }
            .layoutWeight(1)

            // 月
            Column() {
              Text('月').fontSize(12).fontColor(Color.Gray)
              TextInput({ text: this.inputMonth, placeholder: '月' })
                .type(InputType.Number)
                .maxLength(2)
                .height(40)
                .width('100%')
                .backgroundColor(Color.White)
                .border({ width: 1, color: Color.Grey })
                .onChange((value: string) => {
                  console.log(`[UI] 月输入框变化: "${value}"`);
                  this.inputMonth = value;
                })
            }
            .layoutWeight(1)

            // 日
            Column() {
              Text('日').fontSize(12).fontColor(Color.Gray)
              TextInput({ text: this.inputDay, placeholder: '日' })
                .type(InputType.Number)
                .maxLength(2)
                .height(40)
                .width('100%')
                .backgroundColor(Color.White)
                .border({ width: 1, color: Color.Grey })
                .onChange((value: string) => {
                  console.log(`[UI] 日输入框变化: "${value}"`);
                  this.inputDay = value;
                })
            }
            .layoutWeight(1)
          }
          .width('90%')

          // 时间设置
          Text('时间设置:')
            .fontSize(16)
            .fontWeight(FontWeight.Medium)
            .width('90%')
            .textAlign(TextAlign.Start)
            .margin({ top: 15, bottom: 5 })

          Row({ space: 10 }) {
            // 时
            Column() {
              Text('时').fontSize(12).fontColor(Color.Gray)
              TextInput({ text: this.inputHour, placeholder: '时' })
                .type(InputType.Number)
                .maxLength(2)
                .height(40)
                .width('100%')
                .backgroundColor(Color.White)
                .border({ width: 1, color: Color.Grey })
                .onChange((value: string) => {
                  console.log(`[UI] 时输入框变化: "${value}"`);
                  this.inputHour = value;
                })
            }
            .layoutWeight(1)

            // 分
            Column() {
              Text('分').fontSize(12).fontColor(Color.Gray)
              TextInput({ text: this.inputMinute, placeholder: '分' })
                .type(InputType.Number)
                .maxLength(2)
                .height(40)
                .width('100%')
                .backgroundColor(Color.White)
                .border({ width: 1, color: Color.Grey })
                .onChange((value: string) => {
                  console.log(`[UI] 分输入框变化: "${value}"`);
                  this.inputMinute = value;
                })
            }
            .layoutWeight(1)

            // 秒
            Column() {
              Text('秒').fontSize(12).fontColor(Color.Gray)
              TextInput({ text: this.inputSecond, placeholder: '秒' })
                .type(InputType.Number)
                .maxLength(2)
                .height(40)
                .width('100%')
                .backgroundColor(Color.White)
                .border({ width: 1, color: Color.Grey })
                .onChange((value: string) => {
                  console.log(`[UI] 秒输入框变化: "${value}"`);
                  this.inputSecond = value;
                })
            }
            .layoutWeight(1)
          }
          .width('90%')

          // 纳秒
          Column() {
            Text('纳秒').fontSize(12).fontColor(Color.Gray)
            TextInput({ text: this.inputNanoSecond, placeholder: '纳秒' })
              .type(InputType.Number)
              .maxLength(9)
              .height(40)
              .width('90%')
              .backgroundColor(Color.White)
              .border({ width: 1, color: Color.Grey })
              .onChange((value: string) => {
                console.log(`[UI] 纳秒输入框变化: "${value}"`);
                this.inputNanoSecond = value;
              })
          }
          .width('100%')
          .margin({ top: 5 })

          // 时区设置 - 只有可点击的时区文本
          Text('时区设置:')
            .fontSize(16)
            .fontWeight(FontWeight.Medium)
            .width('90%')
            .textAlign(TextAlign.Start)
            .margin({ top: 15, bottom: 5 })

          Column() {
            // 当前选择的时区显示 - 点击弹出选择对话框
            Text('当前时区: ' + this.timeZoneDisplayTexts[this.selectedTimeZoneIndex])
              .fontSize(14)
              .fontColor(Color.Blue)
              .width('90%')
              .textAlign(TextAlign.Start)
              .padding(12)
              .backgroundColor(Color.White)
              .border({ width: 1, color: Color.Blue })
              .borderRadius(4)
              .onClick(() => {
                // 点击显示时区选择弹窗
                this.showTimeZoneDialog = true;
              })
          }
          .width('100%')
          .margin({ bottom: 20 })
        }
        .width('100%')
        .alignItems(HorizontalAlign.Center)
      }
      .height(350)
      .width('100%')

      // 按钮区域
      Row({ space: 10 }) {
        Button('设置时间')
          .fontSize(14)
          .fontColor(Color.White)
          .backgroundColor(Color.Blue)
          .height(40)
          .flexGrow(1)
          .onClick(() => {
            this.setDateTime();
          })

        Button('清除')
          .fontSize(14)
          .fontColor(Color.White)
          .backgroundColor(Color.Grey)
          .height(40)
          .flexGrow(1)
          .onClick(() => {
            this.clearAll();
          })

        Button('获取时间信息')
          .fontSize(14)
          .fontColor(Color.White)
          .backgroundColor(Color.Green)
          .height(40)
          .flexGrow(1)
          .onClick(() => {
            this.getAndDisplayTimeInfo();
          })
      }
      .width('90%')
      .margin({ bottom: 15 })

      // 时间信息显示区域（三行）- 初始为空
      Column({ space: 8 }) {
        Text('时间信息:')
          .fontSize(16)
          .fontWeight(FontWeight.Medium)
          .fontColor(Color.Blue)
          .width('90%')
          .textAlign(TextAlign.Start)
          .margin({ bottom: 5 })

        // 第一行：正常时间
        if (this.displayLines[0]) {
          Text('1. ' + this.displayLines[0])
            .fontSize(14)
            .fontColor(Color.Black)
            .width('90%')
            .textAlign(TextAlign.Start)
            .padding(10)
            .backgroundColor(Color.White)
            .border({ width: 1, color: Color.Grey })
        } else {
          Text('1. [未显示]')
            .fontSize(14)
            .fontColor(Color.Gray)
            .width('90%')
            .textAlign(TextAlign.Start)
            .padding(10)
            .backgroundColor('#F0F0F0')
            .border({ width: 1, color: Color.Grey })
        }
      }
      .width('100%')
      .margin({ bottom: 20 })

      // 底部说明
      Column() {
        Text('使用说明:')
          .fontSize(14)
          .fontWeight(FontWeight.Medium)
          .fontColor(Color.Gray)
          .margin({ bottom: 5 })

        Text('1. 填写日期时间（年不为空则使用输入时间）')
          .fontSize(12)
          .fontColor(Color.Gray)
        Text('2. 点击"设置时间"保存到内存')
          .fontSize(12)
          .fontColor(Color.Gray)
        Text('3. 点击时区文本选择时区')
          .fontSize(12)
          .fontColor(Color.Gray)
        Text('4. 点击"获取时间信息"显示时间转换')
          .fontSize(12)
          .fontColor(Color.Gray)
        Text('5. 点击"清除"清空所有输入和设置')
          .fontSize(12)
          .fontColor(Color.Gray)
      }
      .width('90%')
      .alignItems(HorizontalAlign.Start)
      .margin({ bottom: 20 })

      // 时区选择弹窗
      if (this.showTimeZoneDialog) {
        Column() {
          Text('选择时区')
            .fontSize(18)
            .fontWeight(FontWeight.Bold)
            .margin({ bottom: 20 })

          Scroll() {
            Column() {
              ForEach(this.timeZoneDisplayTexts, (text: string, index: number) => {
                Row() {
                  Text(text)
                    .fontSize(14)
                    .layoutWeight(1)

                  if (this.selectedTimeZoneIndex === index) {
                    Text('✓')
                      .fontSize(16)
                      .fontColor(Color.Green)
                  }
                }
                .width('100%')
                .padding(12)
                .backgroundColor(this.selectedTimeZoneIndex === index ? '#E8F4FF' : Color.White)
                .onClick(() => {
                  this.selectedTimeZoneIndex = index;
                  this.showTimeZoneDialog = false;
                })
                .border({ width: 0.5, color: Color.Grey })
              })
            }
          }
          .height(300)
          .width('100%')

          Button('取消')
            .fontSize(16)
            .fontColor(Color.White)
            .backgroundColor(Color.Grey)
            .margin({ top: 20 })
            .width('100%')
            .onClick(() => {
              this.showTimeZoneDialog = false;
            })
        }
        .width('80%')
        .padding(20)
        .backgroundColor(Color.White)
        .border({ width: 1, color: Color.Grey })
        .borderRadius(10)
        .shadow({ radius: 10, color: '#33000000' })
        .position({ x: '10%', y: '20%' })
      }

    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F5F5F5')
    .alignItems(HorizontalAlign.Center)
    .justifyContent(FlexAlign.Start)
  }
}