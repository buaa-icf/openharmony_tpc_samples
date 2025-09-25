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

import { webSocket } from '@kit.NetworkKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { HeaderNames } from "./HeaderNames";
import { HttpClient } from "./HttpClient";
import { MessageHeaders } from "./IHubProtocol";
import { ILogger, LogLevel } from "./ILogger";
import { ITransport, TransferFormat } from "./ITransport";
import { Arg, getDataDetail, getUserAgentHeader } from "./Utils";

/** @private */
export class HarmonyWebSocketTransport implements ITransport {
    private readonly _logger: ILogger;
    private readonly _accessTokenFactory: (() => string | Promise<string>) | undefined;
    private readonly _logMessageContent: boolean;
    private readonly _httpClient: HttpClient;
    private _webSocket?: webSocket.WebSocket;
    private _headers: MessageHeaders;
    private _isConnected: boolean = false;

    public onreceive: ((data: string | ArrayBuffer) => void) | null;
    public onclose: ((error?: Error) => void) | null;

    constructor(httpClient: HttpClient, accessTokenFactory: (() => string | Promise<string>) | undefined, logger: ILogger,
                logMessageContent: boolean, headers: MessageHeaders) {
        this._logger = logger;
        this._accessTokenFactory = accessTokenFactory;
        this._logMessageContent = logMessageContent;
        this._httpClient = httpClient;

        this.onreceive = null;
        this.onclose = null;
        this._headers = headers;
    }

    public async connect(url: string, transferFormat: TransferFormat): Promise<void> {
        Arg.isRequired(url, "url");
        Arg.isRequired(transferFormat, "transferFormat");
        Arg.isIn(transferFormat, TransferFormat, "transferFormat");
        
        this._logger.log(LogLevel.Trace, "(HarmonyWebSocket transport) Connecting.");

        // 获取访问令牌
        let token: string = "";
        if (this._accessTokenFactory) {
            token = await this._accessTokenFactory();
        }

        return new Promise<void>((resolve, reject) => {
            // 转换HTTP URL为WebSocket URL
            url = url.replace(/^http/, "ws");
            
            // 添加访问令牌到URL
            if (token) {
                const separator = url.indexOf("?") === -1 ? "?" : "&";
                url += `${separator}access_token=${encodeURIComponent(token)}`;
            }

            let ws: webSocket.WebSocket | undefined;

            const opened = () => {
                this._logger.log(LogLevel.Information, `HarmonyWebSocket connected to ${url}.`);
                this._webSocket = ws;
                this._isConnected = true;
                resolve();
            };

            const failed = (error: BusinessError) => {
                let errorMessage = "";
                if (error && error.message) {
                    errorMessage = error.message;
                } else {
                    errorMessage = "WebSocket failed to connect. The connection could not be found on the server, " +
                        "either the endpoint may not be a SignalR endpoint, " +
                        "the connection ID is not present on the server, or there is a proxy blocking WebSockets.";
                }

                this._logger.log(LogLevel.Error, `(HarmonyWebSocket transport) ${errorMessage}.`);
                this._isConnected = false;
                reject(new Error(errorMessage));
            };

            const closed = (closeResult: webSocket.CloseResult) => {
                this._logger.log(LogLevel.Trace, "(HarmonyWebSocket transport) socket closed.");
                this._isConnected = false;
                
                if (this.onclose) {
                    if (closeResult.code !== 1000) {
                        this.onclose(new Error(`WebSocket closed with status code: ${closeResult.code} (${closeResult.reason || "no reason given"}).`));
                    } else {
                        this.onclose();
                    }
                }
            };

            const receivedMessage = (err: BusinessError, data: string | ArrayBuffer) => {
                if (err) {
                    this._logger.log(LogLevel.Error, `(HarmonyWebSocket transport) Error receiving message: ${err.message}`);
                    return;
                }
                
                this._logger.log(LogLevel.Trace, `(HarmonyWebSocket transport) data received. ${getDataDetail(data, this._logMessageContent)}.`);
                
                if (this.onreceive) {
                    try {
                        this.onreceive(data);
                    } catch (error) {
                        this._logger.log(LogLevel.Error, `(HarmonyWebSocket transport) Error processing received data: ${error}`);
                        this.onclose?.(error instanceof Error ? error : new Error(String(error)));
                        return;
                    }
                }
            };

            // 创建WebSocket连接 - 修正API调用
            ws = webSocket.createWebSocket();

            // 订阅事件
            ws.on('open', (err: BusinessError, value: Object) => {
                if (!err) {
                    opened();
                } else {
                    failed(err);
                }
            });

            ws.on('message', receivedMessage);

            ws.on('close', (err: BusinessError, value: webSocket.CloseResult) => {
                closed(value);
            });

            ws.on('error', (err: BusinessError) => {
                this._logger.log(LogLevel.Information, `(HarmonyWebSocket transport) ${err.message}.`);
                failed(err);
            });

            this._webSocket = ws;

            // 连接WebSocket
            ws.connect(url, (err: BusinessError, value: boolean) => {
                if (err) {
                    failed(err);
                }
            });
        });
    }

