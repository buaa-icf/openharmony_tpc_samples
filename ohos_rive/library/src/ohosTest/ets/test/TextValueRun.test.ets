import { hilog } from '@kit.PerformanceAnalysisKit';
import AbilityDelegatorRegistry from '@ohos.app.ability.abilityDelegatorRegistry'
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect } from '@ohos/hypium';
import rive from 'libohos_rive.so'
import { common } from '@kit.AbilityKit';
import { FallbackAssetLoader } from '../../../main/ets/runtime/core/FileAssetLoader';

const DOMAIN = 0x0000;
const TAG = 'RiveTest';

function getContext(): Context {
  let abilityDelegator = AbilityDelegatorRegistry.getAbilityDelegator();
  let context = abilityDelegator.getAppContext();
  return context;
}

export default function textValueRunTest() {
  rive.Napi_Rive_cppInitialize();
  describe('TextValueRunTest', () => {
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

    it('TextValueRun_Test_GetSetText', 0, async (done: Function) => {
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

      const runObj= rive.Napi_Artboard_findTextValueRun(artboardInstance, 'bound_text_run');
      expect(runObj != 0).assertTrue();

      const text = rive.Napi_RiveTextValueRun_cppText(runObj);
      expect(text == 'unbound text').assertTrue();

      rive.Napi_RiveTextValueRun_cppSetText(runObj, 'new text111');
      const newText = rive.Napi_RiveTextValueRun_cppText(runObj);
      expect(newText == 'new text111').assertTrue();

      rive.Napi_Artboard_delete(artboardInstance);
      done();
    })

  })
}