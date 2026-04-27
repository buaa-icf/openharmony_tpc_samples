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
import { File } from './core/File';
import {
  RiveFileController,
  PointerEvents,
  RiveFileControllerListener,
  RiveEventListener,
} from './controllers/RiveFileController';
import { Loop, LoopUtils } from './core/Loop';
import { Alignment } from './core/Alignment';
import { Fit } from './core/Fit';
import { Direction } from './core/Direction';
import {
  RendererAttributes,
  ResourceType,
  ResourceId,
  ResourceUrl,
  ResourceBytes,
  ResourceRiveFile,
  ResourceTypeFactory
} from './renderers/RendererAttributes';
import { RendererType, rendererTypeToIndex, rendererTypeFromIndex } from './renderers/RendererType';
import { FileAssetLoader, FallbackAssetLoader } from './core/FileAssetLoader';
import { StateMachineInstance } from './core/StateMachineInstance';
import LinearAnimationInstance from './core/LinearAnimationInstance';
import { Artboard } from './core/Artboard';
import { BusinessError, systemDateTime } from '@kit.BasicServicesKit';
import http from '@ohos.net.http';
import { Renderer } from './renderers/Renderer';
import { RiveArtboardRenderer } from './renderers/RiveArtboardRenderer';
import { SharedSurface } from './renderers/SharedSurface';
import { JSON } from '@kit.ArkTS';

const TAG: string = 'RiveAnimationView';
const SINGLE_TOUCH_ID: number = 0;

const alignmentIndexDefault: number = Alignment.CENTER;
const fitIndexDefault: number = Fit.CONTAIN;
const loopIndexDefault: number = Loop.AUTO;
const traceAnimationsDefault: boolean = false;
const shouldLoadCDNAssetsDefault: boolean = true;

interface PointerInfo {
  id: number;
  x: number;
  y: number;
}

export interface Bounds {
  left: number;
  top: number;
  right: number;
  bottom: number;
}

type EventProperties = Record<string, string | number | boolean>;

type PlayableInstance = LinearAnimationInstance | StateMachineInstance;

export class ChangedInput {
  public stateMachineName: string;
  public name: string;
  public value: boolean | number | null;
  public nestedArtboardPath: string | null;

  constructor(
    stateMachineName: string,
    name: string,
    value: boolean | number | null = null,
    nestedArtboardPath: string | null = null
  ) {
    this.stateMachineName = stateMachineName;
    this.name = name;
    this.value = value;
    this.nestedArtboardPath = nestedArtboardPath;
  }
}

class RiveXComponentController extends XComponentController {
  private onSurfaceCreatedCallback?: (surfaceId: string) => void;
  private onSurfaceChangedCallback?: (surfaceId: string, rect: SurfaceRect) => void;
  private onSurfaceDestroyedCallback?: (surfaceId: string) => void;

  onSurfaceCreated(surfaceId: string): void {
    console.info(`${TAG}: onSurfaceCreated surfaceId: ${surfaceId}`);
    this.onSurfaceCreatedCallback?.(surfaceId);
  }

  onSurfaceChanged(surfaceId: string, rect: SurfaceRect): void {
    console.info(`${TAG}: onSurfaceChanged surfaceId: ${surfaceId}, rect: ${JSON.stringify(rect)}`);
    this.onSurfaceChangedCallback?.(surfaceId, rect);
  }

  onSurfaceDestroyed(surfaceId: string): void {
    console.info(`${TAG}: onSurfaceDestroyed surfaceId: ${surfaceId}`);
    this.onSurfaceDestroyedCallback?.(surfaceId);
  }

  setOnSurfaceCreated(callback: (surfaceId: string) => void): void {
    this.onSurfaceCreatedCallback = callback;
  }

  setOnSurfaceChanged(callback: (surfaceId: string, rect: SurfaceRect) => void): void {
    this.onSurfaceChangedCallback = callback;
  }

  setOnSurfaceDestroyed(callback: (surfaceId: string) => void): void {
    this.onSurfaceDestroyedCallback = callback;
  }
}

export class RiveAnimationViewBuilder {
  private context: Context;
  public alignment: Alignment | null = null;
  public fit: Fit | null = null;
  public loop: Loop | null = null;
  public rendererType: RendererType | null = null;
  public autoplay: boolean | null = null;
  public autoBind: boolean = false;
  public traceAnimations: boolean | null = null;
  public artboardName: string | null = null;
  public animationName: string | null = null;
  public stateMachineName: string | null = null;
  public assetLoader: FileAssetLoader | null = null;
  public shouldLoadCDNAssets: boolean = shouldLoadCDNAssetsDefault;
  public touchPassThrough: boolean = false;
  public multiTouchEnabled: boolean = false;
  public resource: number | string | Uint8Array | File | null = null;
  public resourceType: ResourceType | null = null;

