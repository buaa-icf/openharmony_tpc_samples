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



import { hilog } from '@kit.PerformanceAnalysisKit';
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect } from '@ohos/hypium';
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
import { StringBuffer } from './StringBuffer'



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
    let validNumbers = [
      '202-456-1414',
      '(202) 456-1414',
      '+1 (202) 456-1414',
      '202.456.1414',
      '202/4561414',
      '1 202 456 1414',
      '+12024561414',
      '1 202-456-1414'
    ];
    let phoneUtil: PhoneNumberUtil = PhoneNumberUtil.getInstance();
    let numberFormat: NumberFormat = new NumberFormat();
    let US_NUMBER:PhoneNumber = new PhoneNumber();
    US_NUMBER.setCountryCode(1);
    US_NUMBER.setNationalNumber(6502530000);
    let itPhone: PhoneNumber = phoneUtil.parse('+390612345678', 'IT');
    let phone: PhoneNumber = phoneUtil.parseAndKeepRawInput('202-456-1414 #123', 'US');
    let asYouType: AsYouTypeFormatter = new AsYouTypeFormatter('US');
    let format: PhoneNumberFormat = phoneUtil.format(phone, PhoneNumberFormat.NATIONAL);

    it('should_format_a_number_in_the_international_format', 0, () => {
      validNumbers.forEach(value => {
        let phoneNumber: PhoneNumber = phoneUtil.parseAndKeepRawInput(value, 'US');
        let formatValue: string = phoneUtil.format(phoneNumber, PhoneNumberFormat.INTERNATIONAL);
        expect(formatValue).assertEqual('+1 202-456-1414');
      });
    });

    it('should_format_a_number_in_the_E164_format', 0, () => {
      validNumbers.forEach(value => {
        let phoneNumber: PhoneNumber = phoneUtil.parseAndKeepRawInput(value, 'US');
        let formatValue: string = phoneUtil.format(phoneNumber, PhoneNumberFormat.E164);
        expect(formatValue).assertEqual('+12024561414');
      });
    });

    it('should_format_a_number_in_the_national_format', 0, () => {
      validNumbers.forEach(value => {
        let phoneNumber: PhoneNumber = phoneUtil.parseAndKeepRawInput(value, 'US');
        let formatValue: string = phoneUtil.format(phoneNumber, PhoneNumberFormat.NATIONAL)
        expect(formatValue).assertEqual('(202) 456-1414');
      });
    });

    it('should_format_a_number_in_the_RFC3966_format', 0, () => {
      validNumbers.forEach(value => {
        let phoneNumber: PhoneNumber = phoneUtil.parseAndKeepRawInput(value, 'US');
        let formatValue: string = phoneUtil.format(phoneNumber, PhoneNumberFormat.RFC3966);
        expect(formatValue).assertEqual('tel:+1-202-456-1414');
      });
    });

    it('should_return_a_valid_phone_number_type', 0, () => {
      let phoneNumber: PhoneNumber = phoneUtil.parseAndKeepRawInput(validNumbers[0], 'US');
      expect(phoneUtil.getNumberType(phoneNumber)).assertEqual(PhoneNumberType.FIXED_LINE_OR_MOBILE);
    });

    it('should_throw_an_error_when_attempting_to_format_a_malformatted_number', 0, () => {
      try {
        phoneUtil.parseAndKeepRawInput('111111111111111111111', 'US');
      } catch (e) {
        expect(e.message).assertEqual('The string supplied is too long to be a phone number');
      }
    });

    it('should_return_a_reason_for_an_invalid_number', 0, () => {
      let phoneNumber: PhoneNumber = phoneUtil.parseAndKeepRawInput('123456', 'US');
      expect(phoneUtil.isPossibleNumber(phoneNumber)).assertFalse();
      expect(phoneUtil.isPossibleNumberWithReason(phoneNumber)).assertEqual(PhoneNumberUtil.ValidationResult.TOO_SHORT);
    });

    it('should_format_numbers_as_typed_', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      hilog.info(0x0000, 'testTag', '%{public}s', 'it begin');
      let a = 'abc';
      let b = 'b';
      // Defines a variety of assertion methods, which are used to declare expected boolean conditions.
      expect(a).assertContain(b);
      expect(a).assertEqual(a);
    })

    it('should_format_numbers_as_typed', 0, () => {
      let formatter: AsYouTypeFormatter = new AsYouTypeFormatter('PT');
      let phoneNumber = '912345678';
      let sequence = [
        '9',
        '91',
        '912',
        '912 3',
        '912 34',
        '912 345',
        '912 345 6',
        '912 345 67',
        '912 345 678'
      ];
      for (let i = 0; i < phoneNumber.length; ++i) {
        let formatterContent: string = formatter.inputDigit(phoneNumber.charAt(i));
        expect(formatterContent).assertEqual(sequence[i]);
      }
    });

    it('country_with_space_in_national_prefix_formatting_rule', 0, () => {
      let formatter: AsYouTypeFormatter = new AsYouTypeFormatter('BY');
      expect(formatter.inputDigit('8')).assertEqual('8');
      expect(formatter.inputDigit('8')).assertEqual('88');
      expect(formatter.inputDigit('1')).assertEqual('881');
      expect(formatter.inputDigit('9')).assertEqual('8 819');
      expect(formatter.inputDigit('0')).assertEqual('8 819 0');
      expect(formatter.inputDigit('1')).assertEqual('8 819 01');
      expect(formatter.inputDigit('2')).assertEqual('8 819 012');
      expect(formatter.inputDigit('3')).assertEqual('8 819 0123');
    });

    it('AYTFUSMobileShortCode', 0, () => {
      let formatter: AsYouTypeFormatter = new AsYouTypeFormatter('US');
      expect(formatter.inputDigit('*')).assertEqual('*');
      expect(formatter.inputDigit('1')).assertEqual('*1');
      expect(formatter.inputDigit('2')).assertEqual('*12');
      expect(formatter.inputDigit('1')).assertEqual('*121');
      expect(formatter.inputDigit('#')).assertEqual('*121#');
    });

    it('testAYTFGBFixedLine', 0, () => {
      let formatter: AsYouTypeFormatter = new AsYouTypeFormatter('GB');
      expect(formatter.inputDigit('0')).assertEqual('0');
      expect(formatter.inputDigit('2')).assertEqual('02');
      expect(formatter.inputDigit('0')).assertEqual('020');
      expect(formatter.inputDigitAndRememberPosition('7')).assertEqual('020 7');
      expect(formatter.getRememberedPosition()).assertEqual(5);
      expect(formatter.inputDigit('0')).assertEqual('020 70');
      expect(formatter.inputDigit('3')).assertEqual('020 703');
      expect(formatter.getRememberedPosition()).assertEqual(5);
      expect(formatter.inputDigit('1')).assertEqual('020 7031');
      expect(formatter.inputDigit('3')).assertEqual('020 7031 3');
      expect(formatter.inputDigit('0')).assertEqual('020 7031 30');
      expect(formatter.inputDigit('0')).assertEqual('020 7031 300');
      expect(formatter.inputDigit('0')).assertEqual('020 7031 3000');
    });

    it('AYTFUSFullWidthCharacters', 0, () => {
      let formatter: AsYouTypeFormatter = new AsYouTypeFormatter('US');
      expect(formatter.inputDigit('\uFF16')).assertEqual('\uFF16');
      expect(formatter.inputDigit('\uFF15')).assertEqual('\uFF16\uFF15');
      expect(formatter.inputDigit('\uFF10')).assertEqual('650');
      expect(formatter.inputDigit('\uFF12')).assertEqual('650-2');
      expect(formatter.inputDigit('\uFF15')).assertEqual('650-25');
      expect(formatter.inputDigit('\uFF13')).assertEqual('650-253');
      expect(formatter.inputDigit('\uFF12')).assertEqual('650-2532');
      expect(formatter.inputDigit('\uFF12')).assertEqual('(650) 253-22');
      expect(formatter.inputDigit('\uFF12')).assertEqual('(650) 253-222');
      expect(formatter.inputDigit('\uFF12')).assertEqual('(650) 253-2222');
    });

    it('testAYTFDE', 0, () => {
      let formatter: AsYouTypeFormatter = new AsYouTypeFormatter('DE');
      expect(formatter.inputDigit('0')).assertEqual('0');
      expect(formatter.inputDigit('3')).assertEqual('03');
      expect(formatter.inputDigit('0')).assertEqual('030');
      expect(formatter.inputDigit('1')).assertEqual('030 1');
      expect(formatter.inputDigit('2')).assertEqual('030 12');
      expect(formatter.inputDigit('3')).assertEqual('030 123');
      expect(formatter.inputDigit('4')).assertEqual('030 1234');
      // 04134 1234
      formatter.clear();
      expect(formatter.inputDigit('0')).assertEqual('0');
      expect(formatter.inputDigit('4')).assertEqual('04');
      expect(formatter.inputDigit('1')).assertEqual('041');
      expect(formatter.inputDigit('3')).assertEqual('0413');
      expect(formatter.inputDigit('4')).assertEqual('04134');
      expect(formatter.inputDigit('1')).assertEqual('04134 1');
      expect(formatter.inputDigit('2')).assertEqual('04134 12');
      expect(formatter.inputDigit('3')).assertEqual('04134 123');
      expect(formatter.inputDigit('4')).assertEqual('04134 1234');
    });

    it('should_export_an_instance_of_PhoneNumberUtil', 0, () => {
      expect(PhoneNumberUtil.getInstance() instanceof PhoneNumberUtil).assertTrue();
    });

    it('PhoneNumberUtil_getRegionCodeForNumber', 0, () => {
      expect(phoneUtil.getRegionCodeForNumber(itPhone)).assertEqual('IT');
    });

    it('PhoneNumberUtil_format', 0, () => {
      expect(phoneUtil.format(itPhone, PhoneNumberFormat.NATIONAL)).assertEqual('06 1234 5678');
    });

    it('PhoneNumberUtil_isValidNumber', 0, () => {
      expect(phoneUtil.isValidNumber(phone)).assertTrue();
    });

    it('PhoneNumberUtil_isPossibleNumber', 0, () => {
      expect(phoneUtil.isPossibleNumber(phone)).assertTrue();
    });

    it('PhoneNumberUtil_isValidNumberForRegion', 0, () => {
      expect(phoneUtil.isPossibleNumber(phone)).assertTrue();
    });

    it('PhoneNumberUtil_formatInOriginalFormat', 0, () => {
      expect(phoneUtil.formatInOriginalFormat(phoneUtil.parse("+86 138 1234 5678", 'CH'))).assertEqual('138 1234 5678');
    });

    it('PhoneNumberUtil_formatOutOfCountryCallingNumber', 0, () => {
      expect(phoneUtil.formatOutOfCountryCallingNumber(phone, "US")).assertEqual('1 (202) 456-1414 ext. 123');
    });

    it('PhoneNumberUtil_createExtnPattern_', 0, () => {
      expect(PhoneNumberUtil.createExtnPattern_().length > 0).assertTrue();
    });

    it('PhoneNumberUtil_extractPossibleNumber', 0, () => {
      expect(PhoneNumberUtil.extractPossibleNumber('1234567890')).assertEqual('1234567890');
    });

    it('PhoneNumberUtil_isViablePhoneNumber', 0, () => {
      expect(PhoneNumberUtil.isViablePhoneNumber('12345')).assertTrue();
    });

    it('PhoneNumberUtil_normalize', 0, () => {
      expect(PhoneNumberUtil.normalize('+12345')).assertEqual('12345');
    });

    it('PhoneNumberUtil_normalizeDigitsOnly', 0, () => {
      expect(PhoneNumberUtil.normalizeDigitsOnly('+12345')).assertEqual('12345');
    });

    it('PhoneNumberUtil_convertAlphaCharactersInNumber', 0, () => {
      expect(PhoneNumberUtil.convertAlphaCharactersInNumber('+abc')).assertEqual('+222');
    });

    it('PhoneNumberUtil_getLengthOfNationalDestinationCode', 0, () => {
      expect(phoneUtil.getLengthOfNationalDestinationCode(phone)).assertEqual(3);
    });

    it('PhoneNumberUtil_getCountryMobileToken', 0, () => {
      expect(PhoneNumberUtil.getCountryMobileToken(54)).assertEqual('9');
    });

    it('PhoneNumberUtil_getSupportedGlobalNetworkCallingCodes', 0, () => {
      expect(phoneUtil.getSupportedGlobalNetworkCallingCodes().length > 0).assertTrue();
    });

    it('PhoneNumberUtil_getSupportedCallingCodes', 0, () => {
      expect(phoneUtil.getSupportedCallingCodes().length > 0).assertTrue();
    });

    it('PhoneNumberUtil_getSupportedTypesForMetadata_', 0, () => {
      expect(PhoneNumberUtil.getSupportedTypesForMetadata_(asYouType.getMetadataForRegion_('US')).length > 0)
        .assertTrue();
    });

    it('PhoneNumberUtil_getSupportedTypesForRegion', 0, () => {
      expect(phoneUtil.getSupportedTypesForRegion().length == 0).assertTrue();
    });

    it('PhoneNumberUtil_normalizeHelper_', 0, () => {
      let normalizationReplacements: ESObject = {
        ' ': '', // 移除空格
        '(': '', // 移除左括号
        ')': '', // 移除右括号
        '-': ''  // 移除破折号
      };
      expect(PhoneNumberUtil.normalizeHelper_('+1 (202) 555-0101', normalizationReplacements, false))
        .assertEqual('+12025550101');
    });

    it('PhoneNumberUtil_isNumberGeographical', 0, () => {
      expect(phoneUtil.isNumberGeographical(phone)).assertTrue();
    });

    it('PhoneNumberUtil_hasValidCountryCallingCode_', 0, () => {
      expect(phoneUtil.hasValidCountryCallingCode_(86)).assertTrue();
    });

    it('PhoneNumberUtil_formatNationalNumberWithCarrierCode', 0, () => {
      expect(phoneUtil.formatNationalNumberWithCarrierCode(phone, 'US')).assertEqual('(202) 456-1414 ext. 123');
    });

    it('PhoneNumberUtil_getMetadataForRegionOrCallingCode_', 0, () => {
      expect(phoneUtil.getMetadataForRegionOrCallingCode_('US',
        PhoneNumberUtil.REGION_CODE_FOR_NON_GEO_ENTITY) instanceof PhoneMetadata).assertTrue();
    });

    it('PhoneNumberUtil_formatNationalNumberWithPreferredCarrierCode', 0, () => {
      expect(phoneUtil.formatNationalNumberWithPreferredCarrierCode(phone, 'US'))
        .assertEqual('(202) 456-1414 ext. 123');
    });

    it('PhoneNumberUtil_formatNumberForMobileDialing', 0, () => {
      expect(phoneUtil.formatNumberForMobileDialing(phone, 'US', true)).assertEqual('+1 202-456-1414');
    });

    it('PhoneNumberUtil_normalizeDiallableCharsOnly', 0, () => {
      expect(PhoneNumberUtil.normalizeDiallableCharsOnly("+123456")).assertEqual('+123456');
    });

    it('PhoneNumberUtil_hasFormattingPatternForNumber_', 0, () => {
      expect(phoneUtil.hasFormattingPatternForNumber_(phone, "US")).assertTrue();
    });

    it('PhoneNumberUtil_formatOutOfCountryKeepingAlphaChars', 0, () => {
      expect(phoneUtil.formatOutOfCountryKeepingAlphaChars(phone, "US")).assertEqual('1 202-456-1414 123');
    });

    it('PhoneNumberUtil_getNationalSignificantNumber', 0, () => {
      expect(phoneUtil.getNationalSignificantNumber(phone)).assertEqual('2024561414');
    });

    it('PhoneNumberUtil_prefixNumberWithCountryCallingCode_', 0, () => {
      expect(phoneUtil.prefixNumberWithCountryCallingCode_("US", phone, "abc", "#222")).assertEqual('abc#222');
    });

    it('PhoneNumberUtil_formatNsn_', 0, () => {
      let metadata: PhoneMetadata = new PhoneMetadata()
      expect(phoneUtil.formatNsn_(phone, metadata, PhoneNumberFormat.NATIONAL, 'US') != undefined).assertTrue();
    });

    it('PhoneNumberUtil_chooseFormattingPatternForNumber_', 0, () => {
      numberFormat.setPattern('123456');
      expect(phoneUtil.chooseFormattingPatternForNumber_([numberFormat], '123456') != undefined).assertTrue();
    });

    it('PhoneNumberUtil_formatNsnUsingPattern_', 0, () => {
      expect(phoneUtil.formatNsnUsingPattern_("13812345678", numberFormat, PhoneNumberFormat.RFC3966, phone, "CN"))
        .assertEqual('13878');
    });

    it('PhoneNumberUtil_getExampleNumberForType', 0, () => {
      expect(phoneUtil.getExampleNumberForType("US", PhoneNumberType.FIXED_LINE_OR_MOBILE, phone) instanceof
        PhoneNumber).assertTrue();
    });

    it('PhoneNumberUtil_getExampleNumberForNonGeoEntity', 0, () => {
      expect(phoneUtil.getExampleNumberForNonGeoEntity(800) instanceof PhoneNumber).assertTrue();
    });

    let phoneMetadata: PhoneMetadata = phoneUtil.getMetadataForRegionOrCallingCode_('US', PhoneNumberUtil.REGION_CODE_FOR_NON_GEO_ENTITY);
    it('PhoneNumberUtil_maybeGetFormattedExtension_', 0, () => {
      expect(phoneUtil.maybeGetFormattedExtension_(phone, phoneMetadata, PhoneNumberFormat.NATIONAL))
        .assertEqual(' ext. 123');
    });

    it('PhoneNumberUtil_getNumberDescByType_', 0, () => {
      expect(PhoneNumberUtil.getNumberDescByType_(phoneMetadata, PhoneNumberType.TOLL_FREE) instanceof PhoneNumberDesc)
        .assertTrue();
    });


    it('phoneUtil_descHasData_', 0, () => {
      expect(PhoneNumberUtil.descHasData_(PhoneNumberUtil.getNumberDescByType_(phoneMetadata, PhoneNumberType.TOLL_FREE))).assertTrue();
    });

    it('test_format_by_pattern', 0, () => {
      numberFormat.setPattern('(\\d{3})(\\d{3})(\\d{4})');
      numberFormat.setFormat('($1) $2-$3');
      expect('(650) 253-0000')
        .assertEqual(phoneUtil.formatByPattern(US_NUMBER, PhoneNumberFormat.NATIONAL, [numberFormat]));
      expect('+1 (650) 253-0000')
        .assertEqual(phoneUtil.formatByPattern(US_NUMBER, PhoneNumberFormat.INTERNATIONAL, [numberFormat]));
      expect('tel:+1-650-253-0000')
        .assertEqual(phoneUtil.formatByPattern(US_NUMBER, PhoneNumberFormat.RFC3966, [numberFormat]));
    });

    it('phoneUtil_parse_prefix_as_idd_', 0, () => {
      // 设置测试数据
      const iddPattern = /\+/; // 假设的正则表达式，用于匹配以 "+" 开头的 IDD 前缀
      const number = new StringBuffer("+1234567890"); // 假设的电话号码，包含 IDD 前缀
      // 调用 parsePrefixAsIdd_ 并断言结果
      expect(phoneUtil.parsePrefixAsIdd_(iddPattern, number)).assertTrue()
      expect(number.toString()).assertEqual("1234567890"); // 预期电话号码被剥离了 IDD 前缀
    });

    it('should_parse_an_international_number_correctly',0, () => {
      const numberToParse = "+1234567890";
      const defaultRegion = "US"; // 假设默认区域为美国
      const keepRawInput = true;
      const checkRegion = true;

      // 调用 parseHelper_ 并断言结果
      const parsedNumber: PhoneNumber = phoneUtil.parseHelper_(numberToParse, defaultRegion, keepRawInput, checkRegion);

      // 验证解析结果
      expect(parsedNumber instanceof PhoneNumber).assertTrue();
      expect(parsedNumber.getCountryCode()).assertEqual(1);
      expect(parsedNumber.getNationalNumber()).assertEqual(234567890);
    });

    it('should_correctly_match_a_possible_number_and_national_number',0, () => {
      const number = "+0987654321";
      const numberDesc:PhoneNumberDesc = new PhoneNumberDesc();
      numberDesc.setNationalNumberPattern("[0-9]{10}$");
      // 验证结果
      expect(shortNumberInfo.matchesPossibleNumberAndNationalNumber_(number, numberDesc)).assertFalse(); // 假设这个电话号码与 PhoneNumberDesc 匹配
    });

    it('should_create_a_formatting_template_for_a_given_number_format',0, () => {
      const format:NumberFormat = new NumberFormat();
      format.setPattern("(\\d{3})(\\d{3})(\\d{4})");
      format.setFormat('($1) $2-$3');
      expect(asYouType.createFormattingTemplate_(format)).assertTrue()
    });

    it('should_attempt_to_choose_pattern_with_prefix_extracted_',0, () => {
      expect(asYouType.attemptToChoosePatternWithPrefixExtracted_()).assertEqual('')
    });

    it('should_attempt_to_format_accrued_digits_',0, () => {
      expect(asYouType.attemptToFormatAccruedDigits_()).assertEqual('');
    });

    it('should_attempt_to_choose_formatting_pattern_',0, () => {
      expect(asYouType.attemptToChooseFormattingPattern_()).assertEqual('');
    });

    it('should_input_accrued_national_number_',0, () => {
      expect(asYouType.inputAccruedNationalNumber_()).assertEqual('');
    });

    it('PhoneNumberUtil_getNumberTypeHelper_', 0, () => {
      expect(phoneUtil.getNumberTypeHelper_("13912345679", phoneMetadata)).assertEqual(PhoneNumberType.UNKNOWN);
    });

    it('PhoneNumberUtil_getMetadataForNonGeographicalRegion', 0, () => {
      expect(phoneUtil.getMetadataForNonGeographicalRegion(800) != undefined).assertTrue();
    });

    it('PhoneNumberUtil_getRegionCodeForNumberFromRegionList_', 0, () => {
      expect(phoneUtil.getRegionCodeForNumberFromRegionList_(phone, ['US', 'CN'])).assertEqual('US');
    });

    it('PhoneNumberUtil_getRegionCodeForCountryCode', 0, () => {
      expect(phoneUtil.getRegionCodeForCountryCode(800)).assertEqual('001');
    });

    it('PhoneNumberUtil_getCountryCodeForRegion', 0, () => {
      expect(phoneUtil.getCountryCodeForRegion(800)).assertEqual(0);
    });

    it('PhoneNumberUtil_getNddPrefixForRegion', 0, () => {
      expect(phoneUtil.getNddPrefixForRegion('US', true)).assertEqual('1');
    });

    it('PhoneNumberUtil_isAlphaNumber', 0, () => {
      expect(phoneUtil.isAlphaNumber('110')).assertFalse();
    });

    it('PhoneNumberUtil_testNumberLength_', 0, () => {
      expect(phoneUtil.testNumberLength_("12345", phoneMetadata))
        .assertEqual(PhoneNumberUtil.ValidationResult.TOO_SHORT);
    });

    it('PhoneNumberUtil_testNumberLengthForType_', 0, () => {
      expect(phoneUtil.testNumberLengthForType_("12345", phoneMetadata, PhoneNumberType.UNKNOWN))
        .assertEqual(PhoneNumberUtil.ValidationResult.TOO_SHORT);
    });

    it('PhoneNumberUtil_isPossibleNumberForTypeWithReason', 0, () => {
      expect(phoneUtil.isPossibleNumberForTypeWithReason(phone, PhoneNumberType.UNKNOWN)).assertEqual(0);
    });

    it('PhoneNumberUtil_isPossibleNumberString', 0, () => {
      expect(phoneUtil.isPossibleNumberString('+1 650 253 0000', "US")).assertTrue();
    });

    it('PhoneNumberUtil_extractCountryCode', 0, () => {
      expect(phoneUtil.extractCountryCode(new StringBuffer('+861241546465456-3898003'), new StringBuffer('')))
        .assertEqual(86);
    });

    it('PhoneNumberUtil_truncateTooLongNumber', 0, () => {
      let tooLongNumber: PhoneNumber = new PhoneNumber();
      tooLongNumber.setCountryCode(44);
      tooLongNumber.setNationalNumber(80123456780123);
      let validNumber: PhoneNumber = new PhoneNumber();
      validNumber.setCountryCode(44);
      validNumber.setNationalNumber(8012345678);
      expect(phoneUtil.truncateTooLongNumber(phoneUtil.parse('+1 650 253 0000', "US"))).assertTrue();
      expect(validNumber.equals(tooLongNumber)).assertFalse();
    });

    it('PhoneNumberUtil_maybeExtractCountryCode', 0, () => {
      let number: PhoneNumber = new PhoneNumber();
      let metadata: PhoneMetadata = phoneUtil.getMetadataForRegion("US");
      try {
        let phoneNumber = '011112-3456789';
        let strippedNumber = '123456789';
        let countryCallingCode = 1;
        let numberToFill = new String();
        expect(phoneUtil.maybeExtractCountryCode(phoneNumber, metadata, numberToFill, true, number))
          .assertEqual(countryCallingCode);
        expect(number.getCountryCodeSource()).assertEqual(CountryCodeSource.FROM_NUMBER_WITH_IDD);
        expect(numberToFill.toString()).assertEqual(strippedNumber);
      } catch (e) {
        console.error('Should not have thrown an exception:' + e.message)
      }
    });

    it('PhoneNumberUtil_maybeStripInternationalPrefixAndNormalize', 0, () => {
      let internationalPrefix = '00[39]';
      let numberToStrip: StringBuffer = new StringBuffer('0034567700-3898003');
      let strippedNumber = '45677003898003';
      expect(phoneUtil.maybeStripInternationalPrefixAndNormalize(
        numberToStrip, internationalPrefix)).assertEqual(PhoneNumber.CountryCodeSource.FROM_NUMBER_WITH_IDD);
      expect(numberToStrip.toString()).assertEqual(strippedNumber.toString())
      expect(phoneUtil.maybeStripInternationalPrefixAndNormalize(
        numberToStrip, internationalPrefix)).assertEqual(PhoneNumber.CountryCodeSource.FROM_DEFAULT_COUNTRY);
      numberToStrip = new StringBuffer('00945677003898003');
      expect(phoneUtil.maybeStripInternationalPrefixAndNormalize(
        numberToStrip, internationalPrefix)).assertEqual(PhoneNumber.CountryCodeSource.FROM_NUMBER_WITH_IDD);
      expect(numberToStrip.toString()).assertEqual(strippedNumber.toString());
    });

    it('PhoneNumberUtil_copyCoreFieldsOnly_', 0, () => {
      expect(PhoneNumberUtil.copyCoreFieldsOnly_(phone) != undefined).assertTrue();
    });

    it('PhoneNumberUtil_matchesEntirely', 0, () => {
      // 要验证的正则表达式
      let regex = /^(\\+\\d{1,3})?(\\(\\d{3}\\)|\\d{3})[-.\\s]?\\d{3}[-.\\s]?\\d{4}$/;
      // 要验证的字符串
      let phoneNumber = '+1 (123) 456-7890';
      expect(PhoneNumberUtil.matchesEntirely(regex, phoneNumber)).assertFalse();
    });

    it('PhoneNumberUtil_maybeStripNationalPrefixAndCarrierCode', 0, () => {
      let metadata: PhoneMetadata = new PhoneMetadata();
      metadata.setNationalPrefixForParsing('34');
      let generalDesc: PhoneNumberDesc = new PhoneNumberDesc();
      generalDesc.setNationalNumberPattern('\\d{4,8}');
      metadata.setGeneralDesc(generalDesc);
      let numberToStrip = new StringBuffer('34356778');
      let strippedNumber = '356778';
      expect(phoneUtil.maybeStripNationalPrefixAndCarrierCode(numberToStrip, metadata, new StringBuffer('')))
        .assertTrue();

      expect(numberToStrip.toString()).assertEqual(strippedNumber)
      expect(phoneUtil.maybeStripNationalPrefixAndCarrierCode(numberToStrip, metadata, new StringBuffer('')))
        .assertFalse();
      metadata.setNationalPrefixForParsing('');
      expect(phoneUtil.maybeStripNationalPrefixAndCarrierCode(numberToStrip, metadata, new StringBuffer('')))
        .assertFalse();
      metadata.setNationalPrefixForParsing('3');
      numberToStrip = new StringBuffer('3123');
      strippedNumber = '3123';
      expect(phoneUtil.maybeStripNationalPrefixAndCarrierCode(numberToStrip, metadata, new StringBuffer('')))
        .assertFalse();

    });

    it('PhoneNumberUtil_maybeStripExtension', 0, () => {
      expect(phoneUtil.maybeStripExtension("+123456")).assertEqual('');
    });

    it('PhoneNumberUtil_checkRegionForParsing_', 0, () => {
      expect(phoneUtil.checkRegionForParsing_("+8613800138000", "CN")).assertTrue();
    });

    it('PhoneNumberUtil_isPhoneContextValid_', 0, () => {
      expect(phoneUtil.isPhoneContextValid_("+8613800138000")).assertTrue();
    });

    it('PhoneNumberUtil_isNumberMatch', 0, () => {
      let num1: PhoneNumber = phoneUtil.parse('+64 3 331 6005', "NZ");
      let num2: PhoneNumber = phoneUtil.parse('+64 03 331 6005', "NZ");
      expect(phoneUtil.isNumberMatch(num1, num2)).assertEqual(PhoneNumberUtil.MatchType.EXACT_MATCH);
      expect(phoneUtil.isNumberMatch('+64 3 331 6005', '+64 03 331 6005'))
        .assertEqual(PhoneNumberUtil.MatchType.EXACT_MATCH);
      expect(phoneUtil.isNumberMatch('+800 1234 5678', '+80012345678'))
        .assertEqual(PhoneNumberUtil.MatchType.EXACT_MATCH);
      expect(phoneUtil.isNumberMatch('+64 03 331-6005', '+64 03331 6005'))
        .assertEqual(PhoneNumberUtil.MatchType.EXACT_MATCH);
      expect(phoneUtil.isNumberMatch('+643 331-6005', '+64033316005'))
        .assertEqual(PhoneNumberUtil.MatchType.EXACT_MATCH);
      expect(phoneUtil.isNumberMatch('+643 331-6005', '+6433316005'))
        .assertEqual(PhoneNumberUtil.MatchType.EXACT_MATCH);
      expect(phoneUtil.isNumberMatch('+64 3 331-6005', '+6433316005'))
        .assertEqual(PhoneNumberUtil.MatchType.EXACT_MATCH);
      expect(phoneUtil.isNumberMatch('+64 3 331-6005', 'tel:+64-3-331-6005;isub=123'))
        .assertEqual(PhoneNumberUtil.MatchType.EXACT_MATCH);
      expect(phoneUtil.isNumberMatch('+1800 siX-Flags', '+1 800 7493 5247'))
        .assertEqual(PhoneNumberUtil.MatchType.EXACT_MATCH);
      expect(phoneUtil.isNumberMatch('+64 3 331-6005 extn 1234', '+6433316005#1234'))
        .assertEqual(PhoneNumberUtil.MatchType.EXACT_MATCH);
      expect(phoneUtil.isNumberMatch('+64 3 331-6005 ext. 1234', '+6433316005;1234'))
        .assertEqual(PhoneNumberUtil.MatchType.EXACT_MATCH);
      expect(phoneUtil.isNumberMatch('+7 423 202-25-11 ext 100', '+7 4232022511 доб. 100'))
        .assertEqual(PhoneNumberUtil.MatchType.EXACT_MATCH);
    });

    it('PhoneNumberUtil_isNationalNumberSuffixOfTheOther_', 0, () => {
      // 解析电话号码字符串为 PhoneNumber 对象
      let firstNumber: PhoneNumber = phoneUtil.parse('+8612345678', 'CN');
      let secondNumber: PhoneNumber = phoneUtil.parse('+861234567890', 'CN');
      expect(phoneUtil.isNationalNumberSuffixOfTheOther_(firstNumber, secondNumber)).assertFalse();
    });

    it('PhoneNumber_getCountryCodeSource', 0, () => {
      expect(phone.getCountryCodeSource()).assertEqual(PhoneNumber.CountryCodeSource.FROM_DEFAULT_COUNTRY);
    });

    it('PhoneNumber_getExtension', 0, () => {
      expect(phone.getExtension()).assertEqual('123');
    });

    it('PhoneNumber_getItalianLeadingZero', 0, () => {
      expect(itPhone.getItalianLeadingZero()).assertTrue();
    });

    it('PhoneNumber_getNationalNumber', 0, () => {
      expect(JSON.stringify(itPhone.getNationalNumber())).assertEqual('612345678');
      expect(JSON.stringify(phone.getNationalNumber())).assertEqual('2024561414');
    });

    it('PhoneNumber_getRawInput', 0, () => {
      expect(phone.getRawInput()).assertEqual('202-456-1414 #123');
    });

    let shortNumberInfo: ShortNumberInfo = ShortNumberInfo.getInstance();
    let shortInfoPhone: PhoneNumber = phoneUtil.parse('12345', 'FR');

    it('shortNumberInfo_connectsToEmergencyNumber', 0, () => {
      expect(shortNumberInfo.connectsToEmergencyNumber('911', 'US')).assertTrue();
    });

    it('shortNumberInfo_isPossibleShortNumber', 0, () => {
      expect(shortNumberInfo.isPossibleShortNumber(shortInfoPhone)).assertTrue();
    });

    it('shortNumberInfo_isPossibleShortNumberForRegion', 0, () => {
      expect(shortNumberInfo.isPossibleShortNumberForRegion(shortInfoPhone, 'FR')).assertTrue();
    });

    it('shortNumberInfo_isValidShortNumber', 0, () => {
      expect(shortNumberInfo.isValidShortNumber(phoneUtil.parse('110', 'CN'))).assertTrue();
    });

    it('shortNumberInfo_isValidShortNumberForRegion', 0, () => {
      expect(shortNumberInfo.isValidShortNumberForRegion(phoneUtil.parse('110', 'CN'), 'CN')).assertTrue();
    });

    it('shortNumberInfo_regionDialingFromMatchesNumber_', 0, () => {
      expect(shortNumberInfo.regionDialingFromMatchesNumber_(shortInfoPhone, 'FR')).assertTrue();
    });

    it('shortNumberInfo_getExpectedCostForRegion', 0, () => {
      expect(shortNumberInfo.getExpectedCostForRegion(shortInfoPhone, 'FR'))
        .assertEqual(ShortNumberInfo.ShortNumberCost.UNKNOWN_COST);
    });

    it('shortNumberInfo_getExpectedCost', 0, () => {
      expect(shortNumberInfo.getExpectedCost(shortInfoPhone, 'FR'))
        .assertEqual(ShortNumberInfo.ShortNumberCost.UNKNOWN_COST);
    });

    it('shortNumberInfo_getSupportedRegions', 0, () => {
      expect(shortNumberInfo.getSupportedRegions() != undefined).assertTrue();
    });

    it('shortNumberInfo_getExampleShortNumberForCost', 0, () => {
      expect(shortNumberInfo.getExampleShortNumberForCost('CH', ShortNumberInfo.ShortNumberCost.TOLL_FREE))
        .assertEqual('112');
    });

    it('shortNumberInfo_getMetadataForRegion_', 0, () => {
      expect(shortNumberInfo.getMetadataForRegion_('US') != undefined).assertTrue();
    });

    it('shortNumberInfo_matchesEmergencyNumberHelper_', 0, () => {
      expect(shortNumberInfo.matchesEmergencyNumberHelper_("110", 'CN')).assertTrue();
    });

    it('shortNumberInfo_isCarrierSpecificForRegion', 0, () => {
      expect(shortNumberInfo.isCarrierSpecificForRegion(phoneUtil.parse("12345", "US"), "US")).assertFalse();
    });

    it('shortNumberInfo_isSmsServiceForRegion', 0, () => {
      expect(shortNumberInfo.isSmsServiceForRegion(phoneUtil.parse("+12025550112", "US"), 'US')).assertFalse();
    });

    it('shortNumberInfo_getNationalSignificantNumber_', 0, () => {
      expect(shortNumberInfo.getNationalSignificantNumber_(phoneUtil.parse("+12025550112", "US")))
        .assertEqual('2025550112');
    });

    it('asYouTypeFormatter_maybeCreateNewTemplate_', 0, () => {
      expect(asYouType.maybeCreateNewTemplate_(format)).assertFalse();
    });

    it('asYouTypeFormatter_inputDigitAndRememberPosition', 0, () => {
      expect(asYouType.inputDigitAndRememberPosition('202-456-1414')).assertEqual('202-456-1414');
    });

    it('asYouTypeFormatter_inputDigitWithOptionToRememberPosition_', 0, () => {
      expect(asYouType.inputDigitWithOptionToRememberPosition_('202-456-1414', false))
        .assertEqual('202-456-1414202-456-1414');
    });

    it('asYouTypeFormatter_ableToExtractLongerNdd_', 0, () => {
      expect(asYouType.ableToExtractLongerNdd_()).assertFalse();
    });

    it('asYouTypeFormatter_appendNationalNumber_', 0, () => {
      expect(asYouType.appendNationalNumber_('202-456-1414')).assertEqual('202-456-1414');
    });

    it('asYouTypeFormatter_getRememberedPosition', 0, () => {
      expect(asYouType.getRememberedPosition()).assertEqual(12);
    });

    it('asYouTypeFormatter_isNanpaNumberWithNationalPrefix_', 0, () => {
      expect(asYouType.isNanpaNumberWithNationalPrefix_()).assertFalse();
    });

    it('asYouTypeFormatter_removeNationalPrefixFromNationalNumber_', 0, () => {
      expect(asYouType.removeNationalPrefixFromNationalNumber_()).assertEqual('');
    });

    it('asYouTypeFormatter_attemptToExtractIdd_', 0, () => {
      expect(asYouType.attemptToExtractIdd_()).assertFalse();
    });

    it('asYouTypeFormatter_attemptToExtractCountryCallingCode_', 0, () => {
      expect(asYouType.attemptToExtractCountryCallingCode_()).assertFalse();
    });

    it('asYouTypeFormatter_normalizeAndAccrueDigitsAndPlusSign_', 0, () => {
      expect(asYouType.normalizeAndAccrueDigitsAndPlusSign_('+', false)).assertEqual('+');
    });

    it('asYouTypeFormatter_inputDigitHelper_', 0, () => {
      expect(asYouType.inputDigitHelper_('202-456-1414')).assertEqual('202-456-1414202-456-1414');
    });

  })
}