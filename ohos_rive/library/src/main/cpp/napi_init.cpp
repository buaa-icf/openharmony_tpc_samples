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

#include "bindings/bindings_artboard.h"
#include "bindings/bindings_bindable_artboard.h"
#include "bindings/bindings_command_queue.h"
#include "bindings/bindings_command_queue_egl.h"
#include "bindings/bindings_data_binding.h"
#include "bindings/bindings_file.h"
#include "bindings/bindings_file_asset.h"
#include "bindings/bindings_file_asset_loader.h"
#include "bindings/bindings_font.h"
#include "bindings/bindings_helper.h"
#include "bindings/bindings_init.h"
#include "bindings/bindings_layer_state.h"
#include "bindings/bindings_linear_animation_instance.h"
#include "bindings/bindings_renderer.h"
#include "bindings/bindings_rive_event.h"
#include "bindings/bindings_rive_texture_view.h"
#include "bindings/bindings_state_machine_input_instance.h"
#include "bindings/bindings_state_machine_instance.h"
#include "bindings/bindings_text_value_run.h"
#include <napi/native_api.h>

using namespace ohos_rive;

static napi_value InitRendererType(napi_env env, napi_value exports)
{
    napi_value rendererTypeEnum;
    napi_create_object(env, &rendererTypeEnum);

    napi_value noneValue;
    napi_create_int32(env, -1, &noneValue);
    napi_set_named_property(env, rendererTypeEnum, "None", noneValue);

    napi_value riveValue;
    napi_create_int32(env, 0, &riveValue);
    napi_set_named_property(env, rendererTypeEnum, "Rive", riveValue);

    napi_value canvasValue;
    napi_create_int32(env, 1, &canvasValue);
    napi_set_named_property(env, rendererTypeEnum, "Canvas", canvasValue);

    napi_set_named_property(env, exports, "RendererType", rendererTypeEnum);
    return exports;
}

static napi_value InitFileAssetLoader(napi_env env, napi_value exports)
{
    napi_property_descriptor fileAssetLoaderDesc[] = {
        {"Napi_FileAssetLoader_constructor", nullptr, FileAssetLoaderCreate, nullptr, nullptr, nullptr, napi_default,
         nullptr},
        {"Napi_FileAssetLoader_cppDelete", nullptr, FileAssetLoaderDelete, nullptr, nullptr, nullptr, napi_default,
         nullptr},
        {"Napi_FileAssetLoader_cppRef", nullptr, FileAssetLoaderRef, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"Napi_FileAssetLoader_cppSetRendererType", nullptr, FileAssetLoaderSetRendererType, nullptr, nullptr, nullptr,
         napi_default, nullptr}};

    napi_define_properties(env, exports, sizeof(fileAssetLoaderDesc) / sizeof(fileAssetLoaderDesc[0]),
                           fileAssetLoaderDesc);
    return exports;
}

static napi_value InitFile(napi_env env, napi_value exports)
{
    napi_property_descriptor fileDesc[] = {
        {"Napi_File_import", nullptr, Napi_File_import, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"Napi_File_cppEnums", nullptr, Napi_File_cppEnums, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"Napi_File_cppArtboardByName", nullptr, FileCppArtboardByName, nullptr, nullptr, nullptr, napi_default,
         nullptr},
        {"Napi_File_cppDelete", nullptr, FileCppDelete, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"Napi_File_cppArtboardCount", nullptr, FileCppArtboardCount, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"Napi_File_cppArtboardByIndex", nullptr, FileCppArtboardByIndex, nullptr, nullptr, nullptr, napi_default,
         nullptr},
        {"Napi_File_cppArtboardNameByIndex", nullptr, FileCppArtboardNameByIndex, nullptr, nullptr, nullptr,
         napi_default, nullptr},
        {"Napi_File_cppCreateBindableArtboardByName", nullptr, FileCppCreateBindableArtboardByName, nullptr, nullptr,
         nullptr, napi_default, nullptr},
        {"Napi_File_cppCreateDefaultBindableArtboard", nullptr, FileCppCreateDefaultBindableArtboard, nullptr, nullptr,
         nullptr, napi_default, nullptr},
        {"Napi_File_cppViewModelCount", nullptr, FileCppViewModelCount, nullptr, nullptr, nullptr, napi_default,
         nullptr},
        {"Napi_File_cppViewModelByIndex", nullptr, FileCppViewModelByIndex, nullptr, nullptr, nullptr, napi_default,
         nullptr},
        {"Napi_File_cppViewModelByName", nullptr, FileCppViewModelByName, nullptr, nullptr, nullptr, napi_default,
         nullptr},
        {"Napi_CommandQueue_cppLoadFile", nullptr, CommandQueueLoadFile, nullptr, nullptr, nullptr, napi_default,
         nullptr},
        {"Napi_CommandQueue_cppDeleteFile", nullptr, CommandQueueDeleteFile, nullptr, nullptr, nullptr, napi_default,
         nullptr},
        {"Napi_File_cppDefaultViewModelForArtboard", nullptr, FileCppDefaultViewModelForArtboard, nullptr, nullptr,
         nullptr, napi_default, nullptr}};

    napi_define_properties(env, exports, sizeof(fileDesc) / sizeof(fileDesc[0]), fileDesc);
    return exports;
}

static napi_value InitBindableArtboard(napi_env env, napi_value exports)
{
    napi_property_descriptor bindableArtboardDesc[] = {
        {"Napi_BindableArtboard_cppDelete", nullptr, BindableArtboardDelete, nullptr, nullptr, nullptr, napi_default,
         nullptr},
        {"Napi_BindableArtboard_cppName", nullptr, BindableArtboardGetName, nullptr, nullptr, nullptr, napi_default,
         nullptr}};

    napi_define_properties(env, exports, sizeof(bindableArtboardDesc) / sizeof(bindableArtboardDesc[0]),
                           bindableArtboardDesc);
    return exports;
}

