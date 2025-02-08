/**
 *
 * Copyright (c) 2024 Huawei Device Co., Ltd.
 *
 * All rights reserved.
 * Redistribution and use in source and binary forms, with or without modification,
 * are permitted provided that the following conditions are met:
 *
 * Redistributions of source code must retain the above copyright notice,this
 * list of conditions and the following disclaimer.
 *
 * Redistributions in binary form must reproduce the above copyright notice,
 * this list of conditions and the following disclaimer in the documentation
 * and/or other materials provided with the distribution.
 *
 * THIS IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS 'AS IS' AND ANY EXPRESS OR IMPLIED WARRANTIES,
 * INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 * ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
 * INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
 * PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS;
 * OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
 * STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS,
 *
 * EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

import type { Parser,DomHandler } from "@ohos/htmlparser2";

interface Event {
    $event: string;
    data: unknown[];
    startIndex: number;
    endIndex: number;
}

/**
 * Creates a handler that calls the supplied callback with simplified events on
 * completion.
 *
 * @internal
 * @param callback Function to call with all events.
 */
export function getEventCollector(
    callback: (error: Error | null, data?: ESObject) => void,
): Partial<DomHandler> {
    const events: Event[] = [];
    let parser: Parser;

    function handle(event: string, data: unknown[]): void {
        switch (event) {
            case "onerror": {
                callback(data[0] as Error);
                break;
            }
            case "onend": {
                callback(null, {
                    $event: event.slice(2),
                    startIndex: parser.startIndex,
                    endIndex: parser.endIndex,
                    data,
                });
                break;
            }
            case "onreset": {
                events.length = 0;
                break;
            }
            case "onparserinit": {
                parser = data[0] as Parser;
                break;
            }

            case "onopentag": {
                callback(null, {
                    $event: event.slice(2),
                    startIndex: parser.startIndex,
                    endIndex: parser.endIndex,
                    data,
                });
                break;
            }

            case "ontext": {
                callback(null, {
                    $event: event.slice(2),
                    startIndex: parser.startIndex,
                    endIndex: parser.endIndex,
                    data: data[0],
                })
                break;
            }

            case "onclosetag": {
                if (data[0] === "script") {
                    console.info("htmlparser2--That's it?!");
                }
                break;
            }
            default: {
                const last = events[events.length - 1];
                if (event === "ontext" && last && last.$event === "text") {
                    (last.data[0] as string) += data[0];
                    last.endIndex = parser.endIndex;
                    break;
                }

                if (event === "onattribute" && data[2] === undefined) {
                    data.pop();
                }

                if (!(parser.startIndex <= parser.endIndex)) {
                    throw new Error(
                        `Invalid start/end index ${parser.startIndex} > ${parser.endIndex}`,
                    );
                }

                events.push({
                    $event: event.slice(2),
                    startIndex: parser.startIndex,
                    endIndex: parser.endIndex,
                    data,
                });
                parser.endIndex;
            }
        }
    }

    return new Proxy(
        {},
        {
            get:
            (_, event: string) =>
            (...data: unknown[]) =>
            handle(event, data),
        },
    );
}
