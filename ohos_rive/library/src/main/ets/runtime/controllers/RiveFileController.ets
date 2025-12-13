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

import { Loop } from '../core/Loop';
import { File } from '../core/File';
import { RendererAttributes } from '../renderers/RendererAttributes';
import { Alignment } from '../core/Alignment';
import { Fit } from '../core/Fit';
import { Direction } from '../core/Direction';
import { StateMachineInstance } from '../core/StateMachineInstance';
import { Artboard } from '../core/Artboard';
import LinearAnimationInstance from '../core/LinearAnimationInstance';
import { PlayableInstance } from '../core/PlayableInstance';
import { RiveEvent } from '../core/RiveEvent';
import { Observable } from '../Observable';
import { AdvanceResult } from '../core/AdvanceResult';
import { ChangedInput } from '../RiveAnimationView';
import { Bounds } from '../RiveAnimationView';
import { RefCount } from '../core/RefCount';
import { Helpers, RectF, PointF } from '../core/Helpers';
import { SMITrigger } from '../core/SMITrigger';
import { SMIBoolean } from '../core/SMIBoolean';
import { SMINumber } from '../core/SMINumber';
import { systemDateTime } from '@kit.BasicServicesKit';

const TAG: string = 'RiveFileController';

export interface RiveFileControllerListener {
  notifyPlay(animation:PlayableInstance): void;
  notifyPause(animation: PlayableInstance): void;
  notifyStop(animation: PlayableInstance): void;
  notifyLoop(animation: PlayableInstance): void;
  notifyStateChanged(stateMachineName: string, stateName: string): void;
  notifyAdvance?(elapsed: number): void;
}

export interface RiveEventListener {
  notifyEvent(event: RiveEvent): void;
}

export class ControllerState {
  public file: File;
  public activeArtboard: Artboard;
  public animations: LinearAnimationInstance[];
  public playingAnimations: Set<LinearAnimationInstance>;
  public stateMachines: StateMachineInstance[];
  public playingStateMachines: Set<StateMachineInstance>;
  public isActive: boolean;

  constructor(
    file: File,
    activeArtboard: Artboard,
    animations: LinearAnimationInstance[],
    playingAnimations: Set<LinearAnimationInstance>,
    stateMachines: StateMachineInstance[],
    playingStateMachines: Set<StateMachineInstance>,
    isActive: boolean
  ) {
    this.file = file;
    this.activeArtboard = activeArtboard;
    this.animations = animations;
    this.playingAnimations = playingAnimations;
    this.stateMachines = stateMachines;
    this.playingStateMachines = playingStateMachines;
    this.isActive = isActive;
  }

  dispose(): void {
    this.file.release();
    this.activeArtboard.release();
  }
}

export enum PointerEvents {
  POINTER_DOWN = 0,
  POINTER_UP = 1,
  POINTER_MOVE = 2,
  POINTER_EXIT = 3
}

interface Point {
  x: number;
  y: number;
}

interface Rect {
  left: number;
  top: number;
  right: number;
  bottom: number;
}

export type OnStartCallback = () => void;

export class RiveFileController extends RefCount implements Observable<RiveFileControllerListener> {
  private static readonly TAG: string = TAG;
  public loop: Loop;
  public autoplay: boolean;
  private _fit: Fit = Fit.CONTAIN;
  private _alignment: Alignment = Alignment.CENTER;
  public file: File | null;
  private _activeArtboard: Artboard | null = null;
  public isActive: boolean = false;
  private _layoutScaleFactor: number | null = null;
  private _layoutScaleFactorAutomatic: number = 1.0;
  private rendererAttributes: RendererAttributes;
  public onStart: OnStartCallback | null = null;
  private userSetVolume: number | null = null;
  private animationList: LinearAnimationInstance[] = [];
  private stateMachineList: StateMachineInstance[] = [];
  private playingAnimationSet: Set<LinearAnimationInstance> = new Set();
  private playingStateMachineSet: Set<StateMachineInstance> = new Set();
  private changedInputs: ChangedInput[] = [];
  private listeners: Set<RiveFileControllerListener> = new Set();
  private eventListeners: Set<RiveEventListener> = new Set();
  public targetBounds: Bounds | null = null;
  public requireArtboardResize: boolean = false;
  constructor(
    loop: Loop = Loop.AUTO,
    autoplay: boolean = true,
    file: File | null = null,
    activeArtboard: Artboard | null = null,
    rendererAttributes: RendererAttributes | null = null,
    onStart: OnStartCallback | null = null
  ) {

    super()
    this.loop = loop;
    this.autoplay = autoplay;
    this.file = file;
    this._activeArtboard = activeArtboard;
    this.rendererAttributes = rendererAttributes || RendererAttributes.default();
    this.onStart = onStart;
  }

