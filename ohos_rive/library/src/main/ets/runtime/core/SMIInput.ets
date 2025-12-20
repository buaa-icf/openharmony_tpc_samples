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

/**
 * [SMIInput]s are a base class for state machine input instances.
 *
 * These instances allow modification of the state of the attached state machine.
 *
 * @param unsafeCppPointer Pointer to the C++ counterpart.
 */
export class SMIInput extends NativeObject {
  private cppName(pointer: BigInt): string {
    return rive.Napi_SMI_cppSMIInputName(pointer);
  }

  private cppIsBoolean(pointer: BigInt): boolean {
    return rive.Napi_SMI_cppSMIInputIsBoolean(pointer);
  }

  private cppIsTrigger(pointer: BigInt): boolean {
    return rive.Napi_SMI_cppSMIInputIsTrigger(pointer);
  }

  private cppIsNumber(pointer: BigInt): boolean {
    return rive.Napi_SMI_cppSMIInputIsNumber(pointer);
  }

  constructor(unsafeCppPointer: BigInt) {
    super(unsafeCppPointer);
  }

  /** The input name. */
  get name(): string {
    return this.cppName(this.cppPointer);
  }

  /** Whether this input a boolean input. */
  get isBoolean(): boolean {
    return this.cppIsBoolean(this.cppPointer);
  }

  /** Whether this input a trigger input. */
  get isTrigger(): boolean {
    return this.cppIsTrigger(this.cppPointer);
  }

  /** Whether this input a number input. */
  get isNumber(): boolean {
    return this.cppIsNumber(this.cppPointer);
  }

  /**
   * SMIInput cpp objects are tied to the lifecycle of the StateMachineInstances in cpp
   * Therefore we do not have a cppDelete implementation
   */
  protected cppDelete(pointer: BigInt): void {}

  toString(): string {
    return `SMIInput ${this.name}\n`;
  }
}

