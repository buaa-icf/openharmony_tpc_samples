import { hilog } from '@kit.PerformanceAnalysisKit';
import AbilityDelegatorRegistry from '@ohos.app.ability.abilityDelegatorRegistry'
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect } from '@ohos/hypium';
import rive from 'libohos_rive.so'
import { AdvanceResult } from '../../../main/ets/runtime/core/AdvanceResult'
import { FallbackAssetLoader } from '../../../main/ets/runtime/core/FileAssetLoader';
import { Loop } from '../../../main/ets/runtime/core/Loop'

const DOMAIN = 0x0000;
const TAG = 'RiveTest';

function getContext(): Context {
  let abilityDelegator = AbilityDelegatorRegistry.getAbilityDelegator();
  let context = abilityDelegator.getAppContext();
  return context;
}

export default function linearAnimationInstanceTest() {
  describe('LinearAnimationInstanceTest', () => {
    // Defines a test suite. Two parameters are supported: test suite name and test suite function.
    beforeAll(() => {
      // Presets an action, which is performed only once before all test cases of the test suite start.
      // This API supports only one parameter: preset action function.
    })
    beforeEach(() => {
      // Presets an action, which is performed before each unit test case starts.
      // The number of execution times is the same as the number of test cases defined by **it**.
      // This API supports only one parameter: preset action function.
    })
    afterEach(() => {
      // Presets a clear action, which is performed after each unit test case ends.
      // The number of execution times is the same as the number of test cases defined by **it**.
      // This API supports only one parameter: clear action function.
    })
    afterAll(() => {
      // Presets a clear action, which is performed after all test cases of the test suite end.
      // This API supports only one parameter: clear action function.
    })

    it('LinearAnimationInstance_Test_Basic', 0, async (done: Function) => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      hilog.info(DOMAIN, TAG, '%{public}s', 'it begin');
      let context = getContext();
      const resourceManager = context.resourceManager;
      const rawFile = await resourceManager.getRawFileContent('looping_timeline_events.riv');
      expect(rawFile.byteLength != 0).assertTrue();

      const arrayBuffer = rawFile.buffer.slice(0);

      let fileAssetLoader: FallbackAssetLoader = new FallbackAssetLoader(context, true, null);
      expect(fileAssetLoader != null).assertTrue();
      let filePtr = rive.Napi_File_import(arrayBuffer, rive.RendererType.Rive, fileAssetLoader.getNativePtr());
      expect(filePtr != 0).assertTrue();

      const firstName = rive.Napi_File_cppArtboardNameByIndex(filePtr, 0);
      expect(firstName == 'New Artboard').assertTrue();

      const artboardPtr = rive.Napi_File_cppArtboardByName(filePtr, firstName);
      expect(artboardPtr != 0).assertTrue();

      const animationInstance = rive.Napi_Artboard_animationByIndex(artboardPtr, 0);
      expect(animationInstance != 0).assertTrue();

      const animationName = rive.Napi_LinearAnimationInstance_cppName(animationInstance);
      expect(animationName == 'EventAnimation').assertTrue()

      const duration = rive.Napi_LinearAnimationInstance_cppDuration(animationInstance);
      expect(duration == 60).assertTrue();

      const fps = rive.Napi_LinearAnimationInstance_cppFps(animationInstance);
      expect(fps == 60).assertTrue();

      const time = rive.Napi_LinearAnimationInstance_cppGetTime(animationInstance);
      expect(time == 0).assertTrue();

      rive.Napi_LinearAnimationInstance_cppSetTime(animationInstance, 20);
      expect(rive.Napi_LinearAnimationInstance_cppGetTime(animationInstance) == 20).assertTrue();

      rive.Napi_LinearAnimationInstance_cppSetTime(animationInstance, 0);
      expect(rive.Napi_LinearAnimationInstance_cppGetTime(animationInstance) == 0).assertTrue();

      const direction = rive.Napi_LinearAnimationInstance_cppGetDirection(animationInstance);
      expect(direction == 1).assertTrue();

      rive.Napi_LinearAnimationInstance_cppSetDirection(animationInstance, 2);
      expect(rive.Napi_LinearAnimationInstance_cppGetDirection(animationInstance) == 1).assertTrue();

      rive.Napi_LinearAnimationInstance_cppSetDirection(animationInstance, 0);
      expect(rive.Napi_LinearAnimationInstance_cppGetDirection(animationInstance) == -1).assertTrue();

      rive.Napi_LinearAnimationInstance_cppSetDirection(animationInstance, -10);
      expect(rive.Napi_LinearAnimationInstance_cppGetDirection(animationInstance) == -1).assertTrue();

      const loop = rive.Napi_LinearAnimationInstance_cppGetLoop(animationInstance);
      expect(loop == 1).assertTrue();

      rive.Napi_LinearAnimationInstance_cppSetLoop(animationInstance, 3);
      const loop3 = rive.Napi_LinearAnimationInstance_cppGetLoop(animationInstance);
      expect(loop3 == 3).assertTrue();

      const workStart = rive.Napi_LinearAnimationInstance_cppWorkStart(animationInstance);
      expect(workStart == 4294967295).assertTrue();

      const workEnd = rive.Napi_LinearAnimationInstance_cppWorkEnd(animationInstance);
      expect(workEnd == 4294967295).assertTrue();

      rive.Napi_LinearAnimationInstance_cppApply(animationInstance, 0.5);

      rive.Napi_LinearAnimationInstance_cppDelete(animationInstance);
      done();
    })

    it('LinearAnimationInstance_Advance_Test', 0, async (done: Function) => {
      // 1. 加载Rive文件并创建动画实例（与现有测试相同）
      let context = getContext();
      const resourceManager = context.resourceManager;
      const rawFile = await resourceManager.getRawFileContent('looping_timeline_events.riv');
      expect(rawFile.byteLength != 0).assertTrue();

      const arrayBuffer = rawFile.buffer.slice(0);
      let fileAssetLoader: FallbackAssetLoader = new FallbackAssetLoader(context, true, null);
      expect(fileAssetLoader != null).assertTrue();
      let filePtr = rive.Napi_File_import(arrayBuffer, rive.RendererType.Rive, fileAssetLoader.getNativePtr());
      const artboardPtr = rive.Napi_File_cppArtboardByName(filePtr, 'New Artboard');
      const animationInstance = rive.Napi_Artboard_animationByIndex(artboardPtr, 0);

      rive.Napi_Rive_cppRegisterClass(Loop, "Loop");

      const initialTime = rive.Napi_LinearAnimationInstance_cppGetTime(animationInstance);
      expect(initialTime == 0).assertTrue();

      const loopValue = rive.Napi_LinearAnimationInstance_cppAdvance(animationInstance, 1.0);
      expect(loopValue == Loop.LOOP).assertTrue();
      const newTime = rive.Napi_LinearAnimationInstance_cppGetTime(animationInstance);
      expect(newTime == 0).assertTrue();

      const loopValueAdvance = rive.Napi_LinearAnimationInstance_cppAdvance(animationInstance, 0.5);
      expect(loopValueAdvance == undefined).assertTrue();
      const timeAdvanced = rive.Napi_LinearAnimationInstance_cppGetTime(animationInstance);
      expect(timeAdvanced == 0.5).assertTrue();

      rive.Napi_Rive_cppUnregisterClass(Loop, "Loop");
      rive.Napi_LinearAnimationInstance_cppDelete(animationInstance);

      done();
    })

    it('LinearAnimationInstance_AdvanceResult_Test', 0, async (done: Function) => {
      // 1. 加载Rive文件并创建动画实例（与现有测试相同）
      let context = getContext();
      const resourceManager = context.resourceManager;
      const rawFile = await resourceManager.getRawFileContent('looping_timeline_events.riv');
      expect(rawFile.byteLength != 0).assertTrue();

      const arrayBuffer = rawFile.buffer.slice(0);
      let fileAssetLoader: FallbackAssetLoader = new FallbackAssetLoader(context, true, null);
      expect(fileAssetLoader != null).assertTrue();
      let filePtr = rive.Napi_File_import(arrayBuffer, rive.RendererType.Rive, fileAssetLoader.getNativePtr());
      const artboardPtr = rive.Napi_File_cppArtboardByName(filePtr, 'New Artboard');
      const animationInstance = rive.Napi_Artboard_animationByIndex(artboardPtr, 0);

      rive.Napi_Rive_cppRegisterClass(AdvanceResult, "AdvanceResult");

      const initialTime = rive.Napi_LinearAnimationInstance_cppGetTime(animationInstance);
      expect(initialTime == 0).assertTrue();

      const advanceResult = rive.Napi_LinearAnimationInstance_cppAdvanceAndGetResult(animationInstance, 1);
      expect(advanceResult == AdvanceResult.LOOP).assertTrue();
      expect(rive.Napi_LinearAnimationInstance_cppGetTime(animationInstance) == 0).assertTrue();

      const result = rive.Napi_LinearAnimationInstance_cppAdvanceAndGetResult(animationInstance, 0.5);
      expect(result == AdvanceResult.ADVANCED).assertTrue();

      const time = rive.Napi_LinearAnimationInstance_cppGetTime(animationInstance);
      expect(time == 0.5).assertTrue();

      rive.Napi_Rive_cppUnregisterClass(AdvanceResult, "AdvanceResult");
      rive.Napi_LinearAnimationInstance_cppDelete(animationInstance);

      done();
    })
  })
}