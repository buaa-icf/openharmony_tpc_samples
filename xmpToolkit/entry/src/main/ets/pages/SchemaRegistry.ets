import { XMPConst} from '@ohos/xmp_toolkit';
import { XMPMetaFactory } from '@ohos/xmp_toolkit';

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

// 添加命名空间测试用例类
class NamespaceTestCase {
  public ns: string = '';
  public desc: string = '';

  constructor(ns: string, desc: string) {
    this.ns = ns;
    this.desc = desc;
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
  private readonly NS2 = 'ns:test2/';

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

    // 注册测试命名空间
    const registry = XMPMetaFactory.getSchemaRegistry();
    registry.registerNamespace(this.NS1, 'ns1');
    registry.registerNamespace(this.NS2, 'ns2');

    // 3个测试项目
    await this.test01_NameSpaceMethods();
    await this.test02_AliasMethods();
    await this.test03_FindAliasMethods();
  }

  async test01_NameSpaceMethods() {
    this.currentTest = '[1/3] 命名空间';
    try {
      const registry = XMPMetaFactory.getSchemaRegistry();

      // 测试预定义命名空间
      const dcPrefix = registry.getNamespacePrefix(XMPConst.NS_DC);
      const ns1URI = registry.getNamespaceURI('ns1:');

      const namespacesMap = registry.getNamespaces();
      // 验证映射大小至少包含注册的两个命名空间
      const size = namespacesMap.size;

      const ns1Space = namespacesMap.get(this.NS1);
      const ns2Space = namespacesMap.get(this.NS2);

      // 获取前缀映射
      const prefixesMap = registry.getPrefixes();
      const sizePrefix = prefixesMap.size;
      const expectPrefixSize = sizePrefix === size;
      const ns1Prefix = prefixesMap.get('ns1:');
      const ns2Prefix = prefixesMap.get('ns2:');

      const namespacesBefore = registry.getNamespaces();
      const sizeBefore = namespacesBefore.size;
      registry.deleteNamespace(this.NS1);
      const namespacesAfter = registry.getNamespaces();
      const hasNS1After = namespacesAfter.has(this.NS1);
      const sizeAfter = namespacesAfter.size;
      const deletePassed = !hasNS1After && sizeAfter === sizeBefore - 1;

      const passed = dcPrefix === 'dc:' && ns1URI === this.NS1 &&
        ns1Space === 'ns1:' && ns2Space === 'ns2:' &&
        ns1Prefix === this.NS1 && ns2Prefix === this.NS2 && expectPrefixSize &&
        deletePassed;

      let message = '命名空间大小=' + size + ', 命名空间前缀=' + dcPrefix + ', 命名空间URI=' + ns1URI;
      message += ', 命名空间映射1=' + ns1Space + ', 命名空间映射2=' + ns2Space;
      message += ', 前缀映射1=' + ns1Prefix + ', 前缀映射2=' + ns2Prefix;
      message += ', 删除命名空间前大小=' + sizeBefore + ', 删除命名空间后大小=' + sizeAfter;
      this.addResult('1. 命名空间', passed, message);
    } catch (e) {
      this.addResult('1. 命名空间', false, (e as Error).message);
    }
  }

  async test02_AliasMethods() {
    this.currentTest = '[2/3] 映射别名';
    try {
      const registry = XMPMetaFactory.getSchemaRegistry();
      const aliases = registry.getAliases();
      const aliasesSize = aliases.size > 0;

      let foundAlias = false;
      let testDetails = '';

      if (aliases.size > 0) {
        // 获取所有别名键
        const aliasKeys = Array.from(aliases.keys());
        const testCount = Math.min(3, aliasKeys.length);
        for (let i = 0; i < testCount; i++) {
          const qname = aliasKeys[i];
          const aliasInfo = aliases.get(qname);

          if (aliasInfo !== undefined) {
            foundAlias = true;
            const namespace = aliasInfo.getNamespace();
            const propName = aliasInfo.getPropName();

            const resolved = registry.resolveAlias(namespace, propName);
            if (resolved !== null) {
              testDetails += `  别名 ${i+1}: ${qname}\n`;
              testDetails += `  命名空间: ${namespace}\n`;
              testDetails += `  属性名: ${propName}\n`;
              testDetails += `  前缀: ${aliasInfo.getPrefix()}\n`;
              testDetails += `  别名形式: ${aliasInfo.getAliasForm()}\n`;
            } else {
              testDetails += `别名 ${i+1}: ${qname} (resolveAlias返回null)\n`;
            }
          }
        }
      } else {
        testDetails += '没有找到已注册的别名\n';
      }

      const passed = foundAlias || aliasesSize;

      let message = testDetails;
      this.addResult('2. 映射别名', passed, message);
    } catch (e) {
      this.addResult('2. 映射别名', false, (e as Error).message);
    }
  }

  async test03_FindAliasMethods() {
    this.currentTest = '[3/3] 查找别名';
    try {
      const registry = XMPMetaFactory.getSchemaRegistry();
      let testDetails = '';
      let testPassed = false;

      // 获取所有别名
      const aliases = registry.getAliases();

      if (aliases.size > 0) {
        // 如果有别名，获取第一个别名
        const firstQName = Array.from(aliases.keys())[0];
        const aliasInfo = registry.findAlias(firstQName);

        if (aliasInfo !== null) {
          testDetails += `命名空间: ${aliasInfo.getNamespace()}\n`;
          testDetails += `别名: ${firstQName}\n`;

          testPassed = true;
        }
      } else {
        testDetails += `没有找到别名!`;
      }

      testDetails += `\n查找全部别名:`;
      let findAliases = false;

      const testNamespaces: NamespaceTestCase[] = [
        new NamespaceTestCase('ns:test1/xap/1.0/', 'XMP 命名空间'),
        new NamespaceTestCase(XMPConst.NS_DC, 'Dublin Core 命名空间'),
        new NamespaceTestCase(XMPConst.NS_XMP_RIGHTS, 'XMP Rights 命名空间'),
        new NamespaceTestCase('urn:test1/', '不存在的命名空间')
      ];

      for (const testNS of testNamespaces) {
        // 首先获取命名空间的前缀
        const prefix = registry.getNamespacePrefix(testNS.ns);
        testDetails += `${testNS.desc} `;

        if (prefix !== null) {
          const aliases = registry.findAliases(testNS.ns);
          testDetails += `找到 ${aliases.length} 个别名\n`;

          // 验证每个别名的命名空间正确
          for (const aliasInfo of aliases) {
            const namespace = aliasInfo.getNamespace();
            const propName = aliasInfo.getPropName();

            // 检查别名信息是否完整
            if (!namespace || !propName) {
              testDetails += `错误: 别名信息不完整\n`;
            } else {
              testDetails += `别名: ${namespace}${propName}\n`;
              findAliases = true;
            }
          }

        } else {
          const aliases = registry.findAliases(testNS.ns);
          if (aliases.length > 0) {
            for (const aliasInfo of aliases) {
              testDetails += `无前缀,别名: ${aliasInfo.getNamespace()}${aliasInfo.getPropName()}\n`;
              findAliases = true;
            }
          }
        }

        testDetails += '\n';
      }

      const passed = testPassed && findAliases;
      let message = `查找特定别名:\n${testDetails}`;
      this.addResult('3. 查找别名', passed, message);

    } catch (e) {
      this.addResult('3. 查找别名', false, (e as Error).message);
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
                    .maxLines(12)
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