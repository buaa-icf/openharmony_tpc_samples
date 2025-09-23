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

import { HttpClient } from "./HttpClient";
import { MessageHeaders } from "./IHubProtocol";
import { ILogger, LogLevel } from "./ILogger";
import { ITransport, TransferFormat } from "./ITransport";
import { Arg, getDataDetail, getUserAgentHeader, Platform, sendMessage } from "./Utils";
import { IHttpConnectionOptions } from "./IHttpConnectionOptions";
import { RobustEventSource } from './RobustEventSource';

/** @private */
export class ServerSentEventsTransport implements ITransport {
    private readonly _httpClient: HttpClient;
    private readonly _accessToken: string | undefined;
    private readonly _logger: ILogger;
    private readonly _options: IHttpConnectionOptions;
    private _eventSource?: RobustEventSource;
    private _url?: string;

    public onreceive: ((data: string | ArrayBuffer) => void) | null;
    public onclose: ((error?: Error | unknown) => void) | null;

    constructor(httpClient: HttpClient, accessToken: string | undefined, logger: ILogger,
        options: IHttpConnectionOptions) {
        this._httpClient = httpClient;
        this._accessToken = accessToken;
        this._logger = logger;
        this._options = options;

        this.onreceive = null;
        this.onclose = null;
    }

    public async connect(url: string, transferFormat: TransferFormat): Promise<void> {
        Arg.isRequired(url, "url");
        Arg.isRequired(transferFormat, "transferFormat");
        Arg.isIn(transferFormat, TransferFormat, "transferFormat");

        this._logger.log(LogLevel.Trace, "(SSE transport) Connecting.");

        // set url before accessTokenFactory because this._url is only for send and we set the auth header instead of the query string for send
        this._url = url;

        if (this._accessToken) {
            url += (url.indexOf("?") < 0 ? "?" : "&") + `access_token=${encodeURIComponent(this._accessToken)}`;
        }

        return new Promise<void>((resolve, reject) => {
            let opened = false;
            if (transferFormat !== TransferFormat.Text) {
                reject(new Error("The Server-Sent Events transport only supports the 'Text' transfer format"));
                return;
            }

            try {
                this._eventSource = new RobustEventSource(url, {
                    headers: {
                        'Accept': 'text/event-stream',
                        'Cache-Control': 'no-cache',
                        'Connection': 'keep-alive'
                    }
                });

                // 连接打开事件
                this._eventSource.onopen = () => {
                    this._logger.log(LogLevel.Information, "SSE connection opened");

                    if (!opened) {
                        opened = true;
                        resolve();
                    }
                };

                // 消息接收事件
                this._eventSource.onmessage = (e: any) => {
                    this._logger.log(LogLevel.Trace, `(SSE transport) data received. ${getDataDetail(e.data, this._options.logMessageContent!)}.`);

                    if (this.onreceive) {
                        try {
                            this.onreceive(e.data);
                        } catch (error) {
                            this._logger.log(LogLevel.Error, `onreceive error: ${error}`);
                            this._close(error);
                        }
                    }
                };

                // 错误处理事件
                this._eventSource.onerror = (error?: Error) => {
                    this._logger.log(LogLevel.Error, `SSE connection error: ${error?.message || 'Unknown error'}`);

                    if (!opened) {
                        reject(error || new Error("EventSource failed to connect"));
                    } else {
                        this._close(error);
                    }
                };

            } catch (e) {
                reject(e);
                return;
            }
        });
    }

    public async send(data: any): Promise<void> {
        if (!this._eventSource) {
            return Promise.reject(new Error("Cannot send until the transport is connected"));
        }
        return sendMessage(this._logger, "SSE", this._httpClient, this._url!, data, this._options);
    }

    public stop(): Promise<void> {
        this._close();
        return Promise.resolve();
    }

    private _close(e?: Error | unknown) {
        if (this._eventSource) {
            this._eventSource.close();
            this._eventSource = undefined;

            if (this.onclose) {
                this.onclose(e);
            }
        }
    }
}