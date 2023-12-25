# js-joda

## 简介

适配了OpenHarmony的一款不可变日期和时间开源库。

## 下载安裝

```
 npm install @js-joda/core --save
```

OpenHarmony ohpm环境配置等更多内容，请参考 [如何安装OpenHarmony ohpm包](https://gitee.com/openharmony-tpc/docs/blob/master/OpenHarmony_har_usage.md) 。

## 使用说明

```
import { LocalDate } from '@js-joda/core'

console.info(LocalDate.now().toString());
// 解析日期2016-12-24
var mDate = LocalDate.parse('2022-07-21');
console.info(mDate.toString());
// 当前日期是本月第几天：21
console.info(mDate.dayOfMonth().toString());
// 当前月份：JULY
console.info(mDate.month().toString());
// 当前月份的值：7
console.info(mDate.monthValue().toString());
// 当前年份：2022
console.info(mDate.year().toString());
// 当前日期是周几:THURSDAY
console.info(mDate.dayOfWeek().toString());
// 当前日期是周几的值:4
console.info(mDate.dayOfWeek().value().toString());
// 当前日期是一年中的第几天：202
console.info(mDate.dayOfYear().toString());
// 当前日期是否为闰年：false
console.info(mDate.isLeapYear().toString());
// 当前月有多少天：31
console.info(mDate.lengthOfMonth().toString());
// 当前年有多少天：365
console.info(mDate.lengthOfYear().toString());
// 当前日期在一年中的第几周：29
console.info(mDate.get(ChronoField.ALIGNED_WEEK_OF_YEAR).toString());
```

## 接口说明
* 1.parse()对给定日期格式进行解析
* 2.dayOfMonth()获取当前日期是本月中的第几天
* 3.month()当前月份
* 4.year()当前年份
* 5.dayOfWeek()当前日期是周几
* 6.dayOfYear()当前日期是一年中的第几天
* 7.isLeapYear() 判断当前年份是否为闰年
* 8.lengthOfYear()判断当前年份有多少天
* 9.plusDays()当前日期加上对应天数
* 10.minusDays()当前日期减去对应天数

## 约束与限制
在下述版本验证通过：

DevEco Studio 版本：4.0Beta2（4.0.3.600），OpenHarmony SDK:API10 Release（4.0.10.11）

## 目录结构

````
/js-joda     # 项目根目录
├── entry/src/main/ets/pages      # 示例代码文件夹                   
├── README.md  # 安装使用方法                    
````

## 贡献代码

使用过程中发现任何问题都可以提 [Issue](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/issues) 给我们，当然，我们也非常欢迎你给我们发 [PR](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/pulls) 。

## 开源协议

本项目基于 [BSD License](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/blob/master/js-joda/LICENSE) ，请自由地享受和参与开源。