  constructor(context: Context) {
    this.context = context;
  }

  setAlignment(value: Alignment): RiveAnimationViewBuilder {
    this.alignment = value;
    return this;
  }

  setFit(value: Fit): RiveAnimationViewBuilder {
    this.fit = value;
    return this;
  }

  setLoop(value: Loop): RiveAnimationViewBuilder {
    this.loop = value;
    return this;
  }

  setRendererType(value: RendererType): RiveAnimationViewBuilder {
    this.rendererType = value;
    return this;
  }

  setAutoplay(value: boolean): RiveAnimationViewBuilder {
    this.autoplay = value;
    return this;
  }

  setAutoBind(value: boolean): RiveAnimationViewBuilder {
    this.autoBind = value;
    return this;
  }

  setTraceAnimations(value: boolean): RiveAnimationViewBuilder {
    this.traceAnimations = value;
    return this;
  }

  setArtboardName(value: string): RiveAnimationViewBuilder {
    this.artboardName = value;
    return this;
  }

  setAnimationName(value: string): RiveAnimationViewBuilder {
    this.animationName = value;
    return this;
  }

  setStateMachineName(value: string): RiveAnimationViewBuilder {
    this.stateMachineName = value;
    return this;
  }

  setResource(value: number | string | Uint8Array | File): RiveAnimationViewBuilder {
    this.resourceType = ResourceTypeFactory.makeMaybeResource(value);
    this.resource = value;
    return this;
  }

  setAssetLoader(value: FileAssetLoader): RiveAnimationViewBuilder {
    this.assetLoader = value;
    return this;
  }

  setShouldLoadCDNAssets(value: boolean): RiveAnimationViewBuilder {
    this.shouldLoadCDNAssets = value;
    return this;
  }

  setTouchPassThrough(value: boolean): RiveAnimationViewBuilder {
    this.touchPassThrough = value;
    return this;
  }

  setMultiTouchEnabled(value: boolean): RiveAnimationViewBuilder {
    this.multiTouchEnabled = value;
    return this;
  }

  build(): RiveAnimationView {
    const view = new RiveAnimationView();
    view.applyBuilder(this);
    return view;
  }
}

/**
 * Applies common scene parameters to a RendererAttributes instance.
 * Extracted so unit tests can call it directly without needing a
 * @Component struct instance.
 */
export function applySceneParams(
  attrs: RendererAttributes,
  alignment: Alignment | undefined,
  fit: Fit | undefined,
  loop: Loop | undefined,
  autoplay: boolean,
  autoBind: boolean | undefined,
  artboardName: string | undefined,
  animationName: string | undefined,
  stateMachineName: string | undefined
): void {
  if (alignment !== undefined) {
    attrs.alignmentIndex = alignment.valueOf();
    attrs.alignment = alignment;
  }
  if (fit !== undefined) {
    attrs.fitIndex = fit.valueOf();
    attrs.fit = fit;
  }
  if (loop !== undefined) {
    attrs.loopIndex = loop.valueOf();
    attrs.loop = loop;
  }
  attrs.autoplay = autoplay;
  attrs.autoBind = autoBind ?? false;
  attrs.artboardName = artboardName ?? null;
  attrs.animationName = animationName ?? null;
  attrs.stateMachineName = stateMachineName ?? null;
}

@Component
export struct RiveAnimationView {

  public onReady?: (view: RiveAnimationView) => void;
  public riveResource: string = '';
  public riveUrl: string = '';
  public riveLoop : number = Loop.AUTO;
  public riveFit: string = 'contain';
  public shouldLoadCDNAssets: boolean = shouldLoadCDNAssetsDefault;
  public touchPassThrough: boolean = false;
  public multiTouchEnabled: boolean = false;
  public rendererType: RendererType = RendererType.Rive;
  public alignmentIndex: number = alignmentIndexDefault;
  public riveArtboard: string = '';
  public riveAnimation: string = '';
  public riveStateMachine: string = '';
  public riveAutoPlay: boolean = true;
  public riveAutoBind: boolean = false;
  public riveTraceAnimations: boolean = traceAnimationsDefault;
  public creatRendererFun: () => Promise<Renderer | null> = async (): Promise<Renderer | null> => {
    if (this.controller == null) {
      console.error(`RiveAnimationView creatRenderer controller is null`)
      return null
    }
    return new RiveArtboardRenderer(
      this.getUIContext(),
      this.controller,
      this.rendererAttributes.riveTraceAnimations,
      this.rendererAttributes.rendererType
    )
  }

