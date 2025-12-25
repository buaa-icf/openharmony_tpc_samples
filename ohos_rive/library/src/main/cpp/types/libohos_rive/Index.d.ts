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

import { image } from '@kit.ImageKit';

declare namespace rive {
  enum RendererType {
    None = -1,
    Rive = 0,
    Canvas = 1
  }

  enum Fit {
    NONE = 0,
    FILL = 1,
    CONTAIN = 2,
    COVER = 3,
    FIT_WIDTH = 4,
    FIT_HEIGHT = 5,
    SCALE_DOWN =6,
    LAYOUT = 7
  }

  enum Alignment {
    TOP_LEFT = 0,
    TOP_CENTER = 1,
    TOP_RIGHT = 2,
    CENTER_LEFT = 3,
    CENTER = 4,
    CENTER_RIGHT = 5,
    BOTTOM_LEFT = 6,
    BOTTOM_CENTER = 7,
    BOTTOM_RIGHT = 8
  }

  interface RiveEnumItem {
    /** 枚举名称 */
    name: string;
    /** 枚举值数组 */

    values: string[];
  }

  interface Bounds {
    left: number;
    top: number;
    right: number;
    bottom: number;
  }

  enum DataType {
    NONE = 0,
    STRING = 1,
    NUMBER = 2,
    BOOLEAN = 3,
    COLOR = 4,
    LIST = 5,
    ENUMTYPE = 6,
    TRIGGER = 7,
    VIEWMODEL = 8,
    INTEGER = 9,
    SYMBOLLISTINDEX = 10,
    ASSETIMAGE = 11,
    ARTBOARD = 12,
    /// Special case, this type is used to indicate it uses the input type.
    INPUT = 99
  }

  interface PropertyData {
    type: DataType;
    name: string;
  }

  export function Napi_FileAssetLoader_constructor(etsObject: object): BigInt;

  export function Napi_FileAssetLoader_cppDelete(loaderPtr: BigInt): void;

  export function Napi_FileAssetLoader_cppRef(loaderPtr: BigInt): void;

  export function Napi_FileAssetLoader_cppSetRendererType(loaderPtr: BigInt, rendererType: RendererType): void;

  export function Napi_Rive_cppInitialize(): void;

  export function Napi_BindableArtboard_cppDelete(bindableArtboardPtr: BigInt): void;

  export function Napi_BindableArtboard_cppName(bindableArtboardPtr: BigInt): string;

  export function Napi_File_import(bytes: ArrayBuffer, rendererType: RendererType, fileAssetLoader?: BigInt): BigInt;

  export function Napi_File_cppEnums(fileRef: BigInt): RiveEnumItem[];

  export function Napi_File_cppArtboardByName(fileRef: BigInt, name: string): BigInt;

  export function Napi_File_cppDelete(fileRef: BigInt): void;

  export function Napi_File_cppArtboardCount(fileRef: BigInt): number;

  export function Napi_File_cppArtboardByIndex(fileRef: BigInt, index: number): BigInt;

  export function Napi_File_cppArtboardNameByIndex(fileRef: BigInt, index: number): string;

  export function Napi_File_cppCreateBindableArtboardByName(fileRef: BigInt, name: string): BigInt;

  export function Napi_File_cppCreateDefaultBindableArtboard(fileRef: BigInt): BigInt;

  export function Napi_File_cppViewModelCount(fileRef: BigInt): number;

  export function Napi_File_cppViewModelByIndex(fileRef: BigInt, index: number): BigInt;

  export function Napi_File_cppViewModelByName(fileRef: BigInt, name: string): BigInt;

  export function Napi_File_cppDefaultViewModelForArtboard(fileRef: BigInt, artboardRef: BigInt): BigInt;

  export function Napi_Rive_cppCalculateRequiredBounds(fit: Fit, alignment: Alignment, availableBounds: Bounds, artboardBounds: Bounds, requiredBounds: Bounds, scaleFactor: number): void;

  export function Napi_Rive_cppRegisterClass(etsObject: object): void;

  export function Napi_Rive_cppRegisterClass(etsObject: object, enumName: string): void;

