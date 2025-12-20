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
import { File } from './File';
import { NativeObject } from './NativeObject';
import { ViewModelException } from './errors/ViewModelException';
import { ViewModelInstance, Transfer } from './ViewModelInstance';
import { StateMachineInstance } from './StateMachineInstance';
import LinearAnimationInstance from './LinearAnimationInstance';
import { SMIInput } from './SMIInput';
import { SMIBoolean } from './SMIBoolean';
import { SMITrigger } from './SMITrigger';
import { SMINumber } from './SMINumber';
import { RiveTextValueRun } from './RiveTextValueRun';

const NULL_POINTER: BigInt = 0n;
export class Artboard extends NativeObject {
  public file: File;

  constructor(unsafeCppPointer: BigInt, file: File) {
    super(unsafeCppPointer);
    this.file = file;
  }

  private cppName(cppPointer: BigInt): string {
    return rive.Napi_Artboard_cppName(cppPointer);
  }

  private cppAnimationByIndex(cppPointer: BigInt, index: number): BigInt {
    return rive.Napi_Artboard_animationByIndex(cppPointer, index);
  }

  private cppAnimationByName(cppPointer: BigInt, name: string): BigInt {
    return rive.Napi_Artboard_animationByName(cppPointer, name);
  }

  private cppAnimationCount(cppPointer: BigInt): number {
    return rive.Napi_Artboard_animationCount(cppPointer);
  }

  private cppAnimationNameByIndex(cppPointer: BigInt, index: number): string {
    return rive.Napi_Artboard_animationNameByIndex(cppPointer, index);
  }

  private cppStateMachineByIndex(cppPointer: BigInt, index: number): BigInt {
    return rive.Napi_Artboard_stateMachineByIndex(cppPointer, index);
  }

  private cppStateMachineByName(cppPointer: BigInt, name: string): BigInt {
    return rive.Napi_Artboard_stateMachineByName(cppPointer, name);
  }

  private cppStateMachineCount(cppPointer: BigInt): number {
    return rive.Napi_Artboard_stateMachineCount(cppPointer);
  }

  private cppStateMachineNameByIndex(cppPointer: BigInt, index: number): string {
    return rive.Napi_Artboard_stateMachineNameByIndex(cppPointer, index);
  }

  private cppInputByNameAtPath(cppPointer: BigInt, name: string, path: string): BigInt {
    return rive.Napi_Artboard_inputByNameAtPath(cppPointer, name, path);
  }

  private cppGetVolume(cppPointer: BigInt): number {
    return rive.Napi_Artboard_getVolume(cppPointer);
  }

  private cppSetVolume(cppPointer: BigInt, volume: number): void {
    rive.Napi_Artboard_setVolume(cppPointer, volume);
  }

  private cppAdvance(cppPointer: BigInt, elapsedTime: number): boolean {
    return rive.Napi_Artboard_advance(cppPointer, elapsedTime);
  }

  private cppFindTextValueRun(cppPointer: BigInt, name: string): BigInt {
    return rive.Napi_Artboard_findTextValueRun(cppPointer, name);
  }

  private cppFindValueOfTextValueRun(cppPointer: BigInt, name: string): string {
    return rive.Napi_Artboard_findValueOfTextValueRun(cppPointer, name);
  }

  private cppSetValueOfTextValueRun(cppPointer: BigInt, name: string, newText: string): void {
    rive.Napi_Artboard_setValueOfTextValueRun(cppPointer, name, newText);
  }

  private cppFindTextValueRunAtPath(cppPointer: BigInt, name: string, path: string): BigInt {
    return rive.Napi_Artboard_findTextValueRunAtPath(cppPointer, name, path);
  }

  private cppFindValueOfTextValueRunAtPath(cppPointer: BigInt, name: string, path: string): string {
    return rive.Napi_Artboard_findValueOfTextValueRunAtPath(cppPointer, name, path);
  }

  private cppSetValueOfTextValueRunAtPath(cppPointer: BigInt, name: string, newText: string, path: string): void {
    rive.Napi_Artboard_setValueOfTextValueRunAtPath(cppPointer, name, newText, path);
  }

