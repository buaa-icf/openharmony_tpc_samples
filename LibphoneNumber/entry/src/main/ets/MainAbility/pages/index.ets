/*
 * Copyright (C) 2021 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import {parsePhoneNumber, AsYouType, findPhoneNumbersInText} from 'libphonenumber-js/max'
import Log from './../util/Log'

@Entry
@Component
struct Index {
  build() {
    Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Center, justifyContent: FlexAlign.Center }) {
      Text('Hello World')
        .fontSize(50)
        .fontWeight(FontWeight.Bold)
      Button() {
        Text('no args btn').fontSize(30).fontWeight(FontWeight.Bold)
      }
      .onClick((event: ClickEvent) => {
        this.onInit()
      })
    }
    .width('100%')
    .height('100%')
  }

  onInit() {

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

    // 根据你键入的数字,解析数字，譬如 +12133734253
    Log.showInfo('number：' + asYouType.getNumber());

    // 根据你键入的数字,解析国内的号码样式，譬如 (213) 373-4253
    Log.showInfo('national：' + asYouType.getNumber().formatNational());

    // 根据你键入的数字,解析国际的号码样式，譬如 +1 213 373 4253
    Log.showInfo('international：' + asYouType.getNumber().formatInternational());

    // 根据你键入的数字,解析uri形式的样式，譬如 tel:+12133734253
    Log.showInfo('uri：' + asYouType.getNumber().getURI());

    // 根据你键入的数字,解析类型，譬如 FIXED_LINE_OR_MOBILE
    Log.showInfo('type：' + asYouType.getNumber().getType());

    // 根据你键入的数字,解析是否可能是号码，从数字个数上进行判断
    Log.showInfo('isPossible：' + asYouType.isPossible());

    // 根据你键入的数字,解析是否是有效号码，从所有匹配原则上判断
    Log.showInfo('isValid：' + asYouType.isValid());

    //从一段文本中查找出电话号码
    Log.showInfo(JSON.stringify(findPhoneNumbersInText(findPhoneNumbers, 'US')));
  }
}