  export function Napi_Rive_cppUnregisterClass(etsObject: object): void;

  export function Napi_Rive_cppUnregisterClass(etsObject: object, enumName: string): void;

  export function Napi_Font_cppRegisterFallbackFont(array: Uint8Array): boolean;

  export function Napi_Font_cppResetFontCache(): void;

  export function Napi_Renderer_cppConstructor(renderer: object, trace: boolean, type: RendererType): BigInt;

  export function Napi_Renderer_cppDelete(rendererPtr: BigInt): void;

  export function Napi_Renderer_cppStop(rendererPtr: BigInt): void;

  export function Napi_Renderer_cppStart(rendererPtr: BigInt): void;

  export function Napi_Renderer_cppDoFrame(rendererPtr: BigInt): void;

  export function Napi_Renderer_cppSetSurface(rendererPtr: BigInt, surfaceId: BigInt): void;

  export function Napi_Renderer_cppDestroySurface(rendererPtr: BigInt): void;

  export function Napi_Renderer_cppSave(rendererPtr: BigInt): void;

  export function Napi_Renderer_cppRestore(rendererPtr: BigInt): void;

  export function Napi_Renderer_cppAlign(rendererPtr: BigInt, fit: Fit, alignment: Alignment, targetBounds: Bounds, sourceBounds: Bounds, scaleFactor: number): void;

  export function Napi_Renderer_cppTransform(rendererPtr: BigInt, x: number, sy: number, sx: number, y: number, tx: number, ty: number): void;

  export function Napi_Renderer_cppWidth(rendererPtr: BigInt): number;

  export function Napi_Renderer_cppHeight(rendererPtr: BigInt): number;

  export function Napi_Renderer_cppAvgFps(rendererPtr: BigInt): number;

  export function Napi_RiveTextValueRun_cppText(nativePtr: BigInt): string;

  export function Napi_RiveTextValueRun_cppSetText(nativePtr: BigInt, text: string): void;

  export function Napi_FileAsset_cppName(fileAssetPtr: BigInt): string;

  export function Napi_FileAsset_cppUniqueFilename(fileAssetPtr: BigInt): string;

  export function Napi_FileAsset_cppDecode(fileAssetPtr: BigInt, bytes: Uint8Array | number[], rendererType: RendererType): boolean;

  export function Napi_FileAsset_cppCDNUrl(fileAssetPtr: BigInt): string;

  export function Napi_ImageAsset_cppSetRenderImage(imageAssetPtr: BigInt, renderImagePtr: BigInt): void;

  export function Napi_ImageAsset_cppGetRenderImage(imageAssetPtr: BigInt): BigInt;

  export function Napi_ImageAsset_cppImageAssetWidth(imageAssetPtr: BigInt): number;

  export function Napi_ImageAsset_cppImageAssetHeight(imageAssetPtr: BigInt): number;

  export function Napi_RiveRenderImage_cppCreateFromRGBABytes(bytes: Uint8Array | number[], width: number, height: number, rendererType: RendererType, premultiplied: boolean): BigInt;

  export function Napi_RiveRenderImage_cppCreateFromARGBInts(pixels: Uint32Array, width: number, height: number, rendererType: RendererType, premultiplied: boolean): BigInt;

  export function Napi_RiveRenderImage_cppCreateFromBitmap(pixelMap: image.PixelMap, rendererType: RendererType, premultiplied: boolean): BigInt;

  export function Napi_RiveRenderImage_cppDelete(renderImagePtr: BigInt): void;

  export function Napi_FontAsset_cppSetFont(fontAssetPtr: BigInt, fontPtr: BigInt): void;

  export function Napi_FontAsset_cppGetFont(fontAssetPtr: BigInt): BigInt;

  export function Napi_RiveFont_00024Companion_cppMakeFont(bytes: Uint8Array | number[], rendererType: RendererType): BigInt;

  export function Napi_RiveFont_cppDelete(fontPtr: BigInt): void;

  export function Napi_AudioAsset_cppSetAudio(audioAssetPtr: BigInt, audioSourcePtr: BigInt): void;

