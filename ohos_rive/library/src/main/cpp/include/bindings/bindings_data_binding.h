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

#ifndef OHOS_RIVE_BINDINGS_DATA_BINDING_H
#define OHOS_RIVE_BINDINGS_DATA_BINDING_H

#include <napi/native_api.h>

namespace ohos_rive {
#ifdef __cplusplus
extern "C" {
#endif

napi_value ViewModelName(napi_env env, napi_callback_info info);
napi_value ViewModelInstanceCount(napi_env env, napi_callback_info info);
napi_value ViewModelPropertyCount(napi_env env, napi_callback_info info);
napi_value ViewModelGetProperties(napi_env env, napi_callback_info info);
napi_value ViewModelCreateBlankInstance(napi_env env, napi_callback_info info);
napi_value ViewModelCreateDefaultInstance(napi_env env, napi_callback_info info);
napi_value ViewModelCreateInstanceFromIndex(napi_env env, napi_callback_info info);
napi_value ViewModelCreateInstanceFromName(napi_env env, napi_callback_info info);

napi_value ViewModelInstanceName(napi_env env, napi_callback_info info);
napi_value ViewModelInstancePropertyNumber(napi_env env, napi_callback_info info);
napi_value ViewModelInstancePropertyString(napi_env env, napi_callback_info info);
napi_value ViewModelInstancePropertyBoolean(napi_env env, napi_callback_info info);
napi_value ViewModelInstancePropertyColor(napi_env env, napi_callback_info info);
napi_value ViewModelInstancePropertyEnum(napi_env env, napi_callback_info info);
napi_value ViewModelInstancePropertyTrigger(napi_env env, napi_callback_info info);
napi_value ViewModelInstancePropertyImage(napi_env env, napi_callback_info info);
napi_value ViewModelInstancePropertyList(napi_env env, napi_callback_info info);
napi_value ViewModelInstancePropertyArtboard(napi_env env, napi_callback_info info);
napi_value ViewModelInstancePropertyInstance(napi_env env, napi_callback_info info);
napi_value ViewModelInstanceSetInstanceProperty(napi_env env, napi_callback_info info);
napi_value ViewModelInstanceRefInstance(napi_env env, napi_callback_info info);
napi_value ViewModelInstanceDerefInstance(napi_env env, napi_callback_info info);

napi_value ViewModelPropertyName(napi_env env, napi_callback_info info);
napi_value ViewModelPropertyHasChanged(napi_env env, napi_callback_info info);
napi_value ViewModelPropertyFlushChanges(napi_env env, napi_callback_info info);
napi_value ViewModelNumberPropertyGetValue(napi_env env, napi_callback_info info);
napi_value ViewModelNumberPropertySetValue(napi_env env, napi_callback_info info);
napi_value ViewModelStringPropertyGetValue(napi_env env, napi_callback_info info);
napi_value ViewModelStringPropertySetValue(napi_env env, napi_callback_info info);
napi_value ViewModelBooleanPropertyGetValue(napi_env env, napi_callback_info info);
napi_value ViewModelBooleanPropertySetValue(napi_env env, napi_callback_info info);
napi_value ViewModelColorPropertyGetValue(napi_env env, napi_callback_info info);
napi_value ViewModelColorPropertySetValue(napi_env env, napi_callback_info info);
napi_value ViewModelEnumPropertyGetValue(napi_env env, napi_callback_info info);
napi_value ViewModelEnumPropertySetValue(napi_env env, napi_callback_info info);
napi_value ViewModelTriggerPropertyTrigger(napi_env env, napi_callback_info info);
napi_value ViewModelImagePropertySetValue(napi_env env, napi_callback_info info);
napi_value ViewModelListPropertySize(napi_env env, napi_callback_info info);
napi_value ViewModelListPropertyElementAt(napi_env env, napi_callback_info info);
napi_value ViewModelListPropertyAdd(napi_env env, napi_callback_info info);
napi_value ViewModelListPropertyAddAt(napi_env env, napi_callback_info info);
napi_value ViewModelListPropertyRemove(napi_env env, napi_callback_info info);
napi_value ViewModelListPropertyRemoveAt(napi_env env, napi_callback_info info);
napi_value ViewModelListPropertySwap(napi_env env, napi_callback_info info);
napi_value ViewModelArtboardPropertySetArtboard(napi_env env, napi_callback_info info);
napi_value ViewModelArtboardPropertySetBindableArtboard(napi_env env, napi_callback_info info);

#ifdef __cplusplus
}
#endif
} // namespace ohos_rive
#endif // OHOS_RIVE_BINDINGS_ARTBOARD_H
