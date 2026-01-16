import { XMPMetaFactory, XMPConst } from '@ohos/xmp_toolkit';
import type { XMPSchemaRegistry, XMPAliasInfo } from '@ohos/xmp_toolkit';

@Entry
@Component
struct EnhancedSchemaRegistryDemo {
  @State message: string = 'SchemaRegistry';

  // 当前操作状态
  @State currentAction: string = 'register'; // register, query, alias

  // 注册命名空间操作 - 修改：使用内部URI格式
  @State namespaceUri: string = 'urn:example:custom:ns:';
  @State namespacePrefix: string = 'custom';
  @State namespaceResult: string = '';
  @State allNamespaces: [string, string][] = [];

  // 查询命名空间操作
  @State queryInput: string = '';
  @State queryResult: string = '';
  @State queryResultType: string = ''; // 'uri' 或 'prefix'
  @State queryFoundItem: string = ''; // 查询到的项目

  // 查找别名操作
  @State aliasInput: string = '';
  @State aliasResult: string = '';
  @State aliasFoundInfo: XMPAliasInfo | null = null;
  @State allAliases: [string, string][] = [];
  @State showAllAliases: boolean = false; // 是否显示所有别名

  // 数据统计
  @State namespacesCount: number = 0;
  @State aliasesCount: number = 0;

  // 计数器用于生成唯一标识
  private counter: number = 1;

  // 获取注册表实例
  private getRegistry(): XMPSchemaRegistry {
    return XMPMetaFactory.getSchemaRegistry();
  }

  // 1. 注册命名空间
  registerNamespace() {
    // 清除之前的错误提示
    this.namespaceResult = '';

    const uri = this.namespaceUri;
    const prefix = this.namespacePrefix;

    // 检查URI和前缀是否为空
    if (!uri || !uri.trim()) {
      this.namespaceResult = '⚠️ URI不能为空';
      return;
    }

    if (!prefix || !prefix.trim()) {
      this.namespaceResult = '⚠️ 前缀不能为空';
      return;
    }

    try {
      const registry = this.getRegistry();
      registry.registerNamespace(uri.trim(), prefix.trim());

      // 注册成功后清空输入框
      this.namespaceUri = 'urn:example:custom:ns:';
      this.namespacePrefix = 'custom';
      this.namespaceResult = '';

      this.updateCounts();
      this.loadAllNamespaces();
    } catch (e) {
      this.namespaceResult = `❌ 注册失败: ${(e as Error).message}`;
    }
  }

  // 2. 查询操作
  performQuery() {
    // 清除之前的查询结果
    this.queryResult = '';
    this.queryResultType = '';
    this.queryFoundItem = '';

    // 检查输入是否为空
    const input = this.queryInput;
    if (!input || !input.trim()) {
      this.queryResult = '⚠️ 请输入要查询的内容';
      return;
    }

    try {
      const registry = this.getRegistry();

      // 尝试作为URI查询前缀
      let prefix = registry.getNamespacePrefix(input.trim());
      if (prefix) {
        this.queryResult = `✅ 找到前缀:\nURI: ${input}\n前缀: ${prefix}`;
        this.queryResultType = 'uri';
        this.queryFoundItem = input.trim();
        return;
      }

      // 尝试作为前缀查询URI
      let uri = registry.getNamespaceURI(input.trim());
      if (uri) {
        this.queryResult = `✅ 找到URI:\n前缀: ${input}\nURI: ${uri}`;
        this.queryResultType = 'prefix';
        this.queryFoundItem = input.trim();
        return;
      }

      this.queryResult = `⚠️ 未找到: ${input}`;
    } catch (e) {
      this.queryResult = `❌ 查询失败: ${(e as Error).message}`;
    }
  }

  // 3. 删除查询到的命名空间
  deleteQueriedNamespace() {
    if (!this.queryFoundItem || !this.queryResultType) {
      return;
    }

    try {
      const registry = this.getRegistry();

      if (this.queryResultType === 'uri') {
        // 删除URI对应的命名空间
        registry.deleteNamespace(this.queryFoundItem);
        this.queryResult = `✅ 删除成功！\n已删除命名空间: ${this.queryFoundItem}`;
      } else if (this.queryResultType === 'prefix') {
        // 先获取前缀对应的URI，然后删除
        const uri = registry.getNamespaceURI(this.queryFoundItem);
        if (uri) {
          registry.deleteNamespace(uri);
          this.queryResult = `✅ 删除成功！\n前缀: ${this.queryFoundItem}\n对应URI: ${uri}`;
        }
      }

      this.queryFoundItem = '';
      this.queryResultType = '';
      this.updateCounts();
      this.loadAllNamespaces();
    } catch (e) {
      this.queryResult = `❌ 删除失败: ${(e as Error).message}`;
    }
  }