    public async send(data: any): Promise<void> {
        if (!this._webSocket || !this._isConnected) {
            return Promise.reject("WebSocket is not in the OPEN state");
        }

        this._logger.log(LogLevel.Trace, `(HarmonyWebSocket transport) sending data. ${getDataDetail(data, this._logMessageContent)}.`);

        return new Promise<void>((resolve, reject) => {
            this._webSocket!.send(data, (err: BusinessError, value: boolean) => {
                if (!err && value) {
                    resolve();
                } else {
                    const errorMessage = err ? err.message : "Failed to send data";
                    reject(new Error(errorMessage));
                }
            });
        });
    }

    public async stop(): Promise<void> {
        if (this._webSocket) {
            if (this._isConnected) {
                return new Promise<void>((resolve) => {
                    // 添加超时机制，避免永久等待
                    const timeout = setTimeout(() => {
                        this._logger.log(LogLevel.Warning, "(HarmonyWebSocket transport) close timeout, forcing cleanup");
                        this._isConnected = false;
                        
                        // 超时时手动调用 onclose 回调
                        if (this.onclose) {
                            this.onclose(new Error("WebSocket close operation timed out"));
                        }
                        
                        resolve();
                    }, 3000); // 3秒超时

                    // 先设置一个临时的 close 事件监听器来确保能收到关闭通知
                    const tempCloseHandler = (err: BusinessError, value: webSocket.CloseResult) => {
                        clearTimeout(timeout);
                        this._logger.log(LogLevel.Trace, "(HarmonyWebSocket transport) socket closed via event.");
                        this._isConnected = false;
                        
                        // 调用 onclose 回调，与正常 close 事件处理逻辑一致
                        if (this.onclose) {
                            if (value.code !== 1000) {
                                this.onclose(new Error(`WebSocket closed with status code: ${value.code} (${value.reason || "no reason given"}).`));
                            } else {
                                this.onclose(); // 正常关闭，无错误
                            }
                        }
                        
                        resolve();
                    };
                    
                    this._webSocket!.on('close', tempCloseHandler);

                    // 尝试关闭 WebSocket
                    this._webSocket!.close((err: BusinessError, value: boolean) => {
                        // 可能不会被调用，主要依赖上面的事件监听器和超时机制
                        if (!err) {
                            this._logger.log(LogLevel.Trace, "(HarmonyWebSocket transport) close() callback executed successfully.");
                        } else {
                            this._logger.log(LogLevel.Error, `(HarmonyWebSocket transport) error in close() callback: ${err.message}`);
                        }
                    });
                });
            }

            this._webSocket.off('open');
            this._webSocket.off('message');
            this._webSocket.off('close');
            this._webSocket.off('error');

            this._webSocket = undefined;
            this._isConnected = false;
        }

        this._logger.log(LogLevel.Trace, "(HarmonyWebSocket transport) Stop called when webSocket is not present");
    }
}