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

import { NativeObject } from './NativeObject';
import { EventType } from './EventType';
import { RiveEvent } from './RiveEvent';
import { RiveOpenURLEvent } from './RiveOpenURLEvent';
import { RiveGeneralEvent } from './RiveGeneralEvent';

/**
 * A class for reported Rive events to match its C++ counterpart.
 *
 * @param unsafeCppPointer Pointer to the C++ counterpart.
 */
export class RiveEventReport extends NativeObject {
  private secondsDelay: number;
  private _event: RiveEvent | null = null;

  constructor(unsafeCppPointer: BigInt, secondsDelay: number) {
    super(unsafeCppPointer);
    this.secondsDelay = secondsDelay;
  }

  get event(): RiveEvent {
    if (this._event === null) {
      this._event = this.convertEvent(new RiveEvent(this.cppPointer, this.secondsDelay));
    }
    return this._event;
  }

  private convertEvent(event: RiveEvent): RiveEvent {
    if (event.type === EventType.OpenURLEvent) {
      return new RiveOpenURLEvent(event.riveEventCppPointer, event.delay);
    } else {
      return new RiveGeneralEvent(event.riveEventCppPointer, event.delay);
    }
  }
}
