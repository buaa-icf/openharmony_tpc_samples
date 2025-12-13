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

export enum RendererType {
  None = -1,
  Rive = 0,
  Canvas = 1
}

const RENDERER_TYPE_ENTRIES: RendererType[] = [RendererType.Rive, RendererType.Canvas];

export namespace RendererType {
  export function fromIndex(index: number): RendererType {
    const maxIndex = RENDERER_TYPE_ENTRIES.length - 1;
    if (index < 0 || index > maxIndex) {

    }
    return RENDERER_TYPE_ENTRIES[index];
  }
}

export function rendererTypeToIndex(rendererType: RendererType): number {
  return rendererType.valueOf();
}

export function rendererTypeFromIndex(index: number): RendererType {
  return RendererType.fromIndex(index);
}

export function rendererTypeFromString(type: string | null): RendererType {
  if (!type) {
    return RendererType.Rive;
  }
  
  switch (type.toUpperCase()) {
    case 'RIVE':
      return RendererType.Rive;
    case 'CANVAS':
      return RendererType.Canvas;
    default:
      return RendererType.Rive;
  }
}