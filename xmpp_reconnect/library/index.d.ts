/**
 * Copyright (C) 2024 Huawei Device Co., Ltd.
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 * */

import { EventEmitter } from "@xmpp/events";
import Connection from "@ohos/xmpp_connection";

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
  _timeout:null
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
