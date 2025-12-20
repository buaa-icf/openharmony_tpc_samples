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
import rive from 'libohos_rive.so';
import { ViewModelInstance, Transfer } from './ViewModelInstance';
import { PlayableInstance } from './PlayableInstance';
import { SMIInput } from './SMIInput';
import { SMIBoolean } from './SMIBoolean';
import { SMINumber } from './SMINumber';
import { SMITrigger } from './SMITrigger';
import LayerState from './LayerState';
import { RiveEvent } from './RiveEvent';
import { RiveEventReport } from './RiveEventReport';
import { StateMachineInputException } from './errors/StateMachineInputException';
import AnimationState from './AnimationState';
import AnyState from './AnyState';
import EntryState from './EntryState';
import ExitState from './ExitState';
import BlendState from './BlendState';

/**
 * The [StateMachineInstance] is a helper to wrap common operations to play a state machine.
 *
 * This object has a counterpart in C++, which implements a lot of functionality. The
 * [unsafeCppPointer] keeps track of this relationship.
 *
 * Use this to keep track of a state machine's current state and progress, and to help [apply]
 * changes that the state machine makes to components in an [Artboard].
 */
export class StateMachineInstance extends NativeObject implements PlayableInstance {

  private cppAdvance(pointer: BigInt, elapsedTime: number): boolean {
    return rive.Napi_StateMachine_cppAdvance(pointer, elapsedTime);
  }

  private cppInputCount(cppPointer: BigInt): number {
    return  rive.Napi_StateMachine_cppInputCount(cppPointer);
  }

  private cppSMIInputByIndex(cppPointer: BigInt, index: number): BigInt {
    return  rive.Napi_StateMachine_cppSMIInputByIndex(cppPointer, index);
  }

  private cppStateChangedCount(cppPointer: BigInt): number {
    return  rive.Napi_StateMachine_cppStateChangedCount(cppPointer);
  }

  private cppStateChangedByIndex(cppPointer: BigInt, index: number): BigInt {
    return  rive.Napi_StateMachine_cppStateChangedByIndex(cppPointer, index);
  }

  private cppReportedEventCount(cppPointer: BigInt): number {
    return  rive.Napi_StateMachine_cppReportedEventCount(cppPointer);
  }

  private cppReportedEventAt(cppPointer: BigInt, index: number): RiveEventReport {
    return rive.Napi_StateMachine_cppReportedEventAt(cppPointer, index) as RiveEventReport;
  }

  private cppName(cppPointer: BigInt): string {
    return  rive.Napi_StateMachine_cppName(cppPointer);
  }

  private cppLayerCount(cppPointer: BigInt): number {
    return  rive.Napi_StateMachine_cppLayerCount(cppPointer);
  }

  private cppPointerDown(cppPointer: BigInt, pointerID: number, x: number, y: number): void {
     rive.Napi_StateMachine_cppPointerDown(cppPointer, pointerID, x, y);
  }

  private cppPointerUp(cppPointer: BigInt, pointerID: number, x: number, y: number): void {
     rive.Napi_StateMachine_cppPointerUp(cppPointer, pointerID, x, y);
  }

  private cppPointerMove(cppPointer: BigInt, pointerID: number, x: number, y: number): void {
     rive.Napi_StateMachine_cppPointerMove(cppPointer, pointerID, x, y);
  }

  private cppPointerExit(cppPointer: BigInt, pointerID: number, x: number, y: number): void {
     rive.Napi_StateMachine_cppPointerExit(cppPointer, pointerID, x, y);
  }

  private cppSetViewModelInstance(cppPointer: BigInt, viewModel: BigInt): void {
     rive.Napi_StateMachine_cppSetViewModelInstance(cppPointer, viewModel);
  }

  private cppDeleteImpl(pointer: BigInt): void {
     rive.Napi_StateMachine_cppDelete(pointer);
  }

  constructor(unsafeCppPointer: BigInt) {
    super(unsafeCppPointer);
  }

  /** @return The name of state machine. */
  get name(): string {
    return this.cppName(this.cppPointer);
  }

  /** @return The number of layers configured for the state machine. */
  get layerCount(): number {
    return this.cppLayerCount(this.cppPointer);
  }

  /**
   * The [ViewModelInstance] assigned to this artboard. Once assigned, modifications to the
   * properties of the instance will be reflected in the bindings of this state machine.
   *
   * Assigning will apply to both the [StateMachineInstance] and the parent [Artboard]. Assigning
   * null will do nothing.
   */
  private _viewModelInstance: ViewModelInstance | null = null;
  get viewModelInstance(): ViewModelInstance | null {
    return this._viewModelInstance;
  }

  set viewModelInstance(value: ViewModelInstance | null) {
    if (value !== null) {
      this.cppSetViewModelInstance(this.cppPointer, value.ViewModelInstanceCppPointer);
    }
    this._viewModelInstance = value;
  }

  /**
   * @throws Error If the instance contained by [transfer] has already been assigned or disposed.
   * Note: ViewModelInstance.Transfer is not yet implemented in ETS version
   */
  receiveViewModelInstance(transfer: Transfer): ViewModelInstance {
    const instance = transfer.end();
    this.addDependency(instance);
    this.viewModelInstance = instance;
    return instance;
  }