  export function Napi_AudioAsset_cppGetAudio(audioAssetPtr: BigInt): BigInt;

  export function Napi_RiveAudio_00024Companion_cppMakeAudio(bytes: Uint8Array | number[], rendererType: RendererType): BigInt;

  export function Napi_RiveAudio_cppDelete(audioSourcePtr: BigInt): void;

  export { RendererType, RiveEnumItem };

  export function Napi_Helper_cppConvertToArtboardSpace(touchSpaceRectF: object, touchSpacePointF: object, Fit: Fit, alignment: Alignment, artboardSpaceRectF: object, scaleFactor: number): object;

  export function Napi_StateMachine_cppAdvance(ref: BigInt, elapsedTime: number): boolean;

  export function Napi_StateMachine_cppStateChangedCount(ref: BigInt): number;

  export function Napi_StateMachine_cppStateChangedByIndex(ref: BigInt, index: number): BigInt;

  export function Napi_StateMachine_cppReportedEventCount(ref: BigInt): number;

  export function Napi_StateMachine_cppReportedEventAt(ref: BigInt, index: number): object;

  export function Napi_StateMachine_cppSMIInputByIndex(ref: BigInt, index: number): BigInt;

  export function Napi_StateMachine_cppInputCount(ref: BigInt): number;

  export function Napi_StateMachine_cppName(ref: BigInt): string;

  export function Napi_StateMachine_cppLayerCount(ref: BigInt): number;

  export function Napi_StateMachine_cppPointerDown(ref: BigInt, pointerID: number, x: number, y: number): void;

  export function Napi_StateMachine_cppPointerMove(ref: BigInt, pointerID: number, x: number, y: number): void;

  export function Napi_StateMachine_cppPointerUp(ref: BigInt, pointerID: number, x: number, y: number): void;

  export function Napi_StateMachine_cppPointerExit(ref: BigInt, pointerID: number, x: number, y: number): void;

  export function Napi_StateMachine_cppSetViewModelInstance(ref: BigInt, viewModelInstanceRef: BigInt): void;

  export function Napi_StateMachine_cppDelete(ref: BigInt): void;

  export function Napi_SMI_cppSMIInputName(ref: BigInt): string;

  export function Napi_SMI_cppSMIInputIsBoolean(ref: BigInt): boolean;

  export function Napi_SMI_cppSMIInputIsNumber(ref: BigInt): boolean;

  export function Napi_SMI_cppSMIInputIsTrigger(ref: BigInt): boolean;

  export function Napi_SMI_cppSMIBoolValue(ref: BigInt): boolean;

  export function Napi_SMI_cppSMIBoolSetValue(ref: BigInt, value: boolean): void;

  export function Napi_SMI_cppSMINumberValue(ref: BigInt): number;

  export function Napi_SMI_cppSMINumberSetValue(ref: BigInt, value: number): void;

  export function Napi_SMI_cppSMITriggerFire(ref: BigInt): void;

  export function Napi_ViewModel_cppName(ref: BigInt): string;

  export function Napi_ViewModel_instanceCount(ref: BigInt): number;

  export function Napi_ViewModel_propertyCount(ref: BigInt): number;

  export function Napi_ViewModel_getProperties(ref: BigInt): PropertyData[];

  export function Napi_ViewModel_createBlankInstance(ref: BigInt): BigInt;

  export function Napi_ViewModel_createDefaultInstance(ref: BigInt): BigInt;

  export function Napi_ViewModel_createInstanceFromIndex(ref: BigInt, index: number): BigInt;

  export function Napi_ViewModel_createInstanceFromName(ref: BigInt, name: string): BigInt;

  export function Napi_LinearAnimationInstance_cppAdvance(ref: BigInt, elapsedTime: number): number;

  export function Napi_LinearAnimationInstance_cppAdvanceAndGetResult(ref: BigInt, elapsedTime: number): number;

  export function Napi_LinearAnimationInstance_cppApply(ref: BigInt, mix: number): void;

  export function Napi_LinearAnimationInstance_cppGetTime(ref: BigInt): number;

