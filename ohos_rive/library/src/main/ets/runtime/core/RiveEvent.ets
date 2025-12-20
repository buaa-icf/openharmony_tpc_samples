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

import rive from 'libohos_rive.so';
import { NativeObject } from './NativeObject';
import { EventType, EventTypeFromInt } from './EventType';

/**
 * A class for Rive events.
 *
 * @param unsafeCppPointer Pointer to the C++ counterpart.
 * @see RiveOpenURLEvent
 * @see RiveGeneralEvent
 */
export class RiveEvent extends NativeObject {
  public readonly delay: number;
  public readonly riveEventCppPointer:BigInt
  private cppName(pointer: BigInt): string {
    console.log(`[ohos_rive_ui] RiveEvent.ets: cppName C++ Napi_RiveEvent_cppName`);
    return rive.Napi_RiveEvent_cppName(pointer);
  }

  private cppType(pointer: BigInt): number {
    console.log(`[ohos_rive_ui] RiveEvent.ets: cppType C++ Napi_RiveEvent_cppType`);
    return rive.Napi_RiveEvent_cppType(pointer);
  }

  private cppProperties(pointer: BigInt): object {
    console.log(`[ohos_rive_ui] RiveEvent.ets: cppProperties C++ Napi_RiveEvent_cppProperties`);
    return rive.Napi_RiveEvent_cppProperties(pointer);
  }

  private cppData(pointer: BigInt): Record<string, ESObject> {
    console.log(`[ohos_rive_ui] RiveEvent.ets: cppData C++ Napi_RiveEvent_cppData`);
    return rive.Napi_RiveEvent_cppData(pointer);
  }

  constructor(unsafeCppPointer: BigInt, delay: number) {
    super(unsafeCppPointer);
    this.riveEventCppPointer = unsafeCppPointer;
    this.delay = delay;
  }
  /** Name of the event. */
  get name(): string {
    return this.cppName(this.cppPointer);
  }

  private get typeCode(): number {
    return this.cppType(this.cppPointer);
  }

  /** Type of event. */
  get type(): EventType {
    return EventTypeFromInt(this.typeCode);
  }
  /** Properties of the event. */
  get properties(): object {
    return this.cppProperties(this.cppPointer);
  }

  /** Data of the event. */
  get data(): Record<string, ESObject> {
    return this.cppData(this.cppPointer);
  }

  toString(): string {
    return `RiveEvent ${this.data})`;
  }

}