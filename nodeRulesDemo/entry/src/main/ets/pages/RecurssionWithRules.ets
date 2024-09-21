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
import Prompt from '@system.prompt';

@Entry
@Component
struct RecurssionWithRules {
  @State message: string = 'Hello World'
  @State setValue: string = "";
  @State resultStr: string = "";
  @State arrayStr: Array<string> = [];
  controller: TextAreaController = new TextAreaController();
  testResult: string = getContext(this).resourceManager.getStringByNameSync('text_result').toString();

  ruleEngineExecute(): void {
    let value: number = Number(this.setValue)

    if (this.setValue === '' || Number.isNaN(value) || value >= 10 || value < 0) {
      Prompt.showToast({
        message: 'Enter a value within 10'
      })
      return
    }


    let ruleEngine: RuleEngine = new RuleEngine();
    let that = this;

    class Rule {
      condition(R: ESObject) {
        R.when((this as ESObject).someval < 10);
      }

      consequence(R: ESObject) {
        (this as ESObject).someval = ++(this as ESObject).someval
        console.log((this as ESObject).someval + ": incrementing again till 10")
        that.arrayStr.push((this as ESObject).someval + " ：incrementing again till 10");
        console.log(that.resultStr);
        R.restart();
      }
    }

    let rule: Rule = new Rule();


    ruleEngine.register(rule);

    let fact: ESObject = {
      someval: Number.parseInt(this.setValue)
    };

    console.log("-------" + this.setValue);

    ruleEngine.execute(fact, (data: ESObject) => {
      that.resultStr = "Finished with value:" + data.someval;
    })
  }

  build() {
    Column() {

      Text($r("app.string.text_recurssion_tips"))
        .width("90%")
        .height(50)
        .borderRadius(15)
        .fontSize(13)
        .textAlign(TextAlign.Center)
        .margin({ top: 10 });

      TextArea({ placeholder: "Enter a value within 10 ", controller: this.controller })
        .height(50)
        .width("100%")
        .margin({ top: 5, bottom: 5, left: 5, right: 5 })
        .onChange((value: string) => {
          this.setValue = value;
          this.arrayStr = [];
        })

      Button($r("app.string.button_see_rules")).onClick(() => {
        this.ruleEngineExecute();
      })

      ForEach(this.arrayStr, (item: string, index: number) => {
        Text(this.testResult + item)
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