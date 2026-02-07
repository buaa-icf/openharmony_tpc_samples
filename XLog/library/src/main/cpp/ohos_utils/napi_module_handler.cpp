#include "napi_context.h"
#include "napi_module_handler.h"
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
#include "napi_module_handler.h"
#include <string>

static std::unordered_map<std::string, NapiModuleHandler*> g_moduleMap;

void NapiModuleHandler::AddModule(const std::string &name, NapiModuleHandler *module)
{
    g_moduleMap[name] = module;
    module->Exports();
}

NapiModuleHandler *NapiModuleHandler::GetModule(const std::string &name)
{
    if (g_moduleMap.find(name) == g_moduleMap.end()) {
        return nullptr;
    }
    return g_moduleMap[name];
}

napi_value NapiModuleHandler::GetConstructor(const std::string &name)
{
    NapiModuleHandler *formatModule = NapiModuleHandler::GetModule(name);
    if (formatModule == nullptr) {
        LOGE("no %s module", name.c_str());
        return nullptr;
    }
    return formatModule->GetConstructor();
}

NapiModuleHandler::NapiModuleHandler(napi_env env, napi_value exports): env_(env), exports_(exports)
{}

void NapiModuleHandler::Exports()
{
    ExportStub();
}

void NapiModuleHandler::ExportClass(
    const std::string &name, napi_callback constructor, const std::vector<napi_property_descriptor> &properties)
{
    napi_value module = nullptr;
    napi_define_class(
        env_, name.c_str(), name.length(), constructor, nullptr, properties.size(), properties.data(), &module);
    napi_status status = napi_create_reference(env_, module, 1, &constructorRef_);
    if (status != napi_ok) {
        LOGE("Failed to create %s constructor reference", name.c_str());
        return;
    }
    napi_set_named_property(env_, exports_, name.c_str(), module);
}

void NapiModuleHandler::ExportProperties(const std::vector<napi_property_descriptor> &properties)
{
    napi_define_properties(env_, exports_, properties.size(), properties.data());
}

void NapiModuleHandler::KeepEnv(napi_env env, napi_value exports)
{
    env_ = env;
    exports_ = exports;
}

napi_value NapiModuleHandler::GetConstructor()
{
    if (constructorRef_ == nullptr) {
        return nullptr;
    }
    napi_value constructor;
    napi_status status = napi_get_reference_value(env_, constructorRef_, &constructor);
    if (status != napi_ok) {
        LOGE("Failed to get constructor reference");
        return nullptr;
    }
    return constructor;
}
