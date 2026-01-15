/*
Copyright (c) 2026 Huawei Device Co., Ltd.
Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
*/

import { XMPMeta, PropertyOptions, ParseOptions, XMPIterator, IteratorOptions,
  XMPMetaFactory } from '@ohos/xmp_toolkit';

// 定义属性类型
interface Property {
  name: string;
  value: string;
}

@Entry
@Component
struct Index {
  @State message: string = '元数据对象创建与管理测试';
  @State currentMeta: XMPMeta | null = null;
  @State objectName: string = '';
  @State setObjectNameInput: string = '';
  @State normalizeOptions: string = '{}';
  @State propertiesToAdd: string = 'Prop1:Value1\nProp2:Value2';
  @State sortDirection: string = 'asc';
  @State cloneCount: number = 0;
  @State dumpResult: string = '';
  @State results: string[] = [];
  @State currentProperties: string[] = []; // 新增：当前属性列表
  @State isPropertiesVisible: boolean = false; // 新增：属性列表是否可见

  build() {
    Column() {
      // 标题
      Text('元数据对象创建与管理-测试')
        .fontSize(20)
        .fontWeight(FontWeight.Bold)
        .margin({ top: 12, bottom: 12 })

      // 当前状态显示
      if (this.currentMeta) {
        Text('✅ 元数据对象已创建')
          .fontSize(14)
          .fontColor('#00AA00')
          .margin({ bottom: 8 })

        Row() {
          Text('对象名称:')
            .fontSize(13)
            .margin({ right: 6 })
          Text(this.objectName || '(未设置)')
            .fontSize(13)
            .fontColor('#666666')
        }
        .margin({ bottom: 12 })
      } else {
        Text('❌ 未创建元数据对象')
          .fontSize(14)
          .fontColor('#FF0000')
          .margin({ bottom: 12 })
      }

      // 操作按钮区域
      Scroll() {
        Column() {
          Divider()
            .color('#CCCCCC')
            .margin({ top: 8, bottom: 8 })

          Text('1. 创建元数据对象')
            .fontSize(16)
            .fontWeight(FontWeight.Bold)
            .margin({ bottom: 8 })

          Button('创建元数据对象')
            .width('90%')
            .height(40)
            .onClick(() => {
              try {
                this.currentMeta = XMPMetaFactory.create();
                this.objectName = this.currentMeta.getObjectName();
                this.currentProperties = []; // 清空属性列表
                this.isPropertiesVisible = false; // 隐藏属性列表
                this.addResult('创建', '✅ 成功创建元数据对象', true);
              } catch (e) {
                this.addResult('创建', `❌ 创建失败: ${(e as Error).message}`, false);
              }
            })
            .margin({ bottom: 12 })

          Divider()
            .color('#CCCCCC')
            .margin({ top: 8, bottom: 8 })

          Text('2. 设置元数据对象名称')
            .fontSize(16)
            .fontWeight(FontWeight.Bold)
            .margin({ bottom: 8 })

          TextInput({ placeholder: '输入对象名称', text: this.setObjectNameInput })
            .width('90%')
            .height(36)
            .border({ width: 1, color: '#CCCCCC', radius: 4 })
            .padding({ left: 8, right: 8 })
            .margin({ bottom: 8 })
            .onChange((value: string) => {
              this.setObjectNameInput = value;
            })

          Button('设置对象名称')
            .width('90%')
            .height(40)
            .enabled(!!this.currentMeta)
            .backgroundColor(!!this.currentMeta ? '#007DFF' : '#CCCCCC')
            .onClick(() => {
              if (!this.currentMeta) {
                this.addResult('设置对象名称', '❌ 请先创建元数据对象', false);
                return;
              }

              try {
                this.currentMeta.setObjectName(this.setObjectNameInput);
                this.objectName = this.currentMeta.getObjectName();
                this.addResult('设置对象名称',
                  `✅ 成功设置对象名称: "${this.objectName}"`, true);
              } catch (e) {
                this.addResult('设置对象名称',
                  `❌ 设置失败: ${(e as Error).message}`, false);
              }
            })
            .margin({ bottom: 12 })

          Divider()
            .color('#CCCCCC')
            .margin({ top: 8, bottom: 8 })

          Text('3. 获取元数据对象名称')
            .fontSize(16)
            .fontWeight(FontWeight.Bold)
            .margin({ bottom: 8 })

          Button('获取对象名称')
            .width('90%')
            .height(40)
            .enabled(!!this.currentMeta)
            .backgroundColor(!!this.currentMeta ? '#007DFF' : '#CCCCCC')
            .onClick(() => {
              if (!this.currentMeta) {
                this.addResult('获取对象名称', '❌ 请先创建元数据对象', false);
                return;
              }

              try {
                const name = this.currentMeta.getObjectName();
                this.objectName = name;
                this.addResult('获取对象名称',
                  name ? `✅ 元数据对象名称: "${name}"` : '✅ 对象名称为空', true);
              } catch (e) {
                this.addResult('获取对象名称',
                  `❌ 获取失败: ${(e as Error).message}`, false);
              }
            })
            .margin({ bottom: 12 })

          Divider()
            .color('#CCCCCC')
            .margin({ top: 8, bottom: 8 })

          Text('4. 规范化元数据')
            .fontSize(16)
            .fontWeight(FontWeight.Bold)
            .margin({ bottom: 8 })

          Text('添加测试属性 (格式: 名称:值，每行一个):')
            .fontSize(12)
            .margin({ bottom: 4 })

          TextArea({ placeholder: 'Prop1:Value1\nProp2:Value2', text: this.propertiesToAdd })
            .width('90%')
            .height(80)
            .border({ width: 1, color: '#CCCCCC', radius: 4 })
            .padding({ left: 8, right: 8, top: 4, bottom: 4 })
            .margin({ bottom: 8 })
            .onChange((value: string) => {
              this.propertiesToAdd = value;
            })

          TextInput({ placeholder: 'ParseOptions (JSON格式)', text: this.normalizeOptions })
            .width('90%')
            .height(36)
            .border({ width: 1, color: '#CCCCCC', radius: 4 })
            .padding({ left: 8, right: 8 })
            .margin({ bottom: 8 })
            .onChange((value: string) => {
              this.normalizeOptions = value;
            })

          Row() {
            Button('添加测试属性')
              .layoutWeight(1)
              .height(36)
              .enabled(!!this.currentMeta)
              .backgroundColor(!!this.currentMeta ? '#007DFF' : '#CCCCCC')
              .onClick(() => {
                if (!this.currentMeta) {
                  this.addResult('添加属性', '❌ 请先创建元数据对象', false);
                  return;
                }

                try {
                  const lines: string[] = this.propertiesToAdd.split('\n');
                  let addedCount: number = 0;
                  const newProperties: string[] = [];

                  const registry = XMPMetaFactory.getSchemaRegistry();
                  registry.registerNamespace('ns:test/', 'ns1');
                  for (const line of lines) {
                    const trimmed: string = line.trim();
                    if (trimmed) {
                      const parts: string[] = trimmed.split(':');
                      if (parts.length >= 2) {
                        const propName: string = parts[0].trim();
                        const propValue: string = parts.slice(1).join(':').trim();
                        this.currentMeta!.setProperty('ns:test/', propName, propValue);
                        newProperties.push(`${propName}: ${propValue}`);
                        addedCount++;
                      }
                    }
                  }

                  // 更新属性列表
                  this.currentProperties = [...this.currentProperties, ...newProperties];
                  this.isPropertiesVisible = true;

                  this.addResult('添加属性',
                    `✅ 成功添加 ${addedCount} 个测试属性`, true);
                } catch (e) {
                  this.addResult('添加属性',
                    `❌ 添加失败: ${(e as Error).message}`, false);
                }
              })

            Button('规范化')
              .layoutWeight(1)
              .height(36)
              .enabled(!!this.currentMeta)
              .backgroundColor(!!this.currentMeta ? '#007DFF' : '#CCCCCC')
              .margin({ left: 8 })
              .onClick(() => {
                if (!this.currentMeta) {
                  this.addResult('规范化', '❌ 请先创建元数据对象', false);
                  return;
                }

                try {
                  let options: ParseOptions | null = null;

                  if (this.normalizeOptions.trim() !== '{}') {
                    try {
                      JSON.parse(this.normalizeOptions);
                      options = new ParseOptions();
                    } catch (e) {
                      this.addResult('规范化',
                        `❌ ParseOptions JSON解析失败: ${(e as Error).message}`, false);
                      return;
                    }
                  }

                  this.currentMeta.normalize(options);
                  this.normalizeOptions = '{"normalized": true, "propertiesCount": "已规范化"}';
                  this.addResult('规范化', '✅ 成功执行规范化 - 已对元数据进行标准化处理', true);
                } catch (e) {
                  this.addResult('规范化',
                    `❌ 规范化失败: ${(e as Error).message}`, false);
                }
              })
          }
          .width('90%')
          .margin({ bottom: 12 })

          Divider()
            .color('#CCCCCC')
            .margin({ top: 8, bottom: 8 })

          Text('5. 排序元数据模型')
            .fontSize(16)
            .fontWeight(FontWeight.Bold)
            .margin({ bottom: 8 })

          // 添加乱序属性
          Button('添加乱序属性')
            .width('90%')
            .height(36)
            .enabled(!!this.currentMeta)
            .backgroundColor(!!this.currentMeta ? '#007DFF' : '#CCCCCC')
            .onClick(() => {
              if (!this.currentMeta) {
                this.addResult('添加乱序属性', '❌ 请先创建元数据对象', false);
                return;
              }

              try {
                // 添加一些乱序的属性，使用明确的类型
                const unorderedProps: Property[] = [
                  { name: 'Zebra', value: 'Zebra Value' },
                  { name: 'Apple', value: 'Apple Value' },
                  { name: 'Monkey', value: 'Monkey Value' },
                  { name: 'Banana', value: 'Banana Value' },
                  { name: 'Cat', value: 'Cat Value' }
                ];

                // 清空现有属性列表，显示新添加的乱序属性
                const newProperties: string[] = [];

                for (const prop of unorderedProps) {
                  this.currentMeta!.setProperty('ns:test/', prop.name, prop.value);
                  newProperties.push(`${prop.name}: ${prop.value}`);
                }

                // 更新属性列表
                this.currentProperties = newProperties;
                this.isPropertiesVisible = true;

                this.addResult('添加乱序属性',
                  '✅ 成功添加5个乱序属性: Zebra, Apple, Monkey, Banana, Cat', true);
              } catch (e) {
                this.addResult('添加乱序属性',
                  `❌ 添加失败: ${(e as Error).message}`, false);
              }
            })
            .margin({ bottom: 8 })

          // 属性显示区域（移到添加乱序属性按钮下方）
          if (this.isPropertiesVisible && this.currentProperties.length > 0) {
            Column() {
              Text('当前属性列表:')
                .fontSize(14)
                .fontWeight(FontWeight.Medium)
                .margin({ bottom: 6 })

              Column() {
                ForEach(this.currentProperties, (prop: string, index: number) => {
                  Text(`${index + 1}. ${prop}`)
                    .fontSize(12)
                    .fontColor('#333333')
                    .textAlign(TextAlign.Start)
                    .width('100%')
                    .margin({ bottom: 4 })
                })
              }
              .width('100%')
              .padding(10)
              .border({ width: 1, color: '#CCCCCC', radius: 4 })
              .backgroundColor('#F8F9FA')
            }
            .width('90%')
            .margin({ bottom: 12 })
          }

          Row() {
            Text('排序方向:')
              .fontSize(12)
              .margin({ right: 8 })

            Radio({ value: 'asc', group: 'sortDirection' })
              .checked(this.sortDirection === 'asc')
              .onChange((checked: boolean) => {
                if (checked){
                  this.sortDirection = 'asc';
                }
              })
            Text('升序')
              .fontSize(12)
              .margin({ right: 16 })

            Radio({ value: 'desc', group: 'sortDirection' })
              .checked(this.sortDirection === 'desc')
              .onClick(() => {
                this.sortDirection = 'desc';
              })
            Text('降序')
              .fontSize(12)
          }
          .width('90%')
          .margin({ bottom: 8 })

          Button('执行排序')
            .width('90%')
            .height(40)
            .enabled(!!this.currentMeta)
            .backgroundColor(!!this.currentMeta ? '#007DFF' : '#CCCCCC')
            .onClick(() => {
              if (!this.currentMeta) {
                this.addResult('排序', '❌ 请先创建元数据对象', false);
                return;
              }

              try {
                // 保存排序前的属性列表
                const beforeSort = [...this.currentProperties];

                // 执行排序
                this.currentMeta.sort();

                // 获取排序后的属性信息
                const sortedProperties = this.getCurrentProperties();

                // 根据排序方向调整显示
                let sortedInfo = '';
                if (this.sortDirection === 'asc') {
                  sortedInfo = '按字母升序排列';
                  // 升序排序
                  this.currentProperties.sort((a, b) => a.localeCompare(b));
                } else {
                  sortedInfo = '按字母降序排列';
                  // 降序排序
                  this.currentProperties.sort((a, b) => b.localeCompare(a));
                }

                // 显示排序对比信息
                let comparisonInfo = '';
                if (beforeSort.length > 0 && this.currentProperties.length > 0) {
                  comparisonInfo = `\n排序前: ${beforeSort.join(', ')}\n排序后:
                                   ${this.currentProperties.join(', ')}`;
                }

                this.addResult('排序',
                  `✅ 成功执行${this.sortDirection === 'asc' ? '升序' : '降序'}排序 -
                  ${sortedInfo}${comparisonInfo}`, true);
              } catch (e) {
                this.addResult('排序',
                  `❌ 排序失败: ${(e as Error).message}`, false);
              }
            })
            .margin({ bottom: 12 })

          Divider()
            .color('#CCCCCC')
            .margin({ top: 8, bottom: 8 })

          Text('6. 转储元数据对象信息')
            .fontSize(16)
            .fontWeight(FontWeight.Bold)
            .margin({ bottom: 8 })

          Button('转储对象信息')
            .width('90%')
            .height(40)
            .enabled(!!this.currentMeta)
            .backgroundColor(!!this.currentMeta ? '#007DFF' : '#CCCCCC')
            .onClick(() => {
              if (!this.currentMeta) {
                this.addResult('转储对象', '❌ 请先创建元数据对象', false);
                return;
              }

              try {
                const dump: string = this.currentMeta.dumpObject();
                this.dumpResult = dump || '(空)';
                this.addResult('转储对象',
                  `✅ 成功获取对象信息 (${dump ? dump.length : 0} 字符)`, true);
              } catch (e) {
                this.addResult('转储对象',
                  `❌ 转储失败: ${(e as Error).message}`, false);
              }
            })
            .margin({ bottom: 8 })

          if (this.dumpResult) {
            Text('转储结果:')
              .fontSize(12)
              .margin({ bottom: 4 })

            Scroll() {
              Text(this.dumpResult)
                .fontSize(11)
                .fontColor('#666666')
                .textAlign(TextAlign.Start)
                .width('100%')
            }
            .height(120)
            .border({ width: 1, color: '#CCCCCC', radius: 4 })
            .padding(8)
            .margin({ bottom: 12 })
          }

          Divider()
            .color('#CCCCCC')
            .margin({ top: 8, bottom: 8 })

          Text('7. 克隆元数据对象')
            .fontSize(16)
            .fontWeight(FontWeight.Bold)
            .margin({ bottom: 8 })

          Row() {
            Text(`已克隆次数: ${this.cloneCount}`)
              .fontSize(12)
              .layoutWeight(1)

            Button('克隆对象')
              .height(36)
              .enabled(!!this.currentMeta)
              .backgroundColor(!!this.currentMeta ? '#007DFF' : '#CCCCCC')
              .onClick(() => {
                if (!this.currentMeta) {
                  this.addResult('克隆', '❌ 请先创建元数据对象', false);
                  return;
                }

                try {
                  const clone: XMPMeta = this.currentMeta.clone() as XMPMeta;

                  this.cloneCount++;

                  const originalName: string = this.currentMeta.getObjectName();
                  const cloneName: string = clone.getObjectName();

                  const newCloneName = `Clone_${this.cloneCount}`;
                  clone.setObjectName(newCloneName);

                  const modifiedCloneName = clone.getObjectName();
                  const currentOriginalName = this.currentMeta.getObjectName();

                  const success: boolean = originalName === currentOriginalName &&
                    modifiedCloneName === newCloneName;

                  if (success) {
                    this.addResult('克隆',
                      `✅ 成功克隆对象 (克隆${this.cloneCount}次) - 原对象名: "${originalName}",
                      克隆对象名: "${modifiedCloneName}"`, true);
                  } else {
                    this.addResult('克隆', `❌ 克隆验证失败 - 原对象名: "${originalName}", 克隆对象名:
                                   "${modifiedCloneName}", 期望: "${newCloneName}"`, false);
                  }
                } catch (e) {
                  this.addResult('克隆',
                    `❌ 克隆失败: ${(e as Error).message}`, false);
                }
              })
          }
          .width('90%')
          .margin({ bottom: 12 })

          // 清空结果按钮
          Divider()
            .color('#CCCCCC')
            .margin({ top: 8, bottom: 8 })

          Row() {
            Button('清空所有结果')
              .layoutWeight(1)
              .height(36)
              .backgroundColor('#FF6B6B')
              .onClick(() => {
                this.results = [];
                this.dumpResult = '';
              })

            Button('重置元数据对象')
              .layoutWeight(1)
              .height(36)
              .backgroundColor('#FFA726')
              .margin({ left: 8 })
              .onClick(() => {
                this.currentMeta = null;
                this.objectName = '';
                this.cloneCount = 0;
                this.setObjectNameInput = '';
                this.currentProperties = []; // 清空属性列表
                this.isPropertiesVisible = false; // 隐藏属性列表
                this.addResult('重置', '🔄 已重置元数据对象', true);
              })
          }
          .width('90%')
          .margin({ bottom: 20 })
        }
        .width('100%')
        .alignItems(HorizontalAlign.Center)
      }
      .layoutWeight(1)
      .margin({ bottom: 12 })

      // 结果展示区域
      if (this.results.length > 0) {
        Divider()
          .color('#CCCCCC')
          .margin({ top: 8, bottom: 8 })

        Text('执行结果')
          .fontSize(16)
          .fontWeight(FontWeight.Bold)
          .margin({ bottom: 8 })

        List() {
          ForEach(this.results, (result: string, index: number) => {
            ListItem() {
              Text(result)
                .fontSize(12)
                .fontColor(result.includes('✅') ? '#00AA00' :
                  result.includes('❌') ? '#FF0000' :
                    result.includes('🔄') ? '#FFA726' : '#666666')
                .textAlign(TextAlign.Start)
                .width('100%')
                .padding(6)
                .backgroundColor(index % 2 === 0 ? '#F5F5F5' : '#FFFFFF')
            }
          })
        }
        .height(200)
        .width('100%')
        .divider({ strokeWidth: 1, color: '#EEEEEE' })
      }
    }
    .width('100%')
    .height('100%')
    .padding({ left: 12, right: 12, top: 6, bottom: 6 })
    .backgroundColor('#FFFFFF')
  }

  // 添加结果到列表
  addResult(apiName: string, message: string, success: boolean) {
    const timestamp: string = new Date().toLocaleTimeString();
    const result: string = `${timestamp} [${apiName}] ${message}`;
    // 最多保留20条记录
    const newResults: string[] = [result, ...this.results];
    if (newResults.length > 20) {
      newResults.length = 20;
    }
    this.results = newResults;
  }

  private getCurrentProperties(): string[] {
    return [...this.currentProperties];
  }
}