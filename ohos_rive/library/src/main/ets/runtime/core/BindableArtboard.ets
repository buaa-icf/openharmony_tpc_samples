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

export class BindableArtboard extends NativeObject {

  constructor(unsafeCppPointer: BigInt) {
    super(unsafeCppPointer);
    this.acquire();
  }

  private cppName(pointer: BigInt): string {
    return rive.Napi_BindableArtboard_cppName(pointer);
  }

  cppDelete(pointer: BigInt): void {
    rive.Napi_BindableArtboard_cppDelete(pointer);
  }

  get name(): string {
    return this.cppName(this.cppPointer);
  }
}