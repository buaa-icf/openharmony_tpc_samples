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


import { Alignment } from '../core/Alignment';
import { Fit } from '../core/Fit';
import { Loop, LoopUtils } from '../core/Loop';
import rive from 'libohos_rive.so';
import { RendererType, rendererTypeToIndex, rendererTypeFromIndex } from './RendererType';
import { FallbackAssetLoader, FileAssetLoader } from '../core/FileAssetLoader';
import { File } from '../core/File';

export interface ResourceType {
  type: string;
}

export class ResourceId implements ResourceType {
  public type: string = 'resourceId';
  public value: number | string;

  constructor(id: number | string) {
    this.value = id;
  }
}

export class ResourceUrl implements ResourceType {
  public type: string = 'resourceUrl';
  public value: string;

  constructor(url: string) {
    this.value = url;
  }
}

export class ResourceBytes implements ResourceType {
  public type: string = 'resourceBytes';
  public value: ArrayBuffer;

  constructor(bytes: ArrayBuffer) {
    this.value = bytes;
  }
}

export class ResourceRiveFile implements ResourceType {
  public type: string = 'resourceRiveFile';
  public value: File;

  constructor(file: File) {
    this.value = file;
  }
}

export class ResourceTypeFactory {

  static makeMaybeResource(value: number | string | ArrayBuffer |File): ResourceType | null {
    if (value === null) {
      return null;
    }

    if (typeof value === 'number') {
      return new ResourceId(value);
    } else if (typeof value === 'string') {
      if (value.startsWith('@rawfile/')) {
        return new ResourceId(value);
      } else {
        return new ResourceUrl(value);
      }
    } else if (value instanceof ArrayBuffer) {
      return new ResourceBytes(value);
    } else if (value instanceof File) {
      return new ResourceRiveFile(value);
    } else {
      throw new Error(`Incompatible type ${typeof value}.`);
    }
  }
}

export class RendererAttributes {
  private static TAG: string = 'RendererAttributes';

  public alignmentIndex: number;

  public fitIndex: number;

  public loopIndex: number;

  public autoplay: boolean;

  public autoBind: boolean;

  public riveTraceAnimations: boolean;

  public artboardName: string | null;

  public stateMachineName: string | null;

  public animationName: string | null;

  public rendererIndex: number;

  public assetLoader: FileAssetLoader | null;

  public resource?: ResourceType;

  private _loop: Loop;

  public get loop(): Loop {
    return this._loop
  }

  public set loop(loop: Loop) {
    this._loop = loop
  }

  private _alignment: Alignment;

  public set alignment(value: Alignment) {
    this._alignment = value;
  }

  public get alignment(): Alignment {
    return this._alignment;
  }

  private _fit: Fit;

  public set fit(value: Fit) {
    this._fit = value;
  }

  public get fit(): Fit {
    return this._fit;
  }

  private _rendererType: RendererType;

  public set rendererType(value: RendererType) {
    this._rendererType = value;
  }

  public get rendererType(): RendererType {
    return this._rendererType;
  }

  constructor(
    alignmentIndex: number = Alignment.CENTER,
    fitIndex: number = Fit.CONTAIN,
    loopIndex: number = Loop.AUTO,
    rendererIndex: number = rendererTypeToIndex( RendererType.Rive),
    autoplay: boolean = true,
    autoBind: boolean = false,
    riveTraceAnimations: boolean = false,
    artboardName: string | null = null,
    animationName: string | null = null,
    stateMachineName: string | null = null,
    resource?: ResourceType,
    assetLoader?: FileAssetLoader | null
  ) {
    this.alignmentIndex = alignmentIndex;
    this.fitIndex = fitIndex;
    this.loopIndex = loopIndex;
    this.autoplay = autoplay;
    this.autoBind = autoBind;
    this.riveTraceAnimations = riveTraceAnimations
    this.artboardName = artboardName;
    this.stateMachineName = stateMachineName;
    this.animationName = animationName;
    this.rendererIndex = rendererIndex;
    this.resource = resource;
    this.assetLoader = assetLoader || null;
    this._alignment = Alignment.fromIndex(alignmentIndex)
    this._fit = Fit.fromIndex(fitIndex)
    this._loop = LoopUtils.fromIndex(this.loopIndex);
    this._rendererType = RendererType.fromIndex(rendererIndex)
  }

  public static default(): RendererAttributes {
    return new RendererAttributes();
  }
}