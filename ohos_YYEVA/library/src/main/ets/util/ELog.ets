/*
 * Copyright (C) 2025 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import { EvaUtil } from '../EvaUtil'

/**
 * YYEVA 日志接口
 * 定义日志输出功能
 */
export interface IELog {
    /**
     * 信息日志
     */
    i(tag: string, msg: string): void

    /**
     * 调试日志
     */
    d(tag: string, msg: string): void

    /**
     * 错误日志
     */
    e(tag: string, msg: string): void

    /**
     * 错误日志（带异常）
     */
    e(tag: string, msg: string, tr: Error): void
}

/**
 * YYEVA 日志工具类
 * 提供统一的日志输出功能
 */
export class ELog {
    public static isDebug: boolean = false
    public static log: IELog | null = null

    /**
     * 信息日志
     */
    static i(tag: string, msg: string): void {
        if (ELog.log) {
            ELog.log.i(tag, msg)
        } else {
            console.info(`[${tag}] ${msg}`)
        }
    }

    /**
     * 调试日志
     */
    static d(tag: string, msg: string): void {
        if (ELog.isDebug) {
            if (ELog.log) {
                ELog.log.d(tag, msg)
            } else {
                console.debug(`[${tag}] ${msg}`)
            }
        }
    }

    /**
     * 错误日志
     */
    static e(tag: string, msg: string): void {
        if (ELog.log) {
            ELog.log.e(tag, msg)
        } else {
            console.error(`[${tag}] ${msg}`)
        }
    }

    /**
     * 设置Native侧日志
     */
    static setNapiLog() {
        if (ELog.log) {
            EvaUtil.setLog((level: string, tag: string, message: string) => {
                if (level == 'i') {
                    ELog.log!!.i(tag, message)
                } else if (level == 'd') {
                    ELog.log!!.d(tag, message)
                } else if (level == 'e') {
                    ELog.log!!.e(tag, message)
                }
            })
        } else {
            console.error(`Elog setNapiLog error: ELog.log is null or undefind`)
        }
    }
}