import { hilog } from '@kit.PerformanceAnalysisKit';
import AbilityDelegatorRegistry from '@ohos.app.ability.abilityDelegatorRegistry'
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect } from '@ohos/hypium';
import rive from 'libohos_rive.so'
import { RiveEvent } from '../../../main/ets/runtime/core/RiveEvent'
import { RiveEventReport } from '../../../main/ets/runtime/core/RiveEventReport'
import { common } from '@kit.AbilityKit';
import { FallbackAssetLoader } from '../../../main/ets/runtime/core/FileAssetLoader';

const DOMAIN = 0x0000;
const TAG = 'RiveTest';

function getContext(): Context {
  let abilityDelegator = AbilityDelegatorRegistry.getAbilityDelegator();
  let context = abilityDelegator.getAppContext();
  return context;
}

export default function stateMachineTest() {
  describe('StateMachineTest', () => {
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

    it('StateMachine_Test_Advance', 0, async (done: Function) => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      hilog.info(0x0000, 'testTag', '%{public}s', 'it begin');
      let context = getContext();
      const resourceManager = context.resourceManager;
      const rawFile = await resourceManager.getRawFileContent('multiple_state_machines.riv');
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

      const elapsedTime1 = 0.016; // 约16ms，相当于60fps的一帧
      const result1 = rive.Napi_StateMachine_cppAdvance(stateMachineInstanceRef, elapsedTime1);
      expect(result1 == true).assertTrue();

      const elapsedTime2 = 0.0;
      const result2 = rive.Napi_StateMachine_cppAdvance(stateMachineInstanceRef, elapsedTime2);
      expect(result2 == true).assertTrue();

      const elapsedTime3 = 1.0; // 1秒
      const result3 = rive.Napi_StateMachine_cppAdvance(stateMachineInstanceRef, elapsedTime3);
      expect(result3 == true).assertTrue();

      done();
    })

    it('StateMachine_Test_BasicInfo', 0, async (done: Function) => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      hilog.info(0x0000, 'testTag', '%{public}s', 'it begin');
      let context = getContext();
      const resourceManager = context.resourceManager;
      const rawFile = await resourceManager.getRawFileContent('multiple_state_machines.riv');
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

      const count = rive.Napi_StateMachine_cppStateChangedCount(stateMachineInstanceRef);
      expect(count == 0).assertTrue();

      const statePtr = rive.Napi_StateMachine_cppStateChangedByIndex(stateMachineInstanceRef, 0);
      expect(statePtr == 0).assertTrue();

      const rptEventCount = rive.Napi_StateMachine_cppReportedEventCount(stateMachineInstanceRef);
      expect(rptEventCount == 0).assertTrue();

      const stateMachineName = rive.Napi_StateMachine_cppName(stateMachineInstanceRef);
      expect(stateMachineName == 'four').assertTrue();

      const layerCount = rive.Napi_StateMachine_cppLayerCount(stateMachineInstanceRef);
      expect(layerCount == 1).assertTrue();

      const inputCount = rive.Napi_StateMachine_cppInputCount(stateMachineInstanceRef);
      expect(inputCount == 0).assertTrue();

      const smiInput = rive.Napi_StateMachine_cppSMIInputByIndex(stateMachineInstanceRef, 0);
      expect(smiInput == 0).assertTrue();

      done();
    })

    it('StateMachine_Test_SMIInput', 0, async (done: Function) => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      hilog.info(0x0000, 'testTag', '%{public}s', 'it begin');
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

      const stateMachineCount = rive.Napi_Artboard_stateMachineCount(artboardPtr);
      expect(stateMachineCount == 1).assertTrue();

      const stateMachineInstanceRef = rive.Napi_Artboard_stateMachineByIndex(artboardPtr, 0);
      expect(stateMachineInstanceRef != 0).assertTrue();

      const inputCount = rive.Napi_StateMachine_cppInputCount(stateMachineInstanceRef);
      expect(inputCount == 1).assertTrue();

      const smiInput = rive.Napi_StateMachine_cppSMIInputByIndex(stateMachineInstanceRef, 0);
      expect(smiInput != 0).assertTrue();

      done();
    })

    it('StateMachine_Test_ReportEventCount_Click', 0, async (done: Function) => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      hilog.info(0x0000, 'testTag', '%{public}s', 'it begin');
      let context = getContext();
      const resourceManager = context.resourceManager;
      const rawFile = await resourceManager.getRawFileContent('event_on_listener.riv');
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

      const stateMachineCount = rive.Napi_Artboard_stateMachineCount(artboardPtr);
      expect(stateMachineCount == 1).assertTrue();

      const stateMachineInstanceRef = rive.Napi_Artboard_stateMachineByIndex(artboardPtr, 0);
      expect(stateMachineInstanceRef != 0).assertTrue();

      const count = rive.Napi_StateMachine_cppReportedEventCount(stateMachineInstanceRef);
      expect(count == 0).assertTrue();

      rive.Napi_Rive_cppRegisterClass(RiveEventReport);
      rive.Napi_Rive_cppRegisterClass(RiveEvent);

      rive.Napi_StateMachine_cppPointerDown(stateMachineInstanceRef, 0, 343.0, 116.0);
      rive.Napi_StateMachine_cppPointerUp(stateMachineInstanceRef, 0, 343.0, 116.0);

      const count1 = rive.Napi_StateMachine_cppReportedEventCount(stateMachineInstanceRef);
      expect(count1 == 2).assertTrue();

      const eventRpt = rive.Napi_StateMachine_cppReportedEventAt(stateMachineInstanceRef, 0) as RiveEventReport;
      const event = eventRpt.event;
      expect(event.name == 'Footstep').assertTrue();

      rive.Napi_StateMachine_cppAdvance(stateMachineInstanceRef, 0.0);
      const count2 = rive.Napi_StateMachine_cppReportedEventCount(stateMachineInstanceRef);
      expect(count2 == 0).assertTrue();

      rive.Napi_Rive_cppUnregisterClass(RiveEventReport);
      rive.Napi_Rive_cppUnregisterClass(RiveEvent);
      done();
    })

    it('StateMachine_Test_State_Change', 0, async (done: Function) => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      hilog.info(0x0000, 'testTag', '%{public}s', 'it begin');
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
      hilog.error(DOMAIN, TAG, `firstName ${firstName}`);
      expect(firstName == 'New Artboard').assertTrue();

      const artboardPtr = rive.Napi_File_cppArtboardByName(filePtr, firstName);
      expect(artboardPtr != 0).assertTrue();

      const stateMachineCount = rive.Napi_Artboard_stateMachineCount(artboardPtr);
      hilog.error(DOMAIN, TAG, `state machine count ${stateMachineCount}`);

      const stateMachineInstanceRef = rive.Napi_Artboard_stateMachineByIndex(artboardPtr, 0);
      expect(stateMachineInstanceRef != 0).assertTrue();

      const count0 = rive.Napi_StateMachine_cppStateChangedCount(stateMachineInstanceRef);
      expect(count0 == 0).assertTrue();

      rive.Napi_StateMachine_cppAdvance(stateMachineInstanceRef, 0.5);

      const count = rive.Napi_StateMachine_cppStateChangedCount(stateMachineInstanceRef);
      expect(count == 1).assertTrue();

      const statePtr = rive.Napi_StateMachine_cppStateChangedByIndex(stateMachineInstanceRef, 0);
      expect(statePtr != 0).assertTrue();

      done();
    })

    it('StateMachine_Test_Pointer_Change', 0, async (done: Function) => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      hilog.info(0x0000, 'testTag', '%{public}s', 'it begin');
      let context = getContext();
      const resourceManager = context.resourceManager;
      const rawFile = await resourceManager.getRawFileContent('multiple_state_machines.riv');
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

      rive.Napi_StateMachine_cppPointerDown(stateMachineInstanceRef, 0, 30, 20);
      rive.Napi_StateMachine_cppPointerUp(stateMachineInstanceRef, 0, 30, 20);
      rive.Napi_StateMachine_cppPointerMove(stateMachineInstanceRef, 0, 30, 20);
      rive.Napi_StateMachine_cppPointerExit(stateMachineInstanceRef, 0, 30, 20);

      done();
    })

    it('StateMachine_Test_SetViewModelInstance', 0, async (done: Function) => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      hilog.info(0x0000, 'testTag', '%{public}s', 'it begin');
      let context = getContext();
      const resourceManager = context.resourceManager;
      const rawFile = await resourceManager.getRawFileContent('target_event.riv');
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

      const stateMachineCount = rive.Napi_Artboard_stateMachineCount(artboardPtr);
      expect(stateMachineCount == 1).assertTrue();

      const stateMachineInstanceRef = rive.Napi_Artboard_stateMachineByIndex(artboardPtr, 0);
      expect(stateMachineInstanceRef != 0).assertTrue();

      const viewModelCount = rive.Napi_File_cppViewModelCount(filePtr);
      expect(viewModelCount == 1).assertTrue();

      const viewModelPtr = rive.Napi_File_cppViewModelByIndex(filePtr, 0);
      expect(viewModelPtr != 0).assertTrue();

      const viewModelRuntimeInstance = rive.Napi_ViewModel_createDefaultInstance(viewModelPtr);
      expect(viewModelRuntimeInstance != 0).assertTrue();
      rive.Napi_StateMachine_cppSetViewModelInstance(stateMachineInstanceRef, viewModelRuntimeInstance);
      rive.Napi_StateMachine_cppDelete(stateMachineInstanceRef);

      done();
    })
  })
}