  export function Napi_LinearAnimationInstance_cppSetTime(ref: BigInt, time: number): void;

  export function Napi_LinearAnimationInstance_cppSetDirection(ref: BigInt, direction: number): void;

  export function Napi_LinearAnimationInstance_cppGetDirection(ref: BigInt): number;

  export function Napi_LinearAnimationInstance_cppGetLoop(ref: BigInt): number;

  export function Napi_LinearAnimationInstance_cppSetLoop(ref: BigInt, loop: number): void;

  export function Napi_LinearAnimationInstance_cppName(ref: BigInt): string;

  export function Napi_LinearAnimationInstance_cppDuration(ref: BigInt): number;

  export function Napi_LinearAnimationInstance_cppFps(ref: BigInt): number;

  export function Napi_LinearAnimationInstance_cppWorkStart(ref: BigInt): number;

  export function Napi_LinearAnimationInstance_cppWorkEnd(ref: BigInt): number;

  export function Napi_LinearAnimationInstance_cppDelete(ref: BigInt): void;

  export function Napi_Artboard_cppName(artboardRef: BigInt): string;

  export function Napi_Artboard_animationNameByIndex(artboardRef: BigInt, index: number): string;

  export function Napi_Artboard_stateMachineNameByIndex(artboardRef: BigInt, index: number): string;

  export function Napi_Artboard_animationByIndex(artboardRef: BigInt, index: number): BigInt;

  export function Napi_Artboard_animationByName(artboardRef: BigInt, name: string): BigInt;

  export function Napi_Artboard_animationCount(artboardRef: BigInt): number;

  export function Napi_Artboard_stateMachineByIndex(artboardRef: BigInt, index: number): BigInt;

  export function Napi_Artboard_stateMachineByName(artboardRef: BigInt, name: string): BigInt;

  export function Napi_Artboard_stateMachineCount(artboardRef: BigInt): number;

  export function Napi_Artboard_inputByNameAtPath(artboardRef: BigInt, inputName: string, inputPath: string): BigInt;

  export function Napi_Artboard_getVolume(artboardRef: BigInt): number;

  export function Napi_Artboard_setVolume(artboardRef: BigInt, volume: number): void;

  export function Napi_Artboard_findTextValueRun(artboardRef: BigInt, name: string): BigInt;

  export function Napi_Artboard_findValueOfTextValueRun(artboardRef: BigInt, name: string): string;

  export function Napi_Artboard_setValueOfTextValueRun(artboardRef: BigInt, name: string, newValue: string): void;

  export function Napi_Artboard_findTextValueRunAtPath(artboardRef: BigInt, name: string, path: string): BigInt;

  export function Napi_Artboard_findValueOfTextValueRunAtPath(artboardRef: BigInt, name: string, path: string): string;

  export function Napi_Artboard_setValueOfTextValueRunAtPath(artboardRef: BigInt, name: string, newValue: string, path: string): void;

  export function Napi_Artboard_advance(artboardPtr: BigInt, elapsedTime: number): boolean;

  export function Napi_Artboard_bounds(artboardPtr: BigInt): Bounds;

  export function Napi_Artboard_resetArtboardSize(artboardPtr: BigInt): void;

  export function Napi_Artboard_getArtboardWidth(artboardPtr: BigInt): number;

  export function Napi_Artboard_setArtboardWidth(artboardPtr: BigInt, width: number): void;

  export function Napi_Artboard_getArtboardHeight(artboardPtr: BigInt): number;

  export function Napi_Artboard_setArtboardHeight(artboardPtr: BigInt, height: number): void;

  export function Napi_Artboard_setViewModelInstance(artboardPtr: BigInt, viewModelInstancePtr: BigInt): void;

  export function Napi_Artboard_draw(artboardPtr: BigInt, rendererPtr: BigInt): void;

  export function Napi_Artboard_drawAligned(artboardPtr: BigInt, rendererPtr: BigInt, fit: Fit, alignment: Alignment, scaleFactor: number): void;

  export function Napi_Artboard_delete(artboardPtr: BigInt): void;

  export function Napi_ViewModelInstance_propertyNumber(viewModelInstanceRef: BigInt, propertyPath: string): BigInt;

