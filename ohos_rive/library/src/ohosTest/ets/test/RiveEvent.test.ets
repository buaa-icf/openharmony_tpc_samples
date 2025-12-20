import { hilog } from '@kit.PerformanceAnalysisKit';
import AbilityDelegatorRegistry from '@ohos.app.ability.abilityDelegatorRegistry'
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect } from '@ohos/hypium';
import rive from 'libohos_rive.so'
import { RiveEvent } from '../../../main/ets/runtime/core/RiveEvent'
import { RiveEventReport } from '../../../main/ets/runtime/core/RiveEventReport'
import { FallbackAssetLoader } from '../../../main/ets/runtime/core/FileAssetLoader';

function getContext(): Context {
  let abilityDelegator = AbilityDelegatorRegistry.getAbilityDelegator();
  let context = abilityDelegator.getAppContext();
  return context;
}


export default function riveEventTest() {
  describe('RiveEventTest', () => {
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


    it('RiveEvent_Test', 0, async (done: Function) => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      hilog.info(0x0000, 'testTag', '%{public}s', 'it begin');

      let context = getContext();
      const resourceManager = context.resourceManager;
      const rawFile = await resourceManager.getRawFileContent('events_on_states.riv');
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

      const eventRpt = rive.Napi_StateMachine_cppReportedEventAt(stateMachineInstanceRef, 1) as RiveEventReport;
      const event = eventRpt.event;
      hilog.info(0x0000, 'testTag', 'lxl type = %{public}d, name = %{public}s', event.type, event.name);
      expect(event.name == 'First').assertTrue();
      const eventRptPointer = event.riveEventCppPointer;
      const eventData = rive.Napi_RiveEvent_cppData(eventRptPointer);
      expect(eventData != null).assertTrue();

      const dataName = rive.Napi_RiveEvent_cppName(eventRptPointer);
      expect(dataName != null).assertTrue();

      const dataType = rive.Napi_RiveEvent_cppType(eventRptPointer);
      expect(dataType != null).assertTrue();

      const dataProperties = rive.Napi_RiveEvent_cppProperties(eventRptPointer);
      expect(dataProperties != null).assertTrue();

      const dataTarget = rive.Napi_RiveOpenURLEvent_cppTarget(eventRptPointer);
      expect(dataTarget != null).assertTrue();

      const dataURL = rive.Napi_RiveOpenURLEvent_cppURL(eventRptPointer);
      expect(dataURL != null).assertTrue();

      rive.Napi_Rive_cppUnregisterClass(RiveEventReport);
      rive.Napi_Rive_cppUnregisterClass(RiveEvent);
      done();
    })
  })
}