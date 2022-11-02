/*
 * Copyright (c) 2021 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the 'License');
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *   http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an 'AS IS' BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
// @ts-ignore
import RuleEngine from "node-rules";

@Entry
@Component
struct RecurssionWithRules {
  @State message: string = 'Hello World'
  @State setValue: string = "0";
  @State resultStr: string = "";
  @State arrayStr: Array<string> = [];
  controller: TextAreaController = new TextAreaController();

  ruleEngineExecute(): void {
    var ruleEngine = new RuleEngine();
    var that = this;
    var rule =
      {
        "condition": function (R) {
          R.when(this.someval < 10);
        },
        "consequence": function (R) {
          this.someval = ++this.someval
          console.log(this.someval + ": incrementing again till 10")
          that.arrayStr.push(this.someval + " ：incrementing again till 10");
          console.log(that.resultStr);
          R.restart();
        }
      }

    ruleEngine.register(rule);

    var fact = {
      "someval": parseInt(this.setValue)
    };

    console.log("-------" + this.setValue);

    ruleEngine.execute(fact, (data) => {
      that.resultStr = "Finished with value:" + data.someval;
    })
  }

  build() {
    Column() {

      Text("测试10以内执行次数循环，测试restart接口等")
        .width("90%")
        .height(50)
        .borderRadius(15)
        .fontSize(13)
        .textAlign(TextAlign.Center)
        .margin({ top: 10 });

      TextArea({ placeholder: "10以内数值：", controller: this.controller })
        .height(50)
        .width("100%")
        .margin({ top: 5, bottom: 5, left: 5, right: 5 })
        .onChange((value: string) => {
          this.setValue = value;
          this.arrayStr = [];
          this.controller.caretPosition(-1);

        })

      Button("点击查看是否满足规则").onClick(() => {
        this.ruleEngineExecute();
      })

      ForEach(this.arrayStr, (item, index) => {
        Text("测试结果：" + item)
          .width("90%")
          .height(30)
          .borderRadius(15)
          .fontSize(13)
          .textAlign(TextAlign.Center)
          .margin({ top: 5 })

      })
    }
    .width('100%')
    .padding({ top: 10, left: 3, right: 3 })
  }
}