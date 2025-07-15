/*
 * Copyright (C) 2022 Huawei Device Co., Ltd.
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
import RuleEngine from "node-rules";
import { Fact } from "./Type";
import { getStringByNameSync, showToast } from "./Utils";

@Entry
@Component
struct SimpleRule {
  @State message: string = 'Hello World';
  @State setValue: string = "";
  @State resultStr: string = "";
  controller: TextAreaController = new TextAreaController();
  testResult: string = getStringByNameSync(this.getUIContext().getHostContext(), 'text_result').toString();

  ruleEngineExecute(): void {

    if (this.setValue === '' || Number.isNaN(Number(this.setValue))) {
      showToast(this.getUIContext(), {
        message: 'Enter an integer value'
      })
      return
    }

    let ruleEngine: ESObject = new RuleEngine();

    class Rule {
      condition(ruleEngine: ESObject) {
        ruleEngine.when((this as ESObject).transactionTotal < 500);
      }

      consequence(ruleEngine: ESObject) {
        (this as ESObject).result = false;
        (this as ESObject).reason = "The transaction was blocked as it was less than 500";
        ruleEngine.stop();
      }
    }


    let rule = new Rule()


    ruleEngine.register(rule);


    let fact: Fact = {
      name: "user4",
      application: "MOB2",
      transactionTotal: Number.parseInt(this.setValue),
      cardType: "Credit Card"
    }
    console.log("------" + this.setValue);

    ruleEngine.execute(fact, (data: ESObject) => {
      if (data.result) {
        console.log("Valid transaction:" + data.result); //满足规则
        this.resultStr = "Valid transaction:" + data.result;
      } else {
        console.log("Blocked Reason:" + data["reason"]); //不满足规则
        this.resultStr = "Blocked Reason:" + data["reason"];
      }

    })
  }

  build() {
    Column() {

      Text($r("app.string.text_simple_tips"))
        .width("90%")
        .height(50)
        .borderRadius(15)
        .fontSize(13)
        .textAlign(TextAlign.Center)
        .margin({ top: 10 });

      TextArea({ placeholder: "Enter an integer value", controller: this.controller })
        .height(50)
        .width("100%")
        .margin({ top: 5, bottom: 5, left: 5, right: 5 })
        .onChange((value: string) => {
          this.setValue = value;
        })

      Button($r("app.string.button_see_rules")).onClick(() => {
        this.ruleEngineExecute();
      })
      Text(this.testResult + this.resultStr)
        .width("90%")
        .height(50)
        .borderRadius(15)
        .fontSize(13)
        .textAlign(TextAlign.Center)
        .margin({ top: 10 })
    }
    .width('100%')
    .padding({ top: 10, left: 3, right: 3 })
  }
}