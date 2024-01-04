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
import { from, firstValueFrom, EMPTY, EmptyError, throwError, of, Observable } from 'rxjs';
import { finalize } from 'rxjs';
import { expect, describe, it } from '@ohos/hypium';

export default function firstValueFromTest() {
  describe('firstValueFrom', () => {
    it('should_emit_the_first_value_as_a_promise', 0, async () => {
      let finalized = false;
      const source = from([0, 1, 2, 3, 4, 5]).pipe(finalize(() => (finalized = true)));
      const result = await firstValueFrom(source);
      expect(finalized).assertTrue();
      expect(result).assertEqual(0);

    });

    it('should_support_a_default_value', 0, async () => {
      const source = EMPTY;
      const result = await firstValueFrom(source, {
        defaultValue: 0
      });
      expect(result).assertEqual(0);
    });

    it('should_support_an_undefined_config', 0, async () => {
      const source = EMPTY;
      let error: ESObject = null;
      try {
        await firstValueFrom(source, undefined as ESObject);
      } catch (err) {
        error = err;
      }
      expect(error instanceof EmptyError).assertTrue();
    });

    it('should_error_for_empty_observables', 0, async () => {
      const source = EMPTY;
      let error: ESObject = null;
      try {
        await firstValueFrom(source);
      } catch (err) {
        error = err;
      }
      expect(error instanceof EmptyError).assertTrue();
    });

    it('should_error_for_errored_observables', 0, async () => {
      const source = throwError(() => new Error('blorp!'));
      let error: ESObject = null;
      try {
        await firstValueFrom(source);
      } catch (err) {
        error = err;
      }
      expect(error).assertInstanceOf('Error');
      expect(error.message).assertEqual('blorp!');
    });

    it('should_work_with_a_synchronous_observable', 0, async () => {
      let finalized = false;
      const source = of('apples', 'bananas').pipe(finalize(() => (finalized = true)));
      const result = await firstValueFrom(source);
      expect(result).assertEqual('apples');
      expect(finalized).assertTrue();
    });

    it('should_stop_listening_to_a_synchronous_observable_when_resolved', 0, async () => {
      const sideEffects: number[] = [];
      const synchronousObservable = new Observable<number>(subscriber => {
        // This will check to see if the subscriber was closed on each loop
        // when the unsubscribe hits (from the `take`), it should be closed
        for (let i = 0;!subscriber.closed && i < 10; i++) {
          sideEffects.push(i);
          subscriber.next(i);
        }
      });
      const result = await firstValueFrom(synchronousObservable);
      expect(sideEffects.length).assertEqual(1);
      expect(sideEffects[0]).assertEqual(0);
    });
  });
}