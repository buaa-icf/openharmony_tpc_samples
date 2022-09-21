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

import abilityTest from './Ability.test'
import ajaxTest from './spec/ajax/index-spec'
import firstValueFromTest from './spec/firstValueFrom-spec'
import configTest from './spec/config-spec';
import lastValueFromTest from './spec/lastValueFrom-spec'
import queueSchedulerTest from './spec/scheduler-spec'
import NotificationTest from './spec/Notification-spec'
import observableTest from './spec/Observable-spec'
import subjectTest from './spec/Subject-spec'
import subscriberTest from './spec/Subscriber-spec'
import subscriptionTest from './spec/Subscription-spec'
import asyncSubjectTest from './spec/subjects/AsyncSubject-spec'
import behaviorSubjectTest from './spec/subjects/BehaviorSubject-spec'
import replaySubjectTest from './spec/subjects/ReplaySubject-spec'

export default function testsuite() {
  abilityTest();
  ajaxTest();
  firstValueFromTest();
  configTest();
  lastValueFromTest();
  NotificationTest();
  observableTest();
  queueSchedulerTest();
  subjectTest();
  subscriberTest();
  subscriptionTest();
  asyncSubjectTest();
  behaviorSubjectTest();
  replaySubjectTest();
}