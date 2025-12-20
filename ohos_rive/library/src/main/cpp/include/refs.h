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

#ifndef OHOS_RIVE_REFS_H
#define OHOS_RIVE_REFS_H

#include "helpers/resource.h"
#include "rive/math/aabb.hpp"
#include <napi/native_api.h>

namespace ohos_rive {
extern napi_status ThrowRiveException(napi_env env, const char *message);
extern napi_status ThrowMalformedFileException(napi_env env, const char *message);
extern napi_status ThrowUnsupportedRuntimeVersionException(napi_env env, const char *message);
napi_value GetMethodId(napi_env env, napi_value clazz, const char *name);
napi_value GetClass(napi_env env, const char *name);
napi_value GetStaticMethodId(napi_env env, napi_value clazz, const char *name);
napi_value GetStaticFieldId(napi_env env, napi_value clazz, const char *name);
napi_value GetFieldId(napi_env env, napi_value clazz, const char *name);

extern napi_value GetLoopClass(napi_env env);
extern napi_value GetNoneLoopField(napi_env env);
extern napi_value GetOneShotLoopField(napi_env env);
extern napi_value GetLoopLoopField(napi_env env);
extern napi_value GetPingPongLoopField(napi_env env);

extern napi_value GetAdvanceResultClass(napi_env env);
extern napi_value GetAdvanceResultAdvancedField(napi_env env);
extern napi_value GetAdvanceResultOneShotField(napi_env env);
extern napi_value GetAdvanceResultLoopField(napi_env env);
extern napi_value GetAdvanceResultPingPongField(napi_env env);
extern napi_value GetAdvanceResultNoneField(napi_env env);

extern napi_value GetRiveEventReportClass(napi_env env);
extern napi_value GetRiveEventReportConstructorId(napi_env env);

extern rive::AABB RectFToAABB(napi_env env, napi_value rectf);
extern void AABBToRectF(napi_env env, const rive::AABB &aabb, napi_value rectf);

} // namespace ohos_rive
#endif
