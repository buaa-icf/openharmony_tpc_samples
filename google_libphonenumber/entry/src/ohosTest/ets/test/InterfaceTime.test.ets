/*
 * Copyright (C) 2024 Huawei Device Co., Ltd.
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

import {
  NumberFormat,
  PhoneNumberFormat,
  AsYouTypeFormatter,
  PhoneNumberDesc,
  ShortNumberInfo,
  PhoneNumberUtil,
  PhoneNumberType,
  PhoneNumber,
  PhoneMetadata,
  CountryCodeSource
} from 'google-libphonenumber';
import { describe, it, expect, TestType } from '@ohos/hypium'


export default function InterfaceTime() {

  describe('interfaceTime', ()=> {

    const BASE_COUNT = 3000
    const BASELINE_CREATEHTTP = 3000
    let phoneUtil: PhoneNumberUtil = PhoneNumberUtil.getInstance();
    let formatter: AsYouTypeFormatter = new AsYouTypeFormatter('BY');
    let itPhone: PhoneNumber = phoneUtil.parse('+390612345678', 'IT');
    let shortNumberInfo: ShortNumberInfo = ShortNumberInfo.getInstance();
    let shortInfoPhone: PhoneNumber = phoneUtil.parse('12345', 'FR');
    let asYouType: AsYouTypeFormatter = new AsYouTypeFormatter('US');
    let format: PhoneNumberFormat = phoneUtil.format(itPhone, PhoneNumberFormat.NATIONAL);

    it('regionCodeForNumber', TestType.PERFORMANCE, async (done: Function) => {
      let startTime = new Date().getTime()
      for (let index = 0; index < BASE_COUNT; index++) {
         phoneUtil.getRegionCodeForNumber(itPhone);
      }
      let endTime = new Date().getTime()
      console.log("RegionCodeForNumber endTime:" + endTime);
      let averageTime = ((endTime - startTime) * 1000) / BASE_COUNT
      console.log("RegionCodeForNumber averageTime:" + averageTime + "μs");
      expect(averageTime < BASELINE_CREATEHTTP).assertTrue();
      done();
    });

    it('getNumberType', TestType.PERFORMANCE, async (done: Function) => {
      let startTime = new Date().getTime()
      for (let index = 0; index < BASE_COUNT; index++) {
         phoneUtil.getNumberType(itPhone);
      }
      let endTime = new Date().getTime()
      console.log("getNumberType endTime:" + endTime);
      let averageTime = ((endTime - startTime) * 1000) / BASE_COUNT
      console.log("getNumberType averageTime:" + averageTime + "μs");
      expect(averageTime < BASELINE_CREATEHTTP).assertTrue();
      done();
    });

    it('parseAndKeepRawInput', TestType.PERFORMANCE, async (done: Function) => {
      let startTime = new Date().getTime()
      for (let index = 0; index < BASE_COUNT; index++) {
        phoneUtil.parseAndKeepRawInput('202-456-1414', 'US');
      }
      let endTime = new Date().getTime()
      console.log("parseAndKeepRawInput endTime:" + endTime);
      let averageTime = ((endTime - startTime) * 1000) / BASE_COUNT
      console.log("parseAndKeepRawInput averageTime:" + averageTime + "μs");
      expect(averageTime < BASELINE_CREATEHTTP).assertTrue();
      done();
    });

    it('format', TestType.PERFORMANCE, async (done: Function) => {
      let startTime = new Date().getTime()
      for (let index = 0; index < BASE_COUNT; index++) {
        phoneUtil.format(itPhone, PhoneNumberFormat.RFC3966)
      }
      let endTime = new Date().getTime()
      console.log("format endTime:" + endTime);
      let averageTime = ((endTime - startTime) * 1000) / BASE_COUNT
      console.log("format averageTime:" + averageTime + "μs");
      expect(averageTime < BASELINE_CREATEHTTP).assertTrue();
      done();
    });

    it('isPossibleNumber', TestType.PERFORMANCE, async (done: Function) => {
      let startTime = new Date().getTime()
      for (let index = 0; index < BASE_COUNT; index++) {
        phoneUtil.isPossibleNumber(itPhone);
      }
      let endTime = new Date().getTime()
      console.log("isPossibleNumber endTime:" + endTime);
      let averageTime = ((endTime - startTime) * 1000) / BASE_COUNT
      console.log("isPossibleNumber averageTime:" + averageTime + "μs");
      expect(averageTime < BASELINE_CREATEHTTP).assertTrue();
      done();
    });

    it('inputDigit', TestType.PERFORMANCE, async (done: Function) => {
      let startTime = new Date().getTime()
      for (let index = 0; index < BASE_COUNT; index++) {
        formatter.inputDigit('8');
      }
      let endTime = new Date().getTime()
      console.log("inputDigit endTime:" + endTime);
      let averageTime = ((endTime - startTime) * 1000) / BASE_COUNT
      console.log("inputDigit averageTime:" + averageTime + "μs");
      expect(averageTime < BASELINE_CREATEHTTP).assertTrue();
      done();
    });

    it('formatter_inputDigitAndRememberPosition', TestType.PERFORMANCE, async (done: Function) => {
      let startTime = new Date().getTime()
      for (let index = 0; index < BASE_COUNT; index++) {
        formatter.inputDigitAndRememberPosition('7');
      }
      let endTime = new Date().getTime()
      console.log("formatter_inputDigitAndRememberPosition endTime:" + endTime);
      let averageTime = ((endTime - startTime) * 1000) / BASE_COUNT
      console.log("formatter_inputDigitAndRememberPosition averageTime:" + averageTime + "μs");
      expect(averageTime < BASELINE_CREATEHTTP).assertTrue();
      done();
    });

    it('formatter_getRememberedPosition', TestType.PERFORMANCE, async (done: Function) => {
      let startTime = new Date().getTime()
      for (let index = 0; index < BASE_COUNT; index++) {
        formatter.getRememberedPosition();
      }
      let endTime = new Date().getTime()
      console.log("formatter_getRememberedPosition endTime:" + endTime);
      let averageTime = ((endTime - startTime) * 1000) / BASE_COUNT
      console.log("formatter_getRememberedPosition averageTime:" + averageTime + "μs");
      expect(averageTime < BASELINE_CREATEHTTP).assertTrue();
      done();
    });

    it('isValidNumber', TestType.PERFORMANCE, async (done: Function) => {
      let startTime = new Date().getTime()
      for (let index = 0; index < BASE_COUNT; index++) {
        phoneUtil.isValidNumber(itPhone);
      }
      let endTime = new Date().getTime()
      console.log("isValidNumber endTime:" + endTime);
      let averageTime = ((endTime - startTime) * 1000) / BASE_COUNT
      console.log("isValidNumber averageTime:" + averageTime + "μs");
      expect(averageTime < BASELINE_CREATEHTTP).assertTrue();
      done();
    });

    it('createExtnPattern_', TestType.PERFORMANCE, async (done: Function) => {
      let startTime = new Date().getTime()
      for (let index = 0; index < BASE_COUNT; index++) {
        PhoneNumberUtil.createExtnPattern_();
      }
      let endTime = new Date().getTime()
      console.log("createExtnPattern_ endTime:" + endTime);
      let averageTime = ((endTime - startTime) * 1000) / BASE_COUNT
      console.log("createExtnPattern_ averageTime:" + averageTime + "μs");
      expect(averageTime < BASELINE_CREATEHTTP).assertTrue();
      done();
    });

    it('isViablePhoneNumber', TestType.PERFORMANCE, async (done: Function) => {
      let startTime = new Date().getTime()
      for (let index = 0; index < BASE_COUNT; index++) {
        PhoneNumberUtil.isViablePhoneNumber('12345');
      }
      let endTime = new Date().getTime()
      console.log("isViablePhoneNumber endTime:" + endTime);
      let averageTime = ((endTime - startTime) * 1000) / BASE_COUNT
      console.log("isViablePhoneNumber averageTime:" + averageTime + "μs");
      expect(averageTime < BASELINE_CREATEHTTP).assertTrue();
      done();
    });

    it('normalize', TestType.PERFORMANCE, async (done: Function) => {
      let startTime = new Date().getTime()
      for (let index = 0; index < BASE_COUNT; index++) {
        PhoneNumberUtil.normalize('+12345');
      }
      let endTime = new Date().getTime()
      console.log("normalize endTime:" + endTime);
      let averageTime = ((endTime - startTime) * 1000) / BASE_COUNT
      console.log("normalize averageTime:" + averageTime + "μs");
      expect(averageTime < BASELINE_CREATEHTTP).assertTrue();
      done();
    });

    it('normalizeDigitsOnly', TestType.PERFORMANCE, async (done: Function) => {
      let startTime = new Date().getTime()
      for (let index = 0; index < BASE_COUNT; index++) {
        PhoneNumberUtil.normalizeDigitsOnly('+12345');
      }
      let endTime = new Date().getTime()
      console.log("normalizeDigitsOnly endTime:" + endTime);
      let averageTime = ((endTime - startTime) * 1000) / BASE_COUNT
      console.log("normalizeDigitsOnly averageTime:" + averageTime + "μs");
      expect(averageTime < BASELINE_CREATEHTTP).assertTrue();
      done();
    });

    it('getCountryMobileToken', TestType.PERFORMANCE, async (done: Function) => {
      let startTime = new Date().getTime()
      for (let index = 0; index < BASE_COUNT; index++) {
        PhoneNumberUtil.getCountryMobileToken(54);
      }
      let endTime = new Date().getTime()
      console.log("getCountryMobileToken endTime:" + endTime);
      let averageTime = ((endTime - startTime) * 1000) / BASE_COUNT
      console.log("getCountryMobileToken averageTime:" + averageTime + "μs");
      expect(averageTime < BASELINE_CREATEHTTP).assertTrue();
      done();
    });

    it('getSupportedGlobalNetworkCallingCodes', TestType.PERFORMANCE, async (done: Function) => {
      let startTime = new Date().getTime()
      for (let index = 0; index < BASE_COUNT; index++) {
        phoneUtil.getSupportedGlobalNetworkCallingCodes();
      }
      let endTime = new Date().getTime()
      console.log("getSupportedGlobalNetworkCallingCodes endTime:" + endTime);
      let averageTime = ((endTime - startTime) * 1000) / BASE_COUNT
      console.log("getSupportedGlobalNetworkCallingCodes averageTime:" + averageTime + "μs");
      expect(averageTime < BASELINE_CREATEHTTP).assertTrue();
      done();
    });

    it('normalizeHelper_', TestType.PERFORMANCE, async (done: Function) => {
      let startTime = new Date().getTime();
      let normalizationReplacements: ESObject = {
        ' ': '', // 移除空格
        '(': '', // 移除左括号
        ')': '', // 移除右括号
        '-': ''  // 移除破折号
      };
      for (let index = 0; index < BASE_COUNT; index++) {
         PhoneNumberUtil.normalizeHelper_('+1 (202) 555-0101', normalizationReplacements, false);
      }
      let endTime = new Date().getTime();
      console.log("normalizeHelper_ endTime:" + endTime);
      let averageTime = ((endTime - startTime) * 1000) / BASE_COUNT
      console.log("normalizeHelper_ averageTime:" + averageTime + "μs");
      expect(averageTime < BASELINE_CREATEHTTP).assertTrue();
      done();
    });

    it('isNumberGeographical', TestType.PERFORMANCE, async (done: Function) => {
      let startTime = new Date().getTime();
      for (let index = 0; index < BASE_COUNT; index++) {
         phoneUtil.isNumberGeographical(itPhone);
      }
      let endTime = new Date().getTime();
      console.log("isNumberGeographical endTime:" + endTime);
      let averageTime = ((endTime - startTime) * 1000) / BASE_COUNT
      console.log("isNumberGeographical averageTime:" + averageTime + "μs");
      expect(averageTime < BASELINE_CREATEHTTP).assertTrue();
      done();
    });

    it('hasValidCountryCallingCode_', TestType.PERFORMANCE, async (done: Function) => {
      let startTime = new Date().getTime();
      for (let index = 0; index < BASE_COUNT; index++) {
        phoneUtil.hasValidCountryCallingCode_(86);
      }
      let endTime = new Date().getTime();
      console.log("hasValidCountryCallingCode_ endTime:" + endTime);
      let averageTime = ((endTime - startTime) * 1000) / BASE_COUNT
      console.log("hasValidCountryCallingCode_ averageTime:" + averageTime + "μs");
      expect(averageTime < BASELINE_CREATEHTTP).assertTrue();
      done();
    });

    it('formatNationalNumberWithCarrierCode', TestType.PERFORMANCE, async (done: Function) => {
      let startTime = new Date().getTime();
      for (let index = 0; index < BASE_COUNT; index++) {
        phoneUtil.formatNationalNumberWithCarrierCode(itPhone, 'US');
      }
      let endTime = new Date().getTime();
      console.log("formatNationalNumberWithCarrierCode endTime:" + endTime);
      let averageTime = ((endTime - startTime) * 1000) / BASE_COUNT
      console.log("formatNationalNumberWithCarrierCode averageTime:" + averageTime + "μs");
      expect(averageTime < BASELINE_CREATEHTTP).assertTrue();
      done();
    });

    it('formatNationalNumberWithPreferredCarrierCode', TestType.PERFORMANCE, async (done: Function) => {
      let startTime = new Date().getTime();
      for (let index = 0; index < BASE_COUNT; index++) {
        phoneUtil.formatNationalNumberWithPreferredCarrierCode(itPhone, 'US');
      }
      let endTime = new Date().getTime();
      console.log("formatNationalNumberWithPreferredCarrierCode endTime:" + endTime);
      let averageTime = ((endTime - startTime) * 1000) / BASE_COUNT
      console.log("formatNationalNumberWithPreferredCarrierCode averageTime:" + averageTime + "μs");
      expect(averageTime < BASELINE_CREATEHTTP).assertTrue();
      done();
    });

    it('formatNumberForMobileDialing', TestType.PERFORMANCE, async (done: Function) => {
      let startTime = new Date().getTime();
      for (let index = 0; index < BASE_COUNT; index++) {
        phoneUtil.formatNumberForMobileDialing(itPhone, 'US', true);
      }
      let endTime = new Date().getTime();
      console.log("formatNumberForMobileDialing endTime:" + endTime);
      let averageTime = ((endTime - startTime) * 1000) / BASE_COUNT
      console.log("formatNumberForMobileDialing averageTime:" + averageTime + "μs");
      expect(averageTime < BASELINE_CREATEHTTP).assertTrue();
      done();
    });

    it('normalizeDiallableCharsOnly', TestType.PERFORMANCE, async (done: Function) => {
      let startTime = new Date().getTime();
      for (let index = 0; index < BASE_COUNT; index++) {
         PhoneNumberUtil.normalizeDiallableCharsOnly("+123456");
      }
      let endTime = new Date().getTime();
      console.log("normalizeDiallableCharsOnly endTime:" + endTime);
      let averageTime = ((endTime - startTime) * 1000) / BASE_COUNT
      console.log("normalizeDiallableCharsOnly averageTime:" + averageTime + "μs");
      expect(averageTime < BASELINE_CREATEHTTP).assertTrue();
      done();
    });

    it('isNationalNumberSuffixOfTheOther_', TestType.PERFORMANCE, async (done: Function) => {
      let startTime = new Date().getTime();
      let firstNumber: PhoneNumber = phoneUtil.parse('+8612345678', 'CN');
      let secondNumber: PhoneNumber = phoneUtil.parse('+861234567890', 'CN');
      for (let index = 0; index < BASE_COUNT; index++) {
        phoneUtil.isNationalNumberSuffixOfTheOther_(firstNumber, secondNumber)
      }
      let endTime = new Date().getTime();
      console.log("isNationalNumberSuffixOfTheOther_ endTime:" + endTime);
      let averageTime = ((endTime - startTime) * 1000) / BASE_COUNT
      console.log("isNationalNumberSuffixOfTheOther_ averageTime:" + averageTime + "μs");
      expect(averageTime < BASELINE_CREATEHTTP).assertTrue();
      done();
    });

    it('connectsToEmergencyNumber', TestType.PERFORMANCE, async (done: Function) => {
      let startTime = new Date().getTime();
      for (let index = 0; index < BASE_COUNT; index++) {
        shortNumberInfo.connectsToEmergencyNumber('911', 'US');
      }
      let endTime = new Date().getTime();
      console.log("connectsToEmergencyNumber endTime:" + endTime);
      let averageTime = ((endTime - startTime) * 1000) / BASE_COUNT
      console.log("connectsToEmergencyNumber averageTime:" + averageTime + "μs");
      expect(averageTime < BASELINE_CREATEHTTP).assertTrue();
      done();
    });

    it('isPossibleShortNumber', TestType.PERFORMANCE, async (done: Function) => {
      let startTime = new Date().getTime();
      for (let index = 0; index < BASE_COUNT; index++) {
        shortNumberInfo.isPossibleShortNumber(shortInfoPhone);
      }
      let endTime = new Date().getTime();
      console.log("isPossibleShortNumber endTime:" + endTime);
      let averageTime = ((endTime - startTime) * 1000) / BASE_COUNT
      console.log("isPossibleShortNumber averageTime:" + averageTime + "μs");
      expect(averageTime < BASELINE_CREATEHTTP).assertTrue();
      done();
    });

    it('isPossibleShortNumberForRegion', TestType.PERFORMANCE, async (done: Function) => {
      let startTime = new Date().getTime();
      for (let index = 0; index < BASE_COUNT; index++) {
        shortNumberInfo.isPossibleShortNumberForRegion(shortInfoPhone, 'FR');
      }
      let endTime = new Date().getTime();
      console.log("isPossibleShortNumberForRegion endTime:" + endTime);
      let averageTime = ((endTime - startTime) * 1000) / BASE_COUNT
      console.log("isPossibleShortNumberForRegion averageTime:" + averageTime + "μs");
      expect(averageTime < BASELINE_CREATEHTTP).assertTrue();
      done();
    });

    it('isValidShortNumber', TestType.PERFORMANCE, async (done: Function) => {
      let startTime = new Date().getTime();
      for (let index = 0; index < BASE_COUNT; index++) {
         shortNumberInfo.isValidShortNumber(phoneUtil.parse('110', 'CN'));
      }
      let endTime = new Date().getTime();
      console.log("isValidShortNumber endTime:" + endTime);
      let averageTime = ((endTime - startTime) * 1000) / BASE_COUNT
      console.log("isValidShortNumber averageTime:" + averageTime + "μs");
      expect(averageTime < BASELINE_CREATEHTTP).assertTrue();
      done();
    });

    it('isValidShortNumberForRegion', TestType.PERFORMANCE, async (done: Function) => {
      let startTime = new Date().getTime();
      for (let index = 0; index < BASE_COUNT; index++) {
        shortNumberInfo.isValidShortNumberForRegion(phoneUtil.parse('110', 'CN'), 'CN')
      }
      let endTime = new Date().getTime();
      console.log("isValidShortNumberForRegion endTime:" + endTime);
      let averageTime = ((endTime - startTime) * 1000) / BASE_COUNT
      console.log("isValidShortNumberForRegion averageTime:" + averageTime + "μs");
      expect(averageTime < BASELINE_CREATEHTTP).assertTrue();
      done();
    });

    it('regionDialingFromMatchesNumber_', TestType.PERFORMANCE, async (done: Function) => {
      let startTime = new Date().getTime();
      for (let index = 0; index < BASE_COUNT; index++) {
        shortNumberInfo.regionDialingFromMatchesNumber_(shortInfoPhone, 'FR');
      }
      let endTime = new Date().getTime();
      console.log("regionDialingFromMatchesNumber_ endTime:" + endTime);
      let averageTime = ((endTime - startTime) * 1000) / BASE_COUNT
      console.log("regionDialingFromMatchesNumber_ averageTime:" + averageTime + "μs");
      expect(averageTime < BASELINE_CREATEHTTP).assertTrue();
      done();
    });

    it('getExpectedCostForRegion', TestType.PERFORMANCE, async (done: Function) => {
      let startTime = new Date().getTime();
      for (let index = 0; index < BASE_COUNT; index++) {
        shortNumberInfo.getExpectedCostForRegion(shortInfoPhone, 'FR');
      }
      let endTime = new Date().getTime();
      console.log("getExpectedCostForRegion endTime:" + endTime);
      let averageTime = ((endTime - startTime) * 1000) / BASE_COUNT
      console.log("getExpectedCostForRegion averageTime:" + averageTime + "μs");
      expect(averageTime < BASELINE_CREATEHTTP).assertTrue();
      done();
    });

    it('getExpectedCost', TestType.PERFORMANCE, async (done: Function) => {
      let startTime = new Date().getTime();
      for (let index = 0; index < BASE_COUNT; index++) {
        shortNumberInfo.getExpectedCost(shortInfoPhone, 'FR');
      }
      let endTime = new Date().getTime();
      console.log("getExpectedCost endTime:" + endTime);
      let averageTime = ((endTime - startTime) * 1000) / BASE_COUNT
      console.log("getExpectedCost averageTime:" + averageTime + "μs");
      expect(averageTime < BASELINE_CREATEHTTP).assertTrue();
      done();
    });

    it('getExampleShortNumberForCost', TestType.PERFORMANCE, async (done: Function) => {
      let startTime = new Date().getTime();
      for (let index = 0; index < BASE_COUNT; index++) {
        shortNumberInfo.getExampleShortNumberForCost('CH', ShortNumberInfo.ShortNumberCost.TOLL_FREE);
      }
      let endTime = new Date().getTime();
      console.log("getExampleShortNumberForCost endTime:" + endTime);
      let averageTime = ((endTime - startTime) * 1000) / BASE_COUNT
      console.log("getExampleShortNumberForCost averageTime:" + averageTime + "μs");
      expect(averageTime < BASELINE_CREATEHTTP).assertTrue();
      done();
    });

    it('matchesEmergencyNumberHelper_', TestType.PERFORMANCE, async (done: Function) => {
      let startTime = new Date().getTime();
      for (let index = 0; index < BASE_COUNT; index++) {
        shortNumberInfo.matchesEmergencyNumberHelper_("110", 'CN')
      }
      let endTime = new Date().getTime();
      console.log("matchesEmergencyNumberHelper_ endTime:" + endTime);
      let averageTime = ((endTime - startTime) * 1000) / BASE_COUNT
      console.log("matchesEmergencyNumberHelper_ averageTime:" + averageTime + "μs");
      expect(averageTime < BASELINE_CREATEHTTP).assertTrue();
      done();
    });

    it('isCarrierSpecificForRegion', TestType.PERFORMANCE, async (done: Function) => {
      let startTime = new Date().getTime();
      for (let index = 0; index < BASE_COUNT; index++) {
        shortNumberInfo.isCarrierSpecificForRegion(phoneUtil.parse("12345", "US"), "US");
      }
      let endTime = new Date().getTime();
      console.log("isCarrierSpecificForRegion endTime:" + endTime);
      let averageTime = ((endTime - startTime) * 1000) / BASE_COUNT
      console.log("isCarrierSpecificForRegion averageTime:" + averageTime + "μs");
      expect(averageTime < BASELINE_CREATEHTTP).assertTrue();
      done();
    });

    it('isSmsServiceForRegion', TestType.PERFORMANCE, async (done: Function) => {
      let startTime = new Date().getTime();
      for (let index = 0; index < BASE_COUNT; index++) {
        shortNumberInfo.isSmsServiceForRegion(phoneUtil.parse("+12025550112", "US"), 'US')
      }
      let endTime = new Date().getTime();
      console.log("isSmsServiceForRegion endTime:" + endTime);
      let averageTime = ((endTime - startTime) * 1000) / BASE_COUNT
      console.log("isSmsServiceForRegion averageTime:" + averageTime + "μs");
      expect(averageTime < BASELINE_CREATEHTTP).assertTrue();
      done();
    });

    it('getNationalSignificantNumber_', TestType.PERFORMANCE, async (done: Function) => {
      let startTime = new Date().getTime();
      for (let index = 0; index < BASE_COUNT; index++) {
        shortNumberInfo.getNationalSignificantNumber_(phoneUtil.parse("+12025550112", "US"))
      }
      let endTime = new Date().getTime();
      console.log("getNationalSignificantNumber_ endTime:" + endTime);
      let averageTime = ((endTime - startTime) * 1000) / BASE_COUNT
      console.log("getNationalSignificantNumber_ averageTime:" + averageTime + "μs");
      expect(averageTime < BASELINE_CREATEHTTP).assertTrue();
      done();
    });

    it('maybeCreateNewTemplate_', TestType.PERFORMANCE, async (done: Function) => {
      let startTime = new Date().getTime();
      for (let index = 0; index < BASE_COUNT; index++) {
        asYouType.maybeCreateNewTemplate_(format);
      }
      let endTime = new Date().getTime();
      console.log("maybeCreateNewTemplate_ endTime:" + endTime);
      let averageTime = ((endTime - startTime) * 1000) / BASE_COUNT
      console.log("maybeCreateNewTemplate_ averageTime:" + averageTime + "μs");
      expect(averageTime < BASELINE_CREATEHTTP).assertTrue();
      done();
    });

    it('appendNationalNumber_', TestType.PERFORMANCE, async (done: Function) => {
      let startTime = new Date().getTime();
      for (let index = 0; index < BASE_COUNT; index++) {
        asYouType.appendNationalNumber_('202-456-1414')
      }
      let endTime = new Date().getTime();
      console.log("appendNationalNumber_ endTime:" + endTime);
      let averageTime = ((endTime - startTime) * 1000) / BASE_COUNT
      console.log("appendNationalNumber_ averageTime:" + averageTime + "μs");
      expect(averageTime < BASELINE_CREATEHTTP).assertTrue();
      done();
    });

    it('asYouType_getRememberedPosition', TestType.PERFORMANCE, async (done: Function) => {
      let startTime = new Date().getTime();
      for (let index = 0; index < BASE_COUNT; index++) {
        asYouType.getRememberedPosition()
      }
      let endTime = new Date().getTime();
      console.log("asYouType_getRememberedPosition endTime:" + endTime);
      let averageTime = ((endTime - startTime) * 1000) / BASE_COUNT
      console.log("asYouType_getRememberedPosition averageTime:" + averageTime + "μs");
      expect(averageTime < BASELINE_CREATEHTTP).assertTrue();
      done();
    });

    it('isNanpaNumberWithNationalPrefix_', TestType.PERFORMANCE, async (done: Function) => {
      let startTime = new Date().getTime();
      for (let index = 0; index < BASE_COUNT; index++) {
        asYouType.isNanpaNumberWithNationalPrefix_()
      }
      let endTime = new Date().getTime();
      console.log("isNanpaNumberWithNationalPrefix_ endTime:" + endTime);
      let averageTime = ((endTime - startTime) * 1000) / BASE_COUNT
      console.log("isNanpaNumberWithNationalPrefix_ averageTime:" + averageTime + "μs");
      expect(averageTime < BASELINE_CREATEHTTP).assertTrue();
      done();
    });

    it('attemptToExtractCountryCallingCode_', TestType.PERFORMANCE, async (done: Function) => {
      let startTime = new Date().getTime();
      for (let index = 0; index < BASE_COUNT; index++) {
        asYouType.attemptToExtractCountryCallingCode_()
      }
      let endTime = new Date().getTime();
      console.log("attemptToExtractCountryCallingCode_ endTime:" + endTime);
      let averageTime = ((endTime - startTime) * 1000) / BASE_COUNT
      console.log("attemptToExtractCountryCallingCode_ averageTime:" + averageTime + "μs");
      expect(averageTime < BASELINE_CREATEHTTP).assertTrue();
      done();
    });

    it('normalizeAndAccrueDigitsAndPlusSign_', TestType.PERFORMANCE, async (done: Function) => {
      let startTime = new Date().getTime();
      for (let index = 0; index < BASE_COUNT; index++) {
        asYouType.normalizeAndAccrueDigitsAndPlusSign_('+', false)
      }
      let endTime = new Date().getTime();
      console.log("normalizeAndAccrueDigitsAndPlusSign_ endTime:" + endTime);
      let averageTime = ((endTime - startTime) * 1000) / BASE_COUNT
      console.log("normalizeAndAccrueDigitsAndPlusSign_ averageTime:" + averageTime + "μs");
      expect(averageTime < BASELINE_CREATEHTTP).assertTrue();
      done();
    });

    it('inputDigitHelper_', TestType.PERFORMANCE, async (done: Function) => {
      let startTime = new Date().getTime();
      for (let index = 0; index < BASE_COUNT; index++) {
        asYouType.inputDigitHelper_('202-456-1414');
      }
      let endTime = new Date().getTime();
      console.log("inputDigitHelper_ endTime:" + endTime);
      let averageTime = ((endTime - startTime) * 1000) / BASE_COUNT
      console.log("inputDigitHelper_ averageTime:" + averageTime + "μs");
      expect(averageTime < BASELINE_CREATEHTTP).assertTrue();
      done();
    });
  })
}