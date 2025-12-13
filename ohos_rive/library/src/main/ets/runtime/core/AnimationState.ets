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
import LayerState from './LayerState';

/**
 * AnimationStates are a base class for state machine layer states.
 *
 * @param cppPointer Pointer to the C++ counterpart.
 */
export default class AnimationState extends LayerState {
  constructor(cppPointer: BigInt) {
    super(cppPointer);
  }

  private cppName(pointer: BigInt): string {
    console.log(`[ohos_rive_ui] AnimationState.ets: cppName C++ Napi_AnimationState_cppName`);
    return rive.Napi_AnimationState_cppName(pointer);
  }

  get name(): string {
    return this.cppName(this.cppPointer);
  }

  override toString(): string {
    return this.name;
  }
}