static napi_value InitArtboard(napi_env env, napi_value exports)
{
    napi_property_descriptor artboardDesc[] = {
        {"Napi_Artboard_cppName", nullptr, ArtboardCppName, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"Napi_Artboard_animationNameByIndex", nullptr, ArtboardAnimationNameByIndex, nullptr, nullptr, nullptr,
         napi_default, nullptr},
        {"Napi_Artboard_stateMachineNameByIndex", nullptr, ArtboardStateMachineNameByIndex, nullptr, nullptr, nullptr,
         napi_default, nullptr},
        {"Napi_Artboard_animationByIndex", nullptr, ArtboardAnimationByIndex, nullptr, nullptr, nullptr, napi_default,
         nullptr},
        {"Napi_Artboard_animationByName", nullptr, ArtboardAnimationByName, nullptr, nullptr, nullptr, napi_default,
         nullptr},
        {"Napi_Artboard_animationCount", nullptr, ArtboardAnimationCount, nullptr, nullptr, nullptr, napi_default,
         nullptr},
        {"Napi_Artboard_stateMachineByIndex", nullptr, ArtboardStateMachineByIndex, nullptr, nullptr, nullptr,
         napi_default, nullptr},
        {"Napi_Artboard_stateMachineByName", nullptr, ArtboardStateMachineByName, nullptr, nullptr, nullptr,
         napi_default, nullptr},
        {"Napi_Artboard_stateMachineCount", nullptr, ArtboardStateMachineCount, nullptr, nullptr, nullptr, napi_default,
         nullptr},
        {"Napi_Artboard_inputByNameAtPath", nullptr, ArtboardInputByNameAtPath, nullptr, nullptr, nullptr, napi_default,
         nullptr},
        {"Napi_Artboard_getVolume", nullptr, ArtboardGetVolume, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"Napi_Artboard_setVolume", nullptr, ArtboardSetVolume, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"Napi_Artboard_findTextValueRun", nullptr, ArtboardFindTextValueRun, nullptr, nullptr, nullptr, napi_default,
         nullptr},
        {"Napi_Artboard_findValueOfTextValueRun", nullptr, ArtboardFindValueOfTextValueRun, nullptr, nullptr, nullptr,
         napi_default, nullptr},
        {"Napi_Artboard_setValueOfTextValueRun", nullptr, ArtboardSetValueOfTextValueRun, nullptr, nullptr, nullptr,
         napi_default, nullptr},
        {"Napi_Artboard_findTextValueRunAtPath", nullptr, ArtboardFindTextValueRunAtPath, nullptr, nullptr, nullptr,
         napi_default, nullptr},
        {"Napi_Artboard_findValueOfTextValueRunAtPath", nullptr, ArtboardFindValueOfTextValueRunAtPath, nullptr,
         nullptr, nullptr, napi_default, nullptr},
        {"Napi_Artboard_setValueOfTextValueRunAtPath", nullptr, ArtboardSetValueOfTextValueRunAtPath, nullptr, nullptr,
         nullptr, napi_default, nullptr},
        {"Napi_Artboard_advance", nullptr, ArtboardAdvance, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"Napi_Artboard_bounds", nullptr, ArtboardBounds, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"Napi_CommandQueue_cppGetArtboardNames", nullptr, CommandQueueGetArtboardNames, nullptr, nullptr, nullptr,
         napi_default, nullptr},
        {"Napi_CommandQueue_cppCreateDefaultArtboard", nullptr, CommandQueueCreateDefaultArtboard, nullptr, nullptr,
         nullptr, napi_default, nullptr},
        {"Napi_CommandQueue_cppCreateArtboardByName", nullptr, CommandQueueCreateArtboardByName, nullptr, nullptr,
         nullptr, napi_default, nullptr},
        {"Napi_CommandQueue_cppDeleteArtboard", nullptr, CommandQueueDeleteArtboard, nullptr, nullptr, nullptr,
         napi_default, nullptr},
    };
    napi_define_properties(env, exports, sizeof(artboardDesc) / sizeof(artboardDesc[0]), artboardDesc);
    return exports;
}

static napi_value InitArtboardSize(napi_env env, napi_value exports)
{
    napi_property_descriptor artboardSizeDesc[] = {
        {"Napi_Artboard_resetArtboardSize", nullptr, ArtboardResetArtboardSize, nullptr, nullptr, nullptr, napi_default,
         nullptr},
        {"Napi_Artboard_getArtboardWidth", nullptr, ArtboardGetArtboardWidth, nullptr, nullptr, nullptr, napi_default,
         nullptr},
        {"Napi_Artboard_setArtboardWidth", nullptr, ArtboardSetArtboardWidth, nullptr, nullptr, nullptr, napi_default,
         nullptr},
        {"Napi_Artboard_getArtboardHeight", nullptr, ArtboardGetArtboardHeight, nullptr, nullptr, nullptr, napi_default,
         nullptr},
        {"Napi_Artboard_setArtboardHeight", nullptr, ArtboardSetArtboardHeight, nullptr, nullptr, nullptr, napi_default,
         nullptr},
        {"Napi_Artboard_setViewModelInstance", nullptr, ArtboardSetViewModelInstance, nullptr, nullptr, nullptr,
         napi_default, nullptr},
        {"Napi_Artboard_draw", nullptr, ArtboardDraw, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"Napi_Artboard_drawAligned", nullptr, ArtboardDrawAligned, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"Napi_Artboard_delete", nullptr, ArtboardDelete, nullptr, nullptr, nullptr, napi_default, nullptr},
    };
    napi_define_properties(env, exports, sizeof(artboardSizeDesc) / sizeof(artboardSizeDesc[0]), artboardSizeDesc);
    return exports;
}

static napi_value InitRiveTextureView(napi_env env, napi_value exports)
{
    napi_property_descriptor riveTextureViewDesc[] = {
        {"Napi_RiveTextureView_getAverageFps", nullptr, RiveTextureViewGetAverageFps, nullptr, nullptr, nullptr,
         napi_default, nullptr},
    };
    napi_define_properties(env, exports, sizeof(riveTextureViewDesc) / sizeof(riveTextureViewDesc[0]),
                           riveTextureViewDesc);
    return exports;
}

static napi_value InitViewModel(napi_env env, napi_value exports)
{
    napi_property_descriptor viewModelDesc[] = {
        {"Napi_ViewModel_cppName", nullptr, ViewModelName, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"Napi_ViewModel_instanceCount", nullptr, ViewModelInstanceCount, nullptr, nullptr, nullptr, napi_default,
         nullptr},
        {"Napi_ViewModel_propertyCount", nullptr, ViewModelPropertyCount, nullptr, nullptr, nullptr, napi_default,
         nullptr},
        {"Napi_ViewModel_getProperties", nullptr, ViewModelGetProperties, nullptr, nullptr, nullptr, napi_default,
         nullptr},
        {"Napi_ViewModel_createBlankInstance", nullptr, ViewModelCreateBlankInstance, nullptr, nullptr, nullptr,
         napi_default, nullptr},
        {"Napi_ViewModel_createDefaultInstance", nullptr, ViewModelCreateDefaultInstance, nullptr, nullptr, nullptr,
         napi_default, nullptr},
        {"Napi_ViewModel_createInstanceFromIndex", nullptr, ViewModelCreateInstanceFromIndex, nullptr, nullptr, nullptr,
         napi_default, nullptr},
        {"Napi_ViewModel_createInstanceFromName", nullptr, ViewModelCreateInstanceFromName, nullptr, nullptr, nullptr,
         napi_default, nullptr},
        {"Napi_CommandQueue_cppGetViewModelNames", nullptr, CommandQueueGetViewModelNames, nullptr, nullptr, nullptr,
         napi_default, nullptr},
        {"Napi_CommandQueue_cppGetViewModelInstanceNames", nullptr, CommandQueueGetViewModelInstanceNames, nullptr,
         nullptr, nullptr, napi_default, nullptr},
        {"Napi_CommandQueue_cppGetViewModelProperties", nullptr, CommandQueueGetViewModelProperties, nullptr, nullptr,
         nullptr, napi_default, nullptr},
        {"Napi_CommandQueue_cppDeleteViewModelInstance", nullptr, CommandQueueDeleteViewModelInstance, nullptr, nullptr,
         nullptr, napi_default, nullptr},
        {"Napi_CommandQueue_cppBindViewModelInstance", nullptr, CommandQueueBindViewModelInstance, nullptr, nullptr,
         nullptr, napi_default, nullptr},
    };
    napi_define_properties(env, exports, sizeof(viewModelDesc) / sizeof(viewModelDesc[0]), viewModelDesc);
    return exports;
}

