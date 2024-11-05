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
  PhoneNumberUtil,
  PhoneNumberFormat,
  AsYouTypeFormatter,
  PhoneNumber,
  PhoneNumberType,
  ShortNumberInfo
} from 'google-libphonenumber'
import { prompt } from '@kit.ArkUI';

const phoneUtil_: PhoneNumberUtil = PhoneNumberUtil.getInstance();

@Entry
@Component
struct Index {
  @State phoneNumber: string = '';
  @State defaultCountry: string = '';
  @State carrierCode: string = '';
  @State outputStr: string = '';
  private scroller = new Scroller()

  phoneNumberParser() {
    try {
      let phoneNumber = this.phoneNumber;
      let regionCode = this.defaultCountry;
      let carrierCode = this.carrierCode;
      let output: string = ''

      let number_: PhoneNumber = phoneUtil_.parseAndKeepRawInput(phoneNumber, regionCode)
      let isNumberValid: boolean = phoneUtil_.isValidNumber(number_);
      output = output.concat('****Parsing Result:****\n');
      output = output.concat(JSON.stringify(number_))
      output = output.concat('\n\n****Validation Results:****');
      let isPossible: boolean = phoneUtil_.isPossibleNumber(number_);
      output = output.concat('\nResult from isPossibleNumber(): ');
      output = output.concat(isPossible + "");
      let isPossibleReason: PhoneNumberUtil.ValidationResult = phoneUtil_.isPossibleNumberWithReason(number_);
      let hasRegionCode = regionCode && regionCode != 'ZZ';
      if (isPossible) {
        // Checking as isValid() fails if possible local only.
        if (isPossibleReason == PhoneNumberUtil.ValidationResult.IS_POSSIBLE_LOCAL_ONLY) {
          output = output.concat('\nResult from isPossibleNumberWithReason(): ');
          output = output.concat('IS_POSSIBLE_LOCAL_ONLY');
          output = output.concat(
            '\nNumber is considered invalid as it is ' +
              'not a possible national number.');
        } else {

          output = output.concat('\nResult from isValidNumber(): ');
          output = output.concat(isNumberValid + "");
          if (isNumberValid && hasRegionCode) {
            output = output.concat('\nResult from isValidNumberForRegion(): ');
            output = output.concat(phoneUtil_.isValidNumberForRegion(number_, regionCode));
          }
          output = output.concat('\nPhone Number region: ');
          output = output.concat(phoneUtil_.getRegionCodeForNumber(number_));
          output = output.concat('\nResult from getNumberType(): ');
          output = output.concat(this.getNumberTypeString(number_));
        }
      } else {
        output = output.concat('\nResult from isPossibleNumberWithReason(): ');
        switch (isPossibleReason) {
          case PhoneNumberUtil.ValidationResult.INVALID_COUNTRY_CODE:
            output = output.concat('INVALID_COUNTRY_CODE');
            break;
          case PhoneNumberUtil.ValidationResult.TOO_SHORT:
            output = output.concat('TOO_SHORT');
            break;
          case PhoneNumberUtil.ValidationResult.TOO_LONG:
            output = output.concat('TOO_LONG');
            break;
          case PhoneNumberUtil.ValidationResult.INVALID_LENGTH:
            output = output.concat('INVALID_LENGTH');
            break;
        }
        // IS_POSSIBLE shouldn't happen, since we only call this if _not_
        // possible.
        output = output.concat(
          '\nNote: Numbers that are not possible have type UNKNOWN,' +
            ' an unknown region, and are considered invalid.');
      }
      if (!isNumberValid) {
        let shortInfo: ShortNumberInfo = ShortNumberInfo.getInstance();
        output = output.concat('\n\n****ShortNumberInfo Results:****');
        output = output.concat('\nResult from isPossibleShortNumber: ');
        output = output.concat(shortInfo.isPossibleShortNumber(number_));
        output = output.concat('\nResult from isValidShortNumber: ');
        output = output.concat(shortInfo.isValidShortNumber(number_));
        if (hasRegionCode) {
          output = output.concat('\nResult from isPossibleShortNumberForRegion: ');
          output = output.concat(
            shortInfo.isPossibleShortNumberForRegion(number_, regionCode));
          output = output.concat('\nResult from isValidShortNumberForRegion: ');
          output = output.concat(
            shortInfo.isValidShortNumberForRegion(number_, regionCode));
        }
      }
      output = output.concat('\n\n****Formatting Results:**** ');
      output = output.concat('\nE164 format: ');
      output = output.concat(
        isNumberValid ? phoneUtil_.format(number_, PhoneNumberFormat.E164) : 'invalid');
      output = output.concat('\nOriginal format: ');
      output = output.concat(phoneUtil_.formatInOriginalFormat(number_, regionCode));
      output = output.concat('\nNational format: ');
      output = output.concat(phoneUtil_.format(number_, PhoneNumberFormat.NATIONAL));
      output = output.concat('\nInternational format: ');
      output = output.concat(
        isNumberValid ? phoneUtil_.format(number_, PhoneNumberFormat.INTERNATIONAL) :
          'invalid');
      output = output.concat('\nOut-of-country format from US: ');
      output = output.concat(
        isNumberValid ?
        phoneUtil_.formatOutOfCountryCallingNumber(number_, 'US') :
          'invalid');
      output = output.concat('\nOut-of-country format from Switzerland: ');
      output = output.concat(
        isNumberValid ?
        phoneUtil_.formatOutOfCountryCallingNumber(number_, 'CH') :
          'invalid');
      if (carrierCode.length > 0) {
        output.concat('\nNational format with carrier code: ');
        output.concat(
          phoneUtil_.formatNationalNumberWithCarrierCode(number_, carrierCode));
      }
      output = output.concat('\nFormat for mobile dialing (calling from US): ');
      output = output.concat(
        isNumberValid ?
        phoneUtil_.formatNumberForMobileDialing(number_, 'US', true) :
          'invalid');
      output =
        output.concat('\nFormat for national dialing with preferred carrier code and empty fallback carrier code: ');
      output = output.concat(
        isNumberValid ?
        phoneUtil_.formatNationalNumberWithPreferredCarrierCode(number_, '') :
          'invalid');
      output = output.concat('\n\n****AsYouTypeFormatter Results****');
      let formatter: AsYouTypeFormatter = new AsYouTypeFormatter(regionCode);
      let phoneNumberLength = phoneNumber.length;
      for (let i = 0; i < phoneNumberLength; ++i) {
        let inputChar = phoneNumber.charAt(i);
        output = output.concat('\nChar entered: ');
        output = output.concat(inputChar);
        output = output.concat(' Output: ');
        output = output.concat(formatter.inputDigit(inputChar));
      }

      this.outputStr = output
    } catch (e) {
      console.error('phoneNumberParser::error is e:' + e.message)
    }
  }