  private defaultAutoplay: boolean = true;
  private rendererAttributes: RendererAttributes = RendererAttributes.default();
  private context: Context = getContext() as Context;
  public riveAssetLoaderClass: FileAssetLoader | null = new FallbackAssetLoader(this.context, true, null)
  private xComponentController: RiveXComponentController = new RiveXComponentController();
  public controller: RiveFileController | null = null;
  private pointersInsideView: Map<number, boolean> = new Map<number, boolean>();
  private resourceFromValue: ResourceType | null = null;
  private customLoader: FileAssetLoader | null = null;
  private targetBounds: Bounds | null = null;
  private listeners: Set<RiveFileControllerListener> = new Set();
  private eventListeners: Set<RiveEventListener> = new Set();

  private renderer: Renderer | null = null

  build() {
    Stack() {
      XComponent({
        id: 'RiveAnimComponent',
        type: XComponentType.SURFACE,
        controller: this.xComponentController
      })
        .backgroundColor(Color.Transparent)
        .onTouch((event: TouchEvent) => {
          return this.handleTouchEvent(event);
        })
    }
  }

  async aboutToAppear() {
    console.info(`${TAG}: aboutToAppear`);
    await this.init();
    this.setupSurfaceCallbacks();
    if (this.onReady) {
      console.info(`${TAG}: Calling onReady callback`);
      this.onReady(this);
    }
  }

  applyBuilder(builder: RiveAnimationViewBuilder): void {
    this.rendererAttributes = new RendererAttributes(
      builder.alignment ? builder.alignment.valueOf() : alignmentIndexDefault,
      builder.fit ? builder.fit.valueOf() : fitIndexDefault,
      builder.loop ? builder.loop.valueOf() : loopIndexDefault,
      builder.rendererType ? rendererTypeToIndex(builder.rendererType) : rendererTypeToIndex(RendererType.Rive),
      builder.autoplay ?? this.defaultAutoplay,
      builder.autoBind,
      builder.traceAnimations ?? traceAnimationsDefault,
      builder.artboardName,
      builder.animationName,
      builder.stateMachineName,
      builder.resourceType || undefined,
      builder.assetLoader || null
    );

    this.touchPassThrough = builder.touchPassThrough;
    this.multiTouchEnabled = builder.multiTouchEnabled;

    if (builder.resourceType) {
      this.resourceFromValue = builder.resourceType;
    }

    if (builder.assetLoader) {
      this.customLoader = builder.assetLoader;
    } else {
      this.customLoader = new FallbackAssetLoader(
        this.context,
        builder.shouldLoadCDNAssets,
        null
      );
    }

    if (!this.controller) {
      this.controller = new RiveFileController(
        this.rendererAttributes.loop,
        this.rendererAttributes.autoplay
      );
    }
    this.bindExistingListeners();

    if (this.resourceFromValue) {
      this.loadFileFromResource((file: File) => {
        if (this.controller && file) {
          this.controller.setRiveFile(file);
          this.controller.setupScene(this.rendererAttributes);
        }
      });
    }
  }

  async init() {
    console.info(`${TAG}: init`);

    let assetLoader: FileAssetLoader | null = null;
    try {
      if (this.riveResource !== '') {
        this.resourceFromValue = new ResourceId(this.riveResource);
      } else if (this.riveUrl !== '') {
        this.resourceFromValue = new ResourceUrl(this.riveUrl);
      } else {
        this.resourceFromValue = null;
      }

      assetLoader = new FallbackAssetLoader(
        this.context,
        this.shouldLoadCDNAssets,
        this.riveAssetLoaderClass,
      );
      console.info(`${TAG}: FallbackAssetLoader created successfully`);
    } catch (error) {
      console.error(`${TAG}: Error creating FallbackAssetLoader: ${error}`);
      assetLoader = null;
    }

    this.rendererAttributes = new RendererAttributes(
      this.alignmentIndex,
      Fit.fromString(this.riveFit).valueOf(),
      this.riveLoop,
      rendererTypeToIndex(this.rendererType),
      this.riveAutoPlay,
      this.riveAutoBind,
      this.riveTraceAnimations,
      this.riveArtboard || null,
      this.riveAnimation || null,
      this.riveStateMachine || null,
      this.resourceFromValue || undefined,
      assetLoader
    );

    if (!this.controller) {
      this.controller = new RiveFileController(
        this.rendererAttributes.loop,
        this.rendererAttributes.autoplay
      );
    }

    this.bindExistingListeners();

    if (this.resourceFromValue) {
      this.loadFileFromResource((file: File) => {
        console.info(`${TAG}: Loading file from resource`,file ,'controller===',this.controller);
        if (this.controller && file) {
          this.controller.setRiveFile(file);
          this.controller.setupScene(this.rendererAttributes);
          if (this.onReady) {
            console.info(`${TAG}: Calling onReady callback`);
            this.onReady(this);
          }
        }
      });
    }

    try {
      this.renderer = await this.creatRendererFun()
      console.info(`${TAG}: init this.renderer = ${this.renderer}`);
      if (this.renderer) {
        console.info(`${TAG}: init this.renderer != null`);
        this.renderer.make()
        this.renderer.start()
      }
    } catch (error) {
      console.error(`${TAG}: init creatRendererFun error = ${JSON.stringify(error)}`);
    }
  }

