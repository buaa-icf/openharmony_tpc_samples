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

import * as intl_messageformat_parser from '@f-fjs/intl-messageformat-parser'
import { ExtendedDateTimeFormatOptions, MessageFormatElement } from '@f-fjs/intl-messageformat-parser';
import { setData, CustomDialogExample } from './loading'


@Entry
@Component
struct Index {
  dialogController: CustomDialogController = new CustomDialogController({
    builder: CustomDialogExample(),
    autoCancel: true
  });

  build() {
    Scroll() {
      Column({ space: 20 }) {
        Button($r('app.string.parse_test')).fontSize(24).onClick(() => {
          let input = 'On{takenDate,date,short} {name} took {numPhotos,plural, =0 {no photos.} =1{one photo.} other {# photos}}';
          let ast: MessageFormatElement[] = intl_messageformat_parser.parse(input);
          setData(JSON.stringify(ast), this.dialogController)
        })
        Button($r('app.string.isLiteralElement')).fontSize(24).onClick(() => {
          let input: intl_messageformat_parser.LiteralElement = {
            type: intl_messageformat_parser.TYPE.literal, value: 'testValue'
          };
          let typesResult: boolean = intl_messageformat_parser.isLiteralElement(input);
          if (typesResult) {
            setData($r('app.string.test_successful'), this.dialogController)
          }
        })
        Button($r('app.string.isArgumentElement')).fontSize(24).onClick(() => {
          let input: intl_messageformat_parser.ArgumentElement = {
            type: intl_messageformat_parser.TYPE.argument, value: 'testValue'
          };
          let typesResult: boolean = intl_messageformat_parser.isArgumentElement(input);
          if (typesResult) {
            setData($r('app.string.test_successful'), this.dialogController)
          }
        })
        Button($r('app.string.isNumberElement')).fontSize(24).onClick(() => {
          let input: intl_messageformat_parser.NumberElement = {
            type: intl_messageformat_parser.TYPE.number, value: 'testValue'
          };
          let typesResult: boolean = intl_messageformat_parser.isNumberElement(input);
          if (typesResult) {
            setData($r('app.string.test_successful'), this.dialogController)
          }
        })
        Button($r('app.string.isDateElement')).fontSize(24).onClick(() => {
          let input: intl_messageformat_parser.DateElement = {
            type: intl_messageformat_parser.TYPE.date, value: 'testValue'
          };
          let typesResult: boolean = intl_messageformat_parser.isDateElement(input);
          if (typesResult) {
            setData($r('app.string.test_successful'), this.dialogController)
          }
        })
        Button($r('app.string.isTimeElement')).fontSize(24).onClick(() => {
          let input: intl_messageformat_parser.TimeElement = {
            type: intl_messageformat_parser.TYPE.time, value: 'testValue'
          };
          let typesResult: boolean = intl_messageformat_parser.isTimeElement(input);
          if (typesResult) {
            setData($r('app.string.test_successful'), this.dialogController)
          }
        })
        Button($r('app.string.isSelectElement')).fontSize(24).onClick(() => {
          let input: intl_messageformat_parser.SelectElement = {
            type: intl_messageformat_parser.TYPE.select, value: 'testValue', options: {}
          };
          let typesResult: boolean = intl_messageformat_parser.isSelectElement(input);
          if (typesResult) {
            setData($r('app.string.test_successful'), this.dialogController)
          }
        })
        Button($r('app.string.isPluralElement')).fontSize(24).onClick(() => {
          let input: intl_messageformat_parser.PluralElement = {
            type: intl_messageformat_parser.TYPE.plural,
            value: 'testValue',
            options: {},
            offset: 0,
            pluralType: undefined
          };
          let typesResult: boolean = intl_messageformat_parser.isPluralElement(input)
          if (typesResult) {
            setData($r('app.string.test_successful'), this.dialogController)
          }
        })
        Button($r('app.string.isPoundElement')).fontSize(24).onClick(() => {
          let input: intl_messageformat_parser.PoundElement = {
            type: intl_messageformat_parser.TYPE.pound
          };
          let typesResult: boolean = intl_messageformat_parser.isPoundElement(input);
          if (typesResult) {
            setData($r('app.string.test_successful'), this.dialogController)
          }
        })
        Button($r('app.string.isTagElement')).fontSize(24).onClick(() => {
          let input: intl_messageformat_parser.TagElement = {
            type: intl_messageformat_parser.TYPE.tag, value: 'testValue', children: []
          };
          const typesResult: boolean = intl_messageformat_parser.isTagElement(input);
          if (typesResult) {
            setData($r('app.string.test_successful'), this.dialogController)
          }
        })
        Button($r('app.string.isNumberSkeleton')).fontSize(24).onClick(() => {
          let input: intl_messageformat_parser.NumberSkeleton = {
            type: intl_messageformat_parser.SKELETON_TYPE.number, tokens: []
          };
          let typesResult: boolean = intl_messageformat_parser.isNumberSkeleton(input);
          if (typesResult) {
            setData($r('app.string.test_successful'), this.dialogController)
          }
        })
        Button($r('app.string.isDateTimeSkeleton')).fontSize(24).onClick(() => {
          let input: intl_messageformat_parser.DateTimeSkeleton = {
            type: intl_messageformat_parser.SKELETON_TYPE.dateTime, pattern: ''
          };
          let typesResult: boolean = intl_messageformat_parser.isDateTimeSkeleton(input);
          if (typesResult) {
            setData($r('app.string.test_successful'), this.dialogController)
          }
        })
        Button($r('app.string.createLiteralElement')).fontSize(24).onClick(() => {
          let typesResult: intl_messageformat_parser.LiteralElement = intl_messageformat_parser.createLiteralElement('testValue');
          if (typesResult.value == 'testValue') {
            setData($r('app.string.test_successful'), this.dialogController)
          }
        })
        Button($r('app.string.createNumberElement')).fontSize(24).onClick(() => {
          let typesResult: intl_messageformat_parser.NumberElement = intl_messageformat_parser.createNumberElement('testValue');
          if (typesResult.value == 'testValue') {
            setData($r('app.string.test_successful'), this.dialogController)
          }
        })
        Button($r('app.string.parseDateTimeSkeleton')).fontSize(24).onClick(() => {
          let input = 'ymd';
          let skeletonResult: ExtendedDateTimeFormatOptions = intl_messageformat_parser.parseDateTimeSkeleton(input);
          if (skeletonResult != null) {
            setData($r('app.string.test_successful'), this.dialogController)
          }
        })
        Button($r('app.string.convertNumberSkeletonToNumberFormatOptions')).fontSize(24).onClick(() => {
          let skeletonTokens: intl_messageformat_parser.NumberSkeletonToken[] = [{
            stem: 'percent', options: ['testOptions']
          }];
          let skeletonResult: ESObject = intl_messageformat_parser.convertNumberSkeletonToNumberFormatOptions(skeletonTokens);
          if (skeletonResult != null) {
            setData($r('app.string.test_successful'), this.dialogController)
          }
        })
      }
      .width('100%')
    }
    .scrollable(ScrollDirection.Vertical)
  }
}