/*
# Copyright (c) 2025 Huawei Device Co., Ltd.
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
*/

#include "dialog_wrapper.h"
#include "libvlc_wrapper.h"
#include "ohos_log.h"
#include <map>

napi_value DialogWrapper::DialogWrapperConstructor(napi_env env, napi_callback_info info)
{
    napi_value arkTSDialog = nullptr;
    napi_get_cb_info(env, info, nullptr, nullptr, &arkTSDialog, nullptr);
    return arkTSDialog;
}

napi_value DialogWrapper::QuestionDialogConstructor(napi_env env, napi_callback_info info)
{
    napi_value arkTSDialog = nullptr;
    napi_get_cb_info(env, info, nullptr, nullptr, &arkTSDialog, nullptr);
    return arkTSDialog;
}

struct DialogCallbackCtx {
    std::string title;
    std::string text;
    libvlc_dialog_question_type type;
    std::string cancel;
    std::string action1;
    std::string action2;
};

void DialogWrapper::InitCallback(napi_env env, napi_value cb)
{
    struct CallbackConfig {
        const char* propertyName;
        const char* resourceName;
        napi_threadsafe_function* targetFn;
        napi_threadsafe_function_call_js callJs;
    };

    napi_threadsafe_function* functions[] = {
        &DialogWrapper::pfDisplayErrorFn_,
        &DialogWrapper::pfDisplayLoginFn_,
        &DialogWrapper::pfDisplayProgressFn_,
        &DialogWrapper::pfCancelFn_,
        &DialogWrapper::pfUpdateProgressFn_,
        &DialogWrapper::pfDisplayQuestionFn_
    };
    
    for (auto fn : functions) {
        if (*fn != nullptr) {
            napi_release_threadsafe_function(*fn, napi_tsfn_abort);
            *fn = nullptr;
        }
    }

    CallbackConfig configs[] = {
        {"onQuestion", "pfQuestionFn", &DialogWrapper::pfDisplayQuestionFn_, DisplayQuestionCompleteWork},
        {"onError", "pfErrorFn", &DialogWrapper::pfDisplayErrorFn_, DisplayErrorCompleteWork},
        {"onLogin", "pfLoginFn", &DialogWrapper::pfDisplayLoginFn_, DisplayLoginCompleteWork},
        {"onProgress", "pfProgressFn", &DialogWrapper::pfDisplayProgressFn_, DisplayProgressCompleteWork},
        {"onCanceled", "pfCancelFn", &DialogWrapper::pfCancelFn_, CancelCompleteWork},
        {"onProgressUpdate", "pfUpdateProgressFn", &DialogWrapper::pfUpdateProgressFn_, UpdateProgressCompleteWork},
    };

    for (const auto& config : configs) {
        napi_value callbackFun = nullptr;
        napi_get_named_property(env, cb, config.propertyName, &callbackFun);
        
        if (callbackFun == nullptr) {
            return;
        }

        napi_value resourceName;
        napi_create_string_utf8(env, config.resourceName, NAPI_AUTO_LENGTH, &resourceName);
        napi_create_threadsafe_function(env, callbackFun, nullptr, resourceName,
            0,
            1,
            nullptr,
            [](napi_env env, void* finalize_data, void* finalize_hint) {},
            nullptr,
            config.callJs,
            config.targetFn);
    }
}

static const libvlc_dialog_cbs dialog_cbs = {
    .pf_display_login = DialogWrapper::DisplayLogin,
    .pf_display_question = DialogWrapper::DisplayQuestion,
    .pf_display_progress = DialogWrapper::DisplayProgress,
    .pf_cancel = DialogWrapper::Cancel,
    .pf_update_progress = DialogWrapper::UpdateProgress,
};

napi_value DialogWrapper::SetCallbacks(napi_env env, napi_callback_info info)
{
    LOGE();
    napi_value arkTSDialog = nullptr;
    size_t argc = 2;
    napi_value args[2] = {nullptr};
    napi_get_cb_info(env, info, &argc, args, &arkTSDialog, nullptr);
    
    LibVLCWrapper *vlc = nullptr;
    napi_status status = napi_unwrap(env, args[0], reinterpret_cast<void **>(&vlc));
    if (status != napi_ok) {
        LOGE("unwrap failed");
        return nullptr;
    }
    
    InitCallback(env, args[1]);

    libvlc_dialog_set_callbacks(vlc->instance_, &dialog_cbs, nullptr);
    LOGE();
    return nullptr;
}

