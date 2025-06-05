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

function expectFullObserver(val: ESObject) {
  expect(val instanceof Object).assertTrue();
  expect(val.next instanceof Function).assertTrue();
  expect(val.error instanceof Function).assertTrue();
  expect(val.complete instanceof Function).assertTrue();
  expect(val.closed).assertFalse();
}

export default function observableTest() {
  describe('Observable', () => {
    let rxTestScheduler: TestScheduler;

    beforeEach(() => {
      rxTestScheduler = new TestScheduler(observableMatcher);
    });

    it('should_allow_empty_ctor_which_is_effectively_a_never_observable', 0, () => {
      rxTestScheduler.run((helpers: RunHelpers) => {
        let expectObservable = helpers.expectObservable
        const result: ESObject = new Observable<ESObject>();
        expectObservable<ESObject>(result).toBe('-');
      });
    });


  });
}