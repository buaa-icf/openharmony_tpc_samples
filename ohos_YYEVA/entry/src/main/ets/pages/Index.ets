/*
 * Copyright (C) 2025 Huawei Device Co., Ltd.
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

import { EvaDemo } from './EvaDemo';
import { EvaDownloadDemo } from './EvaDownloadDemo';
import { EvaListDemo } from './EvaListDemo';

@Entry
@Component
struct Index {
  @State currentPage: string = 'main'
  @Provide('pageInfos') pageInfos: NavPathStack = new NavPathStack()
  private arr: string[] = ['Eva Demo', 'Eva Download Demo', 'Eva List Demo'];

  build(): void {
    Navigation(this.pageInfos) {
      List({ space: 12 }) {
        ForEach(this.arr, (item: string) => {
          ListItem() {
            Text(item)
              .width('100%')
              .height(72)
              .backgroundColor(Color.Blue)
              .borderRadius(24)
              .fontColor(Color.White)
              .fontSize(16)
              .fontWeight(500)
              .textAlign(TextAlign.Center)
              .onClick(() => {
                this.pageInfos.replacePath({ name: item });
              })
          }
        }, (item: number) => item.toString())
      }
      .width('90%')
      .margin({ top: 12 })
    }.mode(NavigationMode.Auto)
    .title('YYEVA')
    .navDestination(this.pageMap)
  }

  @Builder
  pageMap(name: string) {
    if (name === this.arr[0]) {
      EvaDemo({ title: this.arr[0] });
    } else if (name === this.arr[1]) {
      EvaDownloadDemo({ title: this.arr[1] });
    } else if (name === this.arr[2]) {
      EvaListDemo({ title: this.arr[2] });
    }
  }
}