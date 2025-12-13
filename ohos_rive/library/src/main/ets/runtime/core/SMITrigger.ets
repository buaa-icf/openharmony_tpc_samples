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

/** A trigger state machines input. */
export class SMITrigger extends SMIInput {
  private cppFire(pointer: BigInt): void {
    console.log(`[ohos_rive_ui] SMITrigger.ets: cppFire C++ Napi_SMI_cppSMITriggerFire`);
    rive.Napi_SMI_cppSMITriggerFire(pointer);
  }

  constructor(unsafeCppPointer: BigInt) {
    super(unsafeCppPointer);
  }

  /**
   * Fire the trigger.
   * This method is typically called internally by the controller.
   */
  fire(): void {
    this.cppFire(this.cppPointer);
  }

  toString(): string {
    return `SMITrigger ${this.name}\n`;
  }
}