  getRenderer(): Renderer | null {
    try {
      if (this.renderer instanceof  RiveArtboardRenderer) {
        return this.renderer as RiveArtboardRenderer
      }else{
        return this.renderer;
      }
    }catch (error) {
      console.error(`${TAG}, Expected RiveArtboardRenderer but got ${
      this.renderer?.constructor?.name ? this.renderer?.constructor?.name : 'NULL'}`)
      return null
    }
  }

  private setupSurfaceCallbacks(): void {
    this.xComponentController.setOnSurfaceCreated((surfaceId: string) => {
      console.info(`${TAG}: Surface created: ${surfaceId}`);
      if (this.controller) {
        this.controller.isActive = true;
      }
      this.updateTargetBounds();
      this.onSurfaceReady();
    });

    this.xComponentController.setOnSurfaceChanged((surfaceId: string, rect: SurfaceRect) => {
      console.info(`${TAG}: Surface changed: ${surfaceId}, offsetX: ${rect.offsetX}, offsetY: ${rect.offsetY}`);
      this.updateTargetBounds(rect);
      if (this.renderer) {
        this.renderer.stop();
        const newSurface = new SharedSurface(surfaceId);
        this.renderer.setSharedSurface(newSurface);
      }
    });

    this.xComponentController.setOnSurfaceDestroyed((surfaceId: string) => {
      console.info(`${TAG}: Surface destroyed: ${surfaceId}`);
      this.targetBounds = null;
      if (this.controller) {
        this.controller.stopAllAnimations();
        this.controller.reset();
        this.controller.isActive = false;
      }
    });
  }

  private updateTargetBounds(rect?: SurfaceRect): void {
    console.info(`${TAG}, updateTargetBounds, rect = ${JSON.stringify(rect)}`)
    if (!this.controller) {
      return;
    }
    const bounds: Bounds = {
      left: rect?.offsetX ?? 0,
      top: rect?.offsetY ?? 0,
      right: (rect?.surfaceWidth ?? 0),
      bottom: (rect?.surfaceHeight ?? 0)
    };
    this.targetBounds = bounds;
    this.controller.targetBounds = bounds;
  }

  private bindExistingListeners(): void {
    if (!this.controller) {
      return;
    }
    this.listeners.forEach(listener => {
      this.controller?.registerListener(listener);
    });
    this.eventListeners.forEach(listener => {
      this.controller?.addEventListener(listener);
    });
  }

  private onSurfaceReady(): void {
    console.info(`${TAG}: Surface ready`);
    if (this.controller && !this.controller.file) {
      this.loadFileFromResource((file: File) => {
        if (this.controller && file) {
          this.controller.setRiveFile(file);
          this.controller.setupScene(this.rendererAttributes);
        }
      });
    }
  }

  private loadFileFromResource(onComplete: (file: File) => void): void {
    const resource = this.rendererAttributes.resource;
    if (resource === null || resource === undefined) {
      console.warn(`${TAG}: loadResource: no resource to load`);
      return;
    }

    try {
      switch (resource.type) {
        case 'resourceRiveFile':
          const riveFileResource = resource as ResourceRiveFile;
          onComplete(riveFileResource.value);
          break;

        case 'resourceUrl':
          const urlResource = resource as ResourceUrl;
          this.loadFromNetwork(urlResource.value, onComplete);
          break;

        case 'resourceBytes':
          const bytesResource = resource as ResourceBytes;
          const arrayBuffer = bytesResource.value
          const fileFromBytes = new File(
            arrayBuffer,
            this.rendererAttributes.rendererType,
            this.rendererAttributes.assetLoader
          );
          onComplete(fileFromBytes);
          fileFromBytes.release();
          break;

        case 'resourceId':
          const idResource = resource as ResourceId;
          this.loadFileFromResourceId(idResource.value.toString(), onComplete);
          break;

        default:
          console.warn(`${TAG}: Unknown resource type: ${resource.type}`);
      }
    } catch (error) {
      console.error(`${TAG}: Error in loadFileFromResource: ${error}`);
    }
  }