  /**
   * Advance the state machine.
   *
   * @param elapsed The time in seconds to advance by.
   * @return `true` if the state machine will continue to animate after this advance.
   */
  advance(elapsed: number): boolean {
    return this.cppAdvance(this.cppPointer, elapsed);
  }

  pointerDown(pointerID: number, x: number, y: number): void {
    this.cppPointerDown(this.cppPointer, pointerID, x, y);
  }

  pointerUp(pointerID: number, x: number, y: number): void {
    this.cppPointerUp(this.cppPointer, pointerID, x, y);
  }

  pointerMove(pointerID: number, x: number, y: number): void {
    this.cppPointerMove(this.cppPointer, pointerID, x, y);
  }

  pointerExit(pointerID: number, x: number, y: number): void {
    this.cppPointerExit(this.cppPointer, pointerID, x, y);
  }

  /** @return The number of inputs configured for the state machine. */
  get inputCount(): number {
    return this.cppInputCount(this.cppPointer);
  }

  /** @return The number of states changed in the last advance. */
  private get stateChangedCount(): number {
    return this.cppStateChangedCount(this.cppPointer);
  }

  /** @return The number of events fired in the last advance. */
  private get reportedEventCount(): number {
    return this.cppReportedEventCount(this.cppPointer);
  }

  private convertInput(input: SMIInput): SMIInput {
    if (input.isBoolean) {
      return new SMIBoolean(input.cppPointer);
    } else if (input.isTrigger) {
      return new SMITrigger(input.cppPointer);
    } else if (input.isNumber) {
      return new SMINumber(input.cppPointer);
    } else {
      throw new StateMachineInputException(`Unknown State Machine Input Instance for ${input.name}.`);
    }
  }

  /**
   * Get the input instance at a given [index] in the state machine.
   *
   * This starts at 0.
   *
   * @throws Error If no [SMIInput] is found at the given [index].
   */
  input(index: number): SMIInput {
    const stateMachineInputPointer = this.cppSMIInputByIndex(this.cppPointer, index);
    if (stateMachineInputPointer === NativeObject.NULL_POINTER) {
      throw new StateMachineInputException(`No StateMachineInput found at index ${index}.`);
    }
    const input = new SMIInput(stateMachineInputPointer);
    return this.convertInput(input);
  }

  /**
   * Get the input with a given [name] in the state machine.
   *
   * @throws Error If no [SMIInput] is found with the given [name].
   */
  inputByName(name: string): SMIInput {
    for (let i = 0; i < this.inputCount; i++) {
      const output = this.input(i);
      if (output.name === name) {
        return output;
      }
    }
    throw new StateMachineInputException(`No StateMachineInput found with name ${name}.`);
  }

  /** @return All inputs in the state machine. */
  get inputs(): SMIInput[] {
    const result: SMIInput[] = [];
    for (let i = 0; i < this.inputCount; i++) {
      result.push(this.input(i));
    }
    return result;
  }

  /** @return The names of all inputs in the state machine. */
  get inputNames(): string[] {
    const result: string[] = [];
    for (let i = 0; i < this.inputCount; i++) {
      result.push(this.input(i).name);
    }
    return result;
  }

  private convertLayerState(state: LayerState): LayerState {
    if (state.isAnimationState) {
      return new AnimationState(state.cppPointer);
    } else if (state.isAnyState) {
      return new AnyState(state.cppPointer);
    } else if (state.isEntryState) {
      return new EntryState(state.cppPointer);
    } else if (state.isExitState) {
      return new ExitState(state.cppPointer);
    } else if (state.isBlendState) {
      return new BlendState(state.cppPointer);
    } else {
      throw new StateMachineInputException(`Unknown Layer State for ${state}.`);
    }
  }

  /**
   * Get a specific state changed in the last advance.
   *
   * @param index The index of the state.
   * @throws Error If no [LayerState] is found at the given [index].
   */
  stateChanged(index: number): LayerState {
    const stateChanged = this.cppStateChangedByIndex(this.cppPointer, index);
    if (stateChanged === 0n) {
      throw new Error(`No LayerState found at index ${index}.`);
    }
    const layerState = new LayerState(stateChanged);
    return this.convertLayerState(layerState);
  }

  /**
   * Get a specific event fired in the last advance.
   *
   * @param index The index of the event.
   * @throws Error If no event is found at the given [index].
   */
  eventAt(index: number): RiveEvent {
    const eventReportData = this.cppReportedEventAt(this.cppPointer, index);
    if (eventReportData.cppPointer === NativeObject.NULL_POINTER) {
      throw new Error(`No Rive Event found at index ${index}.`);
    }
    return eventReportData.event;
  }

  /** @return All layer states changed in the last advance. */
  get statesChanged(): LayerState[] {
    const result: LayerState[] = [];
    for (let i = 0; i < this.stateChangedCount; i++) {
      result.push(this.stateChanged(i));
    }
    return result;
  }

  /** @return All events fired in the last advance. */
  get eventsReported(): RiveEvent[] {
    const result: RiveEvent[] = [];
    for (let i = 0; i < this.reportedEventCount; i++) {
      result.push(this.eventAt(i));
    }
    return result;
  }

  protected cppDelete(pointer: BigInt): void {
    this.cppDeleteImpl(pointer);
  }
}