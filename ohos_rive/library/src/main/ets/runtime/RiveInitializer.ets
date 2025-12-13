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

import { RiveManager } from './core/Rive';
import { RendererType } from './renderers/RendererType';

// 对应 androidx.startup.Initializer
interface Initializer<T> {
  create(context: Context): T;

  dependencies(): Array<() => Initializer<T>>;
}

// Rive 初始化器实现
class RiveInitializer implements Initializer<void> {
  private defaultRendererType: RendererType = RendererType.Rive

  create(context: Context): void {
    RiveManager.getInstance().init(context, this.defaultRendererType);
  }

  dependencies(): Array<() => Initializer<ESObject>> {
    return [];
  }
}