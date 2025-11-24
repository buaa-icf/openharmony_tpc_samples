/**
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

import { YogaNode } from './yogaNode';
import { YogaConfig } from './yogaConfig';
import { YogaValue, YogaConstants, YogaBaselineFunction, YogaMeasureFunction } from './yogaValues';
import { YogaMeasureOutput } from './yogaMeasureOutput';
import {
  YogaDirection,
  YogaEdge,
  YogaFlexDirection,
  YogaJustify,
  YogaAlign,
  YogaPositionType,
  YogaWrap,
  YogaOverflow,
  YogaDisplay,
  YogaBoxSizing,
  YogaGutter,
  YogaUnit,
  YogaMeasureMode,
  YogaErrata,
  YogaExperimentalFeature
} from './yogaEnum';

export namespace Yoga {
  export function createNode(config?: YogaConfig): YogaNode {
    return new YogaNode(config);
  }

  export function createConfig(): YogaConfig {
    return new YogaConfig();
  }
}

export { YogaNode };
export { YogaConfig };

export {
  YogaValue,
  YogaConstants,
  YogaMeasureOutput,
  YogaDirection,
  YogaEdge,
  YogaFlexDirection,
  YogaJustify,
  YogaAlign,
  YogaPositionType,
  YogaWrap,
  YogaOverflow,
  YogaDisplay,
  YogaBoxSizing,
  YogaGutter,
  YogaUnit,
  YogaMeasureMode,
  YogaErrata,
  YogaExperimentalFeature,
  YogaBaselineFunction,
  YogaMeasureFunction
};