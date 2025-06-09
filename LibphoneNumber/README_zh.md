# libphonenumber-js

本项目是OpenHarmony系统下使用libphonenumber-js的示例，libphonenumber-js是一个电话号码格式化和解析的Javascript开源库


## 下载安装

```sh
ohpm install libphonenumber-js@1.9.53
```

OpenHarmony ohpm 环境配置等更多内容，请参考[如何安装 OpenHarmony ohpm 包](https://gitcode.com/openharmony-tpc/docs/blob/master/OpenHarmony_har_usage.md)

## 使用说明
```javascript
    import { parsePhoneNumber, AsYouType, findPhoneNumbersInText, ParseError } from "libphonenumber-js";
    import customData from "./customData.json"; // 自定义元数据
    import Log from './../util/Log';
    import {
        parsePhoneNumberWithError,
        parsePhoneNumber as coreParsePhoneNumber,
        AsYouType as coreAsYouType
    } from 'libphonenumber-js/core'

    const number = '213-373-4253';
    const phoneNumber = parsePhoneNumber(number, 'US');
    const asYouType = new AsYouType('US');
    const findPhoneNumbers = 'For tech support call +7 (800) 555-35-35 internationally or reach a local US branch at (213) 373-4253 ext. 1234.';

    // 号码, 譬如 +12133734253
    Log.showInfo('number：' + phoneNumber.number.toString())

    // 国家，譬如 US
    Log.showInfo('country：' + phoneNumber.country);

    // 国内的号码样式，譬如 (213) 373-4253
    Log.showInfo('national：' + phoneNumber.formatNational());

    // 国际的号码样式，譬如 +1 213 373 4253
    Log.showInfo('international：' + phoneNumber.formatInternational());

    // uri形式的样式，譬如 tel:+12133734253
    Log.showInfo('uri：' + phoneNumber.getURI());

    // 类型，譬如 FIXED_LINE_OR_MOBILE
    Log.showInfo('type：' + phoneNumber.getType());

    // 是否可能是号码，从数字个数上进行判断
    Log.showInfo('isPossible：' + phoneNumber.isPossible());

    // 是否是有效号码，从所有匹配原则上判断
    Log.showInfo('isValid：' + phoneNumber.isValid());

    // 当你键入一个数字时，与之前键入的数字连接起来一起解析，直到调用clear清除状态
    asYouType.input(number);

    // 根据你键入的数字,解析国家，譬如 US
    Log.showInfo('country：' + asYouType.getCountry());

    // 根据你键入的数字,解析模板，譬如 (xxx) xxx-xxxx
    Log.showInfo('template：' + asYouType.getTemplate());

    const phoneNumberValue = asYouType.getNumber();
    if (phoneNumberValue != undefined) {
    // 根据你键入的数字,解析数字，譬如 +12133734253
    Log.showInfo('number：' + JSON.stringify(asYouType.getNumber()));

    // 根据你键入的数字,解析国内的号码样式，譬如 (213) 373-4253
    Log.showInfo('national：' + asYouType.getNumber().formatNational());

    // 根据你键入的数字,解析国际的号码样式，譬如 +1 213 373 4253
    Log.showInfo('international：' + asYouType.getNumber().formatInternational());

    // 根据你键入的数字,解析uri形式的样式，譬如 tel:+12133734253
    Log.showInfo('uri：' + asYouType.getNumber().getURI());

    // 根据你键入的数字,解析类型，譬如 FIXED_LINE_OR_MOBILE
    Log.showInfo('type：' + asYouType.getNumber().getType());
    } else {
    Log.showInfo(TAG + "getNumber() is undefined");
    }

    // 根据你键入的数字,解析是否可能是号码，从数字个数上进行判断
    Log.showInfo('isPossible：' + asYouType.isPossible());

    // 根据你键入的数字,解析是否是有效号码，从所有匹配原则上判断
    Log.showInfo('isValid：' + asYouType.isValid());

    //从一段文本中查找出电话号码
    Log.showInfo(JSON.stringify(findPhoneNumbersInText(findPhoneNumbers, 'US')));


    /**
     *
     * 使用自定义元数据,引入libphonenumber-js/core
     * 使用场景：
     * 1、在某个工程中，可能只需要处理几个特定的国家的号码
     * 2、所谓自定义元数据，就是只包含几个特定的国家的元数据，比如CN和US
     *
     */

    const number: string[] = ['+8618717452985', '+12133734253', '+78005553535'];
    // 这里只列举使用自定义元数据接口的几个示例,其它接口和使用普通元数据用法相同
    const type = new coreAsYouType('CN', customData).input(number[0]);
    Log.showInfo(TAG + ' libphonenumber-js/core AsYouType : ' + type);
    Log.showInfo(TAG + ' libphonenumber-js/core parsePhoneNumber : ' + JSON.stringify(coreParsePhoneNumber(number[0], customData)));
    Log.showInfo(TAG + ' libphonenumber-js/core parsePhoneNumber : ' + JSON.stringify(coreParsePhoneNumber(number[1], customData)));
    try {
        parsePhoneNumberWithError(number[2], customData);
    } catch (error) {
        if (error instanceof ParseError) {
            Log.showInfo(TAG + " Phone number parsing exception ,customData does not contain this country，error msg :  " + error.message);
        }
    }

```

## 接口说明
### 方法
| 方法名                           | 入参内容                                       | 接口描述                                                          |
|-------------------------------|--------------------------------------------|---------------------------------------------------------------|
| parsePhoneNumber()            | text: string, defaultCountry?: CountryCode | 从string中解析电话号码                                                |
| isPossiblePhoneNumber()       | text: string, defaultCountry?: CountryCode | { defaultCountry?: CountryCode, defaultCallingCode?: string } | 检查是否可以解析为“可能的”电话号码。 |
| isValidPhoneNumber()          | text: string, defaultCountry?: CountryCode | { defaultCountry?: CountryCode, defaultCallingCode?: string } | 检查是否可以解析为“有效”的电话号码。 |
| validatePhoneNumberLength()   | text: string, defaultCountry?: CountryCode | { defaultCountry?: CountryCode, defaultCallingCode?: string } | 检查电话号码长度是否有效。 |
| findPhoneNumbersInText()      | text: string, options?: CountryCode        | { defaultCountry?: CountryCode, defaultCallingCode?: string } | 在text中搜索电话号码。 |
| getExampleNumber()            | country: CountryCode, examples: Examples   | 返回某个国家/地区的示例电话号码。                                             |
| isSupportedCountry()          | countryCode: string                        | 检查该库是否支持某个国家。                                                 |
| getCountries()                |                                            | 返回受支持的国家/地区的列表 。                                              |
| getCountryCallingCode()       | countryCode: CountryCode                   | 返回某个国家/地区的国家/地区代码。                                            |
| getExtPrefix()                | tcountryCode: CountryCode                  | 返回指定国家/地区的电话号码分机前缀 。                                       |
| parseDigits()                 | character: string                          | 从字符串中解析数字。                                                    |
| parseIncompletePhoneNumber()  | text: string                               | 解析电话号码字符。                                                     |
| parsePhoneNumberCharacter()   | aracter: string                            | 解析输入字符串的下一个字符，同时解析+该字符串中的电话号码数字。                 |
| formatIncompletePhoneNumber() | number: string, countryCode?: CountryCode  | 格式化可能不完整的电话号码。                                             |

### PhoneNumber
| 方法名                   | 入参内容                                    | 接口描述                                  |
|-----------------------|-----------------------------------------|---------------------------------------|
| countryCallingCode    |                                         | 国家/地区呼叫代码。例如："1"。                  |
| country               |                                         | 国家代码。例如："US"。                         |
| nationalNumber        |                                         | 国家（重要）号码。例如："2133734253"。           |
| number                |                                         | E.164格式的电话号码，例如："+12133734253"。      |
| ext                   |                                         | 电话号码分机号，例如: "1234"。                   |
| carrierCode           |                                         | “运营商代码” ，例如: "15"。                    |
| setExt()              |                                         | 设置电话号码的分机号。                           |
| isPossible()          |                                         | 检查电话号码是否“可用” 。                        |
| isValid()             |                                         | 检查电话号码是否“有效” 。                        |
| getType()             |                                         | 返回电话号码类型（固定电话、移动电话、免费电话等。）   |
| format()              |                                         | 根据将电话号码格式化为字符串format。               |
| formatNational()      | options?: FormatNumberOptionsWithoutIDD | 根据将电话号码格式化为字符串format（National格式）。 | 
| formatInternational() | options?: FormatNumberOptionsWithoutIDD | 根据将电话号码格式化为字符串format（International格式。 |
| getURI()              | options?: FormatNumberOptionsWithoutIDD | 获取uri。                                       |
| isNonGeographic()     |                                         | 该号码是否属于“非地理编号计划”。                     |
| isEqual()             | phoneNumber: PhoneNumber                | 比较两个PhoneNumbers：true如果它们相等则返回，false否则。 |

### AsYouType
| 方法名                  | 入参内容         | 接口描述                     |
|------------------------|--------------|----------------------------|
| country                |              |                            |
| input()                | text: string | 将文本附加到输入                   |
| reset()                |              | 重置输入                       |
| getNumber()            |              | 返回PhoneNumber              |
| getNumberValue()       |              | 返回格式为E.164的电话号码            |
| getNationalNumber()    |              | 返回电话号码                     |
| getChars()             |              | 返回用户输入的电话号码字符              |
| getTemplate()          |              | 返回用于格式化电话号码字符（数字和符号，如有）的模板 |
| getCallingCode()       |              | 返回电话号码的“国家/地区代码”部分         |
| getCountry()           |              | 返回电话号码的两字母国家代码             |
| isInternational()      |              | 如果电话号码以国际格式输入，则返回true      |
| isPossible()           |              | 电话号码是否“可用”                 |
| isValid()              |              | 电话号码是否“有效”                 |

## 约束与限制

- DevEco Studio 版本： 4.1 Canary(4.1.3.317)
- OpenHarmony SDK: API11 (4.1.0.36)

## 贡献代码

使用过程中发现任何问题都可以提 [Issue](https://gitcode.com/openharmony-tpc/openharmony_tpc_samples/issues) ，当然，也非常欢迎发 [PR](https://gitcode.com/openharmony-tpc/openharmony_tpc_samples/pulls) 。

## 开源协议

本项目基于 [Apache License 2.0](https://gitcode.com/openharmony-tpc/openharmony_tpc_samples/blob/master/LibphoneNumber/LICENSE) ，请自由地享受和参与开源。
