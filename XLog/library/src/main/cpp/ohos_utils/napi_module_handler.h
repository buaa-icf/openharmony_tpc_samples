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

#ifndef UTILS_NAPI_MODULE_HANDLER_H
#define UTILS_NAPI_MODULE_HANDLER_H
#include "ohos_log.h"
#include <napi/native_api.h>
#include <cinttypes>
#include <vector>

#define DEFINE_DEFAULT_CLASS(className) \
    className(napi_env env, napi_value exports): NapiModuleHandler(env, exports) {}                      \
    ~className() {};

class NapiModuleHandler {
public:
    NapiModuleHandler(napi_env env, napi_value exports);
    void Exports();
    virtual void ExportStub() = 0;
    
    napi_value GetConstructor();
    
    static void AddModule(const std::string &name, NapiModuleHandler *module);
    static NapiModuleHandler *GetModule(const std::string &name);
    static napi_value GetConstructor(const std::string &name);

protected:
    void ExportClass(
        const std::string &name, napi_callback constructor, const std::vector<napi_property_descriptor> &properties);
    void ExportProperties(const std::vector<napi_property_descriptor> &properties);
    void KeepEnv(napi_env env, napi_value exports);

protected:
    napi_env env_ = nullptr;
    napi_value exports_ = nullptr;
    napi_ref constructorRef_ = nullptr;
};
#endif