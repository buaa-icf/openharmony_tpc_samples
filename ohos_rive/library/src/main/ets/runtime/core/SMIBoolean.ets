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

/** A boolean state machine input. */
export class SMIBoolean extends SMIInput {
  private cppValue(pointer: BigInt): boolean {
    console.log(`[ohos_rive_ui] SMIBoolean.ets: cppValue C++ Napi_SMI_cppSMIBoolValue`);
    return rive.Napi_SMI_cppSMIBoolValue(pointer);
  }

  private cppSetValue(pointer: BigInt, newValue: boolean): void {
    console.log(`[ohos_rive_ui] SMIBoolean.ets: cppSetValue C++ Napi_SMI_cppSMIBoolSetValue`);
    rive.Napi_SMI_cppSMIBoolSetValue(pointer, newValue);
  }

  constructor(unsafeCppPointer: BigInt) {
    super(unsafeCppPointer);
  }

  get value(): boolean {
    return this.cppValue(this.cppPointer);
  }

  set value(newValue: boolean) {
    this.cppSetValue(this.cppPointer, newValue);
  }

  toString(): string {
    return `SMIBoolean ${this.name}\n`;
  }
}

