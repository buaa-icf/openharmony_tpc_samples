/**
 * XMPPathFactory 测试
 * 测试 XPath 组合工具
 */
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect } from '@ohos/hypium';
import {
  XMPMetaFactory,
  XMPPathFactory,
  XMPConst,
  XMPException,
  PropertyOptions
} from '@ohos/xmp_toolkit';

const NS1 = 'ns:test1/';
const NS2 = 'ns:test2/';

export default function xmpPathFactoryTest() {
  describe('XMPPathFactory', () => {
    beforeAll(() => {
      XMPMetaFactory.reset();
      const registry = XMPMetaFactory.getSchemaRegistry();
      registry.registerNamespace(NS1, 'ns1');
      registry.registerNamespace(NS2, 'ns2');
    });

    afterAll(() => {
      XMPMetaFactory.reset();
    });

    describe('composeArrayItemPath', () => {
      it('should compose path for positive index', 0, () => {
        let startTime = Date.now();
        const path = XMPPathFactory.composeArrayItemPath('ArrayProp', 1);
        console.log("===== XMPPathFactory.composeArrayItemPath 接口耗时：" + (Date.now() - startTime) / 10 + "ms");
        expect(path).assertEqual('ArrayProp[1]');
      });
    });

    describe('composeStructFieldPath', () => {
      it('should compose struct field path', 0, () => {
        let startTime = Date.now();
        const path = XMPPathFactory.composeStructFieldPath(NS2, 'Field1');
        console.log("===== XMPPathFactory.composeStructFieldPath 接口耗时：" + (Date.now() - startTime) / 10 + "ms");
        expect(path).assertContain('Field1');
        expect(path.startsWith('/')).assertTrue();
      });
    });

    describe('composeQualifierPath', () => {
      it('should compose qualifier path', 0, () => {
        let startTime = Date.now();
        const path = XMPPathFactory.composeQualifierPath(NS2, 'Qual');
        console.log("===== XMPPathFactory.composeQualifierPath 接口耗时：" + (Date.now() - startTime) / 10 + "ms");
        expect(path).assertContain('Qual');
        expect(path.startsWith('/?')).assertTrue();
      });
    });

    describe('composeLangSelector', () => {
      it('should compose language selector', 0, () => {
        let startTime = Date.now();
        const path = XMPPathFactory.composeLangSelector('AltText', 'en-US');
        console.log("===== XMPPathFactory.composeLangSelector 接口耗时：" + (Date.now() - startTime) / 10 + "ms");
        expect(path).assertContain('AltText');
        expect(path).assertContain('xml:lang');
        // 根据 RFC 3066：第一个子标签小写，2字母次要子标签大写
        expect(path).assertContain('en-US'); // 规范化后应为 en-US（不是 en-us）
      });
    });

    describe('composeFieldSelector', () => {
      it('should compose field selector', 0, () => {
        let startTime = Date.now();
        const path = XMPPathFactory.composeFieldSelector('ArrayProp', NS2, 'Field', 'Value');
        console.log("===== XMPPathFactory.composeFieldSelector 接口耗时：" + (Date.now() - startTime) / 10 + "ms");
        expect(path).assertContain('ArrayProp');
        expect(path).assertContain('Field');
        expect(path).assertContain('Value');
      });
    });
  });
}


