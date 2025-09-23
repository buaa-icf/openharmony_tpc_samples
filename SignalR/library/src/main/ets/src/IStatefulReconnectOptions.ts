/**
 * Copyright (C) 2025 Huawei Device Co., Ltd.
 *
 * This software is distributed under a license. The full license
 * agreement can be found in the file LICENSE in this distribution.
 * This software may not be copied, modified, sold or distributed
 * other than expressed in the named license agreement.
 *
 * This software is distributed without any warranty.
 */

// Licensed to the .NET Foundation under one or more agreements.
// The .NET Foundation licenses this file to you under the MIT license.

/** Options provided to the 'withStatefulReconnect' method on {@link @microsoft/signalr.HubConnectionBuilder} to configure options for Stateful Reconnect. */
export interface IStatefulReconnectOptions {
    /** Amount of bytes we'll buffer when using Stateful Reconnect until applying backpressure to sends from the client. */
    bufferSize: number;
}