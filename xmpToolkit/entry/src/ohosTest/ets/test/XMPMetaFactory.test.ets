/**
 * XMPMetaFactory 测试
 * 测试 XMP 元数据工厂类的所有功能
 */
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect } from '@ohos/hypium';
import {
  XMPMetaFactory,
  XMPMeta,
  XMPSchemaRegistry,
  XMPVersionInfo,
  ParseOptions,
  SerializeOptions
} from '@ohos/xmp_toolkit';
import { util } from '@kit.ArkTS';
import versionCfg from '../../../main/resources/base/profile/version.json';

// 测试用 RDF 数据
const SIMPLE_RDF = `<rdf:RDF xmlns:rdf='http://www.w3.org/1999/02/22-rdf-syntax-ns#'>
  <rdf:Description rdf:about='Test:XMPMetaFactoryTest' xmlns:ns1='ns:test1/'>
    <ns1:SimpleProp>Simple value</ns1:SimpleProp>
  </rdf:Description>
</rdf:RDF>`;

const NS1 = 'ns:test1/';

/**
 * 模拟输出流类，用于测试 serialize 方法
 */
class MockOutputStream {
  private buffer: ArrayBuffer;
  private position: number = 0;
  private totalWritten: number = 0;

  constructor(size: number) {
    this.buffer = new ArrayBuffer(size);
  }

  async write(data: string): Promise<void> {
    console.info(`write 方法被调用，数据长度: ${data.length}`);

    // 将字符串编码为 UTF-8
    const encoder = new util.TextEncoder();
    const dataBytes = encoder.encode(data);

    // 确保有足够空间
    if (this.position + dataBytes.length > this.buffer.byteLength) {
      console.warn(`缓冲区不足，需要 ${dataBytes.length} 字节，剩余 ${this.buffer.byteLength - this.position} 字节`);
      // 扩展缓冲区
      const newBuffer = new ArrayBuffer(Math.max(this.buffer.byteLength * 2, this.position + dataBytes.length));
      const newView = new Uint8Array(newBuffer);
      newView.set(new Uint8Array(this.buffer, 0, this.position));
      this.buffer = newBuffer;
    }

    // 写入数据
    const targetView = new Uint8Array(this.buffer, this.position);
    targetView.set(dataBytes);
    this.position += dataBytes.length;
    this.totalWritten += dataBytes.length;
  }

  getWrittenData(): Uint8Array {
    return new Uint8Array(this.buffer, 0, this.position);
  }

  getWrittenSize(): number {
    return this.totalWritten;
  }

  getBuffer(): ArrayBuffer {
    return this.buffer;
  }

  reset(): void {
    this.position = 0;
    this.totalWritten = 0;
  }
}

