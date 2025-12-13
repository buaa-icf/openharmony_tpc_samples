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
import { RiveEvent } from './RiveEvent';

/**
 * An open URL Rive event.
 *
 * @param unsafeCppPointer Pointer to the C++ counterpart.
 * @see RiveGeneralEvent
 */
export class RiveOpenURLEvent extends RiveEvent {
  private cppURL(pointer: BigInt): string {
    return rive.Napi_RiveOpenURLEvent_cppURL(pointer);
  }

  private cppTarget(pointer: BigInt): string {
    return rive.Napi_RiveOpenURLEvent_cppTarget(pointer);
  }

  constructor(unsafeCppPointer: BigInt, delay: number) {
    super(unsafeCppPointer, delay);
  }

  /** The URL of the event. */
  get url(): string {
    return this.cppURL(this.cppPointer);
  }

  /** The target of the event. */
  get target(): string {
    return this.cppTarget(this.cppPointer);
  }

  toString(): string {
    return `OpenURLRiveEvent, name: ${this.name}, url: ${this.url}, ` +
      `target: ${this.target}, properties: ${JSON.stringify(this.properties)}`;
  }
}