static napi_value InitViewModelInstance(napi_env env, napi_value exports)
{
    napi_property_descriptor viewModelInstanceDesc[] = {
        {"Napi_ViewModelInstance_cppName", nullptr, ViewModelInstanceName, nullptr, nullptr, nullptr, napi_default,
         nullptr},
        {"Napi_ViewModelInstance_propertyNumber", nullptr, ViewModelInstancePropertyNumber, nullptr, nullptr, nullptr,
         napi_default, nullptr},
        {"Napi_ViewModelInstance_propertyString", nullptr, ViewModelInstancePropertyString, nullptr, nullptr, nullptr,
         napi_default, nullptr},
        {"Napi_ViewModelInstance_propertyBoolean", nullptr, ViewModelInstancePropertyBoolean, nullptr, nullptr, nullptr,
         napi_default, nullptr},
        {"Napi_ViewModelInstance_propertyColor", nullptr, ViewModelInstancePropertyColor, nullptr, nullptr, nullptr,
         napi_default, nullptr},
        {"Napi_ViewModelInstance_propertyEnum", nullptr, ViewModelInstancePropertyEnum, nullptr, nullptr, nullptr,
         napi_default, nullptr},
        {"Napi_ViewModelInstance_propertyTrigger", nullptr, ViewModelInstancePropertyTrigger, nullptr, nullptr, nullptr,
         napi_default, nullptr},
        {"Napi_ViewModelInstance_propertyImage", nullptr, ViewModelInstancePropertyImage, nullptr, nullptr, nullptr,
         napi_default, nullptr},
        {"Napi_ViewModelInstance_propertyList", nullptr, ViewModelInstancePropertyList, nullptr, nullptr, nullptr,
         napi_default, nullptr},
        {"Napi_ViewModelInstance_propertyArtboard", nullptr, ViewModelInstancePropertyArtboard, nullptr, nullptr,
         nullptr, napi_default, nullptr},
        {"Napi_ViewModelInstance_propertyInstance", nullptr, ViewModelInstancePropertyInstance, nullptr, nullptr,
         nullptr, napi_default, nullptr},
        {"Napi_ViewModelInstance_setInstanceProperty", nullptr, ViewModelInstanceSetInstanceProperty, nullptr, nullptr,
         nullptr, napi_default, nullptr},
        {"Napi_ViewModelInstance_refInstance", nullptr, ViewModelInstanceRefInstance, nullptr, nullptr, nullptr,
         napi_default, nullptr},
        {"Napi_ViewModelInstance_derefInstance", nullptr, ViewModelInstanceDerefInstance, nullptr, nullptr, nullptr,
         napi_default, nullptr},
    };
    napi_define_properties(env, exports, sizeof(viewModelInstanceDesc) / sizeof(viewModelInstanceDesc[0]),
                           viewModelInstanceDesc);
    return exports;
}

static napi_value InitViewModelProperty(napi_env env, napi_value exports)
{
    napi_property_descriptor viewModelPropertyDesc[] = {
        {"Napi_ViewModelProperty_cppName", nullptr, ViewModelPropertyName, nullptr, nullptr, nullptr, napi_default,
         nullptr},
        {"Napi_ViewModelProperty_hasChanged", nullptr, ViewModelPropertyHasChanged, nullptr, nullptr, nullptr,
         napi_default, nullptr},
        {"Napi_ViewModelProperty_flushChanges", nullptr, ViewModelPropertyFlushChanges, nullptr, nullptr, nullptr,
         napi_default, nullptr},
    };
    napi_define_properties(env, exports, sizeof(viewModelPropertyDesc) / sizeof(viewModelPropertyDesc[0]),
                           viewModelPropertyDesc);
    return exports;
}

static napi_value InitViewModelNumberProperty(napi_env env, napi_value exports)
{
    napi_property_descriptor viewModelNumberPropertyDesc[] = {
        {"Napi_ViewModelNumberProperty_getValue", nullptr, ViewModelNumberPropertyGetValue, nullptr, nullptr, nullptr,
         napi_default, nullptr},
        {"Napi_ViewModelNumberProperty_setValue", nullptr, ViewModelNumberPropertySetValue, nullptr, nullptr, nullptr,
         napi_default, nullptr},
    };
    napi_define_properties(env, exports, sizeof(viewModelNumberPropertyDesc) / sizeof(viewModelNumberPropertyDesc[0]),
                           viewModelNumberPropertyDesc);
    return exports;
}

static napi_value InitViewModelStringProperty(napi_env env, napi_value exports)
{
    napi_property_descriptor viewModelStringPropertyDesc[] = {
        {"Napi_ViewModelStringProperty_getValue", nullptr, ViewModelStringPropertyGetValue, nullptr, nullptr, nullptr,
         napi_default, nullptr},
        {"Napi_ViewModelStringProperty_setValue", nullptr, ViewModelStringPropertySetValue, nullptr, nullptr, nullptr,
         napi_default, nullptr},
    };
    napi_define_properties(env, exports, sizeof(viewModelStringPropertyDesc) / sizeof(viewModelStringPropertyDesc[0]),
                           viewModelStringPropertyDesc);
    return exports;
}

static napi_value InitViewModelBooleanProperty(napi_env env, napi_value exports)
{
    napi_property_descriptor viewModelBooleanPropertyDesc[] = {
        {"Napi_ViewModelBooleanProperty_getValue", nullptr, ViewModelBooleanPropertyGetValue, nullptr, nullptr, nullptr,
         napi_default, nullptr},
        {"Napi_ViewModelBooleanProperty_setValue", nullptr, ViewModelBooleanPropertySetValue, nullptr, nullptr, nullptr,
         napi_default, nullptr},
    };
    napi_define_properties(env, exports, sizeof(viewModelBooleanPropertyDesc) / sizeof(viewModelBooleanPropertyDesc[0]),
                           viewModelBooleanPropertyDesc);
    return exports;
}

