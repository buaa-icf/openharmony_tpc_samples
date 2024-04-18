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
import { describe, expect, beforeEach, afterEach, it, TestType } from '@ohos/hypium';
import { Observer, TeardownLogic } from 'rxjs/internal/types';
import {
  Observable,
  config,
  Subscription,
  Subscriber,
  Operator,
  NEVER,
  Subject,
  of,
  throwError,
  empty
} from 'rxjs';
import {
  map,
  multicast,
  refCount,
  filter,
  count,
  combineLatest,
  concat,
  merge,
  race,
  zip,
  publish,
  publishLast,
  publishBehavior,
  share
} from 'rxjs';
import { TestScheduler, RunHelpers } from 'rxjs/internal/testing/TestScheduler';
import { observableMatcher } from '../spec//helpers/observableMatcher';

import { BindFun, EmptyFun, MyPromise1, observableOperator, observableSource, SourceFun } from './ArkTools';
import {
  ObjectUnsubscribedError,
  AsyncSubject,
} from 'rxjs';
import { catchError, delay, mergeMap } from 'rxjs';
import { InstanceofFun, ObjFun } from './ArkTools';
const BASE_COUNT: number = 2000;
function expectFullObserver(val: ESObject) {
  expect(val instanceof Object).assertTrue();
  expect(val.next instanceof Function).assertTrue();
  expect(val.error instanceof Function).assertTrue();
  expect(val.complete instanceof Function).assertTrue();
  expect(val.closed).assertFalse();
}