  private cppDraw(cppPointer: BigInt, rendererPointer: BigInt) {
    rive.Napi_Artboard_draw(cppPointer, rendererPointer);
  }

  private cppDrawAligned(
    cppPointer: BigInt,
    rendererPointer: BigInt,
    fit: rive.Fit,
    alignment: rive.Alignment,
    scaleFactor: number
  ) {
    rive.Napi_Artboard_drawAligned(cppPointer, rendererPointer, fit, alignment, scaleFactor);
  }

  private cppBounds(cppPointer: BigInt): rive.Bounds {
    return rive.Napi_Artboard_bounds(cppPointer);
  }

  private cppResetArtboardSize(cppPointer: BigInt): void {
    rive.Napi_Artboard_resetArtboardSize(cppPointer);
  }

  private cppGetArtboardWidth(cppPointer: BigInt): number {
    return rive.Napi_Artboard_getArtboardWidth(cppPointer);
  }

  private cppSetArtboardWidth(cppPointer: BigInt, width: number): void {
    rive.Napi_Artboard_setArtboardWidth(cppPointer, width);
  }

  private cppGetArtboardHeight(cppPointer: BigInt): number {
    return rive.Napi_Artboard_getArtboardHeight(cppPointer);
  }

  private cppSetArtboardHeight(cppPointer: BigInt, height: number): void {
    rive.Napi_Artboard_setArtboardHeight(cppPointer, height);
  }

  private cppSetViewModelInstance(cppPointer: BigInt, instancePointer: BigInt): void {
    rive.Napi_Artboard_setViewModelInstance(cppPointer, instancePointer);
  }

  cppDelete(pointer: BigInt): void {
    rive.Napi_Artboard_delete(pointer);
  }

  release(): number {
    return super.release();
  }

  /** Get the [name] of the Artboard. */
  get name(): string {
    return this.cppName(this.cppPointer);
  }

  /**
   * Get the first [animation][LinearAnimationInstance] of the [Artboard].
   *
   * If you use more than one animation, it is preferred to use the [animation] functions.
   *
   * @throws AnimationException if the animation does not exist.
   */
  get firstAnimation(): LinearAnimationInstance {
    return this.animationIndex(0);
  }

  /**
   * Get the animation at a given 0-based [index] in the [Artboard].
   *
   * @throws AnimationException If the animation does not exist.
   */
  animationIndex(index: number): LinearAnimationInstance {
    const animationPointer = this.cppAnimationByIndex(this.cppPointer, index);
    if (animationPointer == NULL_POINTER) {
      throw new Error(`No animation found at index ${index}.`);
    }
    const lai = new LinearAnimationInstance(animationPointer);
    this.addDependency(lai);
    return lai;
  }

  /**
   * Get the animation with a given [name] in the [Artboard].
   *
   * @throws AnimationException If the animation does not exist.
   */
  animation(name: string): LinearAnimationInstance {
    const animationPointer = this.cppAnimationByName(this.cppPointer, name);
    if (animationPointer == NULL_POINTER) {
      throw new Error(
        `Animation "${name}" not found. Available Animations: ${this.animationNames.map(it => `"${it}"`)}`
      );
    }
    const lai = new LinearAnimationInstance(animationPointer);
    this.addDependency(lai);
    return lai;
  }

  /**
   * Get the first [state machine][StateMachineInstance] of the artboard.
   *
   * If you use more than one animation, it is preferred to use the [stateMachine] functions.
   *
   * @throws StateMachineException If the state machine does not exist.
   */
  get firstStateMachine(): StateMachineInstance {
    return this.stateMachineIndex(0);
  }

  /**
   * Get the state machine at a given 0-based [index] in the artboard.
   *
   * @throws StateMachineException If the state machine does not exist.
   */
  stateMachineIndex(index: number): StateMachineInstance {
    const stateMachinePointer = this.cppStateMachineByIndex(this.cppPointer, index);
    if (stateMachinePointer == NULL_POINTER) {
      throw new Error(`No StateMachine found at index ${index}.`);
    }
    const smi = new StateMachineInstance(stateMachinePointer);
    this.addDependency(smi);
    return smi;
  }