  private loadFileFromResourceId(resourceId: string, onComplete: (file: File) => void): void {
    try {
      console.info(`${TAG}: Loading file from resource ID: ${resourceId}`);
      const context = getContext() as Context;
      if (!context) {
        console.error(`${TAG}: Failed to get context`);
        return;
      }

      const fileName = resourceId.replace('@rawfile/', '');
      context.resourceManager.getRawFileContent(fileName, (error: BusinessError, value: Uint8Array) => {
        if (error != null) {
          console.error(`${TAG}: Error loading resource file ${fileName}: ${error}`);
          return;
        }

        try {
          const arrayBuffer = value.buffer.slice(
            value.byteOffset,
            value.byteOffset + value.byteLength
          );
          const file = new File(
            arrayBuffer,
            this.rendererAttributes.rendererType,
            this.rendererAttributes.assetLoader
          );

          if (!file) {
            console.error(`${TAG}: Failed to create RiveFile instance`);
            return;
          }

          console.info(`${TAG}: Successfully loaded file from resource: ${fileName}`);
          onComplete(file);
          file.release();
        } catch (err) {
          console.error(`${TAG}: Error processing loaded file: ${err}`);
        }
      });
    } catch (error) {
      console.error(`${TAG}: Unexpected error in loadFileFromResourceId: ${error}`);
    }
  }

  private loadFromNetwork(url: string, onComplete: (file: File) => void): void {
    console.info(`${TAG}: Loading file from network: ${url}`);
    try {
      const httpRequest = http.createHttp();
      httpRequest.request(url, {
        method: http.RequestMethod.GET,
        connectTimeout: 60000,
        readTimeout: 60000,
        expectDataType: http.HttpDataType.ARRAY_BUFFER
      }).then((response) => {
        if (response.responseCode === 200) {
          console.info(`${TAG}: Network request successful`);
          const arrayBuffer = response.result as ArrayBuffer;
          const file = new File(
            arrayBuffer,
            this.rendererAttributes.rendererType,
            this.rendererAttributes.assetLoader
          );

          if (!file) {
            console.error(`${TAG}: Failed to create RiveFile instance`);
            return;
          }

          onComplete(file);
          file.release();
        } else {
          console.error(`${TAG}: Network request failed with status code: ${response.responseCode}`);
          throw new Error(`Unable to download Rive file ${url}, status code: ${response.responseCode}`);
        }
      }).catch((error: Error) => {
        console.error(`${TAG}: Network request error: ${error}`);
        throw new Error(`Unable to download Rive file ${url}`);
      }).finally(() => {
        httpRequest.destroy();
      });
    } catch (error) {
      console.error(`${TAG}: Error loading file from network: ${error}`);
    }
  }

  pause(): void {
    this.renderer?.stop()
    if (this.controller) {
      this.controller.pauseAllAnimations();
    }
  }

  pauseAnimation(animationName: string, isStateMachine: boolean = false): void {
    if (this.controller) {
      this.controller.pauseAnimations(animationName, isStateMachine);
      console.info(`${TAG}: pause animation: ${animationName}, isStateMachine: ${isStateMachine}`);
    }
  }

  pauseAnimations(animationNames: string[], areStateMachines: boolean = false): void {
    if (this.controller) {
      this.controller.pauseMultipleAnimations(animationNames, areStateMachines);
      console.info(`${TAG}: pause animations: ${animationNames.join(', ')}, areStateMachines: ${areStateMachines}`);
    }
  }

  stop(): void {
    if (this.controller) {
      this.controller.stopAllAnimations();
    }
  }

  stopAnimation(animationName: string, isStateMachine: boolean = false): void {
    if (this.controller) {
      console.info(`${TAG}: stop animation: ${animationName}, isStateMachine: ${isStateMachine}`);
      this.controller.stopAnimations(animationName, isStateMachine);
    }
  }

  stopMultipleAnimations(animationNames: string[], areStateMachines: boolean = false): void {
    if (this.controller) {
      console.info(`${TAG}: stop animations: ${animationNames.join(', ')}, areStateMachines: ${areStateMachines}`);
      this.controller.stopMultipleAnimations(animationNames, areStateMachines);
    }
  }

  play(
    animationName?: string,
    loop: Loop = Loop.AUTO,
    direction: Direction = Direction.AUTO,
    isStateMachine: boolean = false,
    settleInitialState: boolean = true
  ): void {
    console.info(`${TAG}: play animationName: ${animationName}`);
    if (animationName) {
      this.rendererAttributes.animationName = isStateMachine ? null : animationName
      this.rendererAttributes.stateMachineName = isStateMachine ? animationName : null
    }
    this.rendererAttributes.loop = loop

    if (this.controller) {
      if (animationName) {
        this.controller.play(animationName, loop, direction, isStateMachine, settleInitialState);
      } else {
        this.controller.play(loop, direction, settleInitialState);
        console.info(`${TAG}: play first animation with loop ${loop} and direction ${direction}`);
      }
    }
  }

