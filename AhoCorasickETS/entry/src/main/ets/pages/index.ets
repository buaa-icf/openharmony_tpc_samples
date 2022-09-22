/*
 * Copyright (C) 2021 Huawei Device Co., Ltd.
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
// @ts-ignore
//var AhoCorasick = require('ahocorasick');
import AhoCorasick from 'ahocorasick'


@Extend(Text) function textFancy (fontSize: number, textColor: Color, isBold: Boolean) {
  .fontSize(fontSize)
  .fontColor(textColor)
  .fontWeight(isBold ? FontWeight.Bold : FontWeight.Normal)
}

@Extend(Button) function buttonFancy () {
  .type(ButtonType.Capsule)
  .width(90)
  .height(40)
  .align(Alignment.Center)
}

@Entry
@Component
struct Index {
  //语句段落
  @State statement: string = 'should find keyword1 at position 19 and keyword2 at position 47.'
  //段落中的制定词汇
  @State formulate_statement: string = 'keyword1'
  @State resultText: string = ''

  build() {
    Column() {
      Text("输入一个可依据的段落进行下一步的匹配搜索 ↓").textFancy(12, Color.Green, true).margin(10)
      TextInput({ placeholder: '', text: this.statement })
        .onChange((value: string) => {
          this.statement = value;
        })
        .width('100%')
        .margin(15)


      Text("单次只可输入一个搜索内容，请输入与上边段落被包含关系的内容 ↓").textFancy(12, Color.Green, true).margin(10)
      TextInput({ placeholder: '', text: this.formulate_statement })
        .onChange((value: string) => {
          this.formulate_statement = value;
        })
        .width('100%')
        .margin(15)

      Button() {
        Text('搜索指定内容索引').textFancy(13, Color.White, false)
      }
      .buttonFancy()
      .onClick(() => {

        var ahoCorasick = new AhoCorasick([this.formulate_statement]);
        var results = ahoCorasick.search(this.statement);
        this.resultText = JSON.stringify(results);

      }).width(200)

      Text(this.resultText).textFancy(12, Color.Black, true).margin(30)
    }.width('100%')
  }
}