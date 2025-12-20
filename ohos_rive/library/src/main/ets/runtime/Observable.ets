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
 * Observable interface for registering and unregistering listeners
 */
export interface Observable<ListenerType> {
  /**
   * Registers a listener to receive notifications
   * @param listener The listener to register
   */
  registerListener(listener: ListenerType): void;
  
  /**
   * Unregisters a previously registered listener
   * @param listener The listener to unregister
   */
  unregisterListener(listener: ListenerType): void;
}