  export function Napi_ViewModelInstance_propertyString(viewModelInstanceRef: BigInt, propertyPath: string): BigInt;

  export function Napi_ViewModelInstance_propertyTrigger(viewModelInstanceRef: BigInt, propertyPath: string): BigInt;

  export function Napi_ViewModelInstance_propertyBoolean(viewModelInstanceRef: BigInt, propertyPath: string): BigInt;

  export function Napi_ViewModelInstance_propertyColor(viewModelInstanceRef: BigInt, propertyPath: string): BigInt;

  export function Napi_ViewModelInstance_propertyEnum(viewModelInstanceRef: BigInt, propertyPath: string): BigInt;

  export function Napi_ViewModelInstance_propertyImage(viewModelInstanceRef: BigInt, propertyPath: string): BigInt;

  export function Napi_ViewModelInstance_propertyList(viewModelInstanceRef: BigInt, propertyPath: string): BigInt;

  export function Napi_ViewModelInstance_propertyArtboard(viewModelInstanceRef: BigInt, propertyPath: string): BigInt;

  export function Napi_ViewModelInstance_refInstance(viewModelInstanceRef: BigInt): void;

  export function Napi_ViewModelInstance_derefInstance(viewModelInstanceRef: BigInt): void;

  export function Napi_ViewModelBooleanProperty_setValue(propertyRef: BigInt, boolValue: boolean): void;

  export function Napi_ViewModelBooleanProperty_getValue(propertyRef: BigInt): boolean;

  export function Napi_ViewModelStringProperty_setValue(propertyRef: BigInt, stringValue: string): void;

  export function Napi_ViewModelNumberProperty_setValue(propertyRef: BigInt, numValue: number): void;

  export function Napi_ViewModelNumberProperty_getValue(propertyRef: BigInt): number;

  export function Napi_ViewModelStringProperty_getValue(propertyRef: BigInt): string;

  export function Napi_ViewModelColorProperty_setValue(propertyRef: BigInt, colorValue: number): void;

  export function Napi_ViewModelColorProperty_getValue(propertyRef: BigInt): number;

  export function Napi_ViewModelEnumProperty_setValue(propertyRef: BigInt, enumValue: string): void;

  export function Napi_ViewModelEnumProperty_getValue(propertyRef: BigInt): string;

  export function Napi_ViewModelImageProperty_setValue(propertyRef: BigInt, imageRef: BigInt): void;

  export function Napi_ViewModelTriggerProperty_trigger(propertyRef: BigInt): void;

  export function Napi_ViewModelInstance_cppName(viewModelInstanceRef: BigInt): string;

  export function Napi_ViewModelProperty_cppName(propertyRef: BigInt): string;

  export function Napi_ViewModelProperty_hasChanged(propertyRef: BigInt): boolean;

  export function Napi_ViewModelProperty_flushChanges(propertyRef: BigInt): boolean;

  export function Napi_ViewModelListProperty_size(propertyRef: BigInt): number;

  export function Napi_ViewModelListProperty_add(propertyRef: BigInt, itemRef: BigInt): void;

  export function Napi_ViewModelListProperty_addAt(propertyRef: BigInt, index: number, itemRef: BigInt): void;

  export function Napi_ViewModelListProperty_elementAt(propertyRef: BigInt, index: number): BigInt;

  export function Napi_ViewModelListProperty_swap(propertyRef: BigInt, indexA: number, indexB: number): void;

  export function Napi_ViewModelListProperty_remove(propertyRef: BigInt, itemRef: BigInt): void;

  export function Napi_ViewModelListProperty_removeAt(propertyRef: BigInt, index: number): void;

  export function Napi_ViewModelArtboardProperty_setArtboard(propertyRef: BigInt, fileRef: BigInt, artboardRef: BigInt): void;

  export function Napi_ViewModelArtboardProperty_setBindableArtboard(propertyRef: BigInt, bindableArtboardRef: BigInt): void;

  export function Napi_ViewModelInstance_propertyInstance(propertyRef: BigInt, propertyPath: string): BigInt;

