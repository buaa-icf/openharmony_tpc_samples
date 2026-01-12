/**
 * XMPSchemaRegistry 测试
 * 测试命名空间和别名注册功能
 */
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect } from '@ohos/hypium';
import {
  XMPMetaFactory,
  XMPSchemaRegistry,
  XMPConst
} from '@ohos/xmp_toolkit';

const NS1 = 'ns:test1/';

// 辅助函数：获取 registry 并重置
function getRegistry(): XMPSchemaRegistry {
  XMPMetaFactory.reset();
  return XMPMetaFactory.getSchemaRegistry();
}

export default function xmpSchemaRegistryTest() {
  describe('XMPSchemaRegistry', () => {
    afterAll(() => {
      XMPMetaFactory.reset();
    });

    describe('NamespaceRegistration', () => {
      it('should register new namespace', 0, () => {
        const registry = getRegistry();
        let startTime = Date.now();
        const prefix = registry.registerNamespace(NS1, 'ns1');
        console.log("===== XMPSchemaRegistry.registerNameSpace 接口耗时：" + (Date.now() - startTime) / 10 + "ms");

        expect(prefix).assertEqual('ns1:');
      });

      it('should get namespace URI by prefix', 0, () => {
        const registry = getRegistry();
        registry.registerNamespace(NS1, 'ns1');

        let startTime = Date.now();
        const uri = registry.getNamespaceURI('ns1');
        console.log("===== XMPSchemaRegistry.getNamespaceURI 接口耗时：" + (Date.now() - startTime) / 10 + "ms");

        expect(uri).assertEqual(NS1);
      });

      it('should get prefix by namespace URI', 0, () => {
        const registry = getRegistry();
        registry.registerNamespace(NS1, 'ns1');

        let startTime = Date.now();
        const prefix = registry.getNamespacePrefix(NS1);
        console.log("===== XMPSchemaRegistry.getNamespacePrefix 接口耗时：" + (Date.now() - startTime) / 10 + "ms");

        expect(prefix).assertEqual('ns1:');
      });
    });

    describe('getNamespaces', () => {
      it('should return all namespaces', 0, () => {
        const registry = getRegistry();

        let startTime = Date.now();
        const namespaces = registry.getNamespaces();
        console.log("===== XMPSchemaRegistry.getNameSpaces 接口耗时：" + (Date.now() - startTime) / 10 + "ms");

        expect(namespaces.size).assertLarger(0);
      });
    });

    describe('getPrefixes', () => {
      it('should return all prefixes', 0, () => {
        const registry = getRegistry();

        let startTime = Date.now();
        const prefixes = registry.getPrefixes();
        console.log("===== XMPSchemaRegistry.getPrefix 接口耗时：" + (Date.now() - startTime) / 10 + "ms");

        expect(prefixes.size).assertLarger(0);
      });
    });

    describe('AliasResolution', () => {
      it('should return null for non-alias', 0, () => {
        const registry = getRegistry();
        registry.registerNamespace(NS1, 'ns1');

        let startTime = Date.now();
        const aliasInfo = registry.resolveAlias(NS1, 'NonAlias');
        console.log("===== XMPSchemaRegistry.resolveAlias 接口耗时：" + (Date.now() - startTime) / 10 + "ms");

        expect(aliasInfo).assertNull();
      });

      it('should find aliases in namespace', 0, () => {
        const registry = getRegistry();
        registry.registerNamespace(NS1, 'ns1');

        let startTime = Date.now();
        const aliases = registry.findAliases(NS1);
        console.log("===== XMPSchemaRegistry.findAliases 接口耗时：" + (Date.now() - startTime) / 10 + "ms");

        // findAliases 应该返回数组（可能为空）
        expect(aliases).not().assertNull();
      });
    });

    describe('getAliases', () => {
      it('should return all aliases', 0, () => {
        const registry = getRegistry();

        let startTime = Date.now();
        const aliases = registry.getAliases();
        console.log("===== XMPSchemaRegistry.getAliases 接口耗时：" + (Date.now() - startTime) / 10 + "ms");

        expect(aliases).not().assertNull();
      });
    });

    describe('findAlias', () => {
      it('should return null for non-aliased property', 0, () => {
        const registry = getRegistry();
        registry.registerNamespace(NS1, 'ns1');

        let startTime = Date.now();
        const aliasInfo = registry.findAlias('ns1:NotAnAlias');
        console.log("===== XMPSchemaRegistry.findAlias 接口耗时：" + (Date.now() - startTime) / 10 + "ms");

        expect(aliasInfo).assertNull();
      });
    });

    describe('deleteNameSpace', () => {
      it('should the namespcae is not exist', 0, () => {
        const registry = getRegistry();
        registry.registerNamespace(NS1, 'ns1');


        const namespacesBefore = registry.getNamespaces();
        const sizeBefore = namespacesBefore.size;

        let startTime = Date.now();
        registry.deleteNamespace(NS1);
        console.log("===== XMPSchemaRegistry.deleteNamespace 接口耗时：" + (Date.now() - startTime) / 10 + "ms");
        const namespacesAfter = registry.getNamespaces();
        const hasNS1After = namespacesAfter.has(NS1);
        const sizeAfter = namespacesAfter.size;
        const deletePassed = !hasNS1After && sizeAfter === sizeBefore - 1;

        expect(deletePassed).assertTrue();
      });
    });
  });
}
