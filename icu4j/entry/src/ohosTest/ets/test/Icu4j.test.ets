/*
 * Copyright (C) 2022 Huawei Device Co., Ltd.
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

import { describe, it, expect } from '@ohos/hypium'
import * as intl_messageformat_parser from '@f-fjs/intl-messageformat-parser';

export default function icu4jTest() {
  describe('Icu4jTest', () => {
    // Defines a test suite. Two parameters are supported: test suite name and test suite function.
    it('test_index_parser_input', 0, () => {
      let input = '{test}';
      const parseResult = intl_messageformat_parser.parse(input);
      expect(parseResult.length > 0).assertTrue();
    });
    it('test_index_parser_inputEmpty', 0, () => {
      let input = '';
      const parseResult = intl_messageformat_parser.parse(input, {
        normalizeHashtagInPlural: true, captureLocation: true
      });
      expect(parseResult.length).assertEqual(0);
    });
    it('test_index_parser_optsFalse', 0, () => {
      let input = '{test}';
      const parseResult = intl_messageformat_parser.parse(input, {
        normalizeHashtagInPlural: false, captureLocation: false
      });
      expect(parseResult.length > 0).assertTrue();
    });
    it('test_index_parser_optsDefault', 0, () => {
      let input = '{test}';
      const parseResult = intl_messageformat_parser.parse(input, {});
      expect(parseResult.length > 0).assertTrue();
    });

    it('test_types_isLiteralElement_true', 0, () => {
      let input: intl_messageformat_parser.LiteralElement = {
        type: intl_messageformat_parser.TYPE.literal, value: 'testValue'
      };
      const typesResult = intl_messageformat_parser.isLiteralElement(input);
      expect(typesResult).assertTrue();
    });
    it('test_types_isLiteralElement_false', 0, () => {
      let input: intl_messageformat_parser.PoundElement = {
        type: intl_messageformat_parser.TYPE.pound
      };
      const typesResult = intl_messageformat_parser.isLiteralElement(input);
      expect(typesResult).assertFalse();
    });
    it('test_types_isLiteralElement_null', 0, () => {
      let input = null;
      let typesResult: string | boolean = '';
      try {
        typesResult = intl_messageformat_parser.isLiteralElement(input);
      } catch (e) {
        typesResult = 'e';
      }
      expect(typesResult == 'e').assertTrue();
    });
    it('test_types_isLiteralElement_undefined', 0, () => {
      let input = undefined;
      let typesResult: string | boolean = '';
      try {
        typesResult = intl_messageformat_parser.isLiteralElement(input);
      } catch (e) {
        typesResult = 'e';
      }
      expect(typesResult == 'e').assertTrue();
    });

    it('test_types_isArgumentElement_true', 0, () => {
      let input: intl_messageformat_parser.ArgumentElement = {
        type: intl_messageformat_parser.TYPE.argument, value: 'testValue'
      };
      const typesResult = intl_messageformat_parser.isArgumentElement(input);
      expect(typesResult).assertTrue();
    });
    it('test_types_isArgumentElement_false', 0, () => {
      let input: intl_messageformat_parser.PoundElement = {
        type: intl_messageformat_parser.TYPE.pound
      };
      const typesResult = intl_messageformat_parser.isArgumentElement(input);
      expect(typesResult).assertFalse();
    });
    it('test_types_isArgumentElement_null', 0, () => {
      let input = null;
      let typesResult: string | boolean = '';
      try {
        typesResult = intl_messageformat_parser.isArgumentElement(input);
      } catch (e) {
        typesResult = 'e';
      }
      expect(typesResult == 'e').assertTrue();
    });
    it('test_types_isArgumentElement_undefined', 0, () => {
      let input = undefined;
      let typesResult: string | boolean = '';
      try {
        typesResult = intl_messageformat_parser.isArgumentElement(input);
      } catch (e) {
        typesResult = 'e';
      }
      expect(typesResult == 'e').assertTrue();
    });

    it('test_types_isNumberElement_true', 0, () => {
      let input: intl_messageformat_parser.NumberElement = {
        type: intl_messageformat_parser.TYPE.number, value: 'testValue'
      };
      const typesResult = intl_messageformat_parser.isNumberElement(input);
      expect(typesResult).assertTrue();
    });
    it('test_types_isNumberElement_false', 0, () => {
      let input: intl_messageformat_parser.PoundElement = {
        type: intl_messageformat_parser.TYPE.pound
      };
      const typesResult = intl_messageformat_parser.isNumberElement(input);
      expect(typesResult).assertFalse();
    });
    it('test_types_isNumberElement_null', 0, () => {
      let input = null;
      let typesResult: string | boolean = '';
      try {
        typesResult = intl_messageformat_parser.isNumberElement(input);
      } catch (e) {
        typesResult = 'e';
      }
      expect(typesResult == 'e').assertTrue();
    });
    it('test_types_isNumberElement_undefined', 0, () => {
      let input = undefined;
      let typesResult: string | boolean = '';
      try {
        typesResult = intl_messageformat_parser.isNumberElement(input);
      } catch (e) {
        typesResult = 'e';
      }
      expect(typesResult == 'e').assertTrue();
    });

    it('test_types_isDateElement_true', 0, () => {
      let input: intl_messageformat_parser.DateElement = {
        type: intl_messageformat_parser.TYPE.date, value: 'testValue'
      };
      const typesResult = intl_messageformat_parser.isDateElement(input);
      expect(typesResult).assertTrue();
    });
    it('test_types_isDateElement_false', 0, () => {
      let input: intl_messageformat_parser.PoundElement = {
        type: intl_messageformat_parser.TYPE.pound
      };
      const typesResult = intl_messageformat_parser.isDateElement(input);
      expect(typesResult).assertFalse();
    });
    it('test_types_isDateElement_null', 0, () => {
      let input = null;
      let typesResult: string | boolean = '';
      try {
        typesResult = intl_messageformat_parser.isDateElement(input);
      } catch (e) {
        typesResult = 'e';
      }
      expect(typesResult == 'e').assertTrue();
    });
    it('test_types_isDateElement_undefined', 0, () => {
      let input = undefined;
      let typesResult: string | boolean = '';
      try {
        typesResult = intl_messageformat_parser.isDateElement(input);
      } catch (e) {
        typesResult = 'e';
      }
      expect(typesResult == 'e').assertTrue();
    });

    it('test_types_isTimeElement_true', 0, () => {
      let input: intl_messageformat_parser.TimeElement = {
        type: intl_messageformat_parser.TYPE.time, value: 'testValue'
      };
      const typesResult = intl_messageformat_parser.isTimeElement(input);
      expect(typesResult).assertTrue();
    });
    it('test_types_isTimeElement_false', 0, () => {
      let input: intl_messageformat_parser.PoundElement = {
        type: intl_messageformat_parser.TYPE.pound
      };
      const typesResult = intl_messageformat_parser.isTimeElement(input);
      expect(typesResult).assertFalse();
    });
    it('test_types_isTimeElement_null', 0, () => {
      let input = null;
      let typesResult: string | boolean = '';
      try {
        typesResult = intl_messageformat_parser.isTimeElement(input);
      } catch (e) {
        typesResult = 'e';
      }
      expect(typesResult == 'e').assertTrue();
    });
    it('test_types_isTimeElement_undefined', 0, () => {
      let input = undefined;
      let typesResult: string | boolean = '';
      try {
        typesResult = intl_messageformat_parser.isTimeElement(input);
      } catch (e) {
        typesResult = 'e';
      }
      expect(typesResult == 'e').assertTrue();
    });

    it('test_types_isSelectElement_true', 0, () => {
      let input: intl_messageformat_parser.SelectElement = {
        type: intl_messageformat_parser.TYPE.select, value: 'testValue', options: {}
      };
      const typesResult = intl_messageformat_parser.isSelectElement(input);
      expect(typesResult).assertTrue();
    });
    it('test_types_isSelectElement_false', 0, () => {
      let input: intl_messageformat_parser.PoundElement = {
        type: intl_messageformat_parser.TYPE.pound
      };
      const typesResult = intl_messageformat_parser.isSelectElement(input);
      expect(typesResult).assertFalse();
    });
    it('test_types_isSelectElement_null', 0, () => {
      let input = null;
      let typesResult: string | boolean = '';
      try {
        typesResult = intl_messageformat_parser.isSelectElement(input);
      } catch (e) {
        typesResult = 'e';
      }
      expect(typesResult == 'e').assertTrue();
    });
    it('test_types_isSelectElement_undefined', 0, () => {
      let input = undefined;
      let typesResult: string | boolean = '';
      try {
        typesResult = intl_messageformat_parser.isSelectElement(input);
      } catch (e) {
        typesResult = 'e';
      }
      expect(typesResult == 'e').assertTrue();
    });

    it('test_types_isPluralElement_true', 0, () => {
      let input: intl_messageformat_parser.PluralElement = {
        type: intl_messageformat_parser.TYPE.plural,
        value: 'testValue',
        options: {},
        offset: 0,
        pluralType: undefined
      };
      const typesResult = intl_messageformat_parser.isPluralElement(input)
      expect(typesResult).assertTrue();
    });
    it('test_types_isPluralElement_false', 0, () => {
      let input: intl_messageformat_parser.PoundElement = {
        type: intl_messageformat_parser.TYPE.pound
      };
      const typesResult = intl_messageformat_parser.isPluralElement(input);
      expect(typesResult).assertFalse();
    });
    it('test_types_isPluralElement_null', 0, () => {
      let input = null;
      let typesResult: string | boolean = '';
      try {
        typesResult = intl_messageformat_parser.isPluralElement(input);
      } catch (e) {
        typesResult = 'e';
      }
      expect(typesResult == 'e').assertTrue();
    });
    it('test_types_isPluralElement_undefined', 0, () => {
      let input = undefined;
      let typesResult: string | boolean = '';
      try {
        typesResult = intl_messageformat_parser.isPluralElement(input);
      } catch (e) {
        typesResult = 'e';
      }
      expect(typesResult == 'e').assertTrue();
    });

    it('test_types_isPoundElement_true', 0, () => {
      let input: intl_messageformat_parser.PoundElement = {
        type: intl_messageformat_parser.TYPE.pound
      };
      const typesResult = intl_messageformat_parser.isPoundElement(input);
      expect(typesResult).assertTrue();
    });
    it('test_types_isPoundElement_false', 0, () => {
      let input: intl_messageformat_parser.LiteralElement = {
        type: intl_messageformat_parser.TYPE.literal, value: 'testValue'
      };
      const typesResult = intl_messageformat_parser.isPoundElement(input);
      expect(typesResult).assertFalse();
    });
    it('test_types_isPoundElement_null', 0, () => {
      let input = null;
      let typesResult: string | boolean = '';
      try {
        typesResult = intl_messageformat_parser.isPoundElement(input);
      } catch (e) {
        typesResult = 'e';
      }
      expect(typesResult == 'e').assertTrue();
    });
    it('test_types_isPoundElement_undefined', 0, () => {
      let input = undefined;
      let typesResult: string | boolean = '';
      try {
        typesResult = intl_messageformat_parser.isPoundElement(input);
      } catch (e) {
        typesResult = 'e';
      }
      expect(typesResult == 'e').assertTrue();
    });

    it('test_types_isTagElement_true', 0, () => {
      let input: intl_messageformat_parser.TagElement = {
        type: intl_messageformat_parser.TYPE.tag, value: 'testValue', children: []
      };
      const typesResult = intl_messageformat_parser.isTagElement(input);
      expect(typesResult).assertTrue();
    });
    it('test_types_isTagElement_false', 0, () => {
      let input: intl_messageformat_parser.PoundElement = {
        type: intl_messageformat_parser.TYPE.pound
      }
      const typesResult = intl_messageformat_parser.isTagElement(input);
      expect(typesResult).assertFalse();
    });
    it('test_types_isTagElement_null', 0, () => {
      let input = null;
      let typesResult: string | boolean = '';
      try {
        typesResult = intl_messageformat_parser.isTagElement(input);
      } catch (e) {
        typesResult = 'e';
      }
      expect(typesResult == 'e').assertTrue();
    });
    it('test_types_isTagElement_undefined', 0, () => {
      let input = undefined;
      let typesResult: string | boolean = '';
      try {
        typesResult = intl_messageformat_parser.isTagElement(input);
      } catch (e) {
        typesResult = 'e';
      }
      expect(typesResult == 'e').assertTrue();
    });

    it('test_types_isNumberSkeleton_true', 0, () => {
      let input: intl_messageformat_parser.NumberSkeleton = {
        type: intl_messageformat_parser.SKELETON_TYPE.number, tokens: []
      };
      const typesResult = intl_messageformat_parser.isNumberSkeleton(input);
      expect(typesResult).assertTrue();
    });
    it('test_types_isNumberSkeleton_false', 0, () => {
      let input: intl_messageformat_parser.DateTimeSkeleton = {
        type: intl_messageformat_parser.SKELETON_TYPE.dateTime, pattern: ''
      };
      const typesResult = intl_messageformat_parser.isNumberSkeleton(input);
      expect(typesResult).assertFalse();
    });
    it('test_types_isNumberSkeleton_null', 0, () => {
      let input = null;
      let typesResult = intl_messageformat_parser.isNumberSkeleton(input);
      expect(typesResult).assertFalse();
    });
    it('test_types_isNumberSkeleton_undefined', 0, () => {
      let input = undefined;
      let typesResult = intl_messageformat_parser.isNumberSkeleton(input);
      expect(typesResult).assertFalse();
    });

    it('test_types_isDateTimeSkeleton_true', 0, () => {
      let input: intl_messageformat_parser.DateTimeSkeleton = {
        type: intl_messageformat_parser.SKELETON_TYPE.dateTime, pattern: ''
      };
      const typesResult = intl_messageformat_parser.isDateTimeSkeleton(input);
      expect(typesResult).assertTrue();
    });
    it('test_types_isDateTimeSkeleton_false', 0, () => {
      let input: intl_messageformat_parser.NumberSkeleton = {
        type: intl_messageformat_parser.SKELETON_TYPE.number, tokens: []
      };
      const typesResult = intl_messageformat_parser.isDateTimeSkeleton(input);
      expect(typesResult).assertFalse();
    });
    it('test_types_isDateTimeSkeleton_null', 0, () => {
      let input = null;
      let typesResult = intl_messageformat_parser.isDateTimeSkeleton(input);
      expect(typesResult).assertFalse();
    });
    it('test_types_isDateTimeSkeleton_undefined', 0, () => {
      let input = undefined;
      let typesResult = intl_messageformat_parser.isDateTimeSkeleton(input);
      expect(typesResult).assertFalse();
    });

    it('test_types_createLiteralElement_string', 0, () => {
      const typesResult: intl_messageformat_parser.LiteralElement = intl_messageformat_parser.createLiteralElement('testValue');
      expect(typesResult.value).assertEqual('testValue');
    });
    it('test_types_createLiteralElement_empty', 0, () => {
      const typesResult: intl_messageformat_parser.LiteralElement = intl_messageformat_parser.createLiteralElement('');
      expect(typesResult.value).assertEqual('');
    });
    it('test_types_createLiteralElement_null', 0, () => {
      const typesResult: intl_messageformat_parser.LiteralElement = intl_messageformat_parser.createLiteralElement(null);
      expect(typesResult.value).assertNull();
    });
    it('test_types_createLiteralElement_undefined', 0, () => {
      const typesResult: intl_messageformat_parser.LiteralElement = intl_messageformat_parser.createLiteralElement(undefined);
      expect(typesResult.value).assertUndefined();
    });

    it('test_types_createNumberElement_string', 0, () => {
      const typesResult: intl_messageformat_parser.NumberElement = intl_messageformat_parser.createNumberElement('testValue');
      expect(typesResult.value).assertEqual('testValue');
    });
    it('test_types_createNumberElement_empty', 0, () => {
      const typesResult: intl_messageformat_parser.NumberElement = intl_messageformat_parser.createNumberElement('');
      expect(typesResult.value).assertEqual('');
    });
    it('test_types_createNumberElement_null', 0, () => {
      const typesResult: intl_messageformat_parser.NumberElement = intl_messageformat_parser.createNumberElement(null);
      expect(typesResult.value).assertNull();
    });
    it('test_types_createNumberElement_undefined', 0, () => {
      const typesResult: intl_messageformat_parser.NumberElement = intl_messageformat_parser.createNumberElement(undefined);
      expect(typesResult.value).assertUndefined();
    });

    it('test_skeleton_parseDateTimeSkeleton_success', 0, () => {
      let input = 'ymd';
      let skeletonResult = intl_messageformat_parser.parseDateTimeSkeleton(input);
      expect(skeletonResult != null).assertTrue();
    });
    it('test_skeleton_parseDateTimeSkeleton_fail', 0, () => {
      let input = 'YMD';
      let skeletonResult: string | intl_messageformat_parser.ExtendedDateTimeFormatOptions = '';
      try {
        skeletonResult = intl_messageformat_parser.parseDateTimeSkeleton(input);
      } catch (e) {
        skeletonResult = 'e';
      }
      expect(skeletonResult == 'e').assertTrue();
    });
    it('test_skeleton_parseDateTimeSkeleton_null', 0, () => {
      let input = null;
      let skeletonResult: string | intl_messageformat_parser.ExtendedDateTimeFormatOptions = '';
      try {
        skeletonResult = intl_messageformat_parser.parseDateTimeSkeleton(input);
      } catch (e) {
        skeletonResult = 'e';
      }
      expect(skeletonResult == 'e').assertTrue();
    });
    it('test_skeleton_parseDateTimeSkeleton_undefined', 0, () => {
      let input = undefined;
      let skeletonResult: string | intl_messageformat_parser.ExtendedDateTimeFormatOptions = '';
      try {
        skeletonResult = intl_messageformat_parser.parseDateTimeSkeleton(input);
      } catch (e) {
        skeletonResult = 'e';
      }
      expect(skeletonResult == 'e').assertTrue();
    });

    it('test_skeleton_convertNumberSkeletonToNumberFormatOptions_percent', 0, () => {
      let skeletonTokens: intl_messageformat_parser.NumberSkeletonToken[] = [{
        stem: 'percent', options: ['testOptions']
      }];
      let skeletonResult = intl_messageformat_parser.convertNumberSkeletonToNumberFormatOptions(skeletonTokens);
      expect(skeletonResult != null).assertTrue();
    });
    it('test_skeleton_convertNumberSkeletonToNumberFormatOptions_currency', 0, () => {
      let skeletonTokens: intl_messageformat_parser.NumberSkeletonToken[] = [{
        stem: 'currency', options: ['testOptions']
      }];
      let skeletonResult = intl_messageformat_parser.convertNumberSkeletonToNumberFormatOptions(skeletonTokens);
      expect(skeletonResult != null).assertTrue();
    });
    it('test_skeleton_convertNumberSkeletonToNumberFormatOptions_null', 0, () => {
      let skeletonTokens = null;
      let skeletonResult: ESObject;
      try {
        skeletonResult = intl_messageformat_parser.convertNumberSkeletonToNumberFormatOptions(skeletonTokens);
      } catch (e) {
        skeletonResult = 'e';
      }
      expect(skeletonResult == 'e').assertTrue();
    });
    it('test_skeleton_convertNumberSkeletonToNumberFormatOptions_undefined', 0, () => {
      let skeletonTokens = undefined;
      let skeletonResult: ESObject;
      try {
        skeletonResult = intl_messageformat_parser.convertNumberSkeletonToNumberFormatOptions(skeletonTokens);
      } catch (e) {
        skeletonResult = 'e';
      }
      expect(skeletonResult == 'e').assertTrue();
    });
  })
}