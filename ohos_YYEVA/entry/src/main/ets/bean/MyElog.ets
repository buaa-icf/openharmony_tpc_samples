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

import { IELog } from '@ohos/yyevac'

export class MyElog implements IELog {
    i(tag: string, msg: string): void {
        console.info('YYEVA_OHOS-' + tag, msg)
    }

    d(tag: string, msg: string): void {
        console.debug('YYEVA_OHOS-' + tag, msg)
    }

    e(tag: string, msg: string): void;
    e(tag: string, msg: string, tr: Error): void;
    e(tag: string, msg: string, tr?: Error): void {
        if (tr) {
            console.error('YYEVA_OHOS-' + tag, msg, tr)
        } else {
            console.error('YYEVA_OHOS-' + tag, msg)
        }
    }
}