  playAnimations(
    animationNames: string[],
    loop: Loop = Loop.AUTO,
    direction: Direction = Direction.AUTO,
    areStateMachines: boolean = false,
    settleInitialState: boolean = true
  ): void {
    if (this.controller) {
      this.rendererAttributes = new RendererAttributes(
        this.rendererAttributes.alignmentIndex,
        this.rendererAttributes.fitIndex,
        loop.valueOf(),
        this.rendererAttributes.rendererIndex,
        this.rendererAttributes.autoplay,
        this.rendererAttributes.autoBind,
        this.rendererAttributes.riveTraceAnimations,
        this.rendererAttributes.artboardName,
        null,
        null,
        this.rendererAttributes.resource,
        this.rendererAttributes.assetLoader
      );

      this.controller.play(animationNames, loop, direction, areStateMachines, settleInitialState);
      console.info(`${TAG}: play animations: ${animationNames.join(', ')}, areStateMachines: ${areStateMachines}`);
    }
  }

  reset(): void {
    if (this.renderer instanceof RiveArtboardRenderer) {
      this.renderer.reset()
    }
    console.info(`${TAG}: reset`);
  }

  fireState(stateMachineName: string, inputName: string): void {
    if (this.controller) {
      this.controller.fireState(stateMachineName, inputName);
      console.info(`${TAG}: fireState - stateMachine: ${stateMachineName}, input: ${inputName}`);
    }
  }

  setBooleanState(stateMachineName: string, inputName: string, value: boolean): void {
    if (this.controller) {
      this.controller.setBooleanState(stateMachineName, inputName, value);
      console.info(
        `${TAG}: setBooleanState - stateMachine: ${stateMachineName}, input: ${inputName}, value: ${value}`
      );
    }
  }

  setNumberState(stateMachineName: string, inputName: string, value: number): void {
    if (this.controller) {
      this.controller.setNumberState(stateMachineName, inputName, value);
    }
  }

  fireStateAtPath(inputName: string, path: string): void {
    if (this.controller) {
      this.controller.fireStateAtPath(inputName, path);
      console.info(`${TAG}: fireStateAtPath - input: ${inputName}, path: ${path}`);
    }
  }

  setBooleanStateAtPath(inputName: string, value: boolean, path: string): void {
    if (this.controller) {
      this.controller.setBooleanStateAtPath(inputName, value, path);
      console.info(`${TAG}: setBooleanStateAtPath - input: ${inputName}, value: ${value}, path: ${path}`);
    }
  }

  setNumberStateAtPath(inputName: string, value: number, path: string): void {
    if (this.controller) {
      this.controller.setNumberStateAtPath(inputName, value, path);
      console.info(`${TAG}: setNumberStateAtPath - input: ${inputName}, value: ${value}, path: ${path}`);
    }
  }

  setMultipleStates(...inputs: ChangedInput[]): void {
    if (this.controller) {
      this.controller.queueInputs(...inputs);
      console.info(`${TAG}: setMultipleStates - inputs: ${inputs.length}`);
    }
  }

  getTextRunValue(textRunName: string, path?: string): string | null {
    if (this.controller) {
      const value = this.controller.getTextRunValue(textRunName, path);
      console.info(`${TAG}: getTextRunValue - textRunName: ${textRunName}, path: ${path}, value: ${value}`);
      return value;
    }
    return null;
  }

  setTextRunValue(textRunName: string, textValue: string, path?: string): void {
    if (this.controller) {
      this.controller.setTextRunValue(textRunName, textValue, path);
      console.info(`${TAG}: setTextRunValue - textRunName: ${textRunName}, textValue: ${textValue}, path: ${path}`);
    }
  }

  getVolume(): number | null {
    return this.controller?.getVolume() ?? null;
  }

  setVolume(value: number): void {
    if (this.controller) {
      this.controller.setVolume(value);
      console.info(`${TAG}: setVolume - value: ${value}`);
    }
  }

  setRiveResource(
    resId: number | string,
    artboardName?: string,
    animationName?: string,
    stateMachineName?: string,
    autoplay?: boolean,
    autoBind?: boolean,
    fit?: Fit,
    alignment?: Alignment,
    loop?: Loop
  ): void {
    applySceneParams(
      this.rendererAttributes,
      alignment, fit, loop,
      autoplay ?? this.controller?.autoplay ?? this.defaultAutoplay,
      autoBind, artboardName, animationName, stateMachineName
    );
    this.rendererAttributes.resource = ResourceTypeFactory.makeMaybeResource(resId) || undefined;

    this.loadFileFromResource((file: File) => {
      if (this.controller && file) {
        this.controller.setRiveFile(file);
        this.controller.setupScene(this.rendererAttributes);
        if (this.onReady) {
          console.info(`${TAG}: Calling onReady callback`);
          this.onReady(this);
        }
      }
    });
  }