  set activeArtboard(value: Artboard | null) {
    this._activeArtboard = value;
    console.debug(`${TAG}:, set activeArtboard = ` + this._activeArtboard)
  }

  get activeArtboard(): Artboard | null {
    console.debug(`${TAG}:, get activeArtboard = ` + this._activeArtboard)
    return this._activeArtboard;
  }

  get layoutScaleFactor(): number | null {
    return this._layoutScaleFactor;
  }

  set layoutScaleFactor(value: number | null) {
    this._layoutScaleFactor = value;
    this.requireArtboardResize = true;
    this.onStart?.();
  }

  get layoutScaleFactorAutomatic(): number {
    return this._layoutScaleFactorAutomatic;
  }

  set layoutScaleFactorAutomatic(value: number) {
    this._layoutScaleFactorAutomatic = value;
    this.requireArtboardResize = true;
    this.onStart?.();
  }

  get layoutScaleFactorActive(): number {
    return this._layoutScaleFactor ?? this._layoutScaleFactorAutomatic;
  }

  get animations(): LinearAnimationInstance[] {
    return [...this.animationList];
  }

  get stateMachines(): StateMachineInstance[] {
    return [...this.stateMachineList];
  }

  get playingAnimations(): Set<LinearAnimationInstance> {
    return new Set(this.playingAnimationSet);
  }

  get playingStateMachines(): Set<StateMachineInstance> {
    return new Set(this.playingStateMachineSet);
  }

  get pausedAnimations(): Set<LinearAnimationInstance> {
    const playing = this.playingAnimations;
    return new Set(this.animations.filter(anim => !playing.has(anim)));
  }

  get pausedStateMachines(): Set<StateMachineInstance> {
    const playing = this.playingStateMachines;
    return new Set(this.stateMachines.filter(sm => !playing.has(sm)));
  }

  get artboardBounds(): Bounds {
    if (this._activeArtboard) {
      return this._activeArtboard.bounds;
    }
    return { left: 0, top: 0, right: 0, bottom: 0 };
  }

  get isAdvancing(): boolean {
    return this.playingAnimationSet.size > 0 ||
      this.playingStateMachineSet.size > 0 ||
      this.changedInputs.length > 0;
  }

  get isAnimating(): boolean {
    return this.isAdvancing;
  }

  get fit(): Fit {
    return this._fit;
  }

  set fit(value: Fit) {
    if (this._fit !== value) {
      this._fit = value;
      this.requireArtboardResize = true;
      this.onStart?.();
    }
  }

  get alignment(): Alignment {
    return this._alignment;
  }

  set alignment(value: Alignment) {
    if (this._alignment !== value) {
      this._alignment = value;
      this.onStart?.();
    }
  }

  setRiveFile(file: File, artboardName?: string | null): void {
    if (file === this.file) {
      return;
    }
    if (this.file) {
      this.reset();
      this.file.release();
    }
    this.file = file;
    this.file.acquire();
  }

  selectArtboard(name?: string | null): void {
    if (!this.file) {
      console.warn(`${TAG}: selectArtboard: cannot select an Artboard without a valid File.`);
      return;
    }
    try {
      const artboard = name ? this.file.artboardByName(name) : this.file.firstArtboard;
      this.setArtboard(artboard);
    } catch (error) {
      console.error(`${TAG}: Error selecting artboard: ${error}`);
    }
  }

  private setArtboard(ab: Artboard): void {
    if (ab === this._activeArtboard) {
      return;
    }

    this.stopAllAnimations();
    if (this._activeArtboard) {
      this._activeArtboard.release();
    }
    this._activeArtboard = ab;
    this._activeArtboard.acquire();

    if (this.userSetVolume !== null) {
      this._activeArtboard.volume = this.userSetVolume;
    }

    this.autoplayInternal();
  }

  private autoplayInternal(): void {
    if (this.autoplay) {
      this.play();
    } else {
      this._activeArtboard?.advance(0);
      this.onStart?.();
    }
  }

