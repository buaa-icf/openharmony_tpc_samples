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

import { timer, interval, of, merge, from, Notification } from 'rxjs';
import { mapTo, delay, map, tap, delayWhen, dematerialize, concatMap, catchError, timeout, take } from 'rxjs';
import Log from '../log'
import { MyButton } from '../common/MyButton'

@Entry
@Component
struct Tool {
  build() {
    Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Center }) {
      MyButton({
        content: $r("app.string.Do_tap_content"), onClickListener: () => {
          this.tap();
        }
      })

      MyButton({
        content: $r("app.string.Delay_content"), onClickListener: () => {
          this.delay();
        }
      })

      MyButton({
        content: $r("app.string.DelayWhen_content"), onClickListener: () => {
          this.delayWhen();
        }
      })

      MyButton({
        content: $r("app.string.Dematerialize_content"), onClickListener: () => {
          this.dematerialize();
        }
      })

      MyButton({
        content: $r("app.string.Timeout_content"), onClickListener: () => {
          this.timeout();
        }
      })
    }
    .width('100%')
    .height('100%')
  }

  tap() {
    const source = of(1, 2, 3, 4, 5);
    const example: ESObject = source.pipe(
      tap((val: ESObject) => {
        Log.showLog(`tap--BEFORE MAP: ${val}`)
      }),
      map((val: ESObject) => {
        val + 10
      }),
      tap((val: ESObject) => {
        Log.showLog(`tap--AFTER MAP: ${val}`)
      })
    );
    const subscribe: ESObject = example.subscribe((val: ESObject) => {
      Log.showLog('tap--' + val)
    });
  }

  delay() {
    const example = of(null);
    const message = merge(
      example.pipe(mapTo('Hello')),
      example.pipe(
        mapTo('World!'),
        delay(1000)
      ),
      example.pipe(
        mapTo('Goodbye'),
        delay(2000)
      ),
      example.pipe(
        mapTo('World!'),
        delay(3000)
      )
    );
    const subscribe = message.subscribe((val: ESObject) => {
      Log.showLog('delay--' + val)
    });
  }

  delayWhen() {
    const message = interval(1000);
    const delayForFiveSeconds = () => timer(5000);
    const delayWhenExample = message.pipe(delayWhen(delayForFiveSeconds), take(5));
    const subscribe = delayWhenExample.subscribe((val: ESObject) => {
      Log.showLog('delayWhen--' + val)
    });
  }

  dematerialize() {
    const source = from([
      Notification.createNext('SUCCESS!'),
      Notification.createError('ERROR!')
    ]).pipe(
      dematerialize()
    )
    const subscription = source.subscribe({
      next: (val: ESObject) => Log.showLog(`dematerialize--NEXT VALUE: ${val}`),
      error: (val: ESObject) => Log.showLog(`dematerialize--ERROR VALUE: ${val}`)
    });
  }

  timeout() {
    of(4000, 3000, 2000)
      .pipe(
        concatMap(duration =>
        this.makeRequest(duration)
          .pipe(
            timeout(2500),
            catchError((error: ESObject) => of(`Request timed out after: ${duration}`)))
        )
      )
      .subscribe((val: ESObject) => {
        Log.showLog('timeout--' + val)
      });
  }

  makeRequest(timeToDelay: ESObject) {
    return of('Request Complete!').pipe(delay(timeToDelay));
  }
}