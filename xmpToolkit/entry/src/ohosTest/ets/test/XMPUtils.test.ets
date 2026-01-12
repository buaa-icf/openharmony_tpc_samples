/**
 * XMPUtils 测试
 * 测试 XMP 工具类功能
 */
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect } from '@ohos/hypium';
import {
  XMPMetaFactory,
  XMPUtils,
  PropertyOptions
} from '@ohos/xmp_toolkit';
import { util } from '@kit.ArkTS';

const NS1 = 'ns:test1/';
const NS2 = 'ns:test2/';

export default function xmpUtilsTest() {
  describe('XMPUtils', () => {
    beforeAll(() => {
      XMPMetaFactory.reset();
      const registry = XMPMetaFactory.getSchemaRegistry();
      registry.registerNamespace(NS1, 'ns1');
      registry.registerNamespace(NS2, 'ns2');
    });

    afterAll(() => {
      XMPMetaFactory.reset();
    });

    describe('catenateArrayItems', () => {
      it('should concatenate array items with separator', 0, () => {
        const meta = XMPMetaFactory.create();
        meta.appendArrayItem(NS1, 'Array', new PropertyOptions().setArray(true), 'Item1', null);
        meta.appendArrayItem(NS1, 'Array', 'Item2');
        meta.appendArrayItem(NS1, 'Array', 'Item3');

        let startTime = Date.now();
        const result = XMPUtils.catenateArrayItems(meta, NS1, 'Array', '; ', '"', true);
        console.log("===== XMPUtils.catenateArrayItems 接口耗时：" + (Date.now() - startTime) / 10 + "ms");
        
        expect(result).assertContain('Item1');
        expect(result).assertContain('Item2');
        expect(result).assertContain('Item3');
      });
    });

    describe('separateArrayItems', () => {
      it('should separate string into array items', 0, () => {
        const meta = XMPMetaFactory.create();

        let startTime = Date.now();
        // separateArrayItems 需要6个参数
        XMPUtils.separateArrayItems(
          meta, 
          NS1, 
          'Array', 
          'Item1; Item2; Item3',
          new PropertyOptions().setArray(true),
          false  // preserveCommas
        );
        console.log("===== XMPUtils.separateArrayItems 接口耗时：" + (Date.now() - startTime) / 10 + "ms");
        
        expect(meta.countArrayItems(NS1, 'Array')).assertLarger(0);
      });
    });

    describe('removeProperties', () => {
      it('should remove properties from specific namespace', 0, () => {
        const meta = XMPMetaFactory.create();
        meta.setProperty(NS1, 'Prop1', 'Value1');
        meta.setProperty(NS1, 'Prop2', 'Value2');
        meta.setProperty(NS2, 'Prop3', 'Value3');

        let startTime = Date.now();
        // removeProperties 需要5个参数，propName 使用空字符串表示删除所有
        XMPUtils.removeProperties(meta, NS1, '', true, true);
        console.log("===== XMPUtils.removeProperties 接口耗时：" + (Date.now() - startTime) / 10 + "ms");
        
        expect(meta.doesPropertyExist(NS1, 'Prop1')).assertFalse();
        expect(meta.doesPropertyExist(NS1, 'Prop2')).assertFalse();
        expect(meta.doesPropertyExist(NS2, 'Prop3')).assertTrue();
      });
    });

    describe('appendProperties', () => {
      it('should append properties from source to destination', 0, () => {
        const source = XMPMetaFactory.create();
        source.setProperty(NS1, 'Prop1', 'Value1');
        source.setProperty(NS1, 'Prop2', 'Value2');
        
        const dest = XMPMetaFactory.create();
        dest.setProperty(NS1, 'ExistingProp', 'ExistingValue');
        
        // appendProperties 需要5个参数
        let startTime = Date.now();
        XMPUtils.appendProperties(source, dest, true, true, false);
        console.log("===== XMPUtils.appendProperties 接口耗时：" + (Date.now() - startTime) / 10 + "ms");
        
        expect(dest.doesPropertyExist(NS1, 'Prop1')).assertTrue();
        expect(dest.doesPropertyExist(NS1, 'Prop2')).assertTrue();
        expect(dest.doesPropertyExist(NS1, 'ExistingProp')).assertTrue();
      });
    });

    describe('Base64EncodingDecoding', () => {
      it('should encode and decode base64', 0, () => {
        const original = 'Hello, World!';
        // 将字符串转换为 Uint8Array
        // 根据 HarmonyOS API: encodeInto(src) 直接返回 Uint8Array
        let encoder = util.TextEncoder.create();
        try{

          const buffer: Uint8Array = encoder.encodeInto(original);

          let startTime = Date.now();
          const encoded: string = XMPUtils.encodeBase64(buffer);
          console.log("===== XMPUtils.encodeBase64 接口耗时：" + (Date.now() - startTime) / 10 + "ms");

          expect(encoded.length).assertLarger(0);

          startTime = Date.now();
          const decoded: Uint8Array = XMPUtils.decodeBase64(encoded);
          console.log("===== XMPUtils.decodeBase64 接口耗时：" + (Date.now() - startTime) / 10 + "ms");
          const decoder = new util.TextDecoder();
          const decodedStr: string = decoder.decodeToString(decoded);
          expect(decodedStr).assertEqual(original);
        }catch (e) {
          console.log('Error: ' + e)
        }


      });
    });

    describe('TypeConversion', () => {
      it('should convert boolean to string', 0, () => {
        let startTime = Date.now();
        const strFromBool = XMPUtils.convertFromBoolean(true);
        console.log("===== XMPUtils.convertFromBoolean 接口耗时：" + (Date.now() - startTime) / 10 + "ms");

        expect(strFromBool).assertEqual('True');
        expect(XMPUtils.convertFromBoolean(false)).assertEqual('False');
      });

      it('should convert string to boolean', 0, () => {
        let startTime = Date.now();
        const strToBool = XMPUtils.convertToBoolean('true');
        console.log("===== XMPUtils.convertToBoolean 接口耗时：" + (Date.now() - startTime) / 10 + "ms");

        expect(strToBool).assertTrue();
        expect(XMPUtils.convertToBoolean('false')).assertFalse();
        expect(XMPUtils.convertToBoolean('1')).assertTrue();
        expect(XMPUtils.convertToBoolean('0')).assertFalse();
      });

      it('should convert integer to string', 0, () => {
        let startTime = Date.now();
        const strFromInt = XMPUtils.convertFromInteger(42);
        console.log("===== XMPUtils.convertFromInteger 接口耗时：" + (Date.now() - startTime) / 10 + "ms");

        expect(strFromInt).assertEqual('42');
        expect(XMPUtils.convertFromInteger(-10)).assertEqual('-10');
      });

      it('should convert string to integer', 0, () => {
        let startTime = Date.now();
        const intToStr = XMPUtils.convertToInteger('42');
        console.log("===== XMPUtils.convertToInteger 接口耗时：" + (Date.now() - startTime) / 10 + "ms");

        expect(intToStr).assertEqual(42);
        expect(XMPUtils.convertToInteger('-10')).assertEqual(-10);
        expect(XMPUtils.convertToInteger('0x10')).assertEqual(16);
      });

      it('should convert double to string', 0, () => {
        let startTime = Date.now();
        const result = XMPUtils.convertFromDouble(3.14);
        console.log("===== XMPUtils.convertFromDouble 接口耗时：" + (Date.now() - startTime) / 10 + "ms");
        expect(result).assertContain('3.14');
      });

      it('should convert string to double', 0, () => {
        let startTime = Date.now();
        const result = XMPUtils.convertToDouble('3.14');
        console.log("===== XMPUtils.convertToDouble 接口耗时：" + (Date.now() - startTime) / 10 + "ms");
        expect(Math.abs(result - 3.14)).assertLess(0.001);
      });

      it('should convert long to string', 0, () => {
        let startTime = Date.now();
        const result = XMPUtils.convertFromLong(1234567890);
        console.log("===== XMPUtils.convertFromLong 接口耗时：" + (Date.now() - startTime) / 10 + "ms");
        expect(result).assertEqual('1234567890');
      });

      it('should convert string to long', 0, () => {
        let startTime = Date.now();
        const result = XMPUtils.convertToLong('1234567890');
        console.log("===== XMPUtils.convertToLong 接口耗时：" + (Date.now() - startTime) / 10 + "ms");
        expect(result).assertEqual(1234567890);
      });
    });

    describe('DateConversion', () => {
      it('should convert date to string and back', 0, () => {
        const dateStr = '2024-11-28T14:30:00';
        let startTime = Date.now();
        const xmpDate = XMPUtils.convertToDate(dateStr);
        console.log("===== XMPUtils.convertToDate 接口耗时：" + (Date.now() - startTime) / 10 + "ms");
        
        expect(xmpDate.getYear()).assertEqual(2024);
        expect(xmpDate.getMonth()).assertEqual(11);
        expect(xmpDate.getDay()).assertEqual(28);

        startTime = Date.now();
        const converted = XMPUtils.convertFromDate(xmpDate);
        console.log("===== XMPUtils.convertFromDate 接口耗时：" + (Date.now() - startTime) / 10 + "ms");
        expect(converted).assertContain('2024');
      });
    });
  });
}