static napi_value InitViewModelColorProperty(napi_env env, napi_value exports)
{
    napi_property_descriptor viewModelColorPropertyDesc[] = {
        {"Napi_ViewModelColorProperty_getValue", nullptr, ViewModelColorPropertyGetValue, nullptr, nullptr, nullptr,
         napi_default, nullptr},
        {"Napi_ViewModelColorProperty_setValue", nullptr, ViewModelColorPropertySetValue, nullptr, nullptr, nullptr,
         napi_default, nullptr},
    };
    napi_define_properties(env, exports, sizeof(viewModelColorPropertyDesc) / sizeof(viewModelColorPropertyDesc[0]),
                           viewModelColorPropertyDesc);
    return exports;
}

static napi_value InitViewModelEnumProperty(napi_env env, napi_value exports)
{
    napi_property_descriptor viewModelEnumPropertyDesc[] = {
        {"Napi_ViewModelEnumProperty_getValue", nullptr, ViewModelEnumPropertyGetValue, nullptr, nullptr, nullptr,
         napi_default, nullptr},
        {"Napi_ViewModelEnumProperty_setValue", nullptr, ViewModelEnumPropertySetValue, nullptr, nullptr, nullptr,
         napi_default, nullptr},
    };
    napi_define_properties(env, exports, sizeof(viewModelEnumPropertyDesc) / sizeof(viewModelEnumPropertyDesc[0]),
                           viewModelEnumPropertyDesc);
    return exports;
}

static napi_value InitViewModelOtherProperty(napi_env env, napi_value exports)
{
    napi_property_descriptor viewModelTriggerPropertyDesc[] = {
        {"Napi_ViewModelTriggerProperty_trigger", nullptr, ViewModelTriggerPropertyTrigger, nullptr, nullptr, nullptr,
         napi_default, nullptr},
        {"Napi_ViewModelImageProperty_setValue", nullptr, ViewModelImagePropertySetValue, nullptr, nullptr, nullptr,
         napi_default, nullptr},
        {"Napi_ViewModelListProperty_size", nullptr, ViewModelListPropertySize, nullptr, nullptr, nullptr, napi_default,
         nullptr},
        {"Napi_ViewModelListProperty_elementAt", nullptr, ViewModelListPropertyElementAt, nullptr, nullptr, nullptr,
         napi_default, nullptr},
        {"Napi_ViewModelListProperty_add", nullptr, ViewModelListPropertyAdd, nullptr, nullptr, nullptr, napi_default,
         nullptr},
        {"Napi_ViewModelListProperty_addAt", nullptr, ViewModelListPropertyAddAt, nullptr, nullptr, nullptr,
         napi_default, nullptr},
        {"Napi_ViewModelListProperty_remove", nullptr, ViewModelListPropertyRemove, nullptr, nullptr, nullptr,
         napi_default, nullptr},
        {"Napi_ViewModelListProperty_removeAt", nullptr, ViewModelListPropertyRemoveAt, nullptr, nullptr, nullptr,
         napi_default, nullptr},
        {"Napi_ViewModelListProperty_swap", nullptr, ViewModelListPropertySwap, nullptr, nullptr, nullptr, napi_default,
         nullptr},
        {"Napi_ViewModelArtboardProperty_setArtboard", nullptr, ViewModelArtboardPropertySetArtboard, nullptr, nullptr,
         nullptr, napi_default, nullptr},
        {"Napi_ViewModelArtboardProperty_setBindableArtboard", nullptr, ViewModelArtboardPropertySetBindableArtboard,
         nullptr, nullptr, nullptr, napi_default, nullptr},
    };
    napi_define_properties(env, exports, sizeof(viewModelTriggerPropertyDesc) / sizeof(viewModelTriggerPropertyDesc[0]),
                           viewModelTriggerPropertyDesc);
    return exports;
}

static napi_value InitRive(napi_env env, napi_value exports)
{
    napi_property_descriptor riveCppDesc[] = {
        {"Napi_Rive_cppCalculateRequiredBounds", nullptr, RiveCppCalculateRequiredBounds, nullptr, nullptr, nullptr,
         napi_default, nullptr},
        {"Napi_Rive_cppInitialize", nullptr, RiveCppInitialize, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"Napi_Rive_cppRegisterClass", nullptr, RiveCppRegisterClass, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"Napi_Rive_cppUnregisterClass", nullptr, RiveCppUnregisterClass, nullptr, nullptr, nullptr, napi_default,
         nullptr},
    };

    napi_define_properties(env, exports, sizeof(riveCppDesc) / sizeof(riveCppDesc[0]), riveCppDesc);
    return exports;
}

static napi_value InitHelper(napi_env env, napi_value exports)
{
    napi_property_descriptor helperCppDesc[] = {
        {"Napi_Helper_cppConvertToArtboardSpace", nullptr, ConvertToArtboardSpace, nullptr, nullptr, nullptr,
         napi_default, nullptr},
    };

    napi_define_properties(env, exports, sizeof(helperCppDesc) / sizeof(helperCppDesc[0]), helperCppDesc);
    return exports;
}

static napi_value InitLinearAnimation(napi_env env, napi_value exports)
{
    napi_property_descriptor LinearAnimationInstanceCppDesc[] = {
        {"Napi_LinearAnimationInstance_cppAdvance", nullptr, Advance, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"Napi_LinearAnimationInstance_cppAdvanceAndGetResult", nullptr, AdvanceAndGetResult, nullptr, nullptr, nullptr,
         napi_default, nullptr},
        {"Napi_LinearAnimationInstance_cppApply", nullptr, Apply, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"Napi_LinearAnimationInstance_cppGetTime", nullptr, GetTime, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"Napi_LinearAnimationInstance_cppSetTime", nullptr, SetTime, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"Napi_LinearAnimationInstance_cppSetDirection", nullptr, SetDirection, nullptr, nullptr, nullptr, napi_default,
         nullptr},
        {"Napi_LinearAnimationInstance_cppGetDirection", nullptr, GetDirection, nullptr, nullptr, nullptr, napi_default,
         nullptr},
        {"Napi_LinearAnimationInstance_cppGetLoop", nullptr, GetLoop, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"Napi_LinearAnimationInstance_cppSetLoop", nullptr, SetLoop, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"Napi_LinearAnimationInstance_cppName", nullptr, Name, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"Napi_LinearAnimationInstance_cppDuration", nullptr, Duration, nullptr, nullptr, nullptr, napi_default,
         nullptr},
        {"Napi_LinearAnimationInstance_cppFps", nullptr, Fps, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"Napi_LinearAnimationInstance_cppWorkStart", nullptr, WorkStart, nullptr, nullptr, nullptr, napi_default,
         nullptr},
        {"Napi_LinearAnimationInstance_cppWorkEnd", nullptr, WorkEnd, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"Napi_LinearAnimationInstance_cppDelete", nullptr, Delete, nullptr, nullptr, nullptr, napi_default, nullptr},
    };

    napi_define_properties(env, exports,
                           sizeof(LinearAnimationInstanceCppDesc) / sizeof(LinearAnimationInstanceCppDesc[0]),
                           LinearAnimationInstanceCppDesc);
    return exports;
}

