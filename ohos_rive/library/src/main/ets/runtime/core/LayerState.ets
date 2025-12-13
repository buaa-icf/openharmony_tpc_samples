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


export default class LayerState extends NativeObject {

  constructor(cppPointer: BigInt) {
    super(cppPointer);
  }

  // LayerState cpp objects are tied to the lifecycle of the StateMachineInstances in cpp
  // Therefore we do not have a cppDelete implementation
  private cppIsExitState(cppPointer: BigInt): boolean {
    console.log(`[ohos_rive_ui] LayerState.ets: cppIsExitState C++ Napi_LayerState_cppIsExitState`);
    return rive.Napi_LayerState_cppIsExitState(cppPointer);
  }

  private cppIsAnyState(cppPointer: BigInt): boolean {
    console.log(`[ohos_rive_ui] LayerState.ets: cppIsAnyState C++ Napi_LayerState_cppIsAnyState`);
    return rive.Napi_LayerState_cppIsAnyState(cppPointer)
  }

  private cppIsEntryState(cppPointer: BigInt): boolean {
    console.log(`[ohos_rive_ui] LayerState.ets: cppIsEntryState C++ Napi_LayerState_cppIsEntryState`);
    return rive.Napi_LayerState_cppIsEntryState(cppPointer)
  }

  private cppIsAnimationState(cppPointer: BigInt): boolean {
    console.log(`[ohos_rive_ui] LayerState.ets: cppIsAnimationState C++ Napi_LayerState_cppIsAnimationState`);
    return rive.Napi_LayerState_cppIsAnimationState(cppPointer)

  }

  private cppIsBlendState(cppPointer: BigInt): boolean {
    console.log(`[ohos_rive_ui] LayerState.ets: cppIsBlendState C++ Napi_LayerState_cppIsBlendState`);
    return rive.Napi_LayerState_cppIsBlendState(cppPointer);
  }

  private cppIsBlendStateDirect(cppPointer: BigInt): boolean {
    console.log(`[ohos_rive_ui] LayerState.ets: cppIsBlendStateDirect C++ Napi_LayerState_cppIsBlendStateDirect`);
    return rive.Napi_LayerState_cppIsBlendStateDirect(cppPointer);
  }

  private cppIsBlendState1D(cppPointer: BigInt): boolean {
    console.log(`[ohos_rive_ui] LayerState.ets: cppIsBlendState1D C++ Napi_LayerState_cppIsBlendState1D`);
    return rive.Napi_LayerState_cppIsBlendState1D(cppPointer);
  }

  /**
   * Is this state an exit state.
   */
  get isExitState(): boolean {
    return this.cppIsExitState(this.cppPointer);
  }

  /**
   * Is this state an any state.
   */
  get isAnyState(): boolean {
    return this.cppIsAnyState(this.cppPointer);
  }

  /**
   * Is this state an entry state.
   */
  get isEntryState(): boolean {
    return this.cppIsEntryState(this.cppPointer);
  }

  /**
   * Is this state an animation state.
   */
  get isAnimationState(): boolean {
    return this.cppIsAnimationState(this.cppPointer);
  }

  /**
   * Is this state a blend state.
   */
  get isBlendState(): boolean {
    return this.cppIsBlendState(this.cppPointer);
  }

  /**
   * Is this state a 1D blend state.
   */
  get isBlendState1D(): boolean {
    return this.cppIsBlendState1D(this.cppPointer);
  }

  /**
   * Is this state an Additive blend state.
   */
  get isBlendStateDirect(): boolean {
    return this.cppIsBlendStateDirect(this.cppPointer);
  }

  override toString(): string {
    return 'LayerState';
  }
}