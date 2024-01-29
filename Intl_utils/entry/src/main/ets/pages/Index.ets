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


import * as intl_utils from '@f-fjs/intl-utils';
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
        Button('selectUnit测试').fontSize(24).onClick(() => {
          let diffResult = intl_utils.selectUnit(Date.now(), 0, {});
          console.debug('lzdebug diffResult:'+JSON.stringify(diffResult))
          if (diffResult.unit == 'year') {
            setData('测试成功', this.dialogController)
          }
        })
        Button('defaultNumberOption测试').fontSize(24).onClick(() => {
          let result = intl_utils.defaultNumberOption(5, 1, 10, 0);
          if (result == 5) {
            setData('测试成功', this.dialogController)
          }
        })
        Button('getAliasesByLang测试').fontSize(24).onClick(() => {
          let result = intl_utils.getAliasesByLang('aa-SAAHO');
          if (result != null) {
            setData('测试成功', this.dialogController)
          }
        })
        Button('getInternalSlot测试').fontSize(24).onClick(() => {
          class PlClass {
            testKey: string = ''
          }

          let pl: PlClass = {
            testKey: 'testValue'
          };
          let map: WeakMap<PlClass, PlClass> = new WeakMap([[pl, pl]]);
          let result = intl_utils.getInternalSlot<PlClass, PlClass, 'testKey'>(map, pl, 'testKey');
          if (result != null) {
            setData('测试成功', this.dialogController)
          }
        })
        Button('getMultiInternalSlots测试').fontSize(24).onClick(() => {
          class PlClass {
            testKey: string = ''
          }

          let pl: PlClass = {
            testKey: 'testValue'
          };
          let map: WeakMap<PlClass, PlClass> = new WeakMap([[pl, pl]]);
          let result = intl_utils.getMultiInternalSlots<PlClass, PlClass, 'testKey'>(map, pl, 'testKey');
          if (result != null) {
            setData('测试成功', this.dialogController)
          }
        })
        Button('getNumberOption测试').fontSize(24).onClick(() => {
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
          if (result == 50) {
            setData('测试成功', this.dialogController)
          }
        })
        Button('getOption测试').fontSize(24).onClick(() => {
          class OptsClass {
            testKey: string = ''
          }

          let opts: OptsClass = {
            testKey: 'testValue'
          };
          let values: undefined = undefined;
          let fallback: string = '';
          let result: string = intl_utils.getOption<OptsClass, 'testKey', string>(opts, 'testKey', 'string', values, fallback);
          if (result != null) {
            setData('测试成功', this.dialogController)
          }
        })
        Button('getParentLocalesByLang测试').fontSize(24).onClick(() => {
          let result = intl_utils.getParentLocalesByLang('en-150');
          if (result != null) {
            setData('测试成功', this.dialogController)
          }
        })
        Button('isLiteralPart测试').fontSize(24).onClick(() => {
          let patternPart: intl_utils.LiteralPart = {
            type: 'literal', value: 'testValue'
          }
          let result = intl_utils.isLiteralPart(patternPart);
          if (result) {
            setData('测试成功', this.dialogController)
          }
        })
        Button('partitionPattern测试').fontSize(24).onClick(() => {
          let pattern = '{test}'
          let result = intl_utils.partitionPattern(pattern);
          if (result.length >= 0) {
            setData('测试成功', this.dialogController)
          }
        })
        Button('setInternalSlot测试').fontSize(24).onClick(() => {
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
          if (result != 'e') {
            setData('测试成功', this.dialogController)
          }
        })
        Button('setMultiInternalSlots测试').fontSize(24).onClick(() => {
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
          if (result != 'e') {
            setData('测试成功', this.dialogController)
          }
        })
        Button('setNumberFormatDigitOptions测试').fontSize(24).onClick(() => {
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
          if (result != 'e') {
            setData('测试成功', this.dialogController)
          }
        })
        Button('toObject测试').fontSize(24).onClick(() => {
          let arg = 'testValue';
          let result = intl_utils.toObject(arg);
          if (result != null) {
            setData('测试成功', this.dialogController)
          }
        })
        Button('objectIs测试').fontSize(24).onClick(() => {
          let x: string = 'testValue';
          let y: string = 'testValue';
          let result = intl_utils.objectIs(x, y);
          if (result) {
            setData('测试成功', this.dialogController)
          }
        })
        Button('isWellFormedCurrencyCode测试').fontSize(24).onClick(() => {
          let currency = 'AAA';
          let result = intl_utils.isWellFormedCurrencyCode(currency);
          if (result) {
            setData('测试成功', this.dialogController)
          }
        })
        Button('toString测试').fontSize(24).onClick(() => {
          let o = 'testValue';
          let result = intl_utils.toString(o);
          if (result != null) {
            setData('测试成功', this.dialogController)
          }
        })
        Button('createResolveLocale测试').fontSize(24).onClick(() => {
          let result = intl_utils.createResolveLocale<string, Object>(() => {
            return 'testResult'
          });
          if (result != null) {
            setData('测试成功', this.dialogController)
          }
        })
        Button('getLocaleHierarchy测试').fontSize(24).onClick(() => {
          let locale: string = 'testValue';
          let aliases: Record<string, string> = {
            'testKey': 'testValue'
          };
          let parentLocales: Record<string, string> = {
            'testKey': 'testValue'
          };
          let result = intl_utils.getLocaleHierarchy(locale, aliases, parentLocales);
          if (result.length > 0) {
            setData('测试成功', this.dialogController)
          }
        })
        Button('supportedLocales测试').fontSize(24).onClick(() => {
          let availableLocales: string[] = ['testValue'];
          let requestedLocales: string[] = ['testValue'];
          let result = intl_utils.supportedLocales(availableLocales, requestedLocales);
          if (result.length > 0) {
            setData('测试成功', this.dialogController)
          }
        })
        Button('unpackData测试').fontSize(24).onClick(() => {
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
          let result: ESObject = intl_utils.unpackData<ESObject>(locale, localeData, reducer);
          if (result != null) {
            setData('测试成功', this.dialogController)
          }
        })
        Button('isMissingLocaleDataError测试').fontSize(24).onClick(() => {
          class EClass implements Error {
            name: string = '';
            message: string = '';
            type: string = '';
          }

          let e: EClass = {
            name: 'testName', message: 'testMessage', type: 'MISSING_LOCALE_DATA'
          };
          let result = intl_utils.isMissingLocaleDataError(e);
          if (result) {
            setData('测试成功', this.dialogController)
          }
        })
        Button('removeUnitNamespace测试').fontSize(24).onClick(() => {
          let unit = 'digital-bit';
          let result = intl_utils.removeUnitNamespace(unit);
          if (result == 'bit') {
            setData('测试成功', this.dialogController)
          }
        })
        Button('getCanonicalLocales测试').fontSize(24).onClick(() => {
          let result = intl_utils.getCanonicalLocales();
          if (result != null) {
            setData('测试成功', this.dialogController)
          }
        })
        Button('invariant测试').fontSize(24).onClick(() => {
          let condition: boolean = true;
          let message: string = 'testMessage';
          let Err: Object = Error;
          let result: string = '';
          try {
            intl_utils.invariant(condition, message, Err);
          } catch (e) {
            result = 'e';
          }
          if (result != 'e') {
            setData('测试成功', this.dialogController)
          }
        })
      }
      .width('100%')
    }
    .scrollable(ScrollDirection.Vertical)
  }
}