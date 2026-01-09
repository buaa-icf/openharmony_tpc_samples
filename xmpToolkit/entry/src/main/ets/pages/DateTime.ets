import { XMPDateTimeFactory } from '@ohos/xmp_toolkit';

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

    // 3个测试项目
    await this.test01_getDateTimeMethods();
    await this.test02_setDateTimeMethods();
    await this.test03_createDateTimeMethods();
    await this.test04_setLocalTimeZoneMethods();
  }

  async test01_getDateTimeMethods() {
    this.currentTest = '[1/4] 获取日期时间';
    try {
      const currentDate = XMPDateTimeFactory.getCurrentDateTime();

      const curYear= currentDate.getYear();
      const curMonth= currentDate.getMonth();
      const curDay= currentDate.getDay();
      const curHour= currentDate.getHour();
      const curMinute= currentDate.getMinute();
      const curSecond= currentDate.getSecond();
      const curNanoSec= currentDate.getNanoSecond();
      const isoString = currentDate.getISO8601String();

      const calendarDate: Date = currentDate.getCalendar();
      const calendarValid = calendarDate instanceof Date;

      const utcYear = calendarDate.getUTCFullYear();
      const utcMonth = calendarDate.getUTCMonth() + 1;
      const utcDay = calendarDate.getUTCDate();
      const utcHour = calendarDate.getUTCHours();
      const utcMinute = calendarDate.getUTCMinutes();
      const utcSecond = calendarDate.getUTCSeconds();

      const yearMatch = utcYear === curYear;
      const monthMatch = utcMonth === curMonth;
      const dayMatch = utcDay === curDay;
      const hourMatch = utcHour === curHour;
      const minuteMatch = utcMinute === curMinute;
      const secondMatch = Math.abs(utcSecond - curSecond) <= 1; // 允许1秒误差

      const calendarPassed = calendarValid && secondMatch && yearMatch &&
        monthMatch && minuteMatch;

      const passed = curYear > 2024 && calendarPassed;

      let message = '当前本地时间: ';
	  message += curYear + '年' + curMonth + '月' + curDay + '日';
      message += ' ' + curHour + ':' + curMinute + ':' + curSecond + ':' + curNanoSec;
      message += '\nISO8601字符串: ' + isoString;
      message += '\n获取到日历: ' + utcYear + '年' + utcMonth + '月' + utcDay + '日';
      message += ' ' + utcHour + ':' + utcMinute + ':' + utcSecond;
      this.addResult('1. 获取日期时间', passed, message);
    } catch (e) {
      this.addResult('1. 获取日期时间', false, (e as Error).message);
    }
  }

  async test02_setDateTimeMethods() {
    this.currentTest = '[2/4] 设置日期时间';
    try {
      const testDate = XMPDateTimeFactory.createEmpty();

      testDate.setYear(2024);
      testDate.setMonth(12);
      testDate.setDay(26);
      testDate.setHour(11);
      testDate.setMinute(36);
      testDate.setSecond(54);
      testDate.setNanoSecond(3210040);
      testDate.setTimeZone('UTC');

      const hasDate = testDate.hasDate();
      const hasTime = testDate.hasTime();
      const tz = testDate.getTimeZone();

      const hasTz = testDate.hasTimeZone();

      const setYear = testDate.getYear();
      const setMonth = testDate.getMonth();
      const setDay = testDate.getDay();
      const setHour = testDate.getHour();
      const setMinute = testDate.getMinute();
      const setSecond = testDate.getSecond();
      const setNanoSec = testDate.getNanoSecond();

      const yearMatch = setYear === 2024;
      const monthMatch = setMonth === 12;
      const dayMatch = setDay === 26;
      const hourMatch = setHour === 11;
      const minuteMatch = setMinute === 36;
      const secondMatch = Math.abs(setSecond - 54) <= 1; // 允许1秒误差

      const passed = yearMatch && monthMatch && dayMatch && hourMatch &&
        minuteMatch && secondMatch && hasDate && hasTime && hasTz;

      let message = '设置日期时间: ';
      message += setYear + '年' + setMonth + '月' + setDay + '日';
      message += ' ' + setHour + ':' + setMinute + ':' + setSecond + ':' + setNanoSec;
      message += '\n设置当前时区为: ' + tz;
      this.addResult('2. 设置日期时间', passed, message);
    } catch (e) {
      this.addResult('2. 设置日期时间', false, (e as Error).message);
    }
  }

  async test03_createDateTimeMethods() {
    this.currentTest = '[3/4] 创建日期时间';
    try {
      const jsDate = new Date(2024, 10, 28, 14, 30, 45);
      const xmpDate = XMPDateTimeFactory.createFromCalendar(jsDate);
      const calYear = xmpDate.getYear();
      const calMonth = xmpDate.getMonth();
      const calDay = xmpDate.getDay();
      const calHour = xmpDate.getHour();
      const calMinute = xmpDate.getMinute();
      const calSecond = xmpDate.getSecond();

      const yearMatch = calYear === 2024;
      const monthMatch = calMonth === 11;
      const dayMatch = calDay === 28;
      const hourMatch = calHour === 14;
      const minuteMatch = calMinute === 30;
      const secondMatch = Math.abs(calSecond - 45) <= 1; // 允许1秒误差

      const testDate = XMPDateTimeFactory.createEmpty();
      const emptyYear = testDate.getYear();
      const emptyMonth = testDate.getMonth();
      const emptyDay = testDate.getDay();
      const emptyHour = testDate.getHour();
      const emptyMinute = testDate.getMinute();
      const emptySecond = testDate.getSecond();

      const date = XMPDateTimeFactory.createDate(2025, 12, 27);
      const year = date.getYear();
      const month = date.getMonth();
      const day = date.getDay();

      const dt = XMPDateTimeFactory.create(2025, 12, 27, 15, 47, 21, 432100);
      const dtYear = dt.getYear();
      const dtMonth = dt.getMonth();
      const dtDay = dt.getDay();
      const dtHour = dt.getHour();
      const dtMinute = dt.getMinute();
      const dtSecond = dt.getSecond();
      const dtNanoSecond = dt.getNanoSecond();

      // 转换为UTC时间
      const currentDt = XMPDateTimeFactory.getCurrentDateTime();
      const utcDt =XMPDateTimeFactory.convertToUTCTime(currentDt);
      const utcDtStr = utcDt.getISO8601String();

      // 转换为本地时间
      const backToLocal = XMPDateTimeFactory.convertToLocalTime(utcDt);
      const backToLocalStr = backToLocal.getISO8601String();

      // 验证转换是否成功（本地时间与原始时间不同，因为时区转换）
      const localTimeConverted = currentDt.getYear() === backToLocal.getYear() &&
        currentDt.getMonth() === backToLocal.getMonth() &&
        currentDt.getDay() === backToLocal.getDay() &&
        currentDt.getHour() === backToLocal.getHour() &&
        currentDt.getMinute() === backToLocal.getMinute() &&
        currentDt.getSecond() === backToLocal.getSecond();

      const passed = yearMatch && monthMatch && dayMatch && hourMatch &&
        minuteMatch && secondMatch && localTimeConverted;

      let message = '从日历创建日期时间: ';
      message += calYear + '年' + calMonth + '月' + calDay + '日';
      message += ' ' + calHour + ':' + calMinute + ':' + calSecond;
      message += '\n创建空日期时间:' + emptyYear + '年' + emptyMonth + '月' + emptyDay + '日';
      message += ' ' + emptyHour + ':' + emptyMinute + ':' + emptySecond;
      message += '\n仅创建日期:' + year + '年' + month + '月' + day + '日';
      message += '\n创建日期时间:' + dtYear + '年' + dtMonth + '月' + dtDay + '日';
      message += ' ' + dtHour + ':' + dtMinute + ':' + dtSecond + ':' + dtNanoSecond;
      message += '\n转换为UTC时间:' + utcDtStr;
      message += '\n转回本地时间:' + currentDt.getYear() + '-' + backToLocal.getMonth() + '-';
      message += backToLocal.getDay() + ' ' + backToLocal.getHour() + ':' + backToLocal.getMinute() + ':';
      message += backToLocal.getSecond();

      this.addResult('3. 创建日期时间', passed, message);
    } catch (e) {
      this.addResult('3. 创建日期时间', false, (e as Error).message);
    }
  }

  async test04_setLocalTimeZoneMethods() {
    this.currentTest = '[4/4] 设置本地时区';
    try {
      // 创建一个UTC时间
      const utcDateTime = XMPDateTimeFactory.createEmpty();
      utcDateTime.setYear(2024);
      utcDateTime.setMonth(6);
      utcDateTime.setDay(15);
      utcDateTime.setHour(10);
      utcDateTime.setMinute(30);
      utcDateTime.setSecond(0);
      utcDateTime.setNanoSecond(0);
      utcDateTime.setTimeZone('UTC');
      utcDateTime.setTimeZoneOffset(0);  // UTC时区偏移为0

      // 记录原始时间
      const originalYear = utcDateTime.getYear();
      const originalMonth = utcDateTime.getMonth();
      const originalDay = utcDateTime.getDay();
      const originalHour = utcDateTime.getHour();
      const originalMinute = utcDateTime.getMinute();
      const originalSecond = utcDateTime.getSecond();
      const originalTimeZone = utcDateTime.getTimeZone();
      const originalOffset = utcDateTime.getTimeZoneOffset();

      // 转换为本地时区
      const localDateTime = XMPDateTimeFactory.setLocalTimeZone(utcDateTime);

      // 获取转换后的时间
      const localYear = localDateTime.getYear();
      const localMonth = localDateTime.getMonth();
      const localDay = localDateTime.getDay();
      const localHour = localDateTime.getHour();
      const localMinute = localDateTime.getMinute();
      const localSecond = localDateTime.getSecond();
      const localTimeZone = localDateTime.getTimeZone();
      const localOffset = localDateTime.getTimeZoneOffset();
      const hasTimeZone = localDateTime.hasTimeZone();

      // 获取系统本地时区偏移
      const now = new Date();
      const systemOffset = -now.getTimezoneOffset() * 60 * 1000; // 毫秒

      const yearMatch = originalYear === localYear;
      const monthMatch = originalMonth === localMonth;
      const dayMatch = originalDay === localDay;
      const hourMatch = originalHour === localHour;
      const minuteMatch = originalMinute === localMinute;
      const secondMatch = originalSecond === localSecond;

      // 时区应该从UTC变为本地时区
      const timeZoneChanged = originalTimeZone !== localTimeZone;
      const hasValidTimeZone = hasTimeZone && localTimeZone !== '';

      // 时区偏移应该从0变为本地时区偏移
      const offsetChanged = originalOffset !== localOffset;
      const offsetMatch = Math.abs(localOffset - systemOffset) < 60000; // 允许1分钟误差

      // setLocalTimeZone不应该调整时间字段，只应该更改时区
      const fieldsPreserved = yearMatch && monthMatch && dayMatch && hourMatch && minuteMatch && secondMatch;

      const passed = timeZoneChanged && hasValidTimeZone && offsetChanged && offsetMatch && fieldsPreserved;

      let message = '原始UTC时间: ';
      message += originalYear + '-' + originalMonth + '-' + originalDay;
      message += ' ' + originalHour + ':' + originalMinute + ':' + originalSecond;
      message += ' (时区: ' + originalTimeZone + ', 偏移: ' + (originalOffset / (60 * 60 * 1000)) + '小时)';

      message += '\n转换后本地时间: ';
      message += localYear + '-' + localMonth + '-' + localDay;
      message += ' ' + localHour + ':' + localMinute + ':' + localSecond;
      message += ' (时区: ' + localTimeZone + ', 偏移: ' + (localOffset / (60 * 60 * 1000)) + '小时)';

      message += '\n系统本地时区偏移: ' + (systemOffset / (60 * 60 * 1000)) + '小时';

      this.addResult('4. 设置本地时区', passed, message);
    } catch (e) {
      this.addResult('4. 设置本地时区', false, (e as Error).message);
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