  export function Napi_ViewModelInstance_setInstanceProperty(viewModelInstanceRef: BigInt, propertyPath: string, propertyRef: BigInt): boolean;

  export function Napi_RiveOpenURLEvent_cppURL(ref: BigInt): string;

  export function Napi_RiveOpenURLEvent_cppTarget(ref: BigInt): string;

  export function Napi_RiveEvent_cppName(ref: BigInt): string;

  export function Napi_RiveEvent_cppType(ref: BigInt): number;
  
  export function Napi_RiveEvent_cppData(ref: BigInt): object;

  export function Napi_RiveEvent_cppProperties(ref: BigInt): object;

  export function Napi_CommandQueue_cppGetEglDisplay(): BigInt;

  export function Napi_CommandQueue_cppCreateEglContext(display: BigInt): BigInt;

  export function Napi_CommandQueue_cppDeleteEglContext(egldisplay: BigInt, eglcontext: BigInt): void;

  export function Napi_CommandQueue_cppCreateEglSurface(egldisplay: BigInt, eglcontext: BigInt): BigInt;

  export function Napi_CommandQueue_constructor(egldisplay: BigInt, eglcontext: BigInt): BigInt;

  export function Napi_CommandQueue_cppDelete(commandqueue: BigInt): void;

  export function Napi_CommandQueue_cppCreateRenderTarget(width: number, height: number): BigInt;

  export function Napi_CommandQueue_cppDeleteRiveSurface(renderTarget: BigInt): void;

  export function Napi_CommandQueue_cppLoadFile(commandqueue: BigInt, requestID: number,
    fileArrayBuffer: ArrayBuffer): BigInt;

  export function Napi_CommandQueue_cppDeleteFile(commandqueue: BigInt, requestID: number,
    fileHandle: BigInt): void;

  export function Napi_CommandQueue_cppCreateDefaultArtboard(commandqueue: BigInt, requestID: number,
    artboardHandle: BigInt): BigInt;

  export function Napi_CommandQueue_cppCreateArtboardByName(commandqueue: BigInt, requestID: number,
    fileHandle: BigInt, name: string): BigInt;

  export function Napi_CommandQueue_cppGetArtboardNames(commandqueue: BigInt, requestID: number,
    fileHandle: BigInt): void;

  export function Napi_CommandQueue_cppDeleteArtboard(commandqueue: BigInt, requestID: number,
    artboardHandle: BigInt): void;

  export function Napi_CommandQueue_cppCreateDefaultStateMachine(commandqueue: BigInt, requestID: number,
    artboardHandle: BigInt): BigInt;

  export function Napi_CommandQueue_cppCreateStateMachineByName(commandqueue: BigInt, requestID: number,
    artboardHandle: BigInt, name: string): BigInt;

  export function Napi_CommandQueue_cppDeleteStateMachine(commandqueue: BigInt, requestID: number,
    stateMachineHandle: BigInt): void;

  export function Napi_CommandQueue_cppAdvanceStateMachine(commandqueue: BigInt, stateMachineHandle: BigInt,
    deltaTimeNs: number): void;

  export function Napi_CommandQueue_cppDeleteViewModelInstance(commandqueue: BigInt, requestID: number,
    viewModelHandle: BigInt): void;

  export function Napi_CommandQueue_cppDecodeFont(commandqueue: BigInt, requestID: number, bytes: ArrayBuffer): BigInt;

  export function Napi_CommandQueue_cppDeleteFont(commandqueue: BigInt, fontHandle: BigInt): void;

  export function Napi_CommandQueue_cppRegisterFont(commandqueue: BigInt, path: string, fontHandle: BigInt): void;

  export function Napi_CommandQueue_cppUnregisterFont(commandqueue: BigInt, path: string): void;

  export function Napi_CommandQueue_cppDeleteImage(commandqueue: BigInt, imageHandle: BigInt): void;

  export function Napi_CommandQueue_cppGetStateMachineNames(commandqueue: BigInt, requestID: number,
    artboardHandle: BigInt): void;

  export function Napi_CommandQueue_cppGetViewModelNames(commandqueue: BigInt, requestID: number,
    fontHandle: BigInt): void;

