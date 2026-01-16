import { XMPMetaFactory, SerializeOptions, ParseOptions } from '@ohos/xmp_toolkit';
import { util } from '@kit.ArkTS';

/**
 * 测试结果项
 */
class TestResult {
  public name: string = '';
  public success: boolean = false;
  public input: string = '';
  public output: string = '';
  public error: string = '';
  public timestamp: string = '';

  constructor(name: string, success: boolean, input: string = '', output: string = '', error: string = '') {
    this.name = name;
    this.success = success;
    this.input = input;
    this.output = output;
    this.error = error;
    this.timestamp = new Date().toLocaleTimeString();
  }
}

/**
 * 模拟输出流类，用于测试 serialize 方法
 */
class MockOutputStream {
  private buffer: ArrayBuffer;
  private position: number = 0;

  constructor(size: number = 1024 * 1024) {
    this.buffer = new ArrayBuffer(size);
  }

  async write(data: string): Promise<void> {
    console.info(`MockOutputStream.write called, data length: ${data.length}`);

    const encoder = new util.TextEncoder();
    const dataBytes = encoder.encode(data);

    if (this.position + dataBytes.length > this.buffer.byteLength) {
      const newBuffer = new ArrayBuffer(Math.max(this.buffer.byteLength * 2, this.position + dataBytes.length));
      const newView = new Uint8Array(newBuffer);
      newView.set(new Uint8Array(this.buffer, 0, this.position));
      this.buffer = newBuffer;
    }

    const targetView = new Uint8Array(this.buffer, this.position);
    targetView.set(dataBytes);
    this.position += dataBytes.length;
  }

  getWrittenData(): Uint8Array {
    return new Uint8Array(this.buffer, 0, this.position);
  }

  clear(): void {
    this.position = 0;
  }
}

@Entry
@Component
struct XMPTestPage {
  @State testResults: TestResult[] = [];
  @State currentInput: string = '';
  @State currentOutput: string = '';
  @State isLoading: boolean = false;
  @State activeTab: string = 'parse';
  @State parseOptions: ParseOptions = new ParseOptions();
  @State serializeOptions: SerializeOptions = new SerializeOptions();

  // 元数据解析默认值
  private protocol = 'http:';
  private rdfNS = this.protocol + '//www.w3.org/1999/02/22-rdf-syntax-ns#';
  private pdfNS = this.protocol + '//ns.adobe.com/pdf/1.3/';
  private parseDefaultXMP: string = `<?xpacket begin="ï»¿" id="W5M0MpCehiHzreSzNTczkc9d"?>
   <x:xmpmeta xmlns:x="adobe:ns:meta/" x:xmptk="Adobe XMP Core 5.6-c148 79.164036, 2019/08/13-01:06:57        ">
    <rdf:RDF xmlns:rdf="${this.rdfNS}">
      <rdf:Description rdf:about=""
        xmlns:pdf="${this.pdfNS}">
        <pdf:Keywords>测试,文档,PDF</pdf:Keywords>
        <pdf:PDFVersion>1.7</pdf:PDFVersion>
      </rdf:Description>
    </rdf:RDF>
  </x:xmpmeta>
  <?xpacket end="w"?>`;

