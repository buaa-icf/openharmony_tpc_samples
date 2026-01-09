import { XMPMetaFactory } from '@ohos/xmp_toolkit';
import { SerializeOptions } from '@ohos/xmp_toolkit';
import { ParseOptions } from '@ohos/xmp_toolkit';
import { util } from '@kit.ArkTS';

/**
 * 测试结果项
 */
class TestResult {
  public name: string = '';
  public passed: boolean = false;
  public message: string = '';

  constructor(name: string, passed: boolean, message: string) {
    this.name = name;
    this.passed = passed;
    this.message = message;
  }
}

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

@Entry
@Component
struct Index {
  @State message: string = '点击运行测试';
  @State isRunning: boolean = false;
  @State testResults: TestResult[] = [];
  @State totalTests: number = 0;
  @State passedTests: number = 0;
  @State failedTests: number = 0;
  @State currentTest: string = '';

  private readonly NS1 = 'ns:test1/';
  private readonly NS_RDF = 'w3.org/1999/02/22-rdf-syntax-ns#';
  private readonly NS_PDF = 'ns.adobe.com/pdf/1.3/';

  addResult(name: string, passed: boolean, message: string) {
    this.testResults.push(new TestResult(name, passed, message));
    this.totalTests++;
    if (passed) {
      this.passedTests++;
    } else {
      this.failedTests++;
    }
  }

  async runAllTests() {
    this.testResults = [];
    this.totalTests = 0;
    this.passedTests = 0;
    this.failedTests = 0;

    // 2个测试项目
    await this.test01_xmpParse();
    await this.test02_serializeMethods();
    await this.test03_otherMethods();
  }

  async test01_xmpParse() {
    this.currentTest = '[1/3] xmp字符串解析';
    try {
      const protocol = 'http:';
      const rdfNS = protocol + '//www.w3.org/1999/02/22-rdf-syntax-ns#';
      const pdfNS = protocol + '//ns.adobe.com/pdf/1.3/';

      const xmpPacket = `
      <?xpacket begin="ï»¿" id="W5M0MpCehiHzreSzNTczkc9d"?>
      <x:xmpmeta xmlns:x="adobe:ns:meta/" x:xmptk="Adobe XMP Core 5.6-c148 79.164036, 2019/08/13-01:06:57        ">
        <rdf:RDF xmlns:rdf="${rdfNS}">
          <rdf:Description rdf:about=""
            xmlns:pdf="${pdfNS}">
            <pdf:Keywords>测试,文档,PDF</pdf:Keywords>
            <pdf:PDFVersion>1.7</pdf:PDFVersion>
          </rdf:Description>
        </rdf:RDF>
      </x:xmpmeta>
      <?xpacket end="w"?>`;

      let testDetails = '解析的属性: \n';
      const xmpMeta1 = XMPMetaFactory.parseFromString(xmpPacket);

      let simpleParse = false;
      if (xmpMeta1) {
        const pdfVersion = xmpMeta1.getPropertyString(pdfNS, 'PDFVersion');
        const keywords = xmpMeta1.getPropertyString(pdfNS, 'Keywords');
        testDetails += 'PDFVersion 属性=' + pdfVersion;
        testDetails += '\nKeywords 属性=' + keywords;
        simpleParse = pdfVersion === '1.7';
      }

      const parseOptions = new ParseOptions();
      parseOptions.setStrictParsing(false);
      const xmpMeta2 = XMPMetaFactory.parseFromString(xmpPacket, parseOptions);
      let optionParse = false;
      if (xmpMeta2) {
        optionParse = true;
      }

      const encoder = new util.TextEncoder();
      const buffer = encoder.encode(xmpPacket);
      const xmpMeta3 = XMPMetaFactory.parseFromBuffer(buffer);
      let buffParse = false;
      if (xmpMeta3) {
        // 验证属性
        buffParse = xmpMeta3.doesPropertyExist(pdfNS, 'PDFVersion');
      }

      const xmpMeta4 = XMPMetaFactory.parseFromBuffer(buffer, parseOptions);
      let optionBuffParse = false;
      if (xmpMeta4) {
        // 验证属性
        optionBuffParse = xmpMeta4.doesPropertyExist(pdfNS, 'Keywords');
      }

      const arrayBuffer = encoder.encode(xmpPacket).buffer;
      const xmpMeta5 = XMPMetaFactory.parse(arrayBuffer);
      let parseResult = false;
      if (xmpMeta5) {
        parseResult = true;
      }

      const xmpMeta6 = XMPMetaFactory.parse(arrayBuffer, parseOptions);
      let optionParseResult = false;
      if (xmpMeta6) {
        optionParseResult = true;
      }

      const passed =  simpleParse && optionParse && buffParse &&
        optionBuffParse &&  parseResult && optionParseResult;

      let message = testDetails;
      this.addResult('1. xmp字符串解析', passed, message);
    } catch (e) {
      this.addResult('1. xmp字符串解析', false, (e as Error).message);
    }
  }

