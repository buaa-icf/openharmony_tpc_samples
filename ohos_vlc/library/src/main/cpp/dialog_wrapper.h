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

#pragma once

#include "vlc/vlc.h"
#include "napi/native_api.h"
#include <string>

class DialogWrapper {
public:
    static napi_value Export(napi_env env, napi_value exports);
    static napi_value DialogWrapperConstructor(napi_env env, napi_callback_info info);
    static napi_value QuestionDialogConstructor(napi_env env, napi_callback_info info);
    static napi_value SetCallbacks(napi_env env, napi_callback_info info);
    static napi_value SetContext(napi_env env, napi_callback_info info);
    static napi_value GetContext(napi_env env, napi_callback_info info);
    static napi_value PostLogin(napi_env env, napi_callback_info info);
    static napi_value PostAction(napi_env env, napi_callback_info info);
    static napi_value Dismiss(napi_env env, napi_callback_info info);
    
    struct ErrorData {
        std::string title;
        std::string text;
    };

    struct LoginData {
        libvlc_dialog_id* dialogId;
        std::string title;
        std::string text;
        std::string defaultUsername;
        bool askStore;
    };

    struct ProgressData {
        libvlc_dialog_id* dialogId;
        std::string title;
        std::string text;
        bool indeterminate;
        float position;
        std::string cancelText;
    };

    struct QuestionData {
        libvlc_dialog_id* dialogId;
        std::string title;
        std::string text;
        libvlc_dialog_question_type type;
        std::string cancelText;
        std::string action1;
        std::string action2;
    };

    struct CancelData {
        libvlc_dialog_id* dialogId;
    };

    struct UpdateProgressData {
        libvlc_dialog_id* dialogId;
        float position;
        std::string text;
    };

    static void InitCallback(napi_env env, napi_value cb);
    static void DisplayError(void *pData, const char *title, const char *text);
    static void DisplayLogin(void *pData, libvlc_dialog_id *pId,
                             const char *title, const char *text,
                             const char *defaultUsername,
                             bool askStore);
    static void DisplayProgress(void *pData, libvlc_dialog_id *pId,
                                const char *title, const char *text,
                                bool indeterminate, float position,
                                const char *cancel);
    static void Cancel(void *pData, libvlc_dialog_id *pId);
    static void UpdateProgress(void *pData, libvlc_dialog_id *pId,
                               float position, const char *text);
    static void DisplayQuestion(void *pData, libvlc_dialog_id *pId,
                                const char *title, const char *text,
                                libvlc_dialog_question_type type,
                                const char *cancel, const char *action1,
                                const char *action2);

    static void DisplayErrorCompleteWork(napi_env env, napi_value callback, void* context, void* data);
    static void DisplayLoginCompleteWork(napi_env env, napi_value callback, void* context, void* data);
    static void DisplayProgressCompleteWork(napi_env env, napi_value callback, void* context, void* data);
    static void CancelCompleteWork(napi_env env, napi_value callback, void* context, void* data);
    static void UpdateProgressCompleteWork(napi_env env, napi_value callback, void* context, void* data);
    static void DisplayQuestionCompleteWork(napi_env env, napi_value callback, void* context, void* data);
    static std::string SafeString(const char* str);

    static inline napi_threadsafe_function pfDisplayErrorFn_ { nullptr };
    static inline napi_threadsafe_function pfDisplayLoginFn_ { nullptr };
    static inline napi_threadsafe_function pfDisplayProgressFn_ { nullptr };
    static inline napi_threadsafe_function pfCancelFn_ { nullptr };
    static inline napi_threadsafe_function pfUpdateProgressFn_ { nullptr };
    static inline napi_threadsafe_function pfDisplayQuestionFn_ { nullptr };
};
