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

import { Context } from '@ohos.abilityAccessCtrl';
import { BusinessError } from '@ohos.base';
import { preferences } from '@kit.ArkData';
import { ELog } from '../util/ELog';
import { EvaConstant } from '../util/EvaConstant';

const VIDEO_MODE_NORMAL_MP4_NONE = EvaConstant.VIDEO_MODE_NORMAL_MP4_NONE;

export class EvaPref {
    public static TAG: string = `EvaPref`;
    public static sp: preferences.Preferences | null = null;

    static async init(context: Context | undefined): Promise<void> {
        if (!context) {
            ELog.e(EvaPref.TAG, `Init error: context is undefined`);
            return
        }
        if (EvaPref.sp === null) {
            try {
                EvaPref.sp = await preferences.getPreferences(context, EvaPref.TAG);
            } catch (error) {
                ELog.e(EvaPref.TAG, `Init error: ${(error as BusinessError).message}`);
            }
        }
    }

    static async getEvaJson(md5: string | null): Promise<string | null> {
        if (EvaPref.sp === null) {
            ELog.e(EvaPref.TAG, `EvaPref not init`);
            return null;
        }

        if (md5 === null) {
            ELog.e(EvaPref.TAG, `md5 is null`);
            return null;
        }

        try {
            const result: string = await EvaPref.sp.get(`yyeva_json_${md5}`, '') as string;
            return result;
        } catch (error) {
            ELog.e(EvaPref.TAG, `getEvaJson error: ${(error as BusinessError).message}`);
            return null;
        }
    }

    static async setEvaJson(fileName: string, md5: string, json: string): Promise<void> {
        ELog.i(EvaPref.TAG, `setEvaJson fileName: ${fileName}, md5: ${md5}`);
        if (EvaPref.sp) {
            try {
                await EvaPref.sp.put(`yyeva_json_${md5}`, json);
                await EvaPref.sp.flush();
            } catch (error) {
                ELog.e(EvaPref.TAG, `setEvaJson error: ${(error as BusinessError).message}`);
            }
        }
    }

    static async setEvaMp4Type(fileName: string, md5: string, type: number): Promise<void> {
        ELog.i(EvaPref.TAG, `setEvaMp4Type fileName: ${fileName}, md5: ${md5}, type: ${type}`);
        if (EvaPref.sp) {
            try {
                await EvaPref.sp.put(`yyeva_mp4_type_${md5}`, type);
                await EvaPref.sp.flush();
            } catch (error) {
                ELog.e(EvaPref.TAG, `setEvaMp4Type error: ${(error as BusinessError).message}`);
            }
        }
    }

    static async getEvaMp4Type(md5: string | null): Promise<number> {
        if (EvaPref.sp === null) {
            ELog.e(EvaPref.TAG, `EvaPref not init`);
            return VIDEO_MODE_NORMAL_MP4_NONE;
        }

        if (md5 === null) {
            ELog.e(EvaPref.TAG, `md5 is null`);
            return VIDEO_MODE_NORMAL_MP4_NONE;
        }

        try {
            const result: number = await EvaPref.sp.get(`yyeva_mp4_type_${md5}`, VIDEO_MODE_NORMAL_MP4_NONE) as number;
            return result;
        } catch (error) {
            ELog.e(EvaPref.TAG, `getEvaMp4Type error: ${(error as BusinessError).message}`);
            return VIDEO_MODE_NORMAL_MP4_NONE;
        }
    }
}