  async test02_serializeMethods() {
    this.currentTest = '[2/3] 序列化';
    try {
      const protocol = 'http:';
      const rdfNS = protocol + '//www.w3.org/1999/02/22-rdf-syntax-ns#';
      const SIMPLE_RDF: string = `<rdf:RDF xmlns:rdf="${rdfNS}">
                  <rdf:Description rdf:about="Test:XMPCoreCoverage/kSimpleRDF" xmlns:ns1="ns:test1/"
                    xmlns:ns2="ns:test2/">
                      <ns1:SimpleProp>Simple value</ns1:SimpleProp>
                      <ns1:ArrayProp>
                         <rdf:Bag>
                          <rdf:li>Item1 value</rdf:li>
                          <rdf:li>Item2 value</rdf:li>
                         </rdf:Bag>
                      </ns1:ArrayProp>
                      <ns1:StructProp rdf:parseType="Resource">
                        <ns2:Field1>Field1 value</ns2:Field1>
                        <ns2:Field2>Field2 value</ns2:Field2>
                      </ns1:StructProp>
                      <ns1:QualProp rdf:parseType="Resource">
                      <rdf:value>Prop value</rdf:value>
                      <ns2:Qual>Qual value</ns2:Qual>
                      </ns1:QualProp>
                    <ns1:AltTextProp>
                      <rdf:Alt>
                        <rdf:li xml:lang="x-one">x-one value</rdf:li>
                        <rdf:li xml:lang="x-two">x-two value</rdf:li>
                      </rdf:Alt>
                    </ns1:AltTextProp>
                    <ns1:ArrayOfStructProp>
                      <rdf:Bag>
                        <rdf:li rdf:parseType="Resource">
                          <ns2:Field1>Item-1</ns2:Field1>
                          <ns2:Field2>Field 1.2 value</ns2:Field2>
                      </rdf:li>
                    <rdf:li rdf:parseType="Resource">
                   <ns2:Field1>Item-2</ns2:Field1>
                  <ns2:Field2>Field 2.2 value</ns2:Field2>
                </rdf:li>
              </rdf:Bag>
            </ns1:ArrayOfStructProp>
          </rdf:Description>
        </rdf:RDF>`;

      const meta = XMPMetaFactory.parseFromString(SIMPLE_RDF);

      // 添加一些测试属性
      meta.setProperty(this.NS1, 'title', 'TestDoc');
      meta.setProperty(this.NS1, 'creator', 'Tom');

      const serializedString = await XMPMetaFactory.serializeToString(meta);
      let isValidXML = false;
      if (serializedString && typeof serializedString === 'string') {
        isValidXML = serializedString.includes('rdf:RDF');
      }

      const serializeOptions = new SerializeOptions();
      const bufferResult = await XMPMetaFactory.serializeToBuffer(meta);
      let isValidBuf = false;
      if (bufferResult && bufferResult instanceof Uint8Array) {

        const decoder = new util.TextDecoder('utf-8');
        const bufferAsString = decoder.decode(bufferResult);
        const containsProperties = bufferAsString.includes('TestDoc');
        isValidBuf = containsProperties;
      }

      const bufferWithOptions = await XMPMetaFactory.serializeToBuffer(meta, serializeOptions);
      let isValidOptionBuf = false;
      if (bufferWithOptions && bufferWithOptions instanceof Uint8Array) {
        isValidOptionBuf = true;
      }

      let serializeSuccess = false;
      let serializeDataSize = 0;
      let hasData = false;

      const mockStream = new MockOutputStream(1024 * 100);
      await XMPMetaFactory.serialize(meta, mockStream);
      const writtenData = mockStream.getWrittenData();
      serializeDataSize = mockStream.getWrittenSize();

      if (serializeDataSize > 0) {
        serializeSuccess = true;
        hasData = true;

        const decoder = new util.TextDecoder('utf-8');
        const dataString = decoder.decode(writtenData);
      }

      let serializeStream = 0;
      let serializeSResult = false;
      let serializeStr = '';
      await XMPMetaFactory.serialize(meta, mockStream, serializeOptions);
      const serialData = mockStream.getWrittenData();
      serializeStream = mockStream.getWrittenSize();
      if (serializeStream > 0) {
        serializeSResult = true;

        const optionDcoder = new util.TextDecoder('utf-8');
        serializeStr = optionDcoder.decode(serialData);
      }

      const passed = isValidXML && isValidBuf &&
        isValidOptionBuf && serializeSuccess && hasData && serializeSResult;

      let message = '序列化成功\n';
      message += '序列化为字符串= ' + serializedString;
      message += '\n序列化为流= ' + serializeStr;
      this.addResult('2. 序列化', passed, message);
    } catch (e) {
      this.addResult('2. 序列化', false, (e as Error).message);
    }
  }