  setRiveBytes(
    bytes: ArrayBuffer,
    artboardName?: string,
    animationName?: string,
    stateMachineName?: string,
    autoplay?: boolean,
    autoBind?: boolean,
    fit?: Fit,
    alignment?: Alignment,
    loop?: Loop
  ): void {
    applySceneParams(
      this.rendererAttributes,
      alignment, fit, loop,
      autoplay ?? this.controller?.autoplay ?? this.defaultAutoplay,
      autoBind, artboardName, animationName, stateMachineName
    );
    this.rendererAttributes.resource = ResourceTypeFactory.makeMaybeResource(bytes) || undefined;

    this.loadFileFromResource((file: File) => {
      if (this.controller && file) {
        this.controller.setRiveFile(file);
        this.controller.setupScene(this.rendererAttributes);
        if (this.onReady) {
          console.info(`${TAG}: Calling onReady callback`);
          this.onReady(this);
        }
      }
    });
  }

  setRiveFile(
    file: File,
    artboardName?: string,
    animationName?: string,
    stateMachineName?: string,
    autoplay?: boolean,
    autoBind?: boolean,
    fit?: Fit,
    alignment?: Alignment,
    loop?: Loop
  ): void {
    if (file.rendererType !== this.rendererAttributes.rendererType) {
      throw new Error(
        `Incompatible Renderer types: file initialized with ${file.rendererType} ` +
          `but View is set up for ${this.rendererAttributes.rendererType}`
      );
    }

    applySceneParams(
      this.rendererAttributes,
      alignment, fit, loop,
      autoplay ?? this.controller?.autoplay ?? this.defaultAutoplay,
      autoBind, artboardName, animationName, stateMachineName
    );
    this.rendererAttributes.resource = ResourceTypeFactory.makeMaybeResource(file) || undefined;

    if (this.controller) {
      this.controller.setRiveFile(file);
      this.controller.setupScene(this.rendererAttributes);
      if (this.onReady) {
        console.info(`${TAG}: Calling onReady callback`);
        this.onReady(this);
      }
    }
  }

  setAssetLoader(assetLoader: FileAssetLoader | null): void {
    if (assetLoader === this.rendererAttributes.assetLoader) {
      return;
    }

    const currentAssetLoader = this.rendererAttributes.assetLoader;
    this.rendererAttributes.assetLoader = assetLoader;

    if (assetLoader) {
      assetLoader.acquire();
    }
    if (currentAssetLoader) {
      currentAssetLoader.release();
    }
  }

  getFile(): File | null {
    return this.controller?.file || null;
  }

  getArtboardName(): string | null {
    return this.controller?.activeArtboard?.name || null;
  }

  setArtboardName(name: string | null) {
    if (this.controller && this.controller.file) {
      try {
        this.controller.selectArtboard(name)
      } catch (error) {
        console.error(`${TAG}: Error setting artboard name: ${error}`);
      }
    }
  }

  getAutoplay(): boolean {
    return this.controller?.autoplay ?? this.defaultAutoplay;
  }

  setAutoplay(value: boolean) {
    if (this.controller) {
      this.controller.autoplay = value;
    }
  }

  getFit(): Fit {
    return this.controller?.fit ?? Fit.CONTAIN;
  }

  setFit(value: Fit) {
    if (this.controller) {
      this.controller.fit = value;
    }
  }

  getAlignment(): Alignment {
    return this.controller?.alignment ?? Alignment.CENTER;
  }

  setAlignment(value: Alignment) {
    if (this.controller) {
      this.controller.alignment = value;
    }
  }

  getLayoutScaleFactor(): number | null {
    return this.controller?.layoutScaleFactor ?? null;
  }

  setLayoutScaleFactor(value: number | null) {
    if (this.controller) {
      this.controller.layoutScaleFactor = value;
      console.info(`${TAG}: set layoutScaleFactor: ${value}`);
    }
  }

  getAnimations(): LinearAnimationInstance[] {
    return this.controller?.animations ?? [];
  }

  getStateMachines(): StateMachineInstance[] {
    return this.controller?.stateMachines ?? [];
  }

  getPlayingAnimations(): Set<LinearAnimationInstance> {
    return this.controller?.playingAnimations ?? new Set();
  }

  getPlayingStateMachines(): Set<StateMachineInstance> {
    return this.controller?.playingStateMachines ?? new Set();
  }

  isPlaying(): boolean {
    return this.renderer?.isPlaying ?? false
  }

