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

import { Loop, LoopUtils } from './Loop';
import rive from 'libohos_rive.so';
import { NativeObject } from './NativeObject';
import { Direction } from './Direction';
import { AdvanceResult } from './AdvanceResult';
import { PlayableInstance } from './PlayableInstance';

export default class LinearAnimationInstance extends NativeObject implements PlayableInstance {
  private mix: number;
  public name: string;
  constructor(unsafeCppPointer: BigInt, mix: number = 1.0) {
    super(unsafeCppPointer);
    this.mix = mix;
    this.name = this.cppName(this.cppPointer);
  }

  private cppAdvance(pointer: BigInt, elapsedTime: number): Loop | null {
    return rive.Napi_LinearAnimationInstance_cppAdvance(pointer,elapsedTime);
  }

  private cppAdvanceAndGetResult(pointer: BigInt, elapsedTime: number): AdvanceResult {
    return rive.Napi_LinearAnimationInstance_cppAdvanceAndGetResult(pointer, elapsedTime);
  }

  private cppApply(pointer: BigInt, mix: number): void {
    rive.Napi_LinearAnimationInstance_cppApply(pointer, mix);
  }

  private cppGetTime(pointer: BigInt): number {
    return rive.Napi_LinearAnimationInstance_cppGetTime(pointer);
  }

  private cppSetTime(pointer: BigInt, time: number): void {
    rive.Napi_LinearAnimationInstance_cppSetTime(pointer, time);
  }

  private cppGetDirection(pointer: BigInt): number {
    return rive.Napi_LinearAnimationInstance_cppGetDirection(pointer);
  }

  private cppSetDirection(pointer: BigInt, value: number): void {
    rive.Napi_LinearAnimationInstance_cppSetDirection(pointer, value);
  }

  private cppGetLoop(pointer: BigInt): number {
    return rive.Napi_LinearAnimationInstance_cppGetLoop(pointer);
  }

  private cppSetLoop(pointer: BigInt, value: number): void {
    rive.Napi_LinearAnimationInstance_cppSetLoop(pointer, value);
  }

  private cppName(pointer: BigInt): string {
    return rive.Napi_LinearAnimationInstance_cppName(pointer);
  }

  private cppDuration(pointer: BigInt): number {
    return rive.Napi_LinearAnimationInstance_cppDuration(pointer);
  }

  private cppFps(pointer: BigInt): number {
    return rive.Napi_LinearAnimationInstance_cppFps(pointer);
  }

  private cppWorkStart(pointer: BigInt): number {
    return rive.Napi_LinearAnimationInstance_cppWorkStart(pointer);
  }

  private cppWorkEnd(pointer: BigInt): number {
    return rive.Napi_LinearAnimationInstance_cppWorkEnd(pointer);
  }

  /**
   * Advance the animation.
   *
   * @param elapsedTime The time in seconds to advance by.
   * @return The [Loop] type associated with the current animation if this advance caused a loop,
   *    otherwise null.
   */
  advance(elapsedTime: number): Loop | null {
    return this.cppAdvance(this.cppPointer, elapsedTime);
  }

  /**
   * Advance the animation and return the result.
   *
   * @param elapsedTime The time in seconds to advance by.
   * @return An [AdvanceResult] enum value indicating the outcome of the advance step
   */
  advanceAndGetResult(elapsedTime: number): AdvanceResult {
    return this.cppAdvanceAndGetResult(this.cppPointer, elapsedTime);
  }

  /**
   * Applies the animation instance's current set of transformations to an [Artboard].
   *
   * Uses the [mix] property (a value between 0 and 1) to set the strength at which the animation
   * is mixed with other animations applied to the [Artboard].
   */
  apply() {
    this.cppApply(this.cppPointer, this.mix);
  }

  /**
   * Applies and advances the animation instance in a single step.
   *
   * @return `true` if the animation will continue to animate after this advance.
   */
  applyAndAdvance(elapsed: number): boolean {
    this.cppApply(this.cppPointer, this.mix);
    const result = this.advanceAndGetResult(elapsed);
    return [AdvanceResult.ADVANCED, AdvanceResult.LOOP, AdvanceResult.PINGPONG].includes(result);
  }

  /** The elapsed time that this instance has played to. */
  gettime(): number {
    return this.cppGetTime(this.cppPointer);
  }

  /** Seeks the animation to [time]. */
 settime(time: number) {
    this.cppSetTime(this.cppPointer, time);
  }

  /**
   * Configure the animation to play [forwards][Direction.FORWARDS] or
   * [backwards][Direction.BACKWARDS].
   */
  getdirection(): Direction {
    const direction = Direction.fromInt(this.cppGetDirection(this.cppPointer));
    return direction || Direction.FORWARDS;
  }

  setdirection(value: Direction) {
    this.cppSetDirection(this.cppPointer, Direction.getValue(value));
  }

  /**
   * The duration of an animation in frames. This does not take [workStart] and [workEnd] into
   * account.
   */
  getduration(): number {
    return this.cppDuration(this.cppPointer);
  }

  /** The duration of this animation in frames, taking [workStart] and [workEnd] into account. */
  geteffectiveDuration(): number {
    if (this.getworkStart() === -1) {
      return this.getduration();
    }
    return this.getworkEnd() - this.getworkStart();
  }

  /** The duration of an animation in seconds, taking [workStart] and [workEnd] into account. */
  geteffectiveDurationInSeconds(): number {
    return this.geteffectiveDuration() / this.getfps();
  }

  /** Return the frames per second (FPS) configured for this animation. */
  getfps(): number {
    return this.cppFps(this.cppPointer);
  }

  /**
   * The offset in frames to the beginning of an animations work area. Animations will start
   * playing from here.
   */
  getworkStart(): number {
    return this.cppWorkStart(this.cppPointer);
  }

  /**
   * The offset in frames to the end of an animations work area. Animations will execute their
   * loop behavior once this is reached.
   */
  getworkEnd(): number {
    return this.cppWorkEnd(this.cppPointer);
  }

  /** The name given to this animation. */
  getname(): string {
    return this.cppName(this.cppPointer);
  }

  /**
   * The offset in seconds to the beginning of the animation. Animations will start playing from
   * here.
   */
  getstartTime(): number {
    return this.getworkStart() === -1 ? 0 : this.getworkStart() / this.getfps();
  }

  /** The offset in seconds to the end of the animation. */
  getendTime(): number {
    return this.getworkEnd() === -1 ? this.getduration() / this.getfps() : this.getworkEnd() / this.getfps();
  }

  /**
   * Configure the [Loop] mode for this animation. Can be either [Loop.LOOP], [Loop.ONESHOT],
   * [Loop.PINGPONG] or [Loop.AUTO].
   */
  getloop(): Loop {
    const intLoop = this.cppGetLoop(this.cppPointer);
    return LoopUtils.fromIndex(intLoop);
  }

  setloop(value: Loop) {
    this.cppSetLoop(this.cppPointer, LoopUtils.fromIndex(value));
  }
}