  async test03_otherMethods() {
    this.currentTest = '[3/3] 其他';
    try {
      const versionInfo = XMPMetaFactory.getVersionInfo();
      if (!versionInfo) {
        this.addResult('获取版本信息对象', false, '版本信息对象为 null 或 undefined');
        return;
      }

      const majorVersion = versionInfo.getMajor();
      const minorVersion = versionInfo.getMinor();
      const versionMessage = versionInfo.getMessage();
      const versionPass =  typeof minorVersion === 'number' &&
        typeof majorVersion === 'number' ;

      const beforeResetSchema = XMPMetaFactory.getSchemaRegistry();
      const beforeResetVersion = XMPMetaFactory.getVersionInfo();

      // 执行 reset
      XMPMetaFactory.reset();
      const afterResetSchema = XMPMetaFactory.getSchemaRegistry();
      const afterResetVersion = XMPMetaFactory.getVersionInfo();
      const schemaChanged = beforeResetSchema !== afterResetSchema;
      const versionUnchanged = beforeResetVersion === afterResetVersion;

      const passed = versionPass && schemaChanged && versionUnchanged;

      let message = '接口reset和getVersionInfo调用成功';
      this.addResult('3. 其他', passed, message);
    } catch (e) {
      this.addResult('3. 其他', false, (e as Error).message);
    }
  }

  build() {
    Column() {
      // 标题
      Text('xmp_toolkit 自动化接口测试')
        .fontSize(20)
        .fontWeight(FontWeight.Bold)
        .margin({ top: 12, bottom: 12 })

      // 运行按钮
      Button(this.isRunning ? `${this.currentTest}` : this.message)
        .fontSize(14)
        .fontWeight(FontWeight.Bold)
        .width('85%')
        .height(44)
        .enabled(!this.isRunning)
        .onClick(async () => {
          this.isRunning = true;
          this.message = '测试中...';
          try {
            await this.runAllTests();
            this.message = '重新运行测试';
          } catch (e) {
            this.message = '测试出错，点击重试';
          } finally {
            this.isRunning = false;
            this.currentTest = '';
          }
        })
        .margin({ bottom: 12 })

      // 统计信息
      if (this.totalTests > 0) {
        Row() {
          Text(`总计: ${this.totalTests}`)
            .fontSize(13)
            .margin({ right: 12 })
          Text(`✅ ${this.passedTests}`)
            .fontSize(13)
            .fontColor('#00AA00')
            .margin({ right: 12 })
          Text(`❌ ${this.failedTests}`)
            .fontSize(13)
            .fontColor('#FF0000')
        }
        .margin({ bottom: 8 })

        // 总体结果
        Text(this.failedTests === 0 ? '🎉 全部通过!' : `⚠️ ${this.failedTests}项失败`)
          .fontSize(16)
          .fontWeight(FontWeight.Bold)
          .fontColor(this.failedTests === 0 ? '#00AA00' : '#FF6600')
          .margin({ bottom: 10 })
      }

      // 测试结果列表
      if (this.testResults.length > 0) {
        List() {
          ForEach(this.testResults, (item: TestResult) => {
            ListItem() {
              Row() {
                Text(item.passed ? '✅' : '❌')
                  .fontSize(14)
                  .margin({ right: 6 })
                Column() {
                  Text(item.name)
                    .fontSize(13)
                    .fontWeight(FontWeight.Medium)
                  Text(item.message)
                    .fontSize(10)
                    .fontColor(item.passed ? '#666666' : '#FF0000')
                    .maxLines(60)
                    .textOverflow({ overflow: TextOverflow.Ellipsis })
                }
                .alignItems(HorizontalAlign.Start)
                .layoutWeight(1)
              }
              .width('100%')
              .padding({ top: 6, bottom: 6, left: 10, right: 10 })
              .backgroundColor(item.passed ? '#F0FFF0' : '#FFF0F0')
              .borderRadius(4)
            }
            .margin({ bottom: 4 })
          })
        }
        .width('94%')
        .layoutWeight(1)
        .divider({ strokeWidth: 0 })
      }
    }
    .width('100%')
    .height('100%')
    .padding({ left: 10, right: 10, top: 6, bottom: 6 })
  }
}