  setupScene(rendererAttributes: RendererAttributes): void {
    const mFile = this.file;
    if (!mFile) {
      console.warn(`${TAG}: Cannot init without a file`);
      return;
    }

    this.reset();
    this.autoplay = rendererAttributes.autoplay;
    this.alignment = rendererAttributes.alignment;
    this.fit = rendererAttributes.fit;
    this.loop = rendererAttributes.loop;

    const abName = rendererAttributes.artboardName;

    try {
      this._activeArtboard = abName ? mFile.artboardByName(abName) : mFile.firstArtboard;
      if (this._activeArtboard) {
        this._activeArtboard.acquire();
      }
      console.error(`${TAG}:setupScene====`,this._activeArtboard.name)
      if (rendererAttributes.autoBind && this._activeArtboard) {
        const activeArtboard = this._activeArtboard;
        const defaultInstance = mFile.defaultViewModelForArtboard(activeArtboard).createDefaultInstance();
        activeArtboard.viewModelInstance = defaultInstance;

        const stateMachineName: string | null = rendererAttributes.stateMachineName ||
          (activeArtboard.stateMachineNames.length > 0 ? activeArtboard.stateMachineNames[0] : null);
        if (stateMachineName) {
          this.getOrCreateStateMachines(stateMachineName);
        }
        this.stateMachines.forEach(stateMachine => {
          stateMachine.viewModelInstance = defaultInstance;
        });
      }
      console.error(`${TAG}: setupScene: ${this.autoplay}`)
      if (this.autoplay) {
        const animName = rendererAttributes.animationName;
        const smName = rendererAttributes.stateMachineName;
        console.error(`${TAG}: setupScene: ${animName}`)
        if (animName) {
          this.play(animName);
        } else if (smName) {
          this.play(smName, Loop.AUTO, Direction.AUTO, true, true);
        } else {
          this.play(Loop.AUTO, Direction.AUTO, true);
        }
      } else {
        this._activeArtboard?.advance(0);
        this.onStart?.();
      }
    } catch (error) {
      console.error(`${TAG}: Error during setup: ${error}`);
    }
  }

  play(
    animationNameOrNames?: string | string[] | Loop | undefined,
    loopOrDirection?: Loop | Direction | boolean | undefined,
    directionOrIsStateMachine?: Direction | boolean | undefined,
    isStateMachineOrSettleInitialState?: boolean | undefined,
    settleInitialStateOverride?: boolean
  ): void {
    console.info(`${TAG}: play animationNameOrNames: ${animationNameOrNames}`);
    if (Array.isArray(animationNameOrNames)) {
      const animationNames = animationNameOrNames;
      const loop = loopOrDirection as Loop ?? Loop.AUTO;
      const direction = directionOrIsStateMachine as Direction ?? Direction.AUTO;
      const areStateMachines = isStateMachineOrSettleInitialState as boolean ?? false;
      const settleInitialState = settleInitialStateOverride ?? true;

      animationNames.forEach(name => {
        this.playAnimation(name, loop, direction, areStateMachines, settleInitialState);
      });
      return;
    }
    if (animationNameOrNames === undefined || typeof animationNameOrNames === 'number') {
      const derivedLoop: Loop = (animationNameOrNames as Loop) ?? Loop.AUTO;
      const direction = loopOrDirection as Direction ?? Direction.AUTO;
      const settleInitialState = directionOrIsStateMachine as boolean ?? true;
      console.error('animationNameOrNames  is here 1')
      if (this._activeArtboard) {
        console.error('play pausedAnimations',this.pausedAnimations.size)
        console.error('play pausedAnimations',this.pausedStateMachines.size)
        if (this.pausedAnimations.size > 0 || this.pausedStateMachines.size > 0) {
          this.animations.forEach(anim => {
            console.error('play anim')
            this.playAnimationInstance(anim, derivedLoop, direction);
          });
          this.stateMachines.forEach(sm => {
            console.error('play sm')
            this.playStateMachineInstance(sm, settleInitialState);
          });
        } else {
          const animationNames = this._activeArtboard.animationNames;
          if (animationNames.length > 0) {
            this.playAnimation(animationNames[0], derivedLoop, direction, false, settleInitialState);
          } else {
            const stateMachineNames = this._activeArtboard.stateMachineNames;
            if (stateMachineNames.length > 0) {
              this.playAnimation(stateMachineNames[0], derivedLoop, direction, true, settleInitialState);
            }
          }
        }
      }
      return;
    }

    const animationName = animationNameOrNames as string;
    const loop = loopOrDirection as Loop ?? Loop.AUTO;
    const direction = directionOrIsStateMachine as Direction ?? Direction.AUTO;
    const isStateMachine = isStateMachineOrSettleInitialState as boolean ?? false;
    const settleInitialState = settleInitialStateOverride ?? true;
    console.info(`${TAG}: play animationNameOrNames play use this interface`);
    this.playAnimation(animationName, loop, direction, isStateMachine, settleInitialState);
  }

