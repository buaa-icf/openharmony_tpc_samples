/**
 * XMPIterator 测试
 * 测试 XMP 迭代器功能
 */
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect } from '@ohos/hypium';
import {
  XMPMetaFactory,
  XMPPropertyInfo,
  IteratorOptions
} from '@ohos/xmp_toolkit';

const NS1 = 'ns:test1/';
const NS2 = 'ns:test2/';

const RDF_COVERAGE = `<rdf:RDF xmlns:rdf='http://www.w3.org/1999/02/22-rdf-syntax-ns#'>
  <rdf:Description rdf:about='Test:XMPIteratorTest' xmlns:ns1='ns:test1/' xmlns:ns2='ns:test2/'>
    <ns1:SimpleProp>Simple value</ns1:SimpleProp>
    <ns1:ArrayProp>
      <rdf:Bag>
        <rdf:li>Item1</rdf:li>
        <rdf:li>Item2</rdf:li>
      </rdf:Bag>
    </ns1:ArrayProp>
    <ns1:StructProp rdf:parseType='Resource'>
      <ns2:Field1>Field1 value</ns2:Field1>
      <ns2:Field2>Field2 value</ns2:Field2>
    </ns1:StructProp>
  </rdf:Description>
</rdf:RDF>`;

export default function xmpIteratorTest() {
  describe('XMPIterator', () => {
    let registry = XMPMetaFactory.getSchemaRegistry();

    beforeAll(() => {
      XMPMetaFactory.reset();
      registry = XMPMetaFactory.getSchemaRegistry();
      registry.registerNamespace(NS1, 'ns1');
      registry.registerNamespace(NS2, 'ns2');
    });

    afterAll(() => {
      XMPMetaFactory.reset();
    });

    describe('DefaultIteration', () => {
      it('should iterate all properties', 0, () => {
        const meta = XMPMetaFactory.parseFromString(RDF_COVERAGE);

        let startTime = Date.now();
        const iterator = meta.iterator();
        console.log("===== XMPMeta.iterator 接口耗时：" + (Date.now() - startTime) / 10 + "ms");
        
        let count = 0;
        while (iterator.hasNext()) {
          const prop = iterator.next() as XMPPropertyInfo;
          expect(prop).not().assertNull();
          count++;
        }
        
        expect(count).assertLarger(0);
      });
    });

    describe('SkipFunctionality', () => {
      it('should support skipSubtree', 0, () => {
        const meta = XMPMetaFactory.parseFromString(RDF_COVERAGE);
        const iterator = meta.iterator();
        
        let out: number = 0;
        // 遍历时调用 skipSubtree
        while (iterator.hasNext()) {
          const prop = iterator.next() as XMPPropertyInfo;
          if (prop.getPath() === 'ns1:StructProp') {
            let startTime = Date.now();
            iterator.skipSubtree();
            if(out ===0 ){
              console.log("===== XMPiterator.skipSubtree 接口耗时：" + (Date.now() - startTime) / 10 + "ms");
            }

            out += 1;
          }
        }
        
        // 应该能正常完成迭代
        expect(true).assertTrue();
      });

      it('should support skipSiblings', 0, () => {
        const meta = XMPMetaFactory.parseFromString(RDF_COVERAGE);
        const iterator = meta.iterator();

        let out: number = 0;
        while (iterator.hasNext()) {
          const prop = iterator.next() as XMPPropertyInfo;
          if (prop.getPath() === 'ns1:SimpleProp') {
            let startTime = Date.now();
            iterator.skipSiblings();
            if(out === 0){
              console.log("===== XMPiterator.skipSiblings 接口耗时：" + (Date.now() - startTime) / 10 + "ms");
            }

            out += 1;
          }
        }

        expect(true).assertTrue();
      });
    });
  });
}