static napi_value InitSMIInstance(napi_env env, napi_value exports)
{
    napi_property_descriptor SMIInstanceCppDesc[] = {
        {"Napi_SMI_cppSMIInputName", nullptr, SMIInputName, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"Napi_SMI_cppSMIInputIsBoolean", nullptr, SMIInputIsBoolean, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"Napi_SMI_cppSMIInputIsNumber", nullptr, SMIInputIsNumber, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"Napi_SMI_cppSMIInputIsTrigger", nullptr, SMIInputIsTrigger, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"Napi_SMI_cppSMIBoolValue", nullptr, SMIBoolValue, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"Napi_SMI_cppSMIBoolSetValue", nullptr, SMIBoolSetValue, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"Napi_SMI_cppSMINumberValue", nullptr, SMINumberValue, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"Napi_SMI_cppSMINumberSetValue", nullptr, SMINumberSetValue, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"Napi_SMI_cppSMITriggerFire", nullptr, SMITriggerFire, nullptr, nullptr, nullptr, napi_default, nullptr},
    };

    napi_define_properties(env, exports, sizeof(SMIInstanceCppDesc) / sizeof(SMIInstanceCppDesc[0]),
                           SMIInstanceCppDesc);
    return exports;
}

static napi_value InitStateMachineInstance(napi_env env, napi_value exports)
{
    napi_property_descriptor StateMachineInstanceCppDesc[] = {
        {"Napi_StateMachine_cppAdvance", nullptr, StateMachineAdvance, nullptr, nullptr, nullptr, napi_default,
         nullptr},
        {"Napi_StateMachine_cppStateChangedCount", nullptr, StateMachineStateChangedCount, nullptr, nullptr, nullptr,
         napi_default, nullptr},
        {"Napi_StateMachine_cppStateChangedByIndex", nullptr, StateMachineStateChangedByIndex, nullptr, nullptr,
         nullptr, napi_default, nullptr},
        {"Napi_StateMachine_cppReportedEventCount", nullptr, StateMachineReportedEventCount, nullptr, nullptr, nullptr,
         napi_default, nullptr},
        {"Napi_StateMachine_cppReportedEventAt", nullptr, StateMachineReportedEventAt, nullptr, nullptr, nullptr,
         napi_default, nullptr},
        {"Napi_StateMachine_cppSMIInputByIndex", nullptr, StateMachineSMIInputByIndex, nullptr, nullptr, nullptr,
         napi_default, nullptr},
        {"Napi_StateMachine_cppInputCount", nullptr, StateMachineInputCount, nullptr, nullptr, nullptr, napi_default,
         nullptr},
        {"Napi_StateMachine_cppName", nullptr, StateMachineName, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"Napi_StateMachine_cppLayerCount", nullptr, StateMachineLayerCount, nullptr, nullptr, nullptr, napi_default,
         nullptr},
        {"Napi_StateMachine_cppPointerDown", nullptr, StateMachinePointerDown, nullptr, nullptr, nullptr, napi_default,
         nullptr},
        {"Napi_StateMachine_cppPointerMove", nullptr, StateMachinePointerMove, nullptr, nullptr, nullptr, napi_default,
         nullptr},
        {"Napi_StateMachine_cppPointerUp", nullptr, StateMachinePointerUp, nullptr, nullptr, nullptr, napi_default,
         nullptr},
        {"Napi_StateMachine_cppPointerExit", nullptr, StateMachinePointerExit, nullptr, nullptr, nullptr, napi_default,
         nullptr},
        {"Napi_StateMachine_cppSetViewModelInstance", nullptr, StateMachineSetViewModelInstance, nullptr, nullptr,
         nullptr, napi_default, nullptr},
        {"Napi_StateMachine_cppDelete", nullptr, StateMachineDelete, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"Napi_CommandQueue_cppGetStateMachineNames", nullptr, CommandQueueGetStateMachineNames, nullptr, nullptr,
         nullptr, napi_default, nullptr},
        {"Napi_CommandQueue_cppCreateDefaultStateMachine", nullptr, CommandQueueCreateDefaultStateMachine, nullptr,
         nullptr, nullptr, napi_default, nullptr},
        {"Napi_CommandQueue_cppCreateStateMachineByName", nullptr, CommandQueueCreateStateMachineByName, nullptr,
         nullptr, nullptr, napi_default, nullptr},
        {"Napi_CommandQueue_cppDeleteStateMachine", nullptr, CommandQueueDeleteStateMachine, nullptr, nullptr, nullptr,
         napi_default, nullptr},
        {"Napi_CommandQueue_cppAdvanceStateMachine", nullptr, CommandQueueAdvanceStateMachine, nullptr, nullptr,
         nullptr, napi_default, nullptr},
    };

    napi_define_properties(env, exports, sizeof(StateMachineInstanceCppDesc) / sizeof(StateMachineInstanceCppDesc[0]),
                           StateMachineInstanceCppDesc);
    return exports;
}

static napi_value InitFont(napi_env env, napi_value exports)
{
    napi_property_descriptor fontCppDesc[] = {
        {"Napi_Font_cppRegisterFallbackFont", nullptr, FontCppRegisterFallbackFont, nullptr, nullptr, nullptr,
         napi_default, nullptr},
        {"Napi_Font_cppResetFontCache", nullptr, FontCppResetFontCache, nullptr, nullptr, nullptr, napi_default,
         nullptr},
    };

    napi_define_properties(env, exports, sizeof(fontCppDesc) / sizeof(fontCppDesc[0]), fontCppDesc);
    return exports;
}