  private handleTouchEvent(event: TouchEvent): boolean {
    const returnVal = !this.touchPassThrough;

    try {
      switch (event.type) {
        case TouchType.Down:
          {
            const firstPointer = event.touches[0];
            const firstId = this.multiTouchEnabled ? firstPointer.id : SINGLE_TOUCH_ID;
            const firstInfo: PointerInfo = { id: firstId, x: firstPointer.x, y: firstPointer.y };
            this.pointersInsideView.set(firstId, this.inBounds(firstInfo.x, firstInfo.y));
            this.sendPointerEvent(PointerEvents.POINTER_DOWN, firstInfo.id, firstInfo.x, firstInfo.y);
          }
          break;

        case TouchType.Move:
          {
            const upperBound = this.multiTouchEnabled ? event.touches.length : 1;
            for (let i = 0; i < upperBound && i < event.touches.length; i++) {
              const pointer = event.touches[i];
              const id = this.multiTouchEnabled ? pointer.id : SINGLE_TOUCH_ID;
              const info: PointerInfo = { id: id, x: pointer.x, y: pointer.y };
              const wasInside = this.pointersInsideView.get(id) || false;
              const nowInside = this.inBounds(info.x, info.y);
              if (wasInside && !nowInside) {
                this.sendPointerEvent(PointerEvents.POINTER_EXIT, info.id, info.x, info.y);
              }
              this.pointersInsideView.set(id, nowInside);
              this.sendPointerEvent(PointerEvents.POINTER_MOVE, info.id, info.x, info.y);
            }
          }
          break;

        case TouchType.Up:
          {
            const upPointer = event.changedTouches[0];
            const upId = this.multiTouchEnabled ? upPointer.id : SINGLE_TOUCH_ID;
            const upInfo: PointerInfo = { id: upId, x: upPointer.x, y: upPointer.y };
            this.sendPointerEvent(PointerEvents.POINTER_UP, upId, upInfo.x, upInfo.y);
            this.sendPointerEvent(PointerEvents.POINTER_EXIT, upId, upInfo.x, upInfo.y);
            if (event.touches.length === 0) {
              this.pointersInsideView.clear();
            } else {
              this.pointersInsideView.delete(upId);
            }
          }
          break;

        case TouchType.Cancel:
          {
            const keyIterator = this.pointersInsideView.keys();
            let next = keyIterator.next();
            while (!next.done) {
              const id = next.value;
              this.sendPointerEvent(PointerEvents.POINTER_UP, id, -1, -1);
              this.sendPointerEvent(PointerEvents.POINTER_EXIT, id, -1, -1);
              next = keyIterator.next();
            }
            this.pointersInsideView.clear();
          }
          break;

        default:
          console.warn(`${TAG}: Unhandled touch event type: ${event.type}`);
          break;
      }
    } catch (error) {
      console.error(`${TAG}: Error handling touch event: ${error}`);
    }

    return returnVal;
  }

  private inBounds(x: number, y: number): boolean {
    try {
      const bounds = this.targetBounds ?? this.controller?.targetBounds;
      if (!bounds) {
        return x >= 0 && y >= 0;
      }
      return (
        x >= bounds.left &&
          y >= bounds.top &&
          x <= bounds.right &&
          y <= bounds.bottom
      );
    } catch (error) {
      console.error(`${TAG}: Error in inBounds calculation: ${error}`);
      return false;
    }
  }

  private sendPointerEvent(type: PointerEvents, id: number, x: number, y: number): void {
    if (!this.controller) {
      return;
    }

    try {
      const bounds = this.targetBounds ?? this.controller.targetBounds;
      const offsetX = bounds ? bounds.left : 0;
      const offsetY = bounds ? bounds.top : 0;
      const locallx = x - offsetX;
      const locally = y - offsetY;
      console.error(`${TAG}: sendPointerEvent:  locallx = ${locallx}  locally = ${locally}`);
      this.controller.pointerEvent(type, id, locallx, locally);
    } catch (error) {
      console.error(`${TAG}: Error sending pointer event: ${error}`);
    }
  }

  registerListener(listener: RiveFileControllerListener): void {
    this.listeners.add(listener);
    this.controller?.registerListener(listener);
  }

  unregisterListener(listener: RiveFileControllerListener): void {
    this.listeners.delete(listener);
    this.controller?.unregisterListener(listener);
  }

  addEventListener(listener: RiveEventListener): void {
    this.eventListeners.add(listener);
    this.controller?.addEventListener(listener);
  }

  removeEventListener(listener: RiveEventListener): void {
    this.eventListeners.delete(listener);
    this.controller?.removeEventListener(listener);
  }

  aboutToDisappear() {
    console.info(`${TAG}: aboutToDisappear`);
    this.pointersInsideView.clear();
    this.listeners.clear();
    this.eventListeners.clear();

    if (this.controller) {
      this.controller.isActive = false;
      console.info(`${TAG}: Disposing controller`);
      this.controller.stopAllAnimations();
      this.controller.reset();
      this.controller = null;
    }

    if (this.renderer) {
      this.renderer.delete()
      this.renderer = null
    }
  }

  onPageShow(): void {
    this.renderer?.start()
  }

  onPageHide(): void {
    this.renderer?.stop()
  }
}
