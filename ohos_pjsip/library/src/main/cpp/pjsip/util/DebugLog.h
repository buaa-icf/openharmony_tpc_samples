/*
 * Copyright (C) 2021 Huawei Device Co., Ltd.
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

//
// Created on 2022/12/21.
//
// Node APIs are not fully supported. To solve the compilation error of the interface cannot be found,

#ifndef GPU_ImageETS_DebugLog_H
#define GPU_ImageETS_DebugLog_H

#include <hilog/log.h>

#define LOGI(...)((void)OH_LOG_Print(LOG_APP, LOG_INFO, LOG_DOMAIN, "OH_PJSIP_LOG", __VA_ARGS__))
#define LOGD(...)((void)OH_LOG_Print(LOG_APP, LOG_DEBUG, LOG_DOMAIN, "OH_PJSIP_LOG", __VA_ARGS__))
#define LOGW(...)((void)OH_LOG_Print(LOG_APP, LOG_WARN, LOG_DOMAIN, "OH_PJSIP_LOG", __VA_ARGS__))
#define LOGE(...)((void)OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_DOMAIN, "OH_PJSIP_LOG", __VA_ARGS__))

#endif // GPU_ImageETS_DebugLog_H
