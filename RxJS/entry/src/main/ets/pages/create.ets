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

import { Observable, empty, of, interval, from, range, throwError, timer } from 'rxjs';
import Log from '../log'
import { MyButton } from '../common/MyButton'

@Entry
@Component
struct Create {
  build() {
    Scroll() {
      Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Center }) {
        MyButton({
          content: $r("app.string.Create_content"), onClickListener: () => {
            this.create();
          }
        })

        MyButton({
          content: $r("app.string.Empty_content"), onClickListener: () => {
            this.empty();
          }
        })

        MyButton({
          content: $r("app.string.From_content"), onClickListener: () => {
            this.fromArray();
          }
        })

        MyButton({
          content: $r("app.string.Interval_content"), onClickListener: () => {
            this.intervalNum();
          }
        })

        MyButton({
          content: $r("app.string.Of_content"), onClickListener: () => {
            this.ofNum();
          }
        })

        MyButton({
          content: $r("app.string.Rang_content"), onClickListener: () => {
            this.rang();
          }
        })

        MyButton({
          content: $r("app.string.Throw_content"), onClickListener: () => {
            this.throwError();
          }
        })

        MyButton({
          content: $r("app.string.Timer_content"), onClickListener: () => {
            this.timer();
          }
        })

        Text($r("app.string.FromEvent_content"))
          .fontSize(15)
          .width(330)
          .height(50)
          .fontColor('#ffffff')
          .backgroundColor('#dddddd')
          .margin({ top: 25, left: 20, right: 20 })
      }
    }
    .width('100%')
    .height('100%')
  }

  create() {
    const observable: ESObject = Observable.create((observer: ESObject) => {
      observer.next('Hello');
      observer.next('World');
      setTimeout(() => {
        observer.complete();
      }, 1000)
    });
    const observer: ESObject = {
      next: (x: ESObject) => {
        Log.showLog('create--' + x)
      },
      error: (err: ESObject) => {
        Log.showError('create--Observer got an error: ' + err)
      },
      complete: () => {
        Log.showLog('create--complete')
      },
    };
    const subscription: ESObject = observable.subscribe(observer);
  }

  empty() {
    const subscribe = empty().subscribe({
      next: () => Log.showLog('empty--Next'),
      complete: () => Log.showLog('empty--Complete!')
    });
  }

  fromArray() {
    const arraySource = from([1, 2, 3, 4, 5]);
    const subscribe = arraySource.subscribe(val => {
      Log.showLog('from--' + val)
    });
  }

  intervalNum() {
    const source = interval(1000);
    const subscribe = source.subscribe(val => {
      Log.showLog('interval--' + val)
      if (val > 4) {
        subscribe.unsubscribe();
      }
    });
  }

  ofNum() {
    const source = of(1, 2, 3, 4, 5);
    const subscribe = source.subscribe((val) => {
      Log.showLog('of--' + val)
    });
  }

  rang() {
    const source = range(1, 10);
    const example = source.subscribe((val) => {
      Log.showLog('rang--' + val)
    });
  }

  throwError() {
    const source = throwError('This is an error!');
    const subscribe = source.subscribe({
      next: val => Log.showLog('throwError--' + val),
      complete: () => Log.showLog('throwError--Complete!'),
      error: (val: ESObject) => {
        Log.showLog(`throwError--Error: ${val}`)
      }
    });
  }

  timer() {
    const source = timer(1000, 2000);
    const subscribe = source.subscribe(val => {
      Log.showLog('timer--' + val)
      if (val > 4) {
        subscribe.unsubscribe();
      }
    });
  }
}