static napi_value InitRenderer(napi_env env, napi_value exports)
{
    napi_property_descriptor rendererCppDesc[] = {
        {"Napi_Renderer_cppConstructor", nullptr, RendererConstructor, nullptr, nullptr, nullptr, napi_default,
         nullptr},
        {"Napi_Renderer_cppDelete", nullptr, RendererCppDelete, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"Napi_Renderer_cppStop", nullptr, RendererCppStop, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"Napi_Renderer_cppStart", nullptr, RendererCppStart, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"Napi_Renderer_cppDoFrame", nullptr, RendererCppDoFrame, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"Napi_Renderer_cppSetSurface", nullptr, RendererCppSetSurface, nullptr, nullptr, nullptr, napi_default,
         nullptr},
        {"Napi_Renderer_cppDestroySurface", nullptr, RendererCppDestroySurface, nullptr, nullptr, nullptr, napi_default,
         nullptr},
        {"Napi_Renderer_cppSave", nullptr, RendererCppSave, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"Napi_Renderer_cppRestore", nullptr, RendererCppRestore, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"Napi_Renderer_cppAlign", nullptr, RendererCppAlign, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"Napi_Renderer_cppTransform", nullptr, RendererCppTransform, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"Napi_Renderer_cppWidth", nullptr, RendererCppWidth, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"Napi_Renderer_cppHeight", nullptr, RendererCppHeight, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"Napi_Renderer_cppAvgFps", nullptr, RendererCppAvgFps, nullptr, nullptr, nullptr, napi_default, nullptr},
    };

    napi_define_properties(env, exports, sizeof(rendererCppDesc) / sizeof(rendererCppDesc[0]), rendererCppDesc);
    return exports;
}

static napi_value InitLayerState(napi_env env, napi_value exports)
{
    napi_property_descriptor LayerStateCppDesc[] = {
        {"Napi_LayerState_cppIsExitState", nullptr, LayerStateIsExitState, nullptr, nullptr, nullptr, napi_default,
         nullptr},
        {"Napi_LayerState_cppIsAnyState", nullptr, LayerStateIsAnyState, nullptr, nullptr, nullptr, napi_default,
         nullptr},
        {"Napi_LayerState_cppIsEntryState", nullptr, LayerStateIsEntryState, nullptr, nullptr, nullptr, napi_default,
         nullptr},
        {"Napi_LayerState_cppIsAnimationState", nullptr, LayerStateIsAnimationState, nullptr, nullptr, nullptr,
         napi_default, nullptr},
        {"Napi_LayerState_cppIsBlendState", nullptr, LayerStateIsBlendState, nullptr, nullptr, nullptr, napi_default,
         nullptr},
        {"Napi_LayerState_cppIsBlendState1D", nullptr, LayerStateIsBlendState1D, nullptr, nullptr, nullptr,
         napi_default, nullptr},
        {"Napi_LayerState_cppIsBlendStateDirect", nullptr, LayerStateIsBlendStateDirect, nullptr, nullptr, nullptr,
         napi_default, nullptr},
        {"Napi_AnimationState_cppName", nullptr, AnimationStateName, nullptr, nullptr, nullptr, napi_default, nullptr},
    };

    napi_define_properties(env, exports, sizeof(LayerStateCppDesc) / sizeof(LayerStateCppDesc[0]), LayerStateCppDesc);
    return exports;
}
static napi_value InitTextValue(napi_env env, napi_value exports)
{
    napi_property_descriptor textValueRunDesc[] = {
        {"Napi_RiveTextValueRun_cppText", nullptr, TextValueRunGetText, nullptr, nullptr, nullptr, napi_default,
         nullptr},
        {"Napi_RiveTextValueRun_cppSetText", nullptr, TextValueRunSetText, nullptr, nullptr, nullptr, napi_default,
         nullptr},
    };
    napi_define_properties(env, exports, sizeof(textValueRunDesc) / sizeof(textValueRunDesc[0]), textValueRunDesc);
    return exports;
}

static napi_value InitFileAssert(napi_env env, napi_value exports)
{
    napi_property_descriptor fileAsset[] = {
        {"Napi_FileAsset_cppName", nullptr, OhosFileAsset::GetName, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"Napi_FileAsset_cppUniqueFilename", nullptr, OhosFileAsset::GetUniqueFilename, nullptr, nullptr, nullptr,
         napi_default, nullptr},
        {"Napi_FileAsset_cppDecode", nullptr, OhosFileAsset::Decode, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"Napi_FileAsset_cppCDNUrl", nullptr, OhosFileAsset::GetCDNUrl, nullptr, nullptr, nullptr, napi_default,
         nullptr},
        {"Napi_ImageAsset_cppSetRenderImage", nullptr, OhosFileAsset::SetRenderImage, nullptr, nullptr, nullptr,
         napi_default, nullptr},
        {"Napi_ImageAsset_cppGetRenderImage", nullptr, OhosFileAsset::GetRenderImage, nullptr, nullptr, nullptr,
         napi_default, nullptr},
        {"Napi_ImageAsset_cppImageAssetWidth", nullptr, OhosFileAsset::GetImageWidth, nullptr, nullptr, nullptr,
         napi_default, nullptr},
        {"Napi_ImageAsset_cppImageAssetHeight", nullptr, OhosFileAsset::GetImageHeight, nullptr, nullptr, nullptr,
         napi_default, nullptr},
        {"Napi_RiveRenderImage_cppCreateFromRGBABytes", nullptr, OhosFileAsset::CreateFromRGBABytes, nullptr, nullptr,
         nullptr, napi_default, nullptr},
        {"Napi_RiveRenderImage_cppCreateFromARGBInts", nullptr, OhosFileAsset::CreateFromARGBInts, nullptr, nullptr,
         nullptr, napi_default, nullptr},
        {"Napi_RiveRenderImage_cppCreateFromBitmap", nullptr, OhosFileAsset::CreateFromBitmap, nullptr, nullptr,
         nullptr, napi_default, nullptr},
        {"Napi_RiveRenderImage_cppDelete", nullptr, OhosFileAsset::ReleaseRenderImage, nullptr, nullptr, nullptr,
         napi_default, nullptr},
        {"Napi_FontAsset_cppSetFont", nullptr, OhosFileAsset::SetFont, nullptr, nullptr, nullptr, napi_default,
         nullptr},
        {"Napi_FontAsset_cppGetFont", nullptr, OhosFileAsset::GetFont, nullptr, nullptr, nullptr, napi_default,
         nullptr},
        {"Napi_RiveFont_00024Companion_cppMakeFont", nullptr, OhosFileAsset::CreateFont, nullptr, nullptr, nullptr,
         napi_default, nullptr},
        {"Napi_RiveFont_cppDelete", nullptr, OhosFileAsset::ReleaseFont, nullptr, nullptr, nullptr, napi_default,
         nullptr},
        {"Napi_AudioAsset_cppSetAudio", nullptr, OhosFileAsset::SetAudio, nullptr, nullptr, nullptr, napi_default,
         nullptr},
        {"Napi_AudioAsset_cppGetAudio", nullptr, OhosFileAsset::GetAudio, nullptr, nullptr, nullptr, napi_default,
         nullptr},
        {"Napi_RiveAudio_00024Companion_cppMakeAudio", nullptr, OhosFileAsset::CreateAudio, nullptr, nullptr, nullptr,
         napi_default, nullptr},
        {"Napi_RiveAudio_cppDelete", nullptr, OhosFileAsset::ReleaseAudio, nullptr, nullptr, nullptr, napi_default,
         nullptr},
    };
    napi_define_properties(env, exports, sizeof(fileAsset) / sizeof(fileAsset[0]), fileAsset);
    return exports;
}

