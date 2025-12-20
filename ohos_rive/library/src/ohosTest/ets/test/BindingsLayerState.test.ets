import { hilog } from '@kit.PerformanceAnalysisKit';
import AbilityDelegatorRegistry from '@ohos.app.ability.abilityDelegatorRegistry'
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect } from '@ohos/hypium';
import rive from 'libohos_rive.so'
import { FallbackAssetLoader } from '../../../main/ets/runtime/core/FileAssetLoader';

function getContext(): Context {
  let abilityDelegator = AbilityDelegatorRegistry.getAbilityDelegator();
  let context = abilityDelegator.getAppContext();
  return context;
}

export default function bindingsLayerStateTest() {
  describe('BindingsLayerStateTest', () => {
    beforeAll(() => {
      // Presets an action, which is performed only once before all test cases of the test suite start.
    })
    beforeEach(() => {
      // Presets an action, which is performed before each unit test case starts.
    })
    afterEach(() => {
      // Presets a clear action, which is performed after each unit test case ends.
    })
    afterAll(() => {
      // Presets a clear action, which is performed after all test cases of the test suite end.
    })

    it('LayerState_Test_IsExitState', 0, async (done: Function) => {
      let context = getContext();
      const resourceManager = context.resourceManager;
      const rawFile = await resourceManager.getRawFileContent('what_a_state.riv');
      expect(rawFile.byteLength != 0).assertTrue();
      const arrayBuffer = rawFile.buffer.slice(0);
      let fileAssetLoader: FallbackAssetLoader = new FallbackAssetLoader(context, true, null);
      expect(fileAssetLoader != null).assertTrue();
      let filePtr = rive.Napi_File_import(arrayBuffer, rive.RendererType.Rive, fileAssetLoader.getNativePtr());
      expect(filePtr != 0).assertTrue();
      const artboardName = rive.Napi_File_cppArtboardNameByIndex(filePtr, 0);
      expect(artboardName != '').assertTrue();
      const artboardPtr = rive.Napi_File_cppArtboardByName(filePtr, artboardName);
      expect(artboardPtr != 0).assertTrue();
      const stateMachineInstanceRef = rive.Napi_Artboard_stateMachineByIndex(artboardPtr, 0);
      expect(stateMachineInstanceRef != 0).assertTrue();
      const result1 = rive.Napi_StateMachine_cppAdvance(stateMachineInstanceRef, 0);
      expect(result1 == true).assertTrue();
      const result2 = rive.Napi_StateMachine_cppAdvance(stateMachineInstanceRef, 2);
      expect(result2 == true).assertTrue();
      const stateChangedCount = rive.Napi_StateMachine_cppStateChangedCount(stateMachineInstanceRef);
      expect(stateChangedCount >= 0).assertTrue();
      if (stateChangedCount > 0) {
        const layerStatePtr = rive.Napi_StateMachine_cppStateChangedByIndex(stateMachineInstanceRef, 0);
        expect(layerStatePtr != 0).assertTrue();
        const isExitState = rive.Napi_LayerState_cppIsExitState(layerStatePtr);
        expect(isExitState).assertTrue();
        const isAnyState = rive.Napi_LayerState_cppIsAnyState(layerStatePtr);
        expect(isAnyState).assertFalse();
        const isEntryState = rive.Napi_LayerState_cppIsEntryState(layerStatePtr);
        expect(isEntryState).assertFalse();
        const isAnimationState = rive.Napi_LayerState_cppIsAnimationState(layerStatePtr);
        expect(isAnimationState).assertFalse();
        const isBlendState = rive.Napi_LayerState_cppIsBlendState(layerStatePtr);
        expect(isBlendState).assertFalse();
        const isBlend1DState = rive.Napi_LayerState_cppIsBlendState1D(layerStatePtr);
        expect(isBlend1DState).assertFalse();
        const isBlendDirectState = rive.Napi_LayerState_cppIsBlendStateDirect(layerStatePtr);
        expect(isBlendDirectState).assertFalse();
      }
      rive.Napi_File_cppDelete(filePtr);
      done();
    })

    it('LayerState_Test_IsBlendState', 0, async (done: Function) => {
      let context = getContext();
      const resourceManager = context.resourceManager;
      const rawFile = await resourceManager.getRawFileContent('blend_state.riv');
      expect(rawFile.byteLength != 0).assertTrue();
      const arrayBuffer = rawFile.buffer.slice(0);
      let fileAssetLoader: FallbackAssetLoader = new FallbackAssetLoader(context, true, null);
      expect(fileAssetLoader != null).assertTrue();
      let filePtr = rive.Napi_File_import(arrayBuffer, rive.RendererType.Rive, fileAssetLoader.getNativePtr());
      expect(filePtr != 0).assertTrue();
      const artboardName = rive.Napi_File_cppArtboardNameByIndex(filePtr, 0);
      expect(artboardName != '').assertTrue();
      const artboardPtr = rive.Napi_File_cppArtboardByName(filePtr, artboardName);
      expect(artboardPtr != 0).assertTrue();
      const stateMachineInstanceRef = rive.Napi_Artboard_stateMachineByIndex(artboardPtr, 0);
      expect(stateMachineInstanceRef != 0).assertTrue();
      const inputCount = rive.Napi_StateMachine_cppInputCount(stateMachineInstanceRef);
      let blendMixInputFound = false;
      for (let i = 0; i < inputCount; i++) {
        const input = rive.Napi_StateMachine_cppSMIInputByIndex(stateMachineInstanceRef, i);
        const inputName = rive.Napi_SMI_cppSMIInputName(input);
        // 查找名为"left"的输入
        if (inputName && inputName.includes("left")) {
          const isTrigger = rive.Napi_SMI_cppSMIInputIsTrigger(input);
          if (isTrigger) {
            rive.Napi_SMI_cppSMITriggerFire(input);  // 触发输入
            blendMixInputFound = true;
            break;
          }
        }
      }
      expect(blendMixInputFound).assertTrue();
      const result = rive.Napi_StateMachine_cppAdvance(stateMachineInstanceRef, 0);
      expect(result == true).assertTrue();
      const stateChangedCount = rive.Napi_StateMachine_cppStateChangedCount(stateMachineInstanceRef);
      expect(stateChangedCount >= 1).assertTrue();
      if (stateChangedCount > 0) {
        const layerStatePtr = rive.Napi_StateMachine_cppStateChangedByIndex(stateMachineInstanceRef, 0);
        expect(layerStatePtr != 0).assertTrue();
        const isExitState = rive.Napi_LayerState_cppIsExitState(layerStatePtr);
        expect(isExitState).assertFalse();
        const isAnyState = rive.Napi_LayerState_cppIsAnyState(layerStatePtr);
        expect(isAnyState).assertFalse();
        const isEntryState = rive.Napi_LayerState_cppIsEntryState(layerStatePtr);
        expect(isEntryState).assertFalse();
        const isAnimationState = rive.Napi_LayerState_cppIsAnimationState(layerStatePtr);
        expect(isAnimationState).assertFalse();
        const isBlendState = rive.Napi_LayerState_cppIsBlendState(layerStatePtr);
        expect(isBlendState).assertTrue();
        const isBlend1DState = rive.Napi_LayerState_cppIsBlendState1D(layerStatePtr);
        expect(isBlend1DState).assertTrue();
        const isBlendDirectState = rive.Napi_LayerState_cppIsBlendStateDirect(layerStatePtr);
        expect(isBlendDirectState).assertFalse();
      }
      rive.Napi_File_cppDelete(filePtr);
      done();
    })

    it('LayerState_Test_IsBlendStateDirect', 0, async (done: Function) => {
      let context = getContext();
      const resourceManager = context.resourceManager;
      const rawFile = await resourceManager.getRawFileContent('blend_state.riv');
      expect(rawFile.byteLength != 0).assertTrue();
      const arrayBuffer = rawFile.buffer.slice(0);
      let fileAssetLoader: FallbackAssetLoader = new FallbackAssetLoader(context, true, null);
      expect(fileAssetLoader != null).assertTrue();
      let filePtr = rive.Napi_File_import(arrayBuffer, rive.RendererType.Rive, fileAssetLoader.getNativePtr());
      expect(filePtr != 0).assertTrue();
      const artboardName = rive.Napi_File_cppArtboardNameByIndex(filePtr, 0);
      expect(artboardName != '').assertTrue();
      const artboardPtr = rive.Napi_File_cppArtboardByName(filePtr, artboardName);
      expect(artboardPtr != 0).assertTrue();
      const stateMachineInstanceRef = rive.Napi_Artboard_stateMachineByIndex(artboardPtr, 0);
      expect(stateMachineInstanceRef != 0).assertTrue();
      const inputCount = rive.Napi_StateMachine_cppInputCount(stateMachineInstanceRef);
      let blendMixInputFound = false;
      for (let i = 0; i < inputCount; i++) {
        const input = rive.Napi_StateMachine_cppSMIInputByIndex(stateMachineInstanceRef, i);
        const inputName = rive.Napi_SMI_cppSMIInputName(input);
        // 查找名为"right"的输入
        if (inputName && inputName.includes("right")) {
          const isTrigger = rive.Napi_SMI_cppSMIInputIsTrigger(input);
          if (isTrigger) {
            rive.Napi_SMI_cppSMITriggerFire(input);  // 触发输入
            blendMixInputFound = true;
            break;
          }
        }
      }
      expect(blendMixInputFound).assertTrue();
      const result = rive.Napi_StateMachine_cppAdvance(stateMachineInstanceRef, 0);
      expect(result == true).assertTrue();
      const stateChangedCount = rive.Napi_StateMachine_cppStateChangedCount(stateMachineInstanceRef);
      expect(stateChangedCount >= 1).assertTrue();
      if (stateChangedCount > 0) {
        const layerStatePtr = rive.Napi_StateMachine_cppStateChangedByIndex(stateMachineInstanceRef, 0);
        expect(layerStatePtr != 0).assertTrue();
        const isExitState = rive.Napi_LayerState_cppIsExitState(layerStatePtr);
        expect(isExitState).assertFalse();
        const isAnyState = rive.Napi_LayerState_cppIsAnyState(layerStatePtr);
        expect(isAnyState).assertFalse();
        const isEntryState = rive.Napi_LayerState_cppIsEntryState(layerStatePtr);
        expect(isEntryState).assertFalse();
        const isAnimationState = rive.Napi_LayerState_cppIsAnimationState(layerStatePtr);
        expect(isAnimationState).assertFalse();
        const isBlendState = rive.Napi_LayerState_cppIsBlendState(layerStatePtr);
        expect(isBlendState).assertTrue();
        const isBlend1DState = rive.Napi_LayerState_cppIsBlendState1D(layerStatePtr);
        expect(isBlend1DState).assertFalse();
        const isBlendDirectState = rive.Napi_LayerState_cppIsBlendStateDirect(layerStatePtr);
        expect(isBlendDirectState).assertTrue();
      }
      rive.Napi_File_cppDelete(filePtr);
      done();
    })

    it('LayerState_Test_IsAnimationState', 0, async (done: Function) => {
      let context = getContext();
      const resourceManager = context.resourceManager;
      const rawFile = await resourceManager.getRawFileContent('multiple_state_machines.riv');
      expect(rawFile.byteLength != 0).assertTrue();
      const arrayBuffer = rawFile.buffer.slice(0);
      let fileAssetLoader: FallbackAssetLoader = new FallbackAssetLoader(context, true, null);
      expect(fileAssetLoader != null).assertTrue();
      let filePtr = rive.Napi_File_import(arrayBuffer, rive.RendererType.Rive, fileAssetLoader.getNativePtr());
      expect(filePtr != 0).assertTrue();
      const artboardName = rive.Napi_File_cppArtboardNameByIndex(filePtr, 0);
      expect(artboardName != '').assertTrue();
      const artboardPtr = rive.Napi_File_cppArtboardByName(filePtr, artboardName);
      expect(artboardPtr != 0).assertTrue();
      const stateMachineInstanceRef = rive.Napi_Artboard_stateMachineByIndex(artboardPtr, 0);
      expect(stateMachineInstanceRef != 0).assertTrue();
      const elapsedTime = 0.16; // 约16ms，相当于60fps的一帧
      const result = rive.Napi_StateMachine_cppAdvance(stateMachineInstanceRef, elapsedTime);
      expect(result == true).assertTrue();
      const stateChangedCount = rive.Napi_StateMachine_cppStateChangedCount(stateMachineInstanceRef);
      expect(stateChangedCount >= 0).assertTrue();
      if (stateChangedCount > 0) {
        const layerStatePtr = rive.Napi_StateMachine_cppStateChangedByIndex(stateMachineInstanceRef, 0);
        expect(layerStatePtr != 0).assertTrue();
        const isExitState = rive.Napi_LayerState_cppIsExitState(layerStatePtr);
        expect(isExitState).assertFalse();
        const isAnyState = rive.Napi_LayerState_cppIsAnyState(layerStatePtr);
        expect(isAnyState).assertFalse();
        const isEntryState = rive.Napi_LayerState_cppIsEntryState(layerStatePtr);
        expect(isEntryState).assertFalse();
        const isAnimationState = rive.Napi_LayerState_cppIsAnimationState(layerStatePtr);
        expect(isAnimationState).assertTrue();
        const isBlendState = rive.Napi_LayerState_cppIsBlendState(layerStatePtr);
        expect(isBlendState).assertFalse();
        const isBlend1DState = rive.Napi_LayerState_cppIsBlendState1D(layerStatePtr);
        expect(isBlend1DState).assertFalse();
        const isBlendDirectState = rive.Napi_LayerState_cppIsBlendStateDirect(layerStatePtr);
        expect(isBlendDirectState).assertFalse();
        const animationName = rive.Napi_AnimationState_cppName(layerStatePtr);
        expect(animationName != null).assertTrue();
        expect(animationName != 'Unknown').assertTrue();
      }
      rive.Napi_File_cppDelete(filePtr);
      done();
    })

    it('LayerState_Test_EmptyAnimationState', 0, async (done: Function) => {
      let context = getContext();
      const resourceManager = context.resourceManager;
      const rawFile = await resourceManager.getRawFileContent('empty_animation_state.riv');
      expect(rawFile.byteLength != 0).assertTrue();
      const arrayBuffer = rawFile.buffer.slice(0);
      let fileAssetLoader: FallbackAssetLoader = new FallbackAssetLoader(context, true, null);
      expect(fileAssetLoader != null).assertTrue();
      let filePtr = rive.Napi_File_import(arrayBuffer, rive.RendererType.Rive, fileAssetLoader.getNativePtr());
      expect(filePtr != 0).assertTrue();
      const artboardName = rive.Napi_File_cppArtboardNameByIndex(filePtr, 0);
      expect(artboardName != '').assertTrue();
      const artboardPtr = rive.Napi_File_cppArtboardByName(filePtr, artboardName);
      expect(artboardPtr != 0).assertTrue();
      const stateMachineInstanceRef = rive.Napi_Artboard_stateMachineByIndex(artboardPtr, 0);
      expect(stateMachineInstanceRef != 0).assertTrue();
      const elapsedTime = 0.16; // 约16ms，相当于60fps的一帧
      const result = rive.Napi_StateMachine_cppAdvance(stateMachineInstanceRef, elapsedTime);
      expect(result == true).assertTrue();
      const stateChangedCount = rive.Napi_StateMachine_cppStateChangedCount(stateMachineInstanceRef);
      expect(stateChangedCount >= 0).assertTrue();
      if (stateChangedCount > 0) {
        const layerStatePtr = rive.Napi_StateMachine_cppStateChangedByIndex(stateMachineInstanceRef, 0);
        expect(layerStatePtr != 0).assertTrue();
        const isExitState = rive.Napi_LayerState_cppIsExitState(layerStatePtr);
        expect(isExitState).assertFalse();
        const isAnyState = rive.Napi_LayerState_cppIsAnyState(layerStatePtr);
        expect(isAnyState).assertFalse();
        const isEntryState = rive.Napi_LayerState_cppIsEntryState(layerStatePtr);
        expect(isEntryState).assertFalse();
        const isAnimationState = rive.Napi_LayerState_cppIsAnimationState(layerStatePtr);
        expect(isAnimationState).assertTrue();
        const isBlendState = rive.Napi_LayerState_cppIsBlendState(layerStatePtr);
        expect(isBlendState).assertFalse();
        const isBlend1DState = rive.Napi_LayerState_cppIsBlendState1D(layerStatePtr);
        expect(isBlend1DState).assertFalse();
        const isBlendDirectState = rive.Napi_LayerState_cppIsBlendStateDirect(layerStatePtr);
        expect(isBlendDirectState).assertFalse();
        const animationName = rive.Napi_AnimationState_cppName(layerStatePtr);
        expect(animationName == 'Unknown').assertTrue();
      }
      rive.Napi_File_cppDelete(filePtr);
      done();
    })

  });
}