  private playAnimation(
    animationName: string,
    loop: Loop = Loop.AUTO,
    direction: Direction = Direction.AUTO,
    isStateMachine: boolean = false,
    settleInitialState: boolean = true
  ): void {
    if (isStateMachine) {
      const stateMachineInstances = this.getOrCreateStateMachines(animationName);
      stateMachineInstances.forEach(instance => {
        this.playStateMachineInstance(instance, settleInitialState);
      });
    } else {
      const animationInstances = this.getAnimationsByName(animationName);
      animationInstances.forEach(instance => {
        this.playAnimationInstance(instance, loop, direction);
      });

      if (animationInstances.length === 0 && this._activeArtboard) {
        try {
          const animationInstance = this._activeArtboard.animation(animationName);
          if (animationInstance) {
            this.playAnimationInstance(animationInstance, loop, direction);
          }
        } catch (error) {
          console.error(`${TAG}: Error creating animation instance: ${error}`);
        }
      }
    }
  }

  private playAnimationInstance(
    animationInstance: LinearAnimationInstance,
    loop: Loop,
    direction: Direction
  ): void {
    const appliedLoop = loop === Loop.AUTO ? this.loop : loop;
    if (appliedLoop !== Loop.AUTO) {
      animationInstance.setloop(appliedLoop);
    }

    if (this.animationList.indexOf(animationInstance) === -1) {
      if (direction === Direction.BACKWARDS) {
        animationInstance.settime(animationInstance.getendTime());
      }
      this.animationList.push(animationInstance);
    }

    if (direction !== Direction.AUTO) {
      animationInstance.setdirection(direction);
    }

    this.playingAnimationSet.add(animationInstance);
    this.onStart?.();
    this.notifyPlay(animationInstance);
  }

  private playStateMachineInstance(
    stateMachineInstance: StateMachineInstance,
    settleStateMachineState: boolean = true
  ): void {
    console.error('playStateMachineInstance===',)
    if (this.stateMachineList.indexOf(stateMachineInstance) === -1) {
      this.stateMachineList.push(stateMachineInstance);
    }

    if (settleStateMachineState) {
      this.resolveStateMachineAdvance(stateMachineInstance, 0);
    }

    this.playingStateMachineSet.add(stateMachineInstance);
    this.onStart?.();
    this.notifyPlay(stateMachineInstance);
  }

  pauseAllAnimations(): void {
    this.playingAnimations.forEach(anim => this.pauseAnimation(anim));
    this.playingStateMachines.forEach(sm => this.pauseStateMachine(sm));
  }

  pauseAnimations(animationName: string, isStateMachine: boolean = false): void {
    if (isStateMachine) {
      this.getStateMachinesByName(animationName).forEach(sm => this.pauseStateMachine(sm));
    } else {
      this.getAnimationsByName(animationName).forEach(anim => this.pauseAnimation(anim));
    }
  }

  pauseMultipleAnimations(animationNames: string[], areStateMachines: boolean = false): void {
    if (areStateMachines) {
      this.getStateMachinesByNames(animationNames).forEach(sm => this.pauseStateMachine(sm));
    } else {
      this.getAnimationsByNames(animationNames).forEach(anim => this.pauseAnimation(anim));
    }
  }

  private pauseAnimation(animation: LinearAnimationInstance): void {
    const removed = this.playingAnimationSet.delete(animation);
    if (removed) {
      this.notifyPause(animation);
    }
  }

  private pauseStateMachine(stateMachine: StateMachineInstance): void {
    const removed = this.playingStateMachineSet.delete(stateMachine);
    if (removed) {
      this.notifyPause(stateMachine);
    }
  }

  stopAllAnimations(): void {
    this.animations.forEach(anim => this.stopAnimation(anim));
    this.stateMachines.forEach(sm => this.stopStateMachine(sm));
  }