  export function Napi_CommandQueue_cppGetViewModelInstanceNames(commandqueue: BigInt, requestID: number,
    fontHandle: BigInt, name: string): void;

  export function Napi_CommandQueue_cppGetViewModelProperties(commandqueue: BigInt, requestID: number,
    fontHandle: BigInt, name: string): void;

  export function Napi_CommandQueue_cppGetEnums(commandqueue: BigInt, requestID: number,
    fontHandle: BigInt): void;

  export function Napi_CommandQueue_cppNamedVMCreateBlankVMI(commandqueue: BigInt, requestID: number,
      fileHandle: BigInt, viewModelName: string): BigInt

  export function Napi_CommandQueue_cppDefaultVMCreateBlankVMI(commandqueue: BigInt, requestID: number,
    fileHandle: BigInt, artboardHandle: BigInt): BigInt

  export function Napi_CommandQueue_cppNamedVMCreateDefaultVMI(commandqueue: BigInt, requestID: number,
    fileHandle: BigInt, viewModelName: string): BigInt

  export function Napi_CommandQueue_cppDefaultVMCreateDefaultVMI(commandqueue: BigInt, requestID: number,
    fileHandle: BigInt, artboardHandle: BigInt): BigInt

  export function Napi_CommandQueue_cppNamedVMCreateNamedVMI(commandqueue: BigInt, requestID: number,
    fileHandle: BigInt, viewModelName: string, instanceName: string): BigInt

  export function Napi_CommandQueue_cppDefaultVMCreateNamedVMI(commandqueue: BigInt, requestID: number,
    fileHandle: BigInt, artboardHandle: BigInt, instanceName: string): BigInt

  export function Napi_CommandQueue_cppReferenceNestedVMI(commandqueue: BigInt, requestID: number,
    viewModelInstanceHandle: BigInt, pathLength: string): BigInt

  export function Napi_CommandQueue_cppBindViewModelInstance(commandqueue: BigInt, requestID: number,
  stateMachin: BigInt, viewModelInstanceHandle: BigInt): void

  export function Napi_CommandQueue_cppSetNumberProperty(commandqueue: BigInt, viewModelInstanceHandle: BigInt,
    pathLength: string, value: number): void

  export function Napi_CommandQueue_cppGetNumberProperty(commandqueue: BigInt, requestID: number,
    viewModelInstanceHandle: BigInt, pathLength: string): void

  export function Napi_CommandQueue_cppSetStringProperty(commandqueue: BigInt, viewModelInstanceHandle: BigInt,
     pathLength: string, valueLength: string): void

  export function Napi_CommandQueue_cppGetStringProperty(commandqueue: BigInt, requestID: number,
    viewModelInstanceHandle: BigInt, pathLength: string): void

  export function Napi_CommandQueue_cppSetBooleanProperty(commandqueue: number, viewModelInstanceHandle: number,
    pathLength: string, value: boolean): void

  export function Napi_CommandQueue_cppGetBooleanProperty(commandqueue: BigInt, requestID: number,
    viewModelInstanceHandle: BigInt, pathLength: string): void

  export function Napi_CommandQueue_cppSetEnumProperty(commandqueue: BigInt, viewModelInstanceHandle: BigInt,
  pathLength: string, valueLength: string): void

  export function Napi_CommandQueue_cppGetEnumProperty(commandqueue: BigInt, requestID: number,
    viewModelInstanceHandle: BigInt, pathLength: string): void

  export function Napi_CommandQueue_cppSetColorProperty(commandqueue: number, viewModelInstanceHandle: number,
    pathLength: string, colorValue: number): void

  export function Napi_CommandQueue_cppGetColorProperty(commandqueue: BigInt, requestID: number,
    viewModelInstanceHandle: BigInt, pathLength: string): void

  export function Napi_CommandQueue_cppFireTriggerProperty(commandqueue: BigInt, viewModelInstanceHandle: BigInt,
    pathLength: string): void

