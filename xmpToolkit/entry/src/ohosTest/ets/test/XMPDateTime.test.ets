/**
 * XMPDateTime 测试
 * 测试日期时间相关功能
 */
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect } from '@ohos/hypium';
import {
  XMPMetaFactory,
  XMPDateTime,
  XMPDateTimeFactory
} from '@ohos/xmp_toolkit';

const NS1 = 'ns:test1/';

export default function xmpDateTimeTest() {
  describe('XMPDateTime', () => {
    beforeAll(() => {
      XMPMetaFactory.reset();
      const registry = XMPMetaFactory.getSchemaRegistry();
      registry.registerNamespace(NS1, 'ns1');
    });

    afterAll(() => {
      XMPMetaFactory.reset();
    });

    describe('XMPDateTimeFactory.create', () => {
      it('should create date with time', 0, () => {
        let startTime = Date.now();
        const date = XMPDateTimeFactory.create(2024, 11, 28, 14, 30, 45, 0);
        console.log("===== XMPDateTimeFactory.create 接口耗时：" + (Date.now() - startTime) / 10 + "ms");

        expect(date.getHour()).assertEqual(14);
        expect(date.getMinute()).assertEqual(30);
        expect(date.getSecond()).assertEqual(45);
      });
    });

    describe('XMPDateTimeFactory.createFromCalendar', () => {
      it('should create from JavaScript Date', 0, () => {
        const jsDate = new Date(2024, 10, 28, 14, 30, 45); // 月份从0开始

        let startTime = Date.now();
        const xmpDate = XMPDateTimeFactory.createFromCalendar(jsDate);
        console.log("===== XMPDateTimeFactory.createFromCalendar 接口耗时：" + (Date.now() - startTime) / 10 + "ms");
        
        expect(xmpDate.getYear()).assertEqual(2024);
        expect(xmpDate.getMonth()).assertEqual(11); // XMP月份从1开始
        expect(xmpDate.getDay()).assertEqual(28);
      });
    });

    describe('XMPDateTimeFactory.getCurrentDateTime', () => {
      it('should return current date time', 0, () => {
        let startTime = Date.now();
        const now = XMPDateTimeFactory.getCurrentDateTime();
        console.log("===== XMPDateTimeFactory.getCurrentDateTime 接口耗时：" + (Date.now() - startTime) / 10 + "ms");
        const jsNow = new Date();

        expect(now.getYear()).assertEqual(jsNow.getFullYear());
      });
    });

    describe('DatetimeConvert', () => {
      it('should set local time zone', 0, () => {
        // 创建一个UTC时间
        const utcDateTime = XMPDateTimeFactory.createEmpty();
        utcDateTime.setYear(2024);
        utcDateTime.setMonth(6);
        utcDateTime.setDay(15);
        utcDateTime.setHour(10);
        utcDateTime.setMinute(30);
        utcDateTime.setSecond(0);
        utcDateTime.setNanoSecond(0);
        utcDateTime.setTimeZone("UTC");
        utcDateTime.setTimeZoneOffset(0);  // UTC时区偏移为0
        const originalOffset = utcDateTime.getTimeZoneOffset();

        let startTime = Date.now();
        const localDateTime = XMPDateTimeFactory.setLocalTimeZone(utcDateTime);
        console.log("===== XMPDateTimeFactory.setLocalTimeZone 接口耗时：" + (Date.now() - startTime) / 10 + "ms");

        const now = new Date();
        const systemOffset = -now.getTimezoneOffset() * 60 * 1000;
        const hasTimeZone = localDateTime.hasTimeZone();
        const localOffset = localDateTime.getTimeZoneOffset();
        const offsetChanged = originalOffset !== localOffset;
        const offsetMatch = Math.abs(localOffset - systemOffset) < 60000; // 允许1分钟误差

        expect(hasTimeZone).assertTrue();
        expect(offsetChanged).assertTrue();
        expect(offsetMatch).assertTrue();
      });

      it('should display local time correctly', 0, () => {
        // 转换为UTC时间
        const currentDt = XMPDateTimeFactory.getCurrentDateTime();
        let startTime = Date.now();
        const utcDt =XMPDateTimeFactory.convertToUTCTime(currentDt);
        console.log("===== XMPDateTimeFactory.convertToUTCTime 接口耗时：" + (Date.now() - startTime) / 10 + "ms");
        const curDateStr = currentDt.getISO8601String();

        // 转换为本地时间
        startTime = Date.now();
        const backToLocal = XMPDateTimeFactory.convertToLocalTime(utcDt);
        console.log("===== XMPDateTimeFactory.convertToLocalTime 接口耗时：" + (Date.now() - startTime) / 10 + "ms");
        const backToLocalStr = backToLocal.getISO8601String();

        // 验证转换是否成功（本地时间与原始时间不同，因为时区转换）
        const localTimeConverted = currentDt.getYear() === backToLocal.getYear() &&
          currentDt.getMonth() === backToLocal.getMonth() &&
          currentDt.getDay() === backToLocal.getDay() &&
          currentDt.getHour() === backToLocal.getHour() &&
          currentDt.getMinute() === backToLocal.getMinute() &&
          currentDt.getSecond() === backToLocal.getSecond();

        expect(localTimeConverted).assertTrue();
        expect(curDateStr).assertEqual(backToLocalStr);
      });
    });


    describe('XMPDateTimeSetters', () => {
      it('should set year', 0, () => {
        const date = XMPDateTimeFactory.create(2000, 1, 1, 0, 0, 0, 0);

        let startTime = Date.now();
        date.setYear(2025);
        console.log("===== XMPDateTime.setYear 接口耗时：" + (Date.now() - startTime) / 10 + "ms");
        startTime = Date.now();
        const year = date.getYear();
        console.log("===== XMPDateTime.getYear 接口耗时：" + (Date.now() - startTime) / 10 + "ms");

        expect(year).assertEqual(2025);
      });

      it('should set month', 0, () => {
        const date = XMPDateTimeFactory.create(2024, 1, 1, 0, 0, 0, 0);

        let startTime = Date.now();
        date.setMonth(12);
        console.log("===== XMPDateTime.setMonth 接口耗时：" + (Date.now() - startTime) / 10 + "ms");

        startTime = Date.now();
        const month = date.getMonth();
        console.log("===== XMPDateTime.getMonth 接口耗时：" + (Date.now() - startTime) / 10 + "ms");

        expect(month).assertEqual(12);
      });

      it('should set day', 0, () => {
        const date = XMPDateTimeFactory.create(2024, 11, 1, 0, 0, 0, 0);

        let startTime = Date.now();
        date.setDay(28);
        console.log("===== XMPDateTime.setDay 接口耗时：" + (Date.now() - startTime) / 10 + "ms");

        startTime = Date.now();
        const day = date.getDay();
        console.log("===== XMPDateTime.getDay 接口耗时：" + (Date.now() - startTime) / 10 + "ms");

        expect(day).assertEqual(28);
      });

      it('should set hour', 0, () => {
        const date = XMPDateTimeFactory.create(2024, 11, 28, 0, 0, 0, 0);

        let startTime = Date.now();
        date.setHour(23);
        console.log("===== XMPDateTime.setHour 接口耗时：" + (Date.now() - startTime) / 10 + "ms");

        startTime = Date.now();
        const hour = date.getHour();
        console.log("===== XMPDateTime.getHour 接口耗时：" + (Date.now() - startTime) / 10 + "ms");

        expect(hour).assertEqual(23);
      });

      it('should set minute', 0, () => {
        const date = XMPDateTimeFactory.create(2024, 11, 28, 14, 0, 0, 0);

        let startTime = Date.now();
        date.setMinute(59);
        console.log("===== XMPDateTime.setMinute 接口耗时：" + (Date.now() - startTime) / 10 + "ms");

        startTime = Date.now();
        const minute = date.getMinute();
        console.log("===== XMPDateTime.getHour 接口耗时：" + (Date.now() - startTime) / 10 + "ms");

        expect(minute).assertEqual(59);
      });

      it('should set second', 0, () => {
        const date = XMPDateTimeFactory.create(2024, 11, 28, 14, 30, 0, 0);

        let startTime = Date.now();
        date.setSecond(59);
        console.log("===== XMPDateTime.setSecond 接口耗时：" + (Date.now() - startTime) / 10 + "ms");

        startTime = Date.now();
        const second = date.getSecond();
        console.log("===== XMPDateTime.getSecond 接口耗时：" + (Date.now() - startTime) / 10 + "ms");

        expect(second).assertEqual(59);
      });

      it('should set nanosecond', 0, () => {
        const date = XMPDateTimeFactory.create(2024, 11, 28, 14, 30, 45, 0);

        let startTime = Date.now();
        date.setNanoSecond(999999999);
        console.log("===== XMPDateTime.setNanoSecond 接口耗时：" + (Date.now() - startTime) / 10 + "ms");

        startTime = Date.now();
        const nanoSecond = date.getNanoSecond();
        console.log("===== XMPDateTime.getNanoSecond 接口耗时：" + (Date.now() - startTime) / 10 + "ms");

        expect(nanoSecond).assertEqual(999999999);
      });
    });

    describe('XMPDateTime.getCalendar', () => {
      it('should convert to JavaScript Date', 0, () => {
        const xmpDate = XMPDateTimeFactory.create(2024, 11, 28, 14, 30, 45, 0);

        let startTime = Date.now();
        const jsDate: Date = xmpDate.getCalendar();
        console.log("===== XMPDateTime.getCalendar 接口耗时：" + (Date.now() - startTime) / 10 + "ms");
        
        expect(jsDate.getFullYear()).assertEqual(2024);
      });
    });

    describe('DateTimeZone', () => {
      it('should set and get time zone', 0, () => {
        const testDate = XMPDateTimeFactory.createEmpty();
        testDate.setYear(2024);
        testDate.setMonth(12);
        testDate.setDay(26);
        testDate.setHour(11);
        testDate.setMinute(36);
        testDate.setSecond(54);
        testDate.setNanoSecond(3210040);

        let startTime = Date.now();
        testDate.setTimeZone("UTC");
        console.log("===== XMPDateTime.setTimeZone 接口耗时：" + (Date.now() - startTime) / 10 + "ms");

        startTime = Date.now();
        const tz = testDate.getTimeZone();
        console.log("===== XMPDateTime.getTimeZone 接口耗时：" + (Date.now() - startTime) / 10 + "ms");

        expect(tz).assertEqual("UTC");
      });
    });

    describe('DateTimeProperties', () => {
      it('should get string from date time', 0, () => {
        const currentDt = XMPDateTimeFactory.getCurrentDateTime();

        let startTime = Date.now();
        const utcDtStr = currentDt.getISO8601String();
        console.log("===== XMPDateTime.getISO8601String 接口耗时：" + (Date.now() - startTime) / 10 + "ms");
        const pass = utcDtStr.length > 0;

        expect(pass).assertTrue();
      });
    });

  });
}