static napi_value InitRiveEvent(napi_env env, napi_value exports)
{
    napi_property_descriptor RiveEventCppDesc[] = {
        {"Napi_RiveOpenURLEvent_cppURL", nullptr, RiveOpenURLEventURL, nullptr, nullptr, nullptr, napi_default,
         nullptr},
        {"Napi_RiveOpenURLEvent_cppTarget", nullptr, RiveOpenURLEventTarget, nullptr, nullptr, nullptr, napi_default,
         nullptr},
        {"Napi_RiveEvent_cppName", nullptr, RiveEventName, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"Napi_RiveEvent_cppType", nullptr, RiveEventType, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"Napi_RiveEvent_cppProperties", nullptr, RiveEventProperties, nullptr, nullptr, nullptr, napi_default,
         nullptr},
        {"Napi_RiveEvent_cppData", nullptr, RiveEventData, nullptr, nullptr, nullptr, napi_default, nullptr},
    };

    napi_define_properties(env, exports, sizeof(RiveEventCppDesc) / sizeof(RiveEventCppDesc[0]), RiveEventCppDesc);
    return exports;
}

static napi_value InitCommonQueueProperty(napi_env env, napi_value exports)
{
    napi_property_descriptor CommonQueuePropertyCppDesc[] = {
        {"Napi_CommandQueue_cppSetNumberProperty", nullptr, CommandQueueSetNumberProperty, nullptr, nullptr, nullptr,
         napi_default, nullptr},
        {"Napi_CommandQueue_cppGetNumberProperty", nullptr, CommandQueueGetNumberProperty, nullptr, nullptr, nullptr,
         napi_default, nullptr},
        {"Napi_CommandQueue_cppSetStringProperty", nullptr, CommandQueueSetStringProperty, nullptr, nullptr, nullptr,
         napi_default, nullptr},
        {"Napi_CommandQueue_cppGetStringProperty", nullptr, CommandQueueGetStringProperty, nullptr, nullptr, nullptr,
         napi_default, nullptr},
        {"Napi_CommandQueue_cppSetBooleanProperty", nullptr, CommandQueueSetBooleanProperty, nullptr, nullptr, nullptr,
         napi_default, nullptr},
        {"Napi_CommandQueue_cppGetBooleanProperty", nullptr, CommandQueueGetBooleanProperty, nullptr, nullptr, nullptr,
         napi_default, nullptr},
        {"Napi_CommandQueue_cppSetEnumProperty", nullptr, CommandQueueSetEnumProperty, nullptr, nullptr, nullptr,
         napi_default, nullptr},
        {"Napi_CommandQueue_cppGetEnumProperty", nullptr, CommandQueueGetEnumProperty, nullptr, nullptr, nullptr,
         napi_default, nullptr},
        {"Napi_CommandQueue_cppSetColorProperty", nullptr, CommandQueueSetColorProperty, nullptr, nullptr, nullptr,
         napi_default, nullptr},
        {"Napi_CommandQueue_cppGetColorProperty", nullptr, CommandQueueGetColorProperty, nullptr, nullptr, nullptr,
         napi_default, nullptr},
        {"Napi_CommandQueue_cppFireTriggerProperty", nullptr, CommandQueueFireTriggerProperty, nullptr, nullptr,
         nullptr, napi_default, nullptr},
        {"Napi_CommandQueue_cppSubscribeToProperty", nullptr, CommandQueueSubscribeToProperty, nullptr, nullptr,
         nullptr, napi_default, nullptr},
        {"Napi_CommandQueue_cppUnsubscribeFromProperty", nullptr, CommandQueueUnsubscribeFromProperty, nullptr, nullptr,
         nullptr, napi_default, nullptr},

    };

    napi_define_properties(env, exports, sizeof(CommonQueuePropertyCppDesc) / sizeof(CommonQueuePropertyCppDesc[0]),
                           CommonQueuePropertyCppDesc);
    return exports;
}

static napi_value InitCommonQueue(napi_env env, napi_value exports)
{
    napi_property_descriptor CommandQueueCppDesc[] = {
        {"Napi_CommandQueue_constructor", nullptr, CommandQueueConstructor, nullptr, nullptr, nullptr, napi_default,
         nullptr},
        {"Napi_CommandQueue_cppDelete", nullptr, CommandQueueDelete, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"Napi_CommandQueue_cppCreateListeners", nullptr, CommandQueueCreateListeners, nullptr, nullptr, nullptr,
         napi_default, nullptr},
        {"Napi_CommandQueue_cppCreateRenderTarget", nullptr, CommandQueueCreateRenderTarget, nullptr, nullptr, nullptr,
         napi_default, nullptr},
        {"Napi_CommandQueue_cppDecodeImage", nullptr, CommandQueueDecodeImage, nullptr, nullptr, nullptr, napi_default,
         nullptr},
        {"Napi_CommandQueue_cppDeleteImage", nullptr, CommandQueueDeleteImage, nullptr, nullptr, nullptr, napi_default,
         nullptr},
        {"Napi_CommandQueue_cppRegisterImage", nullptr, CommandQueueRegisterImage, nullptr, nullptr, nullptr,
         napi_default, nullptr},
        {"Napi_CommandQueue_cppUnregisterImage", nullptr, CommandQueueUnregisterImage, nullptr, nullptr, nullptr,
         napi_default, nullptr},
        {"Napi_CommandQueue_cppGetEnums", nullptr, CommandQueueGetEnums, nullptr, nullptr, nullptr, napi_default,
         nullptr},
        {"Napi_CommandQueue_cppNamedVMCreateBlankVMI", nullptr, CommandQueueNamedVMCreateBlankVMI, nullptr, nullptr,
         nullptr, napi_default, nullptr},
        {"Napi_CommandQueue_cppDefaultVMCreateBlankVMI", nullptr, CommandQueueDefaultVMCreateBlankVMI, nullptr, nullptr,
         nullptr, napi_default, nullptr},
        {"Napi_CommandQueue_cppNamedVMCreateDefaultVMI", nullptr, CommandQueueNamedVMCreateDefaultVMI, nullptr, nullptr,
         nullptr, napi_default, nullptr},
        {"Napi_CommandQueue_cppDefaultVMCreateDefaultVMI", nullptr, CommandQueueDefaultVMCreateDefaultVMI, nullptr,
         nullptr, nullptr, napi_default, nullptr},
        {"Napi_CommandQueue_cppNamedVMCreateNamedVMI", nullptr, CommandQueueNamedVMCreateNamedVMI, nullptr, nullptr,
         nullptr, napi_default, nullptr},
        {"Napi_CommandQueue_cppDefaultVMCreateNamedVMI", nullptr, CommandQueueDefaultVMCreateNamedVMI, nullptr, nullptr,
         nullptr, napi_default, nullptr},
        {"Napi_CommandQueue_cppReferenceNestedVMI", nullptr, CommandQueueReferenceNestedVMI, nullptr, nullptr, nullptr,
         napi_default, nullptr},
    };

    napi_define_properties(env, exports, sizeof(CommandQueueCppDesc) / sizeof(CommandQueueCppDesc[0]),
                           CommandQueueCppDesc);
    return exports;
}

