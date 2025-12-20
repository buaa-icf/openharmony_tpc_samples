import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect } from '@ohos/hypium';
import artboardTest from './Artboard.test';
import convertToArtboardSpaceTest from './BindingsHelperAbility.test';
import bindingsLayerStateTest from './BindingsLayerState.test';
import commandQueueTest from './CommandQueue.test';
import riveFileTest from './File.test';
import linearAnimationInstanceTest from './LinearAnimationInstance.test';
import riveEventTest from './RiveEvent.test';
import smiInputTest from './SMIInput.test';
import stateMachineTest from './StateMachine.test';
import textValueRunTest from './TextValueRun.test';
import viewModelTest from './ViewModel.test';
import viewModelInstanceTest from './ViewModelInstance.test';

export default function riveAllTest() {
  describe('RiveAllTest', () => {
    it('main_test_entry', 0, () => {
      expect(true).assertTrue();
    });
    bindingsLayerStateTest();
    convertToArtboardSpaceTest();
    stateMachineTest();
    smiInputTest()
    artboardTest();
    viewModelTest();
    viewModelInstanceTest();
    linearAnimationInstanceTest();
    textValueRunTest();
    riveEventTest();
    commandQueueTest();
    riveFileTest();
  })
}