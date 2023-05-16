/*
 * Copyright (C) 2023 Huawei Device Co., Ltd.
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
import { BehaviorTree,Selector,Task,SUCCESS,Random,RUNNING,FAILURE,BehaviorTreeImporter } from "behaviorTree";
import { JSONData } from "./model";
@Entry
@Component
struct Index {
  @State message: string = 'Hello World'
  bTree:BehaviorTree;
  timerId:any;
  aboutToAppear(){
    this.init(BehaviorTree);
    const behaviorTreeImporter = new BehaviorTreeImporter();
    // @ts-ignore
    this.bTree = new BehaviorTree({tree:behaviorTreeImporter.parse(JSONData)})
  }

  init(_BehaviorTree){
    _BehaviorTree.register(
      "computer",
      new Task({
        run(blackboard) {
          console.log("小明选择了计算机专业");
          return undefined;
        },
      })
    );
    _BehaviorTree.register(
      "accountant",
      new Task({
        run(blackboard) {
          console.log("小明选择了会计专业");
          return undefined;
        },
      })
    );
    _BehaviorTree.register(
      "teacher",
      new Task({
        run(blackboard) {
          console.log("小明选择了教师专业");
          return undefined;
        },
      })
    );

    _BehaviorTree.register(
      "Huawei",
      new Task({
        run(blackboard) {
          const value = Math.random() * 10;
          console.log(`Huawei Value ${value}`);
          if (value >= 5) {
            console.log("通过了--华为--面试");
            return SUCCESS;
          } else {
            console.error("未通过--华为--面试");
            return FAILURE;
          }
        },
      })
    );

    _BehaviorTree.register(
      "Tencent",
      new Task({
        run(blackboard) {
          const value = Math.random() * 10;
          console.log(`Tencent Value ${value}`);
          if (value >= 5) {
            console.log("通过了--腾讯--面试");
            return SUCCESS;
          } else {
            console.error("未通过--华为--面试");
            return FAILURE;
          }
        },
      })
    );

    _BehaviorTree.register(
      "Google",
      new Task({
        run(blackboard) {
          const value = Math.random() * 10;
          console.log(`Google Value ${value}`);
          if (value >= 5) {
            console.log("通过了--谷歌--面试");
            return SUCCESS;
          } else {
            console.error("未通过--谷歌--面试");
            return FAILURE;
          }
        },
      })
    );
  }

  build() {
    Row() {
      Column() {
        Button("启动行为树实例").onClick(() => {
          this.timerId = setInterval(() => {
            this.bTree.step();
          },1000)
        })
        Button("关闭行为树实例").onClick(() => {
          clearInterval(this.timerId);
        })
      }
      .width('100%')
    }
    .height('100%')
  }
}