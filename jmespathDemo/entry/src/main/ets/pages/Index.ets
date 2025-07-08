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

import JmesPath from 'jmespath';

interface TestExample {
  name: string;
  expression: string;
  case: string;
  result: string;
}

@Entry
@Component
struct Index {
  defaultExampleArray: TestExample[] = [{
    name: this.getStringSync($r('app.string.basic_expression').id),
    expression: 'a.b.c[0].d[1][0]',
    case: `{"a": {
      "b": {
        "c": [
          {"d": [0, [1, 2]]},
          {"d": [3, 4]}
        ]
      }
    }}`,
    result: '1'
  }, {
    name: this.getStringSync($r('app.string.section').id),
    expression: '[0:5]',
    case: '[0, 1, 2, 3, 4, 5, 6, 7, 8, 9]',
    result: `[
    0,
    1,
    2,
    3,
    4
    ]`
  }, {
    name: this.getStringSync($r('app.string.list_and_slice_projection').id),
    expression: 'people[*].first',
    case: `{
    "people": [
      {"first": "James", "last": "d"},
      {"first": "Jacob", "last": "e"},
      {"first": "Jayden", "last": "f"},
      {"missing": "different"}
    ],
    "foo": {"bar": "baz"}
  }`,
    result: `[
    "James",
    "Jacob",
    "Jayden"
    ]`
  }, {
    name: this.getStringSync($r('app.string.object_projection').id),
    expression: 'ops.*.numArgs',
    case: `{
      "ops": {
        "functionA": {"numArgs": 2},
        "functionB": {"numArgs": 3},
        "functionC": {"variadic": true}
      }
    }`,
    result: `[
      2,
      3
    ]`
  }, {
    name: this.getStringSync($r('app.string.zhan_ping_projection').id),
    expression: 'reservations[*].instances[*].state',
    case: `{
      "reservations": [
        {
          "instances": [
            {"state": "running"},
            {"state": "stopped"}
          ]
        },
        {
          "instances": [
            {"state": "terminated"},
            {"state": "running"}
          ]
        }
      ]
    }`,
    result: `[
      [
        "running",
        "stopped"
      ],
      [
        "terminated",
        "running"
      ]
    ]`
  }, {
    name: this.getStringSync($r('app.string.filter_projection').id),
    expression: "machines[?state=='running'].name",
    case: `{
    "machines": [
      {"name": "a", "state": "running"},
      {"name": "b", "state": "stopped"},
      {"name": "c", "state": "running"}
    ]
  }`,
    result: `[
      "a",
      "c"
    ]`
  }, {
    name: this.getStringSync($r('app.string.pipeline_expression').id),
    expression: 'people[*].first | [0]',
    case: `{
      "people": [
        {"first": "James", "last": "d"},
        {"first": "Jacob", "last": "e"},
        {"first": "Jayden", "last": "f"},
        {"missing": "different"}
      ],
      "foo": {"bar": "baz"}
    }`,
    result: '"James"'
  }, {
    name: this.getStringSync($r('app.string.multiple_choice').id),
    expression: 'people[].{Name: name, State: state.name}',
    case: `{
      "people": [
        {
          "name": "a",
          "state": {"name": "up"}
        },
        {
          "name": "b",
          "state": {"name": "down"}
        },
        {
          "name": "c",
          "state": {"name": "up"}
        }
      ]
    }`,
    result: `[
      {
        "Name": "a",
        "State": "up"
      },
      {
        "Name": "b",
        "State": "down"
      },
      {
        "Name": "c",
        "State": "up"
      }
    ]`
  }, {
    name: this.getStringSync($r('app.string.function').id),
    expression: 'max_by(people, &age).name',
    case: `{
      "people": [
        {
          "name": "b",
          "age": 30
        },
        {
          "name": "a",
          "age": 50
        },
        {
          "name": "c",
          "age": 40
        }
      ]
    }`,
    result: '"a"'
  }]
  @State expressionText: string = this.defaultExampleArray[0].expression
  @State caseText: string = this.defaultExampleArray[0].case
  @State resultText: string = this.defaultExampleArray[0].result


  getStringSync(id: number){
    try {
      return this.getUIContext().getHostContext()?.resourceManager.getStringSync(id) || "";
    }catch (e) {
      console.error("getStringSync");
      return "";
    }
  }
  build() {
    Scroll() {
      Column() {
        Text($r('app.string.select_example'))
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
        Select([{ value: $r('app.string.basic_expression') },
          { value: $r('app.string.section') },
          { value: $r('app.string.list_and_slice_projection') },
          { value: $r('app.string.object_projection') },
          { value: $r('app.string.zhan_ping_projection') },
          { value: $r('app.string.filter_projection') },
          { value: $r('app.string.pipeline_expression') },
          { value: $r('app.string.multiple_choice') },
          { value: $r('app.string.function') }])
          .selected(0)
          .value(this.getStringSync($r('app.string.basic_expression').id))
          .font({ size: 16, weight: 500 })
          .fontColor('#182431')
          .selectedOptionFont({ size: 16, weight: 400 })
          .optionFont({ size: 16, weight: 400 })
          .onSelect((index: number) => {
            this.expressionText = this.defaultExampleArray[index].expression
            this.caseText = this.defaultExampleArray[index].case
            this.resultText = this.defaultExampleArray[index].result
          })
        Text($r('app.string.input_expression'))
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
        Search({ value: this.expressionText })
          .searchButton(this.getStringSync($r('app.string.search').id))
          .width('95%')
          .height(40)
          .backgroundColor('#F5F5F5')
          .placeholderColor(Color.Black)
          .placeholderFont({ size: 14, weight: 400 })
          .textFont({ size: 14, weight: 400 })
          .onSubmit((value: string) => {
            if (!value || value === '') {
              this.resultText = this.getStringSync($r('app.string.expression_empty').id)
              return
            }
            try {
              let result: number | string = JmesPath.search(JSON.parse(this.caseText), value)
              if (result) {
                this.resultText = JSON.stringify(result)
              } else {
                this.resultText = this.getStringSync($r('app.string.no_corresponding_results_found').id)
              }
            } catch (error) {
              console.error(`Search exception, error: ${error.message}.`)
              this.resultText = this.getStringSync($r('app.string.search_exception').id)
            }
          })
        Text($r('app.string.test_data'))
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
        TextArea({ text: this.caseText })
          .placeholderFont({ size: 16, weight: 400 })
          .width(336)//.height(a)
          .margin(10)
          .fontSize(16)
          .fontColor('#ff1f1f1f')
          .backgroundColor('#fff3f3f3')
          .onChange((value: string) => {
            this.caseText = value
          })
        Text($r('app.string.test_result'))
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
        Text(this.resultText)
          .fontSize(20)
          .margin(10)
          .padding(10)
          .borderRadius(10)
          .width('90%')
          .fontSize(16)
          .fontColor('#ff1f1f1f')
          .backgroundColor('#ffc3c3c3')
          .fontWeight(FontWeight.Bold)
      }.width('100%')
      .alignItems(HorizontalAlign.Start)
      .margin({ top: 5, left: 10, bottom: 50, right: 10 })
    }
    .scrollable(ScrollDirection.Vertical)
    .scrollBar(BarState.On)
    .scrollBarColor(Color.Gray)
    .scrollBarWidth(10)
  }
}