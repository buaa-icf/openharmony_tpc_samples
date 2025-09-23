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

/** An abstraction that controls when the client attempts to reconnect and how many times it does so. */
export interface IRetryPolicy {
    /** Called after the transport loses the connection.
     *
     * @param {RetryContext} retryContext Details related to the retry event to help determine how long to wait for the next retry.
     *
     * @returns {number | null} The amount of time in milliseconds to wait before the next retry. `null` tells the client to stop retrying.
     */
    nextRetryDelayInMilliseconds(retryContext: RetryContext): number | null;
}

export interface RetryContext {
    /**
     * The number of consecutive failed tries so far.
     */
    readonly previousRetryCount: number;

    /**
     * The amount of time in milliseconds spent retrying so far.
     */
    readonly elapsedMilliseconds: number;

    /**
     * The error that forced the upcoming retry.
     */
    readonly retryReason: Error;
}
