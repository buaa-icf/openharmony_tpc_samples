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

import rive from 'libohos_rive.so';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { AdvanceResult } from '../runtime/core/AdvanceResult';
import { RiveEventReport } from '../runtime/core/RiveEventReport';
import { Loop } from '../runtime/core/Loop';
import { AudioAsset, FontAsset, ImageAsset } from '../runtime/core/FileAsset';
import { PropertyData, PropertyDataUtils } from '../runtime/core/ViewModel';
import { FontFallbackStrategy } from '../runtime/fonts/FontFallbackStrategy';
import { FontHelper } from '../runtime/fonts/FontHelpers';
import { ImageDecoder } from '../runtime/core/ImageDecoder';

const DOMAIN = 0x0000;
const TAG = 'RiveInitializer';
let isInitialized = false;

export function initializeRive(): void {
  if (isInitialized) {
    hilog.info(DOMAIN, TAG, 'Rive already initialized, skipping');
    return;
  }
  try {
    hilog.info(DOMAIN, TAG, 'Initializing Rive library');
    rive.Napi_Rive_cppInitialize();
    rive.Napi_Rive_cppRegisterClass(AdvanceResult, 'AdvanceResult');
    rive.Napi_Rive_cppRegisterClass(RiveEventReport, 'RiveEventReport');
    rive.Napi_Rive_cppRegisterClass(ImageAsset);
    rive.Napi_Rive_cppRegisterClass(ImageDecoder);
    rive.Napi_Rive_cppRegisterClass(FontAsset);
    rive.Napi_Rive_cppRegisterClass(AudioAsset);
    rive.Napi_Rive_cppRegisterClass(PropertyData);
    rive.Napi_Rive_cppRegisterClass(PropertyDataUtils);
    rive.Napi_Rive_cppRegisterClass(Loop, 'Loop');
    rive.Napi_Rive_cppRegisterClass(FontFallbackStrategy)
    rive.Napi_Rive_cppRegisterClass(FontHelper)
    isInitialized = true;
    hilog.info(DOMAIN, TAG, 'Rive library initialized successfully');
  } catch (error) {
    hilog.error(DOMAIN, TAG, `Failed to initialize Rive: ${error}`);
  }
}