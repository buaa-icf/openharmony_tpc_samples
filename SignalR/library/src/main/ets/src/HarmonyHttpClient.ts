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

import { http } from '@kit.NetworkKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { AbortError, HttpError, TimeoutError } from "./Errors";
import { HttpClient, HttpRequest, HttpResponse } from "./HttpClient";
import { ILogger, LogLevel } from "./ILogger";
import { MessageHeaders } from "./IHubProtocol";

/** HarmonyOS implementation of {@link @microsoft/signalr.HttpClient}. */
export class HarmonyHttpClient extends HttpClient {
    private readonly _logger: ILogger;

    public constructor(logger: ILogger) {
        super();
        this._logger = logger;
    }

    /** @inheritDoc */
    public async send(request: HttpRequest): Promise<HttpResponse> {
        // 检查是否已取消
        if (request.abortSignal && request.abortSignal.aborted) {
            throw new AbortError();
        }

        if (!request.method) {
            throw new Error("No method defined.");
        }
        if (!request.url) {
            throw new Error("No url defined.");
        }

        // 创建HTTP请求对象
        const httpRequest = http.createHttp();
        
        try {
            // 转换请求方法
            const method = this._convertRequestMethod(request.method);
            
            // 构建请求选项
            const options: http.HttpRequestOptions = {
                method: method,
                header: this._convertHeaders(request.headers),
                expectDataType: http.HttpDataType.STRING,
                connectTimeout: 10000, // 10秒连接超时
                readTimeout: request.timeout || 30000, // 30秒读取超时
                usingCache: false, // SignalR需要禁用缓存
                priority: 1
            };

            // 只有当有内容时才添加extraData
            if (request.content) {
                options.extraData = request.content;
            }

            // 处理响应类型
            if (request.responseType === "arraybuffer") {
                options.expectDataType = http.HttpDataType.ARRAY_BUFFER;
            }

            this._logger.log(LogLevel.Trace, `(HarmonyHttpClient transport) sending [${request.method}] request to ${request.url}.`);

            // 验证URL格式
            if (!request.url.startsWith('http://') && !request.url.startsWith('https://')) {
                throw new Error(`Invalid URL format: ${request.url}`);
            }

            // 设置取消监听
            let abortHandler: (() => void) | undefined;
            if (request.abortSignal) {
                abortHandler = () => {
                    this._logger.log(LogLevel.Trace, "(HarmonyHttpClient transport) Request aborted.");
                    httpRequest.destroy();
                };
                // 使用onabort属性而不是addEventListener
                request.abortSignal.onabort = abortHandler;
            }

            // 发起请求
            const response = await new Promise<http.HttpResponse>((resolve, reject) => {
                httpRequest.request(request.url!, options, (err: BusinessError, data: http.HttpResponse) => {
                    if (!err) {
                        resolve(data);
                    } else {
                        reject(this._convertError(err));
                    }
                });
            });

            // 清理取消监听
            if (request.abortSignal && abortHandler) {
                request.abortSignal.onabort = null;
            }

            this._logger.log(LogLevel.Trace, `(HarmonyHttpClient transport) request to ${request.url} completed with status ${response.responseCode}.`);

            // 转换响应
            return this._convertResponse(response);

        } catch (error) {
            this._logger.log(LogLevel.Error, `(HarmonyHttpClient transport) error: ${error}`);
            throw error;
        } finally {
            httpRequest.destroy();
        }
    }

    /** @inheritDoc */
    public getCookieString(url: string): string {
        // HarmonyOS HTTP模块会自动处理cookies
        // 这里返回空字符串，因为无法直接获取cookie字符串
        return "";
    }

    private _convertRequestMethod(method: string): http.RequestMethod {
        switch (method.toUpperCase()) {
            case "GET":
                return http.RequestMethod.GET;
            case "POST":
                return http.RequestMethod.POST;
            case "PUT":
                return http.RequestMethod.PUT;
            case "DELETE":
                return http.RequestMethod.DELETE;
            case "HEAD":
                return http.RequestMethod.HEAD;
            case "OPTIONS":
                return http.RequestMethod.OPTIONS;
            case "TRACE":
                return http.RequestMethod.TRACE;
            case "CONNECT":
                return http.RequestMethod.CONNECT;
            default:
                throw new Error(`Unsupported HTTP method: ${method}`);
        }
    }

    private _convertHeaders(headers?: MessageHeaders): Record<string, string> {
        const harmonyHeaders: Record<string, string> = {};
        
        if (headers) {
            for (const key in headers) {
                if (headers.hasOwnProperty(key)) {
                    harmonyHeaders[key] = headers[key];
                }
            }
        }

        return harmonyHeaders;
    }

    private _convertResponse(harmonyResponse: http.HttpResponse): HttpResponse {
        const statusCode = harmonyResponse.responseCode;
        const statusText = this._getStatusText(statusCode);
        
        // 处理响应内容
        let content: string | ArrayBuffer;
        if (harmonyResponse.result instanceof ArrayBuffer) {
            content = harmonyResponse.result;
        } else if (typeof harmonyResponse.result === 'string') {
            content = harmonyResponse.result;
        } else {
            // 其他类型转换为字符串
            content = JSON.stringify(harmonyResponse.result);
        }

        return new HttpResponse(statusCode, statusText, content);
    }

    private _convertError(error: BusinessError): Error {
        const message = `HTTP request failed: ${error.message} (Code: ${error.code})`;
        
        // 根据错误码判断错误类型
        if (error.code === 2300001) { // 连接超时
            return new TimeoutError(message);
        } else if (error.code >= 2300002 && error.code <= 2300099) { // 网络相关错误
            return new HttpError(message, 0);
        } else {
            return new Error(message);
        }
    }

    private _getStatusText(statusCode: number): string {
        const statusTexts: { [key: number]: string } = {
            200: "OK",
            201: "Created",
            202: "Accepted",
            204: "No Content",
            400: "Bad Request",
            401: "Unauthorized",
            403: "Forbidden",
            404: "Not Found",
            405: "Method Not Allowed",
            500: "Internal Server Error",
            501: "Not Implemented",
            502: "Bad Gateway",
            503: "Service Unavailable",
            504: "Gateway Timeout"
        };

        return statusTexts[statusCode] || "Unknown";
    }
}