napi_value DialogWrapper::PostAction(napi_env env, napi_callback_info info)
{
    napi_value arkTSDialog = nullptr;
    size_t argc = 1;
    napi_value args[1] = {nullptr};
    napi_get_cb_info(env, info, &argc, args, &arkTSDialog, nullptr);
    libvlc_dialog_id *id = nullptr;
    napi_status status = napi_unwrap(env, arkTSDialog, reinterpret_cast<void **>(&id));
    if (status != napi_ok) {
        LOGE("unwrap DialogWrapper failed!");
        return nullptr;
    }
    LOGE("PostAction dialogId: %p", id);
    int32_t action = 0;
    napi_get_value_int32(env, args[0], &action);
    int ret = libvlc_dialog_post_action(id, action);
    napi_value arkRet = 0;
    napi_create_uint32(env, ret, &arkRet);
    return arkRet;
}

napi_value DialogWrapper::Dismiss(napi_env env, napi_callback_info info)
{
    napi_value arkTSDialog = nullptr;
    napi_get_cb_info(env, info, nullptr, nullptr, &arkTSDialog, nullptr);
    libvlc_dialog_id *id = nullptr;
    napi_status status = napi_unwrap(env, arkTSDialog, reinterpret_cast<void **>(&id));
    if (status != napi_ok) {
        LOGE("unwrap DialogWrapper failed!");
        return nullptr;
    }

    int ret = libvlc_dialog_dismiss(id);
    napi_value arkRet = 0;
    napi_create_uint32(env, ret, &arkRet);
    return arkRet;
}

void DialogWrapper::DisplayQuestion(void *pData, libvlc_dialog_id *pId,
                                    const char *title, const char *text,
                                    libvlc_dialog_question_type type,
                                    const char *cancel, const char *action1,
                                    const char *action2)
{
    auto* data = new QuestionData {
        pId,
        SafeString(title),
        SafeString(text),
        type,
        SafeString(cancel),
        SafeString(action1),
        SafeString(action2),
    };
    napi_call_threadsafe_function(DialogWrapper::pfDisplayQuestionFn_, data, napi_tsfn_blocking);
}

void DialogWrapper::DisplayError(void *pData, const char *title, const char *text)
{
    DialogWrapper* wrapper = static_cast<DialogWrapper*>(pData);
    if (!wrapper || !wrapper->pfDisplayErrorFn_) {
        return;
    }
    auto* data = new ErrorData{
        SafeString(title),
        SafeString(text),
    };

    napi_call_threadsafe_function(wrapper->pfDisplayErrorFn_, data, napi_tsfn_blocking);
}

void DialogWrapper::DisplayLogin(void *pData, libvlc_dialog_id *pId,
                                 const char *title, const char *text,
                                 const char *defaultUsername,
                                 bool askStore)
{
    auto* data = new LoginData{
        pId,
        SafeString(title),
        SafeString(text),
        SafeString(defaultUsername),
        askStore,
    };

    napi_call_threadsafe_function(DialogWrapper::pfDisplayLoginFn_, data, napi_tsfn_blocking);
}

void DialogWrapper::DisplayProgress(void *pData, libvlc_dialog_id *pId,
                                    const char *title, const char *text,
                                    bool indeterminate, float position,
                                    const char *cancel)
{
    DialogWrapper* wrapper = static_cast<DialogWrapper*>(pData);
    if (!wrapper || !wrapper->pfDisplayProgressFn_) {
        return;
    }

    auto* data = new ProgressData{
        pId,
        SafeString(title),
        SafeString(text),
        indeterminate,
        position,
        SafeString(cancel),
    };

    napi_call_threadsafe_function(wrapper->pfDisplayProgressFn_, data, napi_tsfn_blocking);
}

void DialogWrapper::Cancel(void *pData, libvlc_dialog_id *pId)
{
    DialogWrapper* wrapper = static_cast<DialogWrapper*>(pData);
    if (!wrapper || !wrapper->pfCancelFn_) {
        return;
    }

    auto* data = new CancelData{
        pId,
    };

    napi_call_threadsafe_function(wrapper->pfCancelFn_, data, napi_tsfn_blocking);
}

void DialogWrapper::UpdateProgress(void *pData, libvlc_dialog_id *pId,
                                   float position, const char *text)
{
    DialogWrapper* wrapper = static_cast<DialogWrapper*>(pData);
    if (!wrapper || !wrapper->pfUpdateProgressFn_) {
        return;
    }

    auto* data = new UpdateProgressData{
        pId,
        position,
        text,
    };

    napi_call_threadsafe_function(wrapper->pfUpdateProgressFn_, data, napi_tsfn_blocking);
}

void DialogWrapper::DisplayErrorCompleteWork(napi_env env, napi_value callback, void* context, void* data)
{
}

void DialogWrapper::DisplayLoginCompleteWork(napi_env env, napi_value callback, void* context, void* data)
{
}

void DialogWrapper::DisplayProgressCompleteWork(napi_env env, napi_value callback, void* context, void* data)
{
}