  /**
   * Get the state machine with a given [name] in the artboard.
   *
   * @throws StateMachineException If the state machine does not exist.
   */
  stateMachine(name: string): StateMachineInstance {
    console.log(`[ohos_rive_ui] Arboard: stateMachine st`);
    const stateMachinePointer = this.cppStateMachineByName(this.cppPointer, name);
    if (stateMachinePointer == NULL_POINTER) {
      throw new Error(`No StateMachine found with name ${name}.`);
    }
    const smi = new StateMachineInstance(stateMachinePointer);
    this.addDependency(smi);
    return smi;
  }

  /**
   * Get the input instance with a given [name] on the nested artboard represented at [path].
   *
   * @throws StateMachineInputException If the input does not exist.
   */
  input(name: string, path: string): SMIInput {
    const stateMachineInputPointer = this.cppInputByNameAtPath(this.cppPointer, name, path);
    if (stateMachineInputPointer == NULL_POINTER) {
      throw new Error(`No StateMachineInput found with name "${name}" in nested artboard $path.`);
    }
    const input = new SMIInput(stateMachineInputPointer);
    return this.convertInput(input);
  }

  /**
   * Get a [RiveTextValueRun] with a given [name] in the artboard.
   *
   * @return The text value run.
   * @throws TextValueRunException If the text run does not exist.
   */
  textRunName(name: string): RiveTextValueRun {
    const textRunPointer = this.cppFindTextValueRun(this.cppPointer, name);
    if (textRunPointer == NULL_POINTER) {
      throw new Error(`No Rive TextValueRun found with name "${name}".`);
    }
    const run = new RiveTextValueRun(textRunPointer);
    this.addDependency(run);
    return run;
  }

  /**
   * Get the text value for a text run named [name].
   *
   * @return The text value of the run, or null if the run is not found.
   */
  getTextRunValueName(name: string): string {
    return this.cppFindValueOfTextValueRun(this.cppPointer, name);
  }

  /**
   * Set the text value for a text run named [name] to [textValue].
   *
   * @throws TextValueRunException If the text run does not exist.
   */
  setTextRunValueName(name: string, textValue: string): void {
    console.info('FontFallbackPage: cppSetValueOfTextValueRun');
    this.cppSetValueOfTextValueRun(this.cppPointer, name, textValue);
  }

  /**
   * Get a [RiveTextValueRun] with a given [name] on the nested artboard represented at [path].
   *
   * @return The text value run.
   * @throws TextValueRunException If the text run does not exist.
   */
  textRunNameAndPath(name: string, path: string): RiveTextValueRun {
    const textRunPointer = this.cppFindTextValueRunAtPath(this.cppPointer, name, path);
    if (textRunPointer == NULL_POINTER) {
      throw new Error(`No Rive TextValueRun found with name "${name}." in nested artboard $path`);
    }
    const run = new RiveTextValueRun(textRunPointer);
    this.addDependency(run);
    return run;
  }

  /**
   * Get the text value for a text run named [name] on the nested artboard represented at [path].
   *
   * @return The text value of the run, or null if the run is not found.
   */
  getTextRunValueNameAndPath(name: string, path: string): string {
    return this.cppFindValueOfTextValueRunAtPath(this.cppPointer, name, path);
  }

  /**
   * Set the text value for a text run named [name] to [textValue] on the nested artboard
   * represented at [path].
   *
   * @throws TextValueRunException If the text run does not exist.
   */
  setTextRunValueNameAndPath(name: string, textValue: string, path: string): void {
    console.info('FontFallbackPage: setTextRunValueNameAndPath');
    this.cppSetValueOfTextValueRunAtPath(this.cppPointer, name, textValue, path);
  }

  /** Get and set the volume of the artboard. */
  get volume(): number {
    return this.cppGetVolume(this.cppPointer);
  }
  set volume(value: number) {
    this.cppSetVolume(this.cppPointer, value);
  }

  /** @return The number of animations stored inside the artboard. */
  get animationCount(): number {
    return this.cppAnimationCount(this.cppPointer);
  }