  export function Napi_CommandQueue_cppSubscribeToProperty(commandqueue: BigInt, viewModelInstanceHandle: BigInt,
    pathLength: string, propertyType: number): void

  export function Napi_CommandQueue_cppUnsubscribeFromProperty(commandqueue: BigInt, viewModelInstanceHandle: BigInt,
    pathLength: string, propertyType: number): void

  export function Napi_CommandQueue_cppDecodeImage(commandqueue: BigInt, requestID: BigInt, bytes: ArrayBuffer): void

  export function Napi_CommandQueue_cppRegisterImage(commandqueue: BigInt, pathLength: string,
    imageHandle: BigInt): void

  export function Napi_CommandQueue_cppUnregisterImage(commandqueue: BigInt, pathLength: string): void

  export function Napi_CommandQueue_cppDecodeAudio(commandqueue: BigInt, requestID: number, bytes: ArrayBuffer): void

  export function Napi_CommandQueue_cppDeleteAudio(commandqueue: BigInt, audioHandle: BigInt): void

  export function Napi_CommandQueue_cppRegisterAudio(commandqueue: BigInt, pathLength: string,
    audioHandle: BigInt): void

  export function Napi_CommandQueue_cppUnregisterAudio(commandqueue: BigInt, pathLength: string): void

  export function Napi_CommandQueue_cppPointerDown(commandQueue: BigInt, stateMachineHandle: BigInt, fit: Fit, alignment: Alignment,
    surfaceWidth: number, surfaceHeight: number, pointerID: number, x: number, y: number): void;

  export function Napi_CommandQueue_cppPointerMove(commandQueue: BigInt, stateMachineHandle: BigInt, fit: Fit, alignment: Alignment,
    surfaceWidth: number, surfaceHeight: number, pointerID: number, x: number, y: number): void;

  export function Napi_CommandQueue_cppPointerUp(commandQueue: BigInt, stateMachineHandle: BigInt, fit: Fit, alignment: Alignment,
    surfaceWidth: number, surfaceHeight: number, pointerID: number, x: number, y: number): void;

  export function Napi_CommandQueue_cppPointerExit(commandQueue: BigInt, stateMachineHandle: BigInt, fit: Fit, alignment: Alignment,
    surfaceWidth: number, surfaceHeight: number, pointerID: number, x: number, y: number): void;

  export function Napi_CommandQueue_cppCreateDrawKey(commandqueue: BigInt): BigInt;

  export function Napi_CommandQueue_cppPollMessages(commandqueue: BigInt): void;

  export function Napi_CommandQueue_cppDraw(commandqueue: BigInt, eglDisplay:BigInt, eglSurface: BigInt, eglContext:BigInt,
    drawKey: BigInt, artboardHandle: BigInt, stateMachineHandle: BigInt, renderTarget: BigInt,
    width: number, height: number, fit: Fit, alignment: Alignment, ohosClearColor: number): void;

  export function Napi_CommandQueue_cppCreateListeners(commandqueue: BigInt, jsCommandQueue: number): object;

  export function Napi_CommandQueue_cppDeleteListeners(fileListenerRef: BigInt, artboardListenerRef: BigInt,
    stateMachineListenerRef: BigInt, viewModelInstanceListenerRef: BigInt, imageListenerRef: BigInt,
    audioListenerRef: BigInt, fontListenerRef: BigInt): void

  export function Napi_LayerState_cppIsExitState(layerStateRef: BigInt): boolean;

  export function Napi_LayerState_cppIsAnyState(layerStateRef: BigInt): boolean;

  export function Napi_LayerState_cppIsEntryState(layerStateRef: BigInt): boolean;

  export function Napi_LayerState_cppIsAnimationState(layerStateRef: BigInt): boolean;

  export function Napi_LayerState_cppIsBlendState(layerStateRef: BigInt): boolean;

  export function Napi_LayerState_cppIsBlendState1D(layerStateRef: BigInt): boolean;

  export function Napi_LayerState_cppIsBlendStateDirect(layerStateRef: BigInt): boolean;

  export function Napi_AnimationState_cppName(animationStateRef: BigInt): string;


  export { Fit, Alignment, Bounds };
}

export default rive;