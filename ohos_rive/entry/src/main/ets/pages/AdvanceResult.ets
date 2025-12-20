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

/**
 * Represents the outcome of advancing a LinearAnimationInstance.
 */
export enum AdvanceResult {
  /** The animation advanced but did not loop or finish. */
  ADVANCED = 0,
  
  /** The animation reached its end in ONESHOT mode and stopped. */
  ONESHOT = 1,
  
  /** The animation looped back to the beginning in LOOP mode. */
  LOOP = 2,
  
  /** The animation reached an end and reversed direction in PINGPONG mode. */
  PINGPONG = 3,
  
  /** The animation was already finished and did not advance effectively. */
  NONE = 4
}