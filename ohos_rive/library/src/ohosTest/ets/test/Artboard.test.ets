import { hilog } from '@kit.PerformanceAnalysisKit';
import AbilityDelegatorRegistry from '@ohos.app.ability.abilityDelegatorRegistry'
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect } from '@ohos/hypium';
import rive from 'libohos_rive.so'
import { common } from '@kit.AbilityKit';
import { FileAsset } from '../../../main/ets/runtime/core/FileAsset';
import { FallbackAssetLoader } from '../../../main/ets/runtime/core/FileAssetLoader';

const DOMAIN = 0x0000;
const TAG = 'RiveTest';

function getContext(): Context {
  let abilityDelegator = AbilityDelegatorRegistry.getAbilityDelegator();
  let context = abilityDelegator.getAppContext();
  return context;
}

export default function artboardTest() {
  rive.Napi_Rive_cppInitialize();
  describe('ArtboardTest', () => {
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

    it('Artboard_Test_cppGetName', 0, async (done: Function) => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      hilog.info(0x0000, 'testTag', '%{public}s', 'it begin');
      let context = getContext();
      const resourceManager = context.resourceManager;
      const rawFile = await resourceManager.getRawFileContent('artboard_animations.riv');
      expect(rawFile.byteLength != 0).assertTrue();

      const arrayBuffer = rawFile.buffer.slice(0);

      let fileAssetLoader: FallbackAssetLoader = new FallbackAssetLoader(context, true, null);
      expect(fileAssetLoader != null).assertTrue();
      let filePtr = rive.Napi_File_import(arrayBuffer, rive.RendererType.Rive, fileAssetLoader.getNativePtr());
      expect(filePtr != 0).assertTrue();

      const firstName = rive.Napi_File_cppArtboardNameByIndex(filePtr, 0);
      expect(firstName == 'Square').assertTrue();

      const artboardInstance = rive.Napi_File_cppArtboardByName(filePtr, firstName);
      expect(artboardInstance != 0).assertTrue();

      const name = rive.Napi_Artboard_cppName(artboardInstance);
      expect(name == 'Square').assertTrue();

      const animationName = rive.Napi_Artboard_animationNameByIndex(artboardInstance, 0);
      expect(animationName == 'rollaround').assertTrue();

      rive.Napi_Artboard_delete(artboardInstance);
      done();
    })

    it('Artboard_Test_Animation', 0, async (done: Function) => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      hilog.info(0x0000, 'testTag', '%{public}s', 'it begin');
      let context = getContext();
      const resourceManager = context.resourceManager;
      const rawFile = await resourceManager.getRawFileContent('artboard_animations.riv');
      expect(rawFile.byteLength != 0).assertTrue();

      const arrayBuffer = rawFile.buffer.slice(0);

      let fileAssetLoader: FallbackAssetLoader = new FallbackAssetLoader(context, true, null);
      expect(fileAssetLoader != null).assertTrue();
      let filePtr = rive.Napi_File_import(arrayBuffer, rive.RendererType.Rive, fileAssetLoader.getNativePtr());
      expect(filePtr != 0).assertTrue();

      const firstName = rive.Napi_File_cppArtboardNameByIndex(filePtr, 0);
      expect(firstName == 'Square').assertTrue();

      const artboardInstance = rive.Napi_File_cppArtboardByName(filePtr, firstName);
      expect(artboardInstance != 0).assertTrue();

      const animationByIndex = rive.Napi_Artboard_animationByIndex(artboardInstance, 0);
      expect(animationByIndex != 0).assertTrue();

      const animationByName = rive.Napi_Artboard_animationByName(artboardInstance, 'rollaround');
      expect(animationByName != 0).assertTrue();

      const animationCount = rive.Napi_Artboard_animationCount(artboardInstance);
      expect(animationCount == 2).assertTrue();

      rive.Napi_Artboard_delete(artboardInstance);
      done();
    })


    it('Artboard_Test_StateMachine', 0, async (done: Function) => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      hilog.info(0x0000, 'testTag', '%{public}s', 'it begin');
      let context = getContext();
      const resourceManager = context.resourceManager;
      const rawFile = await resourceManager.getRawFileContent('runtime_nested_inputs.riv');
      expect(rawFile.byteLength != 0).assertTrue();

      const arrayBuffer = rawFile.buffer.slice(0);

      let fileAssetLoader: FallbackAssetLoader = new FallbackAssetLoader(context, true, null);
      expect(fileAssetLoader != null).assertTrue();
      let filePtr = rive.Napi_File_import(arrayBuffer, rive.RendererType.Rive, fileAssetLoader.getNativePtr());
      expect(filePtr != 0).assertTrue();

      const artboardInstance = rive.Napi_File_cppArtboardByName(filePtr, 'MainArtboard');
      expect(artboardInstance != 0).assertTrue();

      const staMachineByIndex = rive.Napi_Artboard_stateMachineByIndex(artboardInstance, 0);
      expect(staMachineByIndex != 0).assertTrue();

      const staMachineName = rive.Napi_Artboard_stateMachineNameByIndex(artboardInstance, 0);
      expect(staMachineName == 'MainStateMachine').assertTrue();

      const staMachineByName = rive.Napi_Artboard_stateMachineByName(artboardInstance, 'MainStateMachine');
      expect(staMachineByName != 0).assertTrue();

      const stateMachineCount = rive.Napi_Artboard_stateMachineCount(artboardInstance);
      expect(stateMachineCount == 1).assertTrue();

      rive.Napi_Artboard_delete(artboardInstance);
      done();
    })

    it('Artboard_Test_InputByNameAtPath', 0, async (done: Function) => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      hilog.info(0x0000, 'testTag', '%{public}s', 'it begin');
      let context = getContext();
      const resourceManager = context.resourceManager;
      const rawFile = await resourceManager.getRawFileContent('runtime_nested_inputs.riv');
      expect(rawFile.byteLength != 0).assertTrue();

      const arrayBuffer = rawFile.buffer.slice(0);

      let fileAssetLoader: FallbackAssetLoader = new FallbackAssetLoader(context, true, null);
      expect(fileAssetLoader != null).assertTrue();
      let filePtr = rive.Napi_File_import(arrayBuffer, rive.RendererType.Rive, fileAssetLoader.getNativePtr());
      expect(filePtr != 0).assertTrue();

      const artboardInstance = rive.Napi_File_cppArtboardByName(filePtr, 'MainArtboard');
      expect(artboardInstance != 0).assertTrue();

      const input = rive.Napi_Artboard_inputByNameAtPath(artboardInstance, "CircleOuterState", "CircleOuter");
      expect(input != 0).assertTrue();

      rive.Napi_Artboard_delete(artboardInstance);
      done();
    })

    it('Artboard_Test_Volume', 0, async (done: Function) => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      hilog.info(0x0000, 'testTag', '%{public}s', 'it begin');
      let context = getContext();
      const resourceManager = context.resourceManager;
      const rawFile = await resourceManager.getRawFileContent('runtime_nested_inputs.riv');
      expect(rawFile.byteLength != 0).assertTrue();

      const arrayBuffer = rawFile.buffer.slice(0);

      let fileAssetLoader: FallbackAssetLoader = new FallbackAssetLoader(context, true, null);
      expect(fileAssetLoader != null).assertTrue();
      let filePtr = rive.Napi_File_import(arrayBuffer, rive.RendererType.Rive, fileAssetLoader.getNativePtr());
      expect(filePtr != 0).assertTrue();

      const artboardInstance = rive.Napi_File_cppArtboardByName(filePtr, 'MainArtboard');
      expect(artboardInstance != 0).assertTrue();

      rive.Napi_Artboard_setVolume(artboardInstance, 66);

      const volume = rive.Napi_Artboard_getVolume(artboardInstance);
      expect(volume == 66).assertTrue();

      rive.Napi_Artboard_delete(artboardInstance);
      done();
    })

    it('Artboard_Test_TextValueRun', 0, async (done: Function) => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      hilog.info(0x0000, 'testTag', '%{public}s', 'it begin');
      let context = getContext();
      const resourceManager = context.resourceManager;
      const rawFile = await resourceManager.getRawFileContent('data_binding_test.riv');
      expect(rawFile.byteLength != 0).assertTrue();

      const arrayBuffer = rawFile.buffer.slice(0);

      let fileAssetLoader: FallbackAssetLoader = new FallbackAssetLoader(context, true, null);
      expect(fileAssetLoader != null).assertTrue();
      rive.Napi_FileAssetLoader_cppSetRendererType(fileAssetLoader.getNativePtr(), rive.RendererType.Rive);
      let filePtr = rive.Napi_File_import(arrayBuffer, rive.RendererType.Rive, fileAssetLoader.getNativePtr());
      expect(filePtr != 0).assertTrue();

      const artboardInstance = rive.Napi_File_cppArtboardByName(filePtr, 'artboard-1');
      expect(artboardInstance != 0).assertTrue();

      const runObj = rive.Napi_Artboard_findTextValueRun(artboardInstance, 'bound_text_run');
      expect(runObj != 0).assertTrue();

      const text = rive.Napi_Artboard_findValueOfTextValueRun(artboardInstance, 'bound_text_run');
      expect(text == 'unbound text').assertTrue();

      rive.Napi_Artboard_setValueOfTextValueRun(artboardInstance, 'bound_text_run', 'new text111');
      const newText = rive.Napi_Artboard_findValueOfTextValueRun(artboardInstance, 'bound_text_run');
      expect(newText == 'new text111').assertTrue();

      rive.Napi_Artboard_delete(artboardInstance);
      done();
    })

    it('Artboard_Test_TextValueRunAtPath', 0, async (done: Function) => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      hilog.info(0x0000, 'testTag', '%{public}s', 'it begin');
      let context = getContext();
      const resourceManager = context.resourceManager;
      const rawFile = await resourceManager.getRawFileContent('runtime_nested_text_runs.riv');
      expect(rawFile.byteLength != 0).assertTrue();

      const arrayBuffer = rawFile.buffer.slice(0);

      let fileAssetLoader: FallbackAssetLoader = new FallbackAssetLoader(context, true, null);
      expect(fileAssetLoader != null).assertTrue();
      rive.Napi_FileAssetLoader_cppSetRendererType(fileAssetLoader.getNativePtr(), rive.RendererType.Rive);
      let filePtr = rive.Napi_File_import(arrayBuffer, rive.RendererType.Rive, fileAssetLoader.getNativePtr());
      expect(filePtr != 0).assertTrue();

      const artboardInstance = rive.Napi_File_cppArtboardByName(filePtr, 'ArtboardA');
      expect(artboardInstance != 0).assertTrue();

      const runObj = rive.Napi_Artboard_findTextValueRunAtPath(artboardInstance, 'ArtboardBRun', 'ArtboardB-1');
      expect(runObj != 0).assertTrue();

      const text = rive.Napi_Artboard_findValueOfTextValueRunAtPath(artboardInstance, 'ArtboardBRun', 'ArtboardB-1');
      expect(text == 'Artboard B Run').assertTrue();

      rive.Napi_Artboard_setValueOfTextValueRunAtPath(artboardInstance, 'ArtboardBRun', 'new test run', 'ArtboardB-1');
      const newText = rive.Napi_Artboard_findValueOfTextValueRunAtPath(artboardInstance, 'ArtboardBRun', 'ArtboardB-1');
      expect(newText == 'new test run').assertTrue();

      rive.Napi_Artboard_delete(artboardInstance);
      done();
    })

    it('Artboard_Test_Advance', 0, async (done: Function) => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      hilog.info(0x0000, 'testTag', '%{public}s', 'it begin');
      let context = getContext();
      const resourceManager = context.resourceManager;
      const rawFile = await resourceManager.getRawFileContent('artboard_animations.riv');
      expect(rawFile.byteLength != 0).assertTrue();

      const arrayBuffer = rawFile.buffer.slice(0);

       let fileAssetLoader: FallbackAssetLoader = new FallbackAssetLoader(context, true, null);
       expect(fileAssetLoader != null).assertTrue();
      let filePtr = rive.Napi_File_import(arrayBuffer, rive.RendererType.Rive, fileAssetLoader.getNativePtr());
      expect(filePtr != 0).assertTrue();

      const artboardPtr = rive.Napi_File_cppArtboardByIndex(filePtr, 0);
      expect(artboardPtr != 0).assertTrue();

      let ret = rive.Napi_Artboard_advance(artboardPtr, 0.1);
      expect(ret).assertFalse();

      rive.Napi_Artboard_setArtboardWidth(artboardPtr, 1);
      ret = rive.Napi_Artboard_advance(artboardPtr, 0.1);
      expect(ret).assertTrue();

      ret = rive.Napi_Artboard_advance(null, 0);
      expect(ret).assertFalse();

      ret = rive.Napi_Artboard_advance(0, 0);
      expect(ret).assertFalse();
      done();
    })

    it('Artboard_Test_Bounds', 0, async (done: Function) => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      hilog.info(0x0000, 'testTag', '%{public}s', 'it begin');
      let context = getContext();
      const resourceManager = context.resourceManager;
      const rawFile = await resourceManager.getRawFileContent('artboard_animations.riv');
      expect(rawFile.byteLength != 0).assertTrue();

      const arrayBuffer = rawFile.buffer.slice(0);

      let fileAssetLoader: FallbackAssetLoader = new FallbackAssetLoader(context, true, null);
      expect(fileAssetLoader != null).assertTrue();
      let filePtr = rive.Napi_File_import(arrayBuffer, rive.RendererType.Rive, fileAssetLoader.getNativePtr());
      expect(filePtr != 0).assertTrue();

      const artboardPtr = rive.Napi_File_cppArtboardByIndex(filePtr, 0);
      expect(artboardPtr != 0).assertTrue();

      let bounds = rive.Napi_Artboard_bounds(artboardPtr);
      expect(bounds != null).assertTrue();
      expect(bounds.left).assertEqual(0);
      expect(bounds.right).assertEqual(500);
      expect(bounds.top).assertEqual(0);
      expect(bounds.bottom).assertEqual(500);

      bounds = rive.Napi_Artboard_bounds(null);
      expect(bounds == null).assertTrue();

      bounds = rive.Napi_Artboard_bounds(0);
      expect(bounds == null).assertTrue();
      done();
    })

    it('Artboard_Test_ResetArtboardSize', 0, async (done: Function) => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      hilog.info(0x0000, 'testTag', '%{public}s', 'it begin');
      let context = getContext();
      const resourceManager = context.resourceManager;
      const rawFile = await resourceManager.getRawFileContent('artboard_animations.riv');
      expect(rawFile.byteLength != 0).assertTrue();

      const arrayBuffer = rawFile.buffer.slice(0);

      let fileAssetLoader: FallbackAssetLoader = new FallbackAssetLoader(context, true, null);
      expect(fileAssetLoader != null).assertTrue();
      let filePtr = rive.Napi_File_import(arrayBuffer, rive.RendererType.Rive, fileAssetLoader.getNativePtr());
      expect(filePtr != 0).assertTrue();

      const artboardPtr = rive.Napi_File_cppArtboardByIndex(filePtr, 0);
      expect(artboardPtr != 0).assertTrue();

      let bounds = rive.Napi_Artboard_bounds(artboardPtr);
      expect(bounds != null).assertTrue();
      expect(bounds.left == 0).assertTrue();
      expect(bounds.right == 500).assertTrue();
      expect(bounds.top == 0).assertTrue();
      expect(bounds.bottom == 500).assertTrue();

      let ret = rive.Napi_Artboard_setArtboardWidth(artboardPtr, 1);
      expect(ret == undefined).assertTrue();
      let width = rive.Napi_Artboard_getArtboardWidth(artboardPtr);
      expect(width == 1).assertTrue();
      ret = rive.Napi_Artboard_setArtboardHeight(artboardPtr, 10);
      expect(ret == undefined).assertTrue();
      let height = rive.Napi_Artboard_getArtboardHeight(artboardPtr);
      expect(height == 10).assertTrue();

      bounds = rive.Napi_Artboard_bounds(artboardPtr);
      expect(bounds != null).assertTrue();
      expect(bounds.left).assertEqual(0);
      expect(bounds.right).assertEqual(1);
      expect(bounds.top).assertEqual(0);
      expect(bounds.bottom).assertEqual(10);

      ret = rive.Napi_Artboard_resetArtboardSize(artboardPtr);
      expect(ret == undefined).assertTrue();

      bounds = rive.Napi_Artboard_bounds(artboardPtr);
      expect(bounds != null).assertTrue();
      expect(bounds.left).assertEqual(0);
      expect(bounds.right).assertEqual(500);
      expect(bounds.top).assertEqual(0);
      expect(bounds.bottom).assertEqual(500);
      done();
    })

    it('Artboard_Test_Width', 0, async (done: Function) => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      hilog.info(0x0000, 'testTag', '%{public}s', 'it begin');
      let context = getContext();
      const resourceManager = context.resourceManager;
      const rawFile = await resourceManager.getRawFileContent('artboard_animations.riv');
      expect(rawFile.byteLength != 0).assertTrue();

      const arrayBuffer = rawFile.buffer.slice(0);

      let fileAssetLoader: FallbackAssetLoader = new FallbackAssetLoader(context, true, null);
      expect(fileAssetLoader != null).assertTrue();
      let filePtr = rive.Napi_File_import(arrayBuffer, rive.RendererType.Rive, fileAssetLoader.getNativePtr());
      expect(filePtr != 0).assertTrue();

      const artboardPtr = rive.Napi_File_cppArtboardByIndex(filePtr, 0);
      expect(artboardPtr != 0).assertTrue();

      let ret = rive.Napi_Artboard_setArtboardWidth(artboardPtr, 1);
      expect(ret == undefined).assertTrue();
      let width = rive.Napi_Artboard_getArtboardWidth(artboardPtr);
      expect(width).assertEqual(1);

      ret = rive.Napi_Artboard_setArtboardWidth(artboardPtr, null);
      expect(ret == null).assertTrue();

      ret = rive.Napi_Artboard_setArtboardWidth(artboardPtr, -1);
      expect(ret == null).assertTrue();

      ret = rive.Napi_Artboard_setArtboardWidth(null, 1);
      expect(ret == null).assertTrue();
      done();
    })

    it('Artboard_Test_Height', 0, async (done: Function) => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      hilog.info(0x0000, 'testTag', '%{public}s', 'it begin');
      let context = getContext();
      const resourceManager = context.resourceManager;
      const rawFile = await resourceManager.getRawFileContent('artboard_animations.riv');
      expect(rawFile.byteLength != 0).assertTrue();

      const arrayBuffer = rawFile.buffer.slice(0);

      let fileAssetLoader: FallbackAssetLoader = new FallbackAssetLoader(context, true, null);
      expect(fileAssetLoader != null).assertTrue();
      let filePtr = rive.Napi_File_import(arrayBuffer, rive.RendererType.Rive, fileAssetLoader.getNativePtr());
      expect(filePtr != 0).assertTrue();

      const artboardPtr = rive.Napi_File_cppArtboardByIndex(filePtr, 0);
      expect(artboardPtr != 0).assertTrue();

      let ret = rive.Napi_Artboard_setArtboardHeight(artboardPtr, 10);
      expect(ret == undefined).assertTrue();

      let height = rive.Napi_Artboard_getArtboardHeight(artboardPtr);
      expect(height).assertEqual(10);

      ret = rive.Napi_Artboard_setArtboardHeight(artboardPtr, null);
      expect(ret == null).assertTrue();

      ret = rive.Napi_Artboard_setArtboardHeight(artboardPtr, -1);
      expect(ret == null).assertTrue();

      ret = rive.Napi_Artboard_setArtboardHeight(null, 1);
      expect(ret == null).assertTrue();
      rive.Napi_Artboard_delete(artboardPtr);
      done();
    })

    it('Artboard_Test_SetViewModelInstance', 0, async (done: Function) => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      hilog.info(0x0000, 'testTag', '%{public}s', 'it begin');
      let context = getContext();
      const resourceManager = context.resourceManager;
      const rawFile = await resourceManager.getRawFileContent('viewmodel_runtime_file.riv');
      expect(rawFile.byteLength != 0).assertTrue();

      const arrayBuffer = rawFile.buffer.slice(0);

      let fileAssetLoader: FallbackAssetLoader = new FallbackAssetLoader(context, true, null);
      expect(fileAssetLoader != null).assertTrue();
      let filePtr = rive.Napi_File_import(arrayBuffer, rive.RendererType.Rive, fileAssetLoader.getNativePtr());
      expect(filePtr != 0).assertTrue();

      const artboardPtr = rive.Napi_File_cppArtboardByIndex(filePtr, 0);
      expect(artboardPtr != 0).assertTrue();

      const viewModelPtr = rive.Napi_File_cppViewModelByIndex(filePtr, 0);
      expect(viewModelPtr != 0).assertTrue();

      const defaultInstance = rive.Napi_ViewModel_createDefaultInstance(viewModelPtr);
      expect(defaultInstance != 0).assertTrue();

      let ret = rive.Napi_Artboard_setViewModelInstance(artboardPtr, defaultInstance);
      expect(ret == undefined).assertTrue();

      ret = rive.Napi_Artboard_setViewModelInstance(null, viewModelPtr);
      expect(ret == null).assertTrue();

      ret = rive.Napi_Artboard_setViewModelInstance(artboardPtr, null);
      expect(ret == null).assertTrue();

      ret = rive.Napi_Artboard_setViewModelInstance(0, viewModelPtr);
      expect(ret == null).assertTrue();

      ret = rive.Napi_Artboard_setViewModelInstance(artboardPtr, 0);
      expect(ret == null).assertTrue();

      rive.Napi_Artboard_delete(artboardPtr);
      done();
    })
    
    it('Artboard_Test_Delete', 0, async (done: Function) => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      hilog.info(0x0000, 'testTag', '%{public}s', 'it begin');
      let context = getContext();
      const resourceManager = context.resourceManager;
      const rawFile = await resourceManager.getRawFileContent('artboard_animations.riv');
      expect(rawFile.byteLength != 0).assertTrue();

      const arrayBuffer = rawFile.buffer.slice(0);

      let fileAssetLoader: FallbackAssetLoader = new FallbackAssetLoader(context, true, null);
      expect(fileAssetLoader != null).assertTrue();
      let filePtr = rive.Napi_File_import(arrayBuffer, rive.RendererType.Rive, fileAssetLoader.getNativePtr());
      expect(filePtr != 0).assertTrue();

      const artboardPtr = rive.Napi_File_cppArtboardByIndex(filePtr, 0);
      expect(artboardPtr != 0).assertTrue();
      let ret = rive.Napi_Artboard_delete(artboardPtr);
      expect(ret == undefined).assertTrue();

      ret = rive.Napi_Artboard_delete(null);
      expect(ret == null).assertTrue();

      ret = rive.Napi_Artboard_delete(0);
      expect(ret == null).assertTrue();
      done();
    })
  })
}