  stopAnimations(animationName: string, isStateMachine: boolean = false): void {
    if (isStateMachine) {
      this.getStateMachinesByName(animationName).forEach(sm => this.stopStateMachine(sm));
    } else {
      this.getAnimationsByName(animationName).forEach(anim => this.stopAnimation(anim));
    }
  }

  stopMultipleAnimations(animationNames: string[], areStateMachines: boolean = false): void {
    if (areStateMachines) {
      this.getStateMachinesByNames(animationNames).forEach(sm => this.stopStateMachine(sm));
    } else {
      this.getAnimationsByNames(animationNames).forEach(anim => this.stopAnimation(anim));
    }
  }

  private stopAnimation(animation: LinearAnimationInstance): void {
    this.playingAnimationSet.delete(animation);
    const index = this.animationList.indexOf(animation);
    if (index !== -1) {
      this.animationList.splice(index, 1);
      this.notifyStop(animation);
    }
  }

  private stopStateMachine(stateMachine: StateMachineInstance): void {
    this.playingStateMachineSet.delete(stateMachine);
    const index = this.stateMachineList.indexOf(stateMachine);
    if (index !== -1) {
      this.stateMachineList.splice(index, 1);
      this.notifyStop(stateMachine);
    }
  }

  fireState(stateMachineName: string, inputName: string, path?: string | null): void {
    this.queueInput(stateMachineName, inputName, null, path);
  }

  setBooleanState(
    stateMachineName: string,
    inputName: string,
    value: boolean,
    path?: string | null
  ): void {
    this.queueInput(stateMachineName, inputName, value, path);
  }

  setNumberState(
    stateMachineName: string,
    inputName: string,
    value: number,
    path?: string | null
  ): void {
    this.queueInput(stateMachineName, inputName, value, path);
  }

  fireStateAtPath(inputName: string, path: string): void {
    this.queueInput('', inputName, null, path);
  }

  setBooleanStateAtPath(inputName: string, value: boolean, path: string): void {
    this.queueInput('', inputName, value, path);
  }

  setNumberStateAtPath(inputName: string, value: number, path: string): void {
    this.queueInput('', inputName, value, path);
  }

  queueInputs(...inputs: ChangedInput[]): void {
    this.changedInputs.push(...inputs);
    this.onStart?.();
  }

  private queueInput(
    stateMachineName: string,
    inputName: string,
    value: boolean | number | null = null,
    path: string | null | undefined = null
  ): void {
    this.queueInputs(new ChangedInput(stateMachineName, inputName, value, path || null));
  }

  private processAllInputs(): void {
    const playableSet: Set<StateMachineInstance> = new Set();

    while (this.changedInputs.length > 0) {
      const input = this.changedInputs.shift();
      if (!input) {
        break;
      }

      if (!input.nestedArtboardPath) {
        const stateMachines = this.getOrCreateStateMachines(input.stateMachineName);
        stateMachines.forEach(stateMachineInstance => {
          playableSet.add(stateMachineInstance);
          const smiInput = stateMachineInstance.inputByName(input.name);
          if (smiInput instanceof SMITrigger) {
            smiInput.fire();
          } else if (smiInput instanceof SMIBoolean) {
            smiInput.value = input.value as boolean;
          } else if (smiInput instanceof SMINumber) {
            smiInput.value = input.value as number;
          }
        });
      } else {
        const smiInput = this._activeArtboard?.input(input.name, input.nestedArtboardPath);
        if (smiInput instanceof SMITrigger) {
          smiInput.fire();
        } else if (smiInput instanceof SMIBoolean) {
          smiInput.value = input.value as boolean;
        } else if (smiInput instanceof SMINumber) {
          smiInput.value = input.value as number;
        }
      }
    }

    playableSet.forEach(sm => {
      this.playStateMachineInstance(sm, false);
    });
  }
  getArtboard(): Artboard | null {
    return this._activeArtboard;

  }

  getTextRunValue(textRunName: string, path?: string): string | null {
    if (path) {
      return this._activeArtboard?.getTextRunValueNameAndPath(textRunName, path) || null;
    } else {
      return this._activeArtboard?.getTextRunValueName(textRunName) || null;
    }
  }