export default function xmpMetaFactoryTest() {
  describe('XMPMetaFactory', () => {
    beforeAll(() => {
      // 重置注册表以确保测试独立性
      XMPMetaFactory.reset();
    });

    afterAll(() => {
      XMPMetaFactory.reset();
    });

    describe('getVersionInfo', () => {
      it('should return version info with valid values', 0, () => {
        // 读配置的版本信息
        const versionStr = versionCfg.version;
        let cfgMajor: number = 1;
        let cfgMinor: number = 0;
        let cfgMicro: number = 0;
        let cfgEngBuild: number = 0;
        let cfgDebug: boolean = versionCfg.isDebug;

        const dashIndex = versionStr.indexOf('-');
        const versionPart = dashIndex >= 0 ? versionStr.substring(0, dashIndex) : versionStr;
        const engBuildStr = dashIndex >= 0 ? versionStr.substring(dashIndex + 1) : "";
        const dotParts = versionPart.split('.');
        if (dotParts.length >= 1) {
          cfgMajor = parseInt(dotParts[0]) || 0;
        }
        if (dotParts.length >= 2) {
          cfgMinor = parseInt(dotParts[1]) || 0;
        }
        if (dotParts.length >= 3) {
          cfgMicro = parseInt(dotParts[2]) || 0;
        }
        if (engBuildStr) {
          const match = engBuildStr.match(/\d+/);
          if (match) {
            cfgEngBuild = parseInt(match[0]) || 0;
          }
        }

        const versionInfo: XMPVersionInfo = XMPMetaFactory.getVersionInfo();

        let startTime = Date.now();
        const major = versionInfo.getMajor();
        console.log("===== XMPVersionInfo.getMajor 接口耗时：" + (Date.now() - startTime) / 10 + "ms");
        startTime = Date.now();
        const minor = versionInfo.getMinor();
        console.log("===== XMPVersionInfo.getMinor 接口耗时：" + (Date.now() - startTime) / 10 + "ms");
        startTime = Date.now();
        const micro = versionInfo.getMicro();
        console.log("===== XMPVersionInfo.getMicro 接口耗时：" + (Date.now() - startTime) / 10 + "ms");
        startTime = Date.now();
        const build = versionInfo.getBuild();
        console.log("===== XMPVersionInfo.getBuild 接口耗时：" + (Date.now() - startTime) / 10 + "ms");
        startTime = Date.now();
        const isDebug = versionInfo.isDebug();
        console.log("===== XMPVersionInfo.isDebug 接口耗时：" + (Date.now() - startTime) / 10 + "ms");
        startTime = Date.now();
        const messInfo = versionInfo.getMessage();
        console.log("===== XMPVersionInfo.getMessage 接口耗时：" + (Date.now() - startTime) / 10 + "ms");

        expect(versionInfo).not().assertNull();
        expect(major).assertEqual(cfgMajor);
        expect(minor).assertEqual(cfgMinor);
        expect(micro).assertEqual(cfgMicro);
        expect(build).assertEqual(cfgEngBuild);
        expect(isDebug).assertEqual(cfgDebug);
        expect(messInfo).assertContain('XMP Core');
      });
    });

    describe('getSchemaRegistry', () => {
      it('should return schema registry', 0, () => {
        let startTime = Date.now();
        const registry: XMPSchemaRegistry = XMPMetaFactory.getSchemaRegistry();
        console.log("===== XMPMetaFactory.getSchemaRegistry 接口耗时：" + (Date.now() - startTime) / 10 + "ms");
        expect(registry).not().assertNull();
      });
    });

    describe('create', () => {
      it('should create empty XMPMeta object', 0, () => {
        let startTime = Date.now();
        const meta: XMPMeta = XMPMetaFactory.create();
        console.log("===== XMPMetaFactory.create 接口耗时：" + (Date.now() - startTime) / 10 + "ms");
        expect(meta).not().assertNull();
      });
    });

    describe('parseFromString', () => {
      it('should parse valid RDF string', 0, () => {
        const emptyRDF = `<rdf:RDF xmlns:rdf='http://www.w3.org/1999/02/22-rdf-syntax-ns#'>
          <rdf:Description rdf:about='Test:Empty'></rdf:Description>
        </rdf:RDF>`;

        let startTime = Date.now();
        const meta = XMPMetaFactory.parseFromString(emptyRDF);
        console.log("===== XMPMetaFactory.parseFromString 接口耗时：" + (Date.now() - startTime) / 10 + "ms");
        expect(meta).not().assertNull();
      });
    });

    describe('serializeToString', () => {
      it('should serialize XMPMeta to string', 0, async () => {
        const meta = XMPMetaFactory.create();
        const registry = XMPMetaFactory.getSchemaRegistry();
        registry.registerNamespace(NS1, 'ns1');
        meta.setProperty(NS1, 'TestProp', 'Test Value');

        let startTime = Date.now();
        const result = await XMPMetaFactory.serializeToString(meta);
        console.log("===== XMPMetaFactory.serializeToString 接口耗时：" + (Date.now() - startTime) / 10 + "ms");
        expect(result).assertContain('rdf:RDF');
        expect(result).assertContain('Test Value');
      });
    });

    describe('serializeToBuffer', () => {
      it('should serialize XMPMeta to buffer', 0, async () => {
        const meta = XMPMetaFactory.create();
        const registry = XMPMetaFactory.getSchemaRegistry();
        registry.registerNamespace(NS1, 'ns1');
        meta.setProperty(NS1, 'Prop', 'Value');

        let startTime = Date.now();
        const buffer = await XMPMetaFactory.serializeToBuffer(meta);
        console.log("===== XMPMetaFactory.serializeToBuffer 接口耗时：" + (Date.now() - startTime) / 10 + "ms");
        expect(buffer).not().assertNull();
        expect(buffer.length).assertLarger(0);
      });
    });

    describe('reset', () => {
      it('should reset schema registry', 0, () => {
        const registry1 = XMPMetaFactory.getSchemaRegistry();
        registry1.registerNamespace('ns:custom/', 'custom');

        let startTime = Date.now();
        XMPMetaFactory.reset();
        console.log("===== XMPMetaFactory.reset 接口耗时：" + (Date.now() - startTime) / 10 + "ms");
        
        const registry2 = XMPMetaFactory.getSchemaRegistry();
        const prefix = registry2.getNamespacePrefix('ns:custom/');
        // 自定义命名空间应该被清除
        expect(prefix).assertNull();
      });
    });

    describe('parse', () => {
      it('should parse xmp element', 0, () => {
        /**const xmpPacket = `<?xpacket begin="ï»¿" id="W5M0MpCehiHzreSzNTczkc9d"?>
                  <x:xmpmeta xmlns:x="adobe:ns:meta/">
                    <rdf:RDF xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#">
                      <rdf:Description rdf:about="" xmlns:pdf="http://ns.adobe.com/pdf/1.3/">
                        <pdf:Keywords>测试,文档,PDF</pdf:Keywords>
                        <pdf:PDFVersion>1.7</pdf:PDFVersion>
                      </rdf:Description>
                    </rdf:RDF>
                  </x:xmpmeta><?xpacket end="w"?>`;*/

        const xmpPacket = `<?xpacket?><x:xmpmeta xmlns:x="adobe:ns:meta/"><rdf:RDF xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"><rdf:Description xmlns:pdf="http://ns.adobe.com/pdf/1.3/"><pdf:Keywords>t</pdf:Keywords></rdf:Description></rdf:RDF></x:xmpmeta><?xpacket end="w"?>`;

        const encoder = new util.TextEncoder();
        const arrayBuffer = encoder.encode(xmpPacket).buffer;
        let startTime = Date.now();
        const xmpMeta = XMPMetaFactory.parse(arrayBuffer);
        console.log("===== XMPMetaFactory.parse 接口耗时：" + (Date.now() - startTime) / 10 + "ms");
        let parseResult = false;
        if (xmpMeta) {
          parseResult = true;
        }

        expect(parseResult).assertTrue();
      });
    });

    describe('parseFromBuffer', () => {
      it('should parse from buffer', 0, () => {
        const xmpPacket = `<?xpacket?><x:xmpmeta xmlns:x="adobe:ns:meta/"><rdf:RDF xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"><rdf:Description xmlns:pdf="http://ns.adobe.com/pdf/1.3/"><pdf:Keywords>t</pdf:Keywords></rdf:Description></rdf:RDF></x:xmpmeta><?xpacket end="w"?>`;

        const encoder = new util.TextEncoder();
        const buffer = encoder.encode(xmpPacket);
        let startTime = Date.now();
        const xmpMeta = XMPMetaFactory.parseFromBuffer(buffer);
        console.log("===== XMPMetaFactory.parseFromBuffer 接口耗时：" + (Date.now() - startTime) / 10 + "ms");
        let buffParse = false;
        if (xmpMeta) {
          // 验证属性
          buffParse = xmpMeta.doesPropertyExist("http://ns.adobe.com/pdf/1.3/", "Keywords");
        }

        expect(buffParse).assertTrue();
      });
    });

    describe('serialize', () => {
      it('should serializing to a stream', 0, async () => {
        const xmp = XMPMetaFactory.create();
        const dcNS = 'http://purl.org/dc/elements/1.1/';

        // 添加一些测试属性
        xmp.setProperty(dcNS, 'title', 'TestDoc');
        xmp.setProperty(dcNS, 'creator', 'Tom');

        let serializeDataSize = 0;
        const mockStream = new MockOutputStream(1024 * 100);
        let startTime = Date.now();
        await XMPMetaFactory.serialize(xmp, mockStream);
        console.log("===== XMPMetaFactory.serialize 接口耗时：" + (Date.now() - startTime) / 10 + "ms");
        serializeDataSize = mockStream.getWrittenSize();

        expect(serializeDataSize).assertLarger(0);
      });
    });

  });
}


