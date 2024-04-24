/**
 * Copyright (C) 2024 Huawei Device Co., Ltd.
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


import * as events from "@ohos/node-polyfill";

export const EventEmitter: typeof events.EventEmitter;

export type EventEmitter = events.EventEmitter;

export class TimeoutError extends Error {
  readonly name: "TimeoutError";
}

export function delay(ms: number): Promise<void> & { timeout: any | number };

export function timeout<TPromise extends PromiseLike<unknown>>(
  promise: TPromise,
  ms: number,
): TPromise extends PromiseLike<infer TValue> ? Promise<TValue> : never;

export function promise(
  emitter: EventEmitter,
  event: string | symbol,
  rejectEvent?: string | symbol | null,
  timeout?: number | null,
): Promise<unknown>;

export class Deferred<TValue> {
  readonly promise: Promise<TValue>;

  resolve(value: TValue | PromiseLike<TValue>): void;

  reject(reason?: any): void;
}