  getNumberTypeString(number: PhoneNumber): string {
    let phoneNumberType = ''
    switch (phoneUtil_.getNumberType(number)) {
      case PhoneNumberType.FIXED_LINE:
        phoneNumberType = 'FIXED_LINE';
        break;
      case PhoneNumberType.MOBILE:
        phoneNumberType = 'MOBILE';
        break
      case PhoneNumberType.FIXED_LINE_OR_MOBILE:
        phoneNumberType = 'FIXED_LINE_OR_MOBILE';
        break
      case PhoneNumberType.TOLL_FREE:
        phoneNumberType = 'TOLL_FREE';
        break
      case PhoneNumberType.PREMIUM_RATE:
        phoneNumberType = 'PREMIUM_RATE';
        break
      case PhoneNumberType.SHARED_COST:
        phoneNumberType = 'SHARED_COST';
        break
      case PhoneNumberType.VOIP:
        phoneNumberType = 'VOIP';
        break
      case PhoneNumberType.PERSONAL_NUMBER:
        phoneNumberType = 'PERSONAL_NUMBER';
        break
      case PhoneNumberType.PAGER:
        phoneNumberType = 'PAGER';
        break
      case PhoneNumberType.UAN:
        phoneNumberType = 'UAN';
        break
      case PhoneNumberType.UNKNOWN:
        phoneNumberType = 'UNKNOWN';
        break
    }
    return phoneNumberType
  }

  build() {
    Scroll(this.scroller) {
      Column() {
        Text($r('app.string.specify_phone_number'))
          .fontSize(25)
        TextInput({ text: this.phoneNumber })
          .onChange((v) => {
            this.phoneNumber = v
          }).fontSize(25)
        Text($r('app.string.specify_country'))
          .fontSize(25)
        TextInput({
          text: this.defaultCountry,
          placeholder: $r('app.string.input_country_prompt')
        }).onChange((v) => {
          this.defaultCountry = v
        }).fontSize(25)
        Text($r('app.string.specify_carrier_code'))
          .fontSize(25)
        TextInput({
          text: this.carrierCode,
          placeholder: $r('app.string.input_carrier_code_prompt')
        }).onChange((v) => {
          this.carrierCode = v
        })
          .fontSize(25)
        Button($r('app.string.submit'))
          .id('submit')
          .onClick(() => {
            if (this.phoneNumber && this.defaultCountry) {
              this.phoneNumberParser()
            } else {
              if (!this.phoneNumber) {
                prompt.showToast({ message: getContext().resourceManager.getStringSync($r('app.string.check_number')) });
                return;
              }
              if (!this.defaultCountry) {
                prompt.showToast({ message: getContext().resourceManager.getStringSync($r('app.string.check_area_code')) });
                return;
              }
            }
          })
        Button($r('app.string.reset'))
          .onClick(() => {
            this.phoneNumber = ''
            this.defaultCountry = ''
            this.carrierCode = ''
          })
        Text(this.outputStr)
      }
    }
    .width('100%')
    .height('100%')
  }
}