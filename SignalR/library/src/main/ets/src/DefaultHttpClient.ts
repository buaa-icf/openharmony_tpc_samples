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

import { AbortError } from "./Errors";
import { HarmonyHttpClient } from "./HarmonyHttpClient";
import { HttpClient, HttpRequest, HttpResponse } from "./HttpClient";
import { ILogger } from "./ILogger";

/** Default implementation of {@link @microsoft/signalr.HttpClient} for HarmonyOS. */
export class DefaultHttpClient extends HttpClient {
    private readonly _httpClient: HttpClient;

    /** Creates a new instance of the {@link @microsoft/signalr.DefaultHttpClient}, using the provided {@link @microsoft/signalr.ILogger} to log messages. */
    public constructor(logger: ILogger) {
        super();
        
        // 鸿蒙环境下直接使用HarmonyHttpClient
        this._httpClient = new HarmonyHttpClient(logger);
    }

    /** @inheritDoc */
    public send(request: HttpRequest): Promise<HttpResponse> {
        // Check that abort was not signaled before calling send
        if (request.abortSignal && request.abortSignal.aborted) {
            return Promise.reject(new AbortError());
        }

        if (!request.method) {
            return Promise.reject(new Error("No method defined."));
        }
        if (!request.url) {
            return Promise.reject(new Error("No url defined."));
        }

        return this._httpClient.send(request);
    }

    public getCookieString(url: string): string {
        return this._httpClient.getCookieString(url);
    }
}
