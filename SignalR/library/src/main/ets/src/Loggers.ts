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

import { ILogger, LogLevel } from "./ILogger";

/** A logger that does nothing when log messages are sent to it. */
export class NullLogger implements ILogger {
    /** The singleton instance of the {@link @microsoft/signalr.NullLogger}. */
    public static instance: ILogger = new NullLogger();

    private constructor() {}

    /** @inheritDoc */
    // eslint-disable-next-line
    public log(_logLevel: LogLevel, _message: string): void {
    }
}
