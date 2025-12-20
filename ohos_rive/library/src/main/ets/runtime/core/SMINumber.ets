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
import { SMIInput } from './SMIInput';

/** A floating point number state machine input. */
export class SMINumber extends SMIInput {
  private cppValue(pointer: BigInt): number {
    console.log(`[ohos_rive_ui] SMINumber.ets: cppValue C++ Napi_SMI_cppSMINumberValue`);
    return rive.Napi_SMI_cppSMINumberValue(pointer);
  }

  private cppSetValue(pointer: BigInt, value: number): void {
    console.log(`[ohos_rive_ui] SMINumber.ets: cppSetValue C++ Napi_SMI_cppSMINumberSetValue`);
    rive.Napi_SMI_cppSMINumberSetValue(pointer, value);
  }

  constructor(unsafeCppPointer: BigInt) {
    super(unsafeCppPointer);
  }

  get value(): number {
    return this.cppValue(this.cppPointer);
  }

  set value(newValue: number) {
    this.cppSetValue(this.cppPointer, newValue);
  }

  toString(): string {
    return `SMINumber ${this.name}\n`;
  }
}