  /** @return The number of state machines stored inside the artboard. */
  get stateMachineCount(): number {
    return this.cppStateMachineCount(this.cppPointer);
  }

  /**
   * The [ViewModelInstance] assigned to this artboard. Once assigned, modifications to the
   * properties of the instance will be reflected in the bindings of this artboard.
   *
   * Assigning null will do nothing.
   *
   * You should only use assign this property if your file does not contain a state machine. If it
   * does, prefer [StateMachineInstance.viewModelInstance] instead, as it will set the view model
   * for both the state machine and the artboard.
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
   * @throws ViewModelException If the instance contained by [transfer] has already been assigned
   *    or disposed.
   */
  receiveViewModelInstance(transfer: Transfer): ViewModelInstance {
    const instance: ViewModelInstance = transfer.end();
    this.addDependency(instance);
    this.viewModelInstance = instance;
    return instance;
  }

  /**
   * Advancing the artboard:
   * - Updates the layout for all dirty components contained in the artboard
   * - Updates the positions
   * - Forces all components in the artboard to be laid out
   *
   * Components are all the shapes, bones and groups of an artboard. Whenever components are added
   * to an artboard, for example when an artboard is first loaded, they are considered dirty.
   * Whenever animations change properties of components, move a shape, or change a color, they
   * are marked as dirty.
   *
   * Before any changes to components will be visible in the next rendered frame, the artboard
   * needs to be [advanced][advance].
   *
   * [elapsedTime] is currently not taken into account.
   */
  advance(elapsedTime: number): boolean {
    return this.cppAdvance(this.cppPointer, elapsedTime);
  }

  /** Draw the the artboard to the [renderer][app.rive.runtime.kotlin.renderers.Renderer]. */
  draw(rendererAddress: BigInt): void {
    if (!this.hasCppObject) {
      return;
    }
    this.cppDraw(this.cppPointer, rendererAddress);
  }

  /**
   * Draw the the artboard to the [renderer][app.rive.runtime.kotlin.renderers.Renderer]. Also
   * align the artboard to the render surface.
   */
  drawFit(rendererAddress: BigInt, fit: rive.Fit, alignment: rive.Alignment, scaleFactor: number = 1.0): void {
    if (!this.hasCppObject) {
      return;
    }
    this.cppDrawAligned(
      this.cppPointer,
      rendererAddress,
      fit,
      alignment,
      scaleFactor
    );
  }

  /** Reset the artboard size to its defaults. */
  resetArtboardSize(): void {
    this.cppResetArtboardSize(this.cppPointer);
  }

  /** @return The bounds of artboard as defined in the Rive Editor. */
  get bounds(): rive.Bounds {
    return this.cppBounds(this.cppPointer);
  }

  /** The width of the artboard. */
  get width(): number {
    return this.cppGetArtboardWidth(this.cppPointer);
  }

  set width(value: number) {
    this.cppSetArtboardWidth(this.cppPointer, value);
  }

  /** The height of the artboard. */
  get height(): number {
    return this.cppGetArtboardHeight(this.cppPointer);
  }

  set height(value: number) {
    this.cppSetArtboardHeight(this.cppPointer, value);
  }

  /** @return The names of all animations in the artboard. */
  get animationNames(): string[] {
    const result: string[] = [];
    for (let i = 0; i < this.animationCount; i++) {
      result.push(this.cppAnimationNameByIndex(this.cppPointer, i));
    }
    return result;
  }

  /** @return The names of all stateMachines in the artboard. */
  get stateMachineNames(): string[] {
    const result: string[] = [];
    for (let i = 0; i < this.stateMachineCount; i++) {
      result.push(this.cppStateMachineNameByIndex(this.cppPointer, i));
    }
    return result;
  }

  convertInput(input: SMIInput): SMIInput {
    if (input.isBoolean) {
      return new SMIBoolean(input.cppPointer);
    } else if (input.isTrigger) {
      return new SMITrigger(input.cppPointer);
    } else if (input.isNumber) {
      return new SMINumber(input.cppPointer);
    } else {
      throw new Error(`Unknown State Machine Input Instance for ${input.name}.`);
    }
  }
}