export default function DurationTest() {
  /** @test {Subject} */
  describe('Subject', () => {
    let rxTestScheduler: TestScheduler;

    beforeEach(() => {
      rxTestScheduler = new TestScheduler(observableMatcher);
    });

    it('should_allow_next_with_undefined_or_any_when_created_with_no_type', 0, (done: ESObject) => {
      const subject: ESObject = new Subject<ESObject>();
      subject.subscribe(
        {
          next: (x: ESObject) => {
            expect(x).assertUndefined();
          }, complete: done
        }
      );

      const data: ESObject = undefined;
      subject.next(undefined);
      subject.next(data);
      subject.complete();
      let startTime = new Date().getTime()
      for (let index = 0; index < BASE_COUNT; index++) {
        subject.next(undefined);
      }
      endTime(startTime, 'should_allow_next_with_undefined_or_any_when_created_with_no_type');
    });

    it('should_allow_empty_next_when_created_with_void_type', 0, (done: ESObject) => {
      const subject = new Subject<void>();
      subject.subscribe(
        {
          next: (x) => {
            expect(x).assertUndefined();
          }, complete: done
        }
      );

      subject.next();
      subject.complete();
      let startTime = new Date().getTime()
      for (let index = 0; index < BASE_COUNT; index++) {
        subject.complete();
      }
      endTime(startTime, 'should_allow_empty_next_when_created_with_void_type');
    });

    it('should_pump_values_right_on_through_itself', 0, (done: ESObject) => {
      const subject = new Subject<string>();
      const expected = ['foo', 'bar'];

      subject.subscribe(
        {
          next: (x: string) => {
            expect(x).assertEqual(expected.shift());
          }, complete: done
        }
      );

      subject.next('foo');
      subject.next('bar');
      subject.complete();
      let startTime = new Date().getTime()
      for (let index = 0; index < BASE_COUNT; index++) {
        new Subject<string>();
      }
      endTime(startTime, 'should_pump_values_right_on_through_itself');
    });

    it('should_pump_values_to_multiple_subscribers', 0, (done: ESObject) => {
      const subject = new Subject<string>();
      const expected = ['foo', 'bar'];

      let i = 0;
      let j = 0;

      subject.subscribe((x) => {
        expect(x).assertEqual(expected[i++]);
      });

      subject.subscribe(
        {
          next: (x) => {
            expect(x).assertEqual(expected[j++]);
          }, complete: done
        }
      );

      expect(subject.observers.length).assertEqual(2);
      subject.next('foo');
      subject.next('bar');
      subject.complete();

      let startTime = new Date().getTime()
      for (let index = 0; index < BASE_COUNT; index++) {
        new Subject<string>();
      }
      endTime(startTime, 'should_pump_values_to_multiple_subscribers');
    });

    it('should_handle_subscribers_that_arrive_and_leave_t_different_times_subject_does_not_complete', 0, () => {
      const subject = new Subject<number>();
      const results1: (number | string)[] = [];
      const results2: (number | string)[] = [];
      const results3: (number | string)[] = [];

      subject.next(1);
      subject.next(2);
      subject.next(3);
      subject.next(4);

      const subscription1 = subject.subscribe(
        {
          next: (x) => {
            results1.push(x);
          }, error: () => {
          results1.push('E');
        }, complete: () => {
          results1.push('C');
        }
        }
      );

      subject.next(5);

      const subscription2 = subject.subscribe(
        {
          next: (x) => {
            results2.push(x);
          }, error: () => {
          results2.push('E');
        }, complete: () => {
          results2.push('C');
        }
        }
      );

      subject.next(6);
      subject.next(7);

      subscription1.unsubscribe();

      subject.next(8);

      subscription2.unsubscribe();

      subject.next(9);
      subject.next(10);

      const subscription3 = subject.subscribe(
        {
          next: (x) => {
            results3.push(x);
          }, error: () => {
          results3.push('E');
        }, complete: () => {
          results3.push('C');
        }
        }
      );

      subject.next(11);

      subscription3.unsubscribe();

      expect(results1).assertDeepEquals([5, 6, 7]);
      expect(results2).assertDeepEquals([6, 7, 8]);
      expect(results3).assertDeepEquals([11]);
      let startTime = new Date().getTime()
      for (let index = 0; index < BASE_COUNT; index++) {
        subject.next(10);
      }
      endTime(startTime, 'should_handle_subscribers_that_arrive_and_leave_t_different_times_subject_does_not_complete');
    });

    it('should_handle_subscribers_that_arrive_and_leave_at_different_times_subject_completes', 0, () => {
      const subject = new Subject<number>();
      const results1: (number | string)[] = [];
      const results2: (number | string)[] = [];
      const results3: (number | string)[] = [];

      subject.next(1);
      subject.next(2);
      subject.next(3);
      subject.next(4);

      const subscription1 = subject.subscribe(
        {
          next: (x) => {
            results1.push(x);
          }, error: () => {
          results1.push('E');
        }, complete: () => {
          results1.push('C');
        }
        }
      );

      subject.next(5);

      const subscription2 = subject.subscribe(
        {
          next: (x) => {
            results2.push(x);
          }, error: () => {
          results2.push('E');
        }, complete: () => {
          results2.push('C');
        }
        }
      );

      subject.next(6);
      subject.next(7);

      subscription1.unsubscribe();

      subject.complete();

      subscription2.unsubscribe();

      const subscription3 = subject.subscribe(
        {
          next: (x) => {
            results3.push(x);
          }, error: () => {
          results3.push('E');
        }, complete: () => {
          results3.push('C');
        }
        }
      );

      subscription3.unsubscribe();

      expect(results1).assertDeepEquals([5, 6, 7]);
      expect(results2).assertDeepEquals([6, 7, 'C']);
      expect(results3).assertDeepEquals(['C']);
      let startTime = new Date().getTime()
      for (let index = 0; index < BASE_COUNT; index++) {
        subject.next(7);
      }
      endTime(startTime, 'should_handle_subscribers_that_arrive_and_leave_at_different_times_subject_completes');
    });

    it('should_handle_subscribers_that_arrive_and_leave_at_different_imes_subject_terminates_with_an_error', 0, () => {
      const subject = new Subject<number>();
      const results1: (number | string)[] = [];
      const results2: (number | string)[] = [];
      const results3: (number | string)[] = [];

      subject.next(1);
      subject.next(2);
      subject.next(3);
      subject.next(4);

      const subscription1 = subject.subscribe(
        {
          next: (x) => {
            results1.push(x);
          }, error: () => {
          results1.push('E');
        }, complete: () => {
          results1.push('C');
        }
        }
      );

      subject.next(5);

      const subscription2 = subject.subscribe(
        {
          next: (x) => {
            results2.push(x);
          }, error: () => {
          results2.push('E');
        }, complete: () => {
          results2.push('C');
        }
        }
      );

      subject.next(6);
      subject.next(7);

      subscription1.unsubscribe();

      subject.error(new Error('err'));

      subscription2.unsubscribe();

      const subscription3 = subject.subscribe(
        {
          next: (x) => {
            results3.push(x);
          }, error: () => {
          results3.push('E');
        }, complete: () => {
          results3.push('C');
        }
        }
      );

      subscription3.unsubscribe();

      expect(results1).assertDeepEquals([5, 6, 7]);
      expect(results2).assertDeepEquals([6, 7, 'E']);
      expect(results3).assertDeepEquals(['E']);
      let startTime = new Date().getTime()
      for (let index = 0; index < BASE_COUNT; index++) {
        subject.next(7);
      }
      endTime(startTime, 'should_handle_subscribers_that_arrive_and_leave_at_different_imes_subject_terminates_with_an_error');
    });

    it('should_handle_subscribers_that_arrive_and_leave_at_different_times_subject_completes_before_nexting_any_value', 0, () => {
      const subject = new Subject<number>();
      const results1: (number | string)[] = [];
      const results2: (number | string)[] = [];
      const results3: (number | string)[] = [];

      const subscription1 = subject.subscribe(
        {
          next: (x) => {
            results1.push(x);
          }, error: () => {
          results1.push('E');
        }, complete: () => {
          results1.push('C');
        }
        }
      );

      const subscription2 = subject.subscribe(
        {
          next: (x) => {
            results2.push(x);
          }, error: () => {
          results2.push('E');
        }, complete: () => {
          results2.push('C');
        }
        }
      );

      subscription1.unsubscribe();

      subject.complete();

      subscription2.unsubscribe();

      const subscription3 = subject.subscribe(
        {
          next: (x) => {
            results3.push(x);
          }, error: () => {
          results3.push('E');
        }, complete: () => {
          results3.push('C');
        }
        }
      );

      subscription3.unsubscribe();

      expect(results1).assertDeepEquals([]);
      expect(results2).assertDeepEquals(['C']);
      expect(results3).assertDeepEquals(['C']);
      let startTime = new Date().getTime()
      for (let index = 0; index < BASE_COUNT; index++) {
        subject.complete();
      }
      endTime(startTime, 'should_handle_subscribers_that_arrive_and_leave_at_different_times_subject_completes_before_nexting_any_value');
    });

    it('should_disallow_new_subscriber_once_subject_has_been_disposed', 0, () => {
      const subject = new Subject<number>();
      const results1: (number | string)[] = [];
      const results2: (number | string)[] = [];
      const results3: (number | string)[] = [];

      const subscription1 = subject.subscribe(
        {
          next: (x) => {
            results1.push(x);
          }, error: () => {
          results1.push('E');
        }, complete: () => {
          results1.push('C');
        }
        }
      );

      subject.next(1);
      subject.next(2);

      const subscription2 = subject.subscribe(
        {
          next: (x) => {
            results2.push(x);
          }, error: () => {
          results2.push('E');
        }, complete: () => {
          results2.push('C');
        }
        }
      );

      subject.next(3);
      subject.next(4);
      subject.next(5);

      subscription1.unsubscribe();
      subscription2.unsubscribe();
      subject.unsubscribe();

      let error: ESObject = null;
      try {
        subject.subscribe(
          {
            next: (x) => {
              results3.push(x);
            }, error: () => {
          }
          }
        );
      } catch (err) {
        error = err;
      }
      expect(error != null && error instanceof ObjectUnsubscribedError).assertTrue();

      expect(results1).assertDeepEquals([1, 2, 3, 4, 5]);
      expect(results2).assertDeepEquals([3, 4, 5]);
      expect(results3.length == 0).assertTrue();

      let startTime = new Date().getTime()
      for (let index = 0; index < BASE_COUNT; index++) {
        new Subject<number>();
      }
      endTime(startTime, 'should_disallow_new_subscriber_once_subject_has_been_disposed');
    });

    it('should_not_allow_values_to_be_nexted_after_it_is_unsubscribed', 0, (done: ESObject) => {
      const subject = new Subject<string>();
      const expected = ['foo'];
      let err: ESObject = null;

      subject.subscribe((x) => {
        expect(x).assertEqual(expected.shift());
      });

      subject.next('foo');
      subject.unsubscribe();
      try {
        subject.next('bar')
      } catch (e) {
        err = e;
      }
      expect(err != null && err instanceof ObjectUnsubscribedError).assertTrue();
      done();
      let startTime = new Date().getTime()
      for (let index = 0; index < BASE_COUNT; index++) {
        subject.unsubscribe();
      }
      endTime(startTime, 'should_not_allow_values_to_be_nexted_after_it_is_unsubscribed');
    });

    it('should_clean_out_unsubscribed_subscribers', 0, (done: ESObject) => {
      const subject: ESObject = new Subject<ESObject>();

      const sub1: ESObject = subject.subscribe(() => {
        //noop
      });

      const sub2: ESObject = subject.subscribe(() => {
        //noop
      });

      expect(subject.observers.length).assertEqual(2);
      sub1.unsubscribe();
      expect(subject.observers.length).assertEqual(1);
      sub2.unsubscribe();
      expect(subject.observers.length).assertEqual(0);
      done();
      let startTime = new Date().getTime()
      for (let index = 0; index < BASE_COUNT; index++) {
        subject.subscribe(() => {});
      }
      endTime(startTime, 'should_clean_out_unsubscribed_subscribers');
    });

    it('should_expose_observed_status', 0, () => {
      const subject: ESObject = new Subject<ESObject>();

      expect(subject.observed).assertEqual(false);

      const sub1: ESObject = subject.subscribe(() => {
        //noop
      });

      expect(subject.observed).assertEqual(true);

      const sub2: ESObject = subject.subscribe(() => {
        //noop
      });

      expect(subject.observed).assertTrue();
      sub1.unsubscribe();
      expect(subject.observed).assertTrue();
      sub2.unsubscribe();
      expect(subject.observed).assertFalse();
      subject.unsubscribe();
      expect(subject.observed).assertFalse();
      let startTime = new Date().getTime()
      for (let index = 0; index < BASE_COUNT; index++) {
        subject.observed
      }
      endTime(startTime, 'should_expose_observed_status');
    });

    it('should_have_a_static_create_function_that_works', 0, () => {
      expect(Subject.create instanceof Function).assertTrue();
      const source = of(1, 2, 3, 4, 5);
      const nexts: number[] = [];
      const output: number[] = [];

      let error: ESObject;
      let complete = false;
      let outputComplete = false;

      const destination: ESObject = ObjFun(nexts, error, complete)

      const sub: Subject<ESObject> = Subject.create(destination, source);

      sub.subscribe({
        next: (x: number) => {
          output.push(x);
        },
        complete: () => {
          outputComplete = true;
          complete = true;
        }
      });

      sub.next('a');
      sub.next('b');
      sub.next('c');
      sub.complete();

      expect(nexts).assertDeepEquals(['a', 'b', 'c']);
      expect(complete).assertTrue();
      expect(error).assertUndefined();

      expect(output).assertDeepEquals([1, 2, 3, 4, 5]);
      expect(outputComplete).assertTrue();
      let startTime = new Date().getTime()
      for (let index = 0; index < BASE_COUNT; index++) {
        sub.next('c');
      }
      endTime(startTime, 'should_have_a_static_create_function_that_works');
    });

    it('should_have_a_tatic_create_function_tha_works_also_to_raise_rrors', 0, () => {
      expect(Subject.create instanceof Function).assertTrue();
      const source = of(1, 2, 3, 4, 5);
      const nexts: number[] = [];
      const output: number[] = [];

      let error: ESObject = 'boom';
      let complete = false;
      let outputComplete = false;

      const destination = ObjFun(nexts, error, complete)

      const sub: Subject<ESObject> = Subject.create(destination, source);

      sub.subscribe({
        next: (x: number) => {
          output.push(x);
        },
        complete: () => {
          outputComplete = true;
        },
        error: (x: ESObject) => {
          error = x;
        }
      });

      sub.next('a');
      sub.next('b');
      sub.next('c');
      sub.error('boom');

      expect(nexts).assertDeepEquals(['a', 'b', 'c']);
      expect(complete).assertFalse();
      expect(error).assertEqual('boom');

      expect(output).assertDeepEquals([1, 2, 3, 4, 5]);
      expect(outputComplete).assertTrue();
      let startTime = new Date().getTime()
      for (let index = 0; index < BASE_COUNT; index++) {
        sub.error('boom');
      }
      endTime(startTime, 'should_have_a_tatic_create_function_tha_works_also_to_raise_rrors');
    });

    it('should_be_an_Observer_ich_can_be_given_to_Observable_subscribe', 0, (done: ESObject) => {
      const source = of(1, 2, 3, 4, 5);
      const subject = new Subject<number>();
      const expected = [1, 2, 3, 4, 5];

      subject.subscribe(
        {
          next: (x) => {
            expect(x).assertEqual(expected.shift());
          }, error: () => {
          done(new Error('should not be called'));
        }, complete: () => {
          done();
        }
        }
      );

      source.subscribe(subject);

      let startTime = new Date().getTime()
      for (let index = 0; index < BASE_COUNT; index++) {
        source.subscribe(subject);
      }
      endTime(startTime, 'should_be_an_Observer_ich_can_be_given_to_Observable_subscribe');
    });

    it('should_be_usable_as_an_Observer_of_a_finite_delayed_Observable', 0, (done: ESObject) => {
      const source = of(1, 2, 3).pipe(delay(50));
      const subject = new Subject<number>();

      const expected = [1, 2, 3];

      subject.subscribe(
        {
          next: (x) => {
            expect(x).assertEqual(expected.shift());
          }, error: () => {
          done(new Error('should not be called'));
        }, complete: () => {
          done();
        }
        }
      );

      source.subscribe(subject);
      let startTime = new Date().getTime()
      for (let index = 0; index < BASE_COUNT; index++) {
        source.subscribe(subject);
      }
      endTime(startTime, 'should_be_usable_as_an_Observer_of_a_finite_delayed_Observable');

    });

    it('should_throw_ObjectUnsubscribedError_when_emit_after_unsubscribed', 0, () => {
      const subject = new Subject<string>();
      subject.unsubscribe();
      let err1: ESObject = null;
      let err2: ESObject = null;
      let err3: ESObject = null;
      try {
        subject.next('a');
      } catch (e) {
        err1 = e;
      }
      expect(err1 != null && err1 instanceof ObjectUnsubscribedError).assertTrue();

      try {
        subject.error('a');
      } catch (e) {
        err2 = e;
      }
      expect(err2 != null && err2 instanceof ObjectUnsubscribedError).assertTrue();
      try {
        subject.complete();
      } catch (e) {
        err3 = e;
      }
      expect(err3 != null && err3 instanceof ObjectUnsubscribedError).assertTrue();

      let startTime = new Date().getTime()
      for (let index = 0; index < BASE_COUNT; index++) {
        subject.unsubscribe();
      }
      endTime(startTime, 'should_throw_ObjectUnsubscribedError_when_emit_after_unsubscribed');
    });

    it('should_not_next_after_completed', 0, () => {
      const subject = new Subject<string>();
      const results: string[] = [];
      subject.subscribe(
        {
          next: (x) => results.push(x), complete: () => results.push('C')
        }
      );
      subject.next('a');
      subject.complete();
      subject.next('b');
      expect(results).assertDeepEquals(['a', 'C']);
      let startTime = new Date().getTime()
      for (let index = 0; index < BASE_COUNT; index++) {
        subject.next('b');
      }
      endTime(startTime, 'should_not_next_after_completed');
    });

    it('should_not_next_after_error', 0, () => {
      const error = new Error('wut?');
      const subject = new Subject<string>();
      const results: string[] = [];
      subject.subscribe(
        {
          next: (x) => results.push(x), error: (err: ESObject) => results.push(err)
        }
      );
      subject.next('a');
      subject.error(error);
      subject.next('b');
      expect(results).assertDeepEquals(['a', error]);
      let startTime = new Date().getTime()
      for (let index = 0; index < BASE_COUNT; index++) {
        subject.next('b');
      }
      endTime(startTime, 'should_not_next_after_error');
    });


    it('should_hide_subject', 0, () => {
      const subject: ESObject = new Subject<ESObject>();
      const observable: ESObject = subject.asObservable();

      expect(JSON.stringify(subject) === JSON.stringify(observable)).assertFalse(); //要改

      expect(observable instanceof Observable).assertTrue();
      expect(observable instanceof Subject).assertFalse();
      let startTime = new Date().getTime()
      for (let index = 0; index < BASE_COUNT; index++) {
        subject.asObservable();
      }
      endTime(startTime, 'should_hide_subject');
    });

    it('should_handle_subject_never_emits', 0, () => {
      rxTestScheduler.run((helpers: RunHelpers) => {
        let hot = helpers.hot
        let expectObservable = helpers.expectObservable
        const observable = hot('-').asObservable();

        expectObservable(observable).toBe('-');
        let startTime = new Date().getTime()
        for (let index = 0; index < BASE_COUNT; index++) {
          hot('-').asObservable();
        }
        endTime(startTime, 'should_handle_subject_completes_without_emits');
      });
    });

    it('should_handle_subject_completes_without_emits', 0, () => {
      rxTestScheduler.run((helpers: RunHelpers) => {
        let hot = helpers.hot
        let expectObservable = helpers.expectObservable
        const observable = hot('--^--|').asObservable();
        const expected = '        ---|';

        expectObservable(observable).toBe(expected);
        let startTime = new Date().getTime()
        for (let index = 0; index < BASE_COUNT; index++) {
          hot('--^--|').asObservable();
        }
        endTime(startTime, 'should_handle_subject_completes_without_emits');
      });
    });

    it('should_handle_subject_hrows', 0, () => {
      rxTestScheduler.run((helpers: RunHelpers) => {
        let hot = helpers.hot
        let expectObservable = helpers.expectObservable
        const observable = hot('--^--#').asObservable();
        const expected = '        ---#';

        expectObservable(observable).toBe(expected);
        let startTime = new Date().getTime()
        for (let index = 0; index < BASE_COUNT; index++) {
          hot('--^--#').asObservable();
        }
        endTime(startTime, 'should_handle_subject_hrows');
      });
    });

    it('should_handle_subject_emits', 0, () => {
      rxTestScheduler.run((helpers: RunHelpers) => {
        let hot = helpers.hot
        let expectObservable = helpers.expectObservable
        const observable = hot('--^--x--|').asObservable();
        const expected = '        ---x--|';

        expectObservable(observable).toBe(expected);
        let startTime = new Date().getTime()
        for (let index = 0; index < BASE_COUNT; index++) {
          hot('--^--x--|').asObservable();
        }
        endTime(startTime, 'should_handle_subject_emits');
      });

    });

    it('should_work_with_inherited_subject', 0, () => {
      const results: (number | string)[] = [];
      const subject = new AsyncSubject<number>();

      subject.next(42);
      subject.complete();

      const observable = subject.asObservable();

      observable.subscribe(
        {
          next: (x) => results.push(x), complete: () => results.push('done')
        }
      );

      expect(results).assertDeepEquals([42, 'done']);
      let startTime = new Date().getTime()
      for (let index = 0; index < BASE_COUNT; index++) {
        subject.next(42);
      }
      endTime(startTime, 'should_work_with_inherited_subject');
    });
  });

  describe('error_thrown_scenario', () => {
    afterEach(() => {
      config.onUnhandledError = null;
    });

    it('should_not_synchronously_error_when_exted_nto', 0, (done: ESObject) => {
      config.onUnhandledError = (err: ESObject) => {
        expect(err.message).assertDeepEquals('Boom!');
        done();
      };

      const source = new Subject<number>();
      source.subscribe();
      source.subscribe(() => {
        throw new Error('Boom!');
      });
      source.subscribe();
      try {
        source.next(42);
      } catch (err) {
        // This should not happen!
        expect(true).assertFalse();
      }
      expect(true).assertTrue();
      let startTime = new Date().getTime()
      for (let index = 0; index < BASE_COUNT; index++) {
        source.next(42);
      }
      endTime(startTime, 'should_not_synchronously_error_when_exted_nto');
    });
  });


  it('should_be_exposed', 0, () => {
    let result: ESObject = InstanceofFun()
    expect(result).assertTrue();
    let startTime = new Date().getTime()
    for (let index = 0; index < BASE_COUNT; index++) {
      result
    }
    endTime(startTime, 'should_not_be_ger');
  });

  it('should_not_be_ger', 0, () => {
    let subscribed = false;

    const subject: ESObject = Subject.create(
      null,
      new Observable<ESObject>((observer: Observer<ESObject>) => {
        subscribed = true;
        const subscription = of('x').subscribe(observer);
        return () => {
          subscription.unsubscribe();
        };
      })
    );

    const observable: ESObject = subject.asObservable();
    expect(subscribed).assertFalse();

    observable.subscribe();
    expect(subscribed).assertTrue();

    let startTime = new Date().getTime()
    for (let index = 0; index < BASE_COUNT; index++) {
      expect(() => {
        subject.asObservable();
      }).assertThrowError('bad');
    }
    endTime(startTime, 'should_not_be_ger');
  });

  describe('useDeprecatedSynchronousErrorHandling', () => {
    beforeEach(() => {
      config.useDeprecatedSynchronousErrorHandling = true;
    });

    afterEach(() => {
      config.useDeprecatedSynchronousErrorHandling = false;
    });

    it('should_throw_an_error_when_nexting_with_a_flattened_erroring_inner_observable', 0, () => {
      const subject = new Subject<string>();
      subject.pipe(mergeMap(() => throwError(() => new Error('bad')))).subscribe();

      expect(() => {
        subject.next('wee');
      }).assertThrowError('bad');
      let startTime = new Date().getTime()
      for (let index = 0; index < BASE_COUNT; index++) {
        expect(() => {
          subject.next('wee');
        })
      }
      endTime(startTime, 'should_throw_an_error_when_nexting_with_a_flattened_erroring_inner_observable');
    });

    it('should_throw_an_error_when_nexting_with_flattened_erroring_inner_observable_with_more_than_one_operator', 0, () => {
      const subject = new Subject<string>();
      subject.pipe(mergeMap(() => throwError(() => new Error('bad'))), map(x => x)).subscribe();

      expect(() => {
        subject.next('wee');
      }).assertThrowError('bad');
      let startTime = new Date().getTime()
      for (let index = 0; index < BASE_COUNT; index++) {
        expect(() => {
          subject.error('wee');
        })
      }
      endTime(startTime, 'should_thro_an_error_when_notifying_an_error_with_catchError_eturning_an_erroring_nne_bservable');
    });

    it('should_thro_an_error_when_notifying_an_error_with_catchError_eturning_an_erroring_nne_bservable', 0, () => {
      const subject = new Subject<string>();
      subject.pipe(catchError(() => throwError(() => new Error('bad')))).subscribe();

      expect(() => {
        subject.error('wee');
      }).assertThrowError('bad');
      let startTime = new Date().getTime()
      for (let index = 0; index < BASE_COUNT; index++) {
        expect(() => {
          subject.error('wee');
        })
      }
      endTime(startTime, 'should_thro_an_error_when_notifying_an_error_with_catchError_eturning_an_erroring_nne_bservable');
    });

    it('should_throw_an_error_when_nexting_with_an_operator_hat_errors_synchronously', 0, () => {
      const subject = new Subject<string>();
      subject.pipe(mergeMap(() => {
        throw new Error('lol');
      })).subscribe();

      expect(() => {
        subject.next('wee');
      }).assertThrowError('lol');
      let startTime = new Date().getTime()
      for (let index = 0; index < BASE_COUNT; index++) {
        expect(() => {
          subject.error('wee');
        })
      }
      endTime(startTime, 'should_throw_an_error_when_notifying_an_error_with_a_catchError_that_errors_synchronously');
    });


    it('should_throw_an_error_when_notifying_an_error_with_a_catchError_that_errors_synchronously', 0, () => {
      const subject = new Subject<string>();
      subject.pipe(catchError(() => {
        throw new Error('lol');
      })).subscribe();

      expect(() => {
        subject.error('wee');
      }).assertThrowError('lol');
      let startTime = new Date().getTime()
      for (let index = 0; index < BASE_COUNT; index++) {
        expect(() => {
          subject.error('wee');
        })
      }
      endTime(startTime, 'should_throw_an_error_when_notifying_an_error_with_a_catchError_that_errors_synchronously');
    });

    it('should_throw_an_rror_when_nexting_with_an_erroring_ext_handler', 0, () => {
      const subject = new Subject<string>();
      subject.subscribe(() => {
        throw new Error('lol');
      });

      expect(() => {
        subject.next('wee');
      }).assertThrowError('lol');
      let startTime = new Date().getTime()
      for (let index = 0; index < BASE_COUNT; index++) {
        subject.subscribe(() => {
          throw new Error('lol');
        });
      }
      endTime(startTime, 'should_throw_an_rror_when_nexting_with_an_erroring_ext_handler');
    });

    it('should_throw_an_error_when_notifying_with_an_erroring_error_handler', 0, () => {
      const subject = new Subject<string>();
      subject.subscribe({
        error: () => {
          throw new Error('lol');
        }
      });

      expect(() => {
        subject.error('wee');
      }).assertThrowError('lol');
      let startTime = new Date().getTime()
      for (let index = 0; index < BASE_COUNT; index++) {
        subject.error('wee');
      }
      endTime(startTime, 'should_throw_an_error_when_notifying_with_an_erroring_error_handler');
    });

    it('should_throw_an_error_when_notifying_with_an_erroring_complete_handler', 0, () => {
      const subject = new Subject<string>();
      subject.subscribe({
        complete: () => {
          throw new Error('lol');
        }
      });

      expect(() => {
        subject.complete();
      }).assertThrowError('lol');
      let startTime = new Date().getTime()
      for (let index = 0; index < BASE_COUNT; index++) {
        subject.complete();
      }
      endTime(startTime, 'should_throw_an_error_when_notifying_with_an_erroring_complete_handler');
    });

    it('should_throw_an_rror_when_notifying_an_complete_and_concatenated_with_nother_observabl_that_synchronously_errors', 0, () => {
      const subject = new Subject<string>();
      concat(subject, throwError(new Error('lol'))).subscribe();

      expect(() => {
        subject.complete();
      }).assertThrowError('lol');
      let startTime = new Date().getTime()
      for (let index = 0; index < BASE_COUNT; index++) {
        new Subject<string>();
      }
      endTime(startTime, 'should_throw_an_rror_when_notifying_an_complete_and_concatenated_with_nother_observabl_that_synchronously_errors');
    });

    it('should_not_throw_on_second_erro_passed', 0, () => {
      const subject: ESObject = new Subject<ESObject>();

      subject.subscribe();

      expect(() => {
        subject.error(new Error('one'));
      }).assertThrowError('one');
      let startTime = new Date().getTime()
      for (let index = 0; index < BASE_COUNT; index++) {
        subject.error(new Error('one'));
      }
      endTime(startTime, 'should_not_throw_on_second_erro_passed');
    });

    it('should_not_throw_on_second_error_passed_even_afte_having_been_operated_on', 0, () => {
      const subject: ESObject = new Subject<ESObject>();

      subject.pipe(mergeMap((x: ESObject) => [x])).subscribe();

      expect(() => {
        subject.error(new Error('one'));
      }).assertThrowError('one');
      let startTime = new Date().getTime()
      for (let index = 0; index < BASE_COUNT; index++) {
        subject.error(new Error('one'));
      }
      endTime(startTime, 'should_not_throw_on_second_error_passed_even_afte_having_been_operated_on');
    });

    it('deep_rethrowing_1', 0, () => {
      const subject1: ESObject = new Subject<ESObject>();
      const subject2: ESObject = new Subject<ESObject>();

      subject2.subscribe();

      subject1.subscribe({
        next: (): ESObject => subject2.error(new Error('hahaha'))
      });

      expect(() => {
        subject1.next('test');
      }).assertThrowError('hahaha');
      let startTime = new Date().getTime()
      for (let index = 0; index < BASE_COUNT; index++) {
        subject1.subscribe({
          next: (): ESObject => subject2.error(new Error('hahaha'))
        });
      }
      endTime(startTime, 'deep_rethrowing_2');
    });

    it('deep_rethrowing_2', 0, () => {
      const subject1: ESObject = new Subject<ESObject>();

      subject1.subscribe({
        next: () => {
          throwError(new Error('hahaha')).subscribe();
        }
      });

      expect(() => {
        subject1.next('test');
      }).assertThrowError('hahaha');
      let startTime = new Date().getTime()
      for (let index = 0; index < BASE_COUNT; index++) {
        new Subject<ESObject>();
      }
      endTime(startTime, 'deep_rethrowing_2');
    });
  });
  describe('Observable', () => {
    let rxTestScheduler: TestScheduler;

    beforeEach(() => {
      rxTestScheduler = new TestScheduler(observableMatcher);
    });

    it('should_be_constructed_with_a_subscriber_function', 0, (done: ESObject) => {
      const source = new Observable<number>((observer) => {
        expectFullObserver(observer);
        observer.next(1);
        observer.complete();
      });

      source.subscribe(
        {
          next: (x) => {
            expect(x).assertDeepEquals(1);
          }, complete: done
        }
      );
      let startTime = new Date().getTime()
      for (let index = 0; index < BASE_COUNT; index++) {
        source.subscribe(
          {
            next: (x) => {}, complete: done
          }
        );
      }
      endTime(startTime, 'should_be_constructed_with_a_subscriber_function')
    });

    it('should_send_errors_thrown_in_the_constructor_down_the_error_path', 0, (done: ESObject) => {
      new Observable<number>(() => {
        throw new Error('this should be handled');
      }).subscribe({
        error(err: ESObject) {
          expect(err instanceof Error).assertTrue();
          expect(err['message']).assertDeepEquals('this should be handled');
          done();
        },
      });
      let startTime = new Date().getTime()
      for (let index = 0; index < BASE_COUNT; index++) {
        new Observable<number>(() => {
        }).subscribe({
          error(err: ESObject) {
            done();
          },
        });
      }
      endTime(startTime, 'should_send_errors_thrown_in_the_constructor_down_the_error_path')
    });

    it('should_allow_empty_ctor_which_is_effectively_a_never_observable', 0, () => {
      rxTestScheduler.run((helpers: RunHelpers) => {
        let expectObservable = helpers.expectObservable
        const result: ESObject = new Observable<ESObject>();
        expectObservable<ESObject>(result).toBe('-');
      });
      let startTime = new Date().getTime()
      for (let index = 0; index < BASE_COUNT; index++) {
        rxTestScheduler.run((helpers: RunHelpers) => {
          let expectObservable = helpers.expectObservable
          const result: ESObject = new Observable<ESObject>();
          expectObservable<ESObject>(result).toBe('-');
        });
      }
      endTime(startTime, 'should_allow_empty_ctor_which_is_effectively_a_never_observable')
    });

    it('forEach_should_iterate_and_return_a_Promise', 0, (done: ESObject) => {
      const expected = [1, 2, 3];
      const result = of(1, 2, 3)
        .forEach((x) => {
          expect(x).assertEqual(expected.shift());
        }, Promise)
        .then(() => {
          done();
        });
      expect(result.then instanceof Function).assertTrue();
      let startTime = new Date().getTime()
      for (let index = 0; index < BASE_COUNT; index++) {
        of(1, 2, 3)
          .forEach((x) => {}, Promise)
          .then(() => {
            done();
          });
      }
      endTime(startTime, 'forEach_should_iterate_and_return_a_Promise')
    });

    it('should_reject_promise_when_in_error', 0, (done: ESObject) => {
      throwError(() => ('bad'))
        .forEach(() => {
          done(new Error('should not be called'));
        }, Promise)
        .then(
          () => {
            done(new Error('should not complete'));
          },
          (err: ESObject) => {
            expect(err).assertDeepEquals('bad');
            done();
          }
        );
      let startTime = new Date().getTime()
      for (let index = 0; index < BASE_COUNT; index++) {
        throwError(() => ('bad'))
      }
      endTime(startTime, 'should_reject_promise_when_in_error')
    });

    it('should_allow_Promise_to_be_globally_configured', 0, async (done:Function) => {
      try {
        let wasCalled = false;

        config.Promise = MyPromise1(wasCalled) as ESObject;

        await of(42).forEach((x) => {
          expect(x).assertDeepEquals(42);
          wasCalled = true
        })

        expect(wasCalled).assertTrue();

        let startTime = new Date().getTime()
        let configUrlTest: (index: number) => void = async (index) => {
          of(42).forEach((x) => {
            expect(x).assertDeepEquals(42);
            wasCalled = true
          }).then(() => {
            if (index < BASE_COUNT) {
              configUrlTest(index + 1)
            } else {
              let endTime = new Date().getTime()
              let averageTime = (endTime - startTime) * 1000/ BASE_COUNT
              console.info("should_allow_Promise_to_be_globally_configured startTime: " + startTime + ' μs');
              console.info("should_allow_Promise_to_be_globally_configured endTime: " + endTime + ' μs');
              console.info("should_allow_Promise_to_be_globally_configured averageTime: " + averageTime + ' μs');
              done()
            }
          })
        }
        configUrlTest(0)

      } finally {
        config.Promise = undefined;
      }



    });

    it('should_reject_promise_if_nextHandler_throws', 0, (done: ESObject) => {
      const results: number[] = [];

      of(1, 2, 3)
        .forEach((x) => {
          if (x === 3) {
            throw new Error('NO THREES!');
          }
          results.push(x);
        }, Promise)
        .then(
          () => {
            done(new Error('should not be called'));
          },
          (err: ESObject) => {
            expect(err['message']).assertDeepEquals('NO THREES!');
            expect(results).assertDeepEquals([1, 2]);
          }
        )
        .then(() => {
          done();
        });
      let startTime = new Date().getTime()
      for (let index = 0; index < BASE_COUNT; index++) {
        of(1, 2, 3)
          .forEach((x) => { }, Promise)
      }
      endTime(startTime, 'should_reject_promise_if_nextHandler_throws')
    });

    it('should_handle_a_synchronous_throw_from_the_next_handler', 0, () => {
      const expected = new Error('I told, you Bobby Boucher, threes are the debil!');
      const syncObservable = new Observable<number>((observer) => {
        observer.next(1);
        observer.next(2);
        observer.next(3);
        observer.next(4);
      });

      const results: Array<number | Error> = [];
      let startTime = new Date().getTime()
      for (let index = 0; index < BASE_COUNT; index++) {
        new Observable<number>((observer) => {
          observer.next(1);
          observer.next(2);
          observer.next(3);
          observer.next(4);
        });
      }
      endTime(startTime, 'should_handle_a_synchronous_throw_from_the_next_handler')
      return syncObservable
        .forEach((x) => {
          results.push(x);
          if (x === 3) {
            throw expected;
          }
        })
        .then(
          () => {
            throw new Error('should not be called');
          },
          (err: ESObject) => {
            results.push(err);
            // The error should unsubscribe from the source, meaning we
            // should not see the number 4.
            expect(results).assertDeepEquals([1, 2, 3, expected]);
          }
        );

    });

    it('should_handle_an_asynchronous_throw_from_the_next_handler_and_tear_down', 0, () => {
      const expected = new Error('I told, you Bobby Boucher, twos are the debil!');
      const asyncObservable = new Observable<number>((observer) => {
        let i = 1;
        const id = setInterval(() => observer.next(i++), 1);

        return () => {
          clearInterval(id);
        };
      });

      const results: Array<number | Error> = [];
      let startTime = new Date().getTime()
      for (let index = 0; index < BASE_COUNT; index++) {
        new Observable<number>((observer) => {
          let i = 1;
          const id = setInterval(() => observer.next(i++), 1);

          return () => {
            clearInterval(id);
          };
        });
      }
      endTime(startTime, 'should_handle_an_asynchronous_throw_from_the_next_handler_and_tear_down')

      return asyncObservable
        .forEach((x) => {
          results.push(x);
          if (x === 2) {
            throw expected;
          }
        })
        .then(
          () => {
            throw new Error('should not be called');
          },
          (err: ESObject) => {
            results.push(err);
            expect(results).assertDeepEquals([1, 2, expected]);
          }
        );

    });


    it('subscribe_should_work_with_handlers_with_hacked_bind_methods', 0, () => {
      const source = of('Hi');
      const results: ESObject[] = [];
      const next = (value: string) => {
        results.push(value);
      }
      BindFun(next)

      const complete = () => {
        results.push('done');
      }
      BindFun(complete)

      source.subscribe({
        next, complete
      });
      expect(results).assertDeepEquals(['Hi', 'done']);
      let startTime = new Date().getTime()
      for (let index = 0; index < BASE_COUNT; index++) {
        source.subscribe({
          next, complete
        });
      }
      endTime(startTime, 'subscribe_should_work_with_handlers_with_hacked_bind_methods')
    });

    it('should_work_with_handlers_with_hacked_bind_methods_in_the_error_case', 0, () => {
      const source = throwError(() => 'an error');
      const results: ESObject[] = [];
      const error = (value: string) => {
        results.push(value);
      }

      source.subscribe({
        error
      });
      expect(results.length).assertEqual(1);
      expect(results[0]).assertDeepEquals('an error');
      let startTime = new Date().getTime()
      for (let index = 0; index < BASE_COUNT; index++) {
        source.subscribe({
          error
        });
      }
      endTime(startTime, 'should_work_with_handlers_with_hacked_bind_methods_in_the_error_case')
    });

    it('should_be_synchronous', 0, () => {
      let subscribed = false;
      let nexted: string;
      let completed: boolean;
      const source = new Observable<string>((observer) => {
        subscribed = true;
        observer.next('wee');
        expect(nexted).assertDeepEquals('wee');
        observer.complete();
        expect(completed).assertTrue();
      });

      expect(subscribed).assertFalse();

      let mutatedByNext = false;
      let mutatedByComplete = false;

      source.subscribe(
        {
          next: (x) => {
            nexted = x;
            mutatedByNext = true;
          }, complete: () => {
          completed = true;
          mutatedByComplete = true;
        }
        }
      );

      expect(mutatedByNext).assertTrue();
      expect(mutatedByComplete).assertTrue();
      let startTime = new Date().getTime()
      for (let index = 0; index < BASE_COUNT; index++) {
        source.subscribe(
          {
            next: (x) => { }, complete: () => {}
          }
        );
      }
      endTime(startTime, 'should_be_synchronous')
    });

    it('should_work_when_subscribe_is_called_with_no_arguments', 0, () => {
      const source = new Observable<string>((subscriber) => {
        subscriber.next('foo');
        subscriber.complete();
      });

      source.subscribe();
      let startTime = new Date().getTime()
      for (let index = 0; index < BASE_COUNT; index++) {
        source.subscribe();
      }
      endTime(startTime, 'should_work_when_subscribe_is_called_with_no_arguments')
    });

    it('should_not_be_unsubscribed_when_other_empty_subscription_completes', 0, () => {
      let unsubscribeCalled = false;
      const source = new Observable<number>(() => {
        return () => {
          unsubscribeCalled = true;
        };
      });

      source.subscribe();

      expect(unsubscribeCalled).assertFalse();

      empty().subscribe();

      expect(unsubscribeCalled).assertFalse();
      let startTime = new Date().getTime()
      for (let index = 0; index < BASE_COUNT; index++) {
        empty().subscribe();
      }
      endTime(startTime, 'should_not_be_unsubscribed_when_other_empty_subscription_completes')
    });

    it('should_not_be_unsubscribed_when_other_subscription_with_same_observer_completes', 0, () => {
      let unsubscribeCalled = false;
      const source = new Observable<number>(() => {
        return () => {
          unsubscribeCalled = true;
        };
      });

      let observer: ESObject = {
        next: () => {
          /*noop*/
        },
      };

      source.subscribe(observer);

      expect(unsubscribeCalled).assertFalse();

      empty().subscribe(observer);

      expect(unsubscribeCalled).assertFalse();
      let startTime = new Date().getTime()
      for (let index = 0; index < BASE_COUNT; index++) {
        empty().subscribe(observer);
      }
      endTime(startTime, 'should_not_be_unsubscribed_when_other_subscription_with_same_observer_completes')
    });

    it('should_run_unsubscription_logic_when_an_error_is_sent_asynchronously_and_subscribe_is_called_with_no_arguments', 0, (done: ESObject) => {
      let unsubscribeCalled = false;
      const source = new Observable<number>((observer) => {
        const id = setInterval(() => {
          observer.error(0);
        }, 1);
        return () => {
          clearInterval(id);
          unsubscribeCalled = true;
        };
      });

      source.subscribe({
        error() {
          /* noop: expected error */
        },
      });

      setTimeout(() => {
        let err: ESObject;
        let errHappened = false;
        try {
          expect(unsubscribeCalled).assertTrue();
        } catch (e) {
          err = e;
          errHappened = true;
        } finally {
          if (!errHappened) {
            done();
          } else {
            done(err);
          }
        }
      }, 100);
      let startTime = new Date().getTime()
      for (let index = 0; index < BASE_COUNT; index++) {
        source.subscribe({
          error() {},
        });
      }
      endTime(startTime, 'should_return_a_Subscription_that_calls_the_unsubscribe_function_returned_by_the_subscriber')
    });

    it('should_return_a_Subscription_that_calls_the_unsubscribe_function_returned_by_the_subscriber', 0, () => {
      let unsubscribeCalled = false;

      const source = new Observable<number>(() => {
        return () => {
          unsubscribeCalled = true;
        };
      });

      const sub = source.subscribe(() => {
        //noop
      });
      expect(sub instanceof Subscription).assertTrue();
      expect(unsubscribeCalled).assertFalse();
      expect(sub.unsubscribe instanceof Function).assertTrue();

      sub.unsubscribe();
      expect(unsubscribeCalled).assertTrue();
      let startTime = new Date().getTime()
      for (let index = 0; index < BASE_COUNT; index++) {
        sub.unsubscribe();
      }
      endTime(startTime, 'should_return_a_Subscription_that_calls_the_unsubscribe_function_returned_by_the_subscriber')
    });

    it('should_ignore_error_messages_after_unsubscription', 0, () => {
      let times = 0;
      let errorCalled = false;
      const source = new Observable<number>((observer) => {
        observer.next(1);
        observer.next(2);
        observer.next(3);
        setTimeout(() => {
          observer.error(new Error());
        }, 10);
        return () => {
          expect(times).assertEqual(2);
          expect(errorCalled).assertFalse();
        }
      });
      const subscription = source.subscribe(
        {
          next: val => {
            times = val;
            if (times === 2) {
              subscription.unsubscribe();
            }
          }, error: (err: ESObject) => {
          errorCalled = true;
        }
        });
      let startTime = new Date().getTime()
      for (let index = 0; index < BASE_COUNT; index++) {
        source.subscribe(
          {
            next: val => {
              times = val;
              if (times === 2) {
                subscription.unsubscribe();
              }
            }, error: (err: ESObject) => {
            errorCalled = true;
          }
          });
      }
      endTime(startTime, 'should_ignore_error_messages_after_unsubscription')
    });

    it('should_ignore_complete_messages_after_unsubscription', 0, () => {
      let times = 0;
      let completeCalled = false;

      const subscription = new Observable<number>((observer) => {
        observer.next(1);
        observer.next(2);
        observer.next(3);
        setTimeout(() => {
          observer.complete();
        }, 10);
        return () => {
          expect(times).assertEqual(2);
          expect(completeCalled).assertFalse();
        }
      }).subscribe(
        {
          next: val => {
            times = val;
            if (times === 2) {
              subscription.unsubscribe();
            }
          }, complete: () => completeCalled = true
        }
      );
      let startTime = new Date().getTime()
      for (let index = 0; index < BASE_COUNT; index++) {
        subscription
      }
      endTime(startTime, 'should_ignore_complete_messages_after_unsubscription')
    });

    it('should_accept_an_anonymous_observe_wit_ust_a_ext_function_and_call_the_next_function_in_the_context_of_the_anonymous_observer', 0,
      (done: ESObject) => {
        //intentionally not using lambda to avoid typescript's this context capture
        const o: ESObject = {
          myValue: 'foo',
          next(x: ESObject) {
            expect(o.myValue).assertDeepEquals('foo');
            expect(x).assertDeepEquals(1);
            done();
          },
        };
        of(1).subscribe(o);
        let startTime = new Date().getTime()
        for (let index = 0; index < BASE_COUNT; index++) {
          of(1).subscribe(o);
        }
        endTime(startTime, 'should_accept_an_anonymous_observe_wit_ust_a_ext_function_and_call_the_next_function_in_the_context_of_the_anonymous_observer')
      }
    );

    it(
      'should_accept_an_anonymous_bserver_with_ust_an_error_function_nd_call_the_error_unction_in_the_context_of_the_anonymous_observer', 0,
      (done: ESObject) => {
        //intentionally not using lambda to avoid typescript's this context capture
        const o: ESObject = {
          myValue: 'foo',
          error(err: ESObject) {
            expect(o.myValue).assertDeepEquals('foo');
            expect(err).assertDeepEquals('bad');
            done();
          },
        };

        throwError(() => ('bad')).subscribe(o);
        let startTime = new Date().getTime()
        for (let index = 0; index < BASE_COUNT; index++) {
          throwError(() => ('bad')).subscribe(o);
        }
        endTime(startTime, 'should_accept_an_anonymous_bserver_with_ust_an_error_function_nd_call_the_error_unction_in_the_context_of_the_anonymous_observer')
      }
    );

    it(
      'should_accept_an_anonymou_observer_with_ust_a_complete_function_and_call_the_complete_unction_in_the_context_of_the_anonymous_observer', 0,
      (done: ESObject) => {
        //intentionally not using lambda to avoid typescript's this context capture
        const o: ESObject = {
          myValue: 'foo',
          complete: () => {
            expect(o.myValue).assertDeepEquals('foo');
            done();
          },
        };

        empty().subscribe(o);
        let startTime = new Date().getTime()
        for (let index = 0; index < BASE_COUNT; index++) {
          empty().subscribe(o);
        }
        endTime(startTime, 'should_accept_an_anonymou_observer_with_ust_a_complete_function_and_call_the_complete_unction_in_the_context_of_the_anonymous_observer');
      }
    );

    it('should_accept_an_anonymous_observer_with_no_functions_at_all', 0, () => {
      let error: ESObject = null;
      try {
        EmptyFun()
      } catch (err) {
        error = err;
      }
      expect(error).assertNull();
      let startTime = new Date().getTime()
      for (let index = 0; index < BASE_COUNT; index++) {
        error
      }
      endTime(startTime, 'should_accept_an_anonymous_observer_with_no_functions_at_all');
    });

    it('should_ignore_next_messages_fter_unsubscription', 0, () => {
      let num = 0;
      const source = new Observable<number>((observer) => {
        observer.next(1);
        observer.next(2);
        observer.next(3);
        return () => {
          expect(num).assertEqual(2);
        }
      });
      const subscription = source.subscribe({
        next: val => {
          num = val;
          if (num === 2) {
            subscription.unsubscribe();
          }
        }
      });
      let startTime = new Date().getTime()
      for (let index = 0; index < BASE_COUNT; index++) {
        new Observable<number>((observer) => {
          observer.next(1);
          observer.next(2);
          observer.next(3);
          return () => {
            expect(num).assertEqual(2);
          }
        })
      }
      endTime(startTime, 'should_ignore_next_messages_fter_unsubscription');
    });


    it('should_finalize_even_with_a_synchronou_thrown_error', 0, () => {
      let called = false;
      const badObservable: ESObject = new Observable<ESObject>((subscriber: ESObject) => {
        subscriber.add(() => {
          called = true;
        });

        throw new Error('bad');
      });

      badObservable.subscribe({
        error: () => { /* do nothing */
        }
      });

      expect(called).assertTrue();
      let startTime = new Date().getTime()
      for (let index = 0; index < BASE_COUNT; index++) {
        badObservable.subscribe({
          error: () => {  }
        });
      }
      endTime(startTime, 'should_finalize_even_with_a_synchronou_thrown_error');
    });


    it('should_handle_empty_string_sync_errors', 0, () => {
      const badObservable: ESObject = new Observable<ESObject>(() => {
        throw new Error('');
      });

      let caught = false;
      badObservable.subscribe({
        error: (err: ESObject) => {
          caught = true;
          expect(err).assertDeepEquals(new Error(''));
        }
      });
      expect(caught).assertTrue();
      let startTime = new Date().getTime()
      for (let index = 0; index < BASE_COUNT; index++) {
        new Observable<ESObject>(() => {
          throw new Error('');
        });
      }
      endTime(startTime, 'should_handle_empty_string_sync_errors');
    });


    it('should_xist', 0, () => {
      const source = of('test');
      expect(source.pipe instanceof Function).assertTrue();
      let startTime = new Date().getTime()
      for (let index = 0; index < BASE_COUNT; index++) {
        of('test');
      }
      endTime(startTime, 'should_xist');
    });

    it('should_pipe_multiple_perations', 0, (done: ESObject) => {
      of('test')
        .pipe(
          map((x) => x + x),
          map((x) => x + '!!!')
        )
        .subscribe(
          {
            next: (x) => {
              expect(x).assertDeepEquals('testtest!!!');
            }, complete: done
          }
        );
      let startTime = new Date().getTime()
      for (let index = 0; index < BASE_COUNT; index++) {
        of('test')
          .pipe(
            map((x) => x + x),
            map((x) => x + '!!!')
          )
          .subscribe();
      }
      endTime(startTime, 'should_pipe_multiple_perations');
    });

    it('should_return_the_same_observable_if_there_are_no_arguments', 0, () => {
      const source = of('test');
      const result = source.pipe();
      expect(result).assertDeepEquals(source);
      let startTime = new Date().getTime()
      for (let index = 0; index < BASE_COUNT; index++) {
        of('test')
      }
      endTime(startTime, 'should_return_the_same_observable_if_there_are_no_arguments');
    });

  });

  describe('Observable_create', () => {
    it('should_create_an_Observable', 0, () => {
      const result: ESObject = Observable.create(() => {
        //noop
      });
      expect(result instanceof Observable).assertTrue();
      let startTime = new Date().getTime()
      for (let index = 0; index < BASE_COUNT; index++) {
        Observable.create(() => {});
      }
      endTime(startTime, 'should_create_an_Observable');
    });

    it('should_provide_an_observer_to_the_function', 0, () => {
      let called = false;
      const result: ESObject = Observable.create((observer: Observer<ESObject>) => {
        called = true;
        expectFullObserver(observer);
        observer.complete();
      });

      expect(called).assertFalse();
      result.subscribe(() => {
        //noop
      });
      expect(called).assertTrue();
      let startTime = new Date().getTime()
      for (let index = 0; index < BASE_COUNT; index++) {
        result.subscribe(() => {});
      }
      endTime(startTime, 'should_provide_an_observer_to_the_function');
    });

    it('should_send_rrors_thrown_in_the_assed_function_down_the_error_ath', 0, (done: ESObject) => {
      Observable.create(() => {
        throw new Error('this should be handled');
      }).subscribe({
        error(err: Error) {
          expect(err instanceof Error).assertTrue();
          expect(err.message).assertDeepEquals('this should be handled');
          done();
        },
      });
      let startTime = new Date().getTime()
      for (let index = 0; index < BASE_COUNT; index++) {
        Observable.create(() => {})
      }
      endTime(startTime, 'should_send_rrors_thrown_in_the_assed_function_down_the_error_ath');
    });
  });

  /** @test {Observable} */
  describe('Observable_lift', () => {
    let rxTestScheduler: TestScheduler;

    beforeEach(() => {
      rxTestScheduler = new TestScheduler(observableMatcher);
    });

    class MyCustomObservable<T> extends Observable<T> {
      static from<T>(source: ESObject) {
        const observable = new MyCustomObservable<T>();
        SourceFun<T>(observable, source)
        return observable;
      }

      lift<R>(operator: Operator<T, R>): Observable<R> {
        const observable = new MyCustomObservable<R>();
        let that = this
        observableSource(observable, that)
        observableOperator(observable, operator)
        return observable;
      }
    }

    it('should_return_Observable_which_calls_FinalizationLogic_of_operator_on_unsubscription', 0, (done: ESObject) => {
      const myOperator: Operator<ESObject, ESObject> = {
        call: (subscriber: Subscriber<ESObject>, source: ESObject) => {
          const subscription: ESObject = source.subscribe((x: ESObject) => subscriber.next(x));
          return () => {
            subscription.unsubscribe();
            done();
          };
        },
      };

      (NEVER as ESObject).lift(myOperator)
        .subscribe()
        .unsubscribe();
      let startTime = new Date().getTime()
      for (let index = 0; index < BASE_COUNT; index++) {
        (NEVER as ESObject).lift(myOperator)
          .subscribe()
          .unsubscribe();
      }
      endTime(startTime, 'should_return_Observable_which_calls_FinalizationLogic_of_operator_on_unsubscription');
    });

    it('should_be_overrideable_in_a_ustom_Observable_typ_that_composes', 0, (done: ESObject) => {
      const result = new MyCustomObservable<number>((observer) => {
        observer.next(1);
        observer.next(2);
        observer.next(3);
        observer.complete();
      }).pipe(
        map((x) => {
          return 10 * x;
        })
      );

      expect(result instanceof MyCustomObservable).assertTrue();

      const expected = [10, 20, 30];

      result.subscribe(
        {
          next: (x) => {
            expect(x).assertDeepEquals(expected.shift());
          }, error: () => {
          done(new Error('should not be called'));
        }, complete: () => {
          done();
        }
        }
      );
      let startTime = new Date().getTime()
      for (let index = 0; index < BASE_COUNT; index++) {
        result.subscribe();
      }
      endTime(startTime, 'should_be_overrideable_in_a_ustom_Observable_typ_that_composes');
    });

    it('should_compose_through_multicas_and_refCount', 0, (done: ESObject) => {
      const result = new MyCustomObservable<number>((observer) => {
        observer.next(1);
        observer.next(2);
        observer.next(3);
        observer.complete();
      }).pipe(
        multicast(() => new Subject<number>()),
        refCount(),
        map((x) => 10 * x)
      );

      expect(result instanceof MyCustomObservable).assertTrue();

      const expected = [10, 20, 30];

      result.subscribe(
        {
          next: (x) => {
            expect(x).assertDeepEquals(expected.shift());
          }, error: () => {
          done(new Error('should not be called'));
        }, complete: () => {
          done();
        }
        }
      );
      let startTime = new Date().getTime()
      for (let index = 0; index < BASE_COUNT; index++) {
        result.subscribe();
      }
      endTime(startTime, 'should_compose_through_multicas_and_refCount');
    });


    it('should_ompose_hrough_publish_and_refCount', 0, (done: ESObject) => {
      const result = new MyCustomObservable<number>((observer) => {
        observer.next(1);
        observer.next(2);
        observer.next(3);
        observer.complete();
      }).pipe(
        publish(),
        refCount(),
        map((x: ESObject) => 10 * x)
      );

      expect(result instanceof MyCustomObservable).assertTrue();

      const expected = [10, 20, 30];

      result.subscribe(
        {
          next: (x) => {
            expect(x).assertDeepEquals(expected.shift());
          }, error: () => {
          done(new Error('should not be called'));
        }, complete: () => {
          done();
        }
        }
      );
      let startTime = new Date().getTime()
      for (let index = 0; index < BASE_COUNT; index++) {
        result.subscribe();
      }
      endTime(startTime, 'should_ompose_hrough_publish_and_refCount');
    });


    it('should_compose_through_publishLast_and_efCount', 0, (done: ESObject) => {
      const result = new MyCustomObservable<number>((observer) => {
        observer.next(1);
        observer.next(2);
        observer.next(3);
        observer.complete();
      }).pipe(
        publishLast(),
        refCount(),
        map((x: ESObject) => 10 * x)
      );

      expect(result instanceof MyCustomObservable).assertTrue();

      const expected = [30];

      result.subscribe(
        {
          next: (x) => {
            expect(x).assertDeepEquals(expected.shift());
          }, error: () => {
          done(new Error('should not be called'));
        }, complete: () => {
          done();
        }
        }
      );
      let startTime = new Date().getTime()
      for (let index = 0; index < BASE_COUNT; index++) {
        result.subscribe();
      }
      endTime(startTime, 'should_compose_through_publishLast_and_efCount');
    });

    it('should_compose_through_publishBehavior_and_refCount', 0, (done: ESObject) => {
      const result = new MyCustomObservable<number>((observer) => {
        observer.next(1);
        observer.next(2);
        observer.next(3);
        observer.complete();
      }).pipe(
        publishBehavior(0),
        refCount(),
        map((x) => 10 * x)
      );

      expect(result instanceof MyCustomObservable).assertTrue();

      const expected = [0, 10, 20, 30];

      result.subscribe(
        {
          next: (x) => {
            expect(x).assertDeepEquals(expected.shift());
          }, error: () => {
          done(new Error('should not be called'));
        }, complete: () => {
          done();
        }
        }
      );
      let startTime = new Date().getTime()
      for (let index = 0; index < BASE_COUNT; index++) {
        result.subscribe();
      }
      endTime(startTime, 'should_compose_through_publishBehavior_and_refCount');
    });

    it('should_composes_Subjects_in_the_simple_case', 0, () => {
      const subject = new Subject<number>();

      const result = subject.pipe(
        map((x) => 10 * x)
      ) as ESObject as Subject<number>; // Yes, this is correct. (but you're advised not to do this)

      expect(result instanceof Subject).assertTrue();

      const emitted: ESObject[] = [];
      result.subscribe(value => emitted.push(value));

      result.next(10);
      result.next(20);
      result.next(30);

      expect(emitted).assertDeepEquals([100, 200, 300]);
      let startTime = new Date().getTime()
      for (let index = 0; index < BASE_COUNT; index++) {
        result.next(30);
      }
      endTime(startTime, 'should_composes_Subjects_in_the_simple_case');
    });

    /**
     * Seriously, never do this. It's probably bad that we've allowed this. Fortunately, it's not
     * a common practice, so maybe we can remove it?
     */
    it('should_demonstrate_the_horrors_f_haring_an_lifting_he_bject_ough', 0, () => {
      const subject = new Subject<number>();

      const shared = subject.pipe(
        share()
      );

      const result1 = shared.pipe(
        map(x => x * 10)
      ) as ESObject as Subject<number>; // Yes, this is correct.

      const result2 = shared.pipe(
        map(x => x - 10)
      ) as ESObject as Subject<number>; // Yes, this is correct.
      expect(result1 instanceof Subject).assertTrue();

      const emitted1: ESObject[] = [];
      result1.subscribe(value => emitted1.push(value));

      const emitted2: ESObject[] = [];
      result2.subscribe(value => emitted2.push(value));

      // THIS IS HORRIBLE DON'T DO THIS.
      result1.next(10);
      result2.next(20); // Yuck
      result1.next(30);

      expect(emitted1).assertDeepEquals([100, 200, 300]);
      expect(emitted2).assertDeepEquals([0, 10, 20]);
      let startTime = new Date().getTime()
      for (let index = 0; index < BASE_COUNT; index++) {
        result2.next(20); // Yuck
      }
      endTime(startTime, 'should_demonstrate_the_horrors_f_haring_an_lifting_he_bject_ough');
    });

    /**
     * This section outlines one of the reasons that we need to get rid of operators that return
     * Connectable observable. Likewise it also reveals a slight design flaw in `lift`. It
     * probably should have never tried to compose through the Subject's observer methods.
     * If you're a user and you're reading this... NEVER try to use this feature, it's likely
     * to go away at some point.
     *
     * The problem is that you can have the Subject parts, or you can have the ConnectableObservable parts,
     * but you can't have both.
     *
     * NOTE: We can remove this in version 8 or 9, because we're getting rid of operators that
     * return `ConnectableObservable`. :tada:
     */

    it('should_compose_through_multicast_and_refCount_even_if_it_is_a_Subject', 0, () => {
      const subject = new Subject<number>();

      const result = subject.pipe(
        multicast(() => new Subject<number>()),
        refCount(),
        map((x) => 10 * x)
      ) as ESObject as Subject<number>; // Yes, this is correct.

      expect(result instanceof Subject).assertTrue();

      const emitted: ESObject[] = [];
      result.subscribe(value => {
        emitted.push(value)
        if (value == 300) {
          expect(emitted).assertDeepEquals([100, 200, 300]);
        }
      });
      result.next(10);
      result.next(20);
      result.next(30);
      let startTime = new Date().getTime()
      for (let index = 0; index < BASE_COUNT; index++) {
        result.subscribe(value => {});
      }
      endTime(startTime, 'should_compose_through_multicast_and_refCount_even_if_it_is_a_Subject');
    });

    it('should_compose_through_publish_and_refCount_even_if_it_is_a_Subject', 0, () => {
      const subject = new Subject<number>();

      const result = subject.pipe(
        publish(),
        refCount(),
        map((x: ESObject) => 10 * x)
      ) as ESObject as Subject<number>; // Yes, this is correct.

      expect(result instanceof Subject).assertTrue();

      const emitted: ESObject[] = [];
      result.subscribe(value => {
        emitted.push(value)
        if (value == 300) {
          expect(emitted).assertDeepEquals([100, 200, 300]);
        }
      });
      result.next(10);
      result.next(20);
      result.next(30);
      let startTime = new Date().getTime()
      for (let index = 0; index < BASE_COUNT; index++) {
        result.subscribe(value => {});
      }
      endTime(startTime, 'should_compose_through_publish_and_refCount_even_if_it_is_a_Subject');
    });


    it('should_compos_through_publishLast_and_refCount_even_if_it_is_a_Subject', 0, () => {
      const subject = new Subject<number>();

      const result = subject.pipe(
        publishLast(),
        refCount(),
        map((x: ESObject) => 10 * x)
      ) as ESObject as Subject<number>; // Yes, this is correct.

      expect(result instanceof Subject).assertTrue();

      const emitted: ESObject[] = [];
      result.subscribe(value => {
        emitted.push(value);
        if (value == 300) {
          expect(emitted).assertDeepEquals([100, 200, 300]);
        }
      });
      result.next(10);
      result.next(20);
      result.next(30);
      let startTime = new Date().getTime()
      for (let index = 0; index < BASE_COUNT; index++) {
        result.next(30);
      }
      endTime(startTime, 'should_compos_through_publishLast_and_refCount_even_if_it_is_a_Subject');
    });

    it('should_compos_through_publishBehavior_nd_refCount_even_if_it_is_a_Subject', 0, () => {
      const subject = new Subject<number>();

      const result = subject.pipe(
        publishBehavior(0),
        refCount(),
        map((x) => 10 * x)
      ) as ESObject as Subject<number>; // Yes, this is correct.

      expect(result instanceof Subject).assertTrue();

      const emitted: ESObject[] = [];
      result.subscribe(value => {
        emitted.push(value);
        if (value == 300) {
          expect(emitted).assertDeepEquals([0, 100, 200, 300]);
        }
      });

      result.next(10);
      result.next(20);
      result.next(30);
      let startTime = new Date().getTime()
      for (let index = 0; index < BASE_COUNT; index++) {
        result.subscribe(value => { });
      }
      endTime(startTime, 'should_compos_through_publishBehavior_nd_refCount_even_if_it_is_a_Subject');
    });


    it('should_compose_through_multicast_with_selector_function', 0, (done: ESObject) => {
      const result = new MyCustomObservable<number>((observer) => {
        observer.next(1);
        observer.next(2);
        observer.next(3);
        observer.complete();
      }).pipe(
        multicast(
          () => new Subject<number>(),
          (shared) => shared.pipe(map((x) => 10 * x))
        )
      );

      expect(result instanceof MyCustomObservable).assertTrue();

      const expected = [10, 20, 30];

      result.subscribe(
        {
          next: (x) => {
            expect(x).assertDeepEquals(expected.shift());
          }, error: () => {
          done(new Error('should not be called'));
        }, complete: () => {
          done();
        }
        }
      );
      let startTime = new Date().getTime()
      for (let index = 0; index < BASE_COUNT; index++) {
        new MyCustomObservable<number>((observer) => {
          observer.next(1);
          observer.next(2);
          observer.next(3);
          observer.complete();
        })
      }
      endTime(startTime, 'should_compose_through_multicast_with_selector_function');
    });

    it('should_compose_through_combineLatest', 0, () => {
      rxTestScheduler.run((helpers: RunHelpers) => {
        let cold = helpers.cold
        let expectObservable = helpers.expectObservable
        const e1 = cold(' -a--b-----c-d-e-|');
        const e2 = cold(' --1--2-3-4---|   ');
        const expected = '--A-BC-D-EF-G-H-|';

        const result = combineLatest([e1, e2], (a, b) => String(a) + String(b));

        expectObservable<ESObject>(result).toBe(expected, {
          A: 'a1',
          B: 'b1',
          C: 'b2',
          D: 'b3',
          E: 'b4',
          F: 'c4',
          G: 'd4',
          H: 'e4',
        });
        let startTime = new Date().getTime()
        for (let index = 0; index < BASE_COUNT; index++) {
          combineLatest([e1, e2], (a, b) => String(a) + String(b));
        }
        endTime(startTime, 'should_compose_through_combineLatest');
      });
    });

    it('should_ompose_through_concat', 0, () => {
      rxTestScheduler.run((helpers: RunHelpers) => {
        let cold = helpers.cold
        let expectObservable = helpers.expectObservable
        const e1 = cold(' --a--b-|');
        const e2 = cold(' --x---y--|');
        const expected = '--a--b---x---y--|';

        const result: ESObject = concat(e1, e2);

        expectObservable<ESObject>(result).toBe(expected);
        let startTime = new Date().getTime()
        for (let index = 0; index < BASE_COUNT; index++) {
          concat(e1, e2);
        }
        endTime(startTime, 'should_ompose_through_concat');
      });
    });
    it('should_compose_through_merge', 0, () => {
      rxTestScheduler.run((helpers: RunHelpers) => {
        let cold = helpers.cold
        let expectObservable = helpers.expectObservable
        const e1 = cold(' -a--b-| ');
        const e2 = cold(' --x--y-|');
        const expected = '-ax-by-|';

        const result: ESObject = merge(e1, e2);

        expectObservable<ESObject>(result).toBe(expected);
        let startTime = new Date().getTime()
        for (let index = 0; index < BASE_COUNT; index++) {
          merge(e1, e2);
        }
        endTime(startTime, 'should_compose_through_merge');
      });
    });

    it('should_compose_through_race', 0, () => {
      rxTestScheduler.run((helpers: RunHelpers) => {
        let cold = helpers.cold
        let expectObservable = helpers.expectObservable
        let expectSubscriptions = helpers.expectSubscriptions
        const e1 = cold(' ---a-----b-----c----|');
        const e1subs = '  ^-------------------!';
        const e2 = cold(' ------x-----y-----z----|');
        const e2subs = '  ^--!';
        const expected = '---a-----b-----c----|';
        const result = race(e1, e2);

        expectObservable<ESObject>(result).toBe(expected);
        expectSubscriptions(e1.subscriptions).toBe(e1subs);
        expectSubscriptions(e2.subscriptions).toBe(e2subs);
        let startTime = new Date().getTime()
        for (let index = 0; index < BASE_COUNT; index++) {
          e2.subscriptions;
        }
        endTime(startTime, 'should_compose_through_race');
      });
    });

    it('should_compose_through_zip', 0, () => {
      rxTestScheduler.run((helpers: RunHelpers) => {
        let cold = helpers.cold
        let expectObservable = helpers.expectObservable
        const e1 = cold(' -a--b-----c-d-e-|');
        const e2 = cold(' --1--2-3-4---|   ');
        const expected = '--A--B----C-D|   ';

        const result: ESObject = zip(e1, e2, (a, b) => String(a) + String(b));


        expectObservable<ESObject>(result).toBe(expected, {
          A: 'a1',
          B: 'b2',
          C: 'c3',
          D: 'd4',
        });
        let startTime = new Date().getTime()
        for (let index = 0; index < BASE_COUNT; index++) {
          cold(' --1--2-3-4---|   ');
        }
        endTime(startTime, 'should_compose_through_zip');
      });
    });

    it('should_allow_njecting_behaviors_into_all_subscribers_n_an_operator_chain_when_overridden', 0, (done: ESObject) => {
      // The custom Subscriber
      const log: Array<string> = [];

      class LogSubscriber<T> extends Subscriber<T> {
        next(value?: T): void {
          log.push('next ' + value);
          if (!this.isStopped) {
            this._next(value!);
          }
        }
      }

      // The custom Operator
      class LogOperator<T, R> implements Operator<T, R> {
        private childOperator: Operator<T, R>

        constructor(childOperator: Operator<T, R>) {
          this.childOperator = childOperator
        }

        call(subscriber: Subscriber<R>, source: ESObject): TeardownLogic {
          return this.childOperator.call(new LogSubscriber<R>(subscriber), source);
        }
      }

      // The custom Observable
      class LogObservable<T> extends Observable<T> {
        lift<R>(operator: Operator<T, R>): Observable<R> {
          const observable = new LogObservable<R>();
          observable.source = this;
          observable.operator = new LogOperator(operator);
          return observable;
        }
      }

      // Use the LogObservable
      const result = new LogObservable<number>((observer) => {
        observer.next(1);
        observer.next(2);
        observer.next(3);
        observer.complete();
      }).pipe(
        map((x) => 10 * x),
        filter((x) => x > 15),
        count()
      );

      expect(result instanceof LogObservable).assertTrue();

      const expected = [2];

      result.subscribe(
        {
          next: (x) => {
            expect(x).assertEqual(expected.shift());
          }, error: () => {
          done(new Error('should not be called'));
        }, complete: () => {
          expect(log).assertDeepEquals([
            'next 10', // map
            'next 20', // map
            'next 20', // filter
            'next 30', // map
            'next 30', // filter
            'next 2',// count
          ]);
          done();
        }
        }
      );

      let startTime = new Date().getTime()
      for (let index = 0; index < BASE_COUNT; index++) {
        result.subscribe();
      }
      endTime(startTime, 'should_allow_njecting_behaviors_into_all_subscribers_n_an_operator_chain_when_overridden');
    });
  });
}
function endTime(startTime: number, tag: string) {
  console.log(tag + ":startTime:" + startTime)
  let endTime: number = new Date().getTime();
  let averageTime = ((endTime - startTime) * 1000 / BASE_COUNT)
  console.log(tag + ":endTime:" + endTime)
  console.log(tag + ":averageTime:" + averageTime + "μs");
}