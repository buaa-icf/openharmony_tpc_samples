import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect } from '@ohos/hypium'
// @ts-ignore
import { get12, get24 } from 'time-ampm';
import isLeapYear from 'leap-year';

export default function TimeTest() {


  describe('TimeTest', function () {
    it('get12', 0, function () { //第一个参数自定义
      expect(get12(0)).assertEqual('12 am')
    })
    it('get24', 0, function () { //第一个参数自定义
      expect(get24('10 pm')).assertEqual('22')
    })
    it('isLeapYear_2016', 0, function () {
      expect(isLeapYear(2014)).assertFalse()
    })
    it('isLeapYear_2016', 0, function () {
      expect(isLeapYear(2016)).assertTrue()
    })
    it('isLeapYear_2016_date', 0, function () {
      expect(isLeapYear(new Date(2016, 0))).assertTrue()
    })
    it('isLeapYear_err', 0, function () {
      expect(isLeapYear(111)).assertInstanceOf('Boolean')
    })
  })

}