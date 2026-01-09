/**
 * xmpProperty 测试
 * 测试 XMP 路径解析和构建功能
 */
import { describe, beforeAll, it, expect } from '@ohos/hypium';
import { XMPMetaFactory } from '@ohos/xmp_toolkit';
import { XMPProperty } from '@ohos/xmp_toolkit';
import { XMPException } from '@ohos/xmp_toolkit';

const NS1 = 'ns:test1/';
const NS2 = 'ns:test2/';

export default function xmpPropertyTest() {
  describe('XMPPropertyModule', () => {
    beforeAll(() => {
      XMPMetaFactory.reset();
      const registry = XMPMetaFactory.getSchemaRegistry();
      registry.registerNamespace(NS1, 'ns1');
      registry.registerNamespace(NS2, 'ns2');
    });

    describe('XMPProperty', () => {
      it('should get property error and throw XMPException', 0, () => {
        const meta = XMPMetaFactory.create();
        meta.setProperty(NS1, "Prop1", "Prop value1");
        meta.setProperty(NS1, "Prop2", "Prop value2");

        let errNum: number = 0;
        let item: XMPProperty| null = null;
        try {
          item = meta.getProperty("ns:bogus/", "Bogus");
        } catch (e) {
          if (e instanceof XMPException) {
            let startTime = Date.now();
            errNum = e.getErrorCode();
            console.log("===== XMPException.getErrorCode 接口耗时：" + (Date.now() - startTime) / 10 + "ms");
          }
        }

        expect(errNum).not().assertEqual(0);
        expect(item).assertNull();
      });
    });
  });
}

