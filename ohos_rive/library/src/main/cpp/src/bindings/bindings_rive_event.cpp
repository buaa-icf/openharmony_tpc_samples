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

#include "bindings/bindings_rive_event.h"
#include "helpers/exception_handler.h"
#include "helpers/general.h"
#include "rive/custom_property_boolean.hpp"
#include "rive/custom_property_number.hpp"
#include "rive/custom_property_string.hpp"
#include "rive/open_url_event.hpp"
#include <js_native_api.h>
namespace ohos_rive {
constexpr size_t ARG_NUM_ZERO = 0;
constexpr size_t ARG_NUM_ONE = 1;
constexpr size_t ARG_NUM_TWO = 2;
constexpr size_t ARG_NUM_THREE = 3;

const char *GetTargetValue(rive::OpenUrlEvent *urlEvent)
{
    switch (urlEvent->targetValue()) {
        case ARG_NUM_ZERO:
            return "_blank";
        case ARG_NUM_ONE:
            return "_parent";
        case ARG_NUM_TWO:
            return "_self";
        case ARG_NUM_THREE:
            return "_top";
        default:
            return "_blank";
    }
}

void ChildCoreType(napi_env env, napi_value &propertiesObject, const rive::Component *child, napi_status &status)
{
    switch (child->coreType()) {
        case rive::CustomPropertyBoolean::typeKey: {
            bool propertyValue = child->as<rive::CustomPropertyBoolean>()->propertyValue();
            napi_value value;
            status = napi_get_boolean(env, propertyValue, &value);
            if (status == napi_ok) {
                NapiExceptionHandler::SetProperty(env, propertiesObject, child->name().c_str(), value);
            }
            break;
        }
        case rive::CustomPropertyString::typeKey: {
            std::string propertyValue = child->as<rive::CustomPropertyString>()->propertyValue();
            napi_value value = NapiExceptionHandler::CreateString(env, propertyValue.c_str());
            if (value != nullptr) {
                NapiExceptionHandler::SetProperty(env, propertiesObject, child->name().c_str(), value);
            }
            break;
        }
        case rive::CustomPropertyNumber::typeKey: {
            float propertyValue = child->as<rive::CustomPropertyNumber>()->propertyValue();
            napi_value value;
            status = napi_create_double(env, propertyValue, &value);
            if (status == napi_ok) {
                NapiExceptionHandler::SetProperty(env, propertiesObject, child->name().c_str(), value);
            }
            break;
        }
    }
}

napi_value GetProperties(napi_env env, rive::Event *event)
{
    napi_value propertiesObject;
    napi_status status = napi_create_object(env, &propertiesObject);
    if (status != napi_ok || propertiesObject == nullptr) {
        NapiExceptionHandler::CheckAndRethrow(env);
        return nullptr;
    }
    if (event == nullptr) {
        return propertiesObject;
    }
    for (auto child : event->children()) {
        if (!child->is<rive::CustomProperty>()) {
            continue;
        }
        if (child->name().empty()) {
            continue;
        }
        napi_value key = NapiExceptionHandler::CreateString(env, child->name().c_str());
        if (key == nullptr) {
            continue;
        }
        ChildCoreType(env, propertiesObject, child, status);
    }
    return propertiesObject;
}

napi_value RiveOpenURLEventURL(napi_env env, napi_callback_info info)
{
    size_t argc = 1;
    napi_value args[1];
    napi_value thisArg;
    void *data;

    napi_get_cb_info(env, info, &argc, args, &thisArg, &data);

    if (argc < 1) {
        LOGE("Wrong number of arguments");
        return nullptr;
    }

    uint64_t ref;
    bool lossless = false;
    if (napi_get_value_bigint_uint64(env, args[0], &ref, &lossless) != napi_ok || !lossless) {
        LOGE("Failed to get OpenUrlEvent reference");
        return nullptr;
    }

    auto *event = reinterpret_cast<rive::Event *>(ref);
    if (event->is<rive::OpenUrlEvent>()) {
        auto urlEvent = event->as<rive::OpenUrlEvent>();
        napi_value result;
        napi_create_string_utf8(env, urlEvent->url().c_str(), NAPI_AUTO_LENGTH, &result);
        return result;
    }

    napi_value result;
    napi_create_string_utf8(env, "", NAPI_AUTO_LENGTH, &result);
    return result;
}

napi_value RiveOpenURLEventTarget(napi_env env, napi_callback_info info)
{
    size_t argc = 1;
    napi_value args[1];
    napi_value thisArg;
    void *data;

    napi_get_cb_info(env, info, &argc, args, &thisArg, &data);

    if (argc < 1) {
        LOGE("Wrong number of arguments");
        return nullptr;
    }

    uint64_t ref;
    bool lossless = false;
    if (napi_get_value_bigint_uint64(env, args[0], &ref, &lossless) != napi_ok || !lossless) {
        LOGE("Event pointer get failed.");
        return nullptr;
    }

    auto *event = reinterpret_cast<rive::Event *>(ref);
    if (event->is<rive::OpenUrlEvent>()) {
        auto urlEvent = event->as<rive::OpenUrlEvent>();
        const char *target = GetTargetValue(urlEvent);

        napi_value result;
        napi_create_string_utf8(env, target, NAPI_AUTO_LENGTH, &result);
        return result;
    }

    napi_value result;
    napi_create_string_utf8(env, "_blank", NAPI_AUTO_LENGTH, &result);
    return result;
}

napi_value RiveEventName(napi_env env, napi_callback_info info)
{
    size_t argc = 1;
    napi_value args[1];
    napi_value thisArg;
    void *data;

    napi_get_cb_info(env, info, &argc, args, &thisArg, &data);

    if (argc < 1) {
        LOGE("Wrong number of arguments");
        return nullptr;
    }

    uint64_t ref;
    bool lossless = false;
    if (napi_get_value_bigint_uint64(env, args[0], &ref, &lossless) != napi_ok || !lossless) {
        LOGE("Event pointer get failed.");
        return nullptr;
    }

    auto *event = reinterpret_cast<rive::Event *>(ref);
    if (event == nullptr) {
        LOGE("Event pointer is null");
        napi_value result;
        napi_create_string_utf8(env, "", NAPI_AUTO_LENGTH, &result);
        return result;
    }
    napi_value result;
    napi_create_string_utf8(env, event->name().c_str(), NAPI_AUTO_LENGTH, &result);
    return result;
}

napi_value RiveEventType(napi_env env, napi_callback_info info)
{
    size_t argc = 1;
    napi_value args[1];
    napi_value thisArg;
    void *data;

    napi_get_cb_info(env, info, &argc, args, &thisArg, &data);

    if (argc < 1) {
        LOGE("Wrong number of arguments");
        return nullptr;
    }

    uint64_t ref;
    bool lossless = false;
    if (napi_get_value_bigint_uint64(env, args[0], &ref, &lossless) != napi_ok || !lossless) {
        LOGE("Event pointer get failed.");
        return nullptr;
    }

    auto *event = reinterpret_cast<rive::Event *>(ref);
    napi_value result;
    napi_create_int32(env, static_cast<int32_t>(event->coreType()), &result);
    return result;
}

napi_value RiveEventProperties(napi_env env, napi_callback_info info)
{
    size_t argc = 1;
    napi_value args[1];
    napi_value thisArg;
    void *data;

    napi_get_cb_info(env, info, &argc, args, &thisArg, &data);

    if (argc < 1) {
        LOGE("Wrong number of arguments");
        return nullptr;
    }

    uint64_t ref;
    bool lossless = false;
    if (napi_get_value_bigint_uint64(env, args[0], &ref, &lossless) != napi_ok || !lossless) {
        LOGE("Event pointer get failed.");
        return nullptr;
    }

    auto *event = reinterpret_cast<rive::Event *>(ref);
    return GetProperties(env, event);
}

static void ProcessUrlEvent(napi_env env, rive::Event *event, napi_value &eventObject)
{
    auto urlEvent = event->as<rive::OpenUrlEvent>();

    napi_value typeKey;
    napi_create_string_utf8(env, "type", NAPI_AUTO_LENGTH, &typeKey);
    napi_value typeValue;
    napi_create_int32(env, event->coreType(), &typeValue);
    napi_set_property(env, eventObject, typeKey, typeValue);

    napi_value urlKey;
    napi_create_string_utf8(env, "url", NAPI_AUTO_LENGTH, &urlKey);
    napi_value urlValue;
    napi_create_string_utf8(env, urlEvent->url().c_str(), NAPI_AUTO_LENGTH, &urlValue);
    napi_set_property(env, eventObject, urlKey, urlValue);

    napi_value targetKey;
    napi_create_string_utf8(env, "target", NAPI_AUTO_LENGTH, &targetKey);
    napi_value targetValue;
    const char *target = GetTargetValue(urlEvent);
    napi_create_string_utf8(env, target, NAPI_AUTO_LENGTH, &targetValue);
    napi_set_property(env, eventObject, targetKey, targetValue);
}

napi_value RiveEventData(napi_env env, napi_callback_info info)
{
    size_t argc = 1;
    napi_value args[1];
    napi_value thisArg;
    void *data;

    napi_get_cb_info(env, info, &argc, args, &thisArg, &data);

    if (argc < 1) {
        LOGE("Wrong number of arguments");
        return nullptr;
    }

    uint64_t ref;
    bool lossless = false;
    if (napi_get_value_bigint_uint64(env, args[0], &ref, &lossless) != napi_ok || !lossless) {
        LOGE("Event pointer get failed.");
        return nullptr;
    }

    auto *event = reinterpret_cast<rive::Event *>(ref);

    napi_value eventObject;
    napi_create_object(env, &eventObject);

    if (event == nullptr) {
        return eventObject;
    }

    napi_value nameKey;
    napi_create_string_utf8(env, "name", NAPI_AUTO_LENGTH, &nameKey);
    napi_value nameValue;
    napi_create_string_utf8(env, event->name().c_str(), NAPI_AUTO_LENGTH, &nameValue);
    napi_set_property(env, eventObject, nameKey, nameValue);

    if (event->is<rive::OpenUrlEvent>()) {
        ProcessUrlEvent(env, event, eventObject);
    }

    napi_value propertiesKey;
    napi_create_string_utf8(env, "properties", NAPI_AUTO_LENGTH, &propertiesKey);
    napi_value propertiesValue = GetProperties(env, event);
    napi_set_property(env, eventObject, propertiesKey, propertiesValue);

    return eventObject;
}

} // namespace ohos_rive