void DialogWrapper::CancelCompleteWork(napi_env env, napi_value callback, void* context, void* data)
{
}

void DialogWrapper::UpdateProgressCompleteWork(napi_env env, napi_value callback, void* context, void* data)
{
}

void DialogWrapper::DisplayQuestionCompleteWork(napi_env env, napi_value callback, void* context, void* data)
{
    if (!data) {
        return;
    }
    std::unique_ptr<QuestionData> errorData(static_cast<QuestionData*>(data));
    
    napi_value global;
    napi_get_global(env, &global);
    napi_value questionDialogClass = nullptr;
    napi_get_named_property(env, global, "QuestionDialog", &questionDialogClass);
    if (questionDialogClass == nullptr) {
        return;
    }
    napi_value instance;
    napi_new_instance(env, questionDialogClass, 0, nullptr, &instance);
    napi_wrap(env, instance, errorData->dialogId, [](napi_env env, void* data, void* hint) {}, nullptr, nullptr);
    
    napi_value tsData;
    napi_create_string_utf8(env, errorData->title.c_str(), NAPI_AUTO_LENGTH, &tsData);
    napi_set_named_property(env, instance, "title", tsData);
    napi_create_string_utf8(env, errorData->text.c_str(), NAPI_AUTO_LENGTH, &tsData);
    napi_set_named_property(env, instance, "text", tsData);
    napi_create_int32(env, errorData->type, &tsData);
    napi_set_named_property(env, instance, "type", tsData);
    napi_create_string_utf8(env, errorData->cancelText.c_str(), NAPI_AUTO_LENGTH, &tsData);
    napi_set_named_property(env, instance, "cancel", tsData);
    napi_create_string_utf8(env, errorData->action1.c_str(), NAPI_AUTO_LENGTH, &tsData);
    napi_set_named_property(env, instance, "action1", tsData);
    napi_create_string_utf8(env, errorData->action2.c_str(), NAPI_AUTO_LENGTH, &tsData);
    napi_set_named_property(env, instance, "action2", tsData);
    napi_call_function(env, instance, callback, 1, &instance, nullptr);
}

std::string DialogWrapper::SafeString(const char* str)
{
    return str ? std::string(str) : std::string();
}


static void CreateEnum(napi_env env, napi_value exports)
{
    napi_value eventEnum;
    napi_create_object(env, &eventEnum);
    std::map<std::string, libvlc_dialog_question_type> states = {
        {"LIBVLC_DIALOG_QUESTION_NORMAL", LIBVLC_DIALOG_QUESTION_NORMAL},
        {"LIBVLC_DIALOG_QUESTION_WARNING", LIBVLC_DIALOG_QUESTION_WARNING},
        {"LIBVLC_DIALOG_QUESTION_CRITICAL", LIBVLC_DIALOG_QUESTION_CRITICAL},
    };

    for (const auto& [k, v] : states) {
        napi_value num = nullptr;
        napi_create_int32(env, v, &num);
        napi_set_named_property(env, eventEnum, k.c_str(), num);
    }
    napi_set_named_property(env, exports, "libvlc_dialog_question_type", eventEnum);
}

napi_value DialogWrapper::Export(napi_env env, napi_value exports)
{
    napi_value dialog_class;
    napi_property_descriptor dialog_props[] = {
        { "setCallbacks", nullptr, SetCallbacks, nullptr, nullptr, nullptr, napi_static, nullptr }
    };
    
    napi_define_class(env, "Dialog", NAPI_AUTO_LENGTH,
                      [](napi_env env, napi_callback_info info) -> napi_value {
                          napi_value jsthis;
                          napi_get_cb_info(env, info, nullptr, nullptr, &jsthis, nullptr);
                          return jsthis;
                      },
                      nullptr, 1, dialog_props, &dialog_class);
    napi_set_named_property(env, exports, "Dialog", dialog_class);
    
    napi_value global;
    napi_get_global(env, &global);
    napi_property_descriptor questionDialogProp[] = {
        {"postAction", nullptr, DialogWrapper::PostAction, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"dismiss", nullptr, DialogWrapper::Dismiss, nullptr, nullptr, nullptr, napi_default, nullptr},
    };
    napi_value arkTSQuestionDialog = nullptr;
    const char *arkTSQuestionDialogName = "QuestionDialog";
    napi_define_class(env, arkTSQuestionDialogName, NAPI_AUTO_LENGTH, DialogWrapper::QuestionDialogConstructor, nullptr,
                      sizeof(questionDialogProp) / sizeof(questionDialogProp[0]),
                      questionDialogProp, &arkTSQuestionDialog);
    napi_set_named_property(env, global, arkTSQuestionDialogName, arkTSQuestionDialog);

    CreateEnum(env, exports);
    return exports;
}