  setTextRunValue(textRunName: string, textValue: string, path?: string): void {
    if (path) {
      this._activeArtboard?.setTextRunValueNameAndPath(textRunName, textValue, path);
    } else {
      this._activeArtboard?.setTextRunValueName(textRunName, textValue);
    }

    this.stateMachines.forEach(sm => {
      this.playStateMachineInstance(sm, false);
    });
  }

  getVolume(): number | null {
    return this._activeArtboard?.volume || null;
  }

  setVolume(value: number): void {
    this.userSetVolume = value;
    if (this._activeArtboard) {
      this._activeArtboard.volume = value;
    }
  }

  pointerEvent(eventType: PointerEvents, pointerID: number, x: number, y: number): void {
    x = vp2px(x);
    y = vp2px(y);
    if (!this._activeArtboard || !this.targetBounds) {
      return;
    }

    let artboardEventLocation: Point = { x, y };
    try {
      // return { left: 0, top: 0, right: 0, bottom: 0 };
      const touchBounds = new RectF(
        this.targetBounds.left,
        this.targetBounds.top,
        this.targetBounds.right,
        this.targetBounds.bottom
      );
      const artboardBoundsValue = this.artboardBounds;
      const artboardBounds = new RectF(
        artboardBoundsValue.left,
        artboardBoundsValue.top,
        artboardBoundsValue.right,
        artboardBoundsValue.bottom
      );
      const converted = Helpers.convertToArtboardSpace(
        touchBounds,
        new PointF(x, y),
        this.fit,
        this.alignment,
        artboardBounds,
        this.layoutScaleFactorActive
      );
      artboardEventLocation = { x: converted.x, y: converted.y };
    } catch (error) {
      console.warn(`${TAG}: pointerEvent convertToArtboardSpace failed: ${error}`);
    }

    this.stateMachines.forEach(stateMachine => {
      switch (eventType) {
        case PointerEvents.POINTER_DOWN:
          stateMachine.pointerDown(pointerID, artboardEventLocation.x, artboardEventLocation.y);
          break;
        case PointerEvents.POINTER_UP:
          stateMachine.pointerUp(pointerID, artboardEventLocation.x, artboardEventLocation.y);
          break;
        case PointerEvents.POINTER_MOVE:
          stateMachine.pointerMove(pointerID, artboardEventLocation.x, artboardEventLocation.y);
          break;
        case PointerEvents.POINTER_EXIT:
          stateMachine.pointerExit(pointerID, artboardEventLocation.x, artboardEventLocation.y);
          break;
      }

      this.playStateMachineInstance(stateMachine, false);
    });
  }

  advance(elapsed: number): void {
    if (!this.file || !this._activeArtboard) {
      return;
    }

    const ab = this._activeArtboard;

    this.processAllInputs();

    let shouldArtboardAdvance = false;
    this.animations.forEach(animationInstance => {
      if (this.playingAnimationSet.has(animationInstance)) {
        const advanceResult = animationInstance.advanceAndGetResult(elapsed);
        animationInstance.apply();
        switch (advanceResult) {
          case AdvanceResult.ONESHOT:
            this.stopAnimation(animationInstance);
            break;

          case AdvanceResult.LOOP:
          case AdvanceResult.PINGPONG:
            this.notifyLoop(animationInstance);
            break;

          case AdvanceResult.ADVANCED:
            shouldArtboardAdvance = this.playingStateMachineSet.size === 0;
            break;

          case AdvanceResult.NONE:
            break;
        }
      }
    });

    if (shouldArtboardAdvance) {
      ab.advance(elapsed);
    }

    const stateMachinesToPause: StateMachineInstance[] = [];
    this.stateMachines.forEach(stateMachineInstance => {
      if (this.playingStateMachineSet.has(stateMachineInstance)) {
        const stillPlaying = this.resolveStateMachineAdvance(stateMachineInstance, elapsed);
        if (!stillPlaying) {
          stateMachinesToPause.push(stateMachineInstance);
        }
      }
    });

    if (elapsed > 0) {
      stateMachinesToPause.forEach(sm => this.pauseStateMachine(sm));
    }

    this.playingStateMachines.forEach(sm => {
      sm.viewModelInstance?.pollChanges();
    });

    this.notifyAdvance(elapsed);
  }

  private resolveStateMachineAdvance(
    stateMachineInstance: StateMachineInstance,
    elapsed: number
  ): boolean {
    if (this.eventListeners.size > 0) {
      stateMachineInstance.eventsReported.forEach(event => {
        this.notifyEvent(event);
      });
    }

    const stillPlaying = stateMachineInstance.advance(elapsed);

    if (this.listeners.size > 0) {
      stateMachineInstance.statesChanged.forEach(state => {
        this.notifyStateChanged(stateMachineInstance.name, state.toString());
      });
    }

    return stillPlaying;
  }

