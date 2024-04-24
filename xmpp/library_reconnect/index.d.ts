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
import { EventEmitter } from "@xmpp/events";
import Connection from "@xmpp/connection";

export = reconnect;

/**
 * Auto reconnect for `@xmpp/client` and `@xmpp/component`.
 *
 * Included and enabled in `@xmpp/component` and `@xmpp/client`.
 *
 * Supports Node.js and browsers.
 *
 * Each reconnect will re-use the options provided to the entity `start` method.
 */
declare function reconnect<TEntity extends Connection>(params: { entity: TEntity }): reconnect.Reconnect<TEntity>;

declare namespace reconnect {
  type Reconnect<TEntity extends Connection> = ReconnectCls<TEntity> & { constructor: typeof ReconnectCls };

  interface ReconnectEvents {
    reconnecting: () => void;
    reconnected: () => void;
  }
}

declare class ReconnectCls<TEntity extends Connection> extends EventEmitter {
  /**
   * Property to set/get the delay in milliseconds between connection closed and reconnecting.
   *
   * @default 1000
   *
   * @example
   * import rec = require('@xmpp/reconnect');
   *
   * const reconnect = rec({entity: entity});
   *
   * reconnect.delay; // 1000
   * reconnect.delay = 2000;
   */
  delay: number;
  entity: TEntity;

  constructor(entity: TEntity);

  scheduleReconnect(): void;
  reconnect(): Promise<void>;
  start(): void;
  stop(): void;

  addListener<TEvent extends keyof reconnect.ReconnectEvents>(
    event: TEvent,
    listener: reconnect.ReconnectEvents[TEvent],
  ): this;
  addListener(event: string | symbol, listener: (...args: any[]) => void): this;

  on<TEvent extends keyof reconnect.ReconnectEvents>(
    event: TEvent,
    listener: reconnect.ReconnectEvents[TEvent],
  ): this;
  on(event: string | symbol, listener: (...args: any[]) => void): this;

  once<TEvent extends keyof reconnect.ReconnectEvents>(
    event: TEvent,
    listener: reconnect.ReconnectEvents[TEvent],
  ): this;
  once(event: string | symbol, listener: (...args: any[]) => void): this;

  prependListener<TEvent extends keyof reconnect.ReconnectEvents>(
    event: TEvent,
    listener: reconnect.ReconnectEvents[TEvent],
  ): this;
  prependListener(event: string | symbol, listener: (...args: any[]) => void): this;

  prependOnceListener<TEvent extends keyof reconnect.ReconnectEvents>(
    event: TEvent,
    listener: reconnect.ReconnectEvents[TEvent],
  ): this;
  prependOnceListener(event: string | symbol, listener: (...args: any[]) => void): this;

  removeListener<TEvent extends keyof reconnect.ReconnectEvents>(
    event: TEvent,
    listener: reconnect.ReconnectEvents[TEvent],
  ): this;
  removeListener(event: string | symbol, listener: (...args: any[]) => void): this;

  off<TEvent extends keyof reconnect.ReconnectEvents>(
    event: TEvent,
    listener: reconnect.ReconnectEvents[TEvent],
  ): this;
  off(event: string | symbol, listener: (...args: any[]) => void): this;

  emit<TEvent extends keyof reconnect.ReconnectEvents>(
    event: TEvent,
    ...args: Parameters<reconnect.ReconnectEvents[TEvent]>
  ): boolean;
  emit(event: string | symbol, ...args: any[]): boolean;
}
