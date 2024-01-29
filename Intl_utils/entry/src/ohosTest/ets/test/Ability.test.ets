/*
 * MIT License
 *
 * Copyright (C) 2024 Huawei Device Co., Ltd.
 *
 * Permission is hereby granted, free of charge, to any person
 * obtaining a copy of this software and associated documentation
 * files (the "Software"), to deal in the Software without
 * restriction, including without limitation the rights to use,
 * copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the
 * Software is furnished to do so, subject to the following
 * conditions:
 *
 * The above copyright notice and this permission notice shall be
 * included in all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
 * OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
 * HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
 * WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
 * OTHER DEALINGS IN THE SOFTWARE.
 */

import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect } from '@ohos/hypium'
import * as intl_utils from '@f-fjs/intl-utils';

export default function abilityTest() {
  describe('ActsAbilityTest', () => {
    // Defines a test suite. Two parameters are supported: test suite name and test suite function.
    beforeAll(() => {
      // Presets an action, which is performed only once before all test cases of the test suite start.
      // This API supports only one parameter: preset action function.
    })
    beforeEach(() => {
      // Presets an action, which is performed before each unit test case starts.
      // The number of execution times is the same as the number of test cases defined by **it**.
      // This API supports only one parameter: preset action function.
    })
    afterEach(() => {
      // Presets a clear action, which is performed after each unit test case ends.
      // The number of execution times is the same as the number of test cases defined by **it**.
      // This API supports only one parameter: clear action function.
    })
    afterAll(() => {
      // Presets a clear action, which is performed after all test cases of the test suite end.
      // This API supports only one parameter: clear action function.
    })
    it('test_diff_selectUnit_year', 0, () => {
      let diffResult = intl_utils.selectUnit(Date.now(), 0, {});
      expect(diffResult.unit).assertEqual('year');
    });
    it('test_diff_selectUnit_second', 0, () => {
      let diffResult = intl_utils.selectUnit(Date.now(), Date.now(), {});
      expect(diffResult.unit).assertEqual('second');
      expect(diffResult.value).assertEqual(0);
    });
    it('test_diff_selectUnit_null', 0, () => {
      let diffResult = intl_utils.selectUnit(null, null, {});
      expect(diffResult.value).assertEqual(0);
    });
    it('test_diff_selectUnit_undefined', 0, () => {
      let diffResult = intl_utils.selectUnit(undefined, undefined, {});
      expect(diffResult.value).assertNaN()
    });

    it('test_polyfill_utils_defaultNumberOption_success', 0, () => {
      let result = intl_utils.defaultNumberOption(5, 1, 10, 0);
      expect(result).assertEqual(5);
    });
    it('test_polyfill_utils_defaultNumberOption_fail', 0, () => {
      let result: string | number = '';
      try {
        result = intl_utils.defaultNumberOption(0, 1, 10, 0);
      } catch (e) {
        result = 'e';
      }
      expect(result == 'e').assertTrue()
    });
    it('test_polyfill_utils_defaultNumberOption_null', 0, () => {
      let result: string | number = '';
      try {
        result = intl_utils.defaultNumberOption(null, 1, 10, 0);
      } catch (e) {
        result = 'e';
      }
      expect(result == 'e').assertTrue()
    });
    it('test_polyfill_utils_defaultNumberOption_undefined', 0, () => {
      let result = intl_utils.defaultNumberOption(undefined, 1, 10, 0);
      expect(result).assertEqual(0);
    });

    it('test_polyfill_utils_getAliasesByLang_string', 0, () => {
      let result = intl_utils.getAliasesByLang('aa-SAAHO');
      expect(result != null).assertTrue();
    });
    it('test_polyfill_utils_getAliasesByLang_empty', 0, () => {
      let result = intl_utils.getAliasesByLang('');
      expect(result != null).assertTrue();
    });
    it('test_polyfill_utils_getAliasesByLang_null', 0, () => {
      let result = intl_utils.getAliasesByLang(null);
      expect(result != null).assertTrue();
    });
    it('test_polyfill_utils_getAliasesByLang_undefined', 0, () => {
      let result = intl_utils.getAliasesByLang(undefined);
      expect(result != null).assertTrue();
    });

    it('test_polyfill_utils_getInternalSlot_success', 0, () => {
      class PlClass {
        testKey: string = ''
      }

      let pl: PlClass = {
        testKey: 'testValue'
      };
      let map: WeakMap<PlClass, PlClass> = new WeakMap([[pl, pl]]);
      let result = intl_utils.getInternalSlot<PlClass, PlClass, 'testKey'>(map, pl, 'testKey');
      expect(result != null).assertTrue();
    });
    it('test_polyfill_utils_getInternalSlot_empty', 0, () => {
      class PlClass {
        testKey: string = ''
      }

      let pl: PlClass = {
        testKey: ''
      };
      let map: WeakMap<PlClass, PlClass> = new WeakMap([[pl, pl]]);
      let result = intl_utils.getInternalSlot<PlClass, PlClass, 'testKey'>(map, pl, 'testKey');
      expect(result != null).assertTrue();
    });
    it('test_polyfill_utils_getInternalSlot_null', 0, () => {
      class PlClass {
        testKey: string = ''
      }

      let pl: PlClass = {} as PlClass;
      pl.testKey = null as ESObject
      let map: WeakMap<PlClass, PlClass> = new WeakMap([[pl, pl]]);
      let result = intl_utils.getInternalSlot<PlClass, PlClass, 'testKey'>(map, pl, 'testKey');
      expect(result != null).assertFalse();
    });
    it('test_polyfill_utils_getInternalSlot_undefined', 0, () => {
      class PlClass {
        testKey: string = ''
      }

      let pl: PlClass = {} as PlClass;
      pl.testKey = undefined as ESObject
      let map: WeakMap<PlClass, PlClass> = new WeakMap([[pl, pl]]);
      let result = intl_utils.getInternalSlot<PlClass, PlClass, 'testKey'>(map, pl, 'testKey');
      expect(result != null).assertFalse();
    });

    it('test_polyfill_utils_getMultiInternalSlots_success', 0, () => {
      class PlClass {
        testKey: string = ''
      }

      let pl: PlClass = {
        testKey: 'testValue'
      };
      let map: WeakMap<PlClass, PlClass> = new WeakMap([[pl, pl]]);
      let result = intl_utils.getMultiInternalSlots<PlClass, PlClass, 'testKey'>(map, pl, 'testKey');
      expect(result != null).assertTrue();
    });
    it('test_polyfill_utils_getMultiInternalSlots_empty', 0, () => {
      class PlClass {
        testKey: string = ''
      }

      let pl: PlClass = {
        testKey: ''
      };
      let map: WeakMap<PlClass, PlClass> = new WeakMap([[pl, pl]]);
      let result = intl_utils.getMultiInternalSlots<PlClass, PlClass, 'testKey'>(map, pl, 'testKey');
      expect(result != null).assertTrue();
    });
    it('test_polyfill_utils_getMultiInternalSlots_null', 0, () => {
      class PlClass {
        testKey: string = ''
      }

      let pl: PlClass = {} as PlClass
      pl.testKey = null as ESObject
      let map: WeakMap<PlClass, PlClass> = new WeakMap([[pl, pl]]);
      let result = intl_utils.getMultiInternalSlots<PlClass, PlClass, 'testKey'>(map, pl, 'testKey');
      expect(result != null).assertTrue();
    });
    it('test_polyfill_utils_getMultiInternalSlots_undefined', 0, () => {
      class PlClass {
        testKey: string = ''
      }

      let pl: PlClass = {} as PlClass
      pl.testKey = undefined as ESObject
      let map: WeakMap<PlClass, PlClass> = new WeakMap([[pl, pl]]);
      let result = intl_utils.getMultiInternalSlots<PlClass, PlClass, 'testKey'>(map, pl, 'testKey');
      expect(result != null).assertTrue();
    });

    it('test_polyfill_utils_getNumberOption_success', 0, () => {
      class OptionsClass {
        testKey: number = 0
      }

      let options: OptionsClass = {
        testKey: 50
      };
      let minimum: number = 0;
      let maximum: number = 100;
      let fallback: number = 0;
      let result = intl_utils.getNumberOption<OptionsClass, 'testKey'>(options, 'testKey', minimum, maximum, fallback);
      expect(result).assertEqual(50);
    });
    it('test_polyfill_utils_getNumberOption_minRangeError', 0, () => {
      class OptionsClass {
        testKey: number = 0
      }

      let options: OptionsClass = {
        testKey: -1
      };
      let minimum: number = 0;
      let maximum: number = 100;
      let fallback: number = 0;
      let result: string | number = '';
      try {
        result = intl_utils.getNumberOption<OptionsClass, 'testKey'>(options, 'testKey', minimum, maximum, fallback);
      } catch (e) {
        result = 'e';
      }
      expect(result == 'e').assertTrue()
    });
    it('test_polyfill_utils_getNumberOption_maxRangeError', 0, () => {
      class OptionsClass {
        testKey: number = 0
      }

      let options: OptionsClass = {
        testKey: 101
      };
      let minimum: number = 0;
      let maximum: number = 100;
      let fallback: number = 0;
      let result: string | number = '';
      try {
        result = intl_utils.getNumberOption<OptionsClass, 'testKey'>(options, 'testKey', minimum, maximum, fallback);
      } catch (e) {
        result = 'e';
      }
      expect(result == 'e').assertTrue()
    });
    it('test_polyfill_utils_getNumberOption_undefined', 0, () => {
      class OptionsClass {
        testKey: number = 0
      }

      let options: OptionsClass = {} as OptionsClass
      options.testKey = undefined as ESObject
      let minimum: number = 0;
      let maximum: number = 100;
      let fallback: number = 0;
      let result = intl_utils.getNumberOption<OptionsClass, 'testKey'>(options, 'testKey', minimum, maximum, fallback);
      expect(result).assertEqual(fallback);
    });

    it('test_polyfill_utils_getOption_string', 0, () => {
      class OptsClass {
        testKey: string | boolean = ''
      }

      let opts: OptsClass = {
        testKey: 'testValue'
      };
      let values: undefined = undefined;
      let fallback: string = '';
      let result = intl_utils.getOption<OptsClass, 'testKey', string>(opts, 'testKey', 'string', values, fallback);
      expect(result != null).assertTrue();
    });
    it('test_polyfill_utils_getOption_boolean', 0, () => {
      class OptsClass {
        testKey: string | boolean = ''
      }

      let opts: OptsClass = {
        testKey: true
      };
      let values: undefined = undefined;
      let fallback: string = '';
      let result = intl_utils.getOption<OptsClass, 'testKey', string>(opts, 'testKey', 'boolean', values, fallback);
      expect(result != null).assertTrue();
    });
    it('test_polyfill_utils_getOption_null', 0, () => {
      class OptsClass {
        testKey: string | boolean = ''
      }

      let opts: OptsClass = {} as OptsClass
      opts.testKey = null as ESObject

      let values: undefined = undefined;
      let fallback: string = '';
      let result = intl_utils.getOption<OptsClass, 'testKey', string>(opts, 'testKey', 'string', values, fallback);
      expect(result != null).assertTrue();
    });
    it('test_polyfill_utils_getOption_undefined', 0, () => {
      class OptsClass {
        testKey: string | boolean = ''
      }

      let opts: OptsClass = {} as OptsClass
      opts.testKey = undefined as ESObject
      let values: undefined = undefined;
      let fallback: string = '';
      let result = intl_utils.getOption<OptsClass, 'testKey', string>(opts, 'testKey', 'string', values, fallback);
      expect(result != null).assertTrue();
    });

    it('test_polyfill_utils_getParentLocalesByLang_string', 0, () => {
      let result = intl_utils.getParentLocalesByLang('en-150');
      expect(result != null).assertTrue();
    });
    it('test_polyfill_utils_getParentLocalesByLang_empty', 0, () => {
      let result = intl_utils.getParentLocalesByLang('');
      expect(result != null).assertTrue();
    });
    it('test_polyfill_utils_getParentLocalesByLang_null', 0, () => {
      let result = intl_utils.getParentLocalesByLang(null);
      expect(result != null).assertTrue();
    });
    it('test_polyfill_utils_getParentLocalesByLang_undefined', 0, () => {
      let result = intl_utils.getParentLocalesByLang(undefined);
      expect(result != null).assertTrue();
    });

    it('test_polyfill_utils_isLiteralPart_success', 0, () => {
      let patternPart: intl_utils.LiteralPart = {
        type: 'literal', value: 'testValue'
      }
      let result = intl_utils.isLiteralPart(patternPart);
      expect(result).assertTrue();
    });
    it('test_polyfill_utils_isLiteralPart_empty', 0, () => {
      let patternPart: intl_utils.LiteralPart = {} as intl_utils.LiteralPart
      patternPart.type = '' as ESObject
      patternPart.value = 'testValue'
      let result = intl_utils.isLiteralPart(patternPart);
      expect(result).assertFalse();
    });
    it('test_polyfill_utils_isLiteralPart_null', 0, () => {
      let patternPart: intl_utils.LiteralPart = {} as intl_utils.LiteralPart
      patternPart.type = null as ESObject
      patternPart.value = 'testValue'
      let result = intl_utils.isLiteralPart(patternPart);
      expect(result).assertFalse();
    });
    it('test_polyfill_utils_isLiteralPart_undefined', 0, () => {
      let patternPart: intl_utils.LiteralPart = {} as intl_utils.LiteralPart
      patternPart.type = undefined as ESObject
      patternPart.value = 'testValue'
      let result = intl_utils.isLiteralPart(patternPart);
      expect(result).assertFalse();
    });

    it('test_polyfill_utils_partitionPattern_success', 0, () => {
      let pattern: string = '{test}'
      let result = intl_utils.partitionPattern(pattern);
      expect(result.length).assertLarger(0);
    });
    it('test_polyfill_utils_partitionPattern_empty', 0, () => {
      let pattern: string = ''
      let result = intl_utils.partitionPattern(pattern);
      expect(result.length).assertEqual(0);
    });
    it('test_polyfill_utils_partitionPattern_null', 0, () => {
      let pattern: null = null
      let result: string | ESObject = '';
      try {
        result = intl_utils.partitionPattern(pattern);
      } catch (e) {
        result = 'e';
      }
      expect(result == 'e').assertTrue()
    });
    it('test_polyfill_utils_partitionPattern_undefined', 0, () => {
      let pattern: undefined = undefined
      let result: string | ESObject = '';
      try {
        result = intl_utils.partitionPattern(pattern);
      } catch (e) {
        result = 'e';
      }
      expect(result == 'e').assertTrue()
    });

    it('test_polyfill_utils_setInternalSlot_success', 0, () => {
      class PlClass {
        testKey: string = ''
      }

      let pl: PlClass = {
        testKey: 'testValue'
      };
      let map: WeakMap<PlClass, PlClass> = new WeakMap();
      let value: string = 'testValue';
      let result: string = '';
      try {
        intl_utils.setInternalSlot<PlClass, PlClass, 'testKey'>(map, pl, 'testKey', value);
      } catch (e) {
        result = 'e';
      }
      expect(result == 'e').assertFalse();
    });
    it('test_polyfill_utils_setInternalSlot_empty', 0, () => {
      class PlClass {
        testKey: string = ''
      }

      let pl: PlClass = {} as PlClass;
      let map: WeakMap<PlClass, PlClass> = new WeakMap();
      let value: string = '';
      let result: string = '';
      try {
        intl_utils.setInternalSlot<PlClass, PlClass, 'testKey'>(map, pl, 'testKey', value);
      } catch (e) {
        result = 'e';
      }
      expect(result == 'e').assertFalse();
    });
    it('test_polyfill_utils_setInternalSlot_null', 0, () => {
      class PlClass {
        testKey: string = ''
      }

      let pl: null = null;
      let map: WeakMap<PlClass, PlClass> = new WeakMap();
      let value: null = null;
      let result: string = '';
      try {
        intl_utils.setInternalSlot<PlClass, PlClass, 'testKey'>(map, pl, null, value);
      } catch (e) {
        result = 'e';
      }
      expect(result == 'e').assertTrue();
    });
    it('test_polyfill_utils_setInternalSlot_undefined', 0, () => {
      class PlClass {
        testKey: string = ''
      }

      let pl: undefined = undefined;
      let map: WeakMap<PlClass, PlClass> = new WeakMap();
      let value: undefined = undefined;
      let result: string = '';
      try {
        intl_utils.setInternalSlot<PlClass, PlClass, 'testKey'>(map, pl, undefined, value);
      } catch (e) {
        result = 'e';
      }
      expect(result == 'e').assertTrue();
    });

    it('test_polyfill_utils_setMultiInternalSlots_success', 0, () => {
      class PlClass {
        testKey: string = ''
      }

      let pl: PlClass = {
        testKey: 'testValue'
      };
      let map: WeakMap<PlClass, PlClass> = new WeakMap();
      let props: PlClass = {
        testKey: 'testValue'
      };
      let result: string = '';
      try {
        intl_utils.setMultiInternalSlots<PlClass, PlClass, 'testKey'>(map, pl, props);
      } catch (e) {
        result = 'e';
      }
      expect(result == 'e').assertFalse();
    });
    it('test_polyfill_utils_setMultiInternalSlots_empty', 0, () => {
      class PlClass {
        testKey: string = ''
      }

      let pl: PlClass = {} as PlClass;
      let map: WeakMap<PlClass, PlClass> = new WeakMap();
      let props: PlClass = {} as PlClass;
      let result: string = '';
      try {
        intl_utils.setMultiInternalSlots<PlClass, PlClass, 'testKey'>(map, pl, props);
      } catch (e) {
        result = 'e';
      }
      expect(result == 'e').assertFalse();
    });
    it('test_polyfill_utils_setMultiInternalSlots_null', 0, () => {
      class PlClass {
        testKey: string = ''
      }

      let pl: null = null;
      let map: WeakMap<PlClass, PlClass> = new WeakMap();
      let props: null = null;
      let result: string = '';
      try {
        intl_utils.setMultiInternalSlots<PlClass, PlClass, 'testKey'>(map, pl, props);
      } catch (e) {
        result = 'e';
      }
      expect(result == 'e').assertTrue();
    });
    it('test_polyfill_utils_setMultiInternalSlots_undefined', 0, () => {
      class PlClass {
        testKey: string = ''
      }

      let pl: undefined = undefined;
      let map: WeakMap<PlClass, PlClass> = new WeakMap();
      let props: undefined = undefined;
      let result: string = '';
      try {
        intl_utils.setMultiInternalSlots<PlClass, PlClass, 'testKey'>(map, pl, props);
      } catch (e) {
        result = 'e';
      }
      expect(result == 'e').assertTrue();
    });

    it('test_polyfill_utils_setNumberFormatDigitOptions_success', 0, () => {
      interface NullClass {}

      let internalSlotMap: WeakMap<NullClass, intl_utils.NumberFormatDigitInternalSlots> = new WeakMap();
      let intlObj: NullClass = {};
      let opts: intl_utils.NumberFormatDigitOptions = {};
      let mnfdDefault = 0;
      let mxfdDefault = 100;
      let result: string = '';
      try {
        intl_utils.setNumberFormatDigitOptions<Object, intl_utils.NumberFormatDigitInternalSlots>(internalSlotMap, intlObj, opts, mnfdDefault, mxfdDefault);
      } catch (e) {
        result = 'e';
      }
      expect(result == 'e').assertFalse();
    });
    it('test_polyfill_utils_setNumberFormatDigitOptions_internalSlotMapNull', 0, () => {
      interface NullClass {}

      let internalSlotMap: null = null;
      let intlObj: NullClass = {};
      let opts: intl_utils.NumberFormatDigitOptions = {};
      let mnfdDefault = 0;
      let mxfdDefault = 0;
      let result: string = '';
      try {
        intl_utils.setNumberFormatDigitOptions(internalSlotMap, intlObj, opts, mnfdDefault, mxfdDefault);
      } catch (e) {
        result = 'e';
      }
      expect(result == 'e').assertTrue();
    });
    it('test_polyfill_utils_setNumberFormatDigitOptions_intlObjNull', 0, () => {
      interface NullClass {}

      let internalSlotMap: WeakMap<NullClass, intl_utils.NumberFormatDigitInternalSlots> = new WeakMap();
      let intlObj: null = null;
      let opts: intl_utils.NumberFormatDigitOptions = {};
      let mnfdDefault = 0;
      let mxfdDefault = 0;
      let result: string = '';
      try {
        intl_utils.setNumberFormatDigitOptions(internalSlotMap, intlObj, opts, mnfdDefault, mxfdDefault);
      } catch (e) {
        result = 'e';
      }
      expect(result == 'e').assertTrue();
    });
    it('test_polyfill_utils_setNumberFormatDigitOptions_optsNull', 0, () => {
      interface NullClass {}

      let internalSlotMap: WeakMap<NullClass, intl_utils.NumberFormatDigitInternalSlots> = new WeakMap();
      let intlObj: NullClass = {};
      let opts: null = null;
      let mnfdDefault = 0;
      let mxfdDefault = 0;
      let result: string = '';
      try {
        intl_utils.setNumberFormatDigitOptions(internalSlotMap, intlObj, opts, mnfdDefault, mxfdDefault);
      } catch (e) {
        result = 'e';
      }
      expect(result == 'e').assertTrue();
    });

    it('test_polyfill_utils_toObject_success', 0, () => {
      let arg: string = 'testValue';
      let result: string = intl_utils.toObject<string>(arg);
      expect(result != null).assertTrue();
    });
    it('test_polyfill_utils_toObject_empty', 0, () => {
      let arg: string = '';
      let result: string = intl_utils.toObject<string>(arg);
      expect(result != null).assertTrue();
    });
    it('test_polyfill_utils_toObject_null', 0, () => {
      let arg: null = null;
      let result: string = '';
      try {
        result = intl_utils.toObject<string>(arg);
      }
      catch (e) {
        result = 'e';
      }
      expect(result == 'e').assertTrue();
    });
    it('test_polyfill_utils_toObject_undefined', 0, () => {
      let arg: undefined = undefined;
      let result: string = '';
      try {
        result = intl_utils.toObject<string>(arg);
      }
      catch (e) {
        result = 'e';
      }
      expect(result == 'e').assertTrue();
    });

    it('test_polyfill_utils_objectIs_true', 0, () => {
      let x: string = 'testValue';
      let y: string = 'testValue';
      let result = intl_utils.objectIs(x, y);
      expect(result).assertTrue();
    });
    it('test_polyfill_utils_objectIs_false', 0, () => {
      let x: string = 'x';
      let y: string = 'y';
      let result = intl_utils.objectIs(x, y);
      expect(result).assertFalse();
    });
    it('test_polyfill_utils_objectIs_null', 0, () => {
      let x: null = null;
      let y: null = null;
      let result = intl_utils.objectIs(x, y);
      expect(result).assertTrue();
    });
    it('test_polyfill_utils_objectIs_undefined', 0, () => {
      let x: undefined = undefined;
      let y: undefined = undefined;
      let result = intl_utils.objectIs(x, y);
      expect(result).assertTrue();
    });

    it('test_polyfill_utils_isWellFormedCurrencyCode_success', 0, () => {
      let currency: string = 'AAA';
      let result = intl_utils.isWellFormedCurrencyCode(currency);
      expect(result).assertTrue();
    });
    it('test_polyfill_utils_isWellFormedCurrencyCode_empty', 0, () => {
      let currency: string = 'A';
      let result = intl_utils.isWellFormedCurrencyCode(currency);
      expect(result).assertFalse();
    });
    it('test_polyfill_utils_isWellFormedCurrencyCode_null', 0, () => {
      let currency: null = null;
      let result: string | boolean = '';
      try {
        result = intl_utils.isWellFormedCurrencyCode(currency);
      }
      catch (e) {
        result = 'e';
      }
      expect(result == 'e').assertTrue();
    });
    it('test_polyfill_utils_isWellFormedCurrencyCode_undefined', 0, () => {
      let currency: undefined = undefined;
      let result: string | boolean = '';
      try {
        result = intl_utils.isWellFormedCurrencyCode(currency);
      }
      catch (e) {
        result = 'e';
      }
      expect(result == 'e').assertTrue();
    });

    it('test_polyfill_utils_toString_success', 0, () => {
      let o: string = 'testValue';
      let result = intl_utils.toString(o);
      expect(result != null).assertTrue();
    });
    it('test_polyfill_utils_toString_empty', 0, () => {
      let o: string = '';
      let result = intl_utils.toString(o);
      expect(result != null).assertTrue();
    });
    it('test_polyfill_utils_toString_null', 0, () => {
      let o: null = null;
      let result = intl_utils.toString(o);
      expect(result != null).assertTrue();
    });
    it('test_polyfill_utils_toString_undefined', 0, () => {
      let o: undefined = undefined;
      let result = intl_utils.toString(o);
      expect(result != null).assertTrue();
    });

    it('test_resolve_locale_createResolveLocale_success', 0, () => {
      let result = intl_utils.createResolveLocale<string, ESObject>(() => {
        return 'testResult'
      });
      expect(result != null).assertTrue();
    });
    it('test_resolve_locale_createResolveLocale_empty', 0, () => {
      let result = intl_utils.createResolveLocale<string, ESObject>(() => {
        return ''
      });
      expect(result != null).assertTrue();
    });
    it('test_resolve_locale_createResolveLocale_null', 0, () => {
      let result = intl_utils.createResolveLocale<string, ESObject>(null);
      expect(result != null).assertTrue();
    });
    it('test_resolve_locale_createResolveLocale_undefined', 0, () => {
      let result = intl_utils.createResolveLocale<string, ESObject>(undefined);
      expect(result != null).assertTrue();
    });

    it('test_resolve_locale_getLocaleHierarchy_success', 0, () => {
      let locale: string = 'testValue';
      let aliases: Record<string, string> = {
        'testKey': 'testValue'
      };
      let parentLocales: Record<string, string> = {
        'testKey': 'testValue'
      };
      let result = intl_utils.getLocaleHierarchy(locale, aliases, parentLocales);
      expect(result.length).assertLarger(0);
    });
    it('test_resolve_locale_getLocaleHierarchy_empty', 0, () => {
      let locale: string = '';
      let aliases: Record<string, string> = {};
      let parentLocales: Record<string, string> = {};
      let result = intl_utils.getLocaleHierarchy(locale, aliases, parentLocales);
      expect(result.length).assertLarger(0);
    });
    it('test_resolve_locale_getLocaleHierarchy_null', 0, () => {
      let locale: null = null;
      let aliases: null = null;
      let parentLocales: null = null;
      let result: string | string[] = '';
      try {
        result = intl_utils.getLocaleHierarchy(locale, aliases, parentLocales);
      }
      catch (e) {
        result = 'e';
      }
      expect(result == 'e').assertTrue();
    });
    it('test_resolve_locale_getLocaleHierarchy_undefined', 0, () => {
      let locale: undefined = undefined;
      let aliases: undefined = undefined;
      let parentLocales: undefined = undefined;
      let result: string | string[] = '';
      try {
        result = intl_utils.getLocaleHierarchy(locale, aliases, parentLocales);
      }
      catch (e) {
        result = 'e';
      }
      expect(result == 'e').assertTrue();
    });

    it('test_resolve_locale_supportedLocales_success', 0, () => {
      let availableLocales: string[] = ['testValue'];
      let requestedLocales: string[] = ['testValue'];
      let result = intl_utils.supportedLocales(availableLocales, requestedLocales);
      expect(result.length).assertLarger(0);
    });
    it('test_resolve_locale_supportedLocales_empty', 0, () => {
      let availableLocales: string[] = [];
      let requestedLocales: string[] = [];
      let result = intl_utils.supportedLocales(availableLocales, requestedLocales);
      expect(result.length).assertEqual(0);
    });
    it('test_resolve_locale_supportedLocales_null', 0, () => {
      let availableLocales: null = null;
      let requestedLocales: null = null;
      let result: string | string[] = '';
      try {
        result = intl_utils.supportedLocales(availableLocales, requestedLocales);
      }
      catch (e) {
        result = 'e';
      }
      expect(result == 'e').assertTrue();
    });
    it('test_resolve_locale_supportedLocales_undefined', 0, () => {
      let availableLocales: undefined = undefined;
      let requestedLocales: undefined = undefined;
      let result: string | string[] = '';
      try {
        result = intl_utils.supportedLocales(availableLocales, requestedLocales);
      }
      catch (e) {
        result = 'e';
      }
      expect(result == 'e').assertTrue();
    });

    it('test_resolve_locale_unpackData_success', 0, () => {
      class LocaleDataClass {
        data: Record<string, string> = {};
        aliases: Record<string, string> = {};
        availableLocales: string[] = [];
        parentLocales: Record<string, string> = {};
      }

      let childObj: Record<string, string> = {} as Record<string, string>
      childObj.zh = 'testValue'

      let locale: string = 'zh';
      let localeData: LocaleDataClass = {
        data: childObj, aliases: childObj, availableLocales: ['testValue'], parentLocales: childObj
      };

      class ReducerClass {
        all: string = '';
        d: string = '';
      }

      let reducer: (all: string, d: string) => ReducerClass = (all: string, d: string) => {
        return {
          all, d
        }
      };
      let result: string | ESObject = intl_utils.unpackData<ESObject>(locale, localeData, reducer);
      expect(result != null).assertTrue();
    });
    it('test_resolve_locale_unpackData_fail', 0, () => {
      class LocaleDataClass {
        data: Record<string, string> = {};
        aliases: Record<string, string> = {};
        availableLocales: string[] = [];
        parentLocales: Record<string, string> = {};
      }

      let childObj: Record<string, string> = {} as Record<string, string>
      childObj.zh = 'testValue'

      let locale: string = 'testKey';
      let localeData: LocaleDataClass = {
        data: childObj, aliases: childObj, availableLocales: ['testValue'], parentLocales: childObj
      };

      class ReducerClass {
        all: string = '';
        d: string = '';
      }

      let reducer: (all: string, d: string) => ReducerClass = (all: string, d: string) => {
        return {
          all, d
        }
      };
      let result: string | ESObject = '';
      try {
        result = intl_utils.unpackData<ESObject>(locale, localeData, reducer);
      } catch (e) {
        result = 'e';
      }
      expect(result == 'e').assertTrue();
    });
    it('test_resolve_locale_unpackData_null', 0, () => {
      let locale: null = null;
      let localeData: null = null;
      let reducer: null = null;
      let result: string | ESObject = '';
      try {
        result = intl_utils.unpackData<ESObject>(locale, localeData, reducer);
      } catch (e) {
        result = 'e';
      }
      expect(result == 'e').assertTrue();
    });
    it('test_resolve_locale_unpackData_undefined', 0, () => {
      let locale: undefined = undefined;
      let localeData: undefined = undefined;
      let reducer: undefined = undefined;
      let result: string | ESObject = '';
      try {
        result = intl_utils.unpackData<ESObject>(locale, localeData, reducer);
      } catch (e) {
        result = 'e';
      }
      expect(result == 'e').assertTrue();
    });

    it('test_resolve_locale_isMissingLocaleDataError_true', 0, () => {
      class EClass implements Error {
        name: string = '';
        message: string = '';
        type: string = '';
      }

      let e: EClass = {
        name: 'testName', message: 'testMessage', type: 'MISSING_LOCALE_DATA'
      };
      let result = intl_utils.isMissingLocaleDataError(e);
      expect(result).assertTrue();
    });
    it('test_resolve_locale_isMissingLocaleDataError_empty', 0, () => {
      class EClass implements Error {
        name: string = '';
        message: string = '';
      }

      let e: EClass = {
        name: 'testName', message: 'testMessage'
      };
      let result = intl_utils.isMissingLocaleDataError(e);
      expect(result).assertFalse();
    });
    it('test_resolve_locale_isMissingLocaleDataError_null', 0, () => {
      let e: null = null;
      let result: string | ESObject = '';
      try {
        result = intl_utils.isMissingLocaleDataError(e);
      } catch (e) {
        result = 'e';
      }
      expect(result == 'e').assertTrue();
    });
    it('test_resolve_locale_isMissingLocaleDataError_undefined', 0, () => {
      let e: undefined = undefined;
      let result: string | ESObject = '';
      try {
        result = intl_utils.isMissingLocaleDataError(e);
      } catch (e) {
        result = 'e';
      }
      expect(result == 'e').assertTrue();
    });

    it('test_units_removeUnitNamespace_success', 0, () => {
      let unit: string = 'digital-bit';
      let result = intl_utils.removeUnitNamespace(unit);
      expect(result).assertEqual('bit');
    });
    it('test_units_removeUnitNamespace_empty', 0, () => {
      let unit: string = '';
      let result = intl_utils.removeUnitNamespace(unit);
      expect(result).assertEqual('');
    });
    it('test_units_removeUnitNamespace_null', 0, () => {
      let unit: null = null;
      let result: string = '';
      try {
        result = intl_utils.removeUnitNamespace(unit);
      } catch (e) {
        result = 'e';
      }
      expect(result == 'e').assertTrue();
    });
    it('test_units_removeUnitNamespace_undefined', 0, () => {
      let unit: undefined = undefined;
      let result: string = '';
      try {
        result = intl_utils.removeUnitNamespace(unit);
      } catch (e) {
        result = 'e';
      }
      expect(result == 'e').assertTrue();
    });

    it('test_get_canonical_locales_getCanonicalLocales_success', 0, () => {
      let result = intl_utils.getCanonicalLocales();
      expect(result != null).assertTrue();
    });
    it('test_get_canonical_locales_getCanonicalLocales_empty', 0, () => {
      let locales: string[] = [];
      let result = intl_utils.getCanonicalLocales(locales);
      expect(result != null).assertTrue();
    });
    it('test_get_canonical_locales_getCanonicalLocales_null', 0, () => {
      let locales: null = null;
      let result: string | string[] = '';
      try {
        result = intl_utils.getCanonicalLocales(locales);
      } catch (e) {
        result = 'e';
      }
      expect(result == 'e').assertTrue();
    });
    it('test_get_canonical_locales_getCanonicalLocales_undefined', 0, () => {
      let locales: undefined = undefined;
      let result = intl_utils.getCanonicalLocales(locales);
      expect(result != null).assertTrue();
    });

    it('test_invariant_invariant_true', 0, () => {
      let condition: boolean = true;
      let message: string = 'testMessage';
      let Err: Object = Error;
      let result: string = '';
      try {
        intl_utils.invariant(condition, message, Err);
      } catch (e) {
        result = 'e';
      }
      expect(result == 'e').assertFalse();
    });
    it('test_invariant_invariant_false', 0, () => {
      let condition: boolean = false;
      let message: string = 'testMessage';
      let Err: Object = Error;
      let result: string = '';
      try {
        intl_utils.invariant(condition, message, Err);
      } catch (e) {
        result = 'e';
      }
      expect(result == 'e').assertTrue();
    });
    it('test_invariant_invariant_null', 0, () => {
      let condition: null = null;
      let message: null = null;
      let Err: null = null;
      let result: string = '';
      try {
        intl_utils.invariant(condition, message, Err);
      } catch (e) {
        result = 'e';
      }
      expect(result == 'e').assertTrue();
    });
    it('test_invariant_invariant_undefined', 0, () => {
      let condition: undefined = undefined;
      let message: undefined = undefined;
      let Err: undefined = undefined;
      let result: string = '';
      try {
        intl_utils.invariant(condition, message, Err);
      } catch (e) {
        result = 'e';
      }
      expect(result == 'e').assertTrue();
    });
  })
}