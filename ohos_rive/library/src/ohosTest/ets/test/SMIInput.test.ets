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

export default function smiInputTest() {
  describe('SMIInputTest', () => {
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

    it('SMIInput_Test_Bool', 0, async (done: Function) => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      hilog.info(DOMAIN, TAG, '%{public}s', 'it begin');
      let context = getContext();
      const resourceManager = context.resourceManager;
      const rawFile = await resourceManager.getRawFileContent('rocket.riv');
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

      const stateMachineInstanceRef = rive.Napi_Artboard_stateMachineByIndex(artboardPtr, 0);
      expect(stateMachineInstanceRef != 0).assertTrue();

      const inputCount = rive.Napi_StateMachine_cppInputCount(stateMachineInstanceRef);
      expect(inputCount == 2).assertTrue();

      const input = rive.Napi_StateMachine_cppSMIInputByIndex(stateMachineInstanceRef, 0);
      expect(input != 0).assertTrue();

      const inputName = rive.Napi_SMI_cppSMIInputName(input);
      expect(inputName == 'Hover').assertTrue();

      const isBool = rive.Napi_SMI_cppSMIInputIsBoolean(input);
      expect(isBool == true).assertTrue();

      const value = rive.Napi_SMI_cppSMIBoolValue(input);
      expect(value == false).assertTrue();

      rive.Napi_SMI_cppSMIBoolSetValue(input, true);
      expect(rive.Napi_SMI_cppSMIBoolValue(input) == true).assertTrue();

      done();
    })

    it('SMIInput_Test_Number', 0, async (done: Function) => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      hilog.info(DOMAIN, TAG, '%{public}s', 'it begin');
      let context = getContext();
      const resourceManager = context.resourceManager;
      const rawFile = await resourceManager.getRawFileContent('smi_test.riv');
      expect(rawFile.byteLength != 0).assertTrue();

      const arrayBuffer = rawFile.buffer.slice(0);

      let fileAssetLoader: FallbackAssetLoader = new FallbackAssetLoader(context, true, null);
      expect(fileAssetLoader != null).assertTrue();
      let filePtr = rive.Napi_File_import(arrayBuffer, rive.RendererType.Rive, fileAssetLoader.getNativePtr());
      expect(filePtr != 0).assertTrue();

      const artboardPtr = rive.Napi_File_cppArtboardByName(filePtr, 'artboard to nest');
      expect(artboardPtr != 0).assertTrue();

      const stateMachineInstanceRef = rive.Napi_Artboard_stateMachineByIndex(artboardPtr, 0);
      expect(stateMachineInstanceRef != 0).assertTrue();

      const inputCount = rive.Napi_StateMachine_cppInputCount(stateMachineInstanceRef);
      expect(inputCount == 3).assertTrue();

      const input = rive.Napi_StateMachine_cppSMIInputByIndex(stateMachineInstanceRef, 2);
      expect(input != 0).assertTrue();

      const inputName = rive.Napi_SMI_cppSMIInputName(input);
      expect(inputName == 'num').assertTrue();

      const isNumber = rive.Napi_SMI_cppSMIInputIsNumber(input);
      expect(isNumber == true).assertTrue();

      const value = rive.Napi_SMI_cppSMINumberValue(input);
      expect(value == 0).assertTrue();

      rive.Napi_SMI_cppSMINumberSetValue(input, 20);
      expect(rive.Napi_SMI_cppSMINumberValue(input) == 20).assertTrue();

      done();
    })

    it('SMIInput_Test_Trigger', 0, async (done: Function) => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      hilog.info(DOMAIN, TAG, '%{public}s', 'it begin');
      let context = getContext();
      const resourceManager = context.resourceManager;
      const rawFile = await resourceManager.getRawFileContent('state_machine_triggers.riv');
      expect(rawFile.byteLength != 0).assertTrue();

      const arrayBuffer = rawFile.buffer.slice(0);

      let fileAssetLoader: FallbackAssetLoader = new FallbackAssetLoader(context, true, null);
      expect(fileAssetLoader != null).assertTrue();
      let filePtr = rive.Napi_File_import(arrayBuffer, rive.RendererType.Rive, fileAssetLoader.getNativePtr());
      expect(filePtr != 0).assertTrue();

      const firstName = rive.Napi_File_cppArtboardNameByIndex(filePtr, 0);
      expect(firstName == 'main').assertTrue();

      const artboardPtr = rive.Napi_File_cppArtboardByName(filePtr, firstName);
      expect(artboardPtr != 0).assertTrue();

      const stateMachineInstanceRef = rive.Napi_Artboard_stateMachineByIndex(artboardPtr, 0);
      expect(stateMachineInstanceRef != 0).assertTrue();

      const inputCount = rive.Napi_StateMachine_cppInputCount(stateMachineInstanceRef);
      expect(inputCount == 1).assertTrue();

      const input = rive.Napi_StateMachine_cppSMIInputByIndex(stateMachineInstanceRef, 0);
      expect(input != 0).assertTrue();

      const inputName = rive.Napi_SMI_cppSMIInputName(input);
      expect(inputName == 'Trigger 1').assertTrue();

      const isTrigger = rive.Napi_SMI_cppSMIInputIsTrigger(input);
      expect(isTrigger == true).assertTrue();

      rive.Napi_SMI_cppSMITriggerFire(input);

      done();
    })
  })
}