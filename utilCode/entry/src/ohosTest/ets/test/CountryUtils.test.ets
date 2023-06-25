import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect } from '@ohos/hypium'
import { CountryUtils } from '@ohos/util_code'
import I18n from '@ohos.i18n';

export default function CountryUtilsTest() {
  describe('CountryUtilsTest', function () {

    it('getCountryCode' , 0, function () {
      expect(CountryUtils.getCountryCode('CN')).assertEqual('+86')
    })

    it('getCountryCodeByLanguage' , 0, function () {
      let systemRegion = I18n.System.getSystemRegion();
      expect(CountryUtils.getCountryCodeByLanguage()).assertEqual(CountryUtils.getCountryCode(systemRegion))
    })

    for (let [key, value] of CountryUtils.getCountryCodeFromMap().entries()) {
      it('getCountryCodeFromMap_' + key, 0, function () {
        expect(CountryUtils.getCountryCodeFromMap().get(key)).assertEqual(value)
      })
    }

  })
}