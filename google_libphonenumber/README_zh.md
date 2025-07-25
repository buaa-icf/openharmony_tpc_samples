# google-libphonenumber

## 简介
- 本库是OpenHarmony系统下基于google-libphonenumber库使用的开发示例，此处使用的版本是google-libphonenumber@3.2.42,
google-libphonenumber主要功能是提供了一套强大的工具来解析、格式化、存储和验证全球电话号码。

## 下载安装

1. 参考安装教程 [如何安装OpenHarmony ohpm包](https://gitee.com/openharmony-tpc/docs/blob/master/OpenHarmony_har_usage.md)

2. 安装命令如下：

   ```
   ohpm install google-libphonenumber@3.2.42
   ```
## 使用说明
```javascript
    import { PhoneNumberUtil, PhoneNumber, PhoneNumberFormat, AsYouTypeFormatter, PhoneNumberType, ShortNumberInfo } from 'google-libphonenumber';
    const phoneUtil: PhoneNumberUtil = PhoneNumberUtil.getInstance();
    // Parse number with country code and keep raw input.
    const number = phoneUtil.parseAndKeepRawInput('202-456-1414', 'US');

    // Print the phone's country code.
    console.log(number.getCountryCode());
    // => 1

    // Print the phone's national number.
    console.log(number.getNationalNumber());
    // => 2024561414

    // Print the phone's extension.
    console.log(number.getExtension());
    // =>

    // Print the phone's extension when compared to i18n.phonenumbers.CountryCodeSource.
    console.log(number.getCountryCodeSource());
    // => FROM_DEFAULT_COUNTRY

    // Print the phone's italian leading zero.
    console.log(number.getItalianLeadingZero());
    // => false

    // Print the phone's raw input.
    console.log(number.getRawInput());
    // => 202-456-1414

    // Result from isPossibleNumber().
    console.log(phoneUtil.isPossibleNumber(number));
    // => true

    // Result from isValidNumber().
    console.log(phoneUtil.isValidNumber(number));
    // => true

    // Result from isValidNumberForRegion().
    console.log(phoneUtil.isValidNumberForRegion(number, 'US'));
    // => true

    // Result from getRegionCodeForNumber().
    console.log(phoneUtil.getRegionCodeForNumber(number));
    // => US

    // Result from getNumberType() when compared to i18n.phonenumbers.PhoneNumberType.
    console.log(phoneUtil.getNumberType(number));
    // => FIXED_LINE_OR_MOBILE

    // Format number in the E164 format.
    console.log(phoneUtil.format(number, PhoneNumberFormat.E164));
    // => +12024561414

    // Format number in the original format.
    console.log(phoneUtil.formatInOriginalFormat(number, 'US'));
    // => (202) 456-1414

    // Format number in the national format.
    console.log(phoneUtil.format(number, PhoneNumberFormat.NATIONAL));
    // => (202) 456-1414

    // Format number in the international format.
    console.log(phoneUtil.format(number, PhoneNumberFormat.INTERNATIONAL));
    // => +1 202-456-1414

    // Format number in the out-of-country format from US.
    console.log(phoneUtil.formatOutOfCountryCallingNumber(number, 'US'));
    // => 1 (202) 456-1414

    // Format number in the out-of-country format from CH.
    console.log(phoneUtil.formatOutOfCountryCallingNumber(number, 'CH'));
    // => 00 1 202-456-1414

    // Require `AsYouTypeFormatter`.
    const formatter = new AsYouTypeFormatter('US');

    console.log(formatter.inputDigit('2')); // => 2
    console.log(formatter.inputDigit('0')); // => 20
    console.log(formatter.inputDigit('2')); // => 202
    console.log(formatter.inputDigit('-')); // => 202-
    console.log(formatter.inputDigit('4')); // => 202-4
    console.log(formatter.inputDigit('5')); // => 202-45
    console.log(formatter.inputDigit('6')); // => 202-456
    console.log(formatter.inputDigit('-')); // => 202-456-
    console.log(formatter.inputDigit('1')); // => 202-456-1
    console.log(formatter.inputDigit('4')); // => 202-456-14
    console.log(formatter.inputDigit('1')); // => 202-456-141
    console.log(formatter.inputDigit('4')); // => 202-456-1414

    // Cleanup all input digits from instance.
    formatter.clear();

```

## 约束与限制
在下述版本验证通过：
- DevEco Studio 版本： 5.0.3.500; SDK: API12 (5.0.0.31)


## 目录结构

```
|---- google-libphonenumber 
|     |----- dist
|            |------- libphonenumber.js# 生成的电话号码处理接口类
|     |---- README.md  # 详细介绍安装与使用方法的文档
```

## 贡献代码

使用过程中发现任何问题都可以提 [Issue](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/issues) 给本库，当然，也非常欢迎使用者向本库发 [PR](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/pulls) 。

## 开源协议

此项目基于 [MIT许可](https://github.com/ruimarinho/google-libphonenumber/blob/master/LICENSE) ，欢迎自由使用并参与开源贡献。