  // 4. 删除特定命名空间
  deleteSpecificNamespace(uri: string) {
    try {
      const registry = this.getRegistry();
      registry.deleteNamespace(uri);
      this.updateCounts();
      this.loadAllNamespaces();
    } catch (e) {
      console.error('删除命名空间失败:', e);
    }
  }

  // 5. 查找特定别名 - 修改：未找到时显示提示
  resolveAlias() {
    // 清除之前的查询结果
    this.aliasResult = '';
    this.aliasFoundInfo = null;

    const input = this.aliasInput;
    if (!input || !input.trim()) {
      this.aliasResult = '⚠️ 请输入别名信息';
      return;
    }

    try {
      const registry = this.getRegistry();

      // 尝试查找别名
      const aliasInfo = registry.findAlias(input.trim());
      if (aliasInfo) {
        this.aliasResult = `✅ 找到别名:\n${input}\n→ ${aliasInfo.getNamespace()}${aliasInfo.getPropName()}`;
        this.aliasFoundInfo = aliasInfo;
        return;
      }

      // 尝试用XMP命名空间解析
      const xmpAlias = registry.resolveAlias(XMPConst.NS_XMP, input.trim());
      if (xmpAlias) {
        this.aliasResult = `✅ 解析别名:\nXMP:${input}\n→ ${xmpAlias.getNamespace()}${xmpAlias.getPropName()}`;
        this.aliasFoundInfo = xmpAlias;
        return;
      }

      // 修改：查找不到别名时，显示未找到提示
      this.aliasResult = `⚠️ 未找到别名: ${input}`;
      this.aliasFoundInfo = null;
    } catch (e) {
      this.aliasResult = `❌ 解析失败: ${(e as Error).message}`;
      this.aliasFoundInfo = null;
    }
  }

  // 6. 查找所有别名
  findAllAliases() {
    try {
      const registry = this.getRegistry();
      const aliases = registry.getAliases();
      const aliasList: [string, string][] = [];

      for (const entry of aliases.entries()) {
        const qname = entry[0];
        const aliasInfo = entry[1];
        if (aliasInfo) {
          const description = `${aliasInfo.getNamespace()}${aliasInfo.getPropName()}`;
          aliasList.push([qname, description]);
        } else {
          // 如果没有aliasInfo，直接使用qname
          aliasList.push([qname, '未知别名信息']);
        }
      }

      // 排序
      aliasList.sort((a, b) => {
        return a[0].localeCompare(b[0]);
      });

      this.allAliases = aliasList;
      this.aliasesCount = aliasList.length;
      this.showAllAliases = true;

      // 清空单个别名查询结果
      this.aliasResult = '';
      this.aliasFoundInfo = null;
    } catch (e) {
      console.error('查找所有别名失败:', e);
      this.aliasResult = `❌ 查找所有别名失败: ${(e as Error).message}`;
    }
  }

  // 7. 加载所有命名空间
  loadAllNamespaces() {
    try {
      const registry = this.getRegistry();
      const namespaces = registry.getNamespaces();
      const entries = Array.from(namespaces.entries());

      this.allNamespaces = entries;
      this.namespacesCount = entries.length;
    } catch (e) {
      console.error('加载所有命名空间失败:', e);
    }
  }

  // 8. 更新计数
  updateCounts() {
    try {
      const registry = this.getRegistry();
      const namespaces = registry.getNamespaces();
      const aliases = registry.getAliases();
      this.namespacesCount = namespaces.size;
      this.aliasesCount = aliases.size;
    } catch (e) {
      console.error('更新计数失败:', e);
    }
  }

  // 清空所有结果
  clearAll() {
    this.namespaceResult = '';
    this.queryResult = '';
    this.aliasResult = '';
    this.queryResultType = '';
    this.queryFoundItem = '';
    this.aliasFoundInfo = null;
    this.showAllAliases = false;
  }

