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

#include "refs.h"
#include "helpers/general.h"
#include "helpers/resource.h"
#include <cstdlib>
#include <napi/native_api.h>
#include <string>

namespace ohos_rive {
constexpr size_t INDEX_ONE = 1;
constexpr size_t INDEX_TWO = 2;
constexpr size_t INDEX_THREE = 3;
constexpr size_t INDEX_FOUR = 4;

napi_value GetClass(napi_env env, const char *name)
{
    if (!name) {
        return nullptr;
    }

    auto result = FindClass(env, name);
    return result.Get();
}

napi_value GetMethodId(napi_env env, napi_value clazz, const char *name)
{
    // 获取构造函数的原型对象
    napi_value prototype;
    napi_status status = napi_get_named_property(env, clazz, "prototype", &prototype);
    if (status != napi_ok) {
        LOGE("Failed to get prototype for method: %{public}s", name);
        return nullptr;
    }

    // 从原型中获取方法
    napi_value method;
    status = napi_get_named_property(env, prototype, name, &method);
    if (status != napi_ok) {
        LOGE("Method not found in prototype: %{public}s", name);
        return nullptr;
    }
    // 验证获取的是函数
    napi_valuetype value_type;
    status = napi_typeof(env, method, &value_type);
    if (status != napi_ok || value_type != napi_function) {
        LOGE("Property %{public}s is not a function, type: %{public}d", name, value_type);
        return nullptr;
    }
    LOGI("Get method OK: %{public}s", name);
    return method;
}

napi_value GetStaticMethodId(napi_env env, napi_value clazz, const char *name)
{
    napi_status status;

    napi_value method;
    status = napi_get_named_property(env, clazz, name, &method);
    if (status != napi_ok) {
        LOGE("Failed to retrieve static method");
        return nullptr;
    }

    // 类型验证
    napi_valuetype valueType;
    status = napi_typeof(env, method, &valueType);
    if (status != napi_ok || valueType != napi_function) {
        LOGE("Static property is not a function");
        return nullptr;
    }
    LOGI("Get static method OK: %{public}s", name);
    return method;
}

napi_value GetStaticFieldId(napi_env env, napi_value clazz, const char *name)
{
    napi_value field;
    napi_status status = napi_get_named_property(env, clazz, name, &field);
    if (status != napi_ok) {
        LOGE("Failed to get static field: %{public}s", name);
        return nullptr;
    }

    return field;
}

napi_value GetFieldId(napi_env env, napi_value clazz, const char *name)
{
    // 获取构造函数的原型对象
    napi_value prototype;
    napi_status status = napi_get_prototype(env, clazz, &prototype);
    if (status != napi_ok) {
        LOGE("Failed to get prototype for field: %{public}s", name);
        return nullptr;
    }

    // 从原型中获取字段
    napi_value field;
    status = napi_get_named_property(env, prototype, name, &field);
    if (status != napi_ok) {
        LOGE("Field not found in prototype: %{public}s", name);
        return nullptr;
    }
    return field;
}

napi_status ThrowRiveException(napi_env env, const char *message)
{
    return napi_throw_error(env, "RIVE_ERROR", message);
}

napi_status ThrowMalformedFileException(napi_env env, const char *message)
{
    return napi_throw_error(env, "MALFORMED_FILE", message);
}

napi_status ThrowUnsupportedRuntimeVersionException(napi_env env, const char *message)
{
    return napi_throw_error(env, "UNSUPPORTED_VERSION", message);
}

napi_value GetLoopClass(napi_env env)
{
    return GetClass(env, "Loop");
}

napi_value GetNoneLoopField(napi_env env)
{
    return GetStaticFieldId(env, GetLoopClass(env), "NONE");
}
napi_value GetOneShotLoopField(napi_env env)
{
    return GetStaticFieldId(env, GetLoopClass(env), "ONESHOT");
}
napi_value GetLoopLoopField(napi_env env)
{
    return GetStaticFieldId(env, GetLoopClass(env), "LOOP");
}
napi_value GetPingPongLoopField(napi_env env)
{
    return GetStaticFieldId(env, GetLoopClass(env), "PINGPONG");
}

napi_value GetAdvanceResultClass(napi_env env)
{
    return GetClass(env, "AdvanceResult");
}

napi_value GetAdvanceResultAdvancedField(napi_env env)
{
    return GetStaticFieldId(env, GetAdvanceResultClass(env), "ADVANCED");
}

napi_value GetAdvanceResultOneShotField(napi_env env)
{
    return GetStaticFieldId(env, GetAdvanceResultClass(env), "ONESHOT");
}

napi_value GetAdvanceResultLoopField(napi_env env)
{
    return GetStaticFieldId(env, GetAdvanceResultClass(env), "LOOP");
}

napi_value GetAdvanceResultPingPongField(napi_env env)
{
    return GetStaticFieldId(env, GetAdvanceResultClass(env), "PINGPONG");
}

napi_value GetAdvanceResultNoneField(napi_env env)
{
    return GetStaticFieldId(env, GetAdvanceResultClass(env), "NONE");
}

napi_value GetRiveEventReportClass(napi_env env)
{
    return GetClass(env, "RiveEventReport");
}

napi_value GetRiveEventReportConstructorId(napi_env env)
{
    return GetMethodId(env, GetRiveEventReportClass(env), "constructor");
}

rive::AABB RectFToAABB(napi_env env, napi_value rectf)
{
    float values[INDEX_FOUR];
    const char *kAABBFieldNames[] = {"left", "top", "right", "bottom"};
    for (int i = 0; i < INDEX_FOUR; ++i) {
        napi_value property;
        napi_get_named_property(env, rectf, kAABBFieldNames[i], &property);

        double value;
        napi_get_value_double(env, property, &value);
        values[i] = static_cast<float>(value);
    }

    return {values[0], values[INDEX_ONE], values[INDEX_TWO], values[INDEX_THREE]};
}

void AABBToRectF(napi_env env, const rive::AABB &aabb, napi_value rectf)
{
    const float values[INDEX_FOUR] = {aabb.left(), aabb.top(), aabb.right(), aabb.bottom()};
    const char *kAABBFieldNames[] = {"left", "top", "right", "bottom"};
    for (int i = 0; i < INDEX_FOUR; ++i) {
        napi_value value;
        napi_create_double(env, values[i], &value);
        napi_set_named_property(env, rectf, kAABBFieldNames[i], value);
    }
}
} // namespace ohos_rive

