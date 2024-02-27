/*
 * Copyright (C) 2024 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
@Entry
@Component
struct tree_registry {
  @State message: string = '获取节点数据'
  @State one_node: string = 'chang'
  @State two_node: string = 'rap'
  @State one_node_data_1: string = '1×2.5'
  @State one_node_data_2:string ='1×kun'
  @State two_node_data: string = '2×basketball'

  build() {
    Row() {
      Column() {
        Text(this.message)
          .fontSize(30)
          .fontColor(Color.Black)
          .fontWeight(FontWeight.Regular)
        Divider()
        Button(this.message, { type: ButtonType.Normal, stateEffect: true })
          .height(80)
          .width(150)
          .margin({ top: 50 })
          .onClick(() => {
            class Node {
              public name: string

              constructor(name: string) {
                this.name = name;
              }
              execute() {
              }
            }

            class Registry {
              public registry: Map<string, Node[]> = new Map();

              registerNode(type: string, node: Node) {
                if (!this.registry[type]) {
                  this.registry[type] = [];
                }
                this.registry[type].push(node);
              }

              getRegistry(type: string): Node[] {
                return this.registry[type] || [];
              }
            }
            //写入注册表数据
            const registry = new Registry();
            registry.registerNode(this.one_node, new Node(this.one_node_data_1));
            registry.registerNode(this.one_node, new Node(this.one_node_data_2));
            registry.registerNode(this.two_node, new Node(this.two_node_data));
            // 从注册表中获取节点并输出结果
            const actions: Node[] = registry.getRegistry(this.one_node);
            const conditions: Node[] = registry.getRegistry(this.two_node);
            console.log('第一个节点有数据:');
            actions.forEach(action => console.log(action.name));
            console.log('第二个节点有数据:');
            conditions.forEach(condition => console.log(condition.name));
          })
      }
    }
  }
}