  // 使用示例URI - 修改：使用内部URI格式
  useExampleUri() {
    this.namespaceUri = `urn:example:test:ns:${this.counter}`;
    this.namespacePrefix = `ex${this.counter}`;
    this.counter++;
  }

  // 使用标准命名空间
  useStandardNamespace() {
    this.queryInput = XMPConst.NS_DC;
    this.queryResult = '';
  }

  // 使用标准别名
  useStandardAlias() {
    this.aliasInput = 'Author';
    this.aliasResult = '';
  }

  // 返回别名查询页面
  backToAliasSearch() {
    this.showAllAliases = false;
    this.aliasInput = '';
    this.aliasResult = '';
  }

  // 初始化
  aboutToAppear() {
    this.updateCounts();
    this.loadAllNamespaces();
  }

  build() {
    Column({ space: 10 }) {
      // 标题
      Text(this.message)
        .fontSize(24)
        .fontWeight(FontWeight.Bold)
        .fontColor(Color.Blue)
        .margin({ top: 15, bottom: 5 })
        .width('95%')
        .textAlign(TextAlign.Center)

      // 统计数据 - 一行显示
      Row({ space: 30 }) {
        Row({ space: 5 }) {
          Text('命名空间:')
            .fontSize(14)
            .fontColor(Color.Gray)
          Text(this.namespacesCount.toString())
            .fontSize(16)
            .fontColor(Color.Blue)
            .fontWeight(FontWeight.Bold)
        }

        Row({ space: 5 }) {
          Text('别名:')
            .fontSize(14)
            .fontColor(Color.Gray)
          Text(this.aliasesCount.toString())
            .fontSize(16)
            .fontColor(Color.Green)
            .fontWeight(FontWeight.Bold)
        }
      }
      .margin({ bottom: 10 })
      .width('95%')
      .justifyContent(FlexAlign.SpaceAround)

      // 操作按钮行
      Row({ space: 10 }) {
        Button('注册命名空间')
          .fontSize(14)
          .fontColor(Color.White)
          .backgroundColor(this.currentAction === 'register' ? Color.Blue : '#A0A0A0')
          .height(40)
          .flexGrow(1)
          .onClick(() => {
            this.currentAction = 'register';
            this.clearAll();
            this.loadAllNamespaces();
          })

        Button('查询命名空间')
          .fontSize(14)
          .fontColor(Color.White)
          .backgroundColor(this.currentAction === 'query' ? Color.Green : '#A0A0A0')
          .height(40)
          .flexGrow(1)
          .onClick(() => {
            this.currentAction = 'query';
            this.clearAll();
          })

        Button('查找别名')
          .fontSize(14)
          .fontColor(Color.White)
          .backgroundColor(this.currentAction === 'alias' ? Color.Red : '#A0A0A0')
          .height(40)
          .flexGrow(1)
          .onClick(() => {
            this.currentAction = 'alias';
            this.clearAll();
          })
      }
      .width('95%')
      .margin({ bottom: 10 })

      // 操作区域 - 紧凑布局
      Column({ space: 10 }) {
        // 注册命名空间页面
        if (this.currentAction === 'register') {
          Column({ space: 8 }) {
            // 注册表单区域
            Column({ space: 8 }) {
              Row({ space: 8 }) {
                Column() {
                  Text('URI:')
                    .fontSize(12)
                    .fontColor(Color.Gray)
                  TextInput({ text: this.namespaceUri, placeholder: '命名空间URI' })
                    .fontSize(14)
                    .height(38)
                    .width('100%')
                    .backgroundColor(Color.White)
                    .border({ width: 1, color: Color.Grey })
                    .onChange((value: string) => {
                      this.namespaceUri = value;
                    })
                }
                .layoutWeight(2)

                Column() {
                  Text('前缀:')
                    .fontSize(12)
                    .fontColor(Color.Gray)
                  TextInput({ text: this.namespacePrefix, placeholder: '前缀' })
                    .fontSize(14)
                    .height(38)
                    .width('100%')
                    .backgroundColor(Color.White)
                    .border({ width: 1, color: Color.Grey })
                    .onChange((value: string) => {
                      this.namespacePrefix = value;
                    })
                }
                .layoutWeight(1)
              }
              .width('100%')

              Row({ space: 8 }) {
                Button('示例')
                  .fontSize(14)
                  .fontColor(Color.White)
                  .backgroundColor(Color.Pink)
                  .height(38)
                  .flexGrow(1)
                  .onClick(() => {
                    this.useExampleUri();
                  })

                Button('注册')
                  .fontSize(14)
                  .fontColor(Color.White)
                  .backgroundColor(Color.Blue)
                  .height(38)
                  .flexGrow(1)
                  .onClick(() => {
                    this.registerNamespace();
                  })
              }
              .width('100%')

              // 显示提示信息
              if (this.namespaceResult) {
                Text(this.namespaceResult)
                  .fontSize(13)
                  .fontColor(this.namespaceResult.startsWith('⚠️') ? Color.Red :
                    this.namespaceResult.startsWith('❌') ? Color.Red : Color.Green)
                  .width('100%')
                  .textAlign(TextAlign.Start)
                  .padding(8)
                  .backgroundColor(this.namespaceResult.startsWith('⚠️') ? '#FFF0F0' :
                    this.namespaceResult.startsWith('❌') ? '#FFF0F0' : '#F0FFF0')
                  .border({ width: 1, color: Color.Grey })
              }
            }
            .padding(12)
            .backgroundColor(Color.White)
            .border({ width: 1, color: Color.Grey })
            .borderRadius(6)
            .width('100%')
            .margin({ bottom: 8 })

            // 当前所有命名空间列表
            Column({ space: 8 }) {
              Row({ space: 10 }) {
                Text(`当前所有命名空间 (${this.allNamespaces.length}个)`)
                  .fontSize(16)
                  .fontWeight(FontWeight.Medium)
                  .fontColor(Color.Black)
                  .layoutWeight(1)
                  .textAlign(TextAlign.Start)

                Button('刷新')
                  .fontSize(12)
                  .fontColor(Color.White)
                  .backgroundColor(Color.Blue)
                  .height(28)
                  .width(60)
                  .onClick(() => {
                    this.loadAllNamespaces();
                  })
              }
              .width('100%')

              if (this.allNamespaces.length > 0) {
                Scroll() {
                  Column({ space: 5 }) {
                    ForEach(this.allNamespaces, (item: [string, string], index: number) => {
                      Column({ space: 5 }) {
                        Row() {
                          Text(`${index + 1}.`)
                            .fontSize(12)
                            .fontColor(Color.Gray)
                            .width(30)

                          Column() {
                            Text(item[0])
                              .fontSize(12)
                              .fontColor(Color.Black)
                              .width('100%')
                              .textAlign(TextAlign.Start)
                              .margin({ bottom: 2 })

                            Text(`前缀: ${item[1]}`)
                              .fontSize(11)
                              .fontColor(Color.Blue)
                              .width('100%')
                              .textAlign(TextAlign.Start)
                          }
                          .layoutWeight(1)
                        }
                        .width('100%')

                        // 删除按钮
                        Button('删除')
                          .fontSize(12)
                          .fontColor(Color.White)
                          .backgroundColor(Color.Red)
                          .height(28)
                          .width('100%')
                          .margin({ top: 5 })
                          .onClick(() => {
                            this.deleteSpecificNamespace(item[0]);
                          })
                      }
                      .width('100%')
                      .padding(8)
                      .backgroundColor(index % 2 === 0 ? '#F8F8F8' : '#FFFFFF')
                      .border({ width: 1, color: Color.Grey })
                      .borderRadius(4)
                      .margin({ bottom: 5 })
                    })
                  }
                  .width('100%')
                }
                .height(200)
                .width('100%')
              } else {
                Text('暂无命名空间数据')
                  .fontSize(14)
                  .fontColor(Color.Gray)
                  .padding(15)
                  .width('100%')
                  .textAlign(TextAlign.Center)
              }
            }
            .width('100%')
            .padding(12)
            .backgroundColor(Color.White)
            .border({ width: 1, color: Color.Grey })
            .borderRadius(6)
          }
          .width('100%')
        }

        // 查询命名空间页面
        if (this.currentAction === 'query') {
          Column({ space: 8 }) {
            Text('可输入URI查询前缀，或输入前缀查询URI')
              .fontSize(12)
              .fontColor(Color.Gray)
              .width('100%')
              .textAlign(TextAlign.Start)
              .margin({ bottom: 8 })

            Row({ space: 8 }) {
              TextInput({ text: this.queryInput, placeholder: '输入URI或前缀' })
                .fontSize(14)
                .height(38)
                .width('100%')
                .backgroundColor(Color.White)
                .border({ width: 1, color: Color.Grey })
                .onChange((value: string) => {
                  this.queryInput = value;
                })
                .layoutWeight(1)

              Button('示例')
                .fontSize(14)
                .fontColor(Color.White)
                .backgroundColor(Color.Pink)
                .height(38)
                .width(80)
                .onClick(() => {
                  this.useStandardNamespace();
                })
            }
            .width('100%')
            .margin({ bottom: 8 })

            Row({ space: 8 }) {
              Button('查询')
                .fontSize(14)
                .fontColor(Color.White)
                .backgroundColor(Color.Green)
                .height(38)
                .flexGrow(1)
                .onClick(() => {
                  this.performQuery();
                })

              // 如果查询到结果，显示删除按钮
              if (this.queryResultType && this.queryFoundItem) {
                Button('删除')
                  .fontSize(14)
                  .fontColor(Color.White)
                  .backgroundColor(Color.Red)
                  .height(38)
                  .flexGrow(1)
                  .onClick(() => {
                    this.deleteQueriedNamespace();
                  })
              }
            }
            .width('100%')

            if (this.queryResult) {
              Column({ space: 6 }) {
                Text(this.queryResult)
                  .fontSize(13)
                  .fontColor(this.queryResult.startsWith('✅') ? Color.Green : Color.Red)
                  .width('100%')
                  .textAlign(TextAlign.Start)

                // 显示额外的操作提示
                if (this.queryResultType && this.queryFoundItem) {
                  Text('💡 点击上方"删除"按钮可删除此项')
                    .fontSize(11)
                    .fontColor(Color.Blue)
                    .width('100%')
                    .textAlign(TextAlign.Start)
                    .margin({ top: 4 })
                }
              }
              .padding(8)
              .backgroundColor(this.queryResult.startsWith('✅') ? '#F0FFF0' : '#FFF0F0')
              .border({ width: 1, color: Color.Grey })
              .width('100%')
              .margin({ top: 8 })
            }
          }
          .width('100%')
          .padding(12)
          .backgroundColor(Color.White)
          .border({ width: 1, color: Color.Grey })
          .borderRadius(6)
        }

        // 查找别名页面
        if (this.currentAction === 'alias') {
          Column({ space: 8 }) {
            // 如果不是显示所有别名，则显示搜索界面
            if (!this.showAllAliases) {
              Column({ space: 8 }) {
                Text('可输入别名名称进行查询')
                  .fontSize(12)
                  .fontColor(Color.Gray)
                  .width('100%')
                  .textAlign(TextAlign.Start)
                  .margin({ bottom: 8 })

                Row({ space: 8 }) {
                  TextInput({ text: this.aliasInput, placeholder: '输入别名名称' })
                    .fontSize(14)
                    .height(38)
                    .width('100%')
                    .backgroundColor(Color.White)
                    .border({ width: 1, color: Color.Grey })
                    .onChange((value: string) => {
                      this.aliasInput = value;
                    })
                    .layoutWeight(1)

                  Button('示例')
                    .fontSize(14)
                    .fontColor(Color.White)
                    .backgroundColor(Color.Pink)
                    .height(38)
                    .width(80)
                    .onClick(() => {
                      this.useStandardAlias();
                    })
                }
                .width('100%')
                .margin({ bottom: 8 })

                Row({ space: 8 }) {
                  Button('查找')
                    .fontSize(14)
                    .fontColor(Color.White)
                    .backgroundColor(Color.Red)
                    .height(38)
                    .flexGrow(1)
                    .onClick(() => {
                      this.resolveAlias();
                    })

                  Button('查找所有')
                    .fontSize(14)
                    .fontColor(Color.White)
                    .backgroundColor(Color.Orange)
                    .height(38)
                    .flexGrow(1)
                    .onClick(() => {
                      this.findAllAliases();
                    })
                }
                .width('100%')

                // 修改：显示所有查询结果，包括未找到的情况
                if (this.aliasResult) {
                  Column({ space: 6 }) {
                    Text(this.aliasResult)
                      .fontSize(13)
                      .fontColor(this.aliasResult.startsWith('✅') ? Color.Green :
                        this.aliasResult.startsWith('⚠️') ? Color.Red : Color.Red)
                      .width('100%')
                      .textAlign(TextAlign.Start)
                  }
                  .padding(8)
                  .backgroundColor(this.aliasResult.startsWith('✅') ? '#F0FFF0' : '#FFF0F0')
                  .border({ width: 1, color: Color.Grey })
                  .width('100%')
                  .margin({ top: 8 })
                }
              }
              .width('100%')
              .padding(12)
              .backgroundColor(Color.White)
              .border({ width: 1, color: Color.Grey })
              .borderRadius(6)
            } else {
              // 显示所有别名
              Column({ space: 8 }) {
                Row({ space: 10 }) {
                  Button('返回')
                    .fontSize(14)
                    .fontColor(Color.White)
                    .backgroundColor(Color.Blue)
                    .height(32)
                    .width(80)
                    .onClick(() => {
                      this.backToAliasSearch();
                    })

                  Text(`所有别名 (${this.allAliases.length}个)`)
                    .fontSize(16)
                    .fontWeight(FontWeight.Medium)
                    .fontColor(Color.Black)
                    .layoutWeight(1)
                    .textAlign(TextAlign.Center)
                }
                .width('100%')
                .margin({ bottom: 8 })

                if (this.allAliases.length > 0) {
                  Scroll() {
                    Column({ space: 5 }) {
                      ForEach(this.allAliases, (item: [string, string], index: number) => {
                        Column({ space: 5 }) {
                          Row() {
                            Text(`${index + 1}.`)
                              .fontSize(12)
                              .fontColor(Color.Gray)
                              .width(30)

                            Column() {
                              Text(item[0])
                                .fontSize(12)
                                .fontColor(Color.Black)
                                .width('100%')
                                .textAlign(TextAlign.Start)
                                .margin({ bottom: 2 })

                              Text(`实际: ${item[1]}`)
                                .fontSize(11)
                                .fontColor(Color.Green)
                                .width('100%')
                                .textAlign(TextAlign.Start)
                            }
                            .layoutWeight(1)
                          }
                          .width('100%')
                        }
                        .width('100%')
                        .padding(8)
                        .backgroundColor(index % 2 === 0 ? '#F8F8F8' : '#FFFFFF')
                        .border({ width: 1, color: Color.Grey })
                        .borderRadius(4)
                        .margin({ bottom: 5 })
                      })
                    }
                    .width('100%')
                  }
                  .height(250)
                  .width('100%')
                } else {
                  Text('暂无别名数据')
                    .fontSize(14)
                    .fontColor(Color.Gray)
                    .padding(15)
                    .width('100%')
                    .textAlign(TextAlign.Center)
                }
              }
              .width('100%')
              .padding(12)
              .backgroundColor(Color.White)
              .border({ width: 1, color: Color.Grey })
              .borderRadius(6)
            }
          }
          .width('100%')
        }
      }
      .width('100%')
      .flexGrow(1)
      .margin({ bottom: 5 })

      // 使用说明
      Column({ space: 5 }) {
        Text('使用说明:')
          .fontSize(14)
          .fontWeight(FontWeight.Medium)
          .fontColor(Color.Gray)
          .width('100%')
          .textAlign(TextAlign.Start)

        Text('1. 注册命名空间: 输入URI和前缀注册新命名空间，下方显示当前所有命名空间，可删除单个命名空间')
          .fontSize(12)
          .fontColor(Color.Gray)
          .width('100%')
          .textAlign(TextAlign.Start)

        Text('2. 查询命名空间: 输入URI查询前缀，或输入前缀查询URI，查询结果可删除')
          .fontSize(12)
          .fontColor(Color.Gray)
          .width('100%')
          .textAlign(TextAlign.Start)

        Text('3. 查找别名: 输入别名进行查找，或点击"查找所有"查看所有别名')
          .fontSize(12)
          .fontColor(Color.Gray)
          .width('100%')
          .textAlign(TextAlign.Start)
      }
      .width('100%')
      .padding(10)
      .backgroundColor('#F8F8F8')
      .border({ width: 1, color: Color.Grey })
      .borderRadius(6)
      .margin({ bottom: 10 })

    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F5F5F5')
    .padding({ left: 10, right: 10 })
    .alignItems(HorizontalAlign.Center)
    .justifyContent(FlexAlign.Start)
  }
}