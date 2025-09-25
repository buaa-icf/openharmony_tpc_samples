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

import { TransferFormat } from "./ITransport";

/** @private */
export interface IConnection {
    readonly features: any;
    readonly connectionId?: string;

    baseUrl: string;

    start(transferFormat: TransferFormat): Promise<void>;
    send(data: string | ArrayBuffer): Promise<void>;
    stop(error?: Error | unknown): Promise<void>;

    onreceive: ((data: string | ArrayBuffer) => void) | null;
    onclose: ((error?: Error) => void) | null;
}