  // 元数据序列化默认值
  private serializeDefaultXMP: string = `<rdf:RDF xmlns:rdf="${this.rdfNS}">
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

  // 初始化示例数据
  aboutToAppear(): void {
    // 页面初次加载时设置默认值
    this.currentInput = this.parseDefaultXMP;
  }

  // 输入参数验证
  private validateInput(): boolean {
    if (!this.currentInput || this.currentInput.trim() === '') {
      this.currentOutput = '❌ 错误: 输入数据不能为空';
      this.addResult(new TestResult('输入验证', false, '', '', '输入数据不能为空'));
      return false;
    }
    return true;
  }

  // 根据标签页更新输入
  private updateInputBasedOnTab(): void {
    if (this.activeTab === 'parse') {
      this.currentInput = this.parseDefaultXMP;
    } else {
      this.currentInput = this.serializeDefaultXMP;
    }
  }

  // 添加测试结果
  private addResult(result: TestResult): void {
    this.testResults.unshift(result); // 最新结果显示在最前面
    if (this.testResults.length > 20) {
      this.testResults.pop(); // 最多保留20条记录
    }
  }

  // 清空测试结果
  private clearResults(): void {
    this.testResults = [];
  }

  // 清空输出
  private clearOutput(): void {
    this.currentOutput = '';
  }

  // 测试 parse 方法
  private async testParse(): Promise<void> {
    // 输入验证
    if (!this.validateInput()) {
      return;
    }

    this.isLoading = true;
    this.clearOutput();

    try {
      const arrayBuffer = new util.TextEncoder().encode(this.currentInput).buffer;
      const xmpMeta = XMPMetaFactory.parse(arrayBuffer, this.parseOptions);

      let output = '✅ 从输入流解析 成功\n';
      output += `对象类型: ${typeof xmpMeta}\n`;
      output += `是否有效: ${xmpMeta ? '是' : '否'}\n`;

      // 尝试获取一些属性来验证
      if (xmpMeta) {
        const prefix = 'http:';
        const rulNS = prefix + '//ns.adobe.com/pdf/1.3/';
        const keywords = xmpMeta.getPropertyString(rulNS, 'Keywords');
        const pdfVersion = xmpMeta.getPropertyString(rulNS, 'PDFVersion');
        output += `PDF关键词: ${keywords || '未找到'}\n`;
        output += `PDF版本: ${pdfVersion || '未找到'}\n`;
      }

      this.currentOutput = output;
      this.addResult(new TestResult('从输入流解析', true, `输入长度: ${this.currentInput.length}`, output));
    } catch (error) {
      const errorMsg = (error as Error).message;
      this.currentOutput = `❌ 从输入流解析 失败\n${errorMsg}`;
      this.addResult(new TestResult('从输入流解析', false, `输入长度: ${this.currentInput.length}`, '', errorMsg));
    } finally {
      this.isLoading = false;
    }
  }

  // 测试 parseFromString 方法
  private async testParseFromString(): Promise<void> {
    // 输入验证
    if (!this.validateInput()) {
      return;
    }

    this.isLoading = true;
    this.clearOutput();

    try {
      const xmpMeta = XMPMetaFactory.parseFromString(this.currentInput, this.parseOptions);

      let output = '✅ 从字符串解析 成功\n';
      output += `对象类型: ${typeof xmpMeta}\n`;
      output += `是否有效: ${xmpMeta ? '是' : '否'}\n`;

      if (xmpMeta) {
        const prefix = 'http:';
        const rulNS = prefix + '//ns.adobe.com/pdf/1.3/';
        const keywords = xmpMeta.getPropertyString(rulNS, 'Keywords');
        const pdfVersion = xmpMeta.getPropertyString(rulNS, 'PDFVersion');
        output += `PDF关键词: ${keywords || '未找到'}\n`;
        output += `PDF版本: ${pdfVersion || '未找到'}\n`;
      }

      this.currentOutput = output;
      this.addResult(new TestResult('从字符串解析', true, `输入长度: ${this.currentInput.length}`, output));
    } catch (error) {
      const errorMsg = (error as Error).message;
      this.currentOutput = `❌ 从字符串解析 失败\n${errorMsg}`;
      this.addResult(new TestResult('从字符串解析', false, `输入长度: ${this.currentInput.length}`, '', errorMsg));
    } finally {
      this.isLoading = false;
    }
  }

  // 测试 parseFromBuffer 方法
  private async testParseFromBuffer(): Promise<void> {
    // 输入验证
    if (!this.validateInput()) {
      return;
    }

    this.isLoading = true;
    this.clearOutput();

    try {
      const buffer = new util.TextEncoder().encode(this.currentInput);
      const xmpMeta = XMPMetaFactory.parseFromBuffer(buffer, this.parseOptions);

      let output = '✅ 从字节数组解析 成功\n';
      output += `对象类型: ${typeof xmpMeta}\n`;
      output += `是否有效: ${xmpMeta ? '是' : '否'}\n`;
      output += `输入buffer长度: ${buffer.length}\n`;

      if (xmpMeta) {
        const prefix = 'http:';
        const rulNS = prefix + '//ns.adobe.com/pdf/1.3/';
        const keywords = xmpMeta.getPropertyString(rulNS, 'Keywords');
        const pdfVersion = xmpMeta.getPropertyString(rulNS, 'PDFVersion');
        output += `PDF关键词: ${keywords || '未找到'}\n`;
        output += `PDF版本: ${pdfVersion || '未找到'}\n`;
      }

      this.currentOutput = output;
      this.addResult(new TestResult('从字节数组解析', true, `输入长度: ${this.currentInput.length}`, output));
    } catch (error) {
      const errorMsg = (error as Error).message;
      this.currentOutput = `❌ 从字节数组解析 失败\n${errorMsg}`;
      this.addResult(new TestResult('从字节数组解析', false, `输入长度: ${this.currentInput.length}`, '', errorMsg));
    } finally {
      this.isLoading = false;
    }
  }

  // 测试 serialize 方法
  private async testSerialize(): Promise<void> {
    // 输入验证
    if (!this.validateInput()) {
      return;
    }

    this.isLoading = true;
    this.clearOutput();

    try {
      // 先解析一个 XMP 对象
      const xmpMeta = XMPMetaFactory.parseFromString(this.currentInput);
      if (!xmpMeta) {
        throw new Error('无法解析输入数据');
      }

      // 创建输出流
      const outputStream = new MockOutputStream();
      await XMPMetaFactory.serialize(xmpMeta, outputStream, this.serializeOptions);

      const writtenData = outputStream.getWrittenData();
      const decoder = new util.TextDecoder('utf-8');
      const serializedString = decoder.decode(writtenData);

      let output = '✅ 序列化到输出流 成功\n';
      output += `序列化数据长度: ${writtenData.length} 字节\n`;
      output += `输出流类型: MockOutputStream\n`;
      output += `序列化结果预览: ${serializedString.substring(0, 200)}${serializedString.length > 200 ? '...' : ''}\n`;

      // 尝试解析序列化的结果验证格式
      try {
        const parsedFromSerialized = XMPMetaFactory.parseFromString(serializedString);
        if (parsedFromSerialized) {
          output += `✓ 序列化结果可以重新解析\n`;

          // 尝试获取一些属性验证
          const simpleProp = parsedFromSerialized.getPropertyString('ns:test1/', 'SimpleProp');
          if (simpleProp) {
            output += `重新解析的 SimpleProp: ${simpleProp}\n`;
          }
        }
      } catch (e) {
        output += `⚠ 序列化结果无法重新解析: ${(e as Error).message}\n`;
      }

      this.currentOutput = output;
      this.addResult(new TestResult('序列化到输出流', true, `输入长度: ${this.currentInput.length}`, output));
    } catch (error) {
      const errorMsg = (error as Error).message;
      this.currentOutput = `❌ 序列化到输出流 失败\n${errorMsg}`;
      this.addResult(new TestResult('序列化到输出流', false, `输入长度: ${this.currentInput.length}`, '', errorMsg));
    } finally {
      this.isLoading = false;
    }
  }

  // 测试 serializeToBuffer 方法
  private async testSerializeToBuffer(): Promise<void> {
    // 输入验证
    if (!this.validateInput()) {
      return;
    }

    this.isLoading = true;
    this.clearOutput();

    try {
      const xmpMeta = XMPMetaFactory.parseFromString(this.currentInput);
      if (!xmpMeta) {
        throw new Error('无法解析输入数据');
      }

      const buffer = await XMPMetaFactory.serializeToBuffer(xmpMeta, this.serializeOptions);

      let output = '✅ 序列化到字节数组 成功\n';
      output += `返回buffer类型: ${buffer.constructor.name}\n`;
      output += `buffer长度: ${buffer.length} 字节\n`;

      // 解码查看内容
      const decoder = new util.TextDecoder('utf-8');
      const bufferAsString = decoder.decode(buffer);
      output += `内容预览: ${bufferAsString.substring(0, 200)}${bufferAsString.length > 200 ? '...' : ''}\n`;

      // 尝试解析验证
      try {
        const parsedFromBuffer = XMPMetaFactory.parseFromBuffer(buffer);
        if (parsedFromBuffer) {
          output += `✓ 字节数组可以重新解析\n`;

          const altText = parsedFromBuffer.getPropertyString('ns:test1/', 'AltTextProp');
          if (altText) {
            output += `重新解析的 AltTextProp 存在\n`;
          }
        }
      } catch (e) {
        output += `⚠ 字节数组无法重新解析: ${(e as Error).message}\n`;
      }

      this.currentOutput = output;
      this.addResult(new TestResult('序列化到字节数组', true, `输入长度: ${this.currentInput.length}`, output));
    } catch (error) {
      const errorMsg = (error as Error).message;
      this.currentOutput = `❌ 序列化到字节数组 失败\n${errorMsg}`;
      this.addResult(new TestResult('序列化到字节数组', false, `输入长度: ${this.currentInput.length}`, '', errorMsg));
    } finally {
      this.isLoading = false;
    }
  }

  // 测试 serializeToString 方法
  private async testSerializeToString(): Promise<void> {
    // 输入验证
    if (!this.validateInput()) {
      return;
    }

    this.isLoading = true;
    this.clearOutput();

    try {
      const xmpMeta = XMPMetaFactory.parseFromString(this.currentInput);
      if (!xmpMeta) {
        throw new Error('无法解析输入数据');
      }

      const result = await XMPMetaFactory.serializeToString(xmpMeta, this.serializeOptions);

      let output = '✅ 序列化到字符串 成功\n';
      output += `返回类型: ${typeof result}\n`;
      output += `字符串长度: ${result.length} 字符\n`;
      output += `结果预览: ${result.substring(0, 200)}${result.length > 200 ? '...' : ''}\n`;

      // 验证序列化结果是否可以重新解析
      try {
        const parsedFromString = XMPMetaFactory.parseFromString(result);
        if (parsedFromString) {
          output += `✓ 序列化字符串可以重新解析\n`;

          const structProp = parsedFromString.getPropertyString('ns:test1/', 'StructProp');
          if (structProp) {
            output += `重新解析的 StructProp 存在\n`;
          }
        }
      } catch (e) {
        output += `⚠ 序列化字符串无法重新解析: ${(e as Error).message}\n`;
      }

      this.currentOutput = output;
      this.addResult(new TestResult('序列化到字符串', true, `输入长度: ${this.currentInput.length}`, output));
    } catch (error) {
      const errorMsg = (error as Error).message;
      this.currentOutput = `❌ 序列化到字符串 失败\n${errorMsg}`;
      this.addResult(new TestResult('序列化到字符串', false, `输入长度: ${this.currentInput.length}`, '', errorMsg));
    } finally {
      this.isLoading = false;
    }
  }

  build() {
    Column() {
      // 标题
      Text('元数据解析与序列化-测试')
        .fontSize(20)
        .fontWeight(FontWeight.Bold)
        .margin({ top: 12, bottom: 8 })

      Row() {
        ForEach(['parse', 'serialize'] as string[], (tab: string) => {
          Button(tab === 'parse' ? '元数据解析' : '元数据序列化')
            .fontSize(12)
            .padding({ left: 8, right: 8, top: 4, bottom: 4 })
            .backgroundColor(this.activeTab === tab ? '#007DFF' : '#F0F0F0')
            .fontColor(this.activeTab === tab ? '#FFFFFF' : '#000000')
            .borderRadius(4)
            .onClick(() => {
              this.activeTab = tab;
              this.updateInputBasedOnTab();
            })
            .margin({ right: 6 })
        })
      }
      .margin({ bottom: 12 })
      .justifyContent(FlexAlign.Start)
      .width('92%')

      // 输入区域
      Row() {
        Text('输入数据:')
          .fontSize(14)
          .fontWeight(FontWeight.Medium)
        Blank()
      }
      .margin({ left: 16, bottom: 4 })
      .width('92%')
      .justifyContent(FlexAlign.SpaceBetween)

      TextArea({ placeholder: '请输入XMP数据...', text: this.currentInput })
        .width('92%')
        .height(120)
        .fontSize(12)
        .backgroundColor('#FFFFFF')
        .border({ width: 1, color: '#CCCCCC', radius: 4 })
        .onChange((value: string) => {
          this.currentInput = value;
        })

      // 按钮区域
      if (this.activeTab === 'parse') {
        Column({ space: 8 }) {
          Button('从输入流解析')
            .fontSize(14)
            .width('92%')
            .height(40)
            .onClick(() => this.testParse())
            .enabled(!this.isLoading)
          Button('从字符串解析')
            .fontSize(14)
            .width('92%')
            .height(40)
            .onClick(() => this.testParseFromString())
            .enabled(!this.isLoading)
          Button('从字节数组解析')
            .fontSize(14)
            .width('92%')
            .height(40)
            .onClick(() => this.testParseFromBuffer())
            .enabled(!this.isLoading)
        }
        .margin({ top: 12, bottom: 8 })
        .width('92%')
      } else {
        // 序列化方法按钮 - 垂直布局
        Column({ space: 8 }) {
          Button('序列化到输出流')
            .fontSize(14)
            .width('92%')
            .height(40)
            .onClick(() => this.testSerialize())
            .enabled(!this.isLoading)
          Button('序列化到字节数组')
            .fontSize(14)
            .width('92%')
            .height(40)
            .onClick(() => this.testSerializeToBuffer())
            .enabled(!this.isLoading)
          Button('序列化到字符串')
            .fontSize(14)
            .width('92%')
            .height(40)
            .onClick(() => this.testSerializeToString())
            .enabled(!this.isLoading)
        }
        .margin({ top: 12, bottom: 8 })
        .width('92%')
      }

      // 输出区域
      Text('测试输出:')
        .fontSize(14)
        .fontWeight(FontWeight.Medium)
        .margin({ left: 16, top: 12, bottom: 4 })
        .width('92%')
        .textAlign(TextAlign.Start)

      Scroll() {
        Text(this.currentOutput)
          .fontSize(12)
          .fontColor('#333333')
          .backgroundColor('#F9F9F9')
          .border({ width: 1, color: '#EEEEEE', radius: 4 })
          .padding(8)
          .width('100%')
      }
      .height(150)
      .width('92%')
      .margin({ bottom: 12 })

      // 历史记录
      Row() {
        Text('测试历史记录')
          .fontSize(14)
          .fontWeight(FontWeight.Medium)
        Blank()
        Button('清空记录')
          .fontSize(10)
          .padding({ left: 8, right: 8, top: 2, bottom: 2 })
          .onClick(() => this.clearResults())
      }
      .width('92%')
      .margin({ bottom: 4 })
      .justifyContent(FlexAlign.SpaceBetween)

      // 历史记录列表
      Scroll() {
        Column() {
          ForEach(this.testResults, (result: TestResult) => {
            Column() {
              Row() {
                Text(result.success ? '✅' : '❌')
                  .fontSize(12)
                  .margin({ right: 6 })
                Text(result.name)
                  .fontSize(12)
                  .fontWeight(FontWeight.Medium)
                  .fontColor(result.success ? '#00AA00' : '#FF0000')
                Blank()
                Text(result.timestamp)
                  .fontSize(10)
                  .fontColor('#666666')
              }
              .width('100%')
              .margin({ bottom: 4 })
              .justifyContent(FlexAlign.SpaceBetween)

              if (result.error) {
                Text(`错误: ${result.error}`)
                  .fontSize(10)
                  .fontColor('#FF0000')
                  .margin({ bottom: 4 })
                  .width('100%')
                  .textAlign(TextAlign.Start)
              }

              if (result.output) {
                Text(`输出: ${result.output.substring(0, 100)}${result.output.length > 100 ? '...' : ''}`)
                  .fontSize(10)
                  .fontColor('#666666')
                  .margin({ bottom: 4 })
                  .width('100%')
                  .textAlign(TextAlign.Start)
              }

              Divider()
                .strokeWidth(0.5)
                .color('#EEEEEE')
                .margin({ top: 4, bottom: 4 })
            }
            .width('100%')
            .padding(8)
            .backgroundColor(result.success ? '#F0FFF0' : '#FFF0F0')
            .borderRadius(4)
            .margin({ bottom: 4 })
          })
        }
        .width('100%')
      }
      .height(200)
      .width('92%')
      .margin({ bottom: 12 })

      // 加载指示器
      if (this.isLoading) {
        Row() {
          LoadingProgress()
            .width(20)
            .height(20)
          Text('测试中...')
            .fontSize(12)
            .fontColor('#666666')
            .margin({ left: 8 })
        }
        .margin({ bottom: 12 })
        .justifyContent(FlexAlign.Center)
        .width('100%')
      }
    }
    .width('100%')
    .height('100%')
    .alignItems(HorizontalAlign.Center)
    .backgroundColor('#F5F5F5')
  }
}