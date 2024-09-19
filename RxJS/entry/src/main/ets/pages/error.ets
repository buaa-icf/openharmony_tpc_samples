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

import { timer, interval, throwError, of } from 'rxjs';
import { catchError, mergeMap, retry, map, tap, retryWhen, delayWhen, take } from 'rxjs';
import Log from '../log'
import { MyButton } from '../common/MyButton'
import { retryWhenLogic } from './ArkTools';

@Entry
@Component
struct Error {
  build() {
    Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Center }) {
      MyButton({
        content: $r("app.string.CatchError_content"), onClickListener: () => {
          this.catchError();
        }
      })

      MyButton({
        content: $r("app.string.Retry_content"), onClickListener: () => {
          this.retry();
        }
      })

      MyButton({
        content: $r("app.string.RetryWhen_content"), onClickListener: () => {
          this.retryWhen();
        }
      })
    }
    .width('100%')
    .height('100%')
  }

  catchError() {
    const source = throwError('This is an error!');
    const example = source.pipe(catchError((val: ESObject) => of(`I caught: ${val}`)));
    const subscribe = example.subscribe((val: ESObject) => {
      Log.showLog('catchError--' + val)
    });
  }

  retry() {
    const source = interval(1000);
    const example = source.pipe(
      mergeMap(val => {
        if (val > 5) {
          return throwError('Error!');
        }
        return of(val);
      }),
      retry(2)
    );
    const subscribe = example.subscribe({
      next: val => Log.showLog('retry--' + val),
      error: (val: ESObject) => Log.showLog(`retry--${val}: Retried 2 times then quit!`)
    });
  }

  retryWhen() {
    const source = interval(1000).pipe(take(10));
    const example = source.pipe(
      map(val => retryWhenLogic(val)),
      retryWhen((errors: ESObject) =>
      errors.pipe(
        tap((val: ESObject) => {
          Log.showLog(`retryWhen--Value ${val} was too high!`)
        }),
        delayWhen((val: ESObject) => timer(val * 1000))
      )
      )
    );
    let count = 0;
    const that = this;
    const subscribe = example.subscribe({
      next: (val) => {
        Log.showLog(val + '')
        count += val
        if (count >= 30) {
          that.close(subscribe);
        }
      }
    });
  }

  close(subscribe: ESObject) {
    setTimeout(() => {
      subscribe.unsubscribe();
    }, 2000)
  }
}