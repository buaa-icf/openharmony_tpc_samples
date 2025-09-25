/*
  * Copyright (c) 2025 Huawei Device Co., Ltd.
  *
  * Licensed under the Apache License, Version 2.0 (the "License");
  * you may not use this file except in compliance with the License.
  * You may obtain a copy of the License at
    *
  * http://www.apache.org/licenses/LICENSE-2.0
    *
  * Unless required by applicable law or agreed to in writing, software
  * distributed under the License is distributed on an "AS IS" BASIS,
  * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
  * See the License for the specific language governing permissions and
  * limitations under the License.
  */


import { MediaSource } from "./model/MediaSource";
import { PrintQuality } from "./model/PrintQuality";
import { Sides } from "./model/Sides";
import { ColorSpace } from "./OhColorSpace";


export class OutputSettings {
  public readonly colorSpace: ColorSpace;
  public readonly sides: Sides;
  public readonly source: MediaSource;
  public readonly quality: PrintQuality | null;
  public readonly reversed: boolean = false;
  public readonly copies: number = 1;

  constructor(
    colorSpace: ColorSpace = ColorSpace.Rgb,
    sides: Sides = Sides.oneSided,
    source: MediaSource = MediaSource.auto,
    quality: PrintQuality | null = null,
    reversed: boolean = false,
    copies: number = 1,
  ) {
    this.colorSpace = colorSpace;
    this.sides = sides;
    this.source = source;
    this.quality = quality;
    this.reversed = reversed;
  }

  getColorSpace(): ColorSpace {
    return this.colorSpace
  }

  getQuality(): PrintQuality | null {
    return this.quality
  }

  getSides(): Sides {
    return this.sides
  }

  getSource(): MediaSource {
    return this.source
  }

  getReversed(): boolean {
    return this.reversed
  }
}