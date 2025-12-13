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

import { ControllerState, RiveAnimationView} from '@ohos/rive';
import { TitleBar } from '../common/TitleBar';

@Entry
@Component
struct RecyclerPage {
  private arr: number[] = [];
  private totalColumn: number = 200;
  private useSharedFile = true;
  @State stateMap: Map<number, ControllerState | null | undefined> = new Map();
  @State riveViewMap: Map<number, RiveAnimationView | null | undefined> = new Map();

  aboutToAppear() {
    for (let index = 0; index < this.totalColumn; index++) {
      this.arr.push(index);
    }
  }

  aboutToDisappear(): void {
    this.stateMap.clear()
    this.riveViewMap.clear();
    this.arr = [];
  }

  getItem(position:number):  string{
    let riveResource = '';
    if(position % 2 === 1){
      riveResource = '@rawfile/basketball.riv';
    }else{
      riveResource = '@rawfile/circle_move.riv';
    }
    return riveResource;
  }

  build() {
    Column() {
      TitleBar()
      Scroll() {
        Grid() {
          Repeat<number>(this.arr)
            .each((ri: RepeatItem<number>) => {
              GridItem() {
                Row() {
                  RiveAnimationView({
                    riveResource: `${this.useSharedFile ? '@rawfile/basketball.riv': this.getItem(ri.index)}`,
                    riveAutoPlay: true,
                    onReady: (view) => {
                      this.riveViewMap.set(ri.index, view);
                    }
                  })
                    .width('100%')
                    .height('18%')
                }
                .onVisibleAreaChange(
                  [0.5, 1.0],
                  (isVisible: boolean, currentRatio: number) => {
                    if (currentRatio >= 0.5 && isVisible) {
                      if (this.stateMap.has(ri.index)) {
                        const savedState = this.stateMap.get(ri.index);
                        if (savedState) {
                          let riveView = this.riveViewMap.get(ri.index);
                          riveView?.play();
                          riveView?.controller?.restoreControllerState(savedState);
                          this.stateMap.set(ri.index, null);
                        }
                      }
                    } else if (!isVisible && currentRatio > 0 && currentRatio < 0.5) {
                      const view = this.riveViewMap.get(ri.index);
                      if (view?.controller && !this.stateMap.get(ri.index)) {
                        const savedState = view.controller.saveControllerState();
                        view.pause();
                        if (savedState) {
                          this.stateMap.set(ri.index, savedState);
                        }
                      }
                    }
                  })
              }
            })
            .virtualScroll({ totalCount: this.arr.length })
        }
        .width('100%')
        .height('100%')
        .columnsTemplate('1fr 1fr 1fr')
        .columnsGap(5)
        .rowsGap(5)

      }
      .width('100%')
      .height('100%')
    }
    .width('100%')
    .height('100%')
  }
}