static napi_value InitCommonQueueOther(napi_env env, napi_value exports)
{
    napi_property_descriptor CommonQueueOtherCppDesc[] = {
        {"Napi_CommandQueue_cppDecodeAudio", nullptr, CommandQueueDecodeAudio, nullptr, nullptr, nullptr, napi_default,
         nullptr},
        {"Napi_CommandQueue_cppDeleteAudio", nullptr, CommandQueueDeleteAudio, nullptr, nullptr, nullptr, napi_default,
         nullptr},
        {"Napi_CommandQueue_cppRegisterAudio", nullptr, CommandQueueRegisterAudio, nullptr, nullptr, nullptr,
         napi_default, nullptr},
        {"Napi_CommandQueue_cppUnregisterAudio", nullptr, CommandQueueUnregisterAudio, nullptr, nullptr, nullptr,
         napi_default, nullptr},
        {"Napi_CommandQueue_cppDecodeFont", nullptr, CommandQueueDecodeFont, nullptr, nullptr, nullptr, napi_default,
         nullptr},
        {"Napi_CommandQueue_cppDeleteFont", nullptr, CommandQueueDeleteFont, nullptr, nullptr, nullptr, napi_default,
         nullptr},
        {"Napi_CommandQueue_cppRegisterFont", nullptr, CommandQueueRegisterFont, nullptr, nullptr, nullptr,
         napi_default, nullptr},
        {"Napi_CommandQueue_cppUnregisterFont", nullptr, CommandQueueUnregisterFont, nullptr, nullptr, nullptr,
         napi_default, nullptr},
        {"Napi_CommandQueue_cppPointerMove", nullptr, CommandQueuePointerMove, nullptr, nullptr, nullptr, napi_default,
         nullptr},
        {"Napi_CommandQueue_cppPointerDown", nullptr, CommandQueuePointerDown, nullptr, nullptr, nullptr, napi_default,
         nullptr},
        {"Napi_CommandQueue_cppPointerUp", nullptr, CommandQueuePointerUp, nullptr, nullptr, nullptr, napi_default,
         nullptr},
        {"Napi_CommandQueue_cppPointerExit", nullptr, CommandQueuePointerExit, nullptr, nullptr, nullptr, napi_default,
         nullptr},
        {"Napi_CommandQueue_cppCreateDrawKey", nullptr, CommandQueueCreateDrawKey, nullptr, nullptr, nullptr,
         napi_default, nullptr},
        {"Napi_CommandQueue_cppPollMessages", nullptr, CommandQueuePollMessages, nullptr, nullptr, nullptr,
         napi_default, nullptr},
        {"Napi_CommandQueue_cppDraw", nullptr, CommandQueueDraw, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"Napi_CommandQueue_cppDeleteRiveSurface", nullptr, CommandQueueDeleteRiveSurface, nullptr, nullptr, nullptr,
         napi_default, nullptr},
        {"Napi_CommandQueue_cppDeleteListeners", nullptr, CommandQueueDeleteListeners, nullptr, nullptr, nullptr,
         napi_default, nullptr},
        {"Napi_CommandQueue_cppCreateEglContext", nullptr, CommandQueueCreateEglContext, nullptr, nullptr, nullptr,
         napi_default, nullptr},
        {"Napi_CommandQueue_cppDeleteEglContext", nullptr, CommandQueueDeleteEglContext, nullptr, nullptr, nullptr,
         napi_default, nullptr},
        {"Napi_CommandQueue_cppGetEglDisplay", nullptr, CommandQueueGetEglDisplay, nullptr, nullptr, nullptr,
         napi_default, nullptr},
        {"Napi_CommandQueue_cppCreateEglSurface", nullptr, CommandQueueCreateEglSurface, nullptr, nullptr, nullptr,
         napi_default, nullptr},
    };

    napi_define_properties(env, exports, sizeof(CommonQueueOtherCppDesc) / sizeof(CommonQueueOtherCppDesc[0]),
                           CommonQueueOtherCppDesc);
    return exports;
}

EXTERN_C_START
static napi_value Init(napi_env env, napi_value exports)
{
    InitRendererType(env, exports);
    InitFileAssetLoader(env, exports);
    InitFile(env, exports);
    InitBindableArtboard(env, exports);
    InitArtboard(env, exports);
    InitArtboardSize(env, exports);
    InitRiveTextureView(env, exports);
    InitViewModel(env, exports);
    InitViewModelInstance(env, exports);
    InitViewModelProperty(env, exports);
    InitViewModelNumberProperty(env, exports);
    InitViewModelStringProperty(env, exports);
    InitViewModelBooleanProperty(env, exports);
    InitViewModelColorProperty(env, exports);
    InitViewModelEnumProperty(env, exports);
    InitViewModelOtherProperty(env, exports);
    InitRive(env, exports);
    InitHelper(env, exports);
    InitLinearAnimation(env, exports);
    InitSMIInstance(env, exports);
    InitStateMachineInstance(env, exports);
    InitFont(env, exports);
    InitRenderer(env, exports);
    InitLayerState(env, exports);
    InitTextValue(env, exports);
    InitFileAssert(env, exports);
    InitRiveEvent(env, exports);
    InitCommonQueueProperty(env, exports);
    InitCommonQueue(env, exports);
    InitCommonQueueOther(env, exports);
    return exports;
}
EXTERN_C_END

static napi_module demoModule = {
    .nm_version = 1,
    .nm_flags = 0,
    .nm_filename = nullptr,
    .nm_register_func = Init,
    .nm_modname = "ohos_rive",
    .nm_priv = ((void *)0),
    .reserved = {0},
};

extern "C" __attribute__((constructor)) void RegisterEntryModule(void)
{
    napi_module_register(&demoModule);
}