  getOrCreateStateMachines(animationName: string): StateMachineInstance[] {
    const stateMachineInstances = this.getStateMachinesByName(animationName);
    if (stateMachineInstances.length === 0 && this._activeArtboard) {
      try {
        const stateMachineInstance = this._activeArtboard.stateMachine(animationName);
        this.stateMachineList.push(stateMachineInstance);
        return [stateMachineInstance];
      } catch (error) {
        console.error(`${TAG}: Error creating state machine: ${error}`);
        return [];
      }
    }
    return stateMachineInstances;
  }

  private getAnimationsByName(animationName: string): LinearAnimationInstance[] {
    return this.getAnimationsByNames([animationName]);
  }

  private getAnimationsByNames(animationNames: string[]): LinearAnimationInstance[] {
    return this.animations.filter(anim => {
      return animationNames.includes(anim.name);
    });
  }

  private getStateMachinesByName(animationName: string): StateMachineInstance[] {
    return this.getStateMachinesByNames([animationName]);
  }

  private getStateMachinesByNames(animationNames: string[]): StateMachineInstance[] {
    return this.stateMachines.filter(sm => animationNames.includes(sm.name));
  }

  reset(): void {
    this.playingAnimationSet.clear();
    this.animationList = [];
    this.playingStateMachineSet.clear();
    this.stateMachineList = [];
    this.changedInputs = [];
    if (this._activeArtboard) {
      this._activeArtboard.release();
    }
    this._activeArtboard = null;
  }

  registerListener(listener: RiveFileControllerListener): void {
    this.listeners.add(listener);
  }

  unregisterListener(listener: RiveFileControllerListener): void {
    this.listeners.delete(listener);
  }

  addEventListener(listener: RiveEventListener): void {
    this.eventListeners.add(listener);
  }

  removeEventListener(listener: RiveEventListener): void {
    this.eventListeners.delete(listener);
  }

  private notifyPlay(playableInstance: PlayableInstance): void {
    this.listeners.forEach(listener => {
      listener.notifyPlay(playableInstance);
    });
  }

  private notifyPause(playableInstance: PlayableInstance): void {
    this.listeners.forEach(listener => {
      listener.notifyPause(playableInstance);
    });
  }

  private notifyStop(playableInstance: PlayableInstance): void {
    this.listeners.forEach(listener => {
      listener.notifyStop(playableInstance);
    });
  }

  private notifyLoop(playableInstance: PlayableInstance): void {
    this.listeners.forEach(listener => {
      listener.notifyLoop(playableInstance);
    });
  }

  private notifyAdvance(elapsed: number): void {
    this.listeners.forEach(listener => {
      listener.notifyAdvance?.(elapsed);
    });
  }

  private notifyStateChanged(stateMachineName: string, stateName: string): void {
    this.listeners.forEach(listener => {
      listener.notifyStateChanged(stateMachineName, stateName);
    });
  }

  private notifyEvent(event: RiveEvent): void {
    this.eventListeners.forEach(listener => {
      listener.notifyEvent(event);
    });
  }

  saveControllerState(): ControllerState | null {
    const mFile = this.file;
    const mArtboard = this._activeArtboard;

    if (!mFile || !mArtboard) {
      return null;
    }

    if (!mFile.hasCppObject) {
      return null;
    }

    mFile.acquire();
    mArtboard.acquire();

    return new ControllerState(
      mFile,
      mArtboard,
      [...this.animationList],
      new Set(this.playingAnimationSet),
      [...this.stateMachineList],
      new Set(this.playingStateMachineSet),
      this.isActive
    );
  }

  restoreControllerState(state: ControllerState): void {
    this.reset();

    this.file = state.file;
    this._activeArtboard = state.activeArtboard;
    this.animationList = [...state.animations];
    this.stateMachineList = [...state.stateMachines];

    state.playingAnimations.forEach(anim => {
      this.playAnimationInstance(anim, anim.getloop(), anim.getdirection());
    });

    state.playingStateMachines.forEach(sm => {
      this.playStateMachineInstance(sm, false);
    });

    this.isActive = state.isActive;

    state.dispose();
  }
}

