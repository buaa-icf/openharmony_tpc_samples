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

import { of, interval, from, range, throwError, timer } from 'rxjs';
import {
  debounce,
  take,
  debounceTime,
  distinctUntilChanged,
  filter,
  takeWhile,
  throttle,
  first,
  ignoreElements,
  last,
  sample,
  single,
  skip,
  skipUntil,
  skipWhile,
  takeUntil,
  throttleTime
} from 'rxjs';
import Log from '../log'
import { MyButton } from '../common/MyButton'

@Entry
@Component
struct Create {
  build() {
    Scroll() {
      Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Center }) {
        MyButton({
          content: $r("app.string.Debounce_content"),
          onClickListener: () => {
            this.debounce();
          }
        })

        MyButton({
          content: $r("app.string.DebounceTime_content"), onClickListener: () => {
            this.debounceTime();
          }
        })

        MyButton({
          content: $r("app.string.DistinctUntilChanged_content"),
          onClickListener: () => {
            this.distinctUntilChanged();
          }
        })

        MyButton({
          content: $r("app.string.Filter_content"), onClickListener: () => {
            this.filter();
          }
        })

        MyButton({
          content: $r("app.string.First_content"), onClickListener: () => {
            this.first();
          }
        })

        MyButton({
          content: $r("app.string.IgnoreElements_content"), onClickListener: () => {
            this.ignoreElements();
          }
        })

        MyButton({
          content: $r("app.string.Last_content"), onClickListener: () => {
            this.last();
          }
        })

        MyButton({
          content: $r("app.string.Sample_content"), onClickListener: () => {
            this.sample();
          }
        })

        MyButton({
          content: $r("app.string.Single_content"), onClickListener: () => {
            this.single();
          }
        })

        MyButton({
          content: $r("app.string.Skip_content"), onClickListener: () => {
            this.skip();
          }
        })

        MyButton({
          content: $r("app.string.SkipUntil_content"), onClickListener: () => {
            this.skipUntil();
          }
        })

        MyButton({
          content: $r("app.string.SkipWhile_content"), onClickListener: () => {
            this.skipWhile();
          }
        })

        MyButton({
          content: $r("app.string.Take_content"), onClickListener: () => {
            this.take();
          }
        })

        MyButton({
          content: $r("app.string.TakeUntil_content"), onClickListener: () => {
            this.takeUntil();
          }
        })

        MyButton({
          content: $r("app.string.TakeWhile_content"), onClickListener: () => {
            this.takeWhile();
          }
        })

        MyButton({
          content: $r("app.string.Throttle_content"),
          onClickListener: () => {
            this.throttle();
          }
        })

        MyButton({
          content: $r("app.string.ThrottleTime_content"), onClickListener: () => {
            this.throttleTime();
          }
        })
      }
    }
    .width('100%')
    .height('100%')

  }

  debounce() {
    const example = of('WAIT', 'ONE', 'SECOND', 'Last will display');
    const debouncedExample = example.pipe(debounce(() => timer(1000)));
    const subscribe = debouncedExample.subscribe(val => {
      Log.showLog('debounce--' + val)
    });
  }

  debounceTime() {
    const example = interval(500).pipe(take(7));
    const debouncedInput = example.pipe(debounceTime(1000));
    const subscribe = debouncedInput.subscribe(val => {
      Log.showLog(`debounceTime--${val}`);
    });
  }

  distinctUntilChanged() {
    const myArrayWithDuplicatesInARow = from([1, 1, 2, 2, 3, 1, 2, 3]);

    const distinctSub = myArrayWithDuplicatesInARow
      .pipe(distinctUntilChanged())
      .subscribe(val => {
        Log.showLog('distinctUntilChanged--' + val)
      });

    const nonDistinctSub = myArrayWithDuplicatesInARow
      .subscribe(val => {
        Log.showLog('distinctUntilChanged--' + val)
      });
  }

  filter() {
    const source = from([1, 2, 3, 4, 5]);
    const example = source.pipe(filter(num => num % 2 === 0));
    const subscribe = example.subscribe(val => {
      Log.showLog(`filter--${val}`)
    });
  }

  first() {
    const source = from([1, 2, 3, 4, 5]);
    const example = source.pipe(first());
    const subscribe = example.subscribe(val => {
      Log.showLog(`first--${val}`)
    });
  }

  ignoreElements() {
    const source = interval(100);
    const example = source.pipe(
      take(5),
      ignoreElements()
    );
    const subscribe = example.subscribe(
      val => Log.showLog(`ignoreElements--NEXT: ${val}`),
      (val: ESObject) => {
        Log.showLog(`ignoreElements--ERROR: ${val}`)
      },
      () => Log.showLog('ignoreElements--COMPLETE!')
    );
  }

  last() {
    const source = from([1, 2, 3, 4, 5]);
    const example = source.pipe(last());
    const subscribe = example.subscribe(val => {
      Log.showLog(`last--${val}`)
    });
  }

  sample() {
    const source = interval(1000);
    const example = source.pipe(sample(interval(2000)), take(5));
    const subscribe = example.subscribe(val => {
      Log.showLog('sample--' + val)
    });
  }

  single() {
    const source = from([1, 2, 3, 4, 5]);
    const example = source.pipe(single(val => val === 4));
    const subscribe = example.subscribe(val => {
      Log.showLog('single--' + val)
    });
  }

  skip() {
    const source = interval(1000);
    const example = source.pipe(skip(5), take(4));
    const subscribe = example.subscribe(val => {
      Log.showLog('skip--' + val)
    });
  }

  skipUntil() {
    const source = interval(1000);
    const example = source.pipe(skipUntil(timer(6000)), take(4));
    const subscribe = example.subscribe(val => {
      Log.showLog('skipUntil--' + val)
    });
  }

  skipWhile() {
    const source = interval(1000);
    const example = source.pipe(skipWhile(val => val < 5), take(4));
    const subscribe = example.subscribe(val => {
      Log.showLog('skipWhile--' + val)
    });
  }

  take() {
    const source = of(1, 2, 3, 4, 5);
    const example = source.pipe(take(1));
    const subscribe = example.subscribe(val => {
      Log.showLog('take--' + val)
    });
  }

  takeUntil() {
    const source = interval(1000);
    const timer$ = timer(5000);
    const example = source.pipe(takeUntil(timer$));
    const subscribe = example.subscribe(val => {
      Log.showLog('takeUntil--' + val)
    });
  }

  takeWhile() {
    const source = of(1, 2, 3, 4, 5);
    const example = source.pipe(takeWhile(val => val <= 4));
    const subscribe = example.subscribe(val => {
      Log.showLog('takeWhile--' + val)
    });
  }

  throttle() {
    const source = interval(1000);
    const example = source.pipe(throttle(val => interval(2000)), take(4));
    const subscribe = example.subscribe(val => {
      Log.showLog('throttle--' + val)
    });
  }

  throttleTime() {
    const source = interval(1000);
    const example = source.pipe(throttleTime(5000), take(3));
    const subscribe = example.subscribe(val => {
      Log.showLog('throttleTime